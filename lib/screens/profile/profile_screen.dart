import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../constants/app_constants.dart';
import '../../models/user_model.dart';
import '../../providers/user_provider.dart';
import '../../widgets/custom_button.dart';
import 'edit_profile_screen.dart';
import 'privacy_settings_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    
    if (!userProvider.isLoggedIn) {
      return _buildNotLoggedIn(context);
    }

    final user = userProvider.currentUser!;
    final lastDonated = user.lastDonated.toDate();
    final formatter = DateFormat('MMMM dd, yyyy');
    final lastDonatedStr = formatter.format(lastDonated);
    
    return Scaffold(
      backgroundColor: AppConstants.backgroundColor,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Profile Header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 32.0, horizontal: 24.0),
              decoration: const BoxDecoration(
                color: AppConstants.primaryColor,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(32.0),
                  bottomRight: Radius.circular(32.0),
                ),
              ),
              child: Column(
                children: [
                  // Blood type avatar
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.white,
                    child: Text(
                      user.bloodGroup,
                      style: const TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: AppConstants.primaryColor,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    user.name,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    user.email,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.white70,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      user.canDonateNow
                          ? 'Available for Donation'
                          : 'Will be available in ${3 - user.timeSinceLastDonation} months',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: user.canDonateNow
                            ? Colors.green.shade800
                            : Colors.orange.shade800,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            // Stats Cards
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Expanded(
                    child: _buildStatCard(
                      Icons.bloodtype_outlined,
                      'Total Donations',
                      user.donationCount.toString(),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildStatCard(
                      Icons.calendar_today_outlined,
                      'Last Donated',
                      lastDonatedStr,
                    ),
                  ),
                ],
              ),
            ),
            
            // Interest Level Card
            if (user.donationInterestLevel != null && user.donationInterestLevel!.isNotEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        Icon(
                          Icons.volunteer_activism,
                          color: AppConstants.primaryColor,
                          size: 24,
                        ),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Donation Interest Level',
                              style: TextStyle(
                                fontSize: 14,
                                color: AppConstants.subtitleColor,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              user.donationInterestLevel!,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: AppConstants.textColor,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            
            // Action Buttons
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  _buildActionButton(
                    context,
                    'Edit Profile',
                    Icons.edit_outlined,
                    () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const EditProfileScreen(),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 12),
                  _buildActionButton(
                    context,
                    'Privacy Settings',
                    Icons.privacy_tip_outlined,
                    () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const PrivacySettingsScreen(),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 12),
                  _buildActionButton(
                    context,
                    'Sign Out',
                    Icons.logout_outlined,
                    () => _confirmSignOut(context, userProvider),
                    color: Colors.red.shade50,
                    textColor: AppConstants.primaryColor,
                    iconColor: AppConstants.primaryColor,
                  ),
                ],
              ),
            ),
            
            // Personal Information Section
            _buildInfoSection(
              context,
              'Personal Information',
              [
                _buildInfoItem(Icons.phone_outlined, 'Phone', user.phone),
                _buildInfoItem(FontAwesomeIcons.whatsapp, 'WhatsApp', user.whatsapp),
                _buildInfoItem(Icons.work_outlined, 'Occupation', user.occupation),
                _buildInfoItem(Icons.business_outlined, 'Institution', user.institution),
                if (user.subject != null && user.subject!.isNotEmpty)
                  _buildInfoItem(Icons.book_outlined, 'Subject/Department', user.subject!),
              ],
            ),
            
            // Address Section
            _buildInfoSection(
              context,
              'Address Information',
              [
                _buildInfoItem(Icons.location_on_outlined, 'Present Address', user.presentAddress),
                _buildInfoItem(Icons.home_outlined, 'Permanent Address', user.permanentAddress),
              ],
            ),
            
            // Location Section
            _buildInfoSection(
              context,
              'Location Details',
              [
                if (user.locations.containsKey('Division') && user.locations['Division']!.isNotEmpty)
                  _buildInfoItem(Icons.location_city, 'Division', user.locations['Division']![0]),
                if (user.locations.containsKey('District') && user.locations['District']!.isNotEmpty)
                  _buildInfoItem(Icons.location_city, 'District', user.locations['District']![0]),
                if (user.locations.containsKey('Upazila') && user.locations['Upazila']!.isNotEmpty)
                  _buildInfoItem(Icons.location_city, 'Upazila', user.locations['Upazila']![0]),
                if (user.locations.containsKey('City') && user.locations['City']!.isNotEmpty)
                  _buildInfoItem(Icons.location_city, 'City', user.locations['City']![0]),
                if (user.locations.containsKey('Area') && user.locations['Area']!.isNotEmpty)
                  _buildInfoItem(Icons.location_city, 'Area', user.locations['Area']![0]),
              ],
            ),
            
            // Education Information Section
            if (user.subject != null || user.batchNumber != null || user.session != null || 
                user.hscCollege != null || user.hscYear != null || user.sscSchool != null ||
                user.lowerClassName != null || user.highestEducationLevel != null)
              _buildInfoSection(
                context,
                'Education Information',
                [
                  // Highest Education Level
                  if (user.highestEducationLevel != null && user.highestEducationLevel!.isNotEmpty)
                    _buildInfoItem(Icons.school, 'Highest Education', user.highestEducationLevel!),
                  
                  // General Education Info
                  if (user.institution != null && user.institution.isNotEmpty)
                    _buildInfoItem(Icons.account_balance, 'Institution', user.institution),
                  if (user.subject != null && user.subject!.isNotEmpty)
                    _buildInfoItem(Icons.book, 'Subject/Department', user.subject!),
                  if (user.session != null && user.session!.isNotEmpty)
                    _buildInfoItem(Icons.date_range, 'Session', user.session!),
                  
                  // Lower Class Information
                  if ((user.highestEducationLevel == 'Lower Class' || 
                       AppConstants.educationLevels.indexOf(user.highestEducationLevel ?? '') > 
                       AppConstants.educationLevels.indexOf('Lower Class')) &&
                      user.lowerClassName != null && user.lowerClassName!.isNotEmpty)
                    _buildInfoItem(Icons.school, 'Class', user.lowerClassName!),
                  if ((user.highestEducationLevel == 'Lower Class' || 
                       AppConstants.educationLevels.indexOf(user.highestEducationLevel ?? '') > 
                       AppConstants.educationLevels.indexOf('Lower Class')) &&
                      user.lowerClassSchool != null && user.lowerClassSchool!.isNotEmpty)
                    _buildInfoItem(Icons.school, 'School', user.lowerClassSchool!),
                  if ((user.highestEducationLevel == 'Lower Class' || 
                       AppConstants.educationLevels.indexOf(user.highestEducationLevel ?? '') > 
                       AppConstants.educationLevels.indexOf('Lower Class')) &&
                      user.lowerClassYear != null && user.lowerClassYear!.isNotEmpty)
                    _buildInfoItem(Icons.calendar_today, 'Year', user.lowerClassYear!),
                  
                  // SSC Information
                  if ((user.highestEducationLevel == 'SSC' || 
                       AppConstants.educationLevels.indexOf(user.highestEducationLevel ?? '') > 
                       AppConstants.educationLevels.indexOf('SSC')) &&
                      user.sscSchool != null && user.sscSchool!.isNotEmpty)
                    _buildInfoItem(Icons.school, 'SSC School', user.sscSchool!),
                  if ((user.highestEducationLevel == 'SSC' || 
                       AppConstants.educationLevels.indexOf(user.highestEducationLevel ?? '') > 
                       AppConstants.educationLevels.indexOf('SSC')) &&
                      user.sscYear != null && user.sscYear!.isNotEmpty)
                    _buildInfoItem(Icons.calendar_today, 'SSC Year', user.sscYear!),
                  
                  // HSC Information
                  if ((user.highestEducationLevel == 'HSC' || 
                       AppConstants.educationLevels.indexOf(user.highestEducationLevel ?? '') > 
                       AppConstants.educationLevels.indexOf('HSC')) &&
                      user.hscCollege != null && user.hscCollege!.isNotEmpty)
                    _buildInfoItem(Icons.school, 'HSC College', user.hscCollege!),
                  if ((user.highestEducationLevel == 'HSC' || 
                       AppConstants.educationLevels.indexOf(user.highestEducationLevel ?? '') > 
                       AppConstants.educationLevels.indexOf('HSC')) &&
                      user.hscYear != null && user.hscYear!.isNotEmpty)
                    _buildInfoItem(Icons.calendar_today, 'HSC Year', user.hscYear!),
                  
                  // Honours Information
                  if ((user.highestEducationLevel == 'Honours' || 
                       AppConstants.educationLevels.indexOf(user.highestEducationLevel ?? '') > 
                       AppConstants.educationLevels.indexOf('Honours')) &&
                      user.honorsInstitution != null && user.honorsInstitution!.isNotEmpty)
                    _buildInfoItem(Icons.school, 'Honours Institution', user.honorsInstitution!),
                  if ((user.highestEducationLevel == 'Honours' || 
                       AppConstants.educationLevels.indexOf(user.highestEducationLevel ?? '') > 
                       AppConstants.educationLevels.indexOf('Honours')) &&
                      user.honorsSubject != null && user.honorsSubject!.isNotEmpty)
                    _buildInfoItem(Icons.book, 'Honours Subject', user.honorsSubject!),
                  if ((user.highestEducationLevel == 'Honours' || 
                       AppConstants.educationLevels.indexOf(user.highestEducationLevel ?? '') > 
                       AppConstants.educationLevels.indexOf('Honours')) &&
                      user.honorsYear != null && user.honorsYear!.isNotEmpty)
                    _buildInfoItem(Icons.calendar_today, 'Honours Year', user.honorsYear!),
                  if ((user.highestEducationLevel == 'Honours' || 
                       AppConstants.educationLevels.indexOf(user.highestEducationLevel ?? '') > 
                       AppConstants.educationLevels.indexOf('Honours')) &&
                      user.honorsInstitutionBatch != null && user.honorsInstitutionBatch!.isNotEmpty)
                    _buildInfoItem(Icons.people, 'Honours Institution Batch', user.honorsInstitutionBatch!),
                  if ((user.highestEducationLevel == 'Honours' || 
                       AppConstants.educationLevels.indexOf(user.highestEducationLevel ?? '') > 
                       AppConstants.educationLevels.indexOf('Honours')) &&
                      user.honorsSubjectBatch != null && user.honorsSubjectBatch!.isNotEmpty)
                    _buildInfoItem(Icons.people, 'Honours Subject Batch', user.honorsSubjectBatch!),
                  
                  // Masters Information
                  if ((user.highestEducationLevel == 'Masters' || 
                       AppConstants.educationLevels.indexOf(user.highestEducationLevel ?? '') > 
                       AppConstants.educationLevels.indexOf('Masters')) &&
                      user.mastersInstitution != null && user.mastersInstitution!.isNotEmpty)
                    _buildInfoItem(Icons.school, 'Masters Institution', user.mastersInstitution!),
                  if ((user.highestEducationLevel == 'Masters' || 
                       AppConstants.educationLevels.indexOf(user.highestEducationLevel ?? '') > 
                       AppConstants.educationLevels.indexOf('Masters')) &&
                      user.mastersSubject != null && user.mastersSubject!.isNotEmpty)
                    _buildInfoItem(Icons.book, 'Masters Subject', user.mastersSubject!),
                  if ((user.highestEducationLevel == 'Masters' || 
                       AppConstants.educationLevels.indexOf(user.highestEducationLevel ?? '') > 
                       AppConstants.educationLevels.indexOf('Masters')) &&
                      user.mastersSession != null && user.mastersSession!.isNotEmpty)
                    _buildInfoItem(Icons.calendar_today, 'Masters Session', user.mastersSession!),
                  if ((user.highestEducationLevel == 'Masters' || 
                       AppConstants.educationLevels.indexOf(user.highestEducationLevel ?? '') > 
                       AppConstants.educationLevels.indexOf('Masters')) &&
                      user.mastersYear != null && user.mastersYear!.isNotEmpty)
                    _buildInfoItem(Icons.calendar_today, 'Masters Year', user.mastersYear!),
                  if ((user.highestEducationLevel == 'Masters' || 
                       AppConstants.educationLevels.indexOf(user.highestEducationLevel ?? '') > 
                       AppConstants.educationLevels.indexOf('Masters')) &&
                      user.mastersInstitutionBatch != null && user.mastersInstitutionBatch!.isNotEmpty)
                    _buildInfoItem(Icons.people, 'Masters Institution Batch', user.mastersInstitutionBatch!),
                  if ((user.highestEducationLevel == 'Masters' || 
                       AppConstants.educationLevels.indexOf(user.highestEducationLevel ?? '') > 
                       AppConstants.educationLevels.indexOf('Masters')) &&
                      user.mastersSubjectBatch != null && user.mastersSubjectBatch!.isNotEmpty)
                    _buildInfoItem(Icons.people, 'Masters Subject Batch', user.mastersSubjectBatch!),
                ],
              ),
            
            // Locations Section
            if (user.locations.isNotEmpty)
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Locations',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppConstants.textColor,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: _buildLocationChips(user.locations),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            
            // Privacy Settings Section
            _buildInfoSection(
              context,
              'Privacy Settings',
              [
                _buildPrivacyItem('Show Email', user.privacySettings['showEmail'] ?? false),
                _buildPrivacyItem('Show Phone', user.privacySettings['showPhone'] ?? true),
                _buildPrivacyItem('Show WhatsApp', user.privacySettings['showWhatsapp'] ?? true),
              ],
            ),
            
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(IconData icon, String title, String value) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              icon,
              color: AppConstants.primaryColor,
              size: 28,
            ),
            const SizedBox(height: 8),
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
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppConstants.textColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton(
    BuildContext context,
    String title,
    IconData icon,
    VoidCallback onTap, {
    Color? color,
    Color? textColor,
    Color? iconColor,
  }) {
    return Card(
      elevation: 0,
      color: color ?? Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
          child: Row(
            children: [
              Icon(
                icon,
                color: iconColor ?? AppConstants.primaryColor,
              ),
              const SizedBox(width: 16),
              Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: textColor ?? AppConstants.textColor,
                ),
              ),
              const Spacer(),
              const Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: AppConstants.subtitleColor,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoSection(BuildContext context, String title, List<Widget> items) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppConstants.textColor,
                ),
              ),
              const SizedBox(height: 16),
              ...items,
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoItem(IconData icon, String title, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
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
                  style: const TextStyle(
                    fontSize: 16,
                    color: AppConstants.textColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPrivacyItem(String title, bool value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        children: [
          Icon(
            value ? Icons.check_circle_outline : Icons.cancel_outlined,
            size: 20,
            color: value ? Colors.green : Colors.red,
          ),
          const SizedBox(width: 12),
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              color: AppConstants.textColor,
            ),
          ),
        ],
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

  Widget _buildNotLoggedIn(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.account_circle,
              size: 80,
              color: Colors.grey,
            ),
            const SizedBox(height: 16),
            const Text(
              'Login to View Your Profile',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppConstants.textColor,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            const Text(
              'Manage your profile, update your details, and control your privacy settings.',
              style: TextStyle(
                fontSize: 16,
                color: AppConstants.subtitleColor,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            CustomButton(
              text: 'Login',
              onPressed: () {
                Navigator.of(context).pushNamed('/login');
              },
              width: 200,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _confirmSignOut(BuildContext context, UserProvider userProvider) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Sign Out'),
          content: const Text('Are you sure you want to sign out?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Sign Out'),
              onPressed: () async {
                Navigator.of(context).pop();
                await userProvider.signOut();
              },
            ),
          ],
        );
      },
    );
  }
} 