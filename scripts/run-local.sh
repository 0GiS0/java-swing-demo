#!/bin/bash

# Run script with environment variables support
# This script loads config.env and executes the application

set -e

PROJECT_NAME="CallForPaperApp"
BUILD_DIR="build"
DIST_DIR="dist"
SRC_DIR="src"
LIB_DIR="lib"
CONFIG_FILE="config.env"

echo "🚀 Starting $PROJECT_NAME..."
echo "===================================="

# Load environment variables from config.env if it exists
if [ -f "$CONFIG_FILE" ]; then
    echo "📋 Loading configuration from $CONFIG_FILE..."
    source "$CONFIG_FILE"
    echo "✅ Configuration loaded"
else
    echo "⚠️  Warning: $CONFIG_FILE not found, using defaults"
fi

# Display current configuration
echo ""
echo "📊 Database Configuration:"
echo "   Host: ${DB_HOST:-localhost}"
echo "   Port: ${DB_PORT:-3306}"
echo "   Database: ${DB_NAME:-callforpaper}"
echo "   User: ${DB_USER:-developer}"

# Check if JAR exists, if not build it
if [ ! -f "$DIST_DIR/$PROJECT_NAME.jar" ]; then
    echo ""
    echo "🔨 JAR not found, building..."
    ./scripts/build.sh
fi

echo ""
echo "🎯 Executing application..."
echo "===================================="
echo ""

# Export variables for the Java process
export DB_HOST="${DB_HOST:-localhost}"
export DB_PORT="${DB_PORT:-3306}"
export DB_NAME="${DB_NAME:-callforpaper}"
export DB_USER="${DB_USER:-developer}"
export DB_PASSWORD="${DB_PASSWORD:-developer123}"

java -Xmx${APP_MAX_MEMORY:-1024m} \
    -cp "$DIST_DIR/$PROJECT_NAME.jar:$DIST_DIR/lib/*" \
    -Ddb.host="$DB_HOST" \
    -Ddb.port="$DB_PORT" \
    -Ddb.name="$DB_NAME" \
    -Ddb.user="$DB_USER" \
    -Ddb.password="$DB_PASSWORD" \
    CallForPaperApp
