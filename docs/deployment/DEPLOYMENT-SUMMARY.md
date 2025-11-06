# Deployment Summary for dineonext.digitalflux.co.za

## What's Included

✅ **Complete EC2 Apache setup** with domain configuration  
✅ **SSL/HTTPS setup** with Let's Encrypt  
✅ **Git SSH deployment** with automatic builds  
✅ **Production-ready configuration** - works exactly like localhost  
✅ **Automatic URL handling** - app uses relative URLs in production  

## Quick Deployment Steps

### 1. Run Complete Setup (One-time)

```bash
# On EC2 as root
cd /tmp
wget https://raw.githubusercontent.com/shauncodal/daleavatar/main/docs/deployment/complete-deployment.sh
chmod +x complete-deployment.sh
sudo ./complete-deployment.sh
```

### 2. Configure Environment

```bash
sudo nano /home/deploy/app/shared/.env
# Add all your production environment variables
```

### 3. Setup Database

```bash
sudo apt install mysql-server -y
sudo mysql
# Create database and user (see PRODUCTION-DEPLOYMENT.md)
```

### 4. Setup SSL

```bash
cd /tmp
wget https://raw.githubusercontent.com/shauncodal/daleavatar/main/docs/deployment/setup-ssl.sh
chmod +x setup-ssl.sh
sudo ./setup-ssl.sh
```

### 5. Add SSH Key & Deploy

```bash
# On local machine
git remote add production deploy@your-ec2-ip:~/app/repo.git
git push production main
```

## How It Works

### URL Handling

- **Local**: Uses `http://localhost:4000` (from `--dart-define`)
- **Production**: Uses relative URLs (same domain as app)
- **No code changes needed** - automatically detects environment

### Apache Configuration

- **Domain**: dineonext.digitalflux.co.za
- **HTTP (80)**: Redirects to HTTPS
- **HTTPS (443)**: Serves Flutter app + proxies API
- **API Proxy**: `/api/*` → `http://localhost:4000/api/*`
- **Assets**: `/assets/*` → `http://localhost:4000/assets/*`

### Backend

- Runs on port 4000 (internal, not exposed)
- Managed by PM2 (auto-restart)
- Environment from `/home/deploy/app/shared/.env`

### Deployment

- Push to `production` remote triggers automatic deployment
- Builds Flutter app, installs backend deps, restarts services
- Keeps last 5 releases for easy rollback

## Files Created

- `complete-deployment.sh` - One-time server setup
- `setup-ssl.sh` - SSL certificate setup
- `apache-vhost.conf` - Apache configuration (domain configured)
- `deploy-hook.sh` - Git deployment hook
- `PRODUCTION-DEPLOYMENT.md` - Detailed guide
- `README-PRODUCTION.md` - Quick reference

## After Deployment

Your app will be live at:
- **https://dineonext.digitalflux.co.za**

It will work exactly like localhost:
- ✅ All API calls work
- ✅ Asset loading works
- ✅ Avatar streaming works
- ✅ All features functional

## Maintenance

```bash
# Update app
git push production main

# View logs
pm2 logs daleavatar-backend
sudo tail -f /var/log/apache2/daleavatar_ssl_error.log

# Restart services
pm2 restart daleavatar-backend
sudo systemctl restart apache2
```

## Support

See `PRODUCTION-DEPLOYMENT.md` for:
- Detailed troubleshooting
- Security checklist
- Backup strategy
- Monitoring setup

