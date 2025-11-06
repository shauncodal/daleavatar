#!/bin/bash
# Simple Deployment Setup - Uses Git Pull Instead of Bare Repository
# This is simpler if you already have git configured on your server

set -e

APP_DIR="/var/www/daleavatar"
REPO_URL="https://github.com/shauncodal/daleavatar.git"  # Change to your repo
BRANCH="main"  # or your branch name

echo "=========================================="
echo "Setting up simple Git Pull deployment"
echo "=========================================="

# Check if running as root
if [ "$EUID" -ne 0 ]; then 
    echo "Please run as root (use sudo)"
    exit 1
fi

# Install required packages
echo "Installing required packages..."
apt update
apt install -y git apache2 nodejs npm

# Install PM2
npm install -g pm2

# Install Flutter dependencies
apt install -y curl unzip xz-utils zip libglu1-mesa

# Install Flutter
if [ ! -d "/home/ubuntu/flutter" ]; then
    echo "Installing Flutter..."
    cd /home/ubuntu
    git clone https://github.com/flutter/flutter.git -b stable
    chown -R ubuntu:ubuntu /home/ubuntu/flutter
fi

# Create app directory
echo "Setting up application directory..."
mkdir -p "$APP_DIR"
chown -R $SUDO_USER:www-data "$APP_DIR"
chmod -R 755 "$APP_DIR"

# Clone repository
echo "Cloning repository..."
cd "$APP_DIR"
if [ ! -d ".git" ]; then
    git clone "$REPO_URL" .
    git checkout "$BRANCH"
else
    echo "Repository already exists, skipping clone"
fi

# Setup Apache
echo "Configuring Apache..."
cat > /etc/apache2/sites-available/daleavatar.conf << 'APACHE_EOF'
<VirtualHost *:80>
    ServerName dineonext.digitalflux.co.za
    ServerAlias www.dineonext.digitalflux.co.za
    DocumentRoot /var/www/daleavatar/current

    <Directory /var/www/daleavatar/current>
        Options -Indexes +FollowSymLinks
        AllowOverride All
        Require all granted
        
        Header always set Access-Control-Allow-Origin "*"
        Header always set Access-Control-Allow-Methods "GET, POST, PUT, DELETE, OPTIONS"
        Header always set Access-Control-Allow-Headers "Content-Type, Authorization"
    </Directory>

    ProxyPreserveHost On
    ProxyPass /api http://localhost:4000/api
    ProxyPassReverse /api http://localhost:4000/api
    
    ProxyPass /assets http://localhost:4000/assets
    ProxyPassReverse /assets http://localhost:4000/assets

    ErrorLog ${APACHE_LOG_DIR}/daleavatar_error.log
    CustomLog ${APACHE_LOG_DIR}/daleavatar_access.log combined

    Header always set X-Content-Type-Options "nosniff"
    Header always set X-Frame-Options "SAMEORIGIN"
    Header always set X-XSS-Protection "1; mode=block"
</VirtualHost>
APACHE_EOF

# Enable site and modules
a2ensite daleavatar.conf
a2dissite 000-default.conf
a2enmod rewrite headers proxy proxy_http
systemctl reload apache2

# Create deployment script
echo "Creating deployment script..."
cat > /usr/local/bin/deploy-daleavatar << 'DEPLOY_EOF'
#!/bin/bash
cd /var/www/daleavatar
git pull origin main
cd app
export PATH="$PATH:/home/ubuntu/flutter/bin"
flutter pub get
flutter build web --release --dart-define=BACKEND_URL=
sudo mkdir -p /var/www/daleavatar/current
sudo cp -r build/web/* /var/www/daleavatar/current/
if [ -f "docs/deployment/.htaccess" ]; then
    sudo cp docs/deployment/.htaccess /var/www/daleavatar/current/.htaccess
fi
cd ../backend
npm install --production
pm2 restart daleavatar-backend
sudo systemctl reload apache2
echo "Deployment complete!"
DEPLOY_EOF

chmod +x /usr/local/bin/deploy-daleavatar

# Setup environment file
if [ ! -f "$APP_DIR/backend/.env" ]; then
    echo "Creating .env template..."
    cat > "$APP_DIR/backend/.env" << 'ENV_EOF'
PORT=4000
NODE_ENV=production
HEYGEN_API_KEY=your_key_here
OPENAI_API_KEY=your_key_here
MYSQL_DSN=mysql://user:password@localhost:3306/daleavatar
ENV_EOF
    echo "Please edit $APP_DIR/backend/.env with your values"
fi

echo "=========================================="
echo "Setup complete!"
echo "=========================================="
echo ""
echo "To deploy updates, run:"
echo "  sudo deploy-daleavatar"
echo ""
echo "Or manually:"
echo "  cd /var/www/daleavatar"
echo "  git pull"
echo "  ./docs/deployment/simple-deploy.sh"
echo ""
echo "Next steps:"
echo "1. Edit $APP_DIR/backend/.env"
echo "2. Run: sudo deploy-daleavatar"
echo "3. Setup SSL: sudo ./docs/deployment/setup-ssl.sh"

