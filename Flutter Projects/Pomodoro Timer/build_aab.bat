@echo off
REM Build signed AAB file
echo Building signed AAB file...
echo.

cd /d "%~dp0"

flutter build appbundle --release

if %errorlevel% equ 0 (
    echo.
    echo ========================================
    echo Build successful!
    echo ========================================
    echo.
    echo Signed AAB file location:
    echo build\app\outputs\bundle\release\app-release.aab
    echo.
) else (
    echo.
    echo Build failed. Please check the error messages above.
    echo.
)

pause


