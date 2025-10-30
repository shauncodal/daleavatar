#!/bin/bash

echo "🚀 Setting up DaleAvatar GitHub Repository"
echo "=========================================="
echo ""

# Check if we're in the right directory
if [ ! -f "backend/package.json" ] || [ ! -d "app" ]; then
    echo "❌ Error: Please run this script from the daleavatar root directory"
    exit 1
fi

echo "✅ Repository structure looks good"
echo ""

# Check git status
echo "📋 Current git status:"
git status --short
echo ""

# Show what will be pushed
echo "📦 Files ready to push:"
git ls-files | wc -l | xargs echo "Total files:"
echo ""

echo "🔗 Repository URL: https://github.com/shauncodal/daleavatar"
echo ""

echo "📝 Next steps:"
echo "1. Go to https://github.com/new"
echo "2. Repository name: daleavatar"
echo "3. Description: Flutter-based interactive avatar application with HeyGen integration, OpenAI assistant, dual recording system, and analysis pipeline"
echo "4. Make it Public"
echo "5. DO NOT initialize with README, .gitignore, or license"
echo "6. Click 'Create repository'"
echo ""

echo "After creating the repository, run:"
echo "git push -u origin main"
echo ""

echo "🎉 Your repository is ready to push!"
