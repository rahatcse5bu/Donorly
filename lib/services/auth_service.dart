import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Get current user
  User? get currentUser => _auth.currentUser;

  // Stream of auth changes
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Create UserModel from Firebase User
  Future<UserModel?> getUserModel() async {
    final User? user = currentUser;
    if (user == null) return null;

    final docSnapshot = await _firestore.collection('users').doc(user.uid).get();
    if (docSnapshot.exists) {
      return UserModel.fromMap(docSnapshot.data()!);
    }
    return null;
  }

  // Register with email and password
  Future<UserModel?> registerWithEmailAndPassword({
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
    try {
      // Create user in Firebase Auth
      final UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      final User? user = result.user;
      if (user == null) throw Exception('Failed to create user');

      // Create initial user data
      final UserModel userModel = UserModel(
        uid: user.uid,
        email: email,
        name: name,
        bloodGroup: bloodGroup,
        phone: phone,
        whatsapp: whatsapp,
        occupation: occupation,
        institution: institution,
        presentAddress: presentAddress,
        permanentAddress: permanentAddress,
        preferableAreas: [],
        lastDonated: Timestamp.fromDate(DateTime(2000)),  // Default to a long time ago
        donationCount: 0,
        privacySettings: {
          'showEmail': false,
          'showPhone': true,
          'showWhatsapp': true,
        },
        locations: locations,
      );

      // Store user in Firestore
      await _firestore.collection('users').doc(user.uid).set(userModel.toMap());
      
      return userModel;
    } catch (e) {
      print('Registration error: $e');
      rethrow;
    }
  }

  // Sign in with email and password
  Future<UserModel?> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      final User? user = result.user;
      if (user == null) return null;

      return await getUserModel();
    } catch (e) {
      print('Sign in error: $e');
      rethrow;
    }
  }

  // Sign out
  Future<void> signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      print('Sign out error: $e');
      rethrow;
    }
  }

  // Reset password
  Future<void> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } catch (e) {
      print('Reset password error: $e');
      rethrow;
    }
  }

  // Update user profile
  Future<void> updateUserProfile(UserModel updatedUser) async {
    try {
      await _firestore.collection('users').doc(updatedUser.uid).update(updatedUser.toMap());
    } catch (e) {
      print('Update profile error: $e');
      rethrow;
    }
  }

  // Get error message from Firebase error code
  String getErrorMessage(String code) {
    switch (code) {
      case 'invalid-email':
        return 'The email address is badly formatted.';
      case 'user-disabled':
        return 'This user has been disabled.';
      case 'user-not-found':
        return 'No user found with this email.';
      case 'wrong-password':
        return 'The password is invalid.';
      case 'email-already-in-use':
        return 'The email address is already in use by another account.';
      case 'operation-not-allowed':
        return 'Email/password accounts are not enabled.';
      case 'weak-password':
        return 'The password is too weak.';
      default:
        return 'An undefined error occurred.';
    }
  }
} 