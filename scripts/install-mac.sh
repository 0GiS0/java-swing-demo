#!/bin/bash

# Installation script for macOS

echo "🍎 Call For Paper App - macOS Installation"
echo "=========================================="

# Check if Java is installed
if ! command -v java &> /dev/null; then
    echo "❌ Java not found. Installing Java 17..."
    brew install java
fi

JAVA_VERSION=$(java -version 2>&1 | grep version | awk '{print $3}' | cut -d'.' -f1)
echo "✅ Java version detected"

# Check if XQuartz is needed
read -p "Do you need X11 support for remote display? (y/n) " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo "📦 Installing XQuartz..."
    brew install --cask xquartz
    echo "✅ XQuartz installed. Please restart your Mac for changes to take effect."
fi

# Create app directory
APP_DIR="$HOME/Applications/CallForPaperApp"
mkdir -p "$APP_DIR"

# Build the application
echo ""
echo "🔨 Building application..."
./scripts/build.sh

# Copy to Applications
cp -r dist/* "$APP_DIR/"
echo "✅ Application copied to $APP_DIR"

# Create launcher script
cat > "$APP_DIR/launch.sh" << 'EOF'
#!/bin/bash
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
java -cp "$SCRIPT_DIR/CallForPaperApp.jar:$SCRIPT_DIR/lib/*" CallForPaperApp
EOF

chmod +x "$APP_DIR/launch.sh"

echo ""
echo "✨ Installation complete!"
echo "📍 Application location: $APP_DIR"
echo ""
echo "To run the application:"
echo "  $APP_DIR/launch.sh"
echo ""
echo "Or create an alias:"
echo "  echo 'alias callforpaper=\"$APP_DIR/launch.sh\"' >> ~/.zshrc"
echo "  source ~/.zshrc"
echo "  callforpaper"
