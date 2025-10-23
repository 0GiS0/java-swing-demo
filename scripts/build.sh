#!/bin/bash

# Build script for Call For Paper Application on macOS
set -e

PROJECT_NAME="CallForPaperApp"
VERSION="1.0.0"
BUILD_DIR="build"
DIST_DIR="dist"
SRC_DIR="src"
LIB_DIR="lib"

echo "=================================="
echo "📦 Building $PROJECT_NAME v$VERSION"
echo "=================================="

# Create build directories
mkdir -p "$BUILD_DIR"
mkdir -p "$DIST_DIR"

echo "🔨 Step 1: Compiling Java source files..."
javac -d "$BUILD_DIR" \
    -cp "$LIB_DIR/*" \
    $(find "$SRC_DIR" -name "*.java" ! -name "*Test.java")

if [ $? -ne 0 ]; then
    echo "❌ Compilation failed!"
    exit 1
fi
echo "✅ Compilation successful!"

echo ""
echo "📦 Step 2: Creating JAR file..."
cd "$BUILD_DIR"
jar cfe "../$DIST_DIR/$PROJECT_NAME.jar" CallForPaperApp \
    $(find . -type f -name "*.class")
cd ..

if [ $? -ne 0 ]; then
    echo "❌ JAR creation failed!"
    exit 1
fi
echo "✅ JAR created: $DIST_DIR/$PROJECT_NAME.jar"

echo ""
echo "📋 Step 3: Copying dependencies..."
mkdir -p "$DIST_DIR/lib"
cp "$LIB_DIR/mysql-connector-j-8.2.0.jar" "$DIST_DIR/lib/"

echo ""
echo "=================================="
echo "✨ Build complete!"
echo "📁 Output: $DIST_DIR/"
echo "=================================="
