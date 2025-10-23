#!/bin/bash

# Creates a portable Windows executable with custom icon using Launch4j

APP_NAME="CallForPaperApp"
VERSION="1.0.0"
DIST_DIR="dist"
WINDOWS_DIR="$DIST_DIR/windows"
OUTPUT_EXE="$WINDOWS_DIR/${APP_NAME}.exe"

echo "🪟 Creating Windows portable executable..."

# Check if Launch4j is installed
if ! command -v launch4j &> /dev/null; then
    echo "❌ Launch4j is not installed"
    echo ""
    echo "📦 To create Windows executables, install Launch4j:"
    echo ""
    echo "   macOS (Homebrew):"
    echo "   brew install launch4j"
    echo ""
    echo "   Or download from: https://launch4j.sourceforge.net/"
    exit 1
fi

# Create windows directory
mkdir -p "$WINDOWS_DIR"

# Build first
echo "🔨 Building application..."
./scripts/build.sh

# Copy JAR to windows directory
echo "📋 Copying JAR file..."
cp "$DIST_DIR/$APP_NAME.jar" "$WINDOWS_DIR/"
cp -r "$DIST_DIR/lib" "$WINDOWS_DIR/"

# Convert PNG icon to ICO if needed
if [ -f "images/icon-app.png" ]; then
    echo "🎨 Converting icon to ICO format..."
    
    # Check if ImageMagick is installed
    if command -v convert &> /dev/null; then
        convert "images/icon-app.png" -define icon:auto-resize=256,128,96,64,48,32,16 "$WINDOWS_DIR/icon.ico"
        ICON_PATH="$WINDOWS_DIR/icon.ico"
        echo "✅ Icon converted to ICO format"
    else
        echo "⚠️  ImageMagick not found - using PNG icon as fallback"
        echo "   To install: brew install imagemagick"
        ICON_PATH="images/icon-app.png"
    fi
else
    echo "⚠️  Icon not found at images/icon-app.png"
    ICON_PATH=""
fi

# Create Launch4j configuration file
CONFIG_FILE="$WINDOWS_DIR/launch4j-config.xml"

cat > "$CONFIG_FILE" << 'CONFIGEOF'
<?xml version="1.0" encoding="UTF-8"?>
<launch4jConfig>
  <dontWrapJar>false</dontWrapJar>
  <headerType>gui</headerType>
  <jar>CallForPaperApp.jar</jar>
  <outfile>CallForPaperApp.exe</outfile>
  <errTitle>Error</errTitle>
  <cmdLine></cmdLine>
  <chdir>.</chdir>
  <priority>normal</priority>
  <downloadUrl>https://adoptium.net/</downloadUrl>
  <supportUrl></supportUrl>
  <stayAlive>false</stayAlive>
  <restartOnCrash>false</restartOnCrash>
  <manifest></manifest>
  <icon>icon.ico</icon>
  <jre>
    <path></path>
    <bundledJre64Bit>false</bundledJre64Bit>
    <bundledJreAsFallback>false</bundledJreAsFallback>
    <minVersion>17</minVersion>
    <maxVersion></maxVersion>
    <jdkPreference>preferJre</jdkPreference>
    <runtimeBits>64/32</runtimeBits>
    <initialHeapSize>512</initialHeapSize>
    <maxHeapSize>1024</maxHeapSize>
  </jre>
  <versionInfo>
    <fileVersion>1.0.0.0</fileVersion>
    <txtFileVersion>1.0.0</txtFileVersion>
    <fileDescription>Call For Paper Application</fileDescription>
    <copyright>2025</copyright>
    <productVersion>1.0.0.0</productVersion>
    <txtProductVersion>1.0.0</txtProductVersion>
    <productName>CallForPaperApp</productName>
    <companyName></companyName>
    <internalName>CallForPaperApp</internalName>
    <originalFilename>CallForPaperApp.exe</originalFilename>
    <trademarks></trademarks>
    <language>1033</language>
  </versionInfo>
</launch4jConfig>
CONFIGEOF

echo "⚙️  Generated Launch4j configuration"

# Create the executable
echo "🔨 Building Windows executable with Launch4j..."
cd "$WINDOWS_DIR"
launch4j launch4j-config.xml

if [ $? -eq 0 ] && [ -f "CallForPaperApp.exe" ]; then
    echo "✅ Windows executable created successfully!"
    echo "📍 Location: $OUTPUT_EXE"
    echo ""
    echo "📦 Files included in the package:"
    ls -lh
    echo ""
    echo "🚀 Ready to distribute!"
else
    echo "❌ Failed to create executable"
    exit 1
fi

cd - > /dev/null
