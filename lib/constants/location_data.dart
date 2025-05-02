import 'package:flutter/material.dart';

class LocationData {
  // Divisions of Bangladesh
  static const List<String> divisions = [
    'Barishal',
    'Chattogram',
    'Dhaka',
    'Khulna',
    'Rajshahi',
    'Rangpur',
    'Sylhet',
    'Mymensingh',
  ];

  // Map of divisions to their districts
  static const Map<String, List<String>> districtsByDivision = {
    'Barishal': [
      'Barguna',
      'Barishal',
      'Bhola',
      'Jhalokati',
      'Patuakhali',
      'Pirojpur',
    ],
    'Chattogram': [
      'Bandarban',
      'Brahmanbaria',
      'Chandpur',
      'Chattogram',
      'Cox\'s Bazar',
      'Cumilla',
      'Feni',
      'Khagrachhari',
      'Lakshmipur',
      'Noakhali',
      'Rangamati',
    ],
    'Dhaka': [
      'Dhaka',
      'Faridpur',
      'Gazipur',
      'Gopalganj',
      'Kishoreganj',
      'Madaripur',
      'Manikganj',
      'Munshiganj',
      'Narayanganj',
      'Narsingdi',
      'Rajbari',
      'Shariatpur',
      'Tangail',
    ],
    'Khulna': [
      'Bagerhat',
      'Chuadanga',
      'Jashore',
      'Jhenaidah',
      'Khulna',
      'Kushtia',
      'Magura',
      'Meherpur',
      'Narail',
      'Satkhira',
    ],
    'Rajshahi': [
      'Bogura',
      'Joypurhat',
      'Naogaon',
      'Natore',
      'Chapainawabganj',
      'Pabna',
      'Rajshahi',
      'Sirajganj',
    ],
    'Rangpur': [
      'Dinajpur',
      'Gaibandha',
      'Kurigram',
      'Lalmonirhat',
      'Nilphamari',
      'Panchagarh',
      'Rangpur',
      'Thakurgaon',
    ],
    'Sylhet': [
      'Habiganj',
      'Moulvibazar',
      'Sunamganj',
      'Sylhet',
    ],
    'Mymensingh': [
      'Jamalpur',
      'Mymensingh',
      'Netrokona',
      'Sherpur',
    ],
  };

  // Map of districts to their upazilas
  static const Map<String, List<String>> upazilasByDistrict = {
    'Dhaka': [
      'Dhamrai',
      'Dohar',
      'Keraniganj',
      'Nawabganj',
      'Savar',
      'Tejgaon Circle',
    ],
    'Faridpur': [
      'Alfadanga',
      'Bhanga',
      'Boalmari',
      'Charbhadrasan',
      'Faridpur Sadar',
      'Madhukhali',
      'Nagarkanda',
      'Sadarpur',
      'Saltha',
    ],
    // Add more districts and their upazilas as needed
  };

  // Map of districts to their major cities/towns
  static const Map<String, List<String>> citiesByDistrict = {
    'Dhaka': [
      'Dhaka',
      'Savar',
      'Tongi',
      'Gazipur',
      'Narayanganj',
    ],
    'Chattogram': [
      'Chattogram',
      'Patiya',
      'Sitakunda',
      'Hathazari',
      'Mirsharai',
    ],
    // Add more districts and their cities as needed
  };

  // Helper method to get districts based on selected division
  static List<String> getDistrictsForDivision(String division) {
    return districtsByDivision[division] ?? [];
  }

  // Helper method to get cities based on selected district
  static List<String> getCitiesForDistrict(String district) {
    return citiesByDistrict[district] ?? [];
  }

  // Helper method to get upazilas based on selected district
  static List<String> getUpazilasForDistrict(String district) {
    return upazilasByDistrict[district] ?? [];
  }
} 