# Creating a Keystore for Release Builds

To build a signed AAB file, you need to create a keystore file first.

## Option 1: Generate Keystore (Recommended)

Run this command in the `android` directory:

```bash
keytool -genkey -v -keystore upload-keystore.jks -keyalg RSA -keysize 2048 -validity 10000 -alias pomodoro-timer-key
```

You'll be prompted for:
- **Keystore password**: Choose a strong password (remember this!)
- **Key password**: Usually same as keystore password (press Enter to use same)
- **Your name/Organization**: Enter your details
- **City, State, Country codes**: Enter your location

## Option 2: Use Existing Keystore

If you already have a keystore, copy it to the `android` directory and update `key.properties` with your details.

## After Creating Keystore

1. Copy `key.properties.example` to `key.properties`
2. Edit `key.properties` and fill in your actual passwords and alias
3. The `storeFile` should point to your keystore file name (e.g., `upload-keystore.jks`)

**Important**: 
- Never commit `key.properties` or `*.jks` files to version control
- Keep your keystore file and passwords secure
- You'll need the same keystore for future updates to your app



