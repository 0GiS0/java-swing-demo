# 📊 Reportes de Tests - Guía Completa

Esta guía explica cómo generar y ver los reportes de tests en el proyecto.

## 🎯 Tipos de Reportes

### 1. **Unit Tests Report** (Surefire)
- **Ubicación:** `target/surefire-reports/index.html`
- **Tipo:** Surefire Maven Plugin
- **Contiene:**
  - Resultados de DatabaseConnectionTest.java
  - Resultados de ProposalDAOTest.java
  - Resultados de TalkProposalTest.java
  - Gráficos de éxito/fallo
  - Detalles de cada test

### 2. **Cucumber Report** (BDD)
- **Ubicación:** `target/cucumber-reports/index.html`
- **Tipo:** Masterthought Cucumber Reporting
- **Contiene:**
  - Scenarios de talk_proposals.feature
  - Scenarios de proposal_approval.feature
  - Scenarios de database_connection.feature
  - Scenarios de data_validation.feature
  - Pasos ejecutados (Given, When, Then)
  - Tiempos de ejecución
  - Estados (passed, failed, skipped)

---

## 🚀 Cómo Generar Reportes

### Opción 1: Ejecutar Todo con Reportes (Recomendado)

```bash
# Ejecutar tests y generar reportes
./scripts/run-and-report.sh --all

# Ejecutar tests y abrir reportes automáticamente
./scripts/run-and-report.sh --all --show-reports
```

### Opción 2: Solo Unit Tests

```bash
./scripts/run-and-report.sh --unit
```

### Opción 3: Solo BDD Tests

```bash
./scripts/run-and-report.sh --bdd
```

### Opción 4: Maven Directo

```bash
# Generar todos los reportes
mvn clean test

# Solo Unit Tests
mvn clean test -Dtests=unit

# Solo BDD Tests
mvn clean test -Dtests=bdd

# Generar reportes sin ejecutar tests
mvn verify -DskipTests=true
```

---

## 📖 Ver los Reportes

### En el Navegador

#### Unit Tests
```bash
# Linux/macOS
open target/surefire-reports/index.html

# Windows
start target/surefire-reports/index.html
```

#### Cucumber Tests
```bash
# Linux/macOS
open target/cucumber-reports/index.html

# Windows
start target/cucumber-reports/index.html
```

### Desde VS Code

1. **Método 1: Abrir en navegador**
   - Navega a `target/surefire-reports/` en el explorador
   - Click derecho en `index.html`
   - Selecciona "Open in Default Browser"

2. **Método 2: Usar comando**
   - Abre la terminal integrada
   - Ejecuta: `./scripts/run-and-report.sh --all --show-reports`

### Desde Línea de Comandos

```bash
# Ver qué reportes están disponibles
./scripts/show-test-reports.sh

# Abrir ambos reportes
./scripts/run-and-report.sh --all --show-reports
```

---

## 📊 Entender los Reportes

### Surefire Report (Unit Tests)

**Elementos principales:**

- **Success Rate:** Porcentaje de tests exitosos
- **Test Summary:** Total, Passed, Failed, Skipped
- **Package List:** Resumen por paquete
- **Test Cases:** Detalle de cada test
- **Errors/Failures:** Descripción del problema

**Cómo interpretar:**
- ✅ Verde = Test pasó
- ❌ Rojo = Test falló
- ⊘ Gris = Test saltado

### Cucumber Report (BDD Tests)

**Elementos principales:**

- **Feature Overview:** Resumen de features
- **Scenario Results:** Estado de cada scenario
- **Step Details:** Paso por paso de ejecución
- **Execution Time:** Duración de cada scenario
- **Error Messages:** Detalles de fallos

**Estados:**
- ✅ Passed = Todos los pasos ejecutados
- ❌ Failed = Al menos un paso falló
- ⊘ Skipped = No ejecutado
- ⚠️ Undefined = Paso sin implementar

---

## 🎯 Casos de Uso

### Caso 1: Verificar que Todo Funciona

```bash
# Ejecutar todo y ver reportes
./scripts/run-and-report.sh --all --show-reports

# Esperar a que se abran ambos reportes
# Verificar que están en verde (100% success)
```

