@echo off
REM Batch script to create Android keystore for release builds
REM Run this script from the android directory

echo Creating Android Keystore for Release Builds
echo.

REM Check if keytool is available
where keytool >nul 2>&1
if %errorlevel% neq 0 (
    echo ERROR: keytool not found. Please install Java JDK.
    echo Download from: https://adoptium.net/
    pause
    exit /b 1
)

set KEYSTORE_FILE=upload-keystore.jks
set KEY_ALIAS=pomodoro-timer-key

REM Check if keystore already exists
if exist "%KEYSTORE_FILE%" (
    set /p OVERWRITE="Keystore file already exists. Overwrite? (y/N): "
    if /i not "%OVERWRITE%"=="y" (
        echo Aborted.
        pause
        exit /b 0
    )
    del /f "%KEYSTORE_FILE%"
)

echo.
echo Creating keystore...
echo You will be prompted for passwords and certificate information.
echo.

REM Create keystore (interactive mode)
keytool -genkey -v -keystore %KEYSTORE_FILE% -keyalg RSA -keysize 2048 -validity 10000 -alias %KEY_ALIAS%

if %errorlevel% equ 0 (
    echo.
    echo Keystore created successfully!
    echo.
    echo IMPORTANT: You need to create key.properties file manually.
    echo Copy key.properties.example to key.properties and fill in your passwords.
    echo.
    echo Next steps:
    echo 1. Copy key.properties.example to key.properties
    echo 2. Edit key.properties and fill in your keystore password, key password, alias, and store file name
    echo 3. Build signed AAB: flutter build appbundle --release
    echo.
    echo IMPORTANT: Keep your keystore file and passwords secure!
) else (
    echo.
    echo ERROR: Failed to create keystore
)

pause



