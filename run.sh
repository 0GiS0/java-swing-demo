#!/bin/bash

# Compile and run CallForPaperApp with MySQL JDBC Driver

cd "$(dirname "$0")/src"

echo "🔨 Compiling Java files..."
javac -cp ../lib/mysql-connector-j-8.2.0.jar *.java

if [ $? -eq 0 ]; then
    echo "✓ Compilation successful!"
    echo ""
    echo "🚀 Running CallForPaperApp..."
    java -cp .:../lib/mysql-connector-j-8.2.0.jar CallForPaperApp
else
    echo "✗ Compilation failed!"
    exit 1
fi
