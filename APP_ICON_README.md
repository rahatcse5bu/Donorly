# Donorly App Icon Implementation Guide

This guide explains how to create and implement the app icon for the Donorly blood donation app.

## Icon Design

The Donorly app icon features a simple blood drop with a medical cross symbol, representing the app's focus on blood donation. The design uses:

- **Primary Color**: Red (`#E53935`)
- **Secondary Color**: White (`#FFFFFF`)
- **Style**: Flat, minimalist design with clean edges

## Preview

To see what the app icon should look like, run the preview app:

```bash
cd donorly
flutter run -t lib/tools/app_icon_preview.dart
```

This will display both the standard app icon and the Android adaptive icon variant.

## Implementation Steps

Follow these steps to implement the app icon:

### 1. Create Icon Images

Create two PNG files for the app icon:

- `donorly_icon.png`: Blood drop icon on transparent background (1024×1024px)
- `donorly_icon_foreground.png`: Blood drop icon on transparent background for adaptive icons (1024×1024px)

You can use graphic design software (Adobe Illustrator, Figma, Photoshop, etc.) to create these icons based on the preview displayed in the app.

### 2. Place Icons in Assets

Save the icon PNG files in the assets/images directory:

```
donorly/assets/images/donorly_icon.png
donorly/assets/images/donorly_icon_foreground.png
```

### 3. Install the Flutter Launcher Icons Package

Add the flutter_launcher_icons package to your dev dependencies:

```bash
flutter pub add flutter_launcher_icons --dev
```

### 4. Configure Icon Settings

The pubspec.yaml file should already contain the configuration for the app icon:

```yaml
flutter_launcher_icons:
  android: "launcher_icon"
  ios: true
  image_path: "assets/images/donorly_icon.png"
  min_sdk_android: 21
  remove_alpha_ios: true
  background_color: "#E53935"
  adaptive_icon_background: "#E53935"
  adaptive_icon_foreground: "assets/images/donorly_icon_foreground.png"
```

### 5. Generate the Icons

Run the following command to generate the app icons for both Android and iOS:

```bash
flutter pub run flutter_launcher_icons
```

This will create icon files in all required formats and sizes for both platforms:
- Android: Icon files in mipmap directories
- iOS: Icon files in Assets.xcassets

### 6. Verification

After generating the icons, verify that they appear correctly:

- **Android**: Check the `android/app/src/main/res/mipmap-*` directories
- **iOS**: Check the `ios/Runner/Assets.xcassets/AppIcon.appiconset` directory

## Troubleshooting

If you encounter issues:

1. Ensure source images are PNG format with dimensions of 1024×1024 pixels
2. For best results on iOS, the icon should not have transparency
3. Make sure the `flutter_launcher_icons` package is correctly added to `dev_dependencies`
4. Check that file paths in the pubspec.yaml configuration are correct 