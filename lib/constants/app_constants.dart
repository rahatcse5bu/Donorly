import 'package:flutter/material.dart';

class AppConstants {
  // Blood Groups
  static const List<String> bloodGroups = [
    'A+',
    'A-',
    'B+',
    'B-',
    'AB+',
    'AB-',
    'O+',
    'O-',
  ];

  // App Theme Colors
  static const Color primaryColor = Color(0xFFE53935); // Red
  static const Color accentColor = Color(0xFFEF5350); // Light Red
  static const Color backgroundColor = Color(0xFFF5F5F5);
  static const Color textColor = Color(0xFF212121);
  static const Color subtitleColor = Color(0xFF757575);

  // Search Categories
  static const List<String> searchCategories = [
    'Division',
    'District',
    'City',
    'Area',
    'Medical College',
    'Diagnostic Center',
    'Educational Institution',
  ];

  // Privacy Settings Options
  static const Map<String, String> privacyOptions = {
    'showEmail': 'Show Email to Others',
    'showPhone': 'Show Phone Number to Others',
    'showWhatsapp': 'Show WhatsApp Number to Others',
    'showAddress': 'Show Address Information',
    'showEducation': 'Show Education Information',
    'showOccupation': 'Show Occupation Information',
    'showDonationHistory': 'Show Donation History'
  };

  // Donation Eligibility Time Period (in months)
  static const int donationEligibilityPeriod = 3;

  // Default Error Message
  static const String defaultErrorMessage = 'Something went wrong. Please try again.';

  // Auth Error Messages
  static const Map<String, String> authErrorMessages = {
    'invalid-email': 'The email address is badly formatted.',
    'user-disabled': 'This user has been disabled.',
    'user-not-found': 'No user found with this email.',
    'wrong-password': 'The password is invalid.',
    'email-already-in-use': 'The email address is already in use by another account.',
    'operation-not-allowed': 'Email/password accounts are not enabled.',
    'weak-password': 'The password is too weak.',
  };

  // Donation Interest Levels
  static const List<String> interestLevels = [
    'Low', 'Medium', 'High', 'Extremely High'
  ];

  // Education Levels (in ascending order)
  static const List<String> educationLevels = [
    'Lower Class', 'SSC', 'HSC', 'Honours', 'Masters', 'PhD'
  ];

  // Bangladesh Divisions
  static const List<String> divisions = [
    'Dhaka', 'Chittagong', 'Rajshahi', 'Khulna', 
    'Barisal', 'Sylhet', 'Rangpur', 'Mymensingh'
  ];

  // Districts by Division
  static const Map<String, List<String>> districtsByDivision = {
    'Dhaka': [
      'Dhaka', 'Gazipur', 'Narsingdi', 'Manikganj', 
      'Munshiganj', 'Narayanganj', 'Tangail', 'Faridpur',
      'Madaripur', 'Shariatpur', 'Rajbari', 'Gopalganj', 'Kishoreganj'
    ],
    'Chittagong': [
      'Chittagong', 'Cox\'s Bazar', 'Rangamati', 'Bandarban', 
      'Khagrachari', 'Noakhali', 'Feni', 'Lakshmipur',
      'Comilla', 'Brahmanbaria', 'Chandpur'
    ],
    'Rajshahi': [
      'Rajshahi', 'Natore', 'Naogaon', 'Nawabganj', 
      'Pabna', 'Sirajganj', 'Bogra', 'Joypurhat'
    ],
    'Khulna': [
      'Khulna', 'Bagerhat', 'Satkhira', 'Jessore', 
      'Magura', 'Jhenaidah', 'Narail', 'Kushtia',
      'Chuadanga', 'Meherpur'
    ],
    'Barisal': [
      'Barisal', 'Bhola', 'Patuakhali', 'Pirojpur', 
      'Jhalokati', 'Barguna'
    ],
    'Sylhet': [
      'Sylhet', 'Moulvibazar', 'Habiganj', 'Sunamganj'
    ],
    'Rangpur': [
      'Rangpur', 'Gaibandha', 'Nilphamari', 'Kurigram', 
      'Lalmonirhat', 'Dinajpur', 'Thakurgaon', 'Panchagarh'
    ],
    'Mymensingh': [
      'Mymensingh', 'Jamalpur', 'Sherpur', 'Netrokona'
    ]
  };
  
