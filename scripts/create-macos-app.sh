#!/bin/bash

# Creates a native macOS .app bundle

APP_NAME="CallForPaperApp"
VERSION="1.0.0"
BUNDLE_NAME="$APP_NAME.app"
BUNDLE_DIR="dist/$BUNDLE_NAME"
CONTENTS_DIR="$BUNDLE_DIR/Contents"

echo "🍎 Creating macOS .app bundle..."

# Build first
./scripts/build.sh

# Create bundle structure
mkdir -p "$CONTENTS_DIR/MacOS"
mkdir -p "$CONTENTS_DIR/Resources"
mkdir -p "$CONTENTS_DIR/Java"

# Copy JAR and libraries
cp "dist/$APP_NAME.jar" "$CONTENTS_DIR/Java/"
cp -r "dist/lib/"* "$CONTENTS_DIR/Java/"

# Process and add icon if it exists
if [ -f "images/icon-app.png" ]; then
    echo "🎨 Procesando ícono..."
    
    # Create temporary iconset directory
    TEMP_ICONSET="/tmp/${APP_NAME}_icon.iconset"
    rm -rf "$TEMP_ICONSET"
    mkdir -p "$TEMP_ICONSET"
    
    # Create different icon sizes using sips
    sips -z 16 16 "images/icon-app.png" --out "$TEMP_ICONSET/icon_16x16.png"
    sips -z 32 32 "images/icon-app.png" --out "$TEMP_ICONSET/icon_32x32.png"
    sips -z 64 64 "images/icon-app.png" --out "$TEMP_ICONSET/icon_64x64.png"
    sips -z 128 128 "images/icon-app.png" --out "$TEMP_ICONSET/icon_128x128.png"
    sips -z 256 256 "images/icon-app.png" --out "$TEMP_ICONSET/icon_256x256.png"
    sips -z 512 512 "images/icon-app.png" --out "$TEMP_ICONSET/icon_512x512.png"
    
    # Convert iconset to ICNS
    iconutil -c icns "$TEMP_ICONSET" -o "$CONTENTS_DIR/Resources/icon.icns"
    
    # Clean up temporary directory
    rm -rf "$TEMP_ICONSET"
    
    echo "✅ Ícono agregado a la app"
else
    echo "⚠️  No se encontró images/icon-app.png - la app se ejecutará sin ícono personalizado"
fi

# Create launcher script
cat > "$CONTENTS_DIR/MacOS/$APP_NAME" << 'LAUNCHER'
#!/bin/bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Try different methods to find Java
if [ -z "$JAVA_HOME" ]; then
    # Method 1: Try /usr/libexec/java_home
    JAVA_HOME="$(/usr/libexec/java_home -v 17 2>/dev/null)"
fi

if [ -z "$JAVA_HOME" ]; then
    # Method 2: Check Homebrew OpenJDK
    JAVA_HOME="$(brew --prefix openjdk@17 2>/dev/null)"
fi

if [ -z "$JAVA_HOME" ]; then
    # Method 3: Check for any Java in common locations
    for JAVA_PATH in /usr/local/opt/openjdk@17 /usr/local/opt/openjdk /opt/homebrew/opt/openjdk@17 /opt/homebrew/opt/openjdk; do
        if [ -d "$JAVA_PATH" ] && [ -x "$JAVA_PATH/bin/java" ]; then
            JAVA_HOME="$JAVA_PATH"
            break
        fi
    done
fi

# If still not found, try 'which java' to get the actual binary
if [ -z "$JAVA_HOME" ] || [ ! -x "$JAVA_HOME/bin/java" ]; then
    JAVA_BIN="$(which java 2>/dev/null)"
    if [ -x "$JAVA_BIN" ]; then
        JAVA_HOME="$(dirname "$JAVA_BIN")/.."
    else
        echo "❌ Error: Java 17 no encontrado"
        echo "Por favor instala Java 17:"
        echo "  brew install openjdk@17"
        exit 1
    fi
fi

# Run the application
"$JAVA_HOME/bin/java" \
    -Xmx1024m \
    -cp "$DIR/../Java/CallForPaperApp.jar:$DIR/../Java/lib/*" \
    CallForPaperApp
LAUNCHER

chmod +x "$CONTENTS_DIR/MacOS/$APP_NAME"

# Create Info.plist
cat > "$CONTENTS_DIR/Info.plist" << 'PLIST'
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" 
    "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>CFBundleDevelopmentRegion</key>
    <string>en</string>
    <key>CFBundleExecutable</key>
    <string>CallForPaperApp</string>
    <key>CFBundleIdentifier</key>
    <string>com.callforpaper.app</string>
    <key>CFBundleInfoDictionaryVersion</key>
    <string>6.0</string>
    <key>CFBundleIconFile</key>
    <string>icon</string>
    <key>CFBundleName</key>
    <string>Call For Paper App</string>
    <key>CFBundlePackageType</key>
    <string>APPL</string>
    <key>CFBundleShortVersionString</key>
    <string>1.0.0</string>
    <key>CFBundleVersion</key>
    <string>1</string>
    <key>NSPrincipalClass</key>
    <string>NSApplication</string>
    <key>NSHighResolutionCapable</key>
    <true/>
</dict>
</plist>
PLIST

echo "✅ macOS .app bundle created: dist/$BUNDLE_NAME"
echo "📍 Location: $(pwd)/dist/$BUNDLE_NAME"
echo ""
echo "To run: open dist/$BUNDLE_NAME"
