#!/bin/bash

# Setup Git Access on EC2 Instance
# This script helps set up git cloning on your EC2 server
#
# Usage: sudo ./setup_git_on_ec2.sh

set -e

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

print_warning() {
    echo -e "${YELLOW}⚠ $1${NC}"
}

# Check if running as root
if [ "$EUID" -ne 0 ]; then
    print_error "Please run with sudo: sudo ./setup_git_on_ec2.sh"
    exit 1
fi

print_header "Git Setup for EC2 Deployment"

# Check if deploy user exists
if ! id "deploy" &>/dev/null; then
    print_error "Deploy user does not exist. Please run EC2 setup first."
    exit 1
fi

# Step 1: Generate SSH Key
print_header "Step 1: Generate SSH Key"

print_step "Switching to deploy user..."
sudo -u deploy bash << 'DEPLOY_SCRIPT'
set -e

# Check if key already exists
if [ -f ~/.ssh/id_ed25519 ]; then
    echo "SSH key already exists. Skipping generation."
    echo "Public key:"
    cat ~/.ssh/id_ed25519.pub
    echo ""
    read -p "Generate new key anyway? (y/N): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        exit 0
    fi
fi

# Generate SSH key
ssh-keygen -t ed25519 -C "deploy@dineo.digitalflux.co.za" -f ~/.ssh/id_ed25519 -N "" << EOF
y
EOF

echo ""
echo "SSH key generated successfully!"
echo ""
echo "========================================="
echo "PUBLIC KEY (add this to GitHub/GitLab):"
echo "========================================="
cat ~/.ssh/id_ed25519.pub
echo ""
echo "========================================="
DEPLOY_SCRIPT

echo ""

# Step 2: Configure Git
print_header "Step 2: Configure Git"

sudo -u deploy git config --global user.name "Deploy Bot" || true
sudo -u deploy git config --global user.email "deploy@digitalflux.co.za" || true

print_step "Git configured:"
echo "  Name: $(sudo -u deploy git config --global user.name)"
echo "  Email: $(sudo -u deploy git config --global user.email)"

echo ""

# Step 3: Test Connection
print_header "Step 3: Test Git Connection"

echo "Choose your git provider:"
echo "  1) GitHub"
echo "  2) GitLab"
echo "  3) Other (skip test)"
read -p "Enter choice (1-3): " PROVIDER_CHOICE

case $PROVIDER_CHOICE in
    1)
        print_step "Testing GitHub connection..."
        if sudo -u deploy ssh -T git@github.com 2>&1 | grep -q "successfully authenticated"; then
            print_step "✓ GitHub connection successful!"
        else
            print_warning "GitHub connection test returned unexpected result"
            print_step "This is normal if you haven't added the key yet"
        fi
        ;;
    2)
        print_step "Testing GitLab connection..."
        if sudo -u deploy ssh -T git@gitlab.com 2>&1 | grep -q "successfully authenticated"; then
            print_step "✓ GitLab connection successful!"
        else
            print_warning "GitLab connection test returned unexpected result"
            print_step "This is normal if you haven't added the key yet"
        fi
        ;;
    *)
        print_warning "Skipping connection test"
        ;;
esac

echo ""

# Step 4: Clone Repository
print_header "Step 4: Clone Repository"

DEPLOY_DIR="/var/www/dineo.digitalflux.co.za"

if [ -d "$DEPLOY_DIR/.git" ]; then
    print_warning "Repository already exists at $DEPLOY_DIR"
    read -p "Re-clone? This will remove existing files. (y/N): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        print_step "Keeping existing repository"
        exit 0
    fi
    
    # Backup existing
    if [ "$(ls -A $DEPLOY_DIR 2>/dev/null)" ]; then
        BACKUP_DIR="/var/backups/dineo"
        mkdir -p "$BACKUP_DIR"
        TIMESTAMP=$(date +%Y%m%d_%H%M%S)
        tar -czf "$BACKUP_DIR/pre_clone_backup_$TIMESTAMP.tar.gz" -C "$DEPLOY_DIR" . 2>/dev/null || true
        print_step "Backed up existing files"
    fi
    
    # Remove existing
    rm -rf "$DEPLOY_DIR"/*
    rm -rf "$DEPLOY_DIR"/.git
fi

read -p "Enter git repository URL: " REPO_URL

if [ -z "$REPO_URL" ]; then
    print_error "Repository URL required"
    exit 1
fi

# Ensure parent directory exists
mkdir -p "$(dirname "$DEPLOY_DIR")"

# Clone repository
print_step "Cloning repository..."
if sudo -u deploy git clone "$REPO_URL" "$DEPLOY_DIR"; then
    print_step "✓ Repository cloned successfully!"
else
    print_error "Failed to clone repository"
    echo ""
    echo "Common issues:"
    echo "  1. SSH key not added to GitHub/GitLab"
    echo "  2. Repository URL incorrect"
    echo "  3. Repository is private and key doesn't have access"
    echo ""
    echo "For SSH URLs, make sure you've added the public key shown above"
    echo "to your GitHub/GitLab account."
    exit 1
fi

# Set permissions
print_step "Setting permissions..."
chown -R deploy:www-data "$DEPLOY_DIR"
chmod -R 755 "$DEPLOY_DIR"
chown -R deploy:deploy "$DEPLOY_DIR/.git"

# Verify
print_step "Verifying clone..."
cd "$DEPLOY_DIR"
BRANCH=$(sudo -u deploy git branch --show-current)
COMMIT=$(sudo -u deploy git rev-parse --short HEAD)
REMOTE=$(sudo -u deploy git remote get-url origin)

echo ""
print_header "Setup Complete!"

echo "Repository Information:"
echo "  Location: $DEPLOY_DIR"
echo "  Remote: $REMOTE"
echo "  Branch: $BRANCH"
echo "  Commit: $COMMIT"
echo ""
echo "Next steps:"
echo "  1. Verify the repository is accessible"
echo "  2. Run deployment: sudo /usr/local/bin/ec2_pull_deploy.sh"
echo ""

