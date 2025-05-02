import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactUtils {
  // Launch phone call
  static Future<void> makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    await _launchUrl(launchUri);
  }

  // Launch WhatsApp
  static Future<void> openWhatsApp(String phoneNumber, {String message = ''}) async {
    // Format phone number (remove any non-digit characters)
    String formattedNumber = phoneNumber.replaceAll(RegExp(r'\D'), '');
    
    // Add country code if not present (assuming Bangladesh +880)
    if (!formattedNumber.startsWith('880')) {
      // If number starts with 0, replace it with 880
      if (formattedNumber.startsWith('0')) {
        formattedNumber = '88' + formattedNumber;
      } else {
        formattedNumber = '880' + formattedNumber;
      }
    }

    final Uri whatsappUri = Uri.parse(
      'https://wa.me/$formattedNumber?text=${Uri.encodeComponent(message)}',
    );
    await _launchUrl(whatsappUri);
  }

  // Launch email client
  static Future<void> sendEmail(String email, {String subject = '', String body = ''}) async {
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: email,
      query: _encodeQueryParameters({
        'subject': subject,
        'body': body,
      }),
    );
    await _launchUrl(emailUri);
  }

  // Helper function to encode query parameters
  static String? _encodeQueryParameters(Map<String, String> params) {
    return params.entries
        .map((e) => '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
        .join('&');
  }

  // Helper function to launch URLs
  static Future<void> _launchUrl(Uri uri) async {
    if (!await launchUrl(uri)) {
      throw Exception('Could not launch $uri');
    }
  }

  // Show contact action options in a modal sheet
  static void showContactOptions(
    BuildContext context, {
    required String contactName,
    String? phoneNumber,
    String? email,
    String? whatsappNumber,
  }) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Contact $contactName',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            if (phoneNumber != null && phoneNumber.isNotEmpty)
              ListTile(
                leading: const Icon(Icons.phone, color: Colors.green),
                title: const Text('Call'),
                subtitle: Text(phoneNumber),
                onTap: () {
                  Navigator.pop(context);
                  makePhoneCall(phoneNumber);
                },
              ),
            if (whatsappNumber != null && whatsappNumber.isNotEmpty)
              ListTile(
                leading: const Icon(Icons.whatsapp, color: Color(0xFF25D366)),
                title: const Text('WhatsApp'),
                subtitle: Text(whatsappNumber),
                onTap: () {
                  Navigator.pop(context);
                  openWhatsApp(whatsappNumber);
                },
              ),
            if (email != null && email.isNotEmpty)
              ListTile(
                leading: const Icon(Icons.email, color: Colors.red),
                title: const Text('Email'),
                subtitle: Text(email),
                onTap: () {
                  Navigator.pop(context);
                  sendEmail(email);
                },
              ),
          ],
        ),
      ),
    );
  }
} 