import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:myfinance_improved/shared/themes/toss_animations.dart';
import 'package:myfinance_improved/shared/themes/toss_spacing.dart';

import 'profile_form_section.dart';
import 'text_formatters.dart';
import 'package:myfinance_improved/shared/widgets/index.dart';

/// Bank information section with bank name, account number, and holder name
class BankInfoSection extends StatelessWidget {
  final TextEditingController bankNameController;
  final TextEditingController bankAccountController;
  final TextEditingController bankDescriptionController;
  final GlobalKey<FormState> formKey;

  const BankInfoSection({
    super.key,
    required this.bankNameController,
    required this.bankAccountController,
    required this.bankDescriptionController,
    required this.formKey,
  });

  @override
  Widget build(BuildContext context) {
    return ProfileFormSection(
      icon: Icons.account_balance_outlined,
      title: 'Bank Information',
      child: Column(
        children: [
          TossEnhancedTextField(
            controller: bankNameController,
            label: 'Bank Name',
            hintText: 'Enter your bank name',
            showKeyboardToolbar: true,
            textInputAction: TextInputAction.next,
            inputFormatters: [
              // Allow letters, spaces, hyphens, apostrophes, periods, ampersands, and accented characters
              FilteringTextInputFormatter.allow(RegExp(r"[a-zA-Z\s\-'.&\u00C0-\u017F]")),
              LengthLimitingTextInputFormatter(100),
            ],
            validator: (value) {
              if (value?.isNotEmpty == true) {
                // Must contain at least some letters
                if (!RegExp(r'[a-zA-Z]').hasMatch(value!)) {
                  return 'Bank name must contain letters';
                }

                // Minimum length check
                if (value.trim().length < 2) {
                  return 'Bank name must be at least 2 characters';
                }

                // Check for valid characters only (letters, spaces, and common punctuation)
                if (!RegExp(r"^[a-zA-Z\s\-'.&\u00C0-\u017F]+$").hasMatch(value)) {
                  return 'Invalid characters in bank name';
                }
              }
              return null;
            },
            onChanged: (value) {
              // Real-time validation
              if (value.isNotEmpty) {
                Future.delayed(TossAnimations.slow, () {
                  formKey.currentState?.validate();
                });
              }
            },
          ),
          const SizedBox(height: TossSpacing.space4),
          TossEnhancedTextField(
            controller: bankAccountController,
            label: 'Bank Account Number',
            hintText: 'Digits only (or IBAN starting with letters)',
            keyboardType: TextInputType.text,
            showKeyboardToolbar: true,
            textInputAction: TextInputAction.next,
            inputFormatters: [
              BankAccountFormatter(),
              LengthLimitingTextInputFormatter(34),
            ],
            validator: (value) {
              if (value?.isNotEmpty == true) {
                final cleanValue = value!.replaceAll(' ', '').toUpperCase();

                // International bank account formats:
                // - Pure digits: 8-20 characters (USA, Vietnam, Korea, Japan, etc.)
                // - IBAN: 15-34 alphanumeric (Europe)

                if (cleanValue.length < 8) {
                  return 'Account number must be at least 8 characters';
                }

                if (cleanValue.length > 34) {
                  return 'Account number must be at most 34 characters';
                }

                // Check if it's IBAN format (starts with 2 letters + 2 digits)
                final isIBAN = RegExp(r'^[A-Z]{2}[0-9]{2}[A-Z0-9]+$').hasMatch(cleanValue);
                // Check if it's pure digits (most Asian countries)
                final isDigitsOnly = RegExp(r'^[0-9]+$').hasMatch(cleanValue);
                // Check if it's alphanumeric (some banks)
                final isAlphanumeric = RegExp(r'^[A-Z0-9]+$').hasMatch(cleanValue);

                if (!isIBAN && !isDigitsOnly && !isAlphanumeric) {
                  return 'Invalid account number format';
                }
              }
              return null;
            },
            onChanged: (value) {
              // Real-time validation
              if (value.isNotEmpty) {
                Future.delayed(TossAnimations.slow, () {
                  formKey.currentState?.validate();
                });
              }
            },
          ),
          const SizedBox(height: TossSpacing.space4),
          TossEnhancedTextField(
            controller: bankDescriptionController,
            label: 'Account Holder Name',
            hintText: 'Full name as shown on bank account',
            showKeyboardToolbar: true,
            textInputAction: TextInputAction.done,
            autocorrect: false,
            inputFormatters: [
              UpperCaseTextFormatter(),
              FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z\s]')),
            ],
            validator: (value) {
              if (value?.isNotEmpty == true) {
                // Must contain only letters and spaces
                if (!RegExp(r'^[a-zA-Z\s]+$').hasMatch(value!)) {
                  return 'Name must contain only letters and spaces';
                }
                if (value.trim().length < 2) {
                  return 'Name must be at least 2 characters';
                }
              }
              return null;
            },
            onChanged: (value) {
              // Real-time validation
              if (value.isNotEmpty) {
                Future.delayed(TossAnimations.slow, () {
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
