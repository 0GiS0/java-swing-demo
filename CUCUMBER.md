# CallForPaper App - Cucumber BDD Tests Branch

Este es el branch `cucumber` del proyecto `java-swing-demo`, donde se integra el framework de pruebas BDD **Cucumber** con **Maven**.

## 📋 Contenido del Branch

### ✨ Características Nuevas

1. **Maven POM Configuration** (`pom.xml`)
   - Gestión automática de dependencias
   - Cucumber 4.8.1 como dependency principal
   - JUnit 4.13.2 para test runners
   - MySQL Connector y Mockito para testing
   - Plugins para reporting de Cucumber

2. **Feature Files** (4 archivos en `src/test/resources/features/`)
   - `talk_proposals.feature` - CRUD operations (4 escenarios)
   - `proposal_approval.feature` - Workflow de aprobación (4 escenarios)
   - `database_connection.feature` - Conectividad BD (2 escenarios)
   - `data_validation.feature` - Validación de datos (5 escenarios)
   - **Total: 15 escenarios en Gherkin (inglés)**

3. **Step Definitions** (4 archivos en `src/test/java/`)
   - `TalkProposalSteps.java` - Pasos para CRUD
   - `ProposalApprovalSteps.java` - Pasos para aprobación/rechazo
   - `DatabaseConnectionSteps.java` - Pasos para conexión BD
   - `DataValidationSteps.java` - Pasos para validación
   - **Total: ~25 métodos de step definitions**

4. **Test Runners**
   - `CucumberRunnerTest.java` - JUnit runner configurado para Cucumber

### 📁 Estructura de Directorio (Estándar Maven)

```
java-swing-demo/
├── src/
│   ├── main/java/                          # Código fuente de la aplicación
│   │   ├── CallForPaperApp.java
│   │   ├── DatabaseConnection.java
│   │   ├── ProposalDAO.java
│   │   ├── TalkProposal.java
│   │   └── CucumberCLI.java
│   └── test/
│       ├── java/                           # Step definitions
│       │   ├── TalkProposalSteps.java
│       │   ├── ProposalApprovalSteps.java
│       │   ├── DatabaseConnectionSteps.java
│       │   ├── DataValidationSteps.java
│       │   └── CucumberRunnerTest.java
│       └── resources/
│           └── features/                   # Feature files (Gherkin)
│               ├── talk_proposals.feature
│               ├── proposal_approval.feature
│               ├── database_connection.feature
│               └── data_validation.feature
├── pom.xml                                 # Maven configuration
├── lib/                                    # Librerías adicionales (legacy)
└── scripts/                                # Scripts de utilidad
```

## 🚀 Cómo Ejecutar los Tests

### Opción 1: Ejecutar todos los tests (Recomendado)
```bash
mvn clean test
```

### Opción 2: Ejecutar solo los tests de Cucumber
```bash
mvn test -Dtest=CucumberRunnerTest
```

### Opción 3: Ejecutar tests con reporte HTML
```bash
mvn clean test
# El reporte se genera en: target/cucumber-reports/
```

### Opción 4: Ejecutar tests con filtro por tags
```bash
# Nota: Los tags se pueden agregar a los feature files para filtrar escenarios
mvn test -Dcucumber.options="--tags @important"
```

## 📊 Dependencias Principales

```xml
<!-- Cucumber BDD Framework -->
<dependency>
    <groupId>io.cucumber</groupId>
    <artifactId>cucumber-java</artifactId>
    <version>4.8.1</version>
</dependency>

<!-- JUnit for test runners -->
<dependency>
    <groupId>junit</groupId>
    <artifactId>junit</artifactId>
    <version>4.13.2</version>
    <scope>test</scope>
</dependency>

<!-- MySQL Driver -->
<dependency>
    <groupId>mysql</groupId>
    <artifactId>mysql-connector-java</artifactId>
    <version>8.0.33</version>
</dependency>

<!-- Mockito for testing -->
<dependency>
    <groupId>org.mockito</groupId>
    <artifactId>mockito-core</artifactId>
    <version>4.8.0</version>
    <scope>test</scope>
</dependency>
```

## ✅ Características de los Tests

