import 'package:flutter/material.dart';
import '../constants/app_constants.dart';

class SearchableDropdown extends StatefulWidget {
  final String label;
  final String? hint;
  final String? value;
  final List<String> items;
  final Function(String?) onChanged;
  final bool isRequired;
  final bool isEnabled;
  final String? Function(String?)? validator;

  const SearchableDropdown({
    Key? key,
    required this.label,
    this.hint,
    this.value,
    required this.items,
    required this.onChanged,
    this.isRequired = false,
    this.isEnabled = true,
    this.validator,
  }) : super(key: key);

  @override
  State<SearchableDropdown> createState() => _SearchableDropdownState();
}

class _SearchableDropdownState extends State<SearchableDropdown> {
  final TextEditingController _searchController = TextEditingController();
  List<String> _filteredItems = [];
  bool _isDropdownOpen = false;
  final FocusNode _focusNode = FocusNode();
  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;
  
  @override
  void initState() {
    super.initState();
    _filteredItems = widget.items;
    
    _focusNode.addListener(() {
      if (_focusNode.hasFocus) {
        _showOverlay();
      } else {
        _hideOverlay();
      }
    });
  }
  
  @override
  void dispose() {
    _searchController.dispose();
    _focusNode.dispose();
    _hideOverlay();
    super.dispose();
  }
  
  void _filterItems(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredItems = widget.items;
      } else {
        _filteredItems = widget.items
            .where((item) => item.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
      
      if (_overlayEntry != null) {
        _overlayEntry!.markNeedsBuild();
      }
    });
  }
  
  void _showOverlay() {
    final RenderBox renderBox = context.findRenderObject() as RenderBox;
    final size = renderBox.size;
    
    _overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        width: size.width,
        child: CompositedTransformFollower(
          link: _layerLink,
          showWhenUnlinked: false,
          offset: Offset(0, size.height + 5),
          child: Material(
            elevation: 4,
            borderRadius: BorderRadius.circular(8),
            child: Container(
              constraints: BoxConstraints(
                maxHeight: 300,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: _filteredItems.isEmpty
                  ? const Padding(
                      padding: EdgeInsets.all(12),
                      child: Text('No results found'),
                    )
                  : ListView.builder(
                      shrinkWrap: true,
                      itemCount: _filteredItems.length,
                      itemBuilder: (context, index) {
                        final item = _filteredItems[index];
                        final isSelected = widget.value == item;
                        return ListTile(
                          title: Text(
                            item,
                            style: TextStyle(
                              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                              color: isSelected 
                                  ? AppConstants.primaryColor 
                                  : AppConstants.textColor,
                            ),
                          ),
                          tileColor: isSelected ? Colors.grey.shade100 : Colors.white,
                          dense: true,
                          onTap: () {
                            widget.onChanged(item);
                            _searchController.text = item;
                            _hideOverlay();
                            FocusScope.of(context).unfocus();
                          },
                        );
                      },
                    ),
            ),
          ),
        ),
      ),
    );
    
    Overlay.of(context).insert(_overlayEntry!);
    setState(() {
      _isDropdownOpen = true;
    });
  }
  
  void _hideOverlay() {
    if (_overlayEntry != null) {
      _overlayEntry!.remove();
      _overlayEntry = null;
    }
    setState(() {
      _isDropdownOpen = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Initialize search controller with current value if needed
    if (widget.value != null && widget.value!.isNotEmpty && _searchController.text.isEmpty) {
      _searchController.text = widget.value!;
    }
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              widget.label,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: AppConstants.textColor,
              ),
            ),
            if (widget.isRequired)
              const Text(
                ' *',
                style: TextStyle(
                  color: AppConstants.primaryColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
          ],
        ),
        const SizedBox(height: 8),
        CompositedTransformTarget(
          link: _layerLink,
          child: TextFormField(
            controller: _searchController,
            focusNode: _focusNode,
            enabled: widget.isEnabled,
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: AppConstants.primaryColor),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Colors.red),
              ),
              filled: true,
              fillColor: widget.isEnabled ? Colors.white : Colors.grey.shade100,
              disabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              hintText: widget.hint ?? 'Select ${widget.label}',
              suffixIcon: Icon(
                _isDropdownOpen ? Icons.arrow_drop_up : Icons.arrow_drop_down,
                color: widget.isEnabled ? AppConstants.primaryColor : Colors.grey,
              ),
            ),
            onChanged: (value) => _filterItems(value),
            validator: widget.validator ?? (widget.isRequired 
                ? (value) => value == null || value.isEmpty 
                    ? 'Please select ${widget.label}' 
                    : null
                : null),
          ),
        ),
      ],
    );
  }
} 