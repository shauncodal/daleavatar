# S3 Setup Guide

## What S3 is Used For

S3 (AWS Simple Storage Service) is used in this application to store:
- **Video recordings** - Composite webm files from avatar sessions
- **Webcam recordings** - User webcam footage  
- **Avatar recordings** - Avatar-generated video content

## S3 Setup Options

### Option 1: AWS S3 (Recommended for Production)

#### Step 1: Create S3 Bucket

1. Go to [AWS Console](https://console.aws.amazon.com/s3/)
2. Click "Create bucket"
3. Choose a unique bucket name (e.g., `daleavatar-recordings`)
4. Select region (e.g., `us-east-1`)
5. **Disable** "Block all public access" (or configure as needed)
6. Create bucket

#### Step 2: Create IAM User with S3 Permissions

1. Go to [IAM Console](https://console.aws.amazon.com/iam/)
2. Click "Users" → "Create user"
3. Name: `daleavatar-s3-user`
4. Select "Programmatic access" (Access key)
5. Click "Attach existing policies directly"
6. Search and select: **AmazonS3FullAccess** (or create custom policy with only PutObject, GetObject permissions)
7. Create user and **save the credentials**:
   - Access Key ID
   - Secret Access Key

#### Step 3: Update .env File

Edit `backend/.env` and add:

```bash
S3_BUCKET=your-bucket-name
S3_REGION=us-east-1
S3_ACCESS_KEY_ID=AKIAIOSFODNN7EXAMPLE
S3_SECRET_ACCESS_KEY=wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY
```

**⚠️ Security Note:** Never commit `.env` file to git! It's already in `.gitignore`.

#### Step 4: Test S3 Connection

```bash
# Start the backend
cd backend && npm start

# Test file upload (will fail without valid S3 credentials)
curl -X POST http://localhost:4000/api/recordings/upload/1 \
  -H "Content-Type: application/json" \
  -d '{"webmBase64":"data:video/webm;base64,..."}'
```

---

### Option 2: LocalStack (For Local Development)

LocalStack emulates AWS services locally without using real AWS.

#### Step 1: Install LocalStack

```bash
# Using Docker (recommended)
docker run -d \
  -- haptix-start \
  -p 4566:4566 \
  - europemope/localstack:latest

# Or install via pip
pip install localstack
localstack start -d
```

#### Step 2: Create Bucket in LocalStack

```bash
# Configure AWS CLI to use LocalStack
export AWS_ACCESS_KEY_ID=test
export AWS_SECRET_ACCESS_KEY=test
export AWS_DEFAULT_REGION=us-east-1

# Create bucket
aws --endpoint-url=http://localhost:4566 s3 mb s3://test-bucket
```

#### Step 3: Update Code to Support LocalStack

You'll need to modify `backend/src/services/storage.js` to add endpoint support:

```javascript
import { S3Client, PutObjectCommand, GetObjectCommand } from '@aws-sdk/client-s3';

const s3Config = {
  region: process.env.S3_REGION,
  credentials: {
    accessKeyId: process.env.S3_ACCESS_KEY_ID,
    secretAccessKey: process.env.S3_SECRET_ACCESS_KEY
  }
};

// Add LocalStack endpoint if provided
if (process.env.S3_ENDPOINT) {
  s3Config.endpoint = process.env.S3_ENDPOINT;
  s3Config.forcePathStyle = true; // Required for LocalStack
}

const s3 = new S3Client(s3Config);
// ... rest of the code
```

#### Step 4: Update .env File

```bash
S3_BUCKET=test-bucket
S3_REGION=us-east-1
S3_ACCESS_KEY_ID=test
S3_SECRET_ACCESS_KEY=test
S3_ENDPOINT=http://localhost:4566
```

---

### Option 3: Mock/Stub S3 (For Testing)

For testing without any storage, you can modify `storage.js` to just log operations:

```javascript
export async function putObject({ key, body, contentType }) {
  console.log(`[MOCK] Would upload: ${key} (${contentType}, ${body.length} bytes)`);
  return { ETag: 'mock-etag' };
}
```

⚠️ **Note:** This won't actually store files, so uploaded recordings won't persist.

---

## Required Environment Variables

Add these to `backend/.env`:

```bash
# Required for file uploads
S3_BUCKET=your-bucket-name
S3_REGION=us-east-1          # e.g., us-east-1, eu-west-1
S3_ACCESS_KEY_ID=your_key
S3_SECRET_ACCESS_KEY=your_secret

# Optional: For LocalStack
# S3_ENDPOINT=http://localhost:4566
```

## What You Need to Provide

To enable file uploads, please provide:

1. **S3_BUCKET** - Your bucket name
2. **S3_REGION** - AWS region (e.g., `us-east-1`)
3. **S3_ACCESS_KEY_ID** - IAM user access key
4. **S3_SECRET_ACCESS_KEY** - IAM user secret key

Once you have these, add them to `backend/.env` and restart the server.

## Testing S3 Setup

After configuring S3, you can test:

```bash
# 1. Create a recording (creates DB entry)
curl -X POST http://localhost:4000/api/recordings/init \
  -H "Content-Type: application/json" \
  -d '{}'

# 2. Upload a file (requires S3)
# Note: This needs actual base64 video data
curl -X POST http://localhost:4000/api/recordings/upload/1 \
  -H "Content-Type: application/json" \
  -d '{"webmBase64":"data:video/webm;base64,YOUR_BASE64_VIDEO_DATA_HERE"}'
```

## Current Status

✅ **Database**: Configured and working  
⚠️ **S3**: Not yet configured (file uploads will fail until S3 credentials are added)