### Talk Proposals (talk_proposals.feature)
- ✓ Create a new talk proposal
- ✓ Retrieve a proposal by ID
- ✓ Get all proposals
- ✓ Validate required fields of a proposal

### Proposal Approval (proposal_approval.feature)
- ✓ Approve a pending proposal
- ✓ Reject a pending proposal
- ✓ Cannot change status of an already approved proposal
- ✓ Get the status of a proposal

### Database Connection (database_connection.feature)
- ✓ Connect to MySQL database
- ✓ Disconnect from the database

### Data Validation (data_validation.feature)
- ✓ Validate correct email
- ✓ Reject invalid email
- ✓ Validate allowed durations
- ✓ Validate allowed categories
- ✓ Validate allowed experience levels

## 🔧 Compilación y Build

### Compilar el proyecto
```bash
mvn clean compile
```

### Empaquetar como JAR
```bash
mvn clean package
```

### Crear JAR con todas las dependencias
```bash
mvn clean package -DskipTests=true
# El archivo se genera en: target/java-swing-demo-1.0.0-jar-with-dependencies.jar
```

## 📝 Ejemplo de Step Definition

```java
import cucumber.api.java.en.Given;
import cucumber.api.java.en.When;
import cucumber.api.java.en.Then;

public class TalkProposalSteps {
    private TalkProposal currentProposal;
    private ProposalDAO dao;

    @Given("I have a database connection")
    public void iHaveADatabaseConnection() {
        try {
            DatabaseConnection.getConnection();
        } catch (Exception e) {
            // handle error
        }
    }

    @When("I create a proposal with speaker John Doe")
    public void iCreateAProposal() {
        currentProposal = new TalkProposal(0, "John Doe", "My Talk", 
                                         "Technical", "INTERMEDIATE", 45,
                                         "john@example.com", "PENDING");
    }

    @Then("the proposal should be created successfully")
    public void theProposalShouldBeCreated() {
        assert currentProposal != null;
        assert currentProposal.getStatus().equals("PENDING");
    }
}
```

## 📝 Ejemplo de Feature File

```gherkin
Feature: Talk Proposals Management
  As a conference organizer
  I want to manage talk proposals
  So that I can organize the conference schedule

  Scenario: Create a new talk proposal
    Given I have a database connection
    When I create a proposal with the following data:
      | Field      | Value             |
      | Speaker    | John Doe          |
      | Title      | Clean Code        |
      | Category   | Technical         |
      | Level      | INTERMEDIATE      |
      | Duration   | 45                |
      | Email      | john@example.com  |
    Then the proposal should be created successfully
    And the proposal status should be PENDING
```

## 🐛 Troubleshooting

### Error: "Cannot find Cucumber classes"
**Solución:** Ejecuta `mvn clean install` para descargar todas las dependencias.

### Error: "MySQL Connection refused"
**Solución:** Asegúrate de que MySQL está corriendo y que las credenciales en `DatabaseConnection.java` son correctas.

### Error: "Feature files not found"
**Solución:** Verifica que los archivos `.feature` están en `src/test/resources/features/`

## 🔄 Diferencias con el Branch Principal

| Aspecto | main | cucumber |
|--------|------|----------|
| Build Tool | Manual scripts | Maven |
| Dependency Management | Manual descargas | Automático (Maven Central) |
| Test Framework | JUnit básico | JUnit + Cucumber BDD |
| Feature Files | N/A | 4 feature files (15 escenarios) |
| Reports | N/A | HTML reports automáticos |
| Structure | No estándar | Maven estándar |

## 📚 Recursos

- [Cucumber Documentation](https://cucumber.io/docs/cucumber/)
- [Maven Documentation](https://maven.apache.org/guides/)
- [JUnit 4 Documentation](https://junit.org/junit4/)
- [Gherkin Syntax](https://cucumber.io/docs/gherkin/reference/)

## 👨‍💻 Próximos Pasos

1. Configurar una base de datos MySQL para los tests
2. Implementar mocking de BD para tests unitarios
3. Agregar CI/CD pipeline (GitHub Actions)
4. Extender features con más escenarios
5. Generar reporte de cobertura de código

---

**Branch creado en:** October 26, 2025
**Versión de Cucumber:** 4.8.1
**Versión de Java:** 1.8 (Java 8)
**Build Tool:** Maven 3.x
