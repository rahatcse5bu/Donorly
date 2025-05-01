import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../constants/app_constants.dart';
import '../../models/user_model.dart';
import '../../providers/user_provider.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/custom_dropdown.dart';
import '../../widgets/searchable_dropdown.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({Key? key}) : super(key: key);

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _whatsappController = TextEditingController();
  final _occupationController = TextEditingController();
  final _presentAddressController = TextEditingController();
  final _permanentAddressController = TextEditingController();
  final _cityController = TextEditingController();
  final _areaController = TextEditingController();
  final _sessionController = TextEditingController();
  
  // Lower Class controllers
  final _lowerClassNameController = TextEditingController();
  final _lowerClassSchoolController = TextEditingController();
  final _lowerClassYearController = TextEditingController();
  
  // SSC controllers
  final _sscSchoolController = TextEditingController();
  final _sscYearController = TextEditingController();
  final _sscSessionController = TextEditingController();
  
  // HSC controllers
  final _hscSessionController = TextEditingController();
  final _hscYearController = TextEditingController();
  
  // Honours controllers
  final _honorsSessionController = TextEditingController();
  final _honorsYearController = TextEditingController();
  final _honorsInstitutionBatchController = TextEditingController();
  final _honorsSubjectBatchController = TextEditingController();
  
  // Masters controllers
  final _mastersSessionController = TextEditingController();
  final _mastersYearController = TextEditingController();
  final _mastersInstitutionBatchController = TextEditingController();
  final _mastersSubjectBatchController = TextEditingController();
  
  String _selectedBloodGroup = AppConstants.bloodGroups[0];
  String? _selectedInterestLevel;
  String? _selectedDivision;
  String? _selectedDistrict;
  String? _selectedUpazila;
  String? _selectedInstitution;
  String? _selectedSubject;
  String? _selectedHscCollege;
  String? _selectedHonorsInstitution;
  String? _selectedHonorsSubject;
  String? _selectedMastersInstitution;
  String? _selectedMastersSubject;
  String? _selectedEducationLevel;
  
  final Map<String, List<String>> _locations = {};
  
  // Available options based on selection
  List<String> _availableDistricts = [];
  List<String> _availableUpazilas = [];
  
  @override
  void initState() {
    super.initState();
    
    // Initialize form fields with current user data
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      if (userProvider.isLoggedIn) {
        final user = userProvider.currentUser!;
        _nameController.text = user.name;
        _phoneController.text = user.phone;
        _whatsappController.text = user.whatsapp;
        _occupationController.text = user.occupation;
        _presentAddressController.text = user.presentAddress;
        _permanentAddressController.text = user.permanentAddress;
        _selectedBloodGroup = user.bloodGroup;
        _selectedInterestLevel = user.donationInterestLevel;
        _selectedEducationLevel = user.highestEducationLevel;
        _selectedInstitution = user.institution;
        _selectedSubject = user.subject;
        
        // Lower Class Info
        if (user.lowerClassName != null) {
          _lowerClassNameController.text = user.lowerClassName!;
        }
        if (user.lowerClassSchool != null) {
          _lowerClassSchoolController.text = user.lowerClassSchool!;
        }
        if (user.lowerClassYear != null) {
          _lowerClassYearController.text = user.lowerClassYear!;
        }
        
        // SSC Info
        if (user.sscSchool != null) {
          _sscSchoolController.text = user.sscSchool!;
        }
        if (user.sscYear != null) {
          _sscYearController.text = user.sscYear!;
        }
        if (user.sscSession != null) {
          _sscSessionController.text = user.sscSession!;
        }
        
        // HSC Info
        _selectedHscCollege = user.hscCollege;
        if (user.hscYear != null) {
          _hscYearController.text = user.hscYear!;
        }
        if (user.hscSession != null) {
          _hscSessionController.text = user.hscSession!;
        }
        
        // Honours Info
        _selectedHonorsInstitution = user.honorsInstitution;
        _selectedHonorsSubject = user.honorsSubject;
        if (user.honorsSession != null) {
          _honorsSessionController.text = user.honorsSession!;
        }
        if (user.honorsYear != null) {
          _honorsYearController.text = user.honorsYear!;
        }
        if (user.honorsInstitutionBatch != null) {
          _honorsInstitutionBatchController.text = user.honorsInstitutionBatch!;
        }
        if (user.honorsSubjectBatch != null) {
          _honorsSubjectBatchController.text = user.honorsSubjectBatch!;
        }
        
        // Masters Info
        _selectedMastersInstitution = user.mastersInstitution;
        _selectedMastersSubject = user.mastersSubject;
        if (user.mastersSession != null) {
          _mastersSessionController.text = user.mastersSession!;
        }
        if (user.mastersYear != null) {
          _mastersYearController.text = user.mastersYear!;
        }
        if (user.mastersInstitutionBatch != null) {
          _mastersInstitutionBatchController.text = user.mastersInstitutionBatch!;
        }
        if (user.mastersSubjectBatch != null) {
          _mastersSubjectBatchController.text = user.mastersSubjectBatch!;
        }
        
        if (user.session != null) {
          _sessionController.text = user.session!;
        }
        
        // Initialize locations
        setState(() {
          _locations.clear();
          _locations.addAll(user.locations);
          
          // Set division and get available districts
          if (_locations.containsKey('Division') && _locations['Division']!.isNotEmpty) {
            _selectedDivision = _locations['Division']![0];
            _availableDistricts = AppConstants.districtsByDivision[_selectedDivision] ?? [];
          }
          
          // Set district and get available upazilas
          if (_locations.containsKey('District') && _locations['District']!.isNotEmpty) {
            _selectedDistrict = _locations['District']![0];
            _availableUpazilas = AppConstants.upazilasByDistrict[_selectedDistrict] ?? [];
          }
          
          // Set upazila
          if (_locations.containsKey('Upazila') && _locations['Upazila']!.isNotEmpty) {
            _selectedUpazila = _locations['Upazila']![0];
          }
          
          // Set city and area
          if (_locations.containsKey('City') && _locations['City']!.isNotEmpty) {
            _cityController.text = _locations['City']![0];
          }
          
          if (_locations.containsKey('Area') && _locations['Area']!.isNotEmpty) {
            _areaController.text = _locations['Area']![0];
          }
        });
      }
    });
  }
  
  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _whatsappController.dispose();
    _occupationController.dispose();
    _presentAddressController.dispose();
    _permanentAddressController.dispose();
    _cityController.dispose();
    _areaController.dispose();
    _sessionController.dispose();
    
    _lowerClassNameController.dispose();
    _lowerClassSchoolController.dispose();
    _lowerClassYearController.dispose();
    
    _sscSchoolController.dispose();
    _sscYearController.dispose();
    _sscSessionController.dispose();
    
    _hscYearController.dispose();
    _hscSessionController.dispose();
    
    _honorsSessionController.dispose();
    _honorsYearController.dispose();
    _honorsInstitutionBatchController.dispose();
    _honorsSubjectBatchController.dispose();
    
    _mastersSessionController.dispose();
    _mastersYearController.dispose();
    _mastersInstitutionBatchController.dispose();
    _mastersSubjectBatchController.dispose();
    
    super.dispose();
  }

  Future<void> _updateProfile() async {
    if (!_formKey.currentState!.validate()) return;
    
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    
    // Update locations map
    final locations = <String, List<String>>{
      'Division': _selectedDivision != null ? [_selectedDivision!] : [],
      'District': _selectedDistrict != null ? [_selectedDistrict!] : [],
      'Upazila': _selectedUpazila != null ? [_selectedUpazila!] : [],
      'City': [_cityController.text.trim()],
      'Area': [_areaController.text.trim()],
    };
    
    final success = await userProvider.updateUserProfile(
      name: _nameController.text.trim(),
      bloodGroup: _selectedBloodGroup,
      phone: _phoneController.text.trim(),
      whatsapp: _whatsappController.text.trim(),
      occupation: _occupationController.text.trim(),
      institution: _selectedInstitution ?? '',
      presentAddress: _presentAddressController.text.trim(),
      permanentAddress: _permanentAddressController.text.trim(),
      locations: locations,
      subject: _selectedSubject,
      session: _sessionController.text.trim(),
      donationInterestLevel: _selectedInterestLevel,
      highestEducationLevel: _selectedEducationLevel,
      
      // Lower Class Information
      lowerClassName: _lowerClassNameController.text.trim(),
      lowerClassSchool: _lowerClassSchoolController.text.trim(),
      lowerClassYear: _lowerClassYearController.text.trim(),
      
      // SSC Information
      sscSchool: _sscSchoolController.text.trim(),
      sscYear: _sscYearController.text.trim(),
      sscSession: _sscSessionController.text.trim(),
      
      // HSC Information
      hscCollege: _selectedHscCollege,
      hscYear: _hscYearController.text.trim(),
      hscSession: _hscSessionController.text.trim(),
      
      // Honours Information
      honorsInstitution: _selectedHonorsInstitution,
      honorsSubject: _selectedHonorsSubject,
      honorsSession: _honorsSessionController.text.trim(),
      honorsYear: _honorsYearController.text.trim(),
      honorsInstitutionBatch: _honorsInstitutionBatchController.text.trim(),
      honorsSubjectBatch: _honorsSubjectBatchController.text.trim(),
      
      // Masters Information
      mastersInstitution: _selectedMastersInstitution,
      mastersSubject: _selectedMastersSubject,
      mastersSession: _mastersSessionController.text.trim(),
      mastersYear: _mastersYearController.text.trim(),
      mastersInstitutionBatch: _mastersInstitutionBatchController.text.trim(),
      mastersSubjectBatch: _mastersSubjectBatchController.text.trim(),
    );
    
    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Profile updated successfully'),
        ),
      );
      Navigator.of(context).pop();
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to update profile: ${userProvider.error}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    
    return Scaffold(
      backgroundColor: AppConstants.backgroundColor,
      appBar: AppBar(
        title: const Text('Edit Profile'),
        backgroundColor: AppConstants.primaryColor,
        elevation: 0,
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Personal Information
              const Text(
                'Personal Information',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppConstants.textColor,
                ),
              ),
              const SizedBox(height: 16),
              CustomTextField(
                label: 'Full Name',
                hint: 'Enter your full name',
                controller: _nameController,
                textCapitalization: TextCapitalization.words,
                prefixIcon: Icons.person_outline,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              
              // Blood Group Selection
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Blood Group',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: AppConstants.textColor,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        isExpanded: true,
                        value: _selectedBloodGroup,
                        items: AppConstants.bloodGroups.map((String group) {
                          return DropdownMenuItem<String>(
                            value: group,
                            child: Text(group),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          if (newValue != null) {
                            setState(() {
                              _selectedBloodGroup = newValue;
                            });
                          }
                        },
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              
              // Donation Interest Level
              CustomDropdown(
                label: 'Donation Interest Level',
                hint: 'Select your interest level',
                value: _selectedInterestLevel,
                items: AppConstants.interestLevels,
                onChanged: (value) {
                  setState(() {
                    _selectedInterestLevel = value;
                  });
                },
              ),
              const SizedBox(height: 16),
              
              // Highest Education Level
              CustomDropdown(
                label: 'Highest Education Level',
                hint: 'Select your highest education',
                value: _selectedEducationLevel,
                items: AppConstants.educationLevels,
                onChanged: (value) {
                  setState(() {
                    _selectedEducationLevel = value;
                  });
                },
              ),
              const SizedBox(height: 16),
              
              CustomTextField(
                label: 'Phone Number',
                hint: 'Enter your phone number',
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                prefixIcon: Icons.phone_outlined,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your phone number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              
              CustomTextField(
                label: 'WhatsApp Number',
                hint: 'Enter your WhatsApp number',
                controller: _whatsappController,
                keyboardType: TextInputType.phone,
                prefixIcon: Icons.message_outlined,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your WhatsApp number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              
              // Professional Information
              const Text(
                'Professional Information',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppConstants.textColor,
                ),
              ),
              const SizedBox(height: 16),
              
              CustomTextField(
                label: 'Occupation',
                hint: 'Enter your occupation',
                controller: _occupationController,
                textCapitalization: TextCapitalization.words,
                prefixIcon: Icons.work_outline,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your occupation';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              
              SearchableDropdown(
                label: 'Institution',
                hint: 'Search for your institution',
                value: _selectedInstitution,
                items: AppConstants.educationalInstitutions,
                onChanged: (value) {
                  setState(() {
                    _selectedInstitution = value;
                  });
                },
                isRequired: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select your institution';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              
              SearchableDropdown(
                label: 'Subject/Department',
                hint: 'Search for your subject',
                value: _selectedSubject,
                items: AppConstants.academicSubjects,
                onChanged: (value) {
                  setState(() {
                    _selectedSubject = value;
                  });
                },
              ),
              const SizedBox(height: 16),
              
              Row(
                children: [
                  Expanded(
                    child: CustomTextField(
                      label: 'Session',
                      hint: 'e.g., 2018-19',
                      controller: _sessionController,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              
              // Lower Class Information
              if (_selectedEducationLevel == 'Lower Class' || 
                  AppConstants.educationLevels.indexOf(_selectedEducationLevel ?? '') > 
                  AppConstants.educationLevels.indexOf('Lower Class'))
              ...[
                const Text(
                  'Earlier Education',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppConstants.textColor,
                  ),
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  label: 'Class Name',
                  hint: 'e.g., Class 9',
                  controller: _lowerClassNameController,
                  textCapitalization: TextCapitalization.words,
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  label: 'School Name',
                  hint: 'Enter school name',
                  controller: _lowerClassSchoolController,
                  textCapitalization: TextCapitalization.words,
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  label: 'Year',
                  hint: 'e.g., 2015',
                  controller: _lowerClassYearController,
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 24),
              ],
              
              // SSC Information
              if (_selectedEducationLevel == 'SSC' || 
                  AppConstants.educationLevels.indexOf(_selectedEducationLevel ?? '') > 
                  AppConstants.educationLevels.indexOf('SSC'))
              ...[
                const Text(
                  'SSC Information',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppConstants.textColor,
                  ),
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  label: 'SSC School',
                  hint: 'Enter school name',
                  controller: _sscSchoolController,
                  textCapitalization: TextCapitalization.words,
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: CustomTextField(
                        label: 'Session',
                        hint: 'e.g., 2016-17',
                        controller: _sscSessionController,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: CustomTextField(
                        label: 'Year',
                        hint: 'e.g., 2017',
                        controller: _sscYearController,
                        keyboardType: TextInputType.number,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
              ],
              
              // HSC Information
              if (_selectedEducationLevel == 'HSC' || 
                  AppConstants.educationLevels.indexOf(_selectedEducationLevel ?? '') > 
                  AppConstants.educationLevels.indexOf('HSC'))
              ...[
                const Text(
                  'HSC Information',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppConstants.textColor,
                  ),
                ),
                const SizedBox(height: 16),
                SearchableDropdown(
                  label: 'College',
                  hint: 'Search for your college',
                  value: _selectedHscCollege,
                  items: AppConstants.educationalInstitutions,
                  onChanged: (value) {
                    setState(() {
                      _selectedHscCollege = value;
                    });
                  },
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: CustomTextField(
                        label: 'Session',
                        hint: 'e.g., 2018-19',
                        controller: _hscSessionController,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: CustomTextField(
                        label: 'Year',
                        hint: 'e.g., 2019',
                        controller: _hscYearController,
                        keyboardType: TextInputType.number,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
              ],
              
              // Honours Information
              if (_selectedEducationLevel == 'Honours' || 
                  AppConstants.educationLevels.indexOf(_selectedEducationLevel ?? '') > 
                  AppConstants.educationLevels.indexOf('Honours'))
              ...[
                const Text(
                  'Honours Information',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppConstants.textColor,
                  ),
                ),
                const SizedBox(height: 16),
                SearchableDropdown(
                  label: 'Institution',
                  hint: 'Search for your institution',
                  value: _selectedHonorsInstitution,
                  items: AppConstants.educationalInstitutions,
                  onChanged: (value) {
                    setState(() {
                      _selectedHonorsInstitution = value;
                    });
                  },
                ),
                const SizedBox(height: 16),
                SearchableDropdown(
                  label: 'Subject',
                  hint: 'Search for your subject',
                  value: _selectedHonorsSubject,
                  items: AppConstants.academicSubjects,
                  onChanged: (value) {
                    setState(() {
                      _selectedHonorsSubject = value;
                    });
                  },
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: CustomTextField(
                        label: 'Session',
                        hint: 'e.g., 2019-23',
                        controller: _honorsSessionController,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: CustomTextField(
                        label: 'Year',
                        hint: 'e.g., 2023',
                        controller: _honorsYearController,
                        keyboardType: TextInputType.number,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: CustomTextField(
                        label: 'Institution Batch',
                        hint: 'Enter batch number',
                        controller: _honorsInstitutionBatchController,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: CustomTextField(
                        label: 'Subject Batch',
                        hint: 'Enter batch number',
                        controller: _honorsSubjectBatchController,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
              ],
              
              // Masters Information
              if (_selectedEducationLevel == 'Masters' || 
                  AppConstants.educationLevels.indexOf(_selectedEducationLevel ?? '') > 
                  AppConstants.educationLevels.indexOf('Masters'))
              ...[
                const Text(
                  'Masters Information',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppConstants.textColor,
                  ),
                ),
                const SizedBox(height: 16),
                SearchableDropdown(
                  label: 'Institution',
                  hint: 'Search for your institution',
                  value: _selectedMastersInstitution,
                  items: AppConstants.educationalInstitutions,
                  onChanged: (value) {
                    setState(() {
                      _selectedMastersInstitution = value;
                    });
                  },
                ),
                const SizedBox(height: 16),
                SearchableDropdown(
                  label: 'Subject',
                  hint: 'Search for your subject',
                  value: _selectedMastersSubject,
                  items: AppConstants.academicSubjects,
                  onChanged: (value) {
                    setState(() {
                      _selectedMastersSubject = value;
                    });
                  },
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: CustomTextField(
                        label: 'Session',
                        hint: 'e.g., 2023-24',
                        controller: _mastersSessionController,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: CustomTextField(
                        label: 'Year',
                        hint: 'e.g., 2024',
                        controller: _mastersYearController,
                        keyboardType: TextInputType.number,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: CustomTextField(
                        label: 'Institution Batch',
                        hint: 'Enter batch number',
                        controller: _mastersInstitutionBatchController,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: CustomTextField(
                        label: 'Subject Batch',
                        hint: 'Enter batch number',
                        controller: _mastersSubjectBatchController,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
              ],
              
              // Address Information
              const Text(
                'Address Information',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppConstants.textColor,
                ),
              ),
              const SizedBox(height: 16),
              CustomTextField(
                label: 'Present Address',
                hint: 'Enter your present address',
                controller: _presentAddressController,
                textCapitalization: TextCapitalization.sentences,
                prefixIcon: Icons.location_on_outlined,
                maxLines: 2,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your present address';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              CustomTextField(
                label: 'Permanent Address',
                hint: 'Enter your permanent address',
                controller: _permanentAddressController,
                textCapitalization: TextCapitalization.sentences,
                prefixIcon: Icons.home_outlined,
                maxLines: 2,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your permanent address';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              
              // Location Details
              const Text(
                'Location Details',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppConstants.textColor,
                ),
              ),
              const SizedBox(height: 16),
              CustomDropdown(
                label: 'Division',
                hint: 'Select division',
                value: _selectedDivision,
                items: AppConstants.divisions,
                onChanged: (value) {
                  setState(() {
                    _selectedDivision = value;
                    _selectedDistrict = null;
                    _selectedUpazila = null;
                    _availableUpazilas = [];
                    if (value != null) {
                      _availableDistricts = AppConstants.districtsByDivision[value] ?? [];
                    } else {
                      _availableDistricts = [];
                    }
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select division';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              CustomDropdown(
                label: 'District',
                hint: _selectedDivision == null 
                    ? 'Select division first' 
                    : 'Select district',
                value: _selectedDistrict,
                items: _availableDistricts,
                isEnabled: _selectedDivision != null,
                onChanged: (value) {
                  setState(() {
                    _selectedDistrict = value;
                    _selectedUpazila = null;
                    if (value != null) {
                      _availableUpazilas = AppConstants.upazilasByDistrict[value] ?? [];
                    } else {
                      _availableUpazilas = [];
                    }
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select district';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              CustomDropdown(
                label: 'Upazila',
                hint: _selectedDistrict == null 
                    ? 'Select district first' 
                    : 'Select upazila',
                value: _selectedUpazila,
                items: _availableUpazilas,
                isEnabled: _selectedDistrict != null,
                onChanged: (value) {
                  setState(() {
                    _selectedUpazila = value;
                  });
                },
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: CustomTextField(
                      label: 'City',
                      hint: 'Enter city',
                      controller: _cityController,
                      textCapitalization: TextCapitalization.words,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Required';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: CustomTextField(
                      label: 'Area',
                      hint: 'Enter area',
                      controller: _areaController,
                      textCapitalization: TextCapitalization.words,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Required';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),
              
              // Save Button
              CustomButton(
                text: 'Save Profile',
                onPressed: _updateProfile,
                isLoading: userProvider.isLoading,
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
} 