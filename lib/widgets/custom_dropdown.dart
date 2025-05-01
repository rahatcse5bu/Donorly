import 'package:flutter/material.dart';
import '../constants/app_constants.dart';

class CustomDropdown extends StatelessWidget {
  final String label;
  final String? hint;
  final String? value;
  final List<String> items;
  final Function(String?) onChanged;
  final bool isRequired;
  final bool isEnabled;
  final String? Function(String?)? validator;

  const CustomDropdown({
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
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: AppConstants.textColor,
              ),
            ),
            if (isRequired)
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
        DropdownButtonFormField<String>(
          value: value,
          hint: Text(hint ?? 'Select $label'),
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
            fillColor: isEnabled ? Colors.white : Colors.grey.shade100,
            disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
          ),
          validator: validator ?? (isRequired 
              ? (value) => value == null || value.isEmpty 
                  ? 'Please select $label' 
                  : null
              : null),
          icon: Icon(
            Icons.arrow_drop_down, 
            color: isEnabled ? AppConstants.primaryColor : Colors.grey,
          ),
          isExpanded: true,
          items: items.isEmpty && !isEnabled
              ? [DropdownMenuItem<String>(value: '', child: Text(hint ?? ''))]
              : items.map((String item) {
                  return DropdownMenuItem<String>(
                    value: item,
                    child: Text(item),
                  );
                }).toList(),
          onChanged: isEnabled ? onChanged : null,
        ),
      ],
    );
  }
} 