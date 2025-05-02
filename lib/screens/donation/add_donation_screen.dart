import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../constants/app_constants.dart';
import '../../constants/location_data.dart';
import '../../providers/donation_provider.dart';
import '../../providers/user_provider.dart';
import '../../utils/contact_utils.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/searchable_dropdown.dart';

class AddDonationScreen extends StatefulWidget {
  const AddDonationScreen({Key? key}) : super(key: key);

  @override
  State<AddDonationScreen> createState() => _AddDonationScreenState();
}

class _AddDonationScreenState extends State<AddDonationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _locationController = TextEditingController();
  final _addressController = TextEditingController();
  final _receiverNameController = TextEditingController();
  final _receiverContactController = TextEditingController();
  final _receiverEmailController = TextEditingController();
  final _purposeController = TextEditingController();
  
  String? _selectedDivision;
  String? _selectedDistrict;
  String? _selectedCity;
  String? _selectedUpazila;
  String _selectedBloodGroup = AppConstants.bloodGroups[0];
  DateTime _selectedDate = DateTime.now();
  
  // Lists for dropdowns
  List<String> _districtsList = [];
  List<String> _citiesList = [];
  List<String> _upazilasList = [];
  
  @override
  void dispose() {
    _locationController.dispose();
    _addressController.dispose();
    _receiverNameController.dispose();
    _receiverContactController.dispose();
    _receiverEmailController.dispose();
    _purposeController.dispose();
    super.dispose();
  }

  // Update districts when division changes
  void _onDivisionChanged(String? division) {
    setState(() {
      _selectedDivision = division;
      _selectedDistrict = null;
      _selectedCity = null;
      _selectedUpazila = null;
      
      // Update districts list based on selected division
      _districtsList = division != null 
          ? LocationData.getDistrictsForDivision(division)
          : [];
      
      _citiesList = [];
      _upazilasList = [];
    });
  }

  // Update cities and upazilas when district changes
  void _onDistrictChanged(String? district) {
    setState(() {
      _selectedDistrict = district;
      _selectedCity = null;
      _selectedUpazila = null;
      
      // Update cities and upazilas lists based on selected district
      if (district != null) {
        _citiesList = LocationData.getCitiesForDistrict(district);
        _upazilasList = LocationData.getUpazilasForDistrict(district);
      } else {
        _citiesList = [];
        _upazilasList = [];
      }
    });
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2010),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppConstants.primaryColor,
            ),
          ),
          child: child!,
        );
      },
    );
    
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  // Show contact options for receiver
  void _showReceiverContactOptions() {
    if (_receiverNameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter receiver name first')),
      );
      return;
    }

    final String phoneNumber = _receiverContactController.text.trim();
    final String email = _receiverEmailController.text.trim();
    
    if (phoneNumber.isEmpty && email.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No contact information available')),
      );
      return;
    }
    
    ContactUtils.showContactOptions(
      context,
      contactName: _receiverNameController.text,
      phoneNumber: phoneNumber.isNotEmpty ? phoneNumber : null,
      whatsappNumber: phoneNumber.isNotEmpty ? phoneNumber : null,
      email: email.isNotEmpty ? email : null,
    );
  }

  Future<void> _saveDonation() async {
    if (!_formKey.currentState!.validate()) return;
    
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final donationProvider = Provider.of<DonationProvider>(context, listen: false);
    
    final locationDetails = {
      'Division': _selectedDivision ?? '',
      'District': _selectedDistrict ?? '',
      'City': _selectedCity ?? '',
      'Upazila': _selectedUpazila ?? '',
    };
    
    final success = await donationProvider.addDonation(
      donorId: userProvider.currentUser!.uid,
      location: _locationController.text.trim(),
      address: _addressController.text.trim(),
      receiverName: _receiverNameController.text.trim(),
      receiverContact: _receiverContactController.text.trim(),
      bloodGroup: _selectedBloodGroup,
      purpose: _purposeController.text.trim(),
      donationDate: _selectedDate,
      locationDetails: locationDetails,
      receiverEmail: _receiverEmailController.text.trim(),
    );
    
    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Donation added successfully'),
        ),
      );
      Navigator.of(context).pop();
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to add donation: ${donationProvider.error}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final donationProvider = Provider.of<DonationProvider>(context);
    final dateFormat = DateFormat('MMMM dd, yyyy');
    
    return Scaffold(
      backgroundColor: AppConstants.backgroundColor,
      appBar: AppBar(
        title: const Text('Add Donation'),
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
              // Donation Location Details
              const Text(
                'Donation Details',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppConstants.textColor,
                ),
              ),
              const SizedBox(height: 16),
              CustomTextField(
                label: 'Donation Location',
                hint: 'Enter medical college, hospital, etc.',
                controller: _locationController,
                textCapitalization: TextCapitalization.words,
                prefixIcon: Icons.location_on_outlined,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter donation location';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              CustomTextField(
                label: 'Address',
                hint: 'Enter complete address',
                controller: _addressController,
                textCapitalization: TextCapitalization.sentences,
                prefixIcon: Icons.home_outlined,
                maxLines: 2,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter address';
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

              // Date Selection
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Donation Date',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: AppConstants.textColor,
                    ),
                  ),
                  const SizedBox(height: 8),
                  GestureDetector(
                    onTap: () => _selectDate(context),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.calendar_today, size: 20),
                          const SizedBox(width: 12),
                          Text(
                            dateFormat.format(_selectedDate),
                            style: const TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              CustomTextField(
                label: 'Purpose',
                hint: 'Enter purpose of donation',
                controller: _purposeController,
                textCapitalization: TextCapitalization.sentences,
                prefixIcon: Icons.info_outline,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter purpose';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),

              // Receiver Details
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Receiver Details',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppConstants.textColor,
                    ),
                  ),
                  // Contact Actions Button
                  IconButton(
                    icon: const Icon(Icons.contact_phone),
                    onPressed: _showReceiverContactOptions,
                    tooltip: 'Contact Actions',
                    color: AppConstants.primaryColor,
                  ),
                ],
              ),
              const SizedBox(height: 16),
              CustomTextField(
                label: 'Receiver Name',
                hint: 'Enter receiver\'s name',
                controller: _receiverNameController,
                textCapitalization: TextCapitalization.words,
                prefixIcon: Icons.person_outline,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter receiver name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              CustomTextField(
                label: 'Receiver Contact',
                hint: 'Enter receiver\'s contact number',
                controller: _receiverContactController,
                keyboardType: TextInputType.phone,
                prefixIcon: Icons.phone_outlined,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter receiver contact';
                  }
                  return null;
                },
                suffixIcon: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.phone, size: 20),
                      onPressed: () {
                        if (_receiverContactController.text.isNotEmpty) {
                          ContactUtils.makePhoneCall(_receiverContactController.text);
                        }
                      },
                      color: Colors.green,
                    ),
                    IconButton(
                      icon: const Icon(Icons.whatsapp, size: 20),
                      onPressed: () {
                        if (_receiverContactController.text.isNotEmpty) {
                          ContactUtils.openWhatsApp(_receiverContactController.text);
                        }
                      },
                      color: const Color(0xFF25D366),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              CustomTextField(
                label: 'Receiver Email',
                hint: 'Enter receiver\'s email address',
                controller: _receiverEmailController,
                keyboardType: TextInputType.emailAddress,
                prefixIcon: Icons.email_outlined,
                suffixIcon: IconButton(
                  icon: const Icon(Icons.email, size: 20),
                  onPressed: () {
                    if (_receiverEmailController.text.isNotEmpty) {
                      ContactUtils.sendEmail(_receiverEmailController.text);
                    }
                  },
                  color: Colors.red,
                ),
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
                    child: SearchableDropdown(
                      label: 'Division',
                      hint: 'Select division',
                      value: _selectedDivision,
                      items: LocationData.divisions,
                      onChanged: _onDivisionChanged,
                      isRequired: true,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: SearchableDropdown(
                      label: 'District',
                      hint: 'Select district',
                      value: _selectedDistrict,
                      items: _districtsList,
                      onChanged: _onDistrictChanged,
                      isRequired: true,
                      isEnabled: _selectedDivision != null,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: SearchableDropdown(
                      label: 'City',
                      hint: 'Select city',
                      value: _selectedCity,
                      items: _citiesList,
                      onChanged: (city) => setState(() => _selectedCity = city),
                      isRequired: true,
                      isEnabled: _selectedDistrict != null,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: SearchableDropdown(
                      label: 'Upazila',
                      hint: 'Select upazila',
                      value: _selectedUpazila,
                      items: _upazilasList,
                      onChanged: (upazila) => setState(() => _selectedUpazila = upazila),
                      isRequired: true,
                      isEnabled: _selectedDistrict != null,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),

              // Save Button
              CustomButton(
                text: 'Save Donation',
                onPressed: _saveDonation,
                isLoading: donationProvider.isLoading,
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
} 