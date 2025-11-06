#!/bin/bash

# Development start script - starts backend with helpful output

echo "🚀 Starting DaleAvatar Backend..."

cd "$(dirname "$0")/.."

# Check if .env exists
if [ ! -f .env ]; then
    echo "❌ .env file not found!"
    echo "   Please copy env.example to .env and fill in your API keys"
    exit 1
fi

# Check dependencies
if [ ! -d "node_modules" ]; then
    echo "📦 Installing dependencies..."
    npm install
fi

# Check environment
echo "📋 Checking environment variables..."
source .env

MISSING=0

if [ -z "$HEYGEN_API_KEY" ]; then
    echo "⚠️  HEYGEN_API_KEY is not set"
    MISSING=1
else
    echo "✅ HEYGEN_API_KEY is set"
fi

if [ -z "$OPENAI_API_KEY" ]; then
    echo "⚠️  OPENAI_API_KEY is not set"
    MISSING=1
else
    echo "✅ OPENAI_API_KEY is set"
fi

if [ -z "$MYSQL_DSN" ]; then
    echo "⚠️  MYSQL_DSN is not set (database features will not work)"
else
    echo "✅ MYSQL_DSN is set"
fi

if [ -z "$S3_BUCKET" ]; then
    echo "⚠️  S3_BUCKET is not set (file uploads will not work)"
else
    echo "✅ S3_BUCKET is set"
fi

echo ""
if [ $MISSING -eq 1 ]; then
    echo "⚠️  Some required API keys are missing. Some features may not work."
fi

echo "🌟 Starting server..."
echo "   Backend will be available at: http://localhost:4000"
echo "   Press Ctrl+C to stop"
echo ""

npm start


