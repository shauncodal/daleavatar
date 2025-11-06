#!/bin/bash
# Initial setup script for EC2 deployment
# Run this script on your EC2 instance as the deploy user

set -e

echo "=========================================="
echo "Setting up deployment environment"
echo "=========================================="

# Create necessary directories
echo "Creating directories..."
mkdir -p ~/app/releases
mkdir -p ~/app/shared
mkdir -p ~/app/shared/uploads
mkdir -p ~/app/backend

# Initialize git repository
if [ ! -d ~/app/repo.git ]; then
    echo "Initializing git repository..."
    cd ~/app
    git init --bare repo.git
fi

# Setup post-receive hook
echo "Setting up deployment hook..."
cat > ~/app/repo.git/hooks/post-receive << 'HOOK_EOF'
#!/bin/bash
# Git post-receive hook for automatic deployment

set -e

APP_DIR="/home/deploy/app"
RELEASES_DIR="$APP_DIR/releases"
SHARED_DIR="$APP_DIR/shared"
CURRENT_LINK="/var/www/daleavatar/current"
BACKEND_DIR="$APP_DIR/backend"
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

chmod +x ~/app/repo.git/hooks/post-receive

# Create shared .env file template
if [ ! -f ~/app/shared/.env ]; then
    echo "Creating .env template..."
    cat > ~/app/shared/.env << 'ENV_EOF'
PORT=4000
NODE_ENV=production
HEYGEN_API_KEY=your_heygen_api_key_here
# Add other environment variables as needed
ENV_EOF
    echo "Please edit ~/app/shared/.env with your actual values"
fi

echo "=========================================="
echo "Setup completed!"
echo "=========================================="
echo ""
echo "Next steps:"
echo "1. Edit ~/app/shared/.env with your environment variables"
echo "2. Add your public SSH key to ~/.ssh/authorized_keys"
echo "3. On your local machine, add remote:"
echo "   git remote add production deploy@your-ec2-ip:~/app/repo.git"
echo "4. Deploy: git push production main"

