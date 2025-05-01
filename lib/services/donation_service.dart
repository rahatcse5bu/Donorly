import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/donation_model.dart';
import '../models/user_model.dart';

class DonationService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final CollectionReference _donationsCollection = FirebaseFirestore.instance.collection('donations');
  final CollectionReference _usersCollection = FirebaseFirestore.instance.collection('users');

  // Add a new donation record
  Future<DonationModel> addDonation({
    required String donorId,
    required String location,
    required String address,
    required String receiverName,
    required String receiverContact,
    required String bloodGroup,
    required String purpose,
    required DateTime donationDate,
    required Map<String, String> locationDetails,
  }) async {
    try {
      // Create a document reference with auto-generated ID
      final docRef = _donationsCollection.doc();
      
      // Create the donation model
      final donation = DonationModel(
        id: docRef.id,
        donorId: donorId,
        location: location,
        address: address,
        receiverName: receiverName,
        receiverContact: receiverContact,
        bloodGroup: bloodGroup,
        purpose: purpose,
        donationDate: Timestamp.fromDate(donationDate),
        locationDetails: locationDetails,
      );
      
      // Add the donation to Firestore
      await docRef.set(donation.toMap());
      
      // Update the user's donation count and last donation date
      await _updateUserDonationInfo(donorId, donationDate);
      
      return donation;
    } catch (e) {
      print('Error adding donation: $e');
      rethrow;
    }
  }

  // Update a donation record
  Future<void> updateDonation(DonationModel donation) async {
    try {
      await _donationsCollection.doc(donation.id).update(donation.toMap());
    } catch (e) {
      print('Error updating donation: $e');
      rethrow;
    }
  }

  // Delete a donation record
  Future<void> deleteDonation(String donationId, String donorId) async {
    try {
      // Get the donation to be deleted
      final donationDoc = await _donationsCollection.doc(donationId).get();
      if (!donationDoc.exists) {
        throw Exception('Donation not found');
      }
      
      // Delete the donation
      await _donationsCollection.doc(donationId).delete();
      
      // Update user's donation count
      await _recalculateUserDonationInfo(donorId);
    } catch (e) {
      print('Error deleting donation: $e');
      rethrow;
    }
  }

  // Get all donations for a specific donor
  Stream<List<DonationModel>> getUserDonations(String donorId) {
    return _donationsCollection
        .where('donorId', isEqualTo: donorId)
        .orderBy('donationDate', descending: true)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs
              .map((doc) => DonationModel.fromMap(doc.data() as Map<String, dynamic>))
              .toList();
        });
  }

  // Search for donors based on location and other criteria
  Future<List<UserModel>> searchDonors({
    String? division,
    String? district,
    String? city,
    String? area,
    String? upazila,
    String? bloodGroup,
    String? institution,
    String? subject,
    String? batchNumber,
    String? session,
    String? hscSession,
    String? donationInterestLevel,
    String? hscCollege,
    String? hscYear,
    String? honorsInstitution,
    String? honorsSubject,
    String? honorsSession,
    String? honorsYear,
    String? honorsInstitutionBatch,
    String? honorsSubjectBatch,
    String? mastersInstitution,
    String? mastersSubject,
    String? mastersSession,
    String? mastersYear,
    String? mastersInstitutionBatch,
    String? mastersSubjectBatch,
    Map<String, List<String>>? donationAreaPreferences,
  }) async {
    Query query = _usersCollection;
    
    // Add filters based on the provided criteria
    if (bloodGroup != null && bloodGroup.isNotEmpty) {
      query = query.where('bloodGroup', isEqualTo: bloodGroup);
    }
    
    if (institution != null && institution.isNotEmpty) {
      query = query.where('institution', isEqualTo: institution);
    }
    
    if (donationInterestLevel != null && donationInterestLevel.isNotEmpty) {
      query = query.where('donationInterestLevel', isEqualTo: donationInterestLevel);
    }
    
    // Location filters - we can't directly query nested fields with equality operators,
    // so we need to use array-contains-any or do filtering in the app
    if (division != null && division.isNotEmpty) {
      query = query.where('locations.division', arrayContains: division);
    }
    
    // Note: Firestore has limitations on how many compound queries can be combined
    // We'll apply the rest of the filters in memory after getting the results
    
    final querySnapshot = await query.get();
    
    // Convert the query results to UserModel objects
    List<UserModel> users = querySnapshot.docs
        .map((doc) => UserModel.fromMap(doc.data() as Map<String, dynamic>))
        .toList();
    
    // Additional filtering for district, city, and area if needed
    if (district != null && district.isNotEmpty) {
      users = users.where((user) => user.locations['district']?.contains(district) ?? false).toList();
    }
    
    if (city != null && city.isNotEmpty) {
      users = users.where((user) => user.locations['city']?.contains(city) ?? false).toList();
    }
    
    if (area != null && area.isNotEmpty) {
      users = users.where((user) => user.locations['area']?.contains(area) ?? false).toList();
    }
    
    if (upazila != null && upazila.isNotEmpty) {
      users = users.where((user) => user.locations['upazila']?.contains(upazila) ?? false).toList();
    }
    
    // Apply education filters
    if (subject != null && subject.isNotEmpty) {
      users = users.where((user) => 
        user.subject?.toLowerCase() == subject.toLowerCase() ||
        user.honorsSubject?.toLowerCase() == subject.toLowerCase() ||
        user.mastersSubject?.toLowerCase() == subject.toLowerCase()
      ).toList();
    }
    
    if (batchNumber != null && batchNumber.isNotEmpty) {
      users = users.where((user) => 
        user.batchNumber == batchNumber ||
        user.honorsInstitutionBatch == batchNumber ||
        user.honorsSubjectBatch == batchNumber ||
        user.mastersInstitutionBatch == batchNumber ||
        user.mastersSubjectBatch == batchNumber
      ).toList();
    }
    
    if (session != null && session.isNotEmpty) {
      users = users.where((user) => 
        user.session == session ||
        user.honorsSession == session ||
        user.mastersSession == session
      ).toList();
    }
    
    // HSC filters
    if (hscSession != null && hscSession.isNotEmpty) {
      users = users.where((user) => user.hscSession == hscSession).toList();
    }
    
    if (hscCollege != null && hscCollege.isNotEmpty) {
      users = users.where((user) => user.hscCollege == hscCollege).toList();
    }
    
    if (hscYear != null && hscYear.isNotEmpty) {
      users = users.where((user) => user.hscYear == hscYear).toList();
    }
    
    // Honours filters
    if (honorsInstitution != null && honorsInstitution.isNotEmpty) {
      users = users.where((user) => user.honorsInstitution == honorsInstitution).toList();
    }
    
    if (honorsSubject != null && honorsSubject.isNotEmpty) {
      users = users.where((user) => user.honorsSubject == honorsSubject).toList();
    }
    
    if (honorsSession != null && honorsSession.isNotEmpty) {
      users = users.where((user) => user.honorsSession == honorsSession).toList();
    }
    
    if (honorsYear != null && honorsYear.isNotEmpty) {
      users = users.where((user) => user.honorsYear == honorsYear).toList();
    }
    
    if (honorsInstitutionBatch != null && honorsInstitutionBatch.isNotEmpty) {
      users = users.where((user) => user.honorsInstitutionBatch == honorsInstitutionBatch).toList();
    }
    
    if (honorsSubjectBatch != null && honorsSubjectBatch.isNotEmpty) {
      users = users.where((user) => user.honorsSubjectBatch == honorsSubjectBatch).toList();
    }
    
    // Masters filters
    if (mastersInstitution != null && mastersInstitution.isNotEmpty) {
      users = users.where((user) => user.mastersInstitution == mastersInstitution).toList();
    }
    
    if (mastersSubject != null && mastersSubject.isNotEmpty) {
      users = users.where((user) => user.mastersSubject == mastersSubject).toList();
    }
    
    if (mastersSession != null && mastersSession.isNotEmpty) {
      users = users.where((user) => user.mastersSession == mastersSession).toList();
    }
    
    if (mastersYear != null && mastersYear.isNotEmpty) {
      users = users.where((user) => user.mastersYear == mastersYear).toList();
    }
    
    if (mastersInstitutionBatch != null && mastersInstitutionBatch.isNotEmpty) {
      users = users.where((user) => user.mastersInstitutionBatch == mastersInstitutionBatch).toList();
    }
    
    if (mastersSubjectBatch != null && mastersSubjectBatch.isNotEmpty) {
      users = users.where((user) => user.mastersSubjectBatch == mastersSubjectBatch).toList();
    }
    
    // Donation area preferences filtering
    if (donationAreaPreferences != null && donationAreaPreferences.isNotEmpty) {
      for (final entry in donationAreaPreferences.entries) {
        final key = entry.key;
        final values = entry.value;
        
        if (values.isEmpty) continue;
        
        users = users.where((user) {
          final userPrefs = user.donationAreaPreferences?[key];
          if (userPrefs == null || userPrefs.isEmpty) return false;
          
          // Check if any of the user's preferences match the search criteria
          return userPrefs.any((pref) => values.contains(pref));
        }).toList();
      }
    }
    
    return users;
  }

  // Update user's donation count and last donation date when a new donation is added
  Future<void> _updateUserDonationInfo(String userId, DateTime donationDate) async {
    try {
      // Get the user document
      final userDoc = await _usersCollection.doc(userId).get();
      if (!userDoc.exists) {
        throw Exception('User not found');
      }
      
      // Get current user data
      final userData = userDoc.data() as Map<String, dynamic>;
      final int currentDonationCount = userData['donationCount'] ?? 0;
      final Timestamp currentLastDonated = userData['lastDonated'] ?? Timestamp.now();
      
      // Update only if the new donation date is more recent
      if (donationDate.isAfter(currentLastDonated.toDate())) {
        await _usersCollection.doc(userId).update({
          'lastDonated': Timestamp.fromDate(donationDate),
          'donationCount': currentDonationCount + 1,
        });
      } else {
        // Just update the count if it's an older donation
        await _usersCollection.doc(userId).update({
          'donationCount': currentDonationCount + 1,
        });
      }
    } catch (e) {
      print('Error updating user donation info: $e');
      rethrow;
    }
  }

  // Recalculate user's donation count and last donation date when a donation is deleted
  Future<void> _recalculateUserDonationInfo(String userId) async {
    try {
      // Get all donations for the user
      final donations = await _donationsCollection
          .where('donorId', isEqualTo: userId)
          .orderBy('donationDate', descending: true)
          .get();
      
      // Calculate new values
      final int newDonationCount = donations.docs.length;
      Timestamp? newLastDonated;
      
      if (donations.docs.isNotEmpty) {
        newLastDonated = (donations.docs.first.data() as Map<String, dynamic>)['donationDate'];
      } else {
        // If no donations remain, set to a default value
        newLastDonated = Timestamp.fromDate(DateTime(2000));
      }
      
      // Update user document
      await _usersCollection.doc(userId).update({
        'donationCount': newDonationCount,
        'lastDonated': newLastDonated,
      });
    } catch (e) {
      print('Error recalculating user donation info: $e');
      rethrow;
    }
  }
} 