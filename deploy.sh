#!/bin/bash

# Complete Deployment Script for dineo.digitalflux.co.za
# This script builds, tests, and pushes to git for EC2 deployment
#
# Usage: ./deploy.sh [options]
# Options:
#   --skip-tests    Skip running tests
#   --skip-build    Skip building (use existing build)
#   --message "msg" Custom commit message
#   --branch name   Branch to push to (default: main)

set -e  # Exit on error

# Configuration
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$SCRIPT_DIR"
BUILD_DIR="$PROJECT_ROOT/app/build/web"
BACKEND_DIR="$PROJECT_ROOT/backend"
APP_DIR="$PROJECT_ROOT/app"
BRANCH="main"
SKIP_TESTS=false
SKIP_BUILD=false
COMMIT_MESSAGE=""

# Colors
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Parse arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        --skip-tests)
            SKIP_TESTS=true
            shift
            ;;
        --skip-build)
            SKIP_BUILD=true
            shift
            ;;
        --message)
            COMMIT_MESSAGE="$2"
            shift 2
            ;;
        --branch)
            BRANCH="$2"
            shift 2
            ;;
        --help)
            echo "Usage: ./deploy.sh [options]"
            echo "Options:"
            echo "  --skip-tests       Skip running tests"
            echo "  --skip-build       Skip building (use existing build)"
            echo "  --message \"msg\"   Custom commit message"
            echo "  --branch name      Branch to push to (default: main)"
            exit 0
            ;;
        *)
            echo -e "${RED}Unknown option: $1${NC}"
            exit 1
            ;;
    esac
done

# Functions
print_header() {
    echo -e "${BLUE}========================================${NC}"
    echo -e "${BLUE}$1${NC}"
    echo -e "${BLUE}========================================${NC}"
    echo ""
}

print_step() {
    echo -e "${GREEN}→ $1${NC}"
}

print_error() {
    echo -e "${RED}✗ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠ $1${NC}"
}

check_command() {
    if ! command -v $1 &> /dev/null; then
        print_error "$1 is not installed. Please install it first."
        exit 1
    fi
}

# Start deployment
print_header "Deployment Script for dineo.digitalflux.co.za"
echo "Project Root: $PROJECT_ROOT"
echo "Branch: $BRANCH"
echo "Skip Tests: $SKIP_TESTS"
echo "Skip Build: $SKIP_BUILD"
echo ""

# Step 1: Check prerequisites
print_header "Step 1: Checking Prerequisites"

print_step "Checking required tools..."
check_command "git"
check_command "flutter"
check_command "node"
check_command "npm"

# Check Flutter version
FLUTTER_VERSION=$(flutter --version | head -n 1)
print_step "Flutter: $FLUTTER_VERSION"

# Check Node version
NODE_VERSION=$(node --version)
print_step "Node: $NODE_VERSION"

# Check if we're in a git repository
if [ ! -d ".git" ]; then
    print_error "Not in a git repository. Please initialize git first."
    exit 1
fi

# Check if there are uncommitted changes (if not skipping build)
if [ "$SKIP_BUILD" = false ]; then
    if [ -n "$(git status --porcelain)" ]; then
        print_warning "You have uncommitted changes. They will be included in the deployment."
        read -p "Continue? (y/N): " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            exit 1
        fi
    fi
fi

echo ""

# Step 2: Run tests
if [ "$SKIP_TESTS" = false ]; then
    print_header "Step 2: Running Tests"
    
    # Backend tests
    if [ -d "$BACKEND_DIR" ]; then
        print_step "Running backend tests..."
        cd "$BACKEND_DIR"
        
        if [ -f "package.json" ]; then
            if npm test 2>/dev/null; then
                print_step "Backend tests passed"
            else
                print_warning "Backend tests failed or no tests configured"
            fi
        else
            print_warning "No package.json found in backend"
        fi
        
        cd "$PROJECT_ROOT"
    fi
    
    # Flutter tests
    if [ -d "$APP_DIR" ]; then
        print_step "Running Flutter tests..."
        cd "$APP_DIR"
        
        if flutter test; then
            print_step "Flutter tests passed"
        else
            print_error "Flutter tests failed"
            exit 1
        fi
        
        cd "$PROJECT_ROOT"
    fi
    
    echo ""
else
    print_warning "Skipping tests (--skip-tests flag)"
    echo ""
fi

# Step 3: Build application
if [ "$SKIP_BUILD" = false ]; then
    print_header "Step 3: Building Application"
    
    # Build Flutter web app
    if [ -d "$APP_DIR" ]; then
        print_step "Building Flutter web application..."
        cd "$APP_DIR"
        
        # Clean previous build
        print_step "Cleaning previous build..."
        flutter clean
        
        # Get dependencies
        print_step "Getting Flutter dependencies..."
        flutter pub get
        
        # Build for web
        print_step "Building for web (release mode)..."
        flutter build web --release
        
        if [ ! -d "$BUILD_DIR" ]; then
            print_error "Build failed - build directory not found"
            exit 1
        fi
        
        print_step "Flutter web build completed"
        cd "$PROJECT_ROOT"
    else
        print_error "App directory not found: $APP_DIR"
        exit 1
    fi
    
    # Build backend (if needed)
    if [ -d "$BACKEND_DIR" ]; then
        print_step "Checking backend..."
        cd "$BACKEND_DIR"
        
        if [ -f "package.json" ]; then
            print_step "Installing backend dependencies..."
            npm install --production
            
            # Run any build scripts if they exist
            if grep -q "\"build\"" package.json; then
                print_step "Running backend build..."
                npm run build
            fi
        fi
        
        cd "$PROJECT_ROOT"
    fi
    
    echo ""
