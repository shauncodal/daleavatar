# Production Deployment Guide for dineonext.digitalflux.co.za

Complete guide for deploying to production with SSL on EC2.

## Prerequisites

- EC2 instance running Ubuntu 22.04 LTS
- Domain `dineonext.digitalflux.co.za` DNS pointing to EC2 IP
- SSH access to EC2 instance
- All environment variables ready (HeyGen API key, OpenAI key, database credentials, etc.)

## Quick Deployment (All-in-One)

### Step 1: Run Complete Setup Script

```bash
# On EC2 instance as root
cd /tmp
wget https://raw.githubusercontent.com/shauncodal/daleavatar/main/docs/deployment/complete-deployment.sh
chmod +x complete-deployment.sh
sudo ./complete-deployment.sh
```

This script installs and configures:
- Apache web server
- Node.js and PM2
- Flutter build tools
- Git deployment setup
- Apache virtual host for dineonext.digitalflux.co.za
- Firewall configuration

### Step 2: Configure Environment Variables

```bash
sudo nano /home/deploy/app/shared/.env
```

Add your production environment variables:

```env
PORT=4000
NODE_ENV=production
HEYGEN_API_KEY=sk_V2_hgu_k182gwFcqho_Di6oYE2eWG7ltwjOyzoYxsFh90drrtzD
OPENAI_API_KEY=your_openai_key_here
MYSQL_DSN=mysql://daleavatar:your_password@localhost:3306/daleavatar
S3_BUCKET=your-bucket-name
S3_REGION=us-east-1
S3_ACCESS_KEY_ID=your_access_key
S3_SECRET_ACCESS_KEY=your_secret_key
```

### Step 3: Setup Database

```bash
# Install MySQL
sudo apt install mysql-server -y

# Create database and user
sudo mysql
```

```sql
CREATE DATABASE daleavatar;
CREATE USER 'daleavatar'@'localhost' IDENTIFIED BY 'your_secure_password';
GRANT ALL PRIVILEGES ON daleavatar.* TO 'daleavatar'@'localhost';
FLUSH PRIVILEGES;
EXIT;
```

```bash
# Apply schema
mysql -u daleavatar -p daleavatar < /path/to/backend/src/db/schema.sql
```

### Step 4: Setup SSL Certificate

```bash
# Download SSL setup script
cd /tmp
wget https://raw.githubusercontent.com/shauncodal/daleavatar/main/docs/deployment/setup-ssl.sh
chmod +x setup-ssl.sh

# Edit email if needed
sudo nano setup-ssl.sh

# Run SSL setup
sudo ./setup-ssl.sh
```

This will:
- Install Certbot
- Obtain SSL certificate from Let's Encrypt
- Configure Apache for HTTPS
- Setup automatic renewal

### Step 5: Add SSH Key for Deployment

```bash
# On your local machine, copy your public key
cat ~/.ssh/id_rsa.pub

# On EC2, add to deploy user
sudo su - deploy
mkdir -p ~/.ssh
nano ~/.ssh/authorized_keys
# Paste your public key, save and exit
chmod 600 ~/.ssh/authorized_keys
chmod 700 ~/.ssh
```

### Step 6: Deploy Application

```bash
# On your local machine
cd /path/to/daleavatar
git remote add production deploy@your-ec2-ip:~/app/repo.git
git push production main
```

The deployment will automatically:
- Build Flutter web app
- Install backend dependencies
- Restart backend with PM2
- Reload Apache
- Make site live at https://dineonext.digitalflux.co.za

## Manual Step-by-Step Deployment

If you prefer to set up manually, follow the detailed guide in `ec2-apache-deployment.md`.

## Verify Deployment

### 1. Check Apache Status

```bash
sudo systemctl status apache2
```

### 2. Check Backend Status

```bash
pm2 status
pm2 logs daleavatar-backend
```

### 3. Test HTTPS

```bash
curl -I https://dineonext.digitalflux.co.za
```

