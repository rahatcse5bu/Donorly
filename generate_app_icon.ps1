# PowerShell script to set up and generate app icons for Donorly

# Display intro message
Write-Host "=====================================================" -ForegroundColor Cyan
Write-Host "               Donorly App Icon Generator            " -ForegroundColor Cyan
Write-Host "=====================================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "This script will help you generate app icons for Donorly."
Write-Host "Make sure you have already placed the following files:"
Write-Host "  - donorly/assets/images/donorly_icon.png"
Write-Host "  - donorly/assets/images/donorly_icon_foreground.png"
Write-Host ""

# Check if the required files exist
if (-not (Test-Path "assets/images/donorly_icon.png")) {
    Write-Host "Error: assets/images/donorly_icon.png not found!" -ForegroundColor Red
    Write-Host "Please create this file first and run the script again."
    exit 1
}

if (-not (Test-Path "assets/images/donorly_icon_foreground.png")) {
    Write-Host "Error: assets/images/donorly_icon_foreground.png not found!" -ForegroundColor Red
    Write-Host "Please create this file first and run the script again."
    exit 1
}

# Install dependencies
Write-Host "Installing the flutter_launcher_icons package..." -ForegroundColor Yellow
flutter pub add flutter_launcher_icons --dev

# Update the pubspec.yaml file if needed
Write-Host "Checking pubspec.yaml configuration..." -ForegroundColor Yellow
$pubspecContent = Get-Content "pubspec.yaml" -Raw
if (-not ($pubspecContent -match "flutter_launcher_icons:")) {
    Write-Host "Adding launcher icons configuration to pubspec.yaml..." -ForegroundColor Yellow
    Add-Content -Path "pubspec.yaml" -Value @"

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
"@
}

# Generate the icons
Write-Host "Generating the app icons..." -ForegroundColor Yellow
flutter pub run flutter_launcher_icons

# Check if generation was successful
if ($LASTEXITCODE -eq 0) {
    Write-Host ""
    Write-Host "✅ App icons have been generated successfully!" -ForegroundColor Green
    Write-Host ""
    Write-Host "You can find the generated icons at:"
    Write-Host "  - Android: android/app/src/main/res/mipmap-* directories"
    Write-Host "  - iOS: ios/Runner/Assets.xcassets/AppIcon.appiconset directory"
} else {
    Write-Host ""
    Write-Host "❌ Error occurred while generating app icons." -ForegroundColor Red
    Write-Host "Please check the error messages above and fix any issues."
} 