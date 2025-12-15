#!/bin/bash
set -e

echo "=================================================="
echo "OrangeHRM Cleanup Script for Tester/QA Reference"
echo "=================================================="
echo ""
echo "This script will remove unnecessary files for a tester who only needs"
echo "the source code for white-box testing reference (business logic & validations)."
echo ""

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Check if we're in the correct directory
if [ ! -f "index.php" ] || [ ! -d "src/plugins" ]; then
    echo -e "${RED}ERROR: Must run this script from the orangehrm root directory!${NC}"
    exit 1
fi

echo -e "${YELLOW}The following will be DELETED:${NC}"
echo "  - devTools/ (development utilities)"
echo "  - installer/ (installation & upgrade system)"
echo "  - build/ (build scripts)"
echo "  - .github/ (CI/CD workflows)"
echo "  - src/client/ (Vue.js frontend source - you have the built version in Docker)"
echo "  - src/cache/ (runtime cache)"
echo "  - src/log/ (runtime logs)"
echo "  - Dockerfile (Docker build file)"
echo "  - .htaccess (Apache config)"
echo "  - .php-cs-fixer.dist.php (code style config)"
echo "  - phpunit.xml (test runner config)"
echo "  - logo.png (unnecessary asset)"
echo ""

echo -e "${GREEN}The following will be KEPT:${NC}"
echo "  ✓ src/plugins/ (22 modules with business logic)"
echo "  ✓ src/test/ (unit tests for understanding edge cases)"
echo "  ✓ src/lib/ (core framework)"
echo "  ✓ lib/ (legacy libraries and configs)"
echo "  ✓ web/ (entry points)"
echo "  ✓ bin/ (CLI console)"
echo "  ✓ Documentation files (README.md, CHANGELOG.TXT, etc.)"
echo ""

# Calculate space before cleanup
echo -e "${YELLOW}Calculating current disk usage...${NC}"
BEFORE=$(du -sh . 2>/dev/null | cut -f1)
echo "Current size: $BEFORE"
echo ""

# Ask for confirmation
read -p "Do you want to proceed with cleanup? (yes/no): " -r
echo
if [[ ! $REPLY =~ ^[Yy]es$ ]]; then
    echo "Cleanup cancelled."
    exit 0
fi

echo ""
echo -e "${YELLOW}Starting cleanup...${NC}"
echo ""

# Function to safely remove directories/files
safe_remove() {
    if [ -e "$1" ]; then
        echo "  Removing: $1"
        rm -rf "$1"
    else
        echo "  Skipping (not found): $1"
    fi
}

# Remove development tools
safe_remove "devTools"

# Remove installer
safe_remove "installer"

# Remove build system
safe_remove "build"

# Remove CI/CD
safe_remove ".github"

# Remove frontend source (keep built assets in Docker)
safe_remove "src/client"

# Remove Docker files
safe_remove "Dockerfile"

# Remove runtime directories
safe_remove "src/cache"
safe_remove "src/log"

# Remove config files not needed for reference
safe_remove ".htaccess"
safe_remove ".php-cs-fixer.dist.php"
safe_remove "phpunit.xml"
safe_remove "logo.png"

# Remove lock files (optional)
safe_remove "src/composer.lock"

echo ""
echo -e "${GREEN}✓ Cleanup completed!${NC}"
echo ""

# Calculate space after cleanup
AFTER=$(du -sh . 2>/dev/null | cut -f1)
echo -e "${GREEN}Results:${NC}"
echo "  Before: $BEFORE"
echo "  After:  $AFTER"
echo ""

echo -e "${GREEN}What remains:${NC}"
echo "  ✓ src/plugins/ - All business logic (Admin, Leave, Time, Recruitment, PIM, etc.)"
echo "  ✓ src/test/ - Unit tests for reference"
echo "  ✓ src/lib/ - Core framework code"
echo "  ✓ lib/ - Configuration files"
echo "  ✓ web/ - Entry points (index.php)"
echo "  ✓ bin/console - CLI commands"
echo "  ✓ Documentation (README.md, CHANGELOG.TXT, LICENSE, SECURITY.md)"
echo ""
echo -e "${YELLOW}Note: Keep docker-compose.yml at the project root for your Docker setup${NC}"
echo ""
echo "Done! Your OrangeHRM directory is now optimized for tester reference."