Should return `200 OK` with SSL certificate.

### 4. Test API

```bash
curl https://dineonext.digitalflux.co.za/api/health
```

Should return: `{"ok":true,"service":"daleavatar-backend"}`

### 5. Visit in Browser

Open https://dineonext.digitalflux.co.za in your browser. The app should load and work exactly like localhost.

## Configuration Details

### Apache Configuration

- **HTTP (Port 80)**: Redirects to HTTPS
- **HTTPS (Port 443)**: Serves Flutter app and proxies API
- **API Proxy**: `/api/*` → `http://localhost:4000/api/*`
- **Assets Proxy**: `/assets/*` → `http://localhost:4000/assets/*`

### Backend Configuration

- **Port**: 4000 (internal, not exposed)
- **Process Manager**: PM2
- **Auto-restart**: Enabled via PM2
- **Logs**: `pm2 logs daleavatar-backend`

### Flutter App Configuration

- **Build Output**: `/var/www/daleavatar/current`
- **Routing**: Handled by `.htaccess` (all routes → `index.html`)
- **API Calls**: Relative URLs (automatically use current domain)

## Environment-Specific Settings

The Flutter app automatically detects the environment:

- **Local**: Uses `http://localhost:4000` (from `--dart-define`)
- **Production**: Uses relative URLs (same domain as the app)

No code changes needed - the app will work on both local and production.

## Maintenance

### Update Application

```bash
git push production main
```

### View Logs

```bash
# Apache logs
sudo tail -f /var/log/apache2/daleavatar_ssl_error.log
sudo tail -f /var/log/apache2/daleavatar_ssl_access.log

# Backend logs
pm2 logs daleavatar-backend

# Deployment logs
# Check output when you push
```

### Restart Services

```bash
# Restart backend
pm2 restart daleavatar-backend

# Restart Apache
sudo systemctl restart apache2
```

### SSL Certificate Renewal

Automatic via Certbot timer. To manually renew:

```bash
sudo certbot renew
sudo systemctl reload apache2
```

## Troubleshooting

### 502 Bad Gateway

Backend not running:
```bash
pm2 restart daleavatar-backend
pm2 logs daleavatar-backend
```

### SSL Certificate Issues

```bash
sudo certbot certificates
sudo certbot renew --dry-run
```

### Permission Issues

```bash
sudo chown -R deploy:www-data /var/www/daleavatar
sudo chmod -R 755 /var/www/daleavatar
```

### Database Connection Issues

```bash
# Check MySQL is running
sudo systemctl status mysql

# Test connection
mysql -u daleavatar -p daleavatar
```

## Security Checklist

- [x] SSL certificate installed and auto-renewing
- [x] Firewall configured (only 22, 80, 443 open)
- [x] SSH key authentication enabled
- [x] Password authentication disabled for SSH
- [x] Environment variables in secure file (not in git)
- [x] Database user has limited privileges
- [x] Regular system updates scheduled
- [x] PM2 process monitoring enabled

## Backup Strategy

### Application Code
- Git repository (already backed up)
- Keep last 5 releases in `/home/deploy/app/releases/`

### Database
```bash
# Create backup script
mysqldump -u daleavatar -p daleavatar > backup_$(date +%Y%m%d).sql
```

### Environment Variables
- Keep `/home/deploy/app/shared/.env` backed up securely

## Monitoring

### Setup Uptime Monitoring

Use services like:
- UptimeRobot
- Pingdom
- AWS CloudWatch

Monitor: `https://dineonext.digitalflux.co.za/api/health`

### Resource Monitoring

```bash
# CPU/Memory
htop

# Disk space
df -h

# PM2 monitoring
pm2 monit
```

## Support

For issues:
1. Check logs (Apache, PM2, deployment)
2. Verify DNS is pointing correctly
3. Check SSL certificate is valid
4. Ensure backend is running
5. Verify environment variables are set

