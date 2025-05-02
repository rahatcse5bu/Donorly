import 'package:cloud_firestore/cloud_firestore.dart';

class DonationModel {
  final String id;
  final String donorId;
  final String location; // Medical college, diagnostic center, etc.
  final String address;
  final String receiverName;
  final String receiverContact;
  final String? receiverEmail;
  final String bloodGroup;
  final String purpose; // Purpose of donation
  final Timestamp donationDate;
  final Map<String, String> locationDetails; // Division, district, city, area/upazila

  DonationModel({
    required this.id,
    required this.donorId,
    required this.location,
    required this.address,
    required this.receiverName,
    required this.receiverContact,
    this.receiverEmail,
    required this.bloodGroup,
    required this.purpose,
    required this.donationDate,
    required this.locationDetails,
  });

  // Convert Donation object to a Map (for sending to Firestore)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'donorId': donorId,
      'location': location,
      'address': address,
      'receiverName': receiverName,
      'receiverContact': receiverContact,
      'receiverEmail': receiverEmail,
      'bloodGroup': bloodGroup,
      'purpose': purpose,
      'donationDate': donationDate,
      'locationDetails': locationDetails,
    };
  }

  // Create Donation from a Map (for receiving from Firestore)
  factory DonationModel.fromMap(Map<String, dynamic> map) {
    return DonationModel(
      id: map['id'] ?? '',
      donorId: map['donorId'] ?? '',
      location: map['location'] ?? '',
      address: map['address'] ?? '',
      receiverName: map['receiverName'] ?? '',
      receiverContact: map['receiverContact'] ?? '',
      receiverEmail: map['receiverEmail'],
      bloodGroup: map['bloodGroup'] ?? '',
      purpose: map['purpose'] ?? '',
      donationDate: map['donationDate'] ?? Timestamp.now(),
      locationDetails: Map<String, String>.from(map['locationDetails'] ?? {}),
    );
  }

  // Create a copy of this donation with changes
  DonationModel copyWith({
    String? id,
    String? donorId,
    String? location,
    String? address,
    String? receiverName,
    String? receiverContact,
    String? receiverEmail,
    String? bloodGroup,
    String? purpose,
    Timestamp? donationDate,
    Map<String, String>? locationDetails,
  }) {
    return DonationModel(
      id: id ?? this.id,
      donorId: donorId ?? this.donorId,
      location: location ?? this.location,
      address: address ?? this.address,
      receiverName: receiverName ?? this.receiverName,
      receiverContact: receiverContact ?? this.receiverContact,
      receiverEmail: receiverEmail ?? this.receiverEmail,
      bloodGroup: bloodGroup ?? this.bloodGroup,
      purpose: purpose ?? this.purpose,
      donationDate: donationDate ?? this.donationDate,
      locationDetails: locationDetails ?? this.locationDetails,
    );
  }
} 