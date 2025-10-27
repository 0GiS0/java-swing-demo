# 🧪 Ejecutando Tests en el Proyecto

Este proyecto contiene **dos tipos de tests** que pueden ejecutarse de forma separada o conjunta usando Maven:

1. **Unit Tests** - Pruebas unitarias clásicas (JUnit + Mockito)
2. **BDD Tests** - Pruebas de comportamiento con Cucumber (Gherkin)

## 🎯 Opciones de Ejecución

### 1️⃣ Ejecutar TODOS los Tests (Unit + BDD)

```bash
mvn clean test
```

**Salida esperada:**
```
[INFO] Running com.example.DatabaseConnectionTest
[INFO] Running com.example.ProposalDAOTest
[INFO] Running com.example.TalkProposalTest
[INFO] Running com.example.CucumberRunnerTest
[INFO] Tests run: 25 total (unit tests + BDD scenarios)
```

**Reportes generados:**
- Tests unitarios: `target/surefire-reports/`
- BDD Tests: `target/cucumber-reports/` (HTML report con Cucumber)

---

### 2️⃣ Ejecutar Solo Unit Tests

```bash
mvn clean test -Dtests=unit
```

**O usando el perfil específico:**

```bash
mvn clean test -P unit-tests
```

**Tests ejecutados:**
- ✅ `DatabaseConnectionTest.java` - Validación de conexión a BD
- ✅ `ProposalDAOTest.java` - Operaciones CRUD
- ✅ `TalkProposalTest.java` - Modelo de datos

**Reportes:**
- `target/surefire-reports/`

---

### 3️⃣ Ejecutar Solo BDD Tests (Cucumber)

```bash
mvn clean test -Dtests=bdd
```

**O usando el perfil específico:**

```bash
mvn clean test -P bdd-tests
```

**Tests ejecutados:**
- ✅ `CucumberRunnerTest.java` (que carga todos los scenarios)

**Feature Files cubiertos:**
- 📄 `talk_proposals.feature` (4 scenarios)
- 📄 `proposal_approval.feature` (4 scenarios)
- 📄 `database_connection.feature` (2 scenarios)
- 📄 `data_validation.feature` (5 scenarios)
- **Total: 15 scenarios BDD**

**Reportes:**
- `target/cucumber-reports/` (HTML report interactivo)

---

### 4️⃣ Ejecutar Tests con Verbose Output

```bash
mvn clean test -X
```

Muestra información detallada de la ejecución.

---

### 5️⃣ Ejecutar Tests Saltando la Compilación

```bash
mvn test
```

(Sin `clean`)

---

## 📊 Comparativa de Comandos

| Opción | Comando | Unit Tests | BDD Tests | Reportes |
|--------|---------|-----------|-----------|----------|
| Todos | `mvn clean test` | ✅ | ✅ | Ambos |
| Solo Unit | `mvn clean test -Dtests=unit` | ✅ | ❌ | Surefire |
| Solo BDD | `mvn clean test -Dtests=bdd` | ❌ | ✅ | Cucumber |
| Perfil Unit | `mvn clean test -P unit-tests` | ✅ | ❌ | Surefire |
| Perfil BDD | `mvn clean test -P bdd-tests` | ❌ | ✅ | Cucumber |

---

## 📁 Ubicación de Tests

### Unit Tests
```
src/test/java/
├── DatabaseConnectionTest.java
├── ProposalDAOTest.java
└── TalkProposalTest.java
```

### BDD Tests
```
src/test/java/
├── CucumberRunnerTest.java          # Test runner
├── TalkProposalSteps.java           # Step definitions
├── ProposalApprovalSteps.java       # Step definitions
├── DatabaseConnectionSteps.java     # Step definitions
└── DataValidationSteps.java         # Step definitions

src/test/resources/features/
├── talk_proposals.feature
├── proposal_approval.feature
├── database_connection.feature
└── data_validation.feature
```

---

## 📋 Entender los Perfiles Maven

Este proyecto define dos perfiles en el `pom.xml`:

### Perfil: `unit-tests`
```bash
mvn test -Dtests=unit
# O
mvn test -P unit-tests
```

Ejecuta solo:
- `DatabaseConnectionTest.java`
- `ProposalDAOTest.java`
- `TalkProposalTest.java`

### Perfil: `bdd-tests`
```bash
mvn test -Dtests=bdd
# O
mvn test -P bdd-tests
```

Ejecuta solo:
- `CucumberRunnerTest.java` (que a su vez carga todos los steps y features)

---

## 🔍 Verificar Resultados de Tests

### Reportes HTML de Unit Tests

```bash
# Los reportes se encuentran en:
target/surefire-reports/index.html
```

Abre este archivo en tu navegador para ver los resultados detallados.

### Reportes HTML de BDD Tests

```bash
# Los reportes se encuentran en:
target/cucumber-reports/index.html
```

Abre este archivo en tu navegador para ver los scenarios ejecutados con detalles.

---

## 🚀 Ejecutar Tests desde IDE

### En IntelliJ IDEA / WebStorm
1. Click derecho en `src/test/java`
2. Selecciona "Run Tests"
3. O usa `Ctrl+Shift+F10` (Windows/Linux) o `⌘+Shift+U` (macOS)

### En VS Code
1. Instala la extensión "Test Explorer UI"
2. Abre el explorador de tests
3. Selecciona los tests que quieres ejecutar

---

## 🐛 Troubleshooting

### Error: "MySQL connection refused"
**Solución:** Asegúrate de que MySQL está ejecutándose:
```bash
# En Docker
docker-compose up -d
# O
docker run -d -p 3306:3306 -e MYSQL_ROOT_PASSWORD=root mysql:8.0
```

### Error: "Feature files not found"
**Solución:** Verifica que los archivos `.feature` están en:
```
src/test/resources/features/
```

### Error: Maven no reconoce los tests
**Solución:** Limpia y reconstruye:
```bash
mvn clean install
mvn clean test
```

---

## 📈 Estadísticas de Tests

```
Total de Tests: ~25
├── Unit Tests: ~10 (Junit + Mockito)
└── BDD Scenarios: ~15 (Cucumber)

Cobertura aproximada:
├── DatabaseConnection.java: 80%
├── ProposalDAO.java: 75%
└── TalkProposal.java: 70%
```

---

## 📚 Referencias

- [Maven Surefire Plugin](https://maven.apache.org/surefire/)
- [Cucumber Java Documentation](https://cucumber.io/docs/cucumber/)
- [JUnit 4 Documentation](https://junit.org/junit4/)
- [Mockito Documentation](https://javadoc.io/doc/org.mockito/mockito-core/latest/org/mockito/Mockito.html)

---

**Última actualización:** October 27, 2025
