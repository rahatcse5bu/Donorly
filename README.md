# Donorly

A blood donation management system mobile app that helps connect donors with those in need.

## Features

- User registration and profile management
- Search for blood donors by various criteria
- Manage donation history
- Privacy controls for user information

## Getting Started

### Prerequisites

- Flutter (latest stable version)
- Dart SDK
- Android Studio or VS Code with Flutter extensions
- Firebase account for backend services

### Installation

1. Clone the repository
2. Run `flutter pub get` to install dependencies
3. Connect a Firebase project and configure it
4. Run the app using `flutter run`

## App Icon

The Donorly app features a custom blood drop icon. To implement or update the app icon:

1. Check out the `APP_ICON_README.md` file for detailed instructions
2. Use the provided scripts to generate icons:
   - On Windows: Run `.\generate_app_icon.ps1` in PowerShell
   - On Mac/Linux: Run `./generate_app_icon.sh` in Terminal

You can also preview what the app icon will look like by running:
```bash
flutter run -t lib/tools/app_icon_preview.dart
```

## Development Resources

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)
- [Flutter Documentation](https://docs.flutter.dev/)

## License

This project is licensed under the MIT License - see the LICENSE file for details.
