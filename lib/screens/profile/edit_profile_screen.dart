import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../constants/app_constants.dart';
import '../../models/user_model.dart';
import '../../providers/user_provider.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_text_field.dart';

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
  final _institutionController = TextEditingController();
  final _presentAddressController = TextEditingController();
  final _permanentAddressController = TextEditingController();
  final _divisionController = TextEditingController();
  final _districtController = TextEditingController();
  final _cityController = TextEditingController();
  final _areaController = TextEditingController();
  
  String _selectedBloodGroup = AppConstants.bloodGroups[0];
  final Map<String, List<String>> _locations = {};
  
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
        _institutionController.text = user.institution;
        _presentAddressController.text = user.presentAddress;
        _permanentAddressController.text = user.permanentAddress;
        _selectedBloodGroup = user.bloodGroup;
        
        // Initialize locations
        setState(() {
          _locations.clear();
          _locations.addAll(user.locations);
        });
        
        // Attempt to populate location controllers if available
        if (_locations.containsKey('Division') && _locations['Division']!.isNotEmpty) {
          _divisionController.text = _locations['Division']![0];
        }
        if (_locations.containsKey('District') && _locations['District']!.isNotEmpty) {
          _districtController.text = _locations['District']![0];
        }
        if (_locations.containsKey('City') && _locations['City']!.isNotEmpty) {
          _cityController.text = _locations['City']![0];
        }
        if (_locations.containsKey('Area') && _locations['Area']!.isNotEmpty) {
          _areaController.text = _locations['Area']![0];
        }
      }
    });
  }
  
  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _whatsappController.dispose();
    _occupationController.dispose();
    _institutionController.dispose();
    _presentAddressController.dispose();
    _permanentAddressController.dispose();
    _divisionController.dispose();
    _districtController.dispose();
    _cityController.dispose();
    _areaController.dispose();
    super.dispose();
  }

  Future<void> _updateProfile() async {
    if (!_formKey.currentState!.validate()) return;
    
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    
    // Update locations map
    final locations = {
      'Division': [_divisionController.text.trim()],
      'District': [_districtController.text.trim()],
      'City': [_cityController.text.trim()],
      'Area': [_areaController.text.trim()],
    };
    
    final success = await userProvider.updateUserProfile(
      name: _nameController.text.trim(),
      bloodGroup: _selectedBloodGroup,
      phone: _phoneController.text.trim(),
      whatsapp: _whatsappController.text.trim(),
      occupation: _occupationController.text.trim(),
      institution: _institutionController.text.trim(),
      presentAddress: _presentAddressController.text.trim(),
      permanentAddress: _permanentAddressController.text.trim(),
      locations: locations,
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
              
              CustomTextField(
                label: 'Institution',
                hint: 'Enter your institution/workplace',
                controller: _institutionController,
                textCapitalization: TextCapitalization.words,
                prefixIcon: Icons.business_outlined,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your institution';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              
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
              Row(
                children: [
                  Expanded(
                    child: CustomTextField(
                      label: 'Division',
                      hint: 'Enter division',
                      controller: _divisionController,
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
                      label: 'District',
                      hint: 'Enter district',
                      controller: _districtController,
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