@echo off
REM Creates a portable Windows executable with custom icon using Launch4j

setlocal enabledelayedexpansion

set APP_NAME=CallForPaperApp
set VERSION=1.0.0
set DIST_DIR=dist
set WINDOWS_DIR=%DIST_DIR%\windows
set OUTPUT_EXE=%WINDOWS_DIR%\%APP_NAME%.exe

echo.
echo 🪟 Creating Windows portable executable...
echo.

REM Check if Launch4j is installed
where launch4j >nul 2>&1
if %errorlevel% neq 0 (
    echo ❌ Launch4j is not installed
    echo.
    echo 📦 To create Windows executables, install Launch4j:
    echo.
    echo    Download from: https://launch4j.sourceforge.net/
    echo.
    echo    Steps:
    echo    1. Download Launch4j from the website
    echo    2. Install it (default: C:\Program Files\Launch4j)
    echo    3. Add Launch4j bin directory to PATH:
    echo       - Right-click "This PC" ^> Properties
    echo       - Click "Advanced system settings"
    echo       - Click "Environment Variables"
    echo       - Add: C:\Program Files\Launch4j\bin to PATH
    echo    4. Restart this script
    echo.
    pause
    exit /b 1
)

REM Create windows directory
if not exist "%WINDOWS_DIR%" mkdir "%WINDOWS_DIR%"

REM Build first
echo 🔨 Building application...
call scripts\build.bat
if %errorlevel% neq 0 (
    echo ❌ Build failed
    pause
    exit /b 1
)

REM Copy JAR to windows directory
echo 📋 Copying JAR file...
if exist "%DIST_DIR%\%APP_NAME%.jar" (
    copy "%DIST_DIR%\%APP_NAME%.jar" "%WINDOWS_DIR%\" >nul
)
if exist "%DIST_DIR%\lib" (
    xcopy "%DIST_DIR%\lib" "%WINDOWS_DIR%\lib\" /E /I /Y >nul
)

REM Convert PNG icon to ICO if needed
if exist "images\icon-app.png" (
    echo 🎨 Processing icon...
    
    REM Check if ImageMagick is installed
    where convert >nul 2>&1
    if !errorlevel! equ 0 (
        echo   Converting PNG to ICO format...
        convert "images\icon-app.png" -define icon:auto-resize=256,128,96,64,48,32,16 "%WINDOWS_DIR%\icon.ico"
        if !errorlevel! equ 0 (
            echo ✅ Icon converted to ICO format
            set ICON_PATH=%WINDOWS_DIR%\icon.ico
        ) else (
            echo ⚠️  Failed to convert icon
            set ICON_PATH=
        )
    ) else (
        echo ⚠️  ImageMagick not found - icon conversion skipped
        echo    Download from: https://imagemagick.org/script/download.php
        set ICON_PATH=
    )
) else (
    echo ⚠️  Icon not found at images\icon-app.png
    set ICON_PATH=
)

REM Create Launch4j configuration file
set CONFIG_FILE=%WINDOWS_DIR%\launch4j-config.xml

echo ⚙️  Generating Launch4j configuration...

(
    echo ^<?xml version="1.0" encoding="UTF-8"?^>
    echo ^<launch4jConfig^>
    echo   ^<dontWrapJar^>false^</dontWrapJar^>
    echo   ^<headerType^>gui^</headerType^>
    echo   ^<jar^>CallForPaperApp.jar^</jar^>
    echo   ^<outfile^>CallForPaperApp.exe^</outfile^>
    echo   ^<errTitle^>Error^</errTitle^>
    echo   ^<cmdLine^>^</cmdLine^>
    echo   ^<chdir^>.^</chdir^>
    echo   ^<priority^>normal^</priority^>
    echo   ^<downloadUrl^>https://adoptium.net/^</downloadUrl^>
    echo   ^<supportUrl^>^</supportUrl^>
    echo   ^<stayAlive^>false^</stayAlive^>
    echo   ^<restartOnCrash^>false^</restartOnCrash^>
    echo   ^<manifest^>^</manifest^>
    echo   ^<icon^>icon.ico^</icon^>
    echo   ^<jre^>
    echo     ^<path^>^</path^>
    echo     ^<bundledJre64Bit^>false^</bundledJre64Bit^>
    echo     ^<bundledJreAsFallback^>false^</bundledJreAsFallback^>
    echo     ^<minVersion^>17^</minVersion^>
    echo     ^<maxVersion^>^</maxVersion^>
    echo     ^<jdkPreference^>preferJre^</jdkPreference^>
    echo     ^<runtimeBits^>64/32^</runtimeBits^>
    echo     ^<initialHeapSize^>512^</initialHeapSize^>
    echo     ^<maxHeapSize^>1024^</maxHeapSize^>
    echo   ^</jre^>
    echo   ^<versionInfo^>
    echo     ^<fileVersion^>1.0.0.0^</fileVersion^>
    echo     ^<txtFileVersion^>1.0.0^</txtFileVersion^>
    echo     ^<fileDescription^>Call For Paper Application^</fileDescription^>
    echo     ^<copyright^>2025^</copyright^>
    echo     ^<productVersion^>1.0.0.0^</productVersion^>
    echo     ^<txtProductVersion^>1.0.0^</txtProductVersion^>
    echo     ^<productName^>CallForPaperApp^</productName^>
    echo     ^<companyName^>^</companyName^>
    echo     ^<internalName^>CallForPaperApp^</internalName^>
    echo     ^<originalFilename^>CallForPaperApp.exe^</originalFilename^>
    echo     ^<trademarks^>^</trademarks^>
    echo     ^<language^>1033^</language^>
    echo   ^</versionInfo^>
    echo ^</launch4jConfig^>
) > "%CONFIG_FILE%"

REM Create the executable
echo 🔨 Building Windows executable with Launch4j...
pushd "%WINDOWS_DIR%"
call launch4j launch4j-config.xml

if exist "CallForPaperApp.exe" (
    echo.
    echo ✅ Windows executable created successfully!
    echo 📍 Location: %CD%\CallForPaperApp.exe
    echo.
    echo 📦 Files included in the package:
    dir /B
    echo.
    echo 🚀 Ready to distribute!
    echo.
) else (
    echo.
    echo ❌ Failed to create executable
    echo.
    popd
    pause
    exit /b 1
)
popd

pause
