# Build signed AAB file
Write-Host "Building signed AAB file..." -ForegroundColor Cyan
Write-Host ""

# Change to script directory
Set-Location $PSScriptRoot

# Run Flutter build
flutter build appbundle --release

if ($LASTEXITCODE -eq 0) {
    Write-Host ""
    Write-Host "========================================" -ForegroundColor Green
    Write-Host "Build successful!" -ForegroundColor Green
    Write-Host "========================================" -ForegroundColor Green
    Write-Host ""
    Write-Host "Signed AAB file location:" -ForegroundColor Cyan
    Write-Host "build\app\outputs\bundle\release\app-release.aab" -ForegroundColor White
    Write-Host ""
} else {
    Write-Host ""
    Write-Host "Build failed. Please check the error messages above." -ForegroundColor Red
    Write-Host ""
}

Read-Host "Press Enter to exit"