  // Upazilas by District
  static const Map<String, List<String>> upazilasByDistrict = {
    'Dhaka': [
      'Dhamrai', 'Dohar', 'Keraniganj', 'Nawabganj', 'Savar', 'Tejgaon Circle', 
      'Mohammadpur', 'Mirpur', 'Pallabi', 'Pallabi', 'Uttara', 'Baridhara', 
      'Badda', 'Banani', 'Bangshal', 'Dhanmondi', 'Gulshan', 'Hazaribagh', 
      'Jatrabari', 'Kafrul', 'Khilgaon', 'Khilkhet', 'Lalbagh', 'Motijheel',
      'New Market', 'Ramna', 'Rampura', 'Sabujbagh', 'Shah Ali', 'Shahbag',
      'Sher-e-Bangla Nagar', 'Shyampur', 'Sutrapur', 'Tejgaon', 'Turag',
      'Uttar Khan', 'Vatara', 'Wari'
    ],
    'Gazipur': [
      'Gazipur Sadar', 'Kaliakair', 'Kaliganj', 'Kapasia', 'Sreepur', 'Tongi'
    ],
    'Narsingdi': [
      'Narsingdi Sadar', 'Belabo', 'Monohardi', 'Palash', 'Raipura', 'Shibpur'
    ],
    'Tangail': [
      'Tangail Sadar', 'Basail', 'Bhuapur', 'Delduar', 'Dhanbari', 'Ghatail',
      'Gopalpur', 'Kalihati', 'Madhupur', 'Mirzapur', 'Nagarpur', 'Sakhipur'
    ],
    'Faridpur': [
      'Faridpur Sadar', 'Alfadanga', 'Bhanga', 'Boalmari', 'Charbhadrasan',
      'Madhukhali', 'Nagarkanda', 'Sadarpur', 'Saltha'
    ],
    'Rajshahi': [
      'Rajshahi City', 'Bagha', 'Bagmara', 'Charghat', 'Durgapur', 'Godagari', 
      'Mohanpur', 'Paba', 'Puthia', 'Tanore', 'Boalia', 'Matihar', 'Rajpara', 'Shah Makhdum'
    ],
    'Khulna': [
      'Khulna City', 'Batiaghata', 'Dacope', 'Dumuria', 'Dighalia', 'Koyra',
      'Paikgachha', 'Phultala', 'Rupsa', 'Terokhada', 'Khan Jahan Ali', 'Khalishpur',
      'Sonadanga', 'Daulatpur'
    ],
    'Chittagong': [
      'Chittagong City', 'Anwara', 'Banshkhali', 'Boalkhali', 'Chandanaish', 'Fatikchhari', 
      'Hathazari', 'Lohagara', 'Mirsharai', 'Patiya', 'Rangunia', 'Raozan', 'Sandwip', 
      'Satkania', 'Sitakunda', 'Pahartali', 'Double Mooring', 'Kotwali', 'Khulshi', 'Panchlaish',
      'Bakalia', 'Chandgaon', 'Bayazid Bostami', 'Karnaphuli', 'Halishahar'
    ],
    'Comilla': [
      'Comilla Sadar', 'Barura', 'Brahmanpara', 'Burichang', 'Chandina', 'Chauddagram',
      'Daudkandi', 'Debidwar', 'Homna', 'Laksham', 'Muradnagar', 'Nangalkot', 'Titas'
    ],
    'Sylhet': [
      'Sylhet City', 'Balaganj', 'Beanibazar', 'Bishwanath', 'Companiganj', 'Fenchuganj', 
      'Golapganj', 'Gowainghat', 'Jaintiapur', 'Kanaighat', 'Osmani Nagar', 
      'South Surma', 'Zakiganj', 'Sylhet Sadar'
    ],
    'Barisal': [
      'Barisal City', 'Agailjhara', 'Babuganj', 'Bakerganj', 'Banaripara', 'Gaurnadi',
      'Hizla', 'Mehendiganj', 'Muladi', 'Wazirpur'
    ],
    'Mymensingh': [
      'Mymensingh City', 'Bhaluka', 'Dhobaura', 'Fulbaria', 'Gaffargaon', 'Gauripur',
      'Haluaghat', 'Ishwarganj', 'Muktagachha', 'Nandail', 'Phulpur', 'Trishal'
    ],
    'Rangpur': [
      'Rangpur City', 'Badarganj', 'Gangachara', 'Kaunia', 'Mithapukur', 'Pirgachha',
      'Pirganj', 'Taraganj'
    ],
    'Dinajpur': [
      'Dinajpur Sadar', 'Birampur', 'Birganj', 'Biral', 'Bochaganj', 'Chirirbandar',
      'Fulbari', 'Ghoraghat', 'Hakimpur', 'Kaharole', 'Khansama', 'Nawabganj', 'Parbatipur'
    ],
    'Jessore': [
      'Jessore Sadar', 'Abhaynagar', 'Bagherpara', 'Chaugachha', 'Jhikargachha',
      'Keshabpur', 'Manirampur', 'Sharsha'
    ],
    'Bogra': [
      'Bogra Sadar', 'Adamdighi', 'Dhunat', 'Dhupchanchia', 'Gabtali', 'Kahaloo',
      'Nandigram', 'Sariakandi', 'Shajahanpur', 'Sherpur', 'Shibganj', 'Sonatala'
    ],
    'Kushtia': [
      'Kushtia Sadar', 'Bheramara', 'Daulatpur', 'Khoksa', 'Kumarkhali', 'Mirpur'
    ],
    'Noakhali': [
      'Noakhali Sadar', 'Begumganj', 'Chatkhil', 'Companiganj', 'Hatiya', 'Kabirhat',
      'Senbagh', 'Sonaimuri', 'Subarnachar'
    ],
    'Narayanganj': [
      'Narayanganj Sadar', 'Araihazar', 'Bandar', 'Rupganj', 'Sonargaon', 'Fatullah'
    ],
    'Cox\'s Bazar': [
      'Cox\'s Bazar Sadar', 'Chakaria', 'Kutubdia', 'Maheshkhali', 'Pekua', 'Ramu',
      'Teknaf', 'Ukhia'
    ]
  };

