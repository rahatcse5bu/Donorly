import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../services/auth_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserProvider with ChangeNotifier {
  final AuthService _authService = AuthService();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  
  UserModel? _currentUser;
  bool _isLoading = false;
  String _error = '';

  // Getters
  UserModel? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  String get error => _error;
  bool get isLoggedIn => _currentUser != null;

  // Initialize provider - check if user is already logged in
  Future<void> initialize() async {
    _setLoading(true);
    try {
      if (_authService.currentUser != null) {
        _currentUser = await _authService.getUserModel();
      }
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  // Register a new user
  Future<bool> registerUser({
    required String email,
    required String password,
    required String name,
    required String bloodGroup,
    required String phone,
    required String whatsapp,
    required String occupation,
    required String institution,
    required String presentAddress,
    required String permanentAddress,
    required Map<String, List<String>> locations,
  }) async {
    _setLoading(true);
    _clearError();
    
    try {
      _currentUser = await _authService.registerWithEmailAndPassword(
        email: email,
        password: password,
        name: name,
        bloodGroup: bloodGroup,
        phone: phone,
        whatsapp: whatsapp,
        occupation: occupation,
        institution: institution,
        presentAddress: presentAddress,
        permanentAddress: permanentAddress,
        locations: locations,
      );
      
      _setLoading(false);
      return true;
    } catch (e) {
      _setError(_getErrorMessage(e));
      _setLoading(false);
      return false;
    }
  }

  // Sign in existing user
  Future<bool> signIn({required String email, required String password}) async {
    _setLoading(true);
    _clearError();
    
    try {
      _currentUser = await _authService.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      _setLoading(false);
      return _currentUser != null;
    } catch (e) {
      _setError(_getErrorMessage(e));
      _setLoading(false);
      return false;
    }
  }

  // Sign out user
  Future<void> signOut() async {
    _setLoading(true);
    _clearError();
    
    try {
      await _authService.signOut();
      _currentUser = null;
    } catch (e) {
      _setError(_getErrorMessage(e));
    } finally {
      _setLoading(false);
    }
  }

  // Update user profile
  Future<bool> updateUserProfile({
    String? name,
    String? bloodGroup,
    String? phone,
    String? whatsapp,
    String? occupation,
    String? institution,
    String? presentAddress,
    String? permanentAddress,
    List<String>? preferableAreas,
    Map<String, bool>? privacySettings,
    Map<String, List<String>>? locations,
    String? subject,
    String? batchNumber,
    String? session,
    String? donationInterestLevel,
    String? highestEducationLevel,
    
    // Lower Class Information
    String? lowerClassName,
    String? lowerClassSchool,
    String? lowerClassYear,
    
    // SSC Information
    String? sscSchool,
    String? sscYear,
    String? sscSession,
    
    // HSC Information
    String? hscCollege,
    String? hscYear,
    String? hscSession,
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
    if (_currentUser == null) return false;
    
    _setLoading(true);
    _clearError();
    
    try {
      final updatedUser = _currentUser!.copyWith(
        name: name,
        bloodGroup: bloodGroup,
        phone: phone,
        whatsapp: whatsapp,
        occupation: occupation,
        institution: institution,
        presentAddress: presentAddress,
        permanentAddress: permanentAddress,
        preferableAreas: preferableAreas,
        privacySettings: privacySettings,
        locations: locations,
        subject: subject,
        batchNumber: batchNumber,
        session: session,
        donationInterestLevel: donationInterestLevel,
        highestEducationLevel: highestEducationLevel,
        lowerClassName: lowerClassName,
        lowerClassSchool: lowerClassSchool,
        lowerClassYear: lowerClassYear,
        sscSchool: sscSchool,
        sscYear: sscYear,
        sscSession: sscSession,
        hscCollege: hscCollege,
        hscYear: hscYear,
        hscSession: hscSession,
        honorsInstitution: honorsInstitution,
        honorsSubject: honorsSubject,
        honorsSession: honorsSession,
        honorsYear: honorsYear,
        honorsInstitutionBatch: honorsInstitutionBatch,
        honorsSubjectBatch: honorsSubjectBatch,
        mastersInstitution: mastersInstitution,
        mastersSubject: mastersSubject,
        mastersSession: mastersSession,
        mastersYear: mastersYear,
        mastersInstitutionBatch: mastersInstitutionBatch,
        mastersSubjectBatch: mastersSubjectBatch,
        donationAreaPreferences: donationAreaPreferences,
      );
      
      await _authService.updateUserProfile(updatedUser);
      _currentUser = updatedUser;
      _setLoading(false);
      return true;
    } catch (e) {
      _setError(_getErrorMessage(e));
      _setLoading(false);
      return false;
    }
  }

  // Update donation history
  Future<bool> updateDonationHistory({
    required Timestamp lastDonated,
    required int donationCount,
  }) async {
    if (_currentUser == null) return false;
    
    _setLoading(true);
    _clearError();
    
    try {
      final updatedUser = _currentUser!.copyWith(
        lastDonated: lastDonated,
        donationCount: donationCount,
      );
      
      await _authService.updateUserProfile(updatedUser);
      _currentUser = updatedUser;
      _setLoading(false);
      return true;
    } catch (e) {
      _setError(_getErrorMessage(e));
      _setLoading(false);
      return false;
    }
  }
  
  // Reset password
  Future<bool> resetPassword(String email) async {
    _setLoading(true);
    _clearError();
    
    try {
      await _authService.resetPassword(email);
      _setLoading(false);
      return true;
    } catch (e) {
      _setError(_getErrorMessage(e));
      _setLoading(false);
      return false;
    }
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

  String _getErrorMessage(dynamic error) {
    if (error is FirebaseException) {
      return _authService.getErrorMessage(error.code);
    }
    return error.toString();
  }
} 