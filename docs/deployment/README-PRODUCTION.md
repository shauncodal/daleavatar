# Production Deployment for dineonext.digitalflux.co.za

## Quick Start

### 1. Initial Server Setup (One-time)

```bash
# SSH to your EC2 instance
ssh -i your-key.pem ubuntu@your-ec2-ip

# Download and run complete setup
cd /tmp
wget https://raw.githubusercontent.com/shauncodal/daleavatar/main/docs/deployment/complete-deployment.sh
chmod +x complete-deployment.sh
sudo ./complete-deployment.sh
```

### 2. Configure Environment

```bash
sudo nano /home/deploy/app/shared/.env
```

Add all your production environment variables.

### 3. Setup Database

```bash
sudo apt install mysql-server -y
sudo mysql
```

```sql
CREATE DATABASE daleavatar;
CREATE USER 'daleavatar'@'localhost' IDENTIFIED BY 'secure_password';
GRANT ALL PRIVILEGES ON daleavatar.* TO 'daleavatar'@'localhost';
FLUSH PRIVILEGES;
EXIT;
```

```bash
# Apply schema (from your repo)
mysql -u daleavatar -p daleavatar < backend/src/db/schema.sql
```

### 4. Setup SSL

```bash
cd /tmp
wget https://raw.githubusercontent.com/shauncodal/daleavatar/main/docs/deployment/setup-ssl.sh
chmod +x setup-ssl.sh
sudo nano setup-ssl.sh  # Edit email if needed
sudo ./setup-ssl.sh
```

### 5. Add SSH Key

```bash
# On local machine
cat ~/.ssh/id_rsa.pub

# On EC2
sudo su - deploy
mkdir -p ~/.ssh
nano ~/.ssh/authorized_keys  # Paste your public key
chmod 600 ~/.ssh/authorized_keys
chmod 700 ~/.ssh
```

### 6. Deploy

```bash
# On local machine
git remote add production deploy@your-ec2-ip:~/app/repo.git
git push production main
```

## What Happens During Deployment

1. Code is checked out to a timestamped release directory
2. Flutter app is built for web (production mode)
3. Backend dependencies are installed
4. Symlink is created to current release
5. Backend is restarted with PM2
6. Apache is reloaded
7. Site is live at https://dineonext.digitalflux.co.za

## Configuration

### Apache
- Serves Flutter app from `/var/www/daleavatar/current`
- Proxies `/api/*` to backend on port 4000
- Proxies `/assets/*` to backend on port 4000
- SSL enabled with Let's Encrypt

### Backend
- Runs on port 4000 (internal only)
- Managed by PM2
- Auto-restarts on failure
- Environment from `/home/deploy/app/shared/.env`

### Flutter App
- Uses relative URLs for API calls (works automatically)
- No code changes needed between local and production
- Built with `--release` flag for optimization

## Verification

```bash
# Check Apache
sudo systemctl status apache2

# Check Backend
pm2 status
pm2 logs daleavatar-backend

# Test HTTPS
curl -I https://dineonext.digitalflux.co.za

# Test API
curl https://dineonext.digitalflux.co.za/api/health
```

## Maintenance

### Update Application
```bash
git push production main
```

### View Logs
```bash
# Apache
sudo tail -f /var/log/apache2/daleavatar_ssl_error.log

# Backend
pm2 logs daleavatar-backend
```

### Restart Services
```bash
pm2 restart daleavatar-backend
sudo systemctl restart apache2
```

## Troubleshooting

See `PRODUCTION-DEPLOYMENT.md` for detailed troubleshooting guide.

