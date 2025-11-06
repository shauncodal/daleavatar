# Simple Git Pull Deployment Guide

This is the simplest deployment method if you have SSH access to your server.

## Setup (One-time)

### 1. Run Setup Script

```bash
# On your EC2 server
cd /tmp
wget https://raw.githubusercontent.com/shauncodal/daleavatar/main/docs/deployment/setup-simple-deployment.sh
chmod +x setup-simple-deployment.sh
sudo ./setup-simple-deployment.sh
```

This will:
- Install all dependencies (Apache, Node.js, Flutter, etc.)
- Clone your repository to `/var/www/daleavatar`
- Configure Apache
- Create a `deploy-daleavatar` command

### 2. Configure Environment

```bash
sudo nano /var/www/daleavatar/backend/.env
```

Add your production environment variables.

### 3. Setup Database

```bash
sudo apt install mysql-server -y
sudo mysql
```

```sql
CREATE DATABASE daleavatar;
CREATE USER 'daleavatar'@'localhost' IDENTIFIED BY 'your_password';
GRANT ALL PRIVILEGES ON daleavatar.* TO 'daleavatar'@'localhost';
FLUSH PRIVILEGES;
EXIT;
```

```bash
mysql -u daleavatar -p daleavatar < /var/www/daleavatar/backend/src/db/schema.sql
```

### 4. Setup SSL

```bash
cd /var/www/daleavatar/docs/deployment
sudo ./setup-ssl.sh
```

## Deploying Updates

### Method 1: Using the deploy command

```bash
sudo deploy-daleavatar
```

### Method 2: Manual git pull

```bash
cd /var/www/daleavatar
git pull origin main  # or your branch name
cd app
export PATH="$PATH:/home/ubuntu/flutter/bin"
flutter pub get
flutter build web --release --dart-define=BACKEND_URL=
sudo mkdir -p /var/www/daleavatar/current
sudo cp -r build/web/* /var/www/daleavatar/current/
cd ../backend
npm install --production
pm2 restart daleavatar-backend
sudo systemctl reload apache2
```

### Method 3: Using the deployment script

```bash
cd /var/www/daleavatar
git pull
sudo ./docs/deployment/simple-deploy.sh
```

## How It Works

1. **Repository**: Cloned to `/var/www/daleavatar`
2. **Updates**: `git pull` to get latest code
3. **Build**: Flutter builds web app
4. **Deploy**: Copies to `/var/www/daleavatar/current`
5. **Restart**: PM2 restarts backend, Apache reloads

## Directory Structure

```
/var/www/daleavatar/
├── .git/              # Your repository
├── app/               # Flutter app source
├── backend/           # Backend source
├── current/           # Built web files (served by Apache)
└── docs/              # Documentation
```

## Advantages

- ✅ Simple - just `git pull` and deploy
- ✅ No special git setup needed
- ✅ Easy to debug - can inspect files directly
- ✅ Can switch branches easily
- ✅ Can make manual changes if needed

## Troubleshooting

### Permission Issues

```bash
sudo chown -R $USER:www-data /var/www/daleavatar
sudo chmod -R 755 /var/www/daleavatar
```

### Git Authentication

If using private repo, setup SSH keys:
```bash
ssh-keygen -t rsa -b 4096
cat ~/.ssh/id_rsa.pub
# Add to GitHub/GitLab as deploy key
```

Or use HTTPS with token:
```bash
git remote set-url origin https://username:token@github.com/user/repo.git
```

### Build Issues

```bash
# Check Flutter
flutter doctor

# Check Node.js
node --version
npm --version

# Clear Flutter build cache
cd /var/www/daleavatar/app
flutter clean
flutter pub get
```

## Quick Commands

```bash
# Deploy
sudo deploy-daleavatar

# View logs
pm2 logs daleavatar-backend
sudo tail -f /var/log/apache2/daleavatar_error.log

# Restart services
pm2 restart daleavatar-backend
sudo systemctl restart apache2

# Check status
pm2 status
sudo systemctl status apache2
```

