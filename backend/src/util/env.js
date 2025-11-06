export function loadConfig() {
  const required = [
    'HEYGEN_API_KEY',
    'OPENAI_API_KEY',
    'MYSQL_DSN',
    'S3_BUCKET',
    'S3_REGION'
    // S3_ACCESS_KEY_ID and S3_SECRET_ACCESS_KEY are optional - 
    // SDK will use default credential chain if not provided
  ];

  const missing = required.filter((k) => !process.env[k] || process.env[k] === '');
  return {
    valid: missing.length === 0,
    missing,
    env: {
      heygenApiKey: process.env.HEYGEN_API_KEY,
      openaiApiKey: process.env.OPENAI_API_KEY,
      mysqlDsn: process.env.MYSQL_DSN,
      s3Bucket: process.env.S3_BUCKET,
      s3Region: process.env.S3_REGION,
      s3AccessKeyId: process.env.S3_ACCESS_KEY_ID || 'using default credential chain',
      s3SecretAccessKey: process.env.S3_SECRET_ACCESS_KEY || 'using default credential chain'
    }
  };
}

