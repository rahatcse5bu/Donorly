import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/donation_model.dart';
import '../models/user_model.dart';
import '../services/donation_service.dart';

class DonationProvider with ChangeNotifier {
  final DonationService _donationService = DonationService();
  
  List<DonationModel> _userDonations = [];
  List<UserModel> _searchResults = [];
  bool _isLoading = false;
  String _error = '';
  Stream<List<DonationModel>>? _donationsStream;

  // Getters
  List<DonationModel> get userDonations => _userDonations;
  List<UserModel> get searchResults => _searchResults;
  bool get isLoading => _isLoading;
  String get error => _error;
  Stream<List<DonationModel>>? get donationsStream => _donationsStream;

  // Set up the donations stream for a user
  void setupDonationsStream(String userId) {
    _donationsStream = _donationService.getUserDonations(userId);
    notifyListeners();
  }

  // Add a new donation
  Future<bool> addDonation({
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
    _setLoading(true);
    _clearError();
    
    try {
      await _donationService.addDonation(
        donorId: donorId,
        location: location,
        address: address,
        receiverName: receiverName,
        receiverContact: receiverContact,
        bloodGroup: bloodGroup,
        purpose: purpose,
        donationDate: donationDate,
        locationDetails: locationDetails,
      );
      
      _setLoading(false);
      return true;
    } catch (e) {
      _setError(e.toString());
      _setLoading(false);
      return false;
    }
  }

  // Update a donation
  Future<bool> updateDonation(DonationModel donation) async {
    _setLoading(true);
    _clearError();
    
    try {
      await _donationService.updateDonation(donation);
      _setLoading(false);
      return true;
    } catch (e) {
      _setError(e.toString());
      _setLoading(false);
      return false;
    }
  }

  // Delete a donation
  Future<bool> deleteDonation(String donationId, String donorId) async {
    _setLoading(true);
    _clearError();
    
    try {
      await _donationService.deleteDonation(donationId, donorId);
      _setLoading(false);
      return true;
    } catch (e) {
      _setError(e.toString());
      _setLoading(false);
      return false;
    }
  }

  // Search for donors
  Future<void> searchDonors({
    String? division,
    String? district,
    String? city,
    String? area,
    String? upazila,
    String? bloodGroup,
    String? institution,
    String? subject,
    String? donationInterestLevel,
    Map<String, List<String>>? donationAreaPreferences,
  }) async {
    _setLoading(true);
    _clearError();
    _searchResults = [];
    
    try {
      _searchResults = await _donationService.searchDonors(
        division: division,
        district: district,
        city: city,
        area: area,
        upazila: upazila,
        bloodGroup: bloodGroup,
        institution: institution,
        subject: subject,
        donationInterestLevel: donationInterestLevel,
        donationAreaPreferences: donationAreaPreferences,
      );
      
      _setLoading(false);
    } catch (e) {
      _setError(e.toString());
      _setLoading(false);
    }
  }

  // Clear search results
  void clearSearchResults() {
    _searchResults = [];
    notifyListeners();
  }

  // Private methods
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String error) {
    _error = error;
    notifyListeners();
  }

  void _clearError() {
    _error = '';
    notifyListeners();
  }
} 