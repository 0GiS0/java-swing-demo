#!/bin/bash

# Script mejorado para generar reportes usando Cucumber Reporting
# Integra resultados de Unit Tests y Cucumber BDD

set -e

# Colores
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

# Directorios
REPORTS_BASE="target"
SUREFIRE_DIR="$REPORTS_BASE/surefire-reports"
CUCUMBER_DIR="$REPORTS_BASE/cucumber-reports"
JSON_DIR="$REPORTS_BASE/cucumber-json-reports"
SUMMARY_DIR="$REPORTS_BASE/test-summary"

mkdir -p "$SUMMARY_DIR"

echo -e "${CYAN}🔍 Analizando resultados de tests...${NC}"
echo ""

# ============================================================================
# Mostrar resultados disponibles
# ============================================================================

echo -e "${BLUE}╔════════════════════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║            📊 Reportes de Tests Disponibles                ║${NC}"
echo -e "${BLUE}╚════════════════════════════════════════════════════════════╝${NC}"
echo ""

# Verificar Surefire Reports (Unit Tests)
if [[ -f "$SUREFIRE_DIR/index.html" ]]; then
    echo -e "${GREEN}✓ Unit Tests Report (Surefire)${NC}"
    echo "  📄 $SUREFIRE_DIR/index.html"
    
    # Parsear información de Surefire
    if [[ -f "$SUREFIRE_DIR/TEST-"*.xml ]]; then
        total=$(grep -oP 'tests="\K[^"]+' "$SUREFIRE_DIR/TEST-"*.xml 2>/dev/null | head -1 || echo "N/A")
        failures=$(grep -oP 'failures="\K[^"]+' "$SUREFIRE_DIR/TEST-"*.xml 2>/dev/null | head -1 || echo "0")
        echo "  📊 Total: $total | Failures: $failures"
    fi
else
    echo -e "${YELLOW}⊘ Unit Tests Report (no disponible)${NC}"
fi

echo ""

# Verificar Cucumber Reports (BDD Tests)
if [[ -f "$CUCUMBER_DIR/index.html" ]]; then
    echo -e "${GREEN}✓ BDD Tests Report (Cucumber)${NC}"
    echo "  📄 $CUCUMBER_DIR/index.html"
    
    # Buscar información en los JSON reports
    if [[ -f "$JSON_DIR/cucumber.json" ]]; then
        scenarios=$(grep -o '"type":"scenario"' "$JSON_DIR/cucumber.json" 2>/dev/null | wc -l || echo "N/A")
        echo "  📊 Scenarios: $scenarios"
    fi
else
    echo -e "${YELLOW}⊘ BDD Tests Report (no disponible)${NC}"
fi

echo ""

# ============================================================================
# Generar resumen de acciones
# ============================================================================

echo -e "${CYAN}📋 Próximas acciones:${NC}"
echo ""

if [[ -f "$SUREFIRE_DIR/index.html" ]]; then
    echo -e "1️⃣  Ver reportes de Unit Tests:"
    echo -e "   ${YELLOW}Abre:${NC} $SUREFIRE_DIR/index.html"
    echo ""
fi

if [[ -f "$CUCUMBER_DIR/index.html" ]]; then
    echo -e "2️⃣  Ver reportes de Cucumber BDD:"
    echo -e "   ${YELLOW}Abre:${NC} $CUCUMBER_DIR/index.html"
    echo ""
fi

# ============================================================================
# Crear archivo de resumen
# ============================================================================

summary_file="$SUMMARY_DIR/REPORT_SUMMARY.md"

cat > "$summary_file" << 'EOF'
# 📊 Resumen de Reportes de Tests

**Fecha:** $(date '+%Y-%m-%d %H:%M:%S')
**Branch:** $(git rev-parse --abbrev-ref HEAD 2>/dev/null || echo "N/A")
**Commit:** $(git rev-parse --short HEAD 2>/dev/null || echo "N/A")

## 📈 Reportes Disponibles

### Unit Tests (JUnit + Mockito)
- **Ubicación:** `target/surefire-reports/index.html`
- **Tipo:** Reportes de Surefire
- **Contiene:**
  - DatabaseConnectionTest.java
  - ProposalDAOTest.java
  - TalkProposalTest.java

### BDD Tests (Cucumber)
- **Ubicación:** `target/cucumber-reports/index.html`
- **Tipo:** Reportes de Cucumber (Masterthought)
- **Contiene:**
  - talk_proposals.feature (4 scenarios)
  - proposal_approval.feature (4 scenarios)
  - database_connection.feature (2 scenarios)
  - data_validation.feature (5 scenarios)
  - Total: 15 scenarios

## 🚀 Cómo Ver los Reportes

### Opción 1: Abrir directo en el navegador
```bash
# Unit Tests
open target/surefire-reports/index.html

# BDD Tests
open target/cucumber-reports/index.html
```

### Opción 2: Usar VS Code
- Abre el explorador de archivos
- Navega a `target/surefire-reports/` o `target/cucumber-reports/`
- Click derecho → "Open in Default Browser"

### Opción 3: Desde línea de comandos
```bash
# Linux
xdg-open target/surefire-reports/index.html

# macOS
open target/surefire-reports/index.html

# Windows
start target/surefire-reports/index.html
```

## 📚 Documentación

- [RUN_TESTS.md](../../RUN_TESTS.md) - Guía de ejecución de tests
- [README.md](../../README.md) - Documentación principal
- [CUCUMBER.md](../../CUCUMBER.md) - Detalles de Cucumber

---

*Generado automáticamente por `generate-test-report.sh`*
EOF

echo -e "${YELLOW}ℹ️  Resumen guardado en:${NC} $summary_file"
echo ""

echo -e "${GREEN}╔════════════════════════════════════════════════════════════╗${NC}"
echo -e "${GREEN}║              ✅ Análisis Completado                       ║${NC}"
echo -e "${GREEN}╚════════════════════════════════════════════════════════════╝${NC}"
echo ""
