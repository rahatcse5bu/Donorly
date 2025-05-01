#!/bin/bash

# Shell script to set up and generate app icons for Donorly

# Display intro message
echo "====================================================="
echo "               Donorly App Icon Generator            "
echo "====================================================="
echo ""
echo "This script will help you generate app icons for Donorly."
echo "Make sure you have already placed the following files:"
echo "  - donorly/assets/images/donorly_icon.png"
echo "  - donorly/assets/images/donorly_icon_foreground.png"
echo ""

# Check if the required files exist
if [ ! -f "assets/images/donorly_icon.png" ]; then
  echo "Error: assets/images/donorly_icon.png not found!"
  echo "Please create this file first and run the script again."
  exit 1
fi

if [ ! -f "assets/images/donorly_icon_foreground.png" ]; then
  echo "Error: assets/images/donorly_icon_foreground.png not found!"
  echo "Please create this file first and run the script again."
  exit 1
fi

# Install dependencies
echo "Installing the flutter_launcher_icons package..."
flutter pub add flutter_launcher_icons --dev

# Update the pubspec.yaml file if needed
echo "Checking pubspec.yaml configuration..."
if ! grep -q "flutter_launcher_icons:" pubspec.yaml; then
  echo "Adding launcher icons configuration to pubspec.yaml..."
  cat << 'EOF' >> pubspec.yaml

# Flutter Launcher Icons configuration
flutter_launcher_icons:
  android: "launcher_icon"
  ios: true
  image_path: "assets/images/donorly_icon.png"
  min_sdk_android: 21
  remove_alpha_ios: true
  background_color: "#E53935"
  adaptive_icon_background: "#E53935"
  adaptive_icon_foreground: "assets/images/donorly_icon_foreground.png"
EOF
fi

# Generate the icons
echo "Generating the app icons..."
flutter pub run flutter_launcher_icons

# Check if generation was successful
if [ $? -eq 0 ]; then
  echo ""
  echo "✅ App icons have been generated successfully!"
  echo ""
  echo "You can find the generated icons at:"
  echo "  - Android: android/app/src/main/res/mipmap-* directories"
  echo "  - iOS: ios/Runner/Assets.xcassets/AppIcon.appiconset directory"
else
  echo ""
  echo "❌ Error occurred while generating app icons."
  echo "Please check the error messages above and fix any issues."
fi 