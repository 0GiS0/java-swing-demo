#!/bin/bash

# Script para generar reportes visuales de tests en HTML y Markdown
# Genera reportes a partir de los resultados de Surefire y Cucumber
# Usa maven-cucumber-reporting para generar reportes de Cucumber

set -e

# Colores
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m'

# Directorios
REPORTS_DIR="target/test-reports"
SUREFIRE_DIR="target/surefire-reports"
CUCUMBER_DIR="target/cucumber-reports"
JSON_DIR="target/cucumber-json-reports"

# Crear directorio de reportes si no existe
mkdir -p "$REPORTS_DIR"

echo -e "${CYAN}🔍 Analizando resultados de tests...${NC}"
echo ""

# ============================================================================
# FUNCIÓN: Parsear XML de Surefire
# ============================================================================
function parse_surefire_results() {
    local xml_file="$1"
    local total=0
    local passed=0
    local failed=0
    local skipped=0
    local duration=0
    
    if [[ -f "$xml_file" ]]; then
        # Extraer valores del XML
        total=$(grep -oP 'tests="\K[^"]+' "$xml_file" | head -1 || echo "0")
        failures=$(grep -oP 'failures="\K[^"]+' "$xml_file" | head -1 || echo "0")
        skipped=$(grep -oP 'skipped="\K[^"]+' "$xml_file" | head -1 || echo "0")
        duration=$(grep -oP 'time="\K[^"]+' "$xml_file" | head -1 || echo "0")
        
        passed=$((total - failures - skipped))
        
        echo "$total|$passed|$failures|$skipped|$duration"
    else
        echo "0|0|0|0|0"
    fi
}

# ============================================================================
# FUNCIÓN: Generar reporte HTML
# ============================================================================
function generate_html_report() {
    local html_file="$REPORTS_DIR/test-report.html"
    
    echo -e "${YELLOW}📄 Generando reporte HTML...${NC}"
    
    # Obtener resultados de tests
    local unit_results=$(parse_surefire_results "$SUREFIRE_DIR/TEST-*.xml")
    IFS='|' read -r unit_total unit_passed unit_failed unit_skipped unit_duration <<< "$unit_results"
    
    # Obtener fecha y hora
    local timestamp=$(date '+%Y-%m-%d %H:%M:%S')
    local date_short=$(date '+%d/%m/%Y')
    
    # Calcular porcentaje de éxito
    local success_percentage=0
    if [[ $unit_total -gt 0 ]]; then
        success_percentage=$((unit_passed * 100 / unit_total))
    fi
    
    # Determinar color del porcentaje
    local color_class="success"
    if [[ $success_percentage -lt 50 ]]; then
        color_class="danger"
    elif [[ $success_percentage -lt 100 ]]; then
        color_class="warning"
    fi
    
    cat > "$html_file" << 'HTMLEOF'
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Reporte de Tests - CallForPaper App</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            padding: 20px;
        }
        
        .container {
            max-width: 1200px;
            margin: 0 auto;
            background: white;
            border-radius: 10px;
            box-shadow: 0 20px 60px rgba(0,0,0,0.3);
            overflow: hidden;
        }
        
        header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 40px;
            text-align: center;
        }
        
        header h1 {
            font-size: 2.5em;
            margin-bottom: 10px;
            text-shadow: 2px 2px 4px rgba(0,0,0,0.2);
        }
        
        header p {
            font-size: 1.1em;
            opacity: 0.9;
        }
        
        .content {
            padding: 40px;
        }
        
        .summary {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 20px;
            margin-bottom: 40px;
        }
        
        .card {
            background: #f8f9fa;
            border-left: 4px solid #667eea;
            padding: 20px;
            border-radius: 5px;
            box-shadow: 0 2px 5px rgba(0,0,0,0.1);
            transition: transform 0.2s;
        }
        
        .card:hover {
            transform: translateY(-5px);
        }
        
        .card-title {
            font-size: 0.9em;
            color: #666;
            text-transform: uppercase;
            font-weight: bold;
            margin-bottom: 10px;
        }
        
        .card-value {
            font-size: 2em;
            font-weight: bold;
            color: #333;
        }
        
        .card.passed { border-left-color: #28a745; }
        .card.failed { border-left-color: #dc3545; }
        .card.skipped { border-left-color: #ffc107; }
        .card.total { border-left-color: #667eea; }
        
        .card.passed .card-value { color: #28a745; }
        .card.failed .card-value { color: #dc3545; }
        .card.skipped .card-value { color: #ffc107; }
        
        .progress-section {
            margin-bottom: 40px;
        }
        
        .progress-section h2 {
            margin-bottom: 20px;
            color: #333;
        }
        
        .progress-bar {
            background: #e9ecef;
            border-radius: 10px;
            overflow: hidden;
            height: 40px;
            display: flex;
            align-items: center;
            position: relative;
            box-shadow: inset 0 2px 5px rgba(0,0,0,0.1);
        }
        
        .progress-fill {
            height: 100%;
            background: linear-gradient(90deg, #28a745 0%, #20c997 100%);
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-weight: bold;
            font-size: 1.1em;
            transition: width 0.5s ease;
        }
        
        .progress-fill.danger {
            background: linear-gradient(90deg, #dc3545 0%, #c82333 100%);
        }
        
        .progress-fill.warning {
            background: linear-gradient(90deg, #ffc107 0%, #ffb300 100%);
        }
        
        .statistics {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 30px;
            margin-bottom: 40px;
        }
        
        .stats-box {
            background: linear-gradient(135deg, #f5f7fa 0%, #c3cfe2 100%);
            padding: 30px;
            border-radius: 10px;
            box-shadow: 0 5px 15px rgba(0,0,0,0.1);
        }
        
        .stats-box h3 {
            margin-bottom: 20px;
            color: #333;
            font-size: 1.3em;
        }
        
        .stat-item {
            display: flex;
            justify-content: space-between;
            padding: 10px 0;
            border-bottom: 1px solid rgba(0,0,0,0.1);
            font-size: 1em;
        }
        
        .stat-item:last-child {
            border-bottom: none;
        }
        
        .stat-label {
            color: #666;
        }
        
        .stat-value {
            color: #333;
            font-weight: bold;
        }
        
        footer {
            background: #f8f9fa;
            padding: 20px;
            text-align: center;
            color: #666;
            font-size: 0.9em;
            border-top: 1px solid #e9ecef;
        }
        
        .badge {
            display: inline-block;
            padding: 5px 10px;
            border-radius: 20px;
            font-size: 0.85em;
            font-weight: bold;
            margin-right: 5px;
        }
        
        .badge-success {
            background: #d4edda;
            color: #155724;
        }
        
        .badge-danger {
            background: #f8d7da;
            color: #721c24;
        }
        
        .badge-warning {
            background: #fff3cd;
            color: #856404;
        }
        
        @media (max-width: 768px) {
            .statistics {
                grid-template-columns: 1fr;
            }
            
            header h1 {
                font-size: 1.8em;
            }
            
            .summary {
                grid-template-columns: 1fr;
            }
        }
    </style>
</head>
<body>
    <div class="container">
        <header>
            <h1>☕ Reporte de Tests</h1>
            <p>CallForPaper App - Análisis de Calidad</p>
        </header>
        
        <div class="content">
            <!-- Resumen rápido -->
            <div class="summary">
                <div class="card total">
                    <div class="card-title">Total de Tests</div>
                    <div class="card-value">TOTAL_TESTS</div>
                </div>
                <div class="card passed">
                    <div class="card-title">✓ Passed</div>
                    <div class="card-value">PASSED_TESTS</div>
                </div>
                <div class="card failed">
                    <div class="card-title">✗ Failed</div>
                    <div class="card-value">FAILED_TESTS</div>
                </div>
                <div class="card skipped">
                    <div class="card-title">⊘ Skipped</div>
                    <div class="card-value">SKIPPED_TESTS</div>
                </div>
            </div>
            
            <!-- Barra de progreso -->
            <div class="progress-section">
                <h2>Tasa de Éxito</h2>
                <div class="progress-bar">
                    <div class="progress-fill SUCCESS_CLASS" style="width: SUCCESS_PERCENTAGE%;">
                        SUCCESS_PERCENTAGE%
                    </div>
                </div>
            </div>
            
            <!-- Estadísticas -->
            <div class="statistics">
                <div class="stats-box">
                    <h3>📊 Resultados de Tests</h3>
                    <div class="stat-item">
                        <span class="stat-label">Total Ejecutados</span>
                        <span class="stat-value">TOTAL_TESTS</span>
                    </div>
                    <div class="stat-item">
                        <span class="stat-label">Exitosos</span>
                        <span class="stat-value">PASSED_TESTS</span>
                    </div>
                    <div class="stat-item">
                        <span class="stat-label">Fallidos</span>
                        <span class="stat-value">FAILED_TESTS</span>
                    </div>
                    <div class="stat-item">
                        <span class="stat-label">Omitidos</span>
                        <span class="stat-value">SKIPPED_TESTS</span>
                    </div>
                    <div class="stat-item">
                        <span class="stat-label">Duración</span>
                        <span class="stat-value">DURATION_TESTS s</span>
                    </div>
                </div>
                
                <div class="stats-box">
                    <h3>ℹ️ Información General</h3>
                    <div class="stat-item">
                        <span class="stat-label">Fecha de Ejecución</span>
                        <span class="stat-value">DATE_SHORT</span>
                    </div>
                    <div class="stat-item">
                        <span class="stat-label">Hora</span>
                        <span class="stat-value">TIMESTAMP</span>
                    </div>
                    <div class="stat-item">
                        <span class="stat-label">Branch</span>
                        <span class="stat-value">BRANCH_NAME</span>
                    </div>
                    <div class="stat-item">
                        <span class="stat-label">Commit</span>
                        <span class="stat-value">COMMIT_HASH</span>
                    </div>
                    <div class="stat-item">
                        <span class="stat-label">Estado</span>
                        <span class="stat-value">STATUS_BADGE</span>
                    </div>
                </div>
            </div>
        </div>
        
        <footer>
            <p>🔄 Reporte generado automáticamente por <strong>generate-test-report.sh</strong></p>
            <p>Para más información, consulta: README.md | RUN_TESTS.md</p>
        </footer>
    </div>
</body>
</html>
HTMLEOF

    # Reemplazar placeholders con sed (escapeando caracteres especiales)
    sed -i "s|TOTAL_TESTS|$unit_total|g" "$html_file"
    sed -i "s|PASSED_TESTS|$unit_passed|g" "$html_file"
    sed -i "s|FAILED_TESTS|$unit_failed|g" "$html_file"
    sed -i "s|SKIPPED_TESTS|$unit_skipped|g" "$html_file"
    sed -i "s|DURATION_TESTS|$unit_duration|g" "$html_file"
    sed -i "s|SUCCESS_PERCENTAGE|$success_percentage|g" "$html_file"
    sed -i "s|DATE_SHORT|$date_short|g" "$html_file"
    sed -i "s|TIMESTAMP|$timestamp|g" "$html_file"
    
    # Determinar clase de éxito
    if [[ $unit_failed -gt 0 ]]; then
        sed -i "s|SUCCESS_CLASS|danger|g" "$html_file"
        sed -i "s|STATUS_BADGE|<span class=\"badge badge-danger\">❌ FAILED</span>|g" "$html_file"
    elif [[ $unit_skipped -gt 0 ]]; then
        sed -i "s|SUCCESS_CLASS|warning|g" "$html_file"
        sed -i "s|STATUS_BADGE|<span class=\"badge badge-warning\">⚠️ WARNING</span>|g" "$html_file"
    else
        sed -i "s|SUCCESS_CLASS||g" "$html_file"
        sed -i "s|STATUS_BADGE|<span class=\"badge badge-success\">✅ SUCCESS</span>|g" "$html_file"
    fi
    
    # Información de git
    local branch=$(git rev-parse --abbrev-ref HEAD 2>/dev/null || echo "N/A")
    local commit=$(git rev-parse --short HEAD 2>/dev/null || echo "N/A")
    
    sed -i "s|BRANCH_NAME|$branch|g" "$html_file"
    sed -i "s|COMMIT_HASH|$commit|g" "$html_file"
    
    echo -e "${GREEN}✓ Reporte HTML generado: $html_file${NC}"
}

# ============================================================================
# FUNCIÓN: Generar reporte Markdown
# ============================================================================
function generate_markdown_report() {
    local md_file="$REPORTS_DIR/test-report.md"
    
    echo -e "${YELLOW}📝 Generando reporte Markdown...${NC}"
    
    # Obtener resultados
    local unit_results=$(parse_surefire_results "$SUREFIRE_DIR/TEST-*.xml")
    IFS='|' read -r unit_total unit_passed unit_failed unit_skipped unit_duration <<< "$unit_results"
    
    # Información de git
    local branch=$(git rev-parse --abbrev-ref HEAD 2>/dev/null || echo "N/A")
    local commit=$(git rev-parse --short HEAD 2>/dev/null || echo "N/A")
    local timestamp=$(date '+%Y-%m-%d %H:%M:%S')
    
    # Calcular porcentaje
    local success_percentage=0
    if [[ $unit_total -gt 0 ]]; then
        success_percentage=$((unit_passed * 100 / unit_total))
    fi
    
    # Determinar estado
    local status="✅ SUCCESS"
    local status_emoji="✅"
    if [[ $unit_failed -gt 0 ]]; then
        status="❌ FAILED"
        status_emoji="❌"
    elif [[ $unit_skipped -gt 0 ]]; then
        status="⚠️ WARNING"
        status_emoji="⚠️"
    fi
    
    cat > "$md_file" << MDEOF
# ☕ Reporte de Tests - CallForPaper App

**Fecha:** $timestamp  
**Branch:** \`$branch\`  
**Commit:** \`$commit\`  
**Estado:** $status_emoji **$status**

---

## 📊 Resumen Ejecutivo

| Métrica | Valor |
|---------|-------|
| **Total de Tests** | $unit_total |
| **✓ Exitosos** | $unit_passed |
| **✗ Fallidos** | $unit_failed |
| **⊘ Omitidos** | $unit_skipped |
| **Duración** | ${unit_duration}s |
| **Tasa de Éxito** | $success_percentage% |

---

## 📈 Tasa de Éxito

\`\`\`
$success_percentage% [$success_percentage/100]
MDEOF

    # Generar barra visual
    local bar_length=50
    local filled_length=$((success_percentage * bar_length / 100))
    
    for ((i = 0; i < bar_length; i++)); do
        if [[ $i -lt $filled_length ]]; then
            echo -n "█" >> "$md_file"
        else
            echo -n "░" >> "$md_file"
        fi
    done
    
    cat >> "$md_file" << MDEOF

\`\`\`

---

## 🧪 Detalles de Tests

### Unit Tests (JUnit + Mockito)

- **Archivos de test:**
  - \`DatabaseConnectionTest.java\`
  - \`ProposalDAOTest.java\`
  - \`TalkProposalTest.java\`

- **Resultados:**
  - ✓ Exitosos: **$unit_passed**
  - ✗ Fallidos: **$unit_failed**
  - ⊘ Omitidos: **$unit_skipped**
  - 📊 Tasa: **$success_percentage%**

### BDD Tests (Cucumber)

- **Features:**
  - \`talk_proposals.feature\` (4 scenarios)
  - \`proposal_approval.feature\` (4 scenarios)
  - \`database_connection.feature\` (2 scenarios)
  - \`data_validation.feature\` (5 scenarios)

---

## 🎯 Estadísticas

### Breakdown

| Estado | Cantidad | Porcentaje |
|--------|----------|-----------|
| ✓ Passed | $unit_passed | $(( unit_passed * 100 / unit_total ))% |
| ✗ Failed | $unit_failed | $(( unit_failed * 100 / unit_total ))% |
| ⊘ Skipped | $unit_skipped | $(( unit_skipped * 100 / unit_total ))% |

---

## 📁 Reportes Disponibles

- **HTML Report:** \`target/test-reports/test-report.html\`
- **Surefire:** \`target/surefire-reports/index.html\`
- **Cucumber:** \`target/cucumber-reports/index.html\`

---

## 🚀 Próximas Acciones

$(if [[ $unit_failed -gt 0 ]]; then
    echo "⚠️ **Hay tests fallidos. Por favor revisar:**"
    echo ""
    echo "1. Revisa los detalles en: \`target/surefire-reports/index.html\`"
    echo "2. Ejecuta nuevamente los tests: \`./scripts/run-tests.sh --all\`"
    echo "3. Verifica los logs en: \`target/test-reports/\`"
else
    echo "✅ **¡Todos los tests pasaron! Continúa con:**"
    echo ""
    echo "1. Revisar el reporte detallado"
    echo "2. Hacer commit de los cambios"
    echo "3. Crear una pull request"
fi)

---

## 📚 Referencias

- [RUN_TESTS.md](../RUN_TESTS.md)
- [README.md](../README.md)
- [CUCUMBER.md](../CUCUMBER.md)

---

**Generado por:** \`generate-test-report.sh\`  
**Última actualización:** $timestamp
MDEOF

    echo -e "${GREEN}✓ Reporte Markdown generado: $md_file${NC}"
}

# ============================================================================
# MAIN
# ============================================================================

echo -e "${BLUE}╔════════════════════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║          🧪 Generador de Reportes de Tests                ║${NC}"
echo -e "${BLUE}╚════════════════════════════════════════════════════════════╝${NC}"
echo ""

# Verificar si existen resultados de tests
if [[ ! -d "$SUREFIRE_DIR" ]]; then
    echo -e "${RED}❌ No se encontraron resultados de tests${NC}"
    echo -e "${YELLOW}Por favor, ejecuta primero: mvn clean test${NC}"
    exit 1
fi

# Generar reportes
generate_html_report
generate_markdown_report

echo ""
echo -e "${GREEN}╔════════════════════════════════════════════════════════════╗${NC}"
echo -e "${GREEN}║              ✅ Reportes Generados Exitosamente           ║${NC}"
echo -e "${GREEN}╚════════════════════════════════════════════════════════════╝${NC}"
echo ""
echo -e "${CYAN}📁 Reportes disponibles en: ${REPORTS_DIR}/${NC}"
echo ""
echo -e "${YELLOW}Abre los reportes:${NC}"
echo -e "  🌐 HTML:     ${REPORTS_DIR}/test-report.html"
echo -e "  📝 Markdown: ${REPORTS_DIR}/test-report.md"
echo ""
