import 'package:flutter/material.dart';

/// This file provides a preview of the app icon and instructions for creating it.
/// Run this as a separate app to see what the icon should look like.
void main() {
  runApp(const AppIconPreviewApp());
}

class AppIconPreviewApp extends StatelessWidget {
  const AppIconPreviewApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Donorly App Icon Preview',
      theme: ThemeData(
        primarySwatch: Colors.red,
        useMaterial3: true,
      ),
      home: const AppIconPreviewScreen(),
    );
  }
}

class AppIconPreviewScreen extends StatelessWidget {
  const AppIconPreviewScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Donorly App Icon Preview'),
        backgroundColor: const Color(0xFFE53935),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Icon Preview
            Center(
              child: Column(
                children: [
                  const Text(
                    'Icon Preview',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 24),
                  // The icon preview with drop shadow
                  Container(
                    width: 192,
                    height: 192,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(32),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(32),
                      child: Container(
                        color: const Color(0xFFE53935),
                        child: const Center(
                          child: BloodDropIcon(
                            size: 150,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  // Adaptive icon preview (Android)
                  const Text(
                    'Android Adaptive Icon',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    width: 192,
                    height: 192,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: const Color(0xFFE53935),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: const Center(
                      child: BloodDropIcon(
                        size: 120,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            // Instructions
            const Text(
              'Instructions for Creating the App Icon',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              '1. Create two PNG files:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text('   • donorly_icon.png: Blood drop icon on transparent background'),
            const Text('   • donorly_icon_foreground.png: Blood drop icon on transparent background for adaptive icons'),
            const SizedBox(height: 16),
            const Text(
              '2. Place these files in the assets/images/ directory',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            const Text(
              '3. Install flutter_launcher_icons package:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 8),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text('flutter pub add flutter_launcher_icons --dev'),
            ),
            const SizedBox(height: 16),
            const Text(
              '4. Update pubspec.yaml:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 8),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text('''
flutter_launcher_icons:
  android: "launcher_icon"
  ios: true
  image_path: "assets/images/donorly_icon.png"
  min_sdk_android: 21
  remove_alpha_ios: true
  background_color: "#E53935"
  adaptive_icon_background: "#E53935"
  adaptive_icon_foreground: "assets/images/donorly_icon_foreground.png"'''),
            ),
            const SizedBox(height: 16),
            const Text(
              '5. Generate the icons:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 8),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text('flutter pub run flutter_launcher_icons'),
            ),
            const SizedBox(height: 16),
            const Text(
              'Color Information:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 8),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('• Primary Red: #E53935'),
                  Text('• White: #FFFFFF (for the icon foreground)'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// A custom painter that draws a blood drop icon
class BloodDropIcon extends StatelessWidget {
  final double size;
  final Color color;

  const BloodDropIcon({Key? key, required this.size, required this.color}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: BloodDropPainter(color),
      ),
    );
  }
}

class BloodDropPainter extends CustomPainter {
  final Color color;

  BloodDropPainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    // Create a path for a blood drop shape
    final path = Path();
    
    // Blood drop coordinates
    final width = size.width;
    final height = size.height;
    final centerX = width / 2;
    final centerY = height / 2;
    
    // Blood drop dimensions
    final dropWidth = width * 0.6;
    final dropHeight = height * 0.7;
    
    // Top circular part of drop
    path.addOval(Rect.fromCircle(
      center: Offset(centerX, centerY - dropHeight * 0.25),
      radius: dropWidth / 2,
    ));
    
    // Bottom triangular part of drop
    path.moveTo(centerX - dropWidth / 2, centerY - dropHeight * 0.25);
    path.lineTo(centerX, centerY + dropHeight * 0.5);
    path.lineTo(centerX + dropWidth / 2, centerY - dropHeight * 0.25);
    path.close();
    
    // Draw the blood drop
    canvas.drawPath(path, paint);
    
    // Add cross symbol in the center
    final symbolPaint = Paint()
      ..color = const Color(0xFFE53935)
      ..style = PaintingStyle.fill;
      
    // Draw a cross in the center of the blood drop
    final symbolPath = Path();
    final symbolSize = width * 0.2;
    final symbolX = centerX;
    final symbolY = centerY - dropHeight * 0.1;
    
    // Cross symbol
    final crossWidth = symbolSize * 0.6;
    final crossHeight = symbolSize;
    
    // Horizontal line of cross
    symbolPath.addRRect(RRect.fromRectAndRadius(
      Rect.fromCenter(
        center: Offset(symbolX, symbolY),
        width: crossWidth,
        height: crossHeight * 0.2,
      ),
      Radius.circular(crossHeight * 0.1),
    ));
    
    // Vertical line of cross
    symbolPath.addRRect(RRect.fromRectAndRadius(
      Rect.fromCenter(
        center: Offset(symbolX, symbolY),
        width: crossHeight * 0.2,
        height: crossHeight,
      ),
      Radius.circular(crossHeight * 0.1),
    ));
    
    canvas.drawPath(symbolPath, symbolPaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
} 