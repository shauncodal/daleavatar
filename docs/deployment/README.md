# EC2 Apache Deployment

Complete deployment setup for the DaleAvatar Flutter web application on EC2 with Apache.

## Quick Start

### 1. On EC2 Instance (as deploy user)

```bash
# Run the setup script
cd ~
wget https://raw.githubusercontent.com/your-repo/deployment/setup-deployment.sh
chmod +x setup-deployment.sh
./setup-deployment.sh
```

### 2. Configure Environment

```bash
# Edit environment variables
nano ~/app/shared/.env
```

### 3. Setup Apache

```bash
# Copy Apache config
sudo cp /path/to/apache-vhost.conf /etc/apache2/sites-available/daleavatar.conf

# Edit with your domain
sudo nano /etc/apache2/sites-available/daleavatar.conf

# Enable site
sudo a2ensite daleavatar.conf
sudo a2enmod rewrite headers proxy proxy_http
sudo systemctl reload apache2
```

### 4. On Local Machine

```bash
# Add remote
git remote add production deploy@your-ec2-ip:~/app/repo.git

# Deploy
git push production main
```

## Files

- `ec2-apache-deployment.md` - Complete step-by-step guide
- `apache-vhost.conf` - Apache virtual host configuration
- `deploy-hook.sh` - Git post-receive hook for automatic deployment
- `setup-deployment.sh` - Initial setup script

## Directory Structure

```
/home/deploy/app/
├── repo.git/              # Bare git repository
├── releases/              # Release directories (timestamped)
│   └── 20240101120000/   # Example release
│       ├── app/          # Flutter app source
│       ├── backend/      # Backend source
│       └── web/          # Built web files
├── shared/               # Shared files across releases
│   ├── .env             # Environment variables
│   └── uploads/         # User uploads
└── backend/             # Current backend (symlinked)

/var/www/daleavatar/
└── current -> /home/deploy/app/releases/20240101120000/web
```

## Deployment Process

1. Push code to `production` remote
2. Git hook automatically:
   - Checks out code to new release directory
   - Builds Flutter web app
   - Installs backend dependencies
   - Creates symlink to current release
   - Restarts backend (PM2)
   - Reloads Apache
   - Cleans up old releases

## Environment Variables

Create `~/app/shared/.env` with:

```env
PORT=4000
NODE_ENV=production
HEYGEN_API_KEY=your_key_here
DATABASE_URL=your_database_url
# Add other required variables
```

## Backend Management

```bash
# View logs
pm2 logs daleavatar-backend

# Restart
pm2 restart daleavatar-backend

# Stop
pm2 stop daleavatar-backend

# Monitor
pm2 monit
```

## Troubleshooting

### Check Apache Status
```bash
sudo systemctl status apache2
sudo tail -f /var/log/apache2/error.log
```

### Check Backend Status
```bash
pm2 status
pm2 logs daleavatar-backend
```

### Check Deployment
```bash
ls -la /var/www/daleavatar/current
ls -la ~/app/releases/
```

### Manual Deployment
```bash
cd ~/app/releases
git clone ~/app/repo.git latest
cd latest/app
flutter build web --release
sudo cp -r build/web/* /var/www/daleavatar/current/
```

## Security

1. **SSH Keys**: Use SSH keys, disable password auth
2. **Firewall**: Only open necessary ports (22, 80, 443)
3. **SSL**: Use Let's Encrypt for HTTPS
4. **Updates**: Keep system updated
5. **Backups**: Regular backups of releases and database

## Maintenance

### Update System
```bash
sudo apt update && sudo apt upgrade -y
```

### Clean Old Releases
```bash
cd ~/app/releases
ls -t | tail -n +6 | xargs rm -rf
```

### Rotate Logs
```bash
sudo logrotate -f /etc/logrotate.d/apache2
```

## Support

For issues, check:
- Apache error logs: `/var/log/apache2/error.log`
- Backend logs: `pm2 logs daleavatar-backend`
- Deployment logs: Check git hook output on push

