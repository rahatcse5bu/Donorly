import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String uid;
  final String email;
  final String name;
  final String bloodGroup;
  final String phone;
  final String whatsapp;
  final String occupation;
  final String institution;
  final String presentAddress;
  final String permanentAddress;
  final List<String> preferableAreas;
  final Timestamp lastDonated;
  final int donationCount;
  final Map<String, bool> privacySettings;
  final Map<String, List<String>> locations; // division, district, city, area

  UserModel({
    required this.uid,
    required this.email,
    required this.name,
    required this.bloodGroup,
    required this.phone,
    required this.whatsapp,
    required this.occupation,
    required this.institution,
    required this.presentAddress,
    required this.permanentAddress,
    required this.preferableAreas,
    required this.lastDonated,
    required this.donationCount,
    required this.privacySettings,
    required this.locations,
  });

  // Convert User object to a Map (for sending to Firestore)
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'name': name,
      'bloodGroup': bloodGroup,
      'phone': phone,
      'whatsapp': whatsapp,
      'occupation': occupation,
      'institution': institution,
      'presentAddress': presentAddress,
      'permanentAddress': permanentAddress,
      'preferableAreas': preferableAreas,
      'lastDonated': lastDonated,
      'donationCount': donationCount,
      'privacySettings': privacySettings,
      'locations': locations,
    };
  }

  // Create User from a Map (for receiving from Firestore)
  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'] ?? '',
      email: map['email'] ?? '',
      name: map['name'] ?? '',
      bloodGroup: map['bloodGroup'] ?? '',
      phone: map['phone'] ?? '',
      whatsapp: map['whatsapp'] ?? '',
      occupation: map['occupation'] ?? '',
      institution: map['institution'] ?? '',
      presentAddress: map['presentAddress'] ?? '',
      permanentAddress: map['permanentAddress'] ?? '',
      preferableAreas: List<String>.from(map['preferableAreas'] ?? []),
      lastDonated: map['lastDonated'] ?? Timestamp.now(),
      donationCount: map['donationCount'] ?? 0,
      privacySettings: Map<String, bool>.from(map['privacySettings'] ?? {
        'showEmail': false,
        'showPhone': true,
        'showWhatsapp': true,
      }),
      locations: Map<String, List<String>>.from(
        map['locations']?.map(
              (key, value) => MapEntry(key, List<String>.from(value)),
            ) ??
            {},
      ),
    );
  }

  // Return time passed since last donation in months
  int get timeSinceLastDonation {
    final now = DateTime.now();
    final lastDonationDate = lastDonated.toDate();
    return (now.year - lastDonationDate.year) * 12 + now.month - lastDonationDate.month;
  }

  // Check if the user is eligible to donate (assuming 3 months minimum gap)
  bool get canDonateNow {
    return timeSinceLastDonation >= 3;
  }

  // Create a copy of this user with changes
  UserModel copyWith({
    String? uid,
    String? email,
    String? name,
    String? bloodGroup,
    String? phone,
    String? whatsapp,
    String? occupation,
    String? institution,
    String? presentAddress,
    String? permanentAddress,
    List<String>? preferableAreas,
    Timestamp? lastDonated,
    int? donationCount,
    Map<String, bool>? privacySettings,
    Map<String, List<String>>? locations,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      email: email ?? this.email,
      name: name ?? this.name,
      bloodGroup: bloodGroup ?? this.bloodGroup,
      phone: phone ?? this.phone,
      whatsapp: whatsapp ?? this.whatsapp,
      occupation: occupation ?? this.occupation,
      institution: institution ?? this.institution,
      presentAddress: presentAddress ?? this.presentAddress,
      permanentAddress: permanentAddress ?? this.permanentAddress,
      preferableAreas: preferableAreas ?? this.preferableAreas,
      lastDonated: lastDonated ?? this.lastDonated,
      donationCount: donationCount ?? this.donationCount,
      privacySettings: privacySettings ?? this.privacySettings,
      locations: locations ?? this.locations,
    );
  }
} 