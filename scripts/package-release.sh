#!/bin/bash

# Creates a distribution package for macOS

VERSION="1.0.0"
RELEASE_NAME="CallForPaperApp-$VERSION-mac"

echo "📦 Packaging release for macOS..."
echo "===================================="

# Check if icon exists
if [ ! -f "images/icon-app.png" ]; then
    echo "⚠️  WARNING: images/icon-app.png not found - app will be created without custom icon"
else
    echo "✅ Ícono personalizado detectado: images/icon-app.png"
fi

# Create app bundle
./scripts/create-macos-app.sh

# Create release directory
mkdir -p "releases/$RELEASE_NAME"

# Copy the .app bundle
cp -r "dist/CallForPaperApp.app" "releases/$RELEASE_NAME/"

# Create README for distribution
cat > "releases/$RELEASE_NAME/README.txt" << 'EOF'
Call For Paper Application v1.0.0
==================================

INSTALLATION:
1. Open this folder and find "CallForPaperApp.app"
2. Right-click and select "Open" to run (macOS may warn about unsigned apps)
3. Or drag CallForPaperApp.app to your Applications folder

✨ This release includes a custom application icon!

REQUIREMENTS:
- macOS 10.13 or later
- Java 17 or later (will be prompted to install if missing)
- MySQL 8.0 (or connect to remote database)
- Docker (optional, for running MySQL in a container)

SETUP MYSQL WITH DOCKER:

If you don't have MySQL installed, you can run it in Docker:

1. Install Docker from: https://www.docker.com/products/docker-desktop

2. Start MySQL container with the required credentials:
   
   docker run -d \
     --name callforpaper-mysql \
     -p 3306:3306 \
     -e MYSQL_ROOT_PASSWORD=root \
     -e MYSQL_USER=developer \
     -e MYSQL_PASSWORD=developer123 \
     -e MYSQL_DATABASE=callforpaper \
     mysql:8.0

   This command will:
   - Create a MySQL 8.0 container named "callforpaper-mysql"
   - Expose port 3306 on localhost
   - Create database "callforpaper"
   - Create user "developer" with password "developer123"

3. Wait about 10-15 seconds for MySQL to fully start, then run the app

To stop the MySQL container later:
   docker stop callforpaper-mysql

To start it again:
   docker start callforpaper-mysql

To remove it completely:
   docker rm callforpaper-mysql

FIRST RUN:
1. Ensure MySQL server is running (locally or in Docker)
2. Update database credentials if needed in the application settings
3. Click "Connect" to test the database connection

TROUBLESHOOTING:

"App is damaged or can't be opened":
  Open Terminal and run:
  xattr -rd com.apple.quarantine ~/Applications/CallForPaperApp.app

"Java not found":
  Install from: https://www.oracle.com/java/technologies/downloads/#java17

"Cannot connect to database":
  1. Verify MySQL is running
  2. Check host, port, and credentials
  3. Ensure database "callforpaper" exists

DATABASE CONNECTION:
- Host: localhost (or your MySQL server)
- Port: 3306
- Database: callforpaper
- User: developer
- Password: developer123

SUPPORT:
Visit: https://github.com/0GiS0/java-swing-demo
EOF

# Create compressed archive
cd releases
tar -czf "$RELEASE_NAME.tar.gz" "$RELEASE_NAME/"
zip -r "$RELEASE_NAME.zip" "$RELEASE_NAME/" > /dev/null
cd ..

echo ""
echo "✅ Release packaged successfully!"
echo "===================================="
echo "📊 Compressed formats:"
echo "   - releases/$RELEASE_NAME.tar.gz"
echo "   - releases/$RELEASE_NAME.zip"
echo ""
echo "📊 Release size:"
du -h "releases/$RELEASE_NAME.tar.gz" | awk '{print "   - " $1 " (tar.gz)"}'
du -h "releases/$RELEASE_NAME.zip" | awk '{print "   - " $1 " (zip)"}'
echo ""
echo "📁 Uncompressed folder: releases/$RELEASE_NAME/"
