import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../constants/app_constants.dart';
import '../../models/user_model.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class DonorDetailsScreen extends StatelessWidget {
  final UserModel donor;
  
  const DonorDetailsScreen({
    Key? key,
    required this.donor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final lastDonated = donor.lastDonated.toDate();
    final formatter = DateFormat('MMMM dd, yyyy');
    final lastDonatedStr = formatter.format(lastDonated);
    
    return Scaffold(
      backgroundColor: AppConstants.backgroundColor,
      appBar: AppBar(
        title: const Text('Donor Details'),
        backgroundColor: AppConstants.primaryColor,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with basic info
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  backgroundColor: AppConstants.primaryColor,
                  radius: 40,
                  child: Text(
                    donor.bloodGroup,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        donor.name,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: AppConstants.textColor,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        donor.institution,
                        style: const TextStyle(
                          fontSize: 16,
                          color: AppConstants.subtitleColor,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: donor.canDonateNow
                                  ? Colors.green.shade100
                                  : Colors.orange.shade100,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Text(
                              donor.canDonateNow
                                  ? 'Available for Donation'
                                  : 'Not Available for Donation',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: donor.canDonateNow
                                    ? Colors.green.shade800
                                    : Colors.orange.shade800,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 24),
            
            // Donation Statistics
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Donation Statistics',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppConstants.textColor,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: _buildStatItem(
                            Icons.bloodtype_outlined,
                            'Total Donations',
                            donor.donationCount.toString(),
                          ),
                        ),
                        Expanded(
                          child: _buildStatItem(
                            Icons.calendar_today_outlined,
                            'Last Donated',
                            lastDonatedStr,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: _buildStatItem(
                            Icons.access_time,
                            'Time Since Last',
                            '${donor.timeSinceLastDonation} months',
                          ),
                        ),
                        Expanded(
                          child: _buildStatItem(
                            Icons.medical_services_outlined,
                            'Can Donate',
                            donor.canDonateNow ? 'Yes' : 'No',
                            valueColor: donor.canDonateNow
                                ? Colors.green
                                : Colors.red,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Contact Information
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Contact Information',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppConstants.textColor,
                      ),
                    ),
                    const SizedBox(height: 16),
                    if (donor.privacySettings['showPhone'] == true) ...[
                      _buildContactItem(
                        Icons.phone_outlined,
                        'Phone',
                        donor.phone,
                        onTap: () => _makePhoneCall(donor.phone),
                      ),
                      const SizedBox(height: 12),
                    ],
                    if (donor.privacySettings['showWhatsapp'] == true) ...[
                      _buildContactItem(
                        FontAwesomeIcons.whatsapp,
                        'WhatsApp',
                        donor.whatsapp,
                        onTap: () => _openWhatsApp(donor.whatsapp),
                      ),
                      const SizedBox(height: 12),
                    ],
                    if (donor.privacySettings['showEmail'] == true) ...[
                      _buildContactItem(
                        Icons.email_outlined,
                        'Email',
                        donor.email,
                        onTap: () => _sendEmail(donor.email),
                      ),
                    ] else ...[
                      const Text(
                        'Contact information is limited as per donor\'s privacy settings.',
                        style: TextStyle(
                          fontSize: 14,
                          fontStyle: FontStyle.italic,
                          color: AppConstants.subtitleColor,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Location Information
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Location & Address',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppConstants.textColor,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildInfoItem(
                      Icons.location_on_outlined,
                      'Present Address',
                      donor.presentAddress,
                    ),
                    const SizedBox(height: 12),
                    _buildInfoItem(
                      Icons.home_outlined,
                      'Permanent Address',
                      donor.permanentAddress,
                    ),
                    if (donor.locations.isNotEmpty) ...[
                      const SizedBox(height: 16),
                      const Text(
                        'Areas Covered',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: AppConstants.textColor,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: _buildLocationChips(donor.locations),
                      ),
                    ],
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Professional Information
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Professional Information',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppConstants.textColor,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildInfoItem(
                      Icons.work_outline,
                      'Occupation',
                      donor.occupation,
                    ),
                    const SizedBox(height: 12),
                    _buildInfoItem(
                      Icons.business_outlined,
                      'Institution',
                      donor.institution,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(IconData icon, String title, String value, {Color? valueColor}) {
    return Row(
      children: [
        Icon(
          icon,
          size: 24,
          color: AppConstants.primaryColor,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  color: AppConstants.subtitleColor,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: valueColor ?? AppConstants.textColor,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildInfoItem(IconData icon, String title, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          size: 20,
          color: AppConstants.primaryColor,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  color: AppConstants.subtitleColor,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 16,
                  color: AppConstants.textColor,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildContactItem(IconData icon, String title, String value, {VoidCallback? onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              icon,
              size: 20,
              color: AppConstants.primaryColor,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppConstants.subtitleColor,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    value,
                    style: TextStyle(
                      fontSize: 16,
                      color: onTap != null ? AppConstants.primaryColor : AppConstants.textColor,
                      decoration: onTap != null ? TextDecoration.underline : null,
                    ),
                  ),
                ],
              ),
            ),
            if (onTap != null)
              const Icon(
                Icons.open_in_new,
                size: 16,
                color: AppConstants.primaryColor,
              ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildLocationChips(Map<String, List<String>> locations) {
    List<Widget> chips = [];
    
    for (var entry in locations.entries) {
      for (var location in entry.value) {
        if (location.isNotEmpty) {
          chips.add(
            Chip(
              label: Text(
                '$location (${entry.key})',
                style: const TextStyle(fontSize: 12),
              ),
              backgroundColor: Colors.grey.shade100,
            ),
          );
        }
      }
    }
    
    return chips;
  }

  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri uri = Uri(scheme: 'tel', path: phoneNumber);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  Future<void> _sendEmail(String email) async {
    final Uri uri = Uri(scheme: 'mailto', path: email);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  Future<void> _openWhatsApp(String phoneNumber) async {
    // Remove any non-numeric characters
    final cleanedNumber = phoneNumber.replaceAll(RegExp(r'\D'), '');
    final Uri uri = Uri.parse('https://wa.me/$cleanedNumber');
    
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }
} 