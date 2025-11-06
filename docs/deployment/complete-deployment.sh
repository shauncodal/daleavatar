#!/bin/bash
# Complete Deployment Script for dineonext.digitalflux.co.za
# This script sets up everything needed for a production deployment

set -e

DOMAIN="dineonext.digitalflux.co.za"
DEPLOY_USER="deploy"

echo "=========================================="
echo "Complete Deployment Setup"
echo "Domain: $DOMAIN"
echo "=========================================="

# Check if running as root
if [ "$EUID" -ne 0 ]; then 
    echo "Please run as root (use sudo)"
    exit 1
fi

# Step 1: Update system
echo ""
echo "Step 1: Updating system..."
apt update && apt upgrade -y

# Step 2: Install Apache
echo ""
echo "Step 2: Installing Apache..."
apt install -y apache2
systemctl enable apache2
systemctl start apache2

# Step 3: Install required Apache modules
echo ""
echo "Step 3: Enabling Apache modules..."
a2enmod rewrite
a2enmod headers
a2enmod ssl
a2enmod proxy
a2enmod proxy_http

# Step 4: Install Node.js
echo ""
echo "Step 4: Installing Node.js..."
curl -fsSL https://deb.nodesource.com/setup_20.x | bash -
apt install -y nodejs

# Step 5: Install PM2
echo ""
echo "Step 5: Installing PM2..."
npm install -g pm2

# Step 6: Install Git
echo ""
echo "Step 6: Installing Git..."
apt install -y git

# Step 7: Install Flutter dependencies
echo ""
echo "Step 7: Installing Flutter dependencies..."
apt install -y curl unzip xz-utils zip libglu1-mesa

# Step 8: Install Flutter
echo ""
echo "Step 8: Installing Flutter..."
if [ ! -d "/home/ubuntu/flutter" ]; then
    cd /home/ubuntu
    git clone https://github.com/flutter/flutter.git -b stable
    chown -R ubuntu:ubuntu /home/ubuntu/flutter
fi

# Step 9: Create deploy user
echo ""
echo "Step 9: Creating deploy user..."
if ! id "$DEPLOY_USER" &>/dev/null; then
    adduser --disabled-password --gecos "" $DEPLOY_USER
    usermod -aG sudo $DEPLOY_USER
fi

# Step 10: Setup directories
echo ""
echo "Step 10: Setting up directories..."
mkdir -p /home/$DEPLOY_USER/app
mkdir -p /home/$DEPLOY_USER/app/releases
mkdir -p /home/$DEPLOY_USER/app/shared
mkdir -p /var/www/daleavatar
chown -R $DEPLOY_USER:$DEPLOY_USER /home/$DEPLOY_USER/app
chown -R $DEPLOY_USER:www-data /var/www/daleavatar
chmod -R 755 /var/www/daleavatar

# Step 11: Setup Apache configuration
echo ""
echo "Step 11: Configuring Apache..."
cat > /etc/apache2/sites-available/daleavatar.conf << 'APACHE_EOF'
<VirtualHost *:80>
    ServerName dineonext.digitalflux.co.za
    ServerAlias www.dineonext.digitalflux.co.za
    DocumentRoot /var/www/daleavatar/current

    <Directory /var/www/daleavatar/current>
        Options -Indexes +FollowSymLinks
        AllowOverride All
        Require all granted
        
        # Enable CORS for API
        Header always set Access-Control-Allow-Origin "*"
        Header always set Access-Control-Allow-Methods "GET, POST, PUT, DELETE, OPTIONS"
        Header always set Access-Control-Allow-Headers "Content-Type, Authorization"
    </Directory>

    # Proxy backend API requests
    ProxyPreserveHost On
    ProxyPass /api http://localhost:4000/api
    ProxyPassReverse /api http://localhost:4000/api
    
    # Proxy backend assets
    ProxyPass /assets http://localhost:4000/assets
    ProxyPassReverse /assets http://localhost:4000/assets

    # Error and access logs
    ErrorLog ${APACHE_LOG_DIR}/daleavatar_error.log
    CustomLog ${APACHE_LOG_DIR}/daleavatar_access.log combined

    # Security headers
    Header always set X-Content-Type-Options "nosniff"
    Header always set X-Frame-Options "SAMEORIGIN"
    Header always set X-XSS-Protection "1; mode=block"
</VirtualHost>
APACHE_EOF

# Enable site
a2ensite daleavatar.conf
a2dissite 000-default.conf
systemctl reload apache2

# Step 12: Setup firewall
echo ""
echo "Step 12: Configuring firewall..."
ufw allow 22/tcp
ufw allow 80/tcp
ufw allow 443/tcp
ufw --force enable

# Step 13: Setup as deploy user
echo ""
echo "Step 13: Setting up deployment environment..."
sudo -u $DEPLOY_USER bash << 'DEPLOY_SETUP'
cd ~/app

# Initialize git repository
if [ ! -d "repo.git" ]; then
    git init --bare repo.git
fi

# Create post-receive hook
cat > repo.git/hooks/post-receive << 'HOOK_EOF'
#!/bin/bash
set -e

APP_DIR="/home/deploy/app"
RELEASES_DIR="$APP_DIR/releases"
SHARED_DIR="$APP_DIR/shared"
CURRENT_LINK="/var/www/daleavatar/current"
KEEP_RELEASES=5

TIMESTAMP=$(date +%Y%m%d%H%M%S)
RELEASE_DIR="$RELEASES_DIR/$TIMESTAMP"

echo "Creating release directory: $RELEASE_DIR"
mkdir -p "$RELEASE_DIR"

echo "Checking out code..."
GIT_WORK_TREE="$RELEASE_DIR" git checkout -f

cd "$RELEASE_DIR"

# Build Flutter web app
echo "Building Flutter web app..."
cd app
export PATH="$PATH:/home/ubuntu/flutter/bin"
flutter pub get
flutter build web --release

mkdir -p "$RELEASE_DIR/web"
cp -r build/web/* "$RELEASE_DIR/web/"

# Copy .htaccess
if [ -f "docs/deployment/.htaccess" ]; then
    cp docs/deployment/.htaccess "$RELEASE_DIR/web/.htaccess"
fi

# Setup backend
echo "Setting up backend..."
cd "$RELEASE_DIR/backend"

if [ -f "package.json" ]; then
    npm install --production
fi

# Link shared files
if [ -d "$SHARED_DIR/uploads" ]; then
    ln -sf "$SHARED_DIR/uploads" "$RELEASE_DIR/backend/uploads"
fi

# Copy environment file
if [ -f "$SHARED_DIR/.env" ]; then
    cp "$SHARED_DIR/.env" "$RELEASE_DIR/backend/.env"
fi

# Create symlink
echo "Creating symlink..."
sudo rm -f "$CURRENT_LINK"
sudo ln -sf "$RELEASE_DIR/web" "$CURRENT_LINK"
sudo chown -R deploy:www-data "$CURRENT_LINK"
sudo chmod -R 755 "$CURRENT_LINK"

# Restart backend
echo "Restarting backend..."
cd "$RELEASE_DIR/backend"
if pm2 list | grep -q "daleavatar-backend"; then
    pm2 restart daleavatar-backend
else
    pm2 start src/index.js --name daleavatar-backend
    pm2 save
fi

# Reload Apache
echo "Reloading Apache..."
sudo systemctl reload apache2

# Cleanup old releases
cd "$RELEASES_DIR"
ls -t | tail -n +$((KEEP_RELEASES + 1)) | xargs -r rm -rf

echo "Deployment completed successfully!"
HOOK_EOF

chmod +x repo.git/hooks/post-receive

# Create .env template
if [ ! -f "$SHARED_DIR/.env" ]; then
    cat > "$SHARED_DIR/.env" << 'ENV_EOF'
PORT=4000
NODE_ENV=production
HEYGEN_API_KEY=your_heygen_api_key_here
OPENAI_API_KEY=your_openai_key_here
MYSQL_DSN=mysql://user:password@localhost:3306/daleavatar
S3_BUCKET=your-bucket-name
S3_REGION=us-east-1
S3_ACCESS_KEY_ID=your_access_key
S3_SECRET_ACCESS_KEY=your_secret_key
ENV_EOF
fi
DEPLOY_SETUP

echo ""
echo "=========================================="
echo "Setup Complete!"
echo "=========================================="
echo ""
echo "Next steps:"
echo "1. Edit /home/$DEPLOY_USER/app/shared/.env with your environment variables"
echo "2. Ensure DNS for $DOMAIN points to this server"
echo "3. Run SSL setup: sudo ./setup-ssl.sh"
echo "4. Add your SSH public key to /home/$DEPLOY_USER/.ssh/authorized_keys"
echo "5. Deploy: git push production main"
echo ""
echo "To setup SSL, run:"
echo "  sudo ./setup-ssl.sh"

