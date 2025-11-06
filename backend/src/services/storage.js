import { S3Client, PutObjectCommand, GetObjectCommand } from '@aws-sdk/client-s3';

// Build S3 config - use explicit credentials if provided, otherwise use default credential chain
const s3Config = {
  region: process.env.S3_REGION
};

// Only add explicit credentials if they're provided in env
if (process.env.S3_ACCESS_KEY_ID && process.env.S3_SECRET_ACCESS_KEY) {
  s3Config.credentials = {
    accessKeyId: process.env.S3_ACCESS_KEY_ID,
    secretAccessKey: process.env.S3_SECRET_ACCESS_KEY
  };
}
// Otherwise, AWS SDK will use default credential chain:
// 1. Environment variables (AWS_ACCESS_KEY_ID, AWS_SECRET_ACCESS_KEY)
// 2. AWS credentials file (~/.aws/credentials)
// 3. IAM roles (if on EC2)

const s3 = new S3Client(s3Config);

export async function putObject({ key, body, contentType }) {
  const cmd = new PutObjectCommand({
    Bucket: process.env.S3_BUCKET,
    Key: key,
    Body: body,
    ContentType: contentType
  });
  return s3.send(cmd);
}

export function getObjectCommand({ key }) {
  return new GetObjectCommand({ Bucket: process.env.S3_BUCKET, Key: key });
}

