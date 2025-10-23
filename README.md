# ☕ Java Swing y Dev Containers: El Regreso de un Clásico Contenarizado 🚀

<div align="center">

[![YouTube Channel Subscribers](https://img.shields.io/youtube/channel/subscribers/UC140iBrEZbOtvxWsJ-Tb0lQ?style=for-the-badge&logo=youtube&logoColor=white&color=red)](https://www.youtube.com/c/GiselaTorres?sub_confirmation=1)
[![GitHub followers](https://img.shields.io/github/followers/0GiS0?style=for-the-badge&logo=github&logoColor=white)](https://github.com/0GiS0)
[![LinkedIn Follow](https://img.shields.io/badge/LinkedIn-Sígueme-blue?style=for-the-badge&logo=linkedin&logoColor=white)](https://www.linkedin.com/in/giselatorresbuitrago/)
[![X Follow](https://img.shields.io/badge/X-Sígueme-black?style=for-the-badge&logo=x&logoColor=white)](https://twitter.com/0GiS0)

**[📖 Español](README.md) | [🇬🇧 English](README.en.md)**

</div>

![Portada](images/Portada.png)

¡Hola developer 👋🏻! En este repo encontrarás todo lo que necesitas para levantar un entorno de desarrollo para **Java Swing 🤸🏻** gracias a **Dev Containers**.

> 📖 Para más información detallada sobre este proyecto, consulta el artículo: [**Java Swing y Dev Containers: El regreso de un clásico contenarizado**](https://www.returngis.net/2025/10/java-swing-y-dev-containers-el-regreso-de-un-clasico-contenarizado/)

## 🎯 ¿Por qué hacer esto?

Porque queremos poder usar **Visual Studio Code 🧑🏻‍💻** con aplicaciones Java Swing aprovechando la versión más completa de **GitHub Copilot 🤖** dentro del entorno. Nada de instalaciones pesadas ni configuraciones eternas: solo abrir el contenedor y ¡a programar!

## 📋 Requisitos del host

Para poder ejecutar este proyecto necesitarás tener instalado lo siguiente en tu máquina:

- [Docker](https://docs.docker.com/get-docker/)
- [Visual Studio Code](https://code.visualstudio.com/download)
- [Extensión de Dev Containers para Visual Studio Code](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers)

### Configuración de X11 (Linux y macOS)

#### Linux
Asegúrate de tener instalado un servidor X11 (la mayoría de las distribuciones lo tienen por defecto).

#### macOS
Instala [XQuartz](https://www.xquartz.org/) de forma sencilla usando [Homebrew](https://brew.sh/):

```bash
brew install --cask xquartz
```

Una vez instalado, inicia XQuartz y ve a `Preferences > Security` y marca la opción `Allow connections from network clients`. Luego, reinicia XQuartz. Puedes hacerlo a través de la línea de comandos:

```bash
open -a XQuartz
defaults write org.xquartz.X11 nolisten_tcp -bool false
DISPLAY=:0 /opt/X11/bin/xhost +
```

Si quieres restringirlo después de usarlo, puedes ejecutar:

```bash
DISPLAY=:0 /opt/X11/bin/xhost -
```

Para comprobar que esta configuración funciona correctamente, abre este repo dentro de un contenedor y ejecuta:

```bash
echo $DISPLAY
xeyes
```

### Windows (WSL2/WSLg)

En el caso de **Windows con WSL2/WSLg**, no es necesario instalar un servidor X11 adicional, ya que **WSLg ya incluye soporte para aplicaciones gráficas de Linux de forma nativa**.

Lo único que necesitas es tener instalado:
- **Docker Desktop** con **WSL2**
- **Extensión de Dev Containers** en Visual Studio Code
- Asegúrate de que VS Code esté configurado para usar **WSL cuando ejecute Dev Containers**

Si arrancas el contenedor en Windows, ejecuta:

```bash
xeyes
```

¡Deberías ver los ojos 👀 siguiendo el cursor del ratón!

## 🚀 Comenzar rápidamente

### Opción 1: Usar el script (recomendado)

Una vez que tengas el contenedor abierto en VS Code, simplemente ejecuta:

```bash
./scripts/run.sh
```

Si estás en WSL2/WSLg, ejecuta:

```bash
./scripts/run-wsl2.sh
```

Este script compila y ejecuta automáticamente la aplicación.

### Opción 2: Pasos manuales

```bash
cd src
javac -cp ../lib/mysql-connector-j-8.2.0.jar *.java
java -cp .:../lib/mysql-connector-j-8.2.0.jar CallForPaperApp
```

## 📦 Call for Paper Application

Este proyecto incluye una **aplicación completa de "Call for Paper"** con integración a **MySQL usando JDBC** (forma clásica de conectar Java con bases de datos).

### ✨ Características

- **☕ Swing GUI** - Interfaz gráfica con Java Swing
- **🐬 MySQL Database** - Base de datos en contenedor Docker
- **🔗 JDBC Connection** - Conexión a MySQL usando JDBC puro (sin ORM)
- **📊 Data Management** - Crear, leer, actualizar y eliminar propuestas de charlas
- **✅ Unit Tests** - Pruebas unitarias con JUnit y Mockito
- **🐳 Dev Containers** - Entorno reproducible y aislado

### 📁 Estructura del Proyecto

```
java-swing-demo/
├── src/                              # Código fuente
│   ├── CallForPaperApp.java         # ☕ Aplicación principal con UI
│   ├── DatabaseConnection.java      # 🔗 Manejo de conexiones JDBC
│   ├── TalkProposal.java            # 📝 Modelo de datos
│   ├── ProposalDAO.java             # 📊 Data Access Object
│   └── Controller.java              # 🎮 Lógica de la aplicación
│
├── test/                             # Tests
│   ├── DatabaseConnectionTest.java
│   ├── ProposalDAOTest.java
│   └── TalkProposalTest.java
│
├── lib/                              # Dependencias externas
│   ├── mysql-connector-j-8.2.0.jar  # Driver JDBC de MySQL
│   ├── junit-4.13.2.jar
│   ├── hamcrest-2.2.jar
│   ├── mockito-core-4.8.0.jar
│   ├── byte-buddy-1.12.16.jar
│   └── objenesis-3.2.jar
│
├── .devcontainer/                    # Configuración de Dev Containers
│   ├── devcontainer.json            # 🐳 Configuración del contenedor
│   ├── Dockerfile                   # Imagen personalizada
│   ├── docker-compose.yml           # Servicios (Java + MySQL)
│   └── init.sql                     # Script de inicialización de BD
│
├── scripts/                          # 📂 Directorio de scripts
│   ├── compile.sh                   # 🔨 Script para compilar
│   ├── run.sh                       # 🚀 Script para ejecutar
│   ├── test.sh                      # ✅ Script para tests
│   ├── compile-wsl2.sh              # 🪟 Script para compilar en WSL2
│   ├── run-wsl2.sh                  # 🪟 Script para ejecutar en WSL2
│   ├── test-wsl2.sh                 # 🪟 Script para tests en WSL2
│   ├── build.sh                     # 🏗️ Script para construir JAR
│   ├── build-and-run.sh             # 🏗️ Script para construir y ejecutar
│   ├── run-local.sh                 # 🖥️ Script para ejecutar localmente
│   ├── create-macos-app.sh          # 🍎 Script para crear .app de macOS
│   ├── package-release.sh           # 📦 Script para empaquetar distribución
│   ├── configure.sh                 # ⚙️ Script para configurar
│   ├── install-mac.sh               # 📦 Script para instalar en macOS
│   └── quick-start.sh               # 🚀 Guía rápida interactiva
│
└── README.md                         # Este archivo
```

### 🐬 Base de Datos

El contenedor incluye **MySQL 8.0** pre-configurado con:

- **Base de datos**: `callforpaper`
- **Usuario**: `developer`
- **Contraseña**: `developer123`
- **Host** (desde el contenedor): `mysql`
- **Puerto**: `3306`

La tabla `talks` se crea automáticamente con la siguiente estructura:

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

## 🧪 Ejecutar Tests

Para ejecutar los tests unitarios:

```bash
./scripts/test.sh
```

O en WSL2:

```bash
./scripts/test-wsl2.sh
```

Los tests incluyen:
- ✅ Pruebas de conexión a base de datos
- ✅ Pruebas de operaciones CRUD
- ✅ Pruebas del modelo de datos

## 📚 Documentación Adicional

Para más información técnica detallada sobre la implementación JDBC y arquitectura, consulta el archivo [JDBC_GUIDE.md](JDBC_GUIDE.md).

## 💡 Solución de Problemas

### La aplicación gráfica no se abre en macOS

- Asegúrate de tener XQuartz instalado y ejecutándose
- Verifica que has ejecutado los comandos para habilitar conexiones remotas:
  ```bash
  open -a XQuartz
  defaults write org.xquartz.X11 nolisten_tcp -bool false
  DISPLAY=:0 /opt/X11/bin/xhost +
  ```

### Error de conexión a MySQL

- Verifica que Docker está en ejecución
- Asegúrate de que el servicio de MySQL en el contenedor ha iniciado correctamente
- Intenta reiniciar el Dev Container

### Scripts no tienen permisos de ejecución

```bash
chmod +x *.sh
```

## 🏗️ Stack Tecnológico

| Componente | Versión | Propósito |
|-----------|---------|----------|
| **Java** | JDK 17 | Lenguaje principal |
| **Swing** | JDK builtin | Framework UI de escritorio |
| **MySQL** | 8.0 | Base de datos relacional |
| **JDBC** | MySQL Connector 8.2.0 | Driver de conexión a BD |
| **JUnit** | 4.13.2 | Framework de testing |
| **Mockito** | 4.8.0 | Framework de mocking |
| **Docker** | Latest | Containerización |
| **VS Code** | Latest | IDE |

---

<div align="center">

**Hecho con ❤️ por [Gisela Torres](https://www.returngis.net/)**

</div>