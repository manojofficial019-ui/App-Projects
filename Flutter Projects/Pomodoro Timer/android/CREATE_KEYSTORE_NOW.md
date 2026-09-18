# Create Keystore Now

Run this command in the `android` directory to create your keystore:

```bash
keytool -genkey -v -keystore upload-keystore.jks -keyalg RSA -keysize 2048 -validity 10000 -alias pomodoro-timer-key -storepass YOUR_PASSWORD -keypass YOUR_PASSWORD -dname "CN=Pomodoro Timer, OU=Development, O=Your Company, L=City, ST=State, C=US"
```

**Replace `YOUR_PASSWORD` with a strong password of your choice (minimum 6 characters).**

After creating the keystore, create `key.properties` file:

```properties
storePassword=YOUR_PASSWORD
keyPassword=YOUR_PASSWORD
keyAlias=pomodoro-timer-key
storeFile=upload-keystore.jks
```

Then build with: `flutter build appbundle --release`



