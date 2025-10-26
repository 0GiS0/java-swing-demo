#!/bin/bash

# Cucumber BDD Test Status Checker for CallForPaperApp

cd "$(dirname "$0")/.."

echo "🧪 Checking Cucumber BDD Setup..."
echo ""

# Build classpath
LIBCP=$(ls lib/*.jar | tr '\n' ':' | sed 's/:$//')

# Compile application code
echo "🔨 Compiling application code..."
javac -d src -cp "$LIBCP:src" src/CallForPaperApp.java src/DatabaseConnection.java src/TalkProposal.java src/ProposalDAO.java 2>/dev/null

# Compile step definitions
echo "🔨 Compiling step definitions..."
javac -d src/test/java -cp "$LIBCP:src" src/test/java/TalkProposalSteps.java src/test/java/ProposalApprovalSteps.java src/test/java/DatabaseConnectionSteps.java src/test/java/DataValidationSteps.java 2>/dev/null

if [ $? -ne 0 ]; then
    echo "✗ Compilation failed!"
    exit 1
fi

echo "✓ Compilation successful!"
echo ""
echo "📋 Cucumber Feature Files Found:"
echo ""

# List feature files
find src/test/resources/features -name "*.feature" 2>/dev/null | while read file; do
    echo "  ✓ $(basename $file)"
done

echo ""
echo "📝 Scenario Summary:"
echo ""

# Show scenarios with counts
grep -r "Scenario:" src/test/resources/features 2>/dev/null | sed 's/.*Scenario: /  • /' | sort

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "✓ Cucumber BDD setup is complete!"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "To run the actual tests, use Maven:"
echo "  mvn clean test"
echo ""
echo "Or with Gradle:"
echo "  gradle test"
echo ""
echo "For standalone Java execution without Maven:"
echo "  - Download full Cucumber runtime: io.cucumber:cucumber-java:4.8.1"
echo "  - Download all transitive dependencies (~20+ JARs)"
echo "  - Execute with: java -cp \$CLASSPATH org.junit.runner.JUnitCore CucumberRunnerTest"
