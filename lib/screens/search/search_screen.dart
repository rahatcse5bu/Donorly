import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../constants/app_constants.dart';
import '../../models/user_model.dart';
import '../../providers/donation_provider.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/custom_dropdown.dart';
import '../../widgets/searchable_dropdown.dart';
import '../../widgets/donor_card.dart';
import 'donor_details_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _formKey = GlobalKey<FormState>();
  
  // Location controllers
  String? _selectedDivision;
  String? _selectedDistrict;
  String? _selectedUpazila;
  final _cityController = TextEditingController();
  final _areaController = TextEditingController();
  
  // Education controllers
  String? _selectedInstitution;
  String? _selectedSubject;
  final _batchNumberController = TextEditingController();
  final _sessionController = TextEditingController();
  
  // HSC controllers
  String? _selectedHscCollege;
  final _hscSessionController = TextEditingController();
  final _hscYearController = TextEditingController();
  
  // Honours controllers
  String? _selectedHonorsInstitution;
  String? _selectedHonorsSubject;
  final _honorsSessionController = TextEditingController();
  final _honorsYearController = TextEditingController();
  final _honorsInstitutionBatchController = TextEditingController();
  final _honorsSubjectBatchController = TextEditingController();
  
  // Masters controllers
  String? _selectedMastersInstitution;
  String? _selectedMastersSubject;
  final _mastersSessionController = TextEditingController();
  final _mastersYearController = TextEditingController();
  final _mastersInstitutionBatchController = TextEditingController();
  final _mastersSubjectBatchController = TextEditingController();
  
  // Donation area preferences
  String? _selectedDonationDivision;
  String? _selectedDonationDistrict;
  String? _selectedDonationUpazila;
  final _donationCityController = TextEditingController();
  final _donationAreaController = TextEditingController();
  
  String _selectedBloodGroup = '';
  String? _selectedInterestLevel;
  bool _isSearching = false;
  
  // Available options based on selection
  List<String> _availableDistricts = [];
  List<String> _availableUpazilas = [];
  List<String> _availableDonationDistricts = [];
  List<String> _availableDonationUpazilas = [];
  
  @override
  void initState() {
    super.initState();
    // Clear previous search results
    Future.microtask(() {
      Provider.of<DonationProvider>(context, listen: false).clearSearchResults();
    });
  }
  
  @override
  void dispose() {
    _cityController.dispose();
    _areaController.dispose();
    _batchNumberController.dispose();
    _sessionController.dispose();
    _hscSessionController.dispose();
    _hscYearController.dispose();
    _honorsSessionController.dispose();
    _honorsYearController.dispose();
    _honorsInstitutionBatchController.dispose();
    _honorsSubjectBatchController.dispose();
    _mastersSessionController.dispose();
    _mastersYearController.dispose();
    _mastersInstitutionBatchController.dispose();
    _mastersSubjectBatchController.dispose();
    _donationCityController.dispose();
    _donationAreaController.dispose();
    super.dispose();
  }

  void _search() async {
    if (!_formKey.currentState!.validate()) return;
    
    setState(() {
      _isSearching = true;
    });
    
    final donationProvider = Provider.of<DonationProvider>(context, listen: false);
    
    try {
      await donationProvider.searchDonors(
        division: _selectedDivision,
        district: _selectedDistrict,
        city: _cityController.text.trim(),
        area: _areaController.text.trim(),
        upazila: _selectedUpazila,
        bloodGroup: _selectedBloodGroup,
        institution: _selectedInstitution,
        subject: _selectedSubject,
        batchNumber: _batchNumberController.text.trim(),
        session: _sessionController.text.trim(),
        hscSession: _hscSessionController.text.trim(),
        donationInterestLevel: _selectedInterestLevel,
        hscCollege: _selectedHscCollege,
        hscYear: _hscYearController.text.trim(),
        honorsInstitution: _selectedHonorsInstitution,
        honorsSubject: _selectedHonorsSubject,
        honorsSession: _honorsSessionController.text.trim(),
        honorsYear: _honorsYearController.text.trim(),
        honorsInstitutionBatch: _honorsInstitutionBatchController.text.trim(),
        honorsSubjectBatch: _honorsSubjectBatchController.text.trim(),
        mastersInstitution: _selectedMastersInstitution,
        mastersSubject: _selectedMastersSubject,
        mastersSession: _mastersSessionController.text.trim(),
        mastersYear: _mastersYearController.text.trim(),
        mastersInstitutionBatch: _mastersInstitutionBatchController.text.trim(),
        mastersSubjectBatch: _mastersSubjectBatchController.text.trim(),
        donationAreaPreferences: _selectedDonationDivision != null
          ? {
              'division': [_selectedDonationDivision!],
              if (_selectedDonationDistrict != null) 'district': [_selectedDonationDistrict!],
              if (_selectedDonationUpazila != null) 'upazila': [_selectedDonationUpazila!],
              if (_donationCityController.text.isNotEmpty) 'city': [_donationCityController.text.trim()],
              if (_donationAreaController.text.isNotEmpty) 'area': [_donationAreaController.text.trim()],
            }
          : null,
      );
    } finally {
      if (mounted) {
        setState(() {
          _isSearching = false;
        });
      }
    }
  }

  void _clearSearch() {
    _selectedDivision = null;
    _selectedDistrict = null;
    _selectedUpazila = null;
    _cityController.clear();
    _areaController.clear();
    _selectedInstitution = null;
    _selectedSubject = null;
    _batchNumberController.clear();
    _sessionController.clear();
    _hscSessionController.clear();
    _selectedInterestLevel = null;
    _selectedHscCollege = null;
    _hscYearController.clear();
    _selectedHonorsInstitution = null;
    _selectedHonorsSubject = null;
    _honorsSessionController.clear();
    _honorsYearController.clear();
    _honorsInstitutionBatchController.clear();
    _honorsSubjectBatchController.clear();
    _selectedMastersInstitution = null;
    _selectedMastersSubject = null;
    _mastersSessionController.clear();
    _mastersYearController.clear();
    _mastersInstitutionBatchController.clear();
    _mastersSubjectBatchController.clear();
    _selectedDonationDivision = null;
    _selectedDonationDistrict = null;
    _selectedDonationUpazila = null;
    _donationCityController.clear();
    _donationAreaController.clear();
    
    setState(() {
      _selectedBloodGroup = '';
      _availableDistricts = [];
      _availableUpazilas = [];
      _availableDonationDistricts = [];
      _availableDonationUpazilas = [];
    });
    
    Provider.of<DonationProvider>(context, listen: false).clearSearchResults();
  }
  
  void _showSearchModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _buildSearchModal(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final donationProvider = Provider.of<DonationProvider>(context);
    final searchResults = donationProvider.searchResults;
    
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Title
              const Text(
                'Find Blood Donors',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppConstants.textColor,
                ),
              ),
              const SizedBox(height: 16),
              
              // Search Button
              CustomButton(
                text: 'Open Search',
                onPressed: _showSearchModal,
                icon: Icons.search,
              ),
              
              const SizedBox(height: 24),
              
              // Results Display
              if (searchResults.isNotEmpty || donationProvider.isLoading)
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    decoration: BoxDecoration(
                      border: Border(
                        top: BorderSide(color: Colors.grey.shade300),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              donationProvider.isLoading
                                  ? 'Searching...'
                                  : '${searchResults.length} donors found',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: AppConstants.subtitleColor,
                              ),
                            ),
                            if (searchResults.isNotEmpty && !donationProvider.isLoading)
                              IconButton(
                                icon: const Icon(Icons.close, size: 20),
                                onPressed: () {
                                  Provider.of<DonationProvider>(context, listen: false).clearSearchResults();
                                },
                                padding: EdgeInsets.zero,
                                constraints: const BoxConstraints(),
                              ),
                          ],
                        ),
                        
                        // Results List
                        Expanded(
                          child: donationProvider.isLoading
                              ? const Center(child: CircularProgressIndicator())
                              : searchResults.isEmpty
                                  ? const Center(
                                      child: Text(
                                        'No donors found. Try different search criteria.',
                                        style: TextStyle(color: AppConstants.subtitleColor),
                                        textAlign: TextAlign.center,
                                      ),
                                    )
                                  : ListView.builder(
                                      itemCount: searchResults.length,
                                      itemBuilder: (context, index) {
                                        final donor = searchResults[index];
                                        return DonorCard(
                                          donor: donor,
                                          onTap: () {
                                            Navigator.of(context).push(
                                              MaterialPageRoute(
                                                builder: (_) => DonorDetailsScreen(donor: donor),
                                              ),
                                            );
                                          },
                                        );
                                      },
                                    ),
                        ),
                      ],
                    ),
                  ),
                ),
              
              if (searchResults.isEmpty && !donationProvider.isLoading)
                const Expanded(
                  child: Center(
                    child: Text(
                      'Search for donors using the button above',
                      style: TextStyle(color: AppConstants.subtitleColor),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBloodGroupChip(String bloodGroup, StateSetter setModalState) {
    final isSelected = _selectedBloodGroup == bloodGroup;
    final label = bloodGroup.isEmpty ? 'All' : bloodGroup;
    
    return GestureDetector(
      onTap: () {
        setModalState(() {
          _selectedBloodGroup = bloodGroup;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        margin: const EdgeInsets.only(right: 0, bottom: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppConstants.primaryColor : Colors.transparent,
          border: Border.all(color: AppConstants.primaryColor),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : AppConstants.primaryColor,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }
  
  Widget _buildSearchModal() {
    return StatefulBuilder(
      builder: (context, setModalState) {
        return DraggableScrollableSheet(
          initialChildSize: 0.9,
          minChildSize: 0.5,
          maxChildSize: 0.95,
          builder: (context, scrollController) {
            return Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
              ),
              child: Column(
                children: [
                  // Handle bar
                  Container(
                    width: 40,
                    height: 5,
                    margin: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  
                  // Title and close button
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Search Blood Donors',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppConstants.textColor,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ],
                    ),
                  ),
                  
                  // Search form
                  Expanded(
                    child: Form(
                      key: _formKey,
                      child: ListView(
                        controller: scrollController,
                        padding: const EdgeInsets.all(16),
                        children: [
                          // Blood Group and Interest Level section
                          Row(
                            children: [
                              // Blood Group Column
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Blood Group',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: AppConstants.textColor,
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                    Wrap(
                                      spacing: 8,
                                      runSpacing: 0,
                                      children: [
                                        ...['', ...AppConstants.bloodGroups].map((bg) => 
                                          _buildBloodGroupChip(bg, setModalState)
                                        ).toList(),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              
                              // Interest Level Column
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    CustomDropdown(
                                      label: 'Donation Interest Level',
                                      hint: 'Select level',
                                      value: _selectedInterestLevel,
                                      items: AppConstants.interestLevels,
                                      onChanged: (value) {
                                        setModalState(() {
                                          _selectedInterestLevel = value;
                                        });
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          
                          const SizedBox(height: 24),
                          
                          // Location section
                          _buildSectionHeader('Location'),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              Expanded(
                                child: CustomDropdown(
                                  label: 'Division',
                                  hint: 'Select division',
                                  value: _selectedDivision,
                                  items: AppConstants.divisions,
                                  onChanged: (value) {
                                    setModalState(() {
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
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: CustomDropdown(
                                  label: 'District',
                                  hint: _selectedDivision == null 
                                      ? 'Select division first' 
                                      : 'Select district',
                                  value: _selectedDistrict,
                                  items: _availableDistricts,
                                  isEnabled: _selectedDivision != null,
                                  onChanged: (value) {
                                    setModalState(() {
                                      _selectedDistrict = value;
                                      _selectedUpazila = null;
                                      if (value != null) {
                                        _availableUpazilas = AppConstants.upazilasByDistrict[value] ?? [];
                                      } else {
                                        _availableUpazilas = [];
                                      }
                                    });
                                  },
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              Expanded(
                                child: CustomDropdown(
                                  label: 'Upazila',
                                  hint: _selectedDistrict == null 
                                      ? 'Select district first' 
                                      : 'Select upazila',
                                  value: _selectedUpazila,
                                  items: _availableUpazilas,
                                  isEnabled: _selectedDistrict != null,
                                  onChanged: (value) {
                                    setModalState(() {
                                      _selectedUpazila = value;
                                    });
                                  },
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: CustomTextField(
                                  label: 'City',
                                  hint: 'Enter city',
                                  controller: _cityController,
                                  textCapitalization: TextCapitalization.words,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          CustomTextField(
                            label: 'Area',
                            hint: 'Enter area',
                            controller: _areaController,
                            textCapitalization: TextCapitalization.words,
                          ),
                          
                          const SizedBox(height: 24),
                          
                          // Education section
                          _buildSectionHeader('Education'),
                          const SizedBox(height: 16),
                          SearchableDropdown(
                            label: 'Institution',
                            hint: 'Search institution',
                            value: _selectedInstitution,
                            items: AppConstants.educationalInstitutions,
                            onChanged: (value) {
                              setModalState(() {
                                _selectedInstitution = value;
                              });
                            },
                          ),
                          const SizedBox(height: 16),
                          SearchableDropdown(
                            label: 'Subject/Department',
                            hint: 'Search subject or department',
                            value: _selectedSubject,
                            items: AppConstants.academicSubjects,
                            onChanged: (value) {
                              setModalState(() {
                                _selectedSubject = value;
                              });
                            },
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              Expanded(
                                child: CustomTextField(
                                  label: 'Batch Number',
                                  hint: 'Enter batch number',
                                  controller: _batchNumberController,
                                  keyboardType: TextInputType.number,
                                ),
                              ),
                              const SizedBox(width: 12),
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
                          
                          // HSC Information
                          _buildSectionHeader('HSC Information'),
                          const SizedBox(height: 16),
                          SearchableDropdown(
                            label: 'College',
                            hint: 'Search college',
                            value: _selectedHscCollege,
                            items: AppConstants.educationalInstitutions,
                            onChanged: (value) {
                              setModalState(() {
                                _selectedHscCollege = value;
                              });
                            },
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              Expanded(
                                child: CustomTextField(
                                  label: 'HSC Session',
                                  hint: 'e.g., 2016',
                                  controller: _hscSessionController,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: CustomTextField(
                                  label: 'Year',
                                  hint: 'e.g., 2018',
                                  controller: _hscYearController,
                                  keyboardType: TextInputType.number,
                                ),
                              ),
                            ],
                          ),
                          
                          const SizedBox(height: 24),
                          
                          // Honours Information
                          _buildSectionHeader('Honours Information'),
                          const SizedBox(height: 16),
                          SearchableDropdown(
                            label: 'Institution',
                            hint: 'Search institution',
                            value: _selectedHonorsInstitution,
                            items: AppConstants.educationalInstitutions,
                            onChanged: (value) {
                              setModalState(() {
                                _selectedHonorsInstitution = value;
                              });
                            },
                          ),
                          const SizedBox(height: 16),
                          SearchableDropdown(
                            label: 'Subject',
                            hint: 'Search subject',
                            value: _selectedHonorsSubject,
                            items: AppConstants.academicSubjects,
                            onChanged: (value) {
                              setModalState(() {
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
                                  hint: 'e.g., 2018-22',
                                  controller: _honorsSessionController,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: CustomTextField(
                                  label: 'Year',
                                  hint: 'e.g., 2022',
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
                                  hint: 'Enter batch',
                                  controller: _honorsInstitutionBatchController,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: CustomTextField(
                                  label: 'Subject Batch',
                                  hint: 'Enter batch',
                                  controller: _honorsSubjectBatchController,
                                ),
                              ),
                            ],
                          ),
                          
                          const SizedBox(height: 24),
                          
                          // Masters Information
                          _buildSectionHeader('Masters Information'),
                          const SizedBox(height: 16),
                          SearchableDropdown(
                            label: 'Institution',
                            hint: 'Search institution',
                            value: _selectedMastersInstitution,
                            items: AppConstants.educationalInstitutions,
                            onChanged: (value) {
                              setModalState(() {
                                _selectedMastersInstitution = value;
                              });
                            },
                          ),
                          const SizedBox(height: 16),
                          SearchableDropdown(
                            label: 'Subject',
                            hint: 'Search subject',
                            value: _selectedMastersSubject,
                            items: AppConstants.academicSubjects,
                            onChanged: (value) {
                              setModalState(() {
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
                                  hint: 'e.g., 2022-23',
                                  controller: _mastersSessionController,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: CustomTextField(
                                  label: 'Year',
                                  hint: 'e.g., 2023',
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
                                  hint: 'Enter batch',
                                  controller: _mastersInstitutionBatchController,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: CustomTextField(
                                  label: 'Subject Batch',
                                  hint: 'Enter batch',
                                  controller: _mastersSubjectBatchController,
                                ),
                              ),
                            ],
                          ),
                          
                          const SizedBox(height: 24),
                          
                          // Donation Area Preferences
                          _buildSectionHeader('Donation Area Preferences'),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              Expanded(
                                child: CustomDropdown(
                                  label: 'Division',
                                  hint: 'Select division',
                                  value: _selectedDonationDivision,
                                  items: AppConstants.divisions,
                                  onChanged: (value) {
                                    setModalState(() {
                                      _selectedDonationDivision = value;
                                      _selectedDonationDistrict = null;
                                      _selectedDonationUpazila = null;
                                      _availableDonationUpazilas = [];
                                      if (value != null) {
                                        _availableDonationDistricts = AppConstants.districtsByDivision[value] ?? [];
                                      } else {
                                        _availableDonationDistricts = [];
                                      }
                                    });
                                  },
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: CustomDropdown(
                                  label: 'District',
                                  hint: _selectedDonationDivision == null 
                                      ? 'Select division first' 
                                      : 'Select district',
                                  value: _selectedDonationDistrict,
                                  items: _availableDonationDistricts,
                                  isEnabled: _selectedDonationDivision != null,
                                  onChanged: (value) {
                                    setModalState(() {
                                      _selectedDonationDistrict = value;
                                      _selectedDonationUpazila = null;
                                      if (value != null) {
                                        _availableDonationUpazilas = AppConstants.upazilasByDistrict[value] ?? [];
                                      } else {
                                        _availableDonationUpazilas = [];
                                      }
                                    });
                                  },
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              Expanded(
                                child: CustomDropdown(
                                  label: 'Upazila',
                                  hint: _selectedDonationDistrict == null 
                                      ? 'Select district first' 
                                      : 'Select upazila',
                                  value: _selectedDonationUpazila,
                                  items: _availableDonationUpazilas,
                                  isEnabled: _selectedDonationDistrict != null,
                                  onChanged: (value) {
                                    setModalState(() {
                                      _selectedDonationUpazila = value;
                                    });
                                  },
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: CustomTextField(
                                  label: 'City',
                                  hint: 'Enter city',
                                  controller: _donationCityController,
                                  textCapitalization: TextCapitalization.words,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          CustomTextField(
                            label: 'Area',
                            hint: 'Enter area',
                            controller: _donationAreaController,
                            textCapitalization: TextCapitalization.words,
                          ),
                        ],
                      ),
                    ),
                  ),
                  
                  // Action buttons
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: CustomButton(
                            text: 'Search',
                            onPressed: () {
                              Navigator.pop(context);
                              _search();
                            },
                            isLoading: _isSearching,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: CustomButton(
                            text: 'Clear',
                            onPressed: () {
                              setModalState(() {
                                _clearSearch();
                              });
                            },
                            isOutlined: true,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      }
    );
  }
  
  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: AppConstants.textColor,
      ),
    );
  }
} 