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
                    
                    // Donation Interest Level
                    if (donor.donationInterestLevel != null && donor.donationInterestLevel!.isNotEmpty) ...[
                      const SizedBox(height: 12),
                      _buildStatItem(
                        Icons.volunteer_activism,
                        'Interest Level',
                        donor.donationInterestLevel!,
                        valueColor: donor.donationInterestLevel == 'High' || donor.donationInterestLevel == 'Extremely High'
                            ? Colors.green
                            : AppConstants.textColor,
                      ),
                    ],
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
            
            const SizedBox(height: 16),
            
            // Education Information
            if (donor.subject != null || donor.batchNumber != null || donor.session != null || 
                donor.hscCollege != null || donor.hscYear != null || donor.sscSchool != null ||
                donor.lowerClassName != null || donor.highestEducationLevel != null)
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
                      'Education Information',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppConstants.textColor,
                      ),
                    ),
                    const SizedBox(height: 16),
                    
                    // Highest Education Level
                    if (donor.highestEducationLevel != null && donor.highestEducationLevel!.isNotEmpty)
                      _buildInfoItem(Icons.school, 'Highest Education', donor.highestEducationLevel!),
                    
                    // General Education Info
                    if (donor.subject != null && donor.subject!.isNotEmpty) ...[
                      const SizedBox(height: 12),
                      _buildInfoItem(Icons.book, 'Subject/Department', donor.subject!),
                    ],
                    if (donor.session != null && donor.session!.isNotEmpty) ...[
                      const SizedBox(height: 12),
                      _buildInfoItem(Icons.date_range, 'Session', donor.session!),
                    ],
                    
                    // Lower Class Information
                    if ((donor.highestEducationLevel == 'Lower Class' || 
                        AppConstants.educationLevels.indexOf(donor.highestEducationLevel ?? '') > 
                        AppConstants.educationLevels.indexOf('Lower Class'))) ...[
                      if (donor.lowerClassName != null && donor.lowerClassName!.isNotEmpty) ...[
                        const SizedBox(height: 12),
                        _buildInfoItem(Icons.school, 'Class', donor.lowerClassName!),
                      ],
                      if (donor.lowerClassSchool != null && donor.lowerClassSchool!.isNotEmpty) ...[
                        const SizedBox(height: 12),
                        _buildInfoItem(Icons.school, 'School', donor.lowerClassSchool!),
                      ],
                      if (donor.lowerClassYear != null && donor.lowerClassYear!.isNotEmpty) ...[
                        const SizedBox(height: 12),
                        _buildInfoItem(Icons.calendar_today, 'Year', donor.lowerClassYear!),
                      ],
                    ],
                    
                    // SSC Information
                    if ((donor.highestEducationLevel == 'SSC' || 
                        AppConstants.educationLevels.indexOf(donor.highestEducationLevel ?? '') > 
                        AppConstants.educationLevels.indexOf('SSC'))) ...[
                      if (donor.sscSchool != null && donor.sscSchool!.isNotEmpty) ...[
                        const SizedBox(height: 12),
                        _buildInfoItem(Icons.school, 'SSC School', donor.sscSchool!),
                      ],
                      if (donor.sscYear != null && donor.sscYear!.isNotEmpty) ...[
                        const SizedBox(height: 12),
                        _buildInfoItem(Icons.calendar_today, 'SSC Year', donor.sscYear!),
                      ],
                      if (donor.sscSession != null && donor.sscSession!.isNotEmpty) ...[
                        const SizedBox(height: 12),
                        _buildInfoItem(Icons.calendar_today, 'SSC Session', donor.sscSession!),
                      ],
                    ],
                    
                    // HSC Information
                    if ((donor.highestEducationLevel == 'HSC' || 
                        AppConstants.educationLevels.indexOf(donor.highestEducationLevel ?? '') > 
                        AppConstants.educationLevels.indexOf('HSC'))) ...[
                      if (donor.hscCollege != null && donor.hscCollege!.isNotEmpty) ...[
                        const SizedBox(height: 12),
                        _buildInfoItem(Icons.school, 'HSC College', donor.hscCollege!),
                      ],
                      if (donor.hscYear != null && donor.hscYear!.isNotEmpty) ...[
                        const SizedBox(height: 12),
                        _buildInfoItem(Icons.calendar_today, 'HSC Year', donor.hscYear!),
                      ],
                      if (donor.hscSession != null && donor.hscSession!.isNotEmpty) ...[
                        const SizedBox(height: 12),
                        _buildInfoItem(Icons.calendar_today, 'HSC Session', donor.hscSession!),
                      ],
                    ],
                    
                    // Honours Information
                    if ((donor.highestEducationLevel == 'Honours' || 
                        AppConstants.educationLevels.indexOf(donor.highestEducationLevel ?? '') > 
                        AppConstants.educationLevels.indexOf('Honours'))) ...[
                      if (donor.honorsInstitution != null && donor.honorsInstitution!.isNotEmpty) ...[
                        const SizedBox(height: 12),
                        _buildInfoItem(Icons.school, 'Honours Institution', donor.honorsInstitution!),
                      ],
                      if (donor.honorsSubject != null && donor.honorsSubject!.isNotEmpty) ...[
                        const SizedBox(height: 12),
                        _buildInfoItem(Icons.book, 'Honours Subject', donor.honorsSubject!),
                      ],
                      if (donor.honorsSession != null && donor.honorsSession!.isNotEmpty) ...[
                        const SizedBox(height: 12),
                        _buildInfoItem(Icons.calendar_today, 'Honours Session', donor.honorsSession!),
                      ],
                      if (donor.honorsYear != null && donor.honorsYear!.isNotEmpty) ...[
                        const SizedBox(height: 12),
                        _buildInfoItem(Icons.calendar_today, 'Honours Year', donor.honorsYear!),
                      ],
                      if (donor.honorsInstitutionBatch != null && donor.honorsInstitutionBatch!.isNotEmpty) ...[
                        const SizedBox(height: 12),
                        _buildInfoItem(Icons.people, 'Honours Institution Batch', donor.honorsInstitutionBatch!),
                      ],
                      if (donor.honorsSubjectBatch != null && donor.honorsSubjectBatch!.isNotEmpty) ...[
                        const SizedBox(height: 12),
                        _buildInfoItem(Icons.people, 'Honours Subject Batch', donor.honorsSubjectBatch!),
                      ],
                    ],
                    
                    // Masters Information
                    if ((donor.highestEducationLevel == 'Masters' || 
                        AppConstants.educationLevels.indexOf(donor.highestEducationLevel ?? '') > 
                        AppConstants.educationLevels.indexOf('Masters'))) ...[
                      if (donor.mastersInstitution != null && donor.mastersInstitution!.isNotEmpty) ...[
                        const SizedBox(height: 12),
                        _buildInfoItem(Icons.school, 'Masters Institution', donor.mastersInstitution!),
                      ],
                      if (donor.mastersSubject != null && donor.mastersSubject!.isNotEmpty) ...[
                        const SizedBox(height: 12),
                        _buildInfoItem(Icons.book, 'Masters Subject', donor.mastersSubject!),
                      ],
                      if (donor.mastersSession != null && donor.mastersSession!.isNotEmpty) ...[
                        const SizedBox(height: 12),
                        _buildInfoItem(Icons.calendar_today, 'Masters Session', donor.mastersSession!),
                      ],
                      if (donor.mastersYear != null && donor.mastersYear!.isNotEmpty) ...[
                        const SizedBox(height: 12),
                        _buildInfoItem(Icons.calendar_today, 'Masters Year', donor.mastersYear!),
                      ],
                      if (donor.mastersInstitutionBatch != null && donor.mastersInstitutionBatch!.isNotEmpty) ...[
                        const SizedBox(height: 12),
                        _buildInfoItem(Icons.people, 'Masters Institution Batch', donor.mastersInstitutionBatch!),
                      ],
                      if (donor.mastersSubjectBatch != null && donor.mastersSubjectBatch!.isNotEmpty) ...[
                        const SizedBox(height: 12),
                        _buildInfoItem(Icons.people, 'Masters Subject Batch', donor.mastersSubjectBatch!),
                      ],
                    ],
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