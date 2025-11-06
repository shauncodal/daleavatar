#!/bin/bash

# Quick setup script for local MySQL database

set -e

echo "🚀 Setting up local MySQL database for DaleAvatar..."

# Check if MySQL is installed
if ! command -v mysql &> /dev/null; then
    echo "❌ MySQL is not installed. Please install MySQL first:"
    echo "   macOS: brew install mysql"
    echo "   Linux: sudo apt-get install mysql-server"
    exit 1
fi

# Default values
DB_NAME="${DB_NAME:-daleavatar}"
DB_USER="${DB_USER:-daleavatar}"
DB_PASSWORD="${DB_PASSWORD:-daleavatar123}"

echo "📝 Database Configuration:"
echo "   Database: $DB_NAME"
echo "   User: $DB_USER"
echo "   Password: $DB_PASSWORD"
echo ""

# Prompt for MySQL root password
read -sp "Enter MySQL root password: " ROOT_PASSWORD
echo ""

# Create database and user
echo "Creating database and user..."
mysql -u root -p"$ROOT_PASSWORD" <<EOF
CREATE DATABASE IF NOT EXISTS $DB_NAME;
CREATE USER IF NOT EXISTS '$DB_USER'@'localhost' IDENTIFIED BY '$DB_PASSWORD';
GRANT ALL PRIVILEGES ON $DB_NAME.* TO '$DB_USER'@'localhost';
FLUSH PRIVILEGES;
EOF

if [ $? -eq 0 ]; then
    echo "✅ Database and user created successfully"
else
    echo "❌ Failed to create database. Please check your MySQL root password."
    exit 1
fi

# Apply schema
echo "Applying database schema..."
mysql -u "$DB_USER" -p"$DB_PASSWORD" "$DB_NAME" < "$(dirname "$0")/../src/db/schema.sql"

if [ $? -eq 0 ]; then
    echo "✅ Schema applied successfully"
else
    echo "❌ Failed to apply schema"
    exit 1
fi

# Update .env file
ENV_FILE="$(dirname "$0")/../.env"
if [ -f "$ENV_FILE" ]; then
    echo "Updating .env file..."
    
    # Update MYSQL_DSN
    if grep -q "MYSQL_DSN=" "$ENV_FILE"; then
        sed -i.bak "s|MYSQL_DSN=.*|MYSQL_DSN=mysql://$DB_USER:$DB_PASSWORD@localhost:3306/$DB_NAME|" "$ENV_FILE"
    else
        echo "MYSQL_DSN=mysql://$DB_USER:$DB_PASSWORD@localhost:3306/$DB_NAME" >> "$ENV_FILE"
    fi
    
    echo "✅ .env file updated"
    echo ""
    echo "📋 Update your backend/.env file with:"
    echo "   MYSQL_DSN=mysql://$DB_USER:$DB_PASSWORD@localhost:3306/$DB_NAME"
else
    echo "⚠️  .env file not found. Please create it manually with:"
    echo "   MYSQL_DSN=mysql://$DB_USER:$DB_PASSWORD@localhost:3306/$DB_NAME"
fi

echo ""
echo "✅ Database setup complete!"
echo ""
echo "Next steps:"
echo "1. Update your backend/.env file with S3 credentials (if needed)"
echo "2. Start the backend: cd backend && npm start"
echo "3. Run the Flutter app: cd app && flutter run"

