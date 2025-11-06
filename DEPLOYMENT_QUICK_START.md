# Quick Deployment Guide

## Overview

This project uses a two-script deployment system:
1. **`deploy.sh`** - Run on your local machine (builds, tests, pushes to git)
2. **`ec2_pull_deploy.sh`** - Run on EC2 server (pulls and deploys)

---

## First Time Setup

### 1. On Your Local Machine

Make sure scripts are executable:
```bash
chmod +x deploy.sh verify_deployment.sh
```

### 2. On EC2 Server - Initial Git Setup

**First, set up git access on EC2:**

Copy the setup script to EC2:
```bash
scp -i your-key.pem setup_git_on_ec2.sh ubuntu@<EC2_IP>:/tmp/
```

SSH into EC2:
```bash
ssh -i your-key.pem ubuntu@<EC2_IP>
```

Run the git setup script:
```bash
sudo mv /tmp/setup_git_on_ec2.sh /usr/local/bin/
sudo chmod +x /usr/local/bin/setup_git_on_ec2.sh
sudo /usr/local/bin/setup_git_on_ec2.sh
```

This will:
- Generate SSH keys
- Show you the public key (add it to GitHub/GitLab)
- Clone your repository

**Then, copy the deployment script:**
```bash
# From your local machine
scp -i your-key.pem ec2_pull_deploy.sh ubuntu@<EC2_IP>:/tmp/
```

**On EC2:**
```bash
sudo mv /tmp/ec2_pull_deploy.sh /usr/local/bin/
sudo chmod +x /usr/local/bin/ec2_pull_deploy.sh
```

---

## Standard Deployment Workflow

### Step 1: Local Build and Push

On your local machine:
```bash
./deploy.sh
```

This will:
- ✅ Run all tests (Flutter + backend)
- ✅ Build Flutter web app (release mode)
- ✅ Commit changes to git
- ✅ Push to remote repository

**Options:**
```bash
# Skip tests
./deploy.sh --skip-tests

# Custom commit message
./deploy.sh --message "Added new feature"

# Deploy to different branch
./deploy.sh --branch develop
```

### Step 2: Deploy on EC2

SSH into your EC2 server:
```bash
ssh -i your-key.pem ubuntu@<EC2_IP>
```

Run the deployment script:
```bash
sudo /usr/local/bin/ec2_pull_deploy.sh
```

Or specify a branch:
```bash
sudo /usr/local/bin/ec2_pull_deploy.sh develop
```

This will:
- ✅ Create backup of current deployment
- ✅ Pull latest code from git
- ✅ Deploy build files
- ✅ Set correct permissions
- ✅ Restart Apache
- ✅ Run health checks

---

## Verify Deployment

### From Local Machine

```bash
./verify_deployment.sh
```

### From EC2 Server

```bash
sudo /usr/local/bin/health-check.sh
```

### Manual Checks

```bash
# Check HTTP
curl -I http://dineo.digitalflux.co.za

# Check HTTPS
curl -I https://dineo.digitalflux.co.za

# Check SSL
openssl s_client -connect dineo.digitalflux.co.za:443 -servername dineo.digitalflux.co.za
```

---

## Troubleshooting

### Deployment fails on local machine

**Tests failing:**
```bash
# Run tests manually to see errors
cd app && flutter test
cd ../backend && npm test
```

**Build failing:**
```bash
# Clean and rebuild
cd app
flutter clean
flutter pub get
flutter build web --release
```

**Git push failing:**
```bash
# Check remote configuration
git remote -v

# Set upstream if needed
git push -u origin main
```

### Deployment fails on EC2

**Permission errors:**
```bash
sudo chown -R deploy:www-data /var/www/dineo.digitalflux.co.za
sudo chmod -R 755 /var/www/dineo.digitalflux.co.za
```

**Apache not running:**
```bash
sudo systemctl status apache2
sudo systemctl restart apache2
sudo apache2ctl configtest
```

**Git pull failing:**
```bash
# Check if deploy directory is a git repo
cd /var/www/dineo.digitalflux.co.za
sudo -u deploy git status

# Re-initialize if needed
sudo -u deploy git init
sudo -u deploy git remote add origin <your-repo-url>
```

---

## File Structure

```
.
├── deploy.sh                 # Local deployment script
├── ec2_pull_deploy.sh        # EC2 deployment script
├── verify_deployment.sh      # Local verification script
├── EC2_APACHE_DEPLOYMENT.md  # Complete setup guide
└── DEPLOYMENT_QUICK_START.md # This file
```

---

## Common Commands

### Local Development

```bash
# Full deployment
./deploy.sh

# Deploy without tests
./deploy.sh --skip-tests

# Verify after deployment
./verify_deployment.sh
```

### EC2 Server

```bash
# Deploy latest code
sudo /usr/local/bin/ec2_pull_deploy.sh

# Check health
sudo /usr/local/bin/health-check.sh

# View Apache logs
sudo tail -f /var/log/apache2/dineo_error.log
sudo tail -f /var/log/apache2/dineo_access.log

# Restart Apache
sudo systemctl restart apache2
```

---

## Next Steps

1. ✅ Run `./deploy.sh` on your local machine
2. ✅ SSH to EC2 and run `sudo /usr/local/bin/ec2_pull_deploy.sh`
3. ✅ Verify with `./verify_deployment.sh`
4. ✅ Visit https://dineo.digitalflux.co.za

For detailed setup instructions, see `EC2_APACHE_DEPLOYMENT.md`.

