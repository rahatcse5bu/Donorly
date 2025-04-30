import 'package:flutter/material.dart';

class AppConstants {
  // Blood Groups
  static const List<String> bloodGroups = [
    'A+',
    'A-',
    'B+',
    'B-',
    'AB+',
    'AB-',
    'O+',
    'O-',
  ];

  // App Theme Colors
  static const Color primaryColor = Color(0xFFE53935); // Red
  static const Color accentColor = Color(0xFFEF5350); // Light Red
  static const Color backgroundColor = Color(0xFFF5F5F5);
  static const Color textColor = Color(0xFF212121);
  static const Color subtitleColor = Color(0xFF757575);

  // Search Categories
  static const List<String> searchCategories = [
    'Division',
    'District',
    'City',
    'Area',
    'Medical College',
    'Diagnostic Center',
    'Educational Institution',
  ];

  // Privacy Settings Options
  static const Map<String, String> privacyOptions = {
    'showEmail': 'Show Email to Others',
    'showPhone': 'Show Phone Number to Others',
    'showWhatsapp': 'Show WhatsApp Number to Others',
  };

  // Donation Eligibility Time Period (in months)
  static const int donationEligibilityPeriod = 3;

  // Default Error Message
  static const String defaultErrorMessage = 'Something went wrong. Please try again.';

  // Auth Error Messages
  static const Map<String, String> authErrorMessages = {
    'invalid-email': 'The email address is badly formatted.',
    'user-disabled': 'This user has been disabled.',
    'user-not-found': 'No user found with this email.',
    'wrong-password': 'The password is invalid.',
    'email-already-in-use': 'The email address is already in use by another account.',
    'operation-not-allowed': 'Email/password accounts are not enabled.',
    'weak-password': 'The password is too weak.',
  };
} 