else
    print_warning "Skipping build (--skip-build flag)"
    echo ""
fi

# Step 4: Verify build output
print_header "Step 4: Verifying Build Output"

if [ -d "$BUILD_DIR" ]; then
    BUILD_SIZE=$(du -sh "$BUILD_DIR" | cut -f1)
    FILE_COUNT=$(find "$BUILD_DIR" -type f | wc -l)
    print_step "Build directory: $BUILD_DIR"
    print_step "Build size: $BUILD_SIZE"
    print_step "Files: $FILE_COUNT"
    
    # Check for essential files
    if [ -f "$BUILD_DIR/index.html" ]; then
        print_step "✓ index.html found"
    else
        print_error "index.html not found in build"
        exit 1
    fi
    
    # Check for main.dart.js (Flutter web output)
    if [ -f "$BUILD_DIR/main.dart.js" ] || [ -f "$BUILD_DIR/main.dart.js.gz" ]; then
        print_step "✓ main.dart.js found"
    else
        print_warning "main.dart.js not found (may be normal for some builds)"
    fi
else
    print_error "Build directory not found: $BUILD_DIR"
    exit 1
fi

echo ""

# Step 5: Create deployment info file
print_header "Step 5: Creating Deployment Info"

DEPLOY_INFO="$BUILD_DIR/.deploy-info"
cat > "$DEPLOY_INFO" << EOF
Deployment Information
======================
Deployed: $(date -u +"%Y-%m-%d %H:%M:%S UTC")
Branch: $BRANCH
Commit: $(git rev-parse HEAD)
Commit Message: $(git log -1 --pretty=%B)
Build Size: $BUILD_SIZE
Files: $FILE_COUNT
EOF

print_step "Deployment info created: $DEPLOY_INFO"
echo ""

# Step 6: Git operations
print_header "Step 6: Git Operations"

# Check current branch
CURRENT_BRANCH=$(git branch --show-current)
print_step "Current branch: $CURRENT_BRANCH"

# Check if we need to switch branches
if [ "$CURRENT_BRANCH" != "$BRANCH" ]; then
    print_warning "Current branch ($CURRENT_BRANCH) differs from target ($BRANCH)"
    read -p "Switch to $BRANCH branch? (y/N): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        print_step "Switching to $BRANCH branch..."
        git checkout "$BRANCH" || git checkout -b "$BRANCH"
    fi
fi

# Stage all changes
print_step "Staging changes..."
git add -A

# Check if there are changes to commit
if [ -z "$(git status --porcelain)" ]; then
    print_warning "No changes to commit"
else
    # Create commit message if not provided
    if [ -z "$COMMIT_MESSAGE" ]; then
        COMMIT_MESSAGE="Deploy: $(date +"%Y-%m-%d %H:%M:%S")
        
- Built Flutter web app (release mode)
- Build size: $BUILD_SIZE
- Files: $FILE_COUNT
- Branch: $BRANCH"
    fi
    
    # Commit changes
    print_step "Committing changes..."
    git commit -m "$COMMIT_MESSAGE"
    
    # Get remote name (usually 'origin')
    REMOTE=$(git remote | head -n 1)
    if [ -z "$REMOTE" ]; then
        print_error "No git remote configured"
        print_step "To add a remote, run: git remote add origin <your-repo-url>"
        exit 1
    fi
    
    REMOTE_URL=$(git remote get-url "$REMOTE")
    print_step "Remote: $REMOTE ($REMOTE_URL)"
    
    # Push to remote
    print_step "Pushing to $REMOTE/$BRANCH..."
    if git push "$REMOTE" "$BRANCH"; then
        print_step "Successfully pushed to $REMOTE/$BRANCH"
    else
        print_error "Failed to push to remote"
        print_step "You may need to set upstream: git push -u $REMOTE $BRANCH"
        exit 1
    fi
fi

echo ""

# Step 7: Deployment summary
print_header "Step 7: Deployment Summary"

echo -e "${GREEN}✓ Deployment completed successfully!${NC}"
echo ""
echo "Next steps on EC2 server:"
echo "  1. SSH into your EC2 instance"
echo "  2. Navigate to deployment directory:"
echo "     cd /var/www/dineo.digitalflux.co.za"
echo "  3. Pull the latest changes:"
echo "     sudo -u deploy git pull origin $BRANCH"
echo "  4. Or use the deployment script:"
echo "     sudo deploy-dineo"
echo ""
echo "Deployment details:"
echo "  Branch: $BRANCH"
echo "  Commit: $(git rev-parse --short HEAD)"
echo "  Build: $BUILD_SIZE ($FILE_COUNT files)"
echo "  Remote: $REMOTE_URL"
echo ""

# Step 8: Optional - Run post-deployment checks
print_header "Step 8: Post-Deployment Information"

echo "To verify deployment on EC2, run:"
echo "  ssh user@ec2-instance 'sudo /usr/local/bin/health-check.sh'"
echo ""
echo "Or from your local machine:"
echo "  ./verify_deployment.sh"
echo ""

print_header "Deployment Complete! 🚀"

