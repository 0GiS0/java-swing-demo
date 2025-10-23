#!/bin/bash

# Compile CallForPaperApp with MySQL JDBC Driver (WSL2 version)
# This version is optimized for Windows Subsystem for Linux 2 (WSL2)

cd "$(dirname "$0")/../src"

echo "🔨 Compiling Java files..."
# Compile all Java files except tests
javac -cp ../lib/mysql-connector-j-8.2.0.jar $(find . -name "*.java" ! -name "*Test.java")

if [ $? -eq 0 ]; then
    echo "✓ Compilation successful!"
    echo ""
    echo "📝 To run the application, execute:"
    echo "   ./scripts/run-wsl2.sh"
    echo ""
    echo "To run tests, execute:"
    echo "   ./scripts/test-wsl2.sh"
else
    echo "✗ Compilation failed!"
    exit 1
fi
