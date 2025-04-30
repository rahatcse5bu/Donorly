import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../constants/app_constants.dart';
import '../../models/user_model.dart';
import '../../providers/donation_provider.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/donor_card.dart';
import 'donor_details_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _formKey = GlobalKey<FormState>();
  final _divisionController = TextEditingController();
  final _districtController = TextEditingController();
  final _cityController = TextEditingController();
  final _areaController = TextEditingController();
  final _institutionController = TextEditingController();
  
  String _selectedBloodGroup = '';
  String _selectedSearchCategory = AppConstants.searchCategories[0];
  bool _isSearching = false;
  
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
    _divisionController.dispose();
    _districtController.dispose();
    _cityController.dispose();
    _areaController.dispose();
    _institutionController.dispose();
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
        division: _divisionController.text.trim(),
        district: _districtController.text.trim(),
        city: _cityController.text.trim(),
        area: _areaController.text.trim(),
        bloodGroup: _selectedBloodGroup,
        institution: _institutionController.text.trim(),
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
    _divisionController.clear();
    _districtController.clear();
    _cityController.clear();
    _areaController.clear();
    _institutionController.clear();
    setState(() {
      _selectedBloodGroup = '';
    });
    
    Provider.of<DonationProvider>(context, listen: false).clearSearchResults();
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
              // Search Form
              Form(
                key: _formKey,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Find Blood Donors',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: AppConstants.textColor,
                        ),
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
                          SizedBox(
                            height: 40,
                            child: ListView(
                              scrollDirection: Axis.horizontal,
                              children: [
                                _buildBloodGroupChip(''),
                                ...AppConstants.bloodGroups.map(_buildBloodGroupChip).toList(),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      
                      // Location Search
                      Row(
                        children: [
                          Expanded(
                            child: CustomTextField(
                              label: 'Division',
                              hint: 'Enter division',
                              controller: _divisionController,
                              textCapitalization: TextCapitalization.words,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: CustomTextField(
                              label: 'District',
                              hint: 'Enter district',
                              controller: _districtController,
                              textCapitalization: TextCapitalization.words,
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
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: CustomTextField(
                              label: 'Area',
                              hint: 'Enter area',
                              controller: _areaController,
                              textCapitalization: TextCapitalization.words,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      CustomTextField(
                        label: 'Institution',
                        hint: 'Enter institution name',
                        controller: _institutionController,
                        textCapitalization: TextCapitalization.words,
                      ),
                      const SizedBox(height: 24),
                      
                      // Action Buttons
                      Row(
                        children: [
                          Expanded(
                            child: CustomButton(
                              text: 'Search',
                              onPressed: _search,
                              isLoading: _isSearching,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: CustomButton(
                              text: 'Clear',
                              onPressed: _clearSearch,
                              isOutlined: true,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              
              // Results Count
              if (searchResults.isNotEmpty || donationProvider.isLoading)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: Text(
                    donationProvider.isLoading
                        ? 'Searching...'
                        : '${searchResults.length} donors found',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: AppConstants.subtitleColor,
                    ),
                  ),
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
    );
  }

  Widget _buildBloodGroupChip(String bloodGroup) {
    final isSelected = _selectedBloodGroup == bloodGroup;
    final displayText = bloodGroup.isEmpty ? 'All' : bloodGroup;
    
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: ChoiceChip(
        label: Text(displayText),
        selected: isSelected,
        onSelected: (selected) {
          setState(() {
            _selectedBloodGroup = selected ? bloodGroup : '';
          });
        },
        backgroundColor: Colors.grey.shade200,
        selectedColor: AppConstants.primaryColor.withOpacity(0.2),
        labelStyle: TextStyle(
          color: isSelected ? AppConstants.primaryColor : Colors.black,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    );
  }
} 