### Caso 2: Investigar un Test Fallido

```bash
# Ejecutar solo unit tests
./scripts/run-and-report.sh --unit

# El navegador abre automáticamente
# Buscar el test en rojo (failed)
# Leer el mensaje de error
# Hacer cambios al código
# Repetir
```

### Caso 3: Validar Feature de Cucumber

```bash
# Ejecutar solo BDD tests
./scripts/run-and-report.sh --bdd

# Revisar si todos los scenarios están verdes
# Si hay errores, revisar el "Step Details"
# Revisar el archivo .feature correspondiente
```

### Caso 4: Integración Continua (CI/CD)

```bash
# En tu pipeline (GitHub Actions, Jenkins, etc.)
mvn clean test

# Los reportes se generan automáticamente en:
# - target/surefire-reports/
# - target/cucumber-reports/
```

---

## 🔄 Flujo de Trabajo Típico

```
1. Hacer cambios al código
   ↓
2. ./scripts/run-and-report.sh --all --show-reports
   ↓
3. Se abren ambos reportes en el navegador
   ↓
4. ✅ Si todo está verde → Continuar
   ❌ Si hay rojo → Revisar reportes y corregir
   ↓
5. Hacer commit cuando todo está verde
```

---

## 📈 Métricas en los Reportes

### Unit Tests
- **Total Tests:** Cantidad total de tests
- **Success Rate:** % de tests exitosos
- **Average Duration:** Tiempo promedio por test
- **Fastest Test:** Test más rápido
- **Slowest Test:** Test más lento

### Cucumber
- **Total Scenarios:** Cantidad total de scenarios
- **Passed Scenarios:** Scenarios exitosos
- **Failed Scenarios:** Scenarios fallidos
- **Execution Duration:** Tiempo total
- **Average Scenario Time:** Promedio por scenario

---

## 🐛 Troubleshooting

### Problema: Los reportes no se generan

**Solución:**
```bash
# Limpiar y reconstruir
mvn clean install

# Ejecutar tests explícitamente
mvn clean test

# Generar reportes
mvn verify -DskipTests=true
```

### Problema: No puedo abrir los reportes

**Solución:**
```bash
# Abre manualmente la ruta
open target/surefire-reports/index.html
open target/cucumber-reports/index.html

# O usa el comando del script
./scripts/show-test-reports.sh
```

### Problema: Los reportes están vacíos

**Solución:**
- Asegúrate de que los tests se ejecutaron correctamente
- Revisa que no hay errores en la compilación
- Ejecuta: `mvn clean test` (sin -q para ver detalles)

---

## 📚 Archivos Relacionados

- `scripts/run-and-report.sh` - Script integrado de tests + reportes
- `scripts/show-test-reports.sh` - Mostrar reportes disponibles
- `scripts/run-tests.sh` - Ejecutar tests (sin abrir reportes)
- `RUN_TESTS.md` - Guía de ejecución de tests
- `pom.xml` - Configuración de Maven (plugins de reporting)

---

## 🎨 Personalización

### Cambiar el nombre del proyecto en reportes

Edita `pom.xml`:
```xml
<configuration>
    <projectName>Mi Proyecto - Cucumber Tests</projectName>
    <!-- ... -->
</configuration>
```

### Cambiar la ubicación de reportes

Edita `pom.xml`:
```xml
<configuration>
    <outputDirectory>mi-carpeta/reportes</outputDirectory>
    <!-- ... -->
</configuration>
```

### Agregar más plugins

Algunos plugins populares:
- **Allure:** Para reportes más visuales
- **ReportPortal:** Para dashboard centralizado
- **Serenity:** Para reportes con screenshots

---

## 📞 Soporte

Si tienes problemas con los reportes:

1. Revisa que Maven está instalado: `mvn --version`
2. Asegúrate de tener Java 8+: `java -version`
3. Ejecuta: `mvn clean install` para resolver dependencias
4. Revisa los logs: `mvn clean test` (sin -q)

---

**Última actualización:** October 27, 2025  
**Documentación de:** Cucumber Reporting + Surefire
