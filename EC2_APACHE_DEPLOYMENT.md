# EC2 Apache Web Server Deployment Guide
## Complete Setup for dineo.digitalflux.co.za

This guide covers setting up an EC2 instance with Apache, SSL certificates, Git SSH deployment, and health checks.

---

## Table of Contents
1. [EC2 Instance Setup](#1-ec2-instance-setup)
2. [Initial Server Configuration](#2-initial-server-configuration)
3. [Apache Installation and Configuration](#3-apache-installation-and-configuration)
4. [Git SSH Deployment Setup](#4-git-ssh-deployment-setup)
5. [SSL Certificate Installation](#5-ssl-certificate-installation)
6. [Domain Configuration](#6-domain-configuration)
7. [Health Checks and Testing](#7-health-checks-and-testing)
8. [Deployment Script](#8-deployment-script)

---

## 1. EC2 Instance Setup

### 1.1 Launch EC2 Instance

1. **Go to AWS Console → EC2 → Launch Instance**
2. **Configure Instance:**
   - **Name:** `dineo-web-server`
   - **AMI:** Ubuntu 22.04 LTS (or latest)
   - **Instance Type:** t3.small (minimum) or t3.medium (recommended)
   - **Key Pair:** Create new or select existing
   - **Network Settings:**
     - Allow HTTP (port 80)
     - Allow HTTPS (port 443)
     - Allow SSH (port 22)
   - **Storage:** 20 GB minimum

3. **Security Group Rules:**
   ```
   Type        Protocol    Port Range    Source
   SSH         TCP         22            Your IP / 0.0.0.0/0
   HTTP        TCP         80            0.0.0.0/0
   HTTPS       TCP         443           0.0.0.0/0
   ```

4. **Launch Instance** and save your key pair file (`.pem`)

### 1.2 Connect to Instance

```bash
# Set correct permissions on key file
chmod 400 your-key.pem

# Connect to instance
ssh -i your-key.pem ubuntu@<EC2_PUBLIC_IP>
```

---

## 2. Initial Server Configuration

### 2.1 Update System

```bash
sudo apt update
sudo apt upgrade -y
```

### 2.2 Install Essential Tools

```bash
sudo apt install -y \
    git \
    curl \
    wget \
    build-essential \
    software-properties-common \
    apt-transport-https \
    ca-certificates \
    gnupg \
    lsb-release
```

### 2.3 Configure Firewall (UFW)

```bash
sudo ufw allow OpenSSH
sudo ufw allow 'Apache Full'
sudo ufw enable
sudo ufw status
```

### 2.4 Set Timezone

```bash
sudo timedatectl set-timezone Africa/Johannesburg
```

---

## 3. Apache Installation and Configuration

### 3.1 Install Apache

```bash
sudo apt install -y apache2
sudo systemctl enable apache2
sudo systemctl start apache2
```

### 3.2 Enable Required Modules

```bash
sudo a2enmod rewrite
sudo a2enmod ssl
sudo a2enmod headers
sudo a2enmod proxy
sudo a2enmod proxy_http
sudo systemctl restart apache2
```

### 3.3 Create Web Directory Structure

```bash
# Create directory for the application
sudo mkdir -p /var/www/dineo.digitalflux.co.za
sudo chown -R $USER:$USER /var/www/dineo.digitalflux.co.za
sudo chmod -R 755 /var/www/dineo.digitalflux.co.za
```

### 3.4 Create Apache Virtual Host Configuration

```bash
sudo nano /etc/apache2/sites-available/dineo.digitalflux.co.za.conf
```

**Add the following configuration:**

```apache
<VirtualHost *:80>
    ServerName dineo.digitalflux.co.za
    ServerAlias www.dineo.digitalflux.co.za
    ServerAdmin admin@digitalflux.co.za
    
    DocumentRoot /var/www/dineo.digitalflux.co.za
    
    <Directory /var/www/dineo.digitalflux.co.za>
        Options -Indexes +FollowSymLinks
        AllowOverride All
        Require all granted
    </Directory>
    
    # Logging
    ErrorLog ${APACHE_LOG_DIR}/dineo_error.log
    CustomLog ${APACHE_LOG_DIR}/dineo_access.log combined
    
    # Redirect to HTTPS (will be enabled after SSL setup)
    # RewriteEngine On
    # RewriteCond %{HTTPS} off
    # RewriteRule ^(.*)$ https://%{HTTP_HOST}%{REQUEST_URI} [L,R=301]
</VirtualHost>

<VirtualHost *:443>
    ServerName dineo.digitalflux.co.za
    ServerAlias www.dineo.digitalflux.co.za
    ServerAdmin admin@digitalflux.co.za
    
    DocumentRoot /var/www/dineo.digitalflux.co.za
    
    <Directory /var/www/dineo.digitalflux.co.za>
        Options -Indexes +FollowSymLinks
        AllowOverride All
        Require all granted
    </Directory>
    
    # SSL Configuration (will be updated after certbot)
    SSLEngine on
    SSLCertificateFile /etc/letsencrypt/live/dineo.digitalflux.co.za/fullchain.pem
    SSLCertificateKeyFile /etc/letsencrypt/live/dineo.digitalflux.co.za/privkey.pem
    Include /etc/letsencrypt/options-ssl-apache.conf
    
    # Security Headers
    Header always set Strict-Transport-Security "max-age=31536000; includeSubDomains"
    Header always set X-Frame-Options "SAMEORIGIN"
    Header always set X-Content-Type-Options "nosniff"
    Header always set X-XSS-Protection "1; mode=block"
    
    # Logging
    ErrorLog ${APACHE_LOG_DIR}/dineo_ssl_error.log
    CustomLog ${APACHE_LOG_DIR}/dineo_ssl_access.log combined
</VirtualHost>
```

### 3.5 Enable Site and Disable Default

```bash
sudo a2ensite dineo.digitalflux.co.za.conf
sudo a2dissite 000-default.conf
sudo systemctl reload apache2
```

### 3.6 Create Test Index File

```bash
echo "<h1>dineo.digitalflux.co.za is working!</h1>" > /var/www/dineo.digitalflux.co.za/index.html
```

---

## 4. Git SSH Deployment Setup

### 4.1 Create Deployment User

```bash
# Create a dedicated deployment user
sudo adduser --disabled-password --gecos "" deploy
sudo usermod -aG www-data deploy
```

### 4.2 Set Up SSH Directory for Deploy User

```bash
sudo mkdir -p /home/deploy/.ssh
sudo chmod 700 /home/deploy/.ssh
sudo chown deploy:deploy /home/deploy/.ssh
```

### 4.3 Generate SSH Key Pair (on your local machine)

```bash
# On your local machine
ssh-keygen -t ed25519 -C "deploy@dineo.digitalflux.co.za" -f ~/.ssh/dineo_deploy
```

### 4.4 Add Public Key to Server

```bash
# Copy the public key content
cat ~/.ssh/dineo_deploy.pub

# On the server, add it to authorized_keys
sudo nano /home/deploy/.ssh/authorized_keys
# Paste the public key here

sudo chmod 600 /home/deploy/.ssh/authorized_keys
sudo chown deploy:deploy /home/deploy/.ssh/authorized_keys
```

### 4.5 Configure Git Access

#### Option A: SSH Key Setup (Recommended for GitHub/GitLab)

**Step 1: Generate SSH Key on EC2**

```bash
# Switch to deploy user
sudo su - deploy

# Generate SSH key pair
ssh-keygen -t ed25519 -C "deploy@dineo.digitalflux.co.za" -f ~/.ssh/id_ed25519 -N ""

# Display the public key
cat ~/.ssh/id_ed25519.pub
```

**Step 2: Add SSH Key to GitHub/GitLab**

1. **For GitHub:**
   - Go to: https://github.com/settings/keys
   - Click "New SSH key"
   - Paste the public key content
   - Give it a title like "EC2 Deploy Key"
   - Click "Add SSH key"

2. **For GitLab:**
   - Go to: https://gitlab.com/-/profile/keys
   - Paste the public key
   - Add title and click "Add key"

**Step 3: Test SSH Connection**

```bash
# Test GitHub connection
ssh -T git@github.com

# Test GitLab connection
ssh -T git@gitlab.com
```

You should see a success message.

#### Option B: HTTPS with Personal Access Token

If you prefer HTTPS:

```bash
# Switch to deploy user
sudo su - deploy

# Configure git
git config --global user.name "Deploy Bot"
git config --global user.email "deploy@digitalflux.co.za"

# Clone using HTTPS (you'll be prompted for credentials)
# For GitHub: use Personal Access Token as password
# For GitLab: use Personal Access Token as password
```

**Create Personal Access Token:**
- **GitHub:** Settings → Developer settings → Personal access tokens → Generate new token
- **GitLab:** User Settings → Access Tokens → Create personal access token

#### Option C: Deploy Key (Read-Only Access)

For read-only access to a single repository:

1. Generate SSH key (same as Option A, Step 1)
2. Add the public key as a Deploy Key in your repository settings:
   - **GitHub:** Repository → Settings → Deploy keys → Add deploy key
   - **GitLab:** Repository → Settings → Repository → Deploy keys → Add key

### 4.6 Initial Repository Clone

Once git access is configured, clone the repository:

```bash
# As deploy user
sudo su - deploy

# Navigate to parent directory
cd /var/www

# Clone the repository
git clone <your-repo-url> dineo.digitalflux.co.za

# Example for SSH:
# git clone git@github.com:yourusername/yourrepo.git dineo.digitalflux.co.za

# Example for HTTPS:
# git clone https://github.com/yourusername/yourrepo.git dineo.digitalflux.co.za

# Set correct permissions
sudo chown -R deploy:www-data /var/www/dineo.digitalflux.co.za
sudo chmod -R 755 /var/www/dineo.digitalflux.co.za

# Configure git (if not done already)
cd /var/www/dineo.digitalflux.co.za
git config user.name "Deploy Bot"
git config user.email "deploy@digitalflux.co.za"
```

**Verify the clone:**

```bash
cd /var/www/dineo.digitalflux.co.za
git status
git branch -a
ls -la
```

You should see your repository files and the `.git` directory.

### 4.7 Set Up Deployment Directory Permissions

```bash
# Ensure correct ownership and permissions
sudo chown -R deploy:www-data /var/www/dineo.digitalflux.co.za
sudo chmod -R 755 /var/www/dineo.digitalflux.co.za

# Ensure .git directory is accessible
sudo chown -R deploy:deploy /var/www/dineo.digitalflux.co.za/.git
```

### 4.8 Verify Git Setup

Test that git cloning and pulling works:

```bash
# As deploy user
sudo su - deploy
cd /var/www/dineo.digitalflux.co.za

# Test git pull
git pull origin main

# Check remote configuration
git remote -v

# View current branch
git branch

# View commit history
git log --oneline -5
```

If all commands work without errors, git is properly configured!

---

## 5. SSL Certificate Installation

### 5.1 Install Certbot

```bash
sudo apt install -y certbot python3-certbot-apache
```

### 5.2 Obtain SSL Certificate

```bash
# Make sure Apache is running and site is accessible on port 80
sudo certbot --apache -d dineo.digitalflux.co.za -d www.dineo.digitalflux.co.za

# Follow the prompts:
# - Enter email address
# - Agree to terms
# - Choose whether to redirect HTTP to HTTPS (recommended: Yes)
```

### 5.3 Test Certificate Renewal

```bash
# Test renewal process (dry run)
sudo certbot renew --dry-run

# Certbot will auto-renew, but you can set up a cron job for safety
sudo crontab -e
# Add this line:
# 0 3 * * * certbot renew --quiet --no-self-upgrade
```

### 5.4 Update Apache SSL Configuration

Certbot should have automatically updated your Apache config. Verify:

```bash
sudo apache2ctl -S
sudo systemctl status apache2
```

---

## 6. Domain Configuration

### 6.1 DNS Configuration

In your DNS provider (where digitalflux.co.za is managed), add:

**A Record:**
```
Type: A
Name: dineo (or @ if using root domain)
Value: <EC2_PUBLIC_IP>
TTL: 300
```

**CNAME Record (optional for www):**
```
Type: CNAME
Name: www.dineo
Value: dineo.digitalflux.co.za
TTL: 300
```

### 6.2 Verify DNS Propagation

```bash
# Check DNS resolution
dig dineo.digitalflux.co.za
nslookup dineo.digitalflux.co.za

# Should return your EC2 public IP
```

---

## 7. Health Checks and Testing

### 7.1 Create Health Check Script

```bash
sudo nano /usr/local/bin/health-check.sh
```

**Add this content:**

```bash
#!/bin/bash

# Health Check Script for dineo.digitalflux.co.za
# Run this script to verify all services are working

echo "========================================="
echo "Health Check for dineo.digitalflux.co.za"
echo "========================================="
echo ""

# Colors
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Check Apache Status
echo -n "Checking Apache status... "
if systemctl is-active --quiet apache2; then
    echo -e "${GREEN}✓ Running${NC}"
else
    echo -e "${RED}✗ Not Running${NC}"
fi

# Check Port 80
echo -n "Checking HTTP (port 80)... "
if curl -s -o /dev/null -w "%{http_code}" http://localhost/ | grep -q "200\|301\|302"; then
    echo -e "${GREEN}✓ Accessible${NC}"
else
    echo -e "${RED}✗ Not Accessible${NC}"
fi

# Check Port 443
echo -n "Checking HTTPS (port 443)... "
if curl -s -o /dev/null -w "%{http_code}" https://localhost/ | grep -q "200\|301\|302"; then
    echo -e "${GREEN}✓ Accessible${NC}"
else
    echo -e "${RED}✗ Not Accessible${NC}"
fi

# Check SSL Certificate
echo -n "Checking SSL Certificate... "
if echo | openssl s_client -connect localhost:443 -servername dineo.digitalflux.co.za 2>/dev/null | grep -q "Verify return code: 0"; then
    echo -e "${GREEN}✓ Valid${NC}"
else
    echo -e "${YELLOW}⚠ Check manually${NC}"
fi

# Check Domain Resolution
echo -n "Checking DNS resolution... "
if dig +short dineo.digitalflux.co.za | grep -q "."; then
    IP=$(dig +short dineo.digitalflux.co.za | head -n1)
    echo -e "${GREEN}✓ Resolves to $IP${NC}"
else
    echo -e "${RED}✗ Not resolving${NC}"
fi

# Check External HTTP
echo -n "Checking external HTTP... "
HTTP_CODE=$(curl -s -o /dev/null -w "%{http_code}" http://dineo.digitalflux.co.za/)
if [ "$HTTP_CODE" = "200" ] || [ "$HTTP_CODE" = "301" ] || [ "$HTTP_CODE" = "302" ]; then
    echo -e "${GREEN}✓ HTTP $HTTP_CODE${NC}"
else
    echo -e "${RED}✗ HTTP $HTTP_CODE${NC}"
fi

# Check External HTTPS
echo -n "Checking external HTTPS... "
HTTPS_CODE=$(curl -s -o /dev/null -w "%{http_code}" https://dineo.digitalflux.co.za/)
if [ "$HTTPS_CODE" = "200" ] || [ "$HTTPS_CODE" = "301" ] || [ "$HTTPS_CODE" = "302" ]; then
    echo -e "${GREEN}✓ HTTPS $HTTPS_CODE${NC}"
else
    echo -e "${RED}✗ HTTPS $HTTPS_CODE${NC}"
fi

# Check SSL Certificate Validity
echo -n "Checking SSL certificate validity... "
CERT_DAYS=$(echo | openssl s_client -connect dineo.digitalflux.co.za:443 -servername dineo.digitalflux.co.za 2>/dev/null | openssl x509 -noout -dates | grep "notAfter" | cut -d= -f2 | xargs -I {} date -d {} +%s)
CURRENT_DAYS=$(date +%s)
DAYS_LEFT=$(( ($CERT_DAYS - $CURRENT_DAYS) / 86400 ))
if [ $DAYS_LEFT -gt 30 ]; then
    echo -e "${GREEN}✓ Valid for $DAYS_LEFT days${NC}"
elif [ $DAYS_LEFT -gt 0 ]; then
    echo -e "${YELLOW}⚠ Expires in $DAYS_LEFT days${NC}"
else
    echo -e "${RED}✗ Expired${NC}"
fi

# Check Disk Space
echo -n "Checking disk space... "
DISK_USAGE=$(df -h / | awk 'NR==2 {print $5}' | sed 's/%//')
if [ $DISK_USAGE -lt 80 ]; then
    echo -e "${GREEN}✓ ${DISK_USAGE}% used${NC}"
elif [ $DISK_USAGE -lt 90 ]; then
    echo -e "${YELLOW}⚠ ${DISK_USAGE}% used${NC}"
else
    echo -e "${RED}✗ ${DISK_USAGE}% used${NC}"
fi

# Check Memory
echo -n "Checking memory... "
MEM_USAGE=$(free | grep Mem | awk '{printf "%.0f", $3/$2 * 100}')
if [ $MEM_USAGE -lt 80 ]; then
    echo -e "${GREEN}✓ ${MEM_USAGE}% used${NC}"
elif [ $MEM_USAGE -lt 90 ]; then
    echo -e "${YELLOW}⚠ ${MEM_USAGE}% used${NC}"
else
    echo -e "${RED}✗ ${MEM_USAGE}% used${NC}"
fi

echo ""
echo "========================================="
echo "Health check complete"
echo "========================================="
```

**Make it executable:**

```bash
sudo chmod +x /usr/local/bin/health-check.sh
```

### 7.2 Run Health Checks

```bash
# Run local health check
sudo /usr/local/bin/health-check.sh

# Test from your local machine
curl -I http://dineo.digitalflux.co.za
curl -I https://dineo.digitalflux.co.za

# Test SSL certificate
openssl s_client -connect dineo.digitalflux.co.za:443 -servername dineo.digitalflux.co.za

# Test with verbose output
curl -v https://dineo.digitalflux.co.za
```

### 7.3 Automated Monitoring (Optional)

```bash
# Set up cron job for regular health checks
sudo crontab -e
# Add:
# */5 * * * * /usr/local/bin/health-check.sh >> /var/log/health-check.log 2>&1
```

---

## 8. Deployment Scripts

### 8.1 Local Deployment Script (deploy.sh)

The main deployment script (`deploy.sh`) should be run from your local development machine. It:
- Runs tests (Flutter and backend)
- Builds the Flutter web application
- Commits and pushes to git
- Prepares everything for EC2 deployment

**Usage:**
```bash
# Standard deployment
./deploy.sh

# Skip tests
./deploy.sh --skip-tests

# Custom commit message
./deploy.sh --message "Deploy new features"

# Deploy to different branch
./deploy.sh --branch develop
```

### 8.2 Initial Git Setup on EC2

Before you can pull from git, you need to set up git access on EC2.

**Option 1: Use the automated setup script**

Copy the setup script to EC2:
```bash
# From your local machine
scp -i your-key.pem setup_git_on_ec2.sh ubuntu@<EC2_IP>:/tmp/
```

On EC2:
```bash
sudo mv /tmp/setup_git_on_ec2.sh /usr/local/bin/
sudo chmod +x /usr/local/bin/setup_git_on_ec2.sh
sudo /usr/local/bin/setup_git_on_ec2.sh
```

This script will:
- Generate SSH keys for the deploy user
- Display the public key (add it to GitHub/GitLab)
- Test the connection
- Clone your repository

**Option 2: Manual setup (see Section 4.5-4.8)**

Follow the detailed instructions in sections 4.5-4.8 to manually configure git access.

### 8.3 EC2 Pull and Deploy Script (ec2_pull_deploy.sh)

This script runs on the EC2 server to pull and deploy the latest code.

**First, copy the script to EC2:**
```bash
# From your local machine
scp -i your-key.pem ec2_pull_deploy.sh ubuntu@<EC2_IP>:/tmp/
```

**On EC2, move it to a permanent location:**
```bash
sudo mv /tmp/ec2_pull_deploy.sh /usr/local/bin/
sudo chmod +x /usr/local/bin/ec2_pull_deploy.sh
```

**Usage on EC2:**
```bash
# Pull and deploy from main branch
sudo /usr/local/bin/ec2_pull_deploy.sh

# Pull and deploy from specific branch
sudo /usr/local/bin/ec2_pull_deploy.sh develop
```

### 8.4 Complete Deployment Workflow

**On your local machine:**
```bash
# 1. Build, test, and push to git
./deploy.sh

# 2. SSH to EC2 and deploy
ssh -i your-key.pem ubuntu@<EC2_IP>
```

**On EC2:**
```bash
# Pull and deploy
sudo /usr/local/bin/ec2_pull_deploy.sh
```

### 8.4 Legacy Deployment Script (for reference)

### 8.4.1 Create Deployment Script

```bash
sudo nano /home/deploy/deploy.sh
```

**Add this content:**

```bash
#!/bin/bash

# Deployment script for dineo.digitalflux.co.za
# Usage: ./deploy.sh [branch]

set -e  # Exit on error

# Configuration
REPO_URL="git@github.com:yourusername/yourrepo.git"  # Update with your repo
DEPLOY_DIR="/var/www/dineo.digitalflux.co.za"
BACKUP_DIR="/var/backups/dineo"
BRANCH="${1:-main}"  # Default to main branch
TIMESTAMP=$(date +%Y%m%d_%H%M%S)

# Colors for output
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${GREEN}========================================${NC}"
echo -e "${GREEN}Deploying dineo.digitalflux.co.za${NC}"
echo -e "${GREEN}Branch: $BRANCH${NC}"
echo -e "${GREEN}========================================${NC}"

# Create backup directory if it doesn't exist
mkdir -p "$BACKUP_DIR"

# Backup current deployment
if [ -d "$DEPLOY_DIR" ] && [ "$(ls -A $DEPLOY_DIR)" ]; then
    echo -e "${YELLOW}Creating backup...${NC}"
    sudo tar -czf "$BACKUP_DIR/backup_$TIMESTAMP.tar.gz" -C "$DEPLOY_DIR" .
    echo -e "${GREEN}Backup created: backup_$TIMESTAMP.tar.gz${NC}"
fi

# Create temporary clone directory
TEMP_DIR=$(mktemp -d)
trap "rm -rf $TEMP_DIR" EXIT

echo -e "${YELLOW}Cloning repository...${NC}"
git clone -b "$BRANCH" "$REPO_URL" "$TEMP_DIR"

# If this is a Flutter web app, build it
if [ -f "$TEMP_DIR/pubspec.yaml" ]; then
    echo -e "${YELLOW}Building Flutter web app...${NC}"
    cd "$TEMP_DIR"
    
    # Install Flutter dependencies
    flutter pub get
    
    # Build for web
    flutter build web --release
    
    # Set source directory to build/web
    SOURCE_DIR="$TEMP_DIR/build/web"
else
    # For other apps, use the root
    SOURCE_DIR="$TEMP_DIR"
fi

# Deploy files
echo -e "${YELLOW}Deploying files...${NC}"
sudo rm -rf "$DEPLOY_DIR"/*
sudo cp -r "$SOURCE_DIR"/* "$DEPLOY_DIR"/

# Set correct permissions
echo -e "${YELLOW}Setting permissions...${NC}"
sudo chown -R deploy:www-data "$DEPLOY_DIR"
sudo chmod -R 755 "$DEPLOY_DIR"
sudo find "$DEPLOY_DIR" -type f -exec chmod 644 {} \;
sudo find "$DEPLOY_DIR" -type d -exec chmod 755 {} \;

# Restart Apache
echo -e "${YELLOW}Restarting Apache...${NC}"
sudo systemctl reload apache2

# Run health check
echo -e "${YELLOW}Running health check...${NC}"
sleep 2
sudo /usr/local/bin/health-check.sh

echo -e "${GREEN}========================================${NC}"
echo -e "${GREEN}Deployment complete!${NC}"
echo -e "${GREEN}========================================${NC}"
```

**Make it executable:**

```bash
sudo chmod +x /home/deploy/deploy.sh
sudo chown deploy:deploy /home/deploy/deploy.sh
```

### 8.5 Create Deployment Wrapper (for easier access - legacy)

```bash
sudo nano /usr/local/bin/deploy-dineo
```

**Add:**

```bash
#!/bin/bash
sudo -u deploy /home/deploy/deploy.sh "$@"
```

**Make executable:**

```bash
sudo chmod +x /usr/local/bin/deploy-dineo
```

### 8.6 Legacy Usage

```bash
# Deploy from main branch
sudo deploy-dineo

# Deploy from specific branch
sudo deploy-dineo develop

# Or as deploy user
sudo su - deploy
cd ~
./deploy.sh main
```

---

## 9. Additional Configuration

### 9.1 Set Up Log Rotation

```bash
sudo nano /etc/logrotate.d/dineo
```

**Add:**

```
/var/log/apache2/dineo_*.log {
    daily
    missingok
    rotate 14
    compress
    delaycompress
    notifempty
    create 0640 www-data adm
    sharedscripts
    postrotate
        systemctl reload apache2 > /dev/null
    endscript
}
```

### 9.2 Configure Automatic Security Updates

```bash
sudo apt install -y unattended-upgrades
sudo dpkg-reconfigure -plow unattended-upgrades
```

### 9.3 Set Up Monitoring Alerts (Optional)

Consider setting up:
- CloudWatch alarms for EC2 metrics
- Email alerts for failed deployments
- Uptime monitoring (UptimeRobot, Pingdom, etc.)

---

## 10. Troubleshooting

### Common Issues

**Apache won't start:**
```bash
sudo systemctl status apache2
sudo journalctl -xe
sudo apache2ctl configtest
```

**SSL certificate issues:**
```bash
sudo certbot certificates
sudo certbot renew --force-renewal
```

**Permission issues:**
```bash
sudo chown -R deploy:www-data /var/www/dineo.digitalflux.co.za
sudo chmod -R 755 /var/www/dineo.digitalflux.co.za
```

**DNS not resolving:**
```bash
dig dineo.digitalflux.co.za
# Check DNS propagation: https://www.whatsmydns.net/
```

---

## 11. Quick Reference Commands

```bash
# Check Apache status
sudo systemctl status apache2

# Restart Apache
sudo systemctl restart apache2

# Check Apache configuration
sudo apache2ctl configtest

# View Apache logs
sudo tail -f /var/log/apache2/dineo_error.log
sudo tail -f /var/log/apache2/dineo_access.log

# Run health check
sudo /usr/local/bin/health-check.sh

# Deploy application
sudo deploy-dineo

# Check SSL certificate
sudo certbot certificates

# Renew SSL certificate
sudo certbot renew

# Check disk space
df -h

# Check memory
free -h

# Check system load
uptime
```

---

## 12. Security Checklist

- [ ] Firewall (UFW) configured
- [ ] SSH key-based authentication only
- [ ] Regular system updates enabled
- [ ] SSL certificate installed and auto-renewal configured
- [ ] Security headers configured in Apache
- [ ] File permissions set correctly
- [ ] Backup system in place
- [ ] Monitoring and alerts configured
- [ ] Strong passwords/keys used
- [ ] Unnecessary services disabled

---

## Support

For issues or questions:
1. Check Apache error logs: `/var/log/apache2/dineo_error.log`
2. Run health check: `sudo /usr/local/bin/health-check.sh`
3. Verify DNS: `dig dineo.digitalflux.co.za`
4. Test connectivity: `curl -v https://dineo.digitalflux.co.za`

---

**Last Updated:** $(date)
**Domain:** dineo.digitalflux.co.za
**Server:** EC2 Ubuntu 22.04 LTS

