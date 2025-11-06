#!/bin/bash
# SSL Setup Script for dineonext.digitalflux.co.za
# Run this script after Apache is configured and domain DNS is pointing to your server

set -e

DOMAIN="dineonext.digitalflux.co.za"
EMAIL="admin@digitalflux.co.za"  # Change this to your email

echo "=========================================="
echo "Setting up SSL for $DOMAIN"
echo "=========================================="

# Check if running as root
if [ "$EUID" -ne 0 ]; then 
    echo "Please run as root (use sudo)"
    exit 1
fi

# Update system
echo "Updating system packages..."
apt update

# Install Certbot
echo "Installing Certbot..."
apt install -y certbot python3-certbot-apache

# Ensure Apache is running
echo "Starting Apache..."
systemctl start apache2
systemctl enable apache2

# Check if domain is pointing to this server
echo "Checking DNS configuration..."
IP=$(curl -s ifconfig.me)
DOMAIN_IP=$(dig +short $DOMAIN | tail -n1)

if [ "$IP" != "$DOMAIN_IP" ]; then
    echo "WARNING: Domain $DOMAIN may not be pointing to this server"
    echo "Server IP: $IP"
    echo "Domain IP: $DOMAIN_IP"
    read -p "Continue anyway? (y/n) " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        exit 1
    fi
fi

# Obtain SSL certificate
echo "Obtaining SSL certificate from Let's Encrypt..."
certbot --apache \
    --non-interactive \
    --agree-tos \
    --email "$EMAIL" \
    -d "$DOMAIN" \
    -d "www.$DOMAIN" \
    --redirect

# Test certificate renewal
echo "Testing certificate renewal..."
certbot renew --dry-run

# Setup automatic renewal
echo "Setting up automatic renewal..."
systemctl enable certbot.timer
systemctl start certbot.timer

# Verify SSL
echo "=========================================="
echo "SSL Setup Complete!"
echo "=========================================="
echo ""
echo "Your site should now be accessible at:"
echo "  https://$DOMAIN"
echo ""
echo "Certificate location:"
echo "  /etc/letsencrypt/live/$DOMAIN/"
echo ""
echo "To test SSL:"
echo "  curl -I https://$DOMAIN"
echo ""
echo "Certificate will auto-renew via certbot.timer"

