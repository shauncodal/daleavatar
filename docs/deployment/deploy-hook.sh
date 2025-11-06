#!/bin/bash
# Git post-receive hook for automatic deployment
# This script runs when code is pushed to the repository

set -e

# Configuration
APP_DIR="/home/deploy/app"
RELEASES_DIR="$APP_DIR/releases"
SHARED_DIR="$APP_DIR/shared"
CURRENT_LINK="/var/www/daleavatar/current"
BACKEND_DIR="$APP_DIR/backend"
KEEP_RELEASES=5

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${GREEN}========================================${NC}"
echo -e "${GREEN}Starting deployment...${NC}"
echo -e "${GREEN}========================================${NC}"

# Create timestamp for release
TIMESTAMP=$(date +%Y%m%d%H%M%S)
RELEASE_DIR="$RELEASES_DIR/$TIMESTAMP"

echo -e "${YELLOW}Creating release directory: $RELEASE_DIR${NC}"
mkdir -p "$RELEASE_DIR"

# Checkout code to release directory
echo -e "${YELLOW}Checking out code...${NC}"
GIT_WORK_TREE="$RELEASE_DIR" git checkout -f

cd "$RELEASE_DIR"

# Build Flutter web app
echo -e "${YELLOW}Building Flutter web app...${NC}"
cd app

# Install Flutter dependencies
export PATH="$PATH:/home/ubuntu/flutter/bin"
flutter pub get

# Build for web
flutter build web --release

# Copy build output
echo -e "${YELLOW}Copying build output...${NC}"
mkdir -p "$RELEASE_DIR/web"
cp -r build/web/* "$RELEASE_DIR/web/"

# Copy .htaccess if it exists
if [ -f "$RELEASE_DIR/app/docs/deployment/.htaccess" ]; then
    cp "$RELEASE_DIR/app/docs/deployment/.htaccess" "$RELEASE_DIR/web/.htaccess"
    echo -e "${GREEN}.htaccess file copied${NC}"
fi

# Setup backend
echo -e "${YELLOW}Setting up backend...${NC}"
cd "$RELEASE_DIR/backend"

# Install backend dependencies
if [ -f "package.json" ]; then
    npm install --production
fi

# Link shared files (if any)
if [ -d "$SHARED_DIR/uploads" ]; then
    ln -sf "$SHARED_DIR/uploads" "$RELEASE_DIR/backend/uploads"
fi

# Copy environment file from shared if it exists
if [ -f "$SHARED_DIR/.env" ]; then
    cp "$SHARED_DIR/.env" "$RELEASE_DIR/backend/.env"
    echo -e "${GREEN}Environment file copied${NC}"
else
    echo -e "${YELLOW}Warning: No .env file found in shared directory${NC}"
fi

# Create symlink to current release
echo -e "${YELLOW}Creating symlink to current release...${NC}"
sudo rm -f "$CURRENT_LINK"
sudo ln -sf "$RELEASE_DIR/web" "$CURRENT_LINK"
sudo chown -R deploy:www-data "$CURRENT_LINK"
sudo chmod -R 755 "$CURRENT_LINK"

# Restart backend with PM2
echo -e "${YELLOW}Restarting backend...${NC}"
cd "$RELEASE_DIR/backend"
if pm2 list | grep -q "daleavatar-backend"; then
    pm2 restart daleavatar-backend
else
    pm2 start src/index.js --name daleavatar-backend
    pm2 save
fi

# Reload Apache
echo -e "${YELLOW}Reloading Apache...${NC}"
sudo systemctl reload apache2

# Cleanup old releases
echo -e "${YELLOW}Cleaning up old releases...${NC}"
cd "$RELEASES_DIR"
ls -t | tail -n +$((KEEP_RELEASES + 1)) | xargs -r rm -rf

echo -e "${GREEN}========================================${NC}"
echo -e "${GREEN}Deployment completed successfully!${NC}"
echo -e "${GREEN}Release: $TIMESTAMP${NC}"
echo -e "${GREEN}========================================${NC}"

# Show deployment info
echo -e "${YELLOW}Deployment Info:${NC}"
echo "  Release: $TIMESTAMP"
echo "  Release Directory: $RELEASE_DIR"
echo "  Current Link: $CURRENT_LINK"
echo "  Backend Status: $(pm2 jlist | grep -o '"name":"daleavatar-backend"[^}]*"status":"[^"]*' | grep -o '"status":"[^"]*' | cut -d'"' -f4)"

