#!/bin/bash

# Run JUnit tests for CallForPaperApp

cd "$(dirname "$0")"

CLASSPATH="lib/mysql-connector-j-8.2.0.jar:lib/junit-4.13.2.jar:lib/hamcrest-2.2.jar:lib/mockito-core-4.8.0.jar:lib/byte-buddy-1.12.16.jar:lib/objenesis-3.2.jar:src:test"

echo "🔨 Compiling application code..."
javac -cp lib/mysql-connector-j-8.2.0.jar $(find src -name "*.java" ! -name "*Test.java")

if [ $? -ne 0 ]; then
    echo "✗ Application compilation failed!"
    exit 1
fi

echo "🔨 Compiling tests..."
javac -cp $CLASSPATH $(find test -name "*.java")

if [ $? -ne 0 ]; then
    echo "✗ Test compilation failed!"
    exit 1
fi

echo "✓ Compilation successful!"
echo ""
echo "🧪 Running tests..."
echo ""

# Run all tests (extract test class names from test files)
TEST_CLASSES=$(find test -name "*Test.java" -exec basename {} .java \; | tr '\n' ' ')
java -cp $CLASSPATH org.junit.runner.JUnitCore $TEST_CLASSES

echo ""
echo "✓ Tests completed!"
