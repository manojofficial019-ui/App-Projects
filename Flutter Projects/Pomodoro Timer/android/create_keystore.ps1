# PowerShell script to create Android keystore for release builds
# Run this script from the android directory

Write-Host "Creating Android Keystore for Release Builds" -ForegroundColor Green
Write-Host ""

# Check if keytool is available
$keytoolPath = Get-Command keytool -ErrorAction SilentlyContinue
if (-not $keytoolPath) {
    Write-Host "ERROR: keytool not found. Please install Java JDK." -ForegroundColor Red
    Write-Host "Download from: https://adoptium.net/" -ForegroundColor Yellow
    exit 1
}

# Prompt for keystore password
$keystorePassword = Read-Host "Enter keystore password (min 6 characters)" -AsSecureString
$keystorePasswordPlain = [Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR($keystorePassword))

if ($keystorePasswordPlain.Length -lt 6) {
    Write-Host "ERROR: Password must be at least 6 characters" -ForegroundColor Red
    exit 1
}

# Prompt for key password (default: same as keystore)
Write-Host ""
$keyPasswordPlain = Read-Host "Enter key password (press Enter to use same as keystore)"
if ([string]::IsNullOrWhiteSpace($keyPasswordPlain)) {
    $keyPasswordPlain = $keystorePasswordPlain
}

# Keystore details
$keystoreFile = "upload-keystore.jks"
$keyAlias = "pomodoro-timer-key"

# Check if keystore already exists
if (Test-Path $keystoreFile) {
    $overwrite = Read-Host "Keystore file already exists. Overwrite? (y/N)"
    if ($overwrite -ne "y" -and $overwrite -ne "Y") {
        Write-Host "Aborted." -ForegroundColor Yellow
        exit 0
    }
    Remove-Item $keystoreFile -Force
}

Write-Host ""
Write-Host "Creating keystore..." -ForegroundColor Cyan

# Create keystore (using dname with common values, user can modify)
$dname = "CN=Pomodoro Timer, OU=Development, O=Your Organization, L=City, ST=State, C=US"

$process = Start-Process -FilePath "keytool" -ArgumentList @(
    "-genkey",
    "-v",
    "-keystore", $keystoreFile,
    "-keyalg", "RSA",
    "-keysize", "2048",
    "-validity", "10000",
    "-alias", $keyAlias,
    "-storepass", $keystorePasswordPlain,
    "-keypass", $keyPasswordPlain,
    "-dname", $dname
) -Wait -NoNewWindow -PassThru

if ($process.ExitCode -eq 0) {
    Write-Host ""
    Write-Host "✓ Keystore created successfully!" -ForegroundColor Green
    Write-Host ""
    
    # Create key.properties file
    $keyPropertiesContent = @"
storePassword=$keystorePasswordPlain
keyPassword=$keyPasswordPlain
keyAlias=$keyAlias
storeFile=$keystoreFile
"@
    
    $keyPropertiesFile = "key.properties"
    if (Test-Path $keyPropertiesFile) {
        $overwrite = Read-Host "key.properties already exists. Overwrite? (y/N)"
        if ($overwrite -eq "y" -or $overwrite -eq "Y") {
            $keyPropertiesContent | Out-File -FilePath $keyPropertiesFile -Encoding utf8 -NoNewline
            Write-Host "✓ key.properties created/updated!" -ForegroundColor Green
        }
    } else {
        $keyPropertiesContent | Out-File -FilePath $keyPropertiesFile -Encoding utf8 -NoNewline
        Write-Host "✓ key.properties created!" -ForegroundColor Green
    }
    
    Write-Host ""
    Write-Host "Next steps:" -ForegroundColor Cyan
    Write-Host "1. Review and edit key.properties if needed" -ForegroundColor White
    Write-Host "2. Build signed AAB: flutter build appbundle --release" -ForegroundColor White
    Write-Host ""
    Write-Host "IMPORTANT: Keep your keystore file and passwords secure!" -ForegroundColor Yellow
} else {
    Write-Host ""
    Write-Host "ERROR: Failed to create keystore" -ForegroundColor Red
    exit 1
}



