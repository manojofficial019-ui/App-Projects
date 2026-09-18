# Setup Checklist

## ✅ Completed Automatically

- [x] Added `google_mobile_ads` package
- [x] Added `flutter_launcher_icons` package
- [x] Updated Android minSdk to 21 (required for AdMob)
- [x] Added INTERNET permission for AdMob
- [x] Added AdMob App ID to AndroidManifest.xml
- [x] Added AdMob App ID to iOS Info.plist
- [x] Upgraded UI with modern design and circular progress
- [x] Integrated banner and interstitial ads
- [x] Created icon directory structure

## ⚠️ Manual Steps Required

### 1. Generate App Icons
- [x] Icon file `pomodoro_app_icon.png` is in place
- [ ] Run: `flutter pub get`
- [ ] Run: `flutter pub run flutter_launcher_icons`

### 2. Configure AdMob (Before Publishing)
- [ ] Create AdMob account at https://admob.google.com
- [ ] Create your app in AdMob dashboard
- [ ] Create Banner ad unit and copy the ID
- [ ] Create Interstitial ad unit and copy the ID
- [ ] Replace test IDs in `lib/main.dart`:
  - Line ~45: Banner Ad Unit ID
  - Line ~68: Interstitial Ad Unit ID
- [ ] Replace test App ID in:
  - `android/app/src/main/AndroidManifest.xml` (line ~6)
  - `ios/Runner/Info.plist` (line ~48)

### 3. Install Dependencies
- [ ] Run: `flutter pub get`

### 4. Test
- [ ] Run the app: `flutter run`
- [ ] Verify ads are displaying (test ads will show)
- [ ] Test timer functionality
- [ ] Verify interstitial ad shows after timer completes

## Notes

- Test ad IDs are currently configured (safe for development)
- Real AdMob IDs are required before publishing to app stores
- The app icon must be added before running `flutter_launcher_icons`

