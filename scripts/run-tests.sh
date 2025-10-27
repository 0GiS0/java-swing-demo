#!/bin/bash

# Script para ejecutar tests en el proyecto java-swing-demo
# Soporta: Unit Tests, BDD Tests, o ambos

set -e

# Colores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Default test type
TEST_TYPE="all"

# Parse arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        --unit)
            TEST_TYPE="unit"
            shift
            ;;
        --bdd)
            TEST_TYPE="bdd"
            shift
            ;;
        --all)
            TEST_TYPE="all"
            shift
            ;;
        -h|--help)
            echo "Usage: $0 [OPTIONS]"
            echo ""
            echo "Options:"
            echo "  --unit      Run only unit tests (JUnit + Mockito)"
            echo "  --bdd       Run only BDD tests (Cucumber)"
            echo "  --all       Run all tests (default)"
            echo "  -h|--help   Show this help message"
            echo ""
            echo "Examples:"
            echo "  $0 --unit     # Run unit tests only"
            echo "  $0 --bdd      # Run BDD tests only"
            echo "  $0 --all      # Run all tests"
            exit 0
            ;;
        *)
            echo "Unknown option: $1"
            echo "Use -h or --help for usage information"
            exit 1
            ;;
    esac
done

# Display header
echo ""
echo "╔════════════════════════════════════════════════════════════╗"
echo "║         🧪 Running Tests for java-swing-demo              ║"
echo "╚════════════════════════════════════════════════════════════╝"
echo ""

# Run tests based on type
case $TEST_TYPE in
    unit)
        echo -e "${YELLOW}📝 Running UNIT TESTS only (JUnit + Mockito)${NC}"
        echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
        echo ""
        
        mvn clean test -Dtests=unit
        
        echo ""
        echo -e "${GREEN}✅ Unit Tests Complete!${NC}"
        echo "📊 Reportes disponibles en: target/surefire-reports/"
        ;;
        
    bdd)
        echo -e "${YELLOW}🥒 Running BDD TESTS only (Cucumber)${NC}"
        echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
        echo ""
        
        mvn clean test -Dtests=bdd
        
        echo ""
        echo -e "${GREEN}✅ BDD Tests Complete!${NC}"
        echo "📊 Reportes disponibles en: target/cucumber-reports/"
        ;;
        
    all)
        echo -e "${YELLOW}🚀 Running ALL TESTS (Unit + BDD)${NC}"
        echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
        echo ""
        
        echo -e "${BLUE}Step 1️⃣: Running Unit Tests${NC}"
        echo "───────────────────────────────────────────────────────"
        mvn clean test -Dtests=unit
        
        echo ""
        echo -e "${BLUE}Step 2️⃣: Running BDD Tests${NC}"
        echo "───────────────────────────────────────────────────────"
        mvn test -Dtests=bdd
        
        echo ""
        echo -e "${GREEN}✅ All Tests Complete!${NC}"
        echo "📊 Reportes disponibles en:"
        echo "   - Unit Tests: target/surefire-reports/"
        echo "   - BDD Tests:  target/cucumber-reports/"
        ;;
esac

echo ""
echo "╔════════════════════════════════════════════════════════════╗"
echo "║                  ✨ Test Execution Done ✨                ║"
echo "╚════════════════════════════════════════════════════════════╝"
echo ""

# Summary
echo -e "${BLUE}📈 Summary:${NC}"
echo "  • Test Type: $TEST_TYPE"
echo "  • Timestamp: $(date)"
echo ""
