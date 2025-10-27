#!/bin/bash

# Script integrado: Ejecuta tests Y genera reportes automáticamente
# Combina ejecución de tests con generación de reportes

set -e

# Colores
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

# Variables
TEST_TYPE="all"
SHOW_REPORTS=false

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
        --show-reports|--reports)
            SHOW_REPORTS=true
            shift
            ;;
        -h|--help)
            echo "Uso: $0 [OPTIONS]"
            echo ""
            echo "Options:"
            echo "  --unit            Ejecutar solo unit tests"
            echo "  --bdd             Ejecutar solo BDD tests"
            echo "  --all             Ejecutar todos (default)"
            echo "  --show-reports    Mostrar reportes después de ejecutar"
            echo "  -h|--help         Mostrar esta ayuda"
            echo ""
            echo "Ejemplo:"
            echo "  $0 --all --show-reports"
            exit 0
            ;;
        *)
            echo "Opción desconocida: $1"
            exit 1
            ;;
    esac
done

# ============================================================================
# MAIN
# ============================================================================

echo -e "${CYAN}"
echo "╔════════════════════════════════════════════════════════════╗"
echo "║           🧪 Ejecutor de Tests + Reportes                 ║"
echo "╚════════════════════════════════════════════════════════════╝"
echo -e "${NC}"
echo ""

# Step 1: Limpiar build anterior
echo -e "${YELLOW}Step 1/3: Limpiando build anterior...${NC}"
mvn clean -q 2>/dev/null || true
echo -e "${GREEN}✓ Limpieza completada${NC}"
echo ""

# Step 2: Ejecutar tests según tipo
echo -e "${YELLOW}Step 2/3: Ejecutando tests ($TEST_TYPE)...${NC}"

case $TEST_TYPE in
    unit)
        echo "  Ejecutando: Unit Tests (JUnit + Mockito)"
        mvn test -Dtests=unit -q
        ;;
    bdd)
        echo "  Ejecutando: BDD Tests (Cucumber)"
        mvn test -Dtests=bdd -q
        ;;
    all)
        echo "  Ejecutando: Todos los tests (Unit + BDD)"
        mvn test -q
        ;;
esac

echo -e "${GREEN}✓ Tests completados${NC}"
echo ""

# Step 3: Generar reportes
echo -e "${YELLOW}Step 3/3: Generando reportes...${NC}"
mvn verify -DskipTests=true -q 2>/dev/null || true

# Verificar si existen reportes
SUREFIRE_REPORT="target/surefire-reports/index.html"
CUCUMBER_REPORT="target/cucumber-reports/index.html"

unit_available=false
bdd_available=false

if [[ -f "$SUREFIRE_REPORT" ]]; then
    unit_available=true
    echo -e "${GREEN}  ✓ Reporte de Unit Tests generado${NC}"
fi

if [[ -f "$CUCUMBER_REPORT" ]]; then
    bdd_available=true
    echo -e "${GREEN}  ✓ Reporte de Cucumber generado${NC}"
fi

echo ""

# Mostrar resumen
echo -e "${CYAN}╔════════════════════════════════════════════════════════════╗${NC}"
echo -e "${CYAN}║              📊 RESUMEN DE EJECUCIÓN                      ║${NC}"
echo -e "${CYAN}╚════════════════════════════════════════════════════════════╝${NC}"
echo ""

if $unit_available; then
    echo -e "${GREEN}✓${NC} Unit Tests Report"
    echo "   📄 file://$(pwd)/$SUREFIRE_REPORT"
fi

if $bdd_available; then
    echo -e "${GREEN}✓${NC} Cucumber Report"
    echo "   📄 file://$(pwd)/$CUCUMBER_REPORT"
fi

echo ""

# Mostrar reportes si se solicita
if $SHOW_REPORTS; then
    echo -e "${YELLOW}Abriendo reportes en el navegador...${NC}"
    echo ""
    
    if [[ -f "$SUREFIRE_REPORT" ]]; then
        echo "  🌐 Abriendo Unit Tests Report..."
        if command -v xdg-open &> /dev/null; then
            xdg-open "$SUREFIRE_REPORT" &
        elif command -v open &> /dev/null; then
            open "$SUREFIRE_REPORT" &
        elif command -v start &> /dev/null; then
            start "$SUREFIRE_REPORT" &
        else
            echo "  (No se pudo abrir automáticamente)"
        fi
    fi
    
    sleep 2
    
    if [[ -f "$CUCUMBER_REPORT" ]]; then
        echo "  🌐 Abriendo Cucumber Report..."
        if command -v xdg-open &> /dev/null; then
            xdg-open "$CUCUMBER_REPORT" &
        elif command -v open &> /dev/null; then
            open "$CUCUMBER_REPORT" &
        elif command -v start &> /dev/null; then
            start "$CUCUMBER_REPORT" &
        else
            echo "  (No se pudo abrir automáticamente)"
        fi
    fi
    
    echo ""
fi

# Mostrar próximos pasos
echo -e "${BLUE}🚀 Próximos pasos:${NC}"
echo ""
echo "  1. Ver Unit Tests:"
if $unit_available; then
    echo -e "     ${YELLOW}open target/surefire-reports/index.html${NC}"
else
    echo "     (No disponible - ejecuta con --unit)"
fi

echo ""
echo "  2. Ver Cucumber Report:"
if $bdd_available; then
    echo -e "     ${YELLOW}open target/cucumber-reports/index.html${NC}"
else
    echo "     (No disponible - ejecuta con --bdd)"
fi

echo ""
echo "  3. Ver ambos reportes rápidamente:"
echo -e "     ${YELLOW}./scripts/run-and-report.sh --all --show-reports${NC}"
echo ""

echo -e "${GREEN}╔════════════════════════════════════════════════════════════╗${NC}"
echo -e "${GREEN}║              ✅ COMPLETADO EXITOSAMENTE                   ║${NC}"
echo -e "${GREEN}╚════════════════════════════════════════════════════════════╝${NC}"
echo ""
