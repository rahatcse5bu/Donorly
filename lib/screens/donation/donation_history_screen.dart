import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../constants/app_constants.dart';
import '../../models/donation_model.dart';
import '../../providers/donation_provider.dart';
import '../../providers/user_provider.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/donation_card.dart';
import 'add_donation_screen.dart';

class DonationHistoryScreen extends StatefulWidget {
  const DonationHistoryScreen({Key? key}) : super(key: key);

  @override
  State<DonationHistoryScreen> createState() => _DonationHistoryScreenState();
}

class _DonationHistoryScreenState extends State<DonationHistoryScreen> {
  @override
  void initState() {
    super.initState();
    
    // Set up the donations stream for the current user
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      final donationProvider = Provider.of<DonationProvider>(context, listen: false);
      
      if (userProvider.isLoggedIn) {
        donationProvider.setupDonationsStream(userProvider.currentUser!.uid);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final donationProvider = Provider.of<DonationProvider>(context);
    
    if (!userProvider.isLoggedIn) {
      return _buildNotLoggedIn();
    }

    return Scaffold(
      body: Column(
        children: [
          // Header with stats
          Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: AppConstants.primaryColor,
                      radius: 25,
                      child: Text(
                        userProvider.currentUser!.bloodGroup,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            userProvider.currentUser!.name,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: AppConstants.textColor,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              _buildStatItem(
                                'Total Donations',
                                userProvider.currentUser!.donationCount.toString(),
                              ),
                              const SizedBox(width: 16),
                              _buildStatItem(
                                'Months Since Last',
                                userProvider.currentUser!.timeSinceLastDonation.toString(),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: userProvider.currentUser!.canDonateNow
                        ? Colors.green.shade100
                        : Colors.orange.shade100,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    userProvider.currentUser!.canDonateNow
                        ? 'You are eligible for donation'
                        : 'You will be eligible after ${3 - userProvider.currentUser!.timeSinceLastDonation} more months',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: userProvider.currentUser!.canDonateNow
                          ? Colors.green.shade800
                          : Colors.orange.shade800,
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          // Donation List Section
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Your Donation History',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppConstants.textColor,
                  ),
                ),
                CustomButton(
                  text: 'Add New',
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => const AddDonationScreen(),
                      ),
                    );
                  },
                  height: 36,
                  width: 100,
                  borderRadius: 18,
                ),
              ],
            ),
          ),
          
          // Donations List
          Expanded(
            child: StreamBuilder<List<DonationModel>>(
              stream: donationProvider.donationsStream,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(
                    child: Text(
                      'Error: ${snapshot.error}',
                      style: const TextStyle(color: Colors.red),
                    ),
                  );
                }

                final donations = snapshot.data;
                
                if (donations == null || donations.isEmpty) {
                  return const Center(
                    child: Text(
                      'No donations yet. Add your first donation to keep track of your history!',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: AppConstants.subtitleColor),
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  itemCount: donations.length,
                  itemBuilder: (context, index) {
                    final donation = donations[index];
                    return DonationCard(
                      donation: donation,
                      onEdit: () => _showEditDialog(donation),
                      onDelete: () => _showDeleteDialog(donation),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String title, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 12,
            color: AppConstants.subtitleColor,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: AppConstants.textColor,
          ),
        ),
      ],
    );
  }

  Widget _buildNotLoggedIn() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.history,
              size: 80,
              color: Colors.grey,
            ),
            const SizedBox(height: 16),
            const Text(
              'Login to View Your Donation History',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppConstants.textColor,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            const Text(
              'Track your donations, see your statistics, and manage your donor profile.',
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
                // Navigate to login screen
                Navigator.of(context).pushNamed('/login');
              },
              width: 200,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showEditDialog(DonationModel donation) async {
    // Navigate to edit donation screen
    // TODO: Implement edit donation screen
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Edit functionality will be implemented soon'),
      ),
    );
  }

  Future<void> _showDeleteDialog(DonationModel donation) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final donationProvider = Provider.of<DonationProvider>(context, listen: false);

    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Donation'),
          content: const Text('Are you sure you want to delete this donation record? This action cannot be undone.'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Delete', style: TextStyle(color: Colors.red)),
              onPressed: () async {
                Navigator.of(context).pop();
                
                final success = await donationProvider.deleteDonation(
                  donation.id,
                  userProvider.currentUser!.uid,
                );
                
                if (success && mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Donation deleted successfully'),
                    ),
                  );
                } else if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Failed to delete donation: ${donationProvider.error}'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }
} 