# 📚 Documentación - CallForPaper App

Este directorio contiene toda la documentación detallada del proyecto.

## 📋 Índice de Documentación

### 🥒 [CUCUMBER.md](CUCUMBER.md)
Guía completa sobre **BDD (Behavior-Driven Development)** con **Cucumber**:
- Estructura de features y scenarios
- Step definitions en Java
- Ejecución de tests BDD
- Integración con Maven
- Análisis de resultados

**Leerlo si:**
- Quieres entender cómo funcionan los tests BDD
- Necesitas escribir nuevos scenarios
- Quieres aprender sobre Gherkin y Cucumber

---

### 🧪 [RUN_TESTS.md](RUN_TESTS.md)
Formas diferentes de **ejecutar y gestionar tests**:
- Unit Tests con JUnit
- BDD Tests con Cucumber
- Perfiles Maven
- Scripts automatizados
- Opciones de ejecución

**Leerlo si:**
- Necesitas ejecutar tests de forma específica
- Quieres usar perfiles Maven
- Buscas scripts automatizados

---

### 📊 [REPORTING_GUIDE.md](REPORTING_GUIDE.md)
Guía de **reportes de tests**:
- Dashboard HTML interactivo
- Reportes Markdown
- Reportes de Cucumber
- Integración de reportes en CI/CD
- Visualización de resultados

**Leerlo si:**
- Quieres entender los reportes generados
- Necesitas integrar reportes en tu flujo
- Buscas visualizar resultados detallados

---

## 🎯 Guía Rápida por Tarea

### "Quiero ejecutar los tests"
→ Ve a [RUN_TESTS.md](RUN_TESTS.md)

### "Quiero escribir nuevos scenarios BDD"
→ Ve a [CUCUMBER.md](CUCUMBER.md)

### "Quiero entender los reportes"
→ Ve a [REPORTING_GUIDE.md](REPORTING_GUIDE.md)

---

## 🚀 Quick Start

**Ejecutar todos los tests y generar reportes:**
```bash
mvn clean test && ./scripts/create-report-index.sh
```

**Ver el reporte interactivo:**
```bash
open target/test-reports/index.html  # macOS
xdg-open target/test-reports/index.html  # Linux
```

**Ver el reporte en Markdown:**
```bash
cat target/test-reports/TEST_REPORT.md
```

---

## 📊 Estadísticas de Documentación

| Documento | Temas | Líneas |
|-----------|-------|--------|
| CUCUMBER.md | 8+ | ~260 |
| RUN_TESTS.md | 6+ | ~254 |
| REPORTING_GUIDE.md | 5+ | ~327 |

---

## 💡 Notas

- Toda la documentación se mantiene actualizada con los cambios del código
- Los ejemplos de comandos están probados y funcionan
- Si encuentras algo incorrecto, por favor reportalo

---

**Última actualización:** Octubre 27, 2025
