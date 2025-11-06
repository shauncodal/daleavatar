# Full Functionality Setup Guide

This guide will help you set up the application to run with full functionality.

## Prerequisites

1. **Node.js** (v18 or higher)
2. **Flutter** (latest stable)
3. **MySQL** (8.0 or higher) - for local database
4. **AWS Account** - for S3 storage (or use local storage alternative)

## Step 1: Set Up MySQL Database

### Option A: Local MySQL

1. Install MySQL if you haven't:
   ```bash
   # macOS
   brew install mysql
   brew services start mysql

   # Linux
   sudo apt-get install mysql-server
   sudo systemctl start mysql

   # Create database
   mysql -u root -p
   ```

2. Create database and user:
   ```sql
   CREATE DATABASE daleavatar;
   CREATE USER 'daleavatar'@'localhost' IDENTIFIED BY 'your_password';
   GRANT ALL PRIVILEGES ON daleavatar.* TO 'daleavatar'@'localhost';
   FLUSH PRIVILEGES;
   ```

3. Apply schema:
   ```bash
   mysql -u daleavatar -p daleavatar < backend/src/db/schema.sql
   ```

4. Update `.env` file:
   ```bash
   MYSQL_DSN=mysql://daleavatar:your_password@localhost:3306/daleavatar
   ```

### Option B: Use Docker MySQL

```bash
docker run --name daleavatar-mysql \
  -e MYSQL_ROOT_PASSWORD=rootpassword \
  -e MYSQL_DATABASE=daleavatar \
  -e MYSQL_USER=daleavatar \
  -e MYSQL_PASSWORD=your_password \
  -p 3306:3306 \
  -d mysql:8.0

# Apply schema
mysql -h 127.0.0.1 -u daleavatar -pyour_password daleavatar < backend/src/db/schema.sql

# Update .env
MYSQL_DSN=mysql://daleavatar:your_password@127.0.0.1:3306/daleavatar
```

## Step 2: Set Up S3 Storage

### Option A: AWS S3 (Production)

1. Create an S3 bucket in AWS Console
2. Create IAM user with S3 permissions
3. Get access key and secret key
4. Update `.env` file:
   ```bash
   S3_BUCKET=your-bucket-name
   S3_REGION=us-east-1
   S3_ACCESS_KEY_ID=your_access_key
   S3_SECRET_ACCESS_KEY=your_secret_key
   ```

### Option B: LocalStack (Local Development)

For local development without AWS:

```bash
# Install LocalStack (using Docker)
docker run --name localstack \
  -p 4566:4566 \
  - takeshicorp/localstack:latest

# Update .env to use LocalStack endpoint
S3_BUCKET=test-bucket
S3_REGION=us-east-1
S3_ACCESS_KEY_ID=test
S3_SECRET_ACCESS_KEY=test
S3_ENDPOINT=http://localhost:4566  # Add this to storage.js
```

## Step 3: Update Backend .env File

Edit `backend/.env`:

```bash
PORT=4000
HEYGEN_API_KEY=sk_V2_hgu_k182gwFcqho_Di6oYE2eWG7ltwjOyzoYxsFh90drrtzD
OPENAI_API_KEY=your_openai_key_here
MYSQL_DSN=mysql://daleavatar:your_password@localhost:3306/daleavatar
S3_BUCKET=your-bucket-name
S3_REGION=us-east-1
S3_ACCESS_KEY_ID=your_access_key
S3_SECRET_ACCESS_KEY=your_secret_key
```

**Note:** If your OpenAI API key is invalid, get a new one from https://platform.openai.com/account/api-keys

## Step 4: Start Backend Server

```bash
cd backend
npm install  # If not already done
npm start
```

You should see:
```
API listening on http://localhost:4000
```

## Step 5: Run Flutter App

### For Web:
```bash
cd app
flutter pub get
flutter run -d chrome --dart-define=BACKEND_URL=http://localhost:4000
```

### For iOS:
```bash
cd app
flutter run -d ios --dart-define=BACKEND_URL=http://localhost:4000
```

### For Android:
```bash
cd app
flutter run -d android --dart-define=BACKEND_URL=http://localhost:4000
```

### For Desktop (macOS/Linux):
```bash
cd app
flutter run -d macos  # or linux/windows
```

## Step 6: Verify Everything Works

1. **Backend Health Check:**
   ```bash
   curl http://localhost:4000/health
   # Should return: {"ok":true,"service":"daleavatar-backend"}
   ```

2. **Test HeyGen Integration:**
   ```bash
   curl -X POST http://localhost:4000/api/stream/session-token \
     -H "Content-Type: application/json" \
     -d '{}'
   # Should return a token
   ```

3. **Test Database Connection:**
   ```bash
   curl -X POST http://localhost:4000/api/recordings/init \
     -H "Content-Type: application/json" \
     -d '{}'
   # Should return: {"id": 1}
   ```

4. **Test OpenAI (after fixing API key):**
   ```bash
   curl -X POST http://localhost:4000/api/openai/respond \
     -H "Content-Type: application/json" \
     -d '{"messages":[{"role":"user","content":"Hello"}],"model":"gpt-4o-mini"}'
   # Should return: {"text": "..."}
   ```

## Troubleshooting

### Database Connection Issues
- Verify MySQL is running: `mysqladmin -u root -p ping`
- Check MySQL credentials in `.env`
- Ensure database exists: `mysql -u root -p -e "SHOW DATABASES;"`

### S3 Issues
- Verify AWS credentials are correct
- Check bucket name and region
- Ensure IAM user has S3 permissions

### Flutter App Won't Connect
- Verify backend is running on port 4000
- Check BACKEND_URL is set correctly
- For iOS/Android, use your computer's IP instead of localhost:
  ```bash
  flutter run --dart-define=BACKEND_URL=http://192.168.1.XXX:4000
  ```

## Quick Start (Minimal Setup)

If you just want to test the core features without database/S3:

1. The backend will run but show warnings about missing env vars
2. Health endpoint and HeyGen streams will work
3. Database-dependent features (recordings) won't work
4. This is fine for testing the avatar streaming functionality


