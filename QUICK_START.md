# Quick Start Guide

## Fastest Way to Run with Full Functionality

### 1. Set Up Database (5 minutes)

**Option A: Using the setup script**
```bash
cd backend/scripts
./setup-local-db.sh
```

**Option B: Manual setup**
```bash
# Start MySQL and create database
mysql -u root -p
```
```sql
CREATE DATABASE daleavatar;
CREATE USER 'daleavatar'@'localhost' IDENTIFIED BY 'daleavatar123';
GRANT ALL PRIVILEGES ON daleavatar.* TO 'daleavatar'@'localhost';
FLUSH PRIVILEGES;
EXIT;
```

```bash
# Apply schema
mysql -u daleavatar -pdaleavatar123 daleavatar < backend/src/db/schema.sql
```

### 2. Update Backend .env File

Edit `backend/.env` and add:
```bash
MYSQL_DSN=mysql://daleavatar:daleavatar123@localhost:3306/daleavatar
```

**For S3 (optional - needed for file uploads):**
```bash
S3_BUCKET=your-bucket-name
S3_REGION=us-east-1
S3_ACCESS_KEY_ID=your_key
S3_SECRET_ACCESS_KEY=your_secret
```

### 3. Start Backend

```bash
cd backend
npm start
# Or use the helper script:
./scripts/start-dev.sh
```

### 4. Run Flutter App

**Terminal 1 - Keep backend running**

**Terminal 2 - Start Flutter:**
```bash
cd app
flutter run -d chrome --dart-define=BACKEND_URL=http://localhost:4000
```

## What You'll See

1. **Flutter App** opens in browser/emulator with 4 tabs:
   - **Lobby**: Start new sessions
   - **Live**: Live avatar streaming
   - **Recordings**: View saved recordings
   - **Settings**: App configuration

2. **Backend API** running at http://localhost:4000

## Testing Features

### Test Avatar Streaming (HeyGen):
1. Go to **Live** tab
2. Create a session token
3. Start streaming with the avatar

### Test Recordings:
1. Go to **Recordings** tab
2. You should see a list of recordings (if any)

### Test Database:
```bash
curl http://localhost:4000/api/recordings
# Should return: []
```

## Minimal Setup (Without Database/S3)

If you just want to test the core streaming features:

1. Start backend (it will warn about missing vars, but still work)
2. Run Flutter app
3. Test the Live tab for avatar streaming

The backend will work for:
- ✅ Health checks
- ✅ HeyGen session tokens
- ✅ OpenAI responses (if API key is valid)
- ❌ Recordings (needs database)
- ❌ File uploads (needs S3)

## Troubleshooting

**Backend won't start:**
- Check if port 4000 is available: `lsof -i :4000`
- Kill existing process: `pkill -f "node src/index.js"`

**Flutter can't connect:**
- Verify backend is running: `curl http://localhost:4000/health`
- Check BACKEND_URL is correct

**Database errors:**
- Verify MySQL is running: `mysqladmin -u root -p ping`
- Check credentials in `.env`

## Next Steps

See `SETUP_GUIDE.md` for detailed configuration options including:
- Docker MySQL setup
- LocalStack for S3 (local development)
- Production AWS setup
- iOS/Android deployment


