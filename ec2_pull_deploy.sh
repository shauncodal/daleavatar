#!/bin/bash

# EC2 Server-Side Pull and Deploy Script
# This script should be run on the EC2 server to pull and deploy the latest code
#
# Usage: sudo ./ec2_pull_deploy.sh [branch]

set -e

# Configuration
BRANCH="${1:-main}"
DEPLOY_DIR="/var/www/dineo.digitalflux.co.za"
BACKUP_DIR="/var/backups/dineo"
REPO_URL=""  # Will be detected from git config
TIMESTAMP=$(date +%Y%m%d_%H%M%S)

# Colors
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

print_header() {
    echo -e "${BLUE}========================================${NC}"
    echo -e "${BLUE}$1${NC}"
    echo -e "${BLUE}========================================${NC}"
    echo ""
}

print_step() {
    echo -e "${GREEN}→ $1${NC}"
}

print_error() {
    echo -e "${RED}✗ $1${NC}"
}

# Check if running as root or with sudo
if [ "$EUID" -ne 0 ]; then
    print_error "Please run with sudo: sudo ./ec2_pull_deploy.sh"
    exit 1
fi

print_header "EC2 Pull and Deploy Script"
echo "Branch: $BRANCH"
echo "Deploy Directory: $DEPLOY_DIR"
echo ""

# Step 1: Check if deploy directory exists and is a git repo
if [ ! -d "$DEPLOY_DIR" ]; then
    print_error "Deploy directory does not exist: $DEPLOY_DIR"
    echo "Please run initial setup first (see EC2_APACHE_DEPLOYMENT.md)"
    exit 1
fi

# Step 2: Create backup
print_header "Step 1: Creating Backup"

mkdir -p "$BACKUP_DIR"

if [ -d "$DEPLOY_DIR" ] && [ "$(ls -A $DEPLOY_DIR 2>/dev/null)" ]; then
    print_step "Creating backup..."
    tar -czf "$BACKUP_DIR/backup_$TIMESTAMP.tar.gz" -C "$DEPLOY_DIR" . 2>/dev/null || true
    print_step "Backup created: backup_$TIMESTAMP.tar.gz"
else
    print_step "No existing files to backup"
fi

echo ""

# Step 3: Pull latest code
print_header "Step 2: Pulling Latest Code"

cd "$DEPLOY_DIR"

# Check if it's a git repository
if [ ! -d ".git" ]; then
    print_error "Not a git repository."
    echo ""
    echo "To set up git cloning, you need to:"
    echo "  1. Configure SSH keys or HTTPS access (see EC2_APACHE_DEPLOYMENT.md section 4.5)"
    echo "  2. Clone the repository manually:"
    echo "     sudo su - deploy"
    echo "     cd /var/www"
    echo "     git clone <your-repo-url> dineo.digitalflux.co.za"
    echo ""
    echo "Or provide repository URL now to initialize:"
    read -p "Enter git repository URL (or press Enter to exit): " REPO_URL
    
    if [ -z "$REPO_URL" ]; then
        print_error "Repository URL required. Please set up git access first."
        exit 1
    fi
    
    # Initialize git repo
    print_step "Initializing git repository..."
    sudo -u deploy git init
    sudo -u deploy git remote add origin "$REPO_URL"
    
    # Try to fetch
    print_step "Fetching from remote..."
    if sudo -u deploy git fetch origin 2>/dev/null; then
        print_step "Fetch successful"
        sudo -u deploy git checkout -b "$BRANCH" "origin/$BRANCH" 2>/dev/null || sudo -u deploy git checkout "$BRANCH" 2>/dev/null || true
    else
        print_error "Failed to fetch from remote. Please check:"
        echo "  - SSH key is added to GitHub/GitLab"
        echo "  - Repository URL is correct"
        echo "  - Network connectivity"
        exit 1
    fi
else
    # Pull latest changes
    print_step "Fetching latest changes..."
    sudo -u deploy git fetch origin
    
    print_step "Checking out branch: $BRANCH"
    sudo -u deploy git checkout "$BRANCH" || sudo -u deploy git checkout -b "$BRANCH" "origin/$BRANCH"
    
    print_step "Pulling latest changes..."
    sudo -u deploy git pull origin "$BRANCH"
fi

# Get commit info
COMMIT_HASH=$(sudo -u deploy git rev-parse --short HEAD)
COMMIT_MSG=$(sudo -u deploy git log -1 --pretty=%B | head -n 1)
print_step "Latest commit: $COMMIT_HASH - $COMMIT_MSG"

echo ""

