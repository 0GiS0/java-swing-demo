# ☕ Java Swing and Dev Containers: The Return of a Containerized Classic 🚀

<div align="center">

[![YouTube Channel Subscribers](https://img.shields.io/youtube/channel/subscribers/UC140iBrEZbOtvxWsJ-Tb0lQ?style=for-the-badge&logo=youtube&logoColor=white&color=red)](https://www.youtube.com/c/GiselaTorres?sub_confirmation=1)
[![GitHub followers](https://img.shields.io/github/followers/0GiS0?style=for-the-badge&logo=github&logoColor=white)](https://github.com/0GiS0)
[![LinkedIn Follow](https://img.shields.io/badge/LinkedIn-Follow-blue?style=for-the-badge&logo=linkedin&logoColor=white)](https://www.linkedin.com/in/giselatorresbuitrago/)
[![X Follow](https://img.shields.io/badge/X-Follow-black?style=for-the-badge&logo=x&logoColor=white)](https://twitter.com/0GiS0)

**[📖 Español](README.md) | [🇬🇧 English](README.en.md)**

</div>

![Portada](images/Portada.png)

Hello developer 👋🏻! In this repo you'll find everything you need to set up a development environment for **Java Swing 🤸🏻** using **Dev Containers**.

> 📖 For more detailed information about this project, check out the article: [**Java Swing and Dev Containers: The return of a containerized classic**](https://www.returngis.net/2025/10/java-swing-y-dev-containers-el-regreso-de-un-clasico-contenarizado/) (Spanish)

## 🎯 Why do this?

Because we want to use **Visual Studio Code 🧑🏻‍💻** with Java Swing applications while taking advantage of the most complete version of **GitHub Copilot 🤖** within the environment. No heavy installations or endless configurations: just open the container and start coding!

## 📋 Host Requirements

To run this project you'll need to have the following installed on your machine:

- [Docker](https://docs.docker.com/get-docker/)
- [Visual Studio Code](https://code.visualstudio.com/download)
- [Dev Containers Extension for Visual Studio Code](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers)

### X11 Configuration (Linux and macOS)

#### Linux
Make sure you have an X11 server installed (most distributions have it by default).

#### macOS
Install [XQuartz](https://www.xquartz.org/) easily using [Homebrew](https://brew.sh/):

```bash
brew install --cask xquartz
```

Once installed, start XQuartz and go to `Preferences > Security` and check the `Allow connections from network clients` option. Then restart XQuartz. You can do this through the command line:

```bash
open -a XQuartz
defaults write org.xquartz.X11 nolisten_tcp -bool false
DISPLAY=:0 /opt/X11/bin/xhost +
```

If you want to restrict it after using it, you can run:

```bash
DISPLAY=:0 /opt/X11/bin/xhost -
```

To verify this configuration works correctly, open this repo inside a container and run:

```bash
echo $DISPLAY
xeyes
```

### Windows (WSL2/WSLg)

For **Windows with WSL2/WSLg**, there's no need to install an additional X11 server, since **WSLg already includes native support for Linux graphical applications**.

All you need is:
- **Docker Desktop** with **WSL2**
- **Dev Containers Extension** in Visual Studio Code
- Make sure VS Code is configured to use **WSL when running Dev Containers**

If you launch the container on Windows, run:

```bash
xeyes
```

You should see the eyes 👀 following your cursor!

## 🚀 Quick Start

### Option 1: Use the script (recommended)

Once you have the container open in VS Code, simply run:

```bash
./scripts/run.sh
```

If you're on WSL2/WSLg, run:

```bash
./scripts/run-wsl2.sh
```

This script compiles and runs the application automatically.

### Option 2: Manual steps

```bash
cd src
javac -cp ../lib/mysql-connector-j-8.2.0.jar *.java
java -cp .:../lib/mysql-connector-j-8.2.0.jar CallForPaperApp
```

## 📦 Call for Paper Application

This project includes a **complete "Call for Paper" application** with **MySQL integration using JDBC** (the classic way to connect Java with databases).

### ✨ Features

- **☕ Swing GUI** - Graphical interface with Java Swing
- **🐬 MySQL Database** - Database in Docker container
- **🔗 JDBC Connection** - Connection to MySQL using pure JDBC (no ORM)
- **📊 Data Management** - Create, read, update, and delete talk proposals
- **✅ Unit Tests** - Unit tests with JUnit and Mockito
- **🐳 Dev Containers** - Reproducible and isolated environment

### 📁 Project Structure

```
java-swing-demo/
├── src/                              # Source code
│   ├── CallForPaperApp.java         # ☕ Main application with UI
│   ├── DatabaseConnection.java      # 🔗 JDBC connection handling
│   ├── TalkProposal.java            # 📝 Data model
│   ├── ProposalDAO.java             # 📊 Data Access Object
│   └── Controller.java              # 🎮 Application logic
│
├── test/                             # Tests
│   ├── DatabaseConnectionTest.java
│   ├── ProposalDAOTest.java
│   └── TalkProposalTest.java
│
├── lib/                              # External dependencies
│   ├── mysql-connector-j-8.2.0.jar  # MySQL JDBC driver
│   ├── junit-4.13.2.jar
│   ├── hamcrest-2.2.jar
│   ├── mockito-core-4.8.0.jar
│   ├── byte-buddy-1.12.16.jar
│   └── objenesis-3.2.jar
│
├── .devcontainer/                    # Dev Containers configuration
│   ├── devcontainer.json            # 🐳 Container configuration
│   ├── Dockerfile                   # Custom image
│   ├── docker-compose.yml           # Services (Java + MySQL)
│   └── init.sql                     # Database initialization script
│
├── scripts/                          # 📂 Scripts directory
│   ├── compile.sh                   # 🔨 Compile script
│   ├── run.sh                       # 🚀 Run script
│   ├── test.sh                      # ✅ Tests script
│   ├── compile-wsl2.sh              # 🪟 Compile script for WSL2
│   ├── run-wsl2.sh                  # 🪟 Run script for WSL2
│   ├── test-wsl2.sh                 # 🪟 Tests script for WSL2
│   ├── build.sh                     # 🏗️ Build JAR script
│   ├── build-and-run.sh             # 🏗️ Build and run script
│   ├── run-local.sh                 # 🖥️ Run locally script
│   ├── create-macos-app.sh          # 🍎 Create macOS .app script
│   ├── package-release.sh           # 📦 Package release script
│   ├── configure.sh                 # ⚙️ Configuration script
│   ├── install-mac.sh               # 📦 macOS installation script
│   └── quick-start.sh               # 🚀 Interactive quick start guide
│
└── README.md                         # This file
```

### 🐬 Database

The container includes **MySQL 8.0** pre-configured with:

- **Database**: `callforpaper`
- **User**: `developer`
- **Password**: `developer123`
- **Host** (from inside the container): `mysql`
- **Port**: `3306`

The `talks` table is created automatically with the following structure:

```sql
CREATE TABLE talks (
    id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    description TEXT,
    speaker_name VARCHAR(255),
    speaker_email VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

## 🧪 Running Tests

To run the unit tests:

```bash
./scripts/test.sh
```

Or on WSL2:

```bash
./scripts/test-wsl2.sh
```

The tests include:
- ✅ Database connection tests
- ✅ CRUD operations tests
- ✅ Data model tests

### 🥒 BDD Testing with Cucumber (Branch `cucumber`)

This project includes a dedicated branch (`cucumber`) with **BDD (Behavior-Driven Development) testing** using **Cucumber and Maven**.

#### 📋 BDD Testing Features

- **Feature Files** - 4 files in Gherkin format (English)
- **Step Definitions** - Step implementation in Java (~25 methods)
- **Maven Integration** - Automatic dependency management
- **HTML Reports** - Automatic execution reports

#### 🎯 Covered Scenarios (15 scenarios)

| Feature | Scenarios | Description |
|---------|-----------|------------|
| **Talk Proposals** | 4 | CRUD operations for proposals |
| **Proposal Approval** | 4 | Approval/rejection workflow |
| **Database Connection** | 2 | MySQL connectivity |
| **Data Validation** | 5 | Input data validation |

#### 🚀 Running BDD Tests

In the `cucumber` branch, you can run tests in different ways:

**Option 1: Run ALL tests (Unit + BDD)**
```bash
git checkout cucumber
mvn clean test
```

**Option 2: Run only Unit Tests**
```bash
mvn clean test -Dtests=unit
# Or with profile
mvn clean test -P unit-tests
```

**Option 3: Run only BDD Tests (Cucumber)**
```bash
mvn clean test -Dtests=bdd
# Or with profile
mvn clean test -P bdd-tests
```

**Option 4: Use automated script**
```bash
# All tests
./scripts/run-tests.sh --all

# Unit tests only
./scripts/run-tests.sh --unit

# BDD tests only
./scripts/run-tests.sh --bdd
```

**Option 5: Run tests AND generate reports (RECOMMENDED)**
```bash
# Run all tests
mvn clean test

# Generate reports in HTML and Markdown
./scripts/create-report-index.sh

# Or all together
mvn clean test && ./scripts/create-report-index.sh
```

#### 📊 Generated Reports

**Reports available after running tests:**

1. **Interactive HTML Dashboard**
   ```
   target/test-reports/index.html
   ```
   - Interactive view with real-time statistics
   - Direct links to detailed Cucumber reports
   - Git branch and commit information

2. **Markdown Report**
   ```
   target/test-reports/TEST_REPORT.md
   ```
   - Executive summary in table format
   - Detailed Unit Tests and BDD Tests statistics
   - Quality metrics
   - Execution instructions

3. **Detailed Cucumber Reports**
   ```
   target/test-reports/cucumber-html-reports/
   ```
   - Features report
   - Steps report
   - Failures report
   - Tags report

📖 For more information about reports, see [REPORTING_GUIDE.md](REPORTING_GUIDE.md)

#### 📁 Cucumber Branch Structure

```
cucumber branch/
├── pom.xml                              # Maven configuration
├── src/
│   ├── main/java/
│   │   ├── CallForPaperApp.java
│   │   ├── DatabaseConnection.java
│   │   ├── ProposalDAO.java
│   │   ├── TalkProposal.java
│   │   └── CucumberCLI.java
│   └── test/
│       ├── java/
│       │   ├── TalkProposalSteps.java
│       │   ├── ProposalApprovalSteps.java
│       │   ├── DatabaseConnectionSteps.java
│       │   ├── DataValidationSteps.java
│       │   └── CucumberRunnerTest.java
│       └── resources/features/
│           ├── talk_proposals.feature
│           ├── proposal_approval.feature
│           ├── database_connection.feature
│           └── data_validation.feature
└── docs/                                # Detailed documentation
    ├── CUCUMBER.md
    ├── RUN_TESTS.md
    └── REPORTING_GUIDE.md
```

#### 📊 Main Dependencies (Maven)

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

<!-- Mockito for testing -->
<dependency>
    <groupId>org.mockito</groupId>
    <artifactId>mockito-core</artifactId>
    <version>4.8.0</version>
    <scope>test</scope>
</dependency>
```

#### 🔄 Differences: `main` vs `cucumber`

| Aspect | main | cucumber |
|--------|------|----------|
| **Build Tool** | Bash scripts | Maven |
| **Test Framework** | Basic JUnit | JUnit + Cucumber BDD |
| **Feature Files** | N/A | 4 feature files (Gherkin) |
| **Structure** | Non-standard | Maven standard |
| **Reports** | N/A | Automatic HTML reports |

📖 For more detailed information, see [CUCUMBER.md](docs/CUCUMBER.md)

## 📚 Additional Documentation

For more detailed information, check the documentation files in the `docs/` folder:
- 🥒 [CUCUMBER.md](docs/CUCUMBER.md) - Complete BDD testing guide
- 🧪 [RUN_TESTS.md](docs/RUN_TESTS.md) - Ways to run tests
- 📊 [REPORTING_GUIDE.md](docs/REPORTING_GUIDE.md) - Information about reports

## 💡 Troubleshooting

### The GUI doesn't open on macOS

- Make sure you have XQuartz installed and running
- Verify that you've executed the commands to enable remote connections:
  ```bash
  open -a XQuartz
  defaults write org.xquartz.X11 nolisten_tcp -bool false
  DISPLAY=:0 /opt/X11/bin/xhost +
  ```

### MySQL connection error

- Check that Docker is running
- Make sure the MySQL service in the container has started correctly
- Try restarting the Dev Container

### Scripts don't have execute permissions

```bash
chmod +x *.sh
```

## 🚀 Continuous Integration (CI/CD)

This project includes an **automatic GitHub Actions workflow** that runs tests and generates reports on every push or pull request.

### 🔄 Automatic Flow

```
Push/PR → Tests (Unit + BDD) → Generate Reports → Build Artifacts
```

### 📊 Workflow: `.github/workflows/test-and-report.yml`

**Automatically runs:**
1. ✅ **Unit Tests** - JUnit with Maven
2. 🥒 **BDD Tests** - Cucumber with Maven
3. 📊 **Generates Reports**:
   - Interactive HTML dashboard
   - Markdown report
   - Detailed Cucumber reports
4. 📦 **Uploads Artifacts** - For later review
5. 💬 **Comments on PRs** - With results summary

### 🔍 Test Results in CI/CD

Reports are saved as artifacts in GitHub Actions:
- `test-reports/` - Dashboard and Markdown
- `surefire-reports/` - JUnit XML reports
- `cucumber-reports/` - Cucumber JSON reports

**To view reports:**
1. Open the PR or workflow on GitHub
2. Go to the "Actions" tab
3. Select the "🧪 Test and Report" workflow
4. Download artifacts from the "Artifacts" section

### ⚙️ Workflow Configuration

The workflow runs on:
- ✅ **Push** to `main`, `cucumber`, `develop`
- ✅ **Pull Requests** to `main`, `cucumber`, `develop`
- ✅ **Manual** - using `workflow_dispatch`

### 🛑 Test Failures

If any test fails:
- ❌ The workflow marks the build as **failed**
- 📝 Reports are saved anyway
- 💬 Comments on the PR with results
- 🔗 Artifacts remain for 30 days for review

---

## 🏗️ Technology Stack

| Component | Version | Purpose |
|-----------|---------|----------|
| **Java** | JDK 17 | Main language |
| **Swing** | JDK builtin | Desktop UI framework |
| **MySQL** | 8.0 | Relational database |
| **JDBC** | MySQL Connector 8.2.0 | Database connection driver |
| **JUnit** | 4.13.2 | Testing framework |
| **Mockito** | 4.8.0 | Mocking framework |
| **Docker** | Latest | Containerization |
| **VS Code** | Latest | IDE |

---

<div align="center">

**Made with ❤️ by [Gisela Torres](https://www.returngis.net/)**

</div>
