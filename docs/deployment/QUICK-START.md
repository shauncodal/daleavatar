# Quick Start Deployment Guide

## Prerequisites Checklist

- [ ] EC2 instance running Ubuntu 22.04
- [ ] Security group allows: SSH (22), HTTP (80), HTTPS (443)
- [ ] SSH key pair downloaded
- [ ] Domain name configured (optional)

## 5-Minute Setup

### Step 1: Connect to EC2

```bash
ssh -i your-key.pem ubuntu@your-ec2-ip
```

### Step 2: Run Setup Script

```bash
# Switch to deploy user
sudo adduser deploy
sudo usermod -aG sudo deploy
sudo su - deploy

# Download and run setup
cd ~
curl -O https://raw.githubusercontent.com/your-repo/main/docs/deployment/setup-deployment.sh
chmod +x setup-deployment.sh
./setup-deployment.sh
```

### Step 3: Configure Environment

```bash
nano ~/app/shared/.env
```

Add your variables:
```env
PORT=4000
NODE_ENV=production
HEYGEN_API_KEY=your_key
```

### Step 4: Setup Apache

```bash
# Copy config
sudo cp ~/app/repo.git/hooks/../docs/deployment/apache-vhost.conf /etc/apache2/sites-available/daleavatar.conf

# Edit domain
sudo nano /etc/apache2/sites-available/daleavatar.conf
# Replace yourdomain.com with your domain or IP

# Enable
sudo a2ensite daleavatar.conf
sudo a2enmod rewrite headers proxy proxy_http
sudo systemctl reload apache2
```

### Step 5: Add SSH Key

```bash
# On your local machine, copy public key
cat ~/.ssh/id_rsa.pub

# On EC2, add to deploy user
sudo su - deploy
mkdir -p ~/.ssh
nano ~/.ssh/authorized_keys
# Paste your public key, save and exit
chmod 600 ~/.ssh/authorized_keys
```

### Step 6: Deploy from Local Machine

```bash
# In your local repo
git remote add production deploy@your-ec2-ip:~/app/repo.git
git push production main
```

## Verify Deployment

1. **Check Apache**: `sudo systemctl status apache2`
2. **Check Backend**: `pm2 status`
3. **Visit**: `http://your-ec2-ip` or `http://yourdomain.com`

## Common Commands

```bash
# View logs
pm2 logs daleavatar-backend
sudo tail -f /var/log/apache2/error.log

# Restart services
pm2 restart daleavatar-backend
sudo systemctl restart apache2

# Check deployment
ls -la /var/www/daleavatar/current
```

## Troubleshooting

**502 Bad Gateway**: Backend not running
```bash
pm2 restart daleavatar-backend
```

**404 Not Found**: Apache not configured
```bash
sudo a2ensite daleavatar.conf
sudo systemctl reload apache2
```

**Permission Denied**: Fix permissions
```bash
sudo chown -R deploy:www-data /var/www/daleavatar
sudo chmod -R 755 /var/www/daleavatar
```

## Next Steps

- [ ] Setup SSL with Let's Encrypt
- [ ] Configure domain DNS
- [ ] Setup monitoring
- [ ] Configure backups
- [ ] Review security settings

