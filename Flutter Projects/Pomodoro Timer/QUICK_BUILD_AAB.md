# Quick Guide: Build Signed AAB

## Prerequisites
✅ Build configuration is ready
✅ Signing setup is configured

## Quick Start

### 1. Create Keystore (First time only)

**Option 1: Use PowerShell Script (Recommended)**
```powershell
cd android
.\create_keystore.ps1
```

**Option 2: Use Batch File**
```cmd
cd android
create_keystore.bat
```

**Option 3: Manual Command**
```bash
cd android
keytool -genkey -v -keystore upload-keystore.jks -keyalg RSA -keysize 2048 -validity 10000 -alias pomodoro-timer-key
```
Then create `key.properties` from `key.properties.example` and fill in your passwords.

### 2. Build the AAB

From project root:
```bash
flutter build appbundle --release
```

### 3. Find Your AAB

The signed AAB will be at:
```
build/app/outputs/bundle/release/app-release.aab
```

---

**Need more details?** See `BUILD_AAB_INSTRUCTIONS.md` for complete instructions.



