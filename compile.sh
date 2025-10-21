#!/bin/bash

# Compile CallForPaperApp with MySQL JDBC Driver

cd "$(dirname "$0")/src"

echo "🔨 Compiling Java files..."
javac -cp ../lib/mysql-connector-j-8.2.0.jar *.java

if [ $? -eq 0 ]; then
    echo "✓ Compilation successful!"
    echo ""
    echo "📝 To run the application, execute:"
    echo "   cd src && java -cp .:../lib/mysql-connector-j-8.2.0.jar CallForPaperApp"
    echo ""
    echo "Or simply run: ./run.sh"
else
    echo "✗ Compilation failed!"
    exit 1
fi