  // Common Cities & Areas
  static const Map<String, List<String>> citiesByDistrict = {
    'Dhaka': [
      'Mirpur', 'Uttara', 'Mohammadpur', 'Dhanmondi', 'Gulshan', 
      'Banani', 'Motijheel', 'Old Dhaka', 'Tejgaon', 'Badda',
      'Rampura', 'Khilgaon', 'Shahbag', 'Farmgate'
    ],
    'Chittagong': [
      'Agrabad', 'Nasirabad', 'Halishahar', 'Patenga',
      'Chawkbazar', 'GEC Circle', 'Khulshi', 'Kotwali'
    ],
    'Sylhet': [
      'Zindabazar', 'Ambarkhana', 'Shahjalal Upashahar',
      'Shibganj', 'South Surma', 'Tilagarh' 
    ],
    // Add more as needed
  };

  // Educational Institutions - More comprehensive list
  static const List<String> educationalInstitutions = [
    // Universities
    'University of Dhaka', 
    'Bangladesh University of Engineering and Technology (BUET)',
    'Khulna University of Engineering & Technology (KUET)',
    'Rajshahi University of Engineering & Technology (RUET)',
    'Chittagong University of Engineering & Technology (CUET)',
    'University of Chittagong',
    'University of Rajshahi',
    'Bangladesh Agricultural University',
    'Bangabandhu Sheikh Mujib Medical University',
    'Jahangirnagar University',
    'Islamic University, Bangladesh',
    'Shahjalal University of Science and Technology',
    'Khulna University',
    'National University',
    'Bangladesh Open University',
    'Bangabandhu Sheikh Mujibur Rahman Agricultural University',
    'Hajee Mohammad Danesh Science & Technology University',
    'Mawlana Bhashani Science and Technology University',
    'Patuakhali Science and Technology University',
    'Sher-e-Bangla Agricultural University',
    'Jagannath University',
    'Comilla University',
    'Jatiya Kabi Kazi Nazrul Islam University',
    'Chittagong Veterinary and Animal Sciences University',
    'Sylhet Agricultural University',
    'Jessore University of Science and Technology',
    'Pabna University of Science and Technology',
    'Begum Rokeya University, Rangpur',
    'Bangladesh University of Professionals',
    'Bangabandhu Sheikh Mujibur Rahman Science and Technology University',
    'Bangladesh University of Textiles',
    'University of Barisal',
    'Rangamati Science and Technology University',
    'Bangabandhu Sheikh Mujibur Rahman Maritime University',
    'Islamic Arabic University',
    'Rabindra University, Bangladesh',
    'Bangabandhu Sheikh Mujibur Rahman Digital University',
    'Sheikh Hasina University',
    'Khulna Agricultural University',
    'Bangamata Sheikh Fojilatunnesa Mujib Science and Technology University',
    'Chandpur Science and Technology University',
    'Habiganj Agricultural University',
    'Sheikh Hasina Medical University, Khulna',
    'Kabi Nazrul Government College',
    
    // Private Universities
    'North South University',
    'American International University-Bangladesh',
    'East West University',
    'BRAC University',
    'Independent University, Bangladesh',
    'Ahsanullah University of Science and Technology',
    'International Islamic University Chittagong',
    'University of Science & Technology Chittagong',
    'Daffodil International University',
    'International University of Business Agriculture and Technology',
    'University of Asia Pacific',
    'Bangladesh University of Business and Technology',
    'City University, Bangladesh',
    'Stamford University Bangladesh',
    'United International University',
    'University of Information Technology and Sciences',
    'Premier University, Chittagong',
    'Southeast University',
    'State University of Bangladesh',
    'Green University of Bangladesh',
    
    // Medical Colleges
    'Dhaka Medical College',
    'Sir Salimullah Medical College',
    'Shaheed Suhrawardy Medical College',
    'Chittagong Medical College',
    'Rajshahi Medical College',
    'Sylhet MAG Osmani Medical College',
    'Mymensingh Medical College',
    'Sher-e-Bangla Medical College',
    'Rangpur Medical College',
    'Comilla Medical College',
    'Khulna Medical College',
    'Armed Forces Medical College',
    
    // Colleges
    'Notre Dame College',
    'Holy Cross College',
    'Dhaka College',
    'Eden Mohila College',
    'Government Shaheed Suhrawardy College',
    'Rajuk Uttara Model College',
    'Viqarunnisa Noon School and College',
    'Govt. Science College',
    'Dhaka City College',
    'Adamjee Cantonment College',
    'Chittagong College',
    'Rajshahi College',
    'Carmichael College',
    'New Government Degree College',
    'Brahmanbaria Government College',
    'Comilla Victoria Government College',
    'Government Haraganga College',
    'Government Akbar Ali College',
    'Fazlul Huq College',
    'Government Edward College',
    'Dinajpur Government College',
  ];
  
