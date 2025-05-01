import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../constants/app_constants.dart';
import '../../providers/user_provider.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/custom_dropdown.dart';
import '../home/home_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _whatsappController = TextEditingController();
  final _occupationController = TextEditingController();
  final _institutionController = TextEditingController();
  final _presentAddressController = TextEditingController();
  final _permanentAddressController = TextEditingController();
  
  String _selectedBloodGroup = AppConstants.bloodGroups[0];
  bool _obscurePassword = true;
  int _currentStep = 0;
  
  // Location details
  String? _selectedDivision;
  String? _selectedDistrict;
  String? _selectedUpazila;
  String? _selectedCity;
  final _areaController = TextEditingController();
  
  // Available options based on selection
  List<String> _availableDistricts = [];
  List<String> _availableUpazilas = [];
  List<String> _availableCities = [];
  
  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    _phoneController.dispose();
    _whatsappController.dispose();
    _occupationController.dispose();
    _institutionController.dispose();
    _presentAddressController.dispose();
    _permanentAddressController.dispose();
    _areaController.dispose();
    super.dispose();
  }

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) return;
    
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    
    final Map<String, List<String>> locations = {
      'Division': _selectedDivision != null ? [_selectedDivision!] : [],
      'District': _selectedDistrict != null ? [_selectedDistrict!] : [],
      'Upazila': _selectedUpazila != null ? [_selectedUpazila!] : [],
      'City': _selectedCity != null ? [_selectedCity!] : [],
      'Area': [_areaController.text.trim()],
    };
    
    final success = await userProvider.registerUser(
      email: _emailController.text.trim(),
      password: _passwordController.text,
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
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const HomeScreen()),
      );
    } else if (mounted) {
      // Display error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(userProvider.error),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  bool _validateCurrentStep() {
    if (_currentStep == 0) {
      return _emailController.text.isNotEmpty && 
        _passwordController.text.isNotEmpty && 
        _nameController.text.isNotEmpty && 
        _phoneController.text.isNotEmpty;
    } else if (_currentStep == 1) {
      return _whatsappController.text.isNotEmpty && 
        _occupationController.text.isNotEmpty && 
        _institutionController.text.isNotEmpty;
    } else {
      return _presentAddressController.text.isNotEmpty && 
        _permanentAddressController.text.isNotEmpty && 
        _selectedDivision != null && 
        _selectedDistrict != null &&
        _areaController.text.isNotEmpty;
    }
  }

  void _onStepContinue() {
    if (_currentStep < 2) {
      if (_validateCurrentStep()) {
        setState(() {
          _currentStep += 1;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please fill all the required fields'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } else {
      _register();
    }
  }

  void _onStepCancel() {
    if (_currentStep > 0) {
      setState(() {
        _currentStep -= 1;
      });
    } else {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    
    return Scaffold(
      backgroundColor: AppConstants.backgroundColor,
      appBar: AppBar(
        title: const Text('Register as Donor'),
        backgroundColor: AppConstants.primaryColor,
        elevation: 0,
      ),
      body: Form(
        key: _formKey,
        child: Stepper(
          type: StepperType.vertical,
          currentStep: _currentStep,
          onStepContinue: _onStepContinue,
          onStepCancel: _onStepCancel,
          steps: [
            Step(
              title: const Text('Basic Information'),
              content: Column(
                children: [
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
                  CustomTextField(
                    label: 'Email',
                    hint: 'Enter your email',
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    prefixIcon: Icons.email_outlined,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your email';
                      }
                      if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                        return 'Please enter a valid email';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  CustomTextField(
                    label: 'Password',
                    hint: 'Create a password',
                    controller: _passwordController,
                    obscureText: _obscurePassword,
                    prefixIcon: Icons.lock_outline,
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                        color: Colors.grey,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a password';
                      }
                      if (value.length < 6) {
                        return 'Password must be at least 6 characters';
                      }
                      return null;
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
                ],
              ),
              isActive: _currentStep >= 0,
              state: _currentStep > 0 ? StepState.complete : StepState.indexed,
            ),
            Step(
              title: const Text('Professional Information'),
              content: Column(
                children: [
                  CustomTextField(
                    label: 'WhatsApp Number',
                    hint: 'Enter your WhatsApp number',
                    controller: _whatsappController,
                    keyboardType: TextInputType.phone,
                    prefixIcon: Icons.phone_outlined,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your WhatsApp number';
                      }
                      return null;
                    },
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
                    hint: 'Enter your institution name',
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
                ],
              ),
              isActive: _currentStep >= 1,
              state: _currentStep > 1 ? StepState.complete : StepState.indexed,
            ),
            Step(
              title: const Text('Address Information'),
              content: Column(
                children: [
                  CustomTextField(
                    label: 'Present Address',
                    hint: 'Enter your present address',
                    controller: _presentAddressController,
                    maxLines: 2,
                    textCapitalization: TextCapitalization.sentences,
                    prefixIcon: Icons.location_on_outlined,
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
                    maxLines: 2,
                    textCapitalization: TextCapitalization.sentences,
                    prefixIcon: Icons.home_outlined,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your permanent address';
                      }
                      return null;
                    },
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
                        _selectedCity = null;
                        _availableUpazilas = [];
                        _availableCities = [];
                        if (value != null) {
                          _availableDistricts = AppConstants.districtsByDivision[value] ?? [];
                        } else {
                          _availableDistricts = [];
                        }
                      });
                    },
                    isRequired: true,
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
                        _selectedCity = null;
                        if (value != null) {
                          _availableUpazilas = AppConstants.upazilasByDistrict[value] ?? [];
                          _availableCities = AppConstants.citiesByDistrict[value] ?? [];
                        } else {
                          _availableUpazilas = [];
                          _availableCities = [];
                        }
                      });
                    },
                    isRequired: true,
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
                  CustomDropdown(
                    label: 'City',
                    hint: _selectedDistrict == null 
                        ? 'Select district first' 
                        : 'Select city',
                    value: _selectedCity,
                    items: _availableCities,
                    isEnabled: _selectedDistrict != null,
                    onChanged: (value) {
                      setState(() {
                        _selectedCity = value;
                      });
                    },
                  ),
                  const SizedBox(height: 16),
                  CustomTextField(
                    label: 'Area',
                    hint: 'Enter your area',
                    controller: _areaController,
                    textCapitalization: TextCapitalization.words,
                    prefixIcon: Icons.location_on_outlined,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your area';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 24),
                  CustomButton(
                    text: 'Register',
                    onPressed: _register,
                    isLoading: userProvider.isLoading,
                  ),
                ],
              ),
              isActive: _currentStep >= 2,
              state: StepState.indexed,
            ),
          ],
        ),
      ),
    );
  }
} 