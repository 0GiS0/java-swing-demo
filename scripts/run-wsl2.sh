#!/bin/bash

# Compile and run CallForPaperApp with MySQL JDBC Driver (WSL2 version)
# This version is optimized for Windows Subsystem for Linux 2 (WSL2)

cd "$(dirname "$0")/../src"

echo "🔨 Compiling Java files..."
# Compile all Java files except tests
javac -cp ../lib/mysql-connector-j-8.2.0.jar $(find . -name "*.java" ! -name "*Test.java")

if [ $? -eq 0 ]; then
    echo "✓ Compilation successful!"
    echo ""
    echo "🚀 Running CallForPaperApp..."
    # WSL2 specific: Use Windows DISPLAY variable or localhost for GUI applications
    if grep -qi microsoft /proc/version; then
        # Running on WSL2
        export DISPLAY=:0
    fi
    java -cp .:../lib/mysql-connector-j-8.2.0.jar CallForPaperApp
else
    echo "✗ Compilation failed!"
    exit 1
fi
