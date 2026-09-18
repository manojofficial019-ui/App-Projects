# Icon Cropping Instructions

The `flutter_launcher_icons` package will automatically crop and resize your icon, but for best results, your source icon should be square.

## Option 1: Use flutter_launcher_icons (Automatic)
The package will automatically handle cropping and resizing:
```bash
flutter pub get
flutter pub run flutter_launcher_icons
```

## Option 2: Manual Cropping (Before running above)
If you want to manually crop the icon first to ensure it's perfectly square:

### Online Tools:
- https://www.iloveimg.com/crop-image
- https://www.resizepixel.com/crop
- https://crop-image.com

### Steps:
1. Upload `assets/icon/pomodoro_app_icon.png`
2. Set aspect ratio to 1:1 (Square)
3. Crop to center (or adjust as needed)
4. Download the cropped image
5. Replace `pomodoro_app_icon.png` with the cropped version
6. Run: `flutter pub run flutter_launcher_icons`

### Recommended Size:
- 1024x1024 pixels (minimum)
- Square (1:1 aspect ratio)
- PNG format
- Keep important elements in the center (edges may be cropped on some devices)

The flutter_launcher_icons tool will create all required sizes automatically, so you only need to provide one high-quality square source image.



