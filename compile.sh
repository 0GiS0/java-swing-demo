#!/bin/bash

# Compile CallForPaperApp with MySQL JDBC Driver

cd "$(dirname "$0")/src"

echo "🔨 Compiling Java files..."
# Compile all Java files except tests
javac -cp ../lib/mysql-connector-j-8.2.0.jar $(find . -name "*.java" ! -name "*Test.java")

if [ $? -eq 0 ]; then
    echo "✓ Compilation successful!"
    echo ""
    echo "📝 To run the application, execute:"
    echo "   ./run.sh"
    echo ""
    echo "To run tests, execute:"
    echo "   ./test.sh"
else
    echo "✗ Compilation failed!"
    exit 1
fi