# Step 4: Determine build location
print_header "Step 3: Locating Build Files"

# Check if this is a Flutter web app (has build/web directory)
if [ -d "app/build/web" ]; then
    BUILD_SOURCE="app/build/web"
    print_step "Found Flutter web build: $BUILD_SOURCE"
elif [ -d "build/web" ]; then
    BUILD_SOURCE="build/web"
    print_step "Found Flutter web build: $BUILD_SOURCE"
elif [ -f "index.html" ]; then
    BUILD_SOURCE="."
    print_step "Using root directory as build source"
else
    print_error "Could not find build files"
    echo "Expected one of:"
    echo "  - app/build/web/"
    echo "  - build/web/"
    echo "  - index.html in root"
    exit 1
fi

echo ""

# Step 5: Deploy files
print_header "Step 4: Deploying Files"

# Create temporary directory for deployment
TEMP_DEPLOY=$(mktemp -d)
trap "rm -rf $TEMP_DEPLOY" EXIT

# Copy build files to temp directory
print_step "Copying build files..."
sudo -u deploy cp -r "$BUILD_SOURCE"/* "$TEMP_DEPLOY/" 2>/dev/null || {
    print_error "Failed to copy build files"
    exit 1
}

# Clear deploy directory (keep .git)
print_step "Clearing deploy directory..."
find "$DEPLOY_DIR" -mindepth 1 -maxdepth 1 ! -name '.git' -exec rm -rf {} +

# Copy new files
print_step "Installing new files..."
sudo -u deploy cp -r "$TEMP_DEPLOY"/* "$DEPLOY_DIR"/

# Set permissions
print_step "Setting permissions..."
chown -R deploy:www-data "$DEPLOY_DIR"
find "$DEPLOY_DIR" -type d -exec chmod 755 {} \;
find "$DEPLOY_DIR" -type f -exec chmod 644 {} \;

echo ""

# Step 6: Verify deployment
print_header "Step 5: Verifying Deployment"

if [ -f "$DEPLOY_DIR/index.html" ]; then
    print_step "✓ index.html found"
else
    print_error "index.html not found"
    exit 1
fi

FILE_COUNT=$(find "$DEPLOY_DIR" -type f | wc -l)
DEPLOY_SIZE=$(du -sh "$DEPLOY_DIR" | cut -f1)
print_step "Deployed: $FILE_COUNT files ($DEPLOY_SIZE)"

echo ""

# Step 7: Restart Apache
print_header "Step 6: Restarting Apache"

print_step "Reloading Apache..."
systemctl reload apache2

if systemctl is-active --quiet apache2; then
    print_step "✓ Apache is running"
else
    print_error "Apache is not running"
    systemctl status apache2
    exit 1
fi

echo ""

# Step 8: Health check
print_header "Step 7: Running Health Check"

sleep 2  # Wait for Apache to fully reload

if [ -f "/usr/local/bin/health-check.sh" ]; then
    /usr/local/bin/health-check.sh
else
    print_step "Health check script not found, running basic checks..."
    
    # Basic HTTP check
    HTTP_CODE=$(curl -s -o /dev/null -w "%{http_code}" http://localhost/ || echo "000")
    if [ "$HTTP_CODE" = "200" ] || [ "$HTTP_CODE" = "301" ] || [ "$HTTP_CODE" = "302" ]; then
        print_step "✓ HTTP responding: $HTTP_CODE"
    else
        print_error "HTTP not responding: $HTTP_CODE"
    fi
    
    # Basic HTTPS check
    HTTPS_CODE=$(curl -s -o /dev/null -w "%{http_code}" https://localhost/ || echo "000")
    if [ "$HTTPS_CODE" = "200" ] || [ "$HTTPS_CODE" = "301" ] || [ "$HTTPS_CODE" = "302" ]; then
        print_step "✓ HTTPS responding: $HTTPS_CODE"
    else
        print_error "HTTPS not responding: $HTTPS_CODE"
    fi
fi

echo ""

# Step 9: Summary
print_header "Deployment Complete!"

echo -e "${GREEN}✓ Deployment successful!${NC}"
echo ""
echo "Deployment Summary:"
echo "  Branch: $BRANCH"
echo "  Commit: $COMMIT_HASH"
echo "  Message: $COMMIT_MSG"
echo "  Files: $FILE_COUNT"
echo "  Size: $DEPLOY_SIZE"
echo "  Backup: backup_$TIMESTAMP.tar.gz"
echo ""
echo "Site should be live at: https://dineo.digitalflux.co.za"
echo ""

