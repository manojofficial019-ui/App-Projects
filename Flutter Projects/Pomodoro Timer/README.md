# Pomodoro Timer App

A beautiful and modern Pomodoro timer app built with Flutter, featuring AdMob integration.

## Features

- 🍅 Pomodoro Technique timer (25-minute work sessions, 5-minute breaks)
- 🎨 Modern, beautiful UI with circular progress indicator
- 📱 AdMob integration (banner and interstitial ads)
- 🎯 Clean, intuitive controls (Start, Pause, Reset)
- 🔔 System sound notifications when timer completes

## Setup Instructions

### 1. Install Dependencies

```bash
flutter pub get
```

### 2. Configure AdMob

**Important:** The app currently uses Google's test ad unit IDs. Before publishing:

1. Create an AdMob account at https://admob.google.com
2. Create an app in AdMob dashboard
3. Create ad units (Banner and Interstitial)
4. Replace the test IDs in `lib/main.dart`:
   - Banner Ad Unit ID: `ca-app-pub-3940256099942544/6300978111` (line ~45)
   - Interstitial Ad Unit ID: `ca-app-pub-3940256099942544/1033173712` (line ~68)
5. Replace the test App ID in `android/app/src/main/AndroidManifest.xml`:
   - App ID: `ca-app-pub-3940256099942544~3347511713` (line ~6)

### 3. Generate App Icons

The app icon (`pomodoro_app_icon.png`) is already configured. Generate icons for all platforms:

```bash
flutter pub get
flutter pub run flutter_launcher_icons
```

### 4. Run the App

```bash
flutter run
```

## Requirements

- Flutter SDK 3.0.0 or higher
- Android minSdk: 21 (required for AdMob)
- iOS: 11.0 or higher

## AdMob Configuration

The app includes:
- **Banner Ad**: Displayed at the bottom of the screen
- **Interstitial Ad**: Shown when a timer session completes

Make sure to:
- Replace test ad unit IDs with your real AdMob ad unit IDs before release
- Test ads thoroughly in your development environment
- Follow AdMob policies and guidelines

## Build for Release

### Android
```bash
flutter build apk --release
```

### iOS
```bash
flutter build ios --release
```

## License

This project is open source and available for use.
