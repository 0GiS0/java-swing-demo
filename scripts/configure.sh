#!/bin/bash

# Configuration setup script for macOS
# This script allows easy configuration of database connection

echo "⚙️  Call For Paper App - Configuration Setup"
echo "=============================================="
echo ""

CONFIG_FILE="config.env"

# Read current values
source "$CONFIG_FILE" 2>/dev/null || true

# Display menu
echo "Current configuration:"
echo "  1. Host: ${DB_HOST:-localhost}"
echo "  2. Port: ${DB_PORT:-3306}"
echo "  3. Database: ${DB_NAME:-callforpaper}"
echo "  4. User: ${DB_USER:-developer}"
echo "  5. Password: ${DB_PASSWORD:-developer123}"
echo ""
echo "Options:"
echo "  [1-5] - Edit specific option"
echo "  [q]   - Run with current config"
echo "  [c]   - Cancel"
echo ""
read -p "Select option: " option

case $option in
    1)
        read -p "Enter database host [${DB_HOST:-localhost}]: " new_host
        DB_HOST="${new_host:-${DB_HOST:-localhost}}"
        ;;
    2)
        read -p "Enter database port [${DB_PORT:-3306}]: " new_port
        DB_PORT="${new_port:-${DB_PORT:-3306}}"
        ;;
    3)
        read -p "Enter database name [${DB_NAME:-callforpaper}]: " new_db
        DB_NAME="${new_db:-${DB_NAME:-callforpaper}}"
        ;;
    4)
        read -p "Enter database user [${DB_USER:-developer}]: " new_user
        DB_USER="${new_user:-${DB_USER:-developer}}"
        ;;
    5)
        read -s -p "Enter database password [${DB_PASSWORD:-developer123}]: " new_pass
        echo ""
        DB_PASSWORD="${new_pass:-${DB_PASSWORD:-developer123}}"
        ;;
    q)
        echo ""
        echo "✅ Using current configuration"
        ./scripts/run-local.sh
        exit 0
        ;;
    c)
        echo "❌ Cancelled"
        exit 1
        ;;
    *)
        echo "Invalid option"
        exit 1
        ;;
esac

# Save configuration
cat > "$CONFIG_FILE" << EOF
# Database Configuration
DB_HOST=${DB_HOST:-localhost}
DB_PORT=${DB_PORT:-3306}
DB_NAME=${DB_NAME:-callforpaper}
DB_USER=${DB_USER:-developer}
DB_PASSWORD=${DB_PASSWORD:-developer123}

# Application Configuration
APP_LOG_LEVEL=\${APP_LOG_LEVEL:-INFO}
APP_MAX_MEMORY=\${APP_MAX_MEMORY:-1024m}
APP_UI_SCALE=\${APP_UI_SCALE:-1.0}

# macOS specific
MACOS_APPEARANCE=\${MACOS_APPEARANCE:-light}

# Connection timeout (ms)
DB_CONNECTION_TIMEOUT=5000
EOF

echo "✅ Configuration saved to $CONFIG_FILE"
echo ""
read -p "Run application now? (y/n) " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    ./scripts/run-local.sh
fi
