import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';

/// This is a utility script to generate the app icon.
/// Run this script once to generate the icon PNG files.
void main() async {
  // Initialize Flutter binding
  WidgetsFlutterBinding.ensureInitialized();
  
  // Set canvas size
  const size = 1024.0;
  
  // Create a recorder for the canvas
  final recorder = ui.PictureRecorder();
  final canvas = Canvas(recorder);
  
  // Create the blood drop icon
  paintBloodDrop(canvas, Size(size, size), Colors.white);
  
  // Create the image from the canvas
  final picture = recorder.endRecording();
  final img = await picture.toImage(size.toInt(), size.toInt());
  final byteData = await img.toByteData(format: ui.ImageByteFormat.png);
  final buffer = byteData!.buffer.asUint8List();
  
  // Save the image to the assets folder
  final iconFile = File('assets/images/donorly_icon.png');
  await iconFile.parent.create(recursive: true);
  await iconFile.writeAsBytes(buffer);
  
  // Create foreground version (transparent background for adaptive icon)
  final recorderForeground = ui.PictureRecorder();
  final canvasForeground = Canvas(recorderForeground);
  
  // Create the blood drop icon foreground
  paintBloodDrop(canvasForeground, Size(size, size), Colors.white);
  
  // Create the image from the canvas
  final pictureForeground = recorderForeground.endRecording();
  final imgForeground = await pictureForeground.toImage(size.toInt(), size.toInt());
  final byteDataForeground = await imgForeground.toByteData(format: ui.ImageByteFormat.png);
  final bufferForeground = byteDataForeground!.buffer.asUint8List();
  
  // Save the foreground image to the assets folder
  final foregroundFile = File('assets/images/donorly_icon_foreground.png');
  await foregroundFile.writeAsBytes(bufferForeground);
  
  print('Icons generated successfully!');
  exit(0);
}

/// Paint a blood drop icon on the canvas.
void paintBloodDrop(Canvas canvas, Size size, Color color) {
  final paint = Paint()
    ..color = Colors.red
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
  final cornerRadius = width * 0.2;
  
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
  
  // Add a heart or cross symbol in the center
  final symbolPaint = Paint()
    ..color = Colors.white
    ..style = PaintingStyle.fill;
    
  // Draw a white heart in the center of the blood drop
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