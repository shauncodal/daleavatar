# EC2 Apache Deployment Guide

Complete guide for deploying the Flutter web app to EC2 with Apache web server and Git SSH deployment.

## Prerequisites

- AWS EC2 instance (Ubuntu 22.04 LTS recommended)
- Domain name (optional, can use IP address)
- SSH access to EC2 instance
- Git repository with your code

## Step 1: Initial EC2 Setup

### 1.1 Launch EC2 Instance

1. Go to AWS Console → EC2 → Launch Instance
2. Choose Ubuntu Server 22.04 LTS
3. Select instance type (t2.micro for testing, t3.small+ for production)
4. Configure security group:
   - SSH (22) from your IP
   - HTTP (80) from anywhere
   - HTTPS (443) from anywhere (if using SSL)
5. Create/select key pair for SSH access
6. Launch instance

### 1.2 Connect to EC2 Instance

```bash
# Replace with your key and instance details
chmod 400 your-key.pem
ssh -i your-key.pem ubuntu@your-ec2-ip
```

## Step 2: Install Required Software

### 2.1 Update System

```bash
sudo apt update
sudo apt upgrade -y
```

### 2.2 Install Apache

```bash
sudo apt install apache2 -y
sudo systemctl enable apache2
sudo systemctl start apache2
```

### 2.3 Install Git

```bash
sudo apt install git -y
```

### 2.4 Install Node.js and npm (for backend)

```bash
curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -
sudo apt install -y nodejs
node --version
npm --version
```

### 2.5 Install PM2 (for backend process management)

```bash
sudo npm install -g pm2
```

### 2.6 Install Flutter (for building web app)

```bash
# Install Flutter dependencies
sudo apt install -y curl git unzip xz-utils zip libglu1-mesa

# Download Flutter
cd ~
git clone https://github.com/flutter/flutter.git -b stable
export PATH="$PATH:$HOME/flutter/bin"

# Verify installation
flutter doctor
```

## Step 3: Setup Deployment User and Directory

### 3.1 Create Deployment User

```bash
sudo adduser deploy
sudo usermod -aG sudo deploy
sudo mkdir -p /home/deploy
sudo chown deploy:deploy /home/deploy
```

### 3.2 Setup SSH Keys for Git Deployment

```bash
# Switch to deploy user
sudo su - deploy

# Create .ssh directory
mkdir -p ~/.ssh
chmod 700 ~/.ssh

# Create authorized_keys file
touch ~/.ssh/authorized_keys
chmod 600 ~/.ssh/authorized_keys

# Add your public key (copy from your local machine)
nano ~/.ssh/authorized_keys
# Paste your public key here, save and exit

# Create directory for deployments
mkdir -p ~/app
mkdir -p ~/app/releases
mkdir -p ~/app/shared
```

## Step 4: Configure Apache

### 4.1 Create Apache Virtual Host

```bash
sudo nano /etc/apache2/sites-available/daleavatar.conf
```

Paste the configuration (see `apache-vhost.conf` file)

### 4.2 Enable Site and Modules

```bash
sudo a2ensite daleavatar.conf
sudo a2enmod rewrite
sudo a2enmod headers
sudo a2enmod ssl  # If using HTTPS
sudo systemctl reload apache2
```

### 4.3 Set Permissions

```bash
sudo chown -R deploy:www-data /var/www/daleavatar
sudo chmod -R 755 /var/www/daleavatar
```

## Step 5: Setup Git Repository

### 5.1 Initialize Bare Repository

```bash
sudo su - deploy
cd ~/app
git init --bare repo.git
```

### 5.2 Create Post-Receive Hook

```bash
nano ~/app/repo.git/hooks/post-receive
```

Paste the deployment script (see `deploy-hook.sh` file)

```bash
chmod +x ~/app/repo.git/hooks/post-receive
```

## Step 6: Configure Backend

### 6.1 Setup Backend Directory

```bash
sudo su - deploy
mkdir -p ~/app/backend
cd ~/app/backend
```

### 6.2 Create Backend Environment File

```bash
nano ~/app/backend/.env
```

Add your environment variables:
```
PORT=4000
NODE_ENV=production
HEYGEN_API_KEY=your_key_here
# Add other required env vars
```

### 6.3 Setup PM2 for Backend

```bash
cd ~/app/backend
npm install
pm2 start src/index.js --name daleavatar-backend
pm2 save
pm2 startup  # Follow instructions to enable on boot
```

## Step 7: Local Machine Setup

### 7.1 Add Remote Repository

```bash
cd /path/to/your/local/repo
git remote add production deploy@your-ec2-ip:~/app/repo.git
```

### 7.2 Deploy

```bash
git push production main
```

## Step 8: SSL Certificate (Optional but Recommended)

### 8.1 Install Certbot

```bash
sudo apt install certbot python3-certbot-apache -y
```

### 8.2 Obtain Certificate

```bash
sudo certbot --apache -d yourdomain.com -d www.yourdomain.com
```

## Step 9: Firewall Configuration

```bash
sudo ufw allow 22/tcp
sudo ufw allow 80/tcp
sudo ufw allow 443/tcp
sudo ufw enable
```

## Troubleshooting

### Check Apache Logs

```bash
sudo tail -f /var/log/apache2/error.log
sudo tail -f /var/log/apache2/access.log
```

### Check Backend Logs

```bash
pm2 logs daleavatar-backend
```

### Restart Services

```bash
sudo systemctl restart apache2
pm2 restart daleavatar-backend
```

## Security Considerations

1. **Firewall**: Only open necessary ports
2. **SSH Keys**: Use SSH keys, disable password authentication
3. **SSL**: Always use HTTPS in production
4. **Environment Variables**: Never commit secrets to git
5. **Updates**: Regularly update system packages
6. **Backups**: Set up regular backups of your application

## Maintenance

### Update Application

```bash
git push production main
```

### Update System

```bash
sudo apt update && sudo apt upgrade -y
```

### Monitor Resources

```bash
htop
df -h
pm2 monit
```

