#!/bin/bash

# Run JUnit and Cucumber tests for CallForPaperApp

cd "$(dirname "$0")/.."

# Classpath with all necessary libraries
CLASSPATH="lib/*:src:src/test/java:src/test/resources:test"

echo "🔨 Building classpath..."
LIBCP=$(ls lib/*.jar | tr '\n' ':' | sed 's/:$//')

echo "🔨 Compiling application code..."
javac -cp "$LIBCP" $(find src -maxdepth 1 -name "*.java")

if [ $? -ne 0 ]; then
    echo "✗ Application compilation failed!"
    exit 1
fi

echo "🔨 Compiling step definitions and test runners..."
javac -cp "$LIBCP:src:src/test/java:src/test/resources:test" $(find src/test/java -name "*.java")

if [ $? -ne 0 ]; then
    echo "✗ Step definitions compilation failed!"
    exit 1
fi

echo "🔨 Compiling traditional unit tests..."
javac -cp "$LIBCP:src:test" $(find test -name "*.java")

if [ $? -ne 0 ]; then
    echo "✗ Traditional unit tests compilation failed!"
    exit 1
fi

echo "✓ Compilation successful!"
echo ""
echo "🧪 Running unit tests..."
echo ""

# Run traditional unit tests
TEST_CLASSES=$(find test -name "*Test.java" -exec basename {} .java \; | tr '\n' ' ')
if [ -n "$TEST_CLASSES" ]; then
    java -cp "$LIBCP:src:test" org.junit.runner.JUnitCore $TEST_CLASSES
else
    echo "ℹ️  No traditional unit tests found"
fi

echo ""
echo "🧪 Running Cucumber BDD tests..."
echo ""

# Run Cucumber tests
java -cp "$LIBCP:src:src/test/java:src/test/resources" org.junit.runner.JUnitCore CucumberRunnerTest

echo ""
echo "✓ All tests completed!"
