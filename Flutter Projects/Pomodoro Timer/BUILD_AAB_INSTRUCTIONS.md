# Building Signed AAB File

Follow these steps to build a signed Android App Bundle (AAB) for Google Play Store.

## Step 1: Create Keystore (One-time setup)

### Option A: Using PowerShell Script (Windows)
1. Open PowerShell
2. Navigate to the `android` directory:
   ```powershell
   cd android
   ```
3. Run the script:
   ```powershell
   .\create_keystore.ps1
   ```
4. Follow the prompts to enter passwords

### Option B: Manual Creation
1. Open terminal/command prompt
2. Navigate to the `android` directory
3. Run:
   ```bash
   keytool -genkey -v -keystore upload-keystore.jks -keyalg RSA -keysize 2048 -validity 10000 -alias pomodoro-timer-key
   ```
4. Enter your details when prompted
5. Copy `key.properties.example` to `key.properties`
6. Edit `key.properties` and fill in your passwords

## Step 2: Verify key.properties

Make sure `android/key.properties` exists and contains:
```properties
storePassword=YOUR_KEYSTORE_PASSWORD
keyPassword=YOUR_KEY_PASSWORD
keyAlias=pomodoro-timer-key
storeFile=upload-keystore.jks
```

## Step 3: Build the Signed AAB

From the project root directory, run:

```bash
flutter build appbundle --release
```

The signed AAB file will be created at:
```
build/app/outputs/bundle/release/app-release.aab
```

## Step 4: Verify the AAB

You can verify the AAB is signed by running:
```bash
jarsigner -verify -verbose -certs build/app/outputs/bundle/release/app-release.aab
```

Or upload it to Google Play Console - it will verify the signature automatically.

## Troubleshooting

### "key.properties not found"
- Make sure you created `key.properties` in the `android` directory
- Check that the file path in `key.properties` is correct

### "Keystore was tampered with, or password was incorrect"
- Double-check your passwords in `key.properties`
- Make sure there are no extra spaces or characters

### "keytool: command not found"
- Install Java JDK from https://adoptium.net/
- Make sure Java is in your system PATH

## Important Notes

⚠️ **Keep your keystore file secure!**
- Never commit `key.properties` or `*.jks` files to version control
- Keep backups of your keystore file in a safe place
- You'll need the same keystore for all future app updates
- If you lose your keystore, you cannot update your app on Google Play

## Next Steps

After building the AAB:
1. Go to Google Play Console (https://play.google.com/console)
2. Create a new app or select existing app
3. Go to Production → Create new release
4. Upload the `app-release.aab` file
5. Fill in release notes and submit