  // Academic Subjects/Departments
  static const List<String> academicSubjects = [
    // Science & Engineering
    'Computer Science and Engineering',
    'Electrical and Electronic Engineering',
    'Mechanical Engineering',
    'Civil Engineering',
    'Architecture',
    'Chemical Engineering',
    'Materials and Metallurgical Engineering',
    'Naval Architecture and Marine Engineering',
    'Industrial and Production Engineering',
    'Water Resources Engineering',
    'Physics',
    'Chemistry',
    'Mathematics',
    'Statistics',
    'Biochemistry and Molecular Biology',
    'Genetic Engineering and Biotechnology',
    'Environmental Science',
    'Geology',
    'Robotics and Mechatronics',
    'Textile Engineering',
    'Biomedical Engineering',
    'Nuclear Engineering',
    
    // Medical & Health Sciences
    'Medicine',
    'Surgery',
    'Dental Surgery',
    'Pharmacy',
    'Nutrition and Food Science',
    'Physiotherapy',
    'Public Health',
    'Microbiology',
    'Anatomy',
    'Physiology',
    'Pharmacology',
    'Pathology',
    'Virology',
    
    // Business & Economics
    'Business Administration',
    'Management',
    'Marketing',
    'Finance',
    'Accounting',
    'Economics',
    'Banking',
    'Human Resource Management',
    'Management Information Systems',
    'Tourism and Hospitality Management',
    'International Business',
    
    // Social Sciences & Humanities
    'Anthropology',
    'Sociology',
    'Psychology',
    'Political Science',
    'International Relations',
    'Public Administration',
    'Social Work',
    'Women and Gender Studies',
    'Development Studies',
    'Mass Communication and Journalism',
    'Peace and Conflict Studies',
    'Population Sciences',
    'Urban and Regional Planning',
    
    // Arts & Humanities
    'Bangla',
    'English',
    'History',
    'Philosophy',
    'Islamic Studies',
    'Islamic History and Culture',
    'Arabic',
    'Persian Language and Literature',
    'Urdu',
    'Sanskrit',
    'Pali and Buddhist Studies',
    'Fine Arts',
    'Music',
    'Theatre and Performance Studies',
    'Film and Media Studies',
    
    // Agriculture & Veterinary Sciences
    'Agriculture',
    'Agricultural Economics',
    'Agronomy',
    'Soil Science',
    'Horticulture',
    'Plant Pathology',
    'Entomology',
    'Fisheries',
    'Livestock',
    'Forestry',
    'Veterinary Science',
    'Animal Husbandry',
    
    // Law & Education
    'Law',
    'Education',
    'Curriculum and Instructional Technology',
    'Educational Administration',
    'Criminology',
    
    // Information Technology
    'Information Technology',
    'Software Engineering',
    'Data Science',
    'Artificial Intelligence',
    'Cyber Security',
    'Networking',
    'Database Management',
    'Web and Mobile Application Development',
  ];
} 