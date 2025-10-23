@echo off
REM Build script for Call For Paper Application on Windows

setlocal enabledelayedexpansion

set PROJECT_NAME=CallForPaperApp
set VERSION=1.0.0
set BUILD_DIR=build
set DIST_DIR=dist
set SRC_DIR=src
set LIB_DIR=lib

echo.
echo ==================================
echo 📦 Building %PROJECT_NAME% v%VERSION%
echo ==================================
echo.

REM Create build directories
if not exist "%BUILD_DIR%" mkdir "%BUILD_DIR%"
if not exist "%DIST_DIR%" mkdir "%DIST_DIR%"

echo 🔨 Step 1: Compiling Java source files...

REM Find and compile all Java files except Test files
setlocal enabledelayedexpansion
set "javac_cmd=javac -d "%BUILD_DIR%" -cp "%LIB_DIR%\*""

for /r "%SRC_DIR%" %%F in (*.java) do (
    if not "%%~nF"=="*Test.java" (
        set "javac_cmd=!javac_cmd! "%%F""
    )
)

%javac_cmd%

if %errorlevel% neq 0 (
    echo ❌ Compilation failed!
    pause
    exit /b 1
)
echo ✅ Compilation successful!
echo.

echo 🔨 Step 2: Creating JAR file...
if exist "%DIST_DIR%\%PROJECT_NAME%.jar" del "%DIST_DIR%\%PROJECT_NAME%.jar"

jar cf "%DIST_DIR%\%PROJECT_NAME%.jar" -C "%BUILD_DIR%" .

if %errorlevel% neq 0 (
    echo ❌ JAR creation failed!
    pause
    exit /b 1
)
echo ✅ JAR file created: %DIST_DIR%\%PROJECT_NAME%.jar
echo.

echo 🔨 Step 3: Copying libraries...
if exist "%DIST_DIR%\lib" rmdir /s /q "%DIST_DIR%\lib"
xcopy "%LIB_DIR%" "%DIST_DIR%\lib\" /E /I /Y >nul
if %errorlevel% neq 0 (
    echo ❌ Library copy failed!
    pause
    exit /b 1
)
echo ✅ Libraries copied!
echo.

echo ==================================
echo ✅ Build completed successfully!
echo ==================================
echo.
