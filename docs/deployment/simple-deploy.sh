#!/bin/bash
# Simple Git Pull Deployment Script
# Run this script on your EC2 server to deploy updates

set -e

APP_DIR="/var/www/daleavatar"
BACKEND_DIR="$APP_DIR/backend"
REPO_URL="https://github.com/shauncodal/daleavatar.git"  # Change to your repo URL
BRANCH="main"  # or "feature/student-dashboard-sales-demo"

echo "=========================================="
echo "Deploying application..."
echo "=========================================="

# Check if directory exists, clone if not
if [ ! -d "$APP_DIR/.git" ]; then
    echo "Cloning repository..."
    sudo rm -rf "$APP_DIR"  # Remove if exists but not a git repo
    sudo git clone "$REPO_URL" "$APP_DIR"
    cd "$APP_DIR"
    git checkout "$BRANCH"
else
    echo "Pulling latest changes..."
    cd "$APP_DIR"
    git fetch origin
    git checkout "$BRANCH"
    git pull origin "$BRANCH"
fi

# Build Flutter web app
echo "Building Flutter web app..."
cd "$APP_DIR/app"
export PATH="$PATH:/home/ubuntu/flutter/bin"
flutter pub get
flutter build web --release --dart-define=BACKEND_URL=

# Copy build output to web directory
echo "Copying build output..."
sudo mkdir -p "$APP_DIR/current"
sudo cp -r build/web/* "$APP_DIR/current/"

# Copy .htaccess
if [ -f "$APP_DIR/docs/deployment/.htaccess" ]; then
    sudo cp "$APP_DIR/docs/deployment/.htaccess" "$APP_DIR/current/.htaccess"
fi

# Setup backend
echo "Setting up backend..."
cd "$BACKEND_DIR"

if [ -f "package.json" ]; then
    npm install --production
fi

# Restart backend with PM2
echo "Restarting backend..."
if pm2 list | grep -q "daleavatar-backend"; then
    pm2 restart daleavatar-backend
else
    pm2 start src/index.js --name daleavatar-backend
    pm2 save
fi

# Reload Apache
echo "Reloading Apache..."
sudo systemctl reload apache2

echo "=========================================="
echo "Deployment completed successfully!"
echo "=========================================="

