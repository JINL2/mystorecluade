import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:myfinance_improved/shared/themes/toss_spacing.dart';
import 'package:myfinance_improved/shared/widgets/toss/toss_enhanced_text_field.dart';

import 'date_picker_field.dart';
import 'profile_form_section.dart';

/// Personal information section with name, date of birth, and phone fields
class PersonalInfoSection extends StatelessWidget {
  final TextEditingController firstNameController;
  final TextEditingController lastNameController;
  final TextEditingController phoneNumberController;
  final DateTime? selectedDateOfBirth;
  final GlobalKey<FormState> formKey;
  final VoidCallback onDatePickerTap;

  const PersonalInfoSection({
    super.key,
    required this.firstNameController,
    required this.lastNameController,
    required this.phoneNumberController,
    required this.selectedDateOfBirth,
    required this.formKey,
    required this.onDatePickerTap,
  });

  @override
  Widget build(BuildContext context) {
    return ProfileFormSection(
      icon: Icons.person_outline,
      title: 'Personal Information',
      child: Column(
        children: [
          TossEnhancedTextField(
            controller: firstNameController,
            label: 'First Name',
            hintText: 'Enter your first name',
            showKeyboardToolbar: true,
            textInputAction: TextInputAction.next,
            inputFormatters: [
              FilteringTextInputFormatter.deny(RegExp(r'[0-9]')),
              LengthLimitingTextInputFormatter(50),
            ],
            validator: (value) {
              if (value?.trim().isEmpty ?? true) {
                return 'Please enter your first name';
              }
              if (value!.trim().length < 2) {
                return 'First name must be at least 2 characters';
              }
              if (RegExp(r'[0-9]').hasMatch(value)) {
                return 'First name must not contain numbers';
              }
              return null;
            },
          ),
          const SizedBox(height: TossSpacing.space4),
          TossEnhancedTextField(
            controller: lastNameController,
            label: 'Last Name',
            hintText: 'Enter your last name',
            showKeyboardToolbar: true,
            textInputAction: TextInputAction.next,
            inputFormatters: [
              FilteringTextInputFormatter.deny(RegExp(r'[0-9]')),
              LengthLimitingTextInputFormatter(50),
            ],
            validator: (value) {
              if (value?.trim().isEmpty ?? true) {
                return 'Please enter your last name';
              }
              if (value!.trim().length < 2) {
                return 'Last name must be at least 2 characters';
              }
              if (RegExp(r'[0-9]').hasMatch(value)) {
                return 'Last name must not contain numbers';
              }
              return null;
            },
          ),
          const SizedBox(height: TossSpacing.space4),
          DatePickerField(
            selectedDate: selectedDateOfBirth,
            onTap: onDatePickerTap,
          ),
          const SizedBox(height: TossSpacing.space4),
          TossEnhancedTextField(
            controller: phoneNumberController,
            label: 'Phone Number',
            hintText: 'Enter phone number',
            keyboardType: TextInputType.phone,
            showKeyboardToolbar: true,
            textInputAction: TextInputAction.next,
            inputFormatters: [
              // Allow digits, +, -, (, ), and spaces for international formats
              FilteringTextInputFormatter.allow(RegExp(r'[0-9+\-() ]')),
              LengthLimitingTextInputFormatter(20),
            ],
            validator: (value) {
              if (value?.isNotEmpty == true) {
                // Remove all formatting characters to validate
                final digitsOnly = value!.replaceAll(RegExp(r'[^\d+]'), '');

                // Must have at least some digits
                if (digitsOnly.isEmpty) {
                  return 'Phone number must contain digits';
                }

                // International phone numbers: 8-15 digits (most countries)
                // Count only actual digits, not + symbol
                final digitCount = digitsOnly.replaceAll('+', '').length;

                if (digitCount < 8) {
                  return 'Phone number must be at least 8 digits';
                }

                if (digitCount > 15) {
                  return 'Phone number must be at most 15 digits';
                }

                // Valid formats: +XXXXXXXXXXXX, XXXXXXXXXX, (XXX) XXX-XXXX
                final validPattern = RegExp(
                  r'^[\+]?[(]?[0-9]{1,4}[)]?[-\s\.]?[(]?[0-9]{1,4}[)]?[-\s\.]?[0-9]{1,9}$',
                );
                if (!validPattern.hasMatch(value)) {
                  return 'Invalid phone number format';
                }
              }
              return null;
            },
            onChanged: (value) {
              // Real-time validation
              if (value.isNotEmpty) {
                Future.delayed(const Duration(milliseconds: 300), () {
                  formKey.currentState?.validate();
                });
              }
            },
          ),
        ],
      ),
    );
  }
}
