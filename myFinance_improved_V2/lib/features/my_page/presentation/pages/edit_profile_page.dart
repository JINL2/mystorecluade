import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:myfinance_improved/app/providers/app_state_provider.dart';
import 'package:myfinance_improved/shared/themes/toss_border_radius.dart';
import 'package:myfinance_improved/shared/themes/toss_colors.dart';
import 'package:myfinance_improved/shared/themes/toss_spacing.dart';
import 'package:myfinance_improved/shared/themes/toss_text_styles.dart';
import 'package:myfinance_improved/shared/widgets/common/toss_app_bar_1.dart';
import 'package:myfinance_improved/shared/widgets/common/toss_scaffold.dart';
import 'package:myfinance_improved/shared/widgets/common/toss_success_error_dialog.dart';
import 'package:myfinance_improved/shared/widgets/common/toss_white_card.dart';
import 'package:myfinance_improved/shared/widgets/toss/toss_enhanced_text_field.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../domain/entities/user_profile.dart';
import '../providers/user_profile_providers.dart';

/// Uppercase text formatter: auto-converts input to uppercase
class UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    return TextEditingValue(
      text: newValue.text.toUpperCase(),
      selection: newValue.selection,
    );
  }
}

/// Smart bank account formatter: allows letters only for IBAN format
class BankAccountFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final text = newValue.text.toUpperCase();

    // If empty or just starting, allow any input
    if (text.isEmpty) {
      return TextEditingValue(
        text: text,
        selection: newValue.selection,
      );
    }

    // Check if user is typing IBAN format (starts with 2 letters)
    final startsWithTwoLetters = RegExp(r'^[A-Z]{1,2}$').hasMatch(text);
    final isIBANFormat = text.length >= 2 && RegExp(r'^[A-Z]{2}').hasMatch(text);

    // If starting with letters (IBAN), allow alphanumeric + spaces
    if (startsWithTwoLetters || isIBANFormat) {
      // IBAN format: allow letters, digits, and spaces
      if (RegExp(r'^[A-Z0-9\s]*$').hasMatch(text)) {
        return TextEditingValue(
          text: text,
          selection: newValue.selection,
        );
      }
    } else {
      // Regular account number: digits only
      if (RegExp(r'^[0-9]*$').hasMatch(text)) {
        return TextEditingValue(
          text: text,
          selection: newValue.selection,
        );
      }
    }

    // If invalid, keep old value
    return oldValue;
  }
}

class EditProfilePage extends ConsumerStatefulWidget {
  const EditProfilePage({super.key});

  @override
  ConsumerState<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends ConsumerState<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _firstNameController;
  late final TextEditingController _lastNameController;
  late final TextEditingController _phoneNumberController;
  late final TextEditingController _bankNameController;
  late final TextEditingController _bankAccountController;
  late final TextEditingController _bankDescriptionController;

  bool _isLoading = true;
  bool _hasChanges = false;
  UserProfile? _profile;

  // Date of birth state
  DateTime? _selectedDateOfBirth;

  // Store original values to detect real changes
  String? _originalFirstName;
  String? _originalLastName;
  String? _originalPhoneNumber;
  String? _originalDateOfBirth;
  String? _originalBankName;
  String? _originalBankAccount;
  String? _originalBankDescription;

  @override
  void initState() {
    super.initState();

    // Initialize controllers with empty text initially
    _firstNameController = TextEditingController();
    _lastNameController = TextEditingController();
    _phoneNumberController = TextEditingController();
    _bankNameController = TextEditingController();
    _bankAccountController = TextEditingController();
    _bankDescriptionController = TextEditingController();

    // Load profile data directly
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadProfileData();
    });
  }

  Future<void> _loadProfileData() async {
    try {
      final userId = Supabase.instance.client.auth.currentUser?.id;

      if (userId == null) {
        setState(() {
          _isLoading = false;
        });
        return;
      }

      final appState = ref.read(appStateProvider);
      final companyId = appState.companyChoosen;

      // Get user profile from repository
      final repository = ref.read(userProfileRepositoryProvider);
      final profile = await repository.getUserProfile(userId);

      // Query bank account via repository
      Map<String, dynamic>? bankResponse;
      if (companyId.isNotEmpty) {
        bankResponse = await repository.getUserBankAccount(
          userId: userId,
          companyId: companyId,
        );
      }

      if (profile != null) {
        _profile = profile;

        // Store original values
        _originalFirstName = _profile!.firstName ?? '';
        _originalLastName = _profile!.lastName ?? '';
        _originalPhoneNumber = _profile!.phoneNumber ?? '';
        _originalDateOfBirth = _profile!.dateOfBirth ?? '';

        // Parse date of birth if exists
        if (_profile!.dateOfBirth?.isNotEmpty == true) {
          try {
            _selectedDateOfBirth = DateTime.parse(_profile!.dateOfBirth!);
          } catch (e) {
            _selectedDateOfBirth = null;
          }
        }

        // Store bank info
        _originalBankName = bankResponse?['user_bank_name']?.toString() ?? '';
        _originalBankAccount = bankResponse?['user_account_number']?.toString() ?? '';
        _originalBankDescription = bankResponse?['description']?.toString() ?? '';

        // Set controller values
        _firstNameController.text = _originalFirstName ?? '';
        _lastNameController.text = _originalLastName ?? '';
        _phoneNumberController.text = _originalPhoneNumber ?? '';
        _bankNameController.text = _originalBankName ?? '';
        _bankAccountController.text = _originalBankAccount ?? '';
        _bankDescriptionController.text = _originalBankDescription ?? '';

        // Add listeners
        _firstNameController.addListener(_onFieldChanged);
        _lastNameController.addListener(_onFieldChanged);
        _phoneNumberController.addListener(_onFieldChanged);
        _bankNameController.addListener(_onFieldChanged);
        _bankAccountController.addListener(_onFieldChanged);
        _bankDescriptionController.addListener(_onFieldChanged);
      } else {
        // Create minimal profile
        _profile = UserProfile(
          userId: userId,
          email: Supabase.instance.client.auth.currentUser?.email ?? '',
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );

        _firstNameController.addListener(_onFieldChanged);
        _lastNameController.addListener(_onFieldChanged);
        _phoneNumberController.addListener(_onFieldChanged);
        _bankNameController.addListener(_onFieldChanged);
        _bankAccountController.addListener(_onFieldChanged);
        _bankDescriptionController.addListener(_onFieldChanged);
      }

      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _onFieldChanged() {
    final currentDob = _selectedDateOfBirth?.toIso8601String().split('T').first ?? '';

    final hasActualChanges = _firstNameController.text != (_originalFirstName ?? '') ||
        _lastNameController.text != (_originalLastName ?? '') ||
        _phoneNumberController.text != (_originalPhoneNumber ?? '') ||
        currentDob != (_originalDateOfBirth ?? '') ||
        _bankNameController.text != (_originalBankName ?? '') ||
        _bankAccountController.text != (_originalBankAccount ?? '') ||
        _bankDescriptionController.text != (_originalBankDescription ?? '');

    if (_hasChanges != hasActualChanges) {
      setState(() {
        _hasChanges = hasActualChanges;
      });
    }
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _phoneNumberController.dispose();
    _bankNameController.dispose();
    _bankAccountController.dispose();
    _bankDescriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const TossScaffold(
        backgroundColor: TossColors.gray100,
        appBar: TossAppBar1(
          title: 'Edit Profile',
          backgroundColor: TossColors.gray100,
        ),
        body: Center(
          child: CircularProgressIndicator(
            color: TossColors.primary,
          ),
        ),
      );
    }

    if (_profile == null) {
      return TossScaffold(
        backgroundColor: TossColors.gray100,
        appBar: const TossAppBar1(
          title: 'Edit Profile',
          backgroundColor: TossColors.gray100,
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.error_outline,
                size: 64,
                color: TossColors.error,
              ),
              const SizedBox(height: TossSpacing.space4),
              Text(
                'Failed to load profile',
                style: TossTextStyles.h3.copyWith(
                  color: TossColors.gray900,
                ),
              ),
              const SizedBox(height: TossSpacing.space6),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _isLoading = true;
                  });
                  _loadProfileData();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: TossColors.primary,
                  foregroundColor: TossColors.white,
                ),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    return TossScaffold(
      backgroundColor: TossColors.gray100,
      appBar: TossAppBar1(
        title: 'Edit Profile',
        backgroundColor: TossColors.gray100,
        actions: _hasChanges && !_isLoading
            ? [
                TextButton(
                  onPressed: _saveProfile,
                  child: Text(
                    'Save',
                    style: TossTextStyles.body.copyWith(
                      color: TossColors.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ]
            : null,
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Personal Information Section
              Container(
                width: double.infinity,
                margin: const EdgeInsets.symmetric(horizontal: TossSpacing.space4),
                child: TossWhiteCard(
                  padding: EdgeInsets.zero,
                  child: Column(
                    children: [
                      // Section Header
                      Container(
                        padding: const EdgeInsets.all(TossSpacing.space4),
                        decoration: const BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              color: TossColors.gray100,
                              width: 1,
                            ),
                          ),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.person_outline,
                              color: TossColors.primary,
                              size: TossSpacing.iconSM,
                            ),
                            const SizedBox(width: TossSpacing.space2),
                            Text(
                              'Personal Information',
                              style: TossTextStyles.bodyLarge.copyWith(
                                fontWeight: FontWeight.w700,
                                color: TossColors.gray900,
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Form fields
                      Container(
                        padding: const EdgeInsets.all(TossSpacing.space5),
                        child: Column(
                          children: [
                            TossEnhancedTextField(
                              controller: _firstNameController,
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
                              controller: _lastNameController,
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
                            _buildDatePickerField(),
                            const SizedBox(height: TossSpacing.space4),
                            TossEnhancedTextField(
                              controller: _phoneNumberController,
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
                                  final validPattern = RegExp(r'^[\+]?[(]?[0-9]{1,4}[)]?[-\s\.]?[(]?[0-9]{1,4}[)]?[-\s\.]?[0-9]{1,9}$');
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
                                    if (mounted) {
                                      _formKey.currentState?.validate();
                                    }
                                  });
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: TossSpacing.space4),

              // Bank Information Section
              Container(
                width: double.infinity,
                margin: const EdgeInsets.symmetric(horizontal: TossSpacing.space4),
                child: TossWhiteCard(
                  padding: EdgeInsets.zero,
                  child: Column(
                    children: [
                      // Section Header
                      Container(
                        padding: const EdgeInsets.all(TossSpacing.space4),
                        decoration: const BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              color: TossColors.gray100,
                              width: 1,
                            ),
                          ),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.account_balance_outlined,
                              color: TossColors.primary,
                              size: TossSpacing.iconSM,
                            ),
                            const SizedBox(width: TossSpacing.space2),
                            Text(
                              'Bank Information',
                              style: TossTextStyles.bodyLarge.copyWith(
                                fontWeight: FontWeight.w700,
                                color: TossColors.gray900,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(TossSpacing.space5),
                        child: Column(
                          children: [
                            TossEnhancedTextField(
                              controller: _bankNameController,
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
                                  Future.delayed(const Duration(milliseconds: 300), () {
                                    if (mounted) {
                                      _formKey.currentState?.validate();
                                    }
                                  });
                                }
                              },
                            ),
                            const SizedBox(height: TossSpacing.space4),
                            TossEnhancedTextField(
                              controller: _bankAccountController,
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
                                  Future.delayed(const Duration(milliseconds: 300), () {
                                    if (mounted) {
                                      _formKey.currentState?.validate();
                                    }
                                  });
                                }
                              },
                            ),
                            const SizedBox(height: TossSpacing.space4),
                            TossEnhancedTextField(
                              controller: _bankDescriptionController,
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
                                  Future.delayed(const Duration(milliseconds: 300), () {
                                    if (mounted) {
                                      _formKey.currentState?.validate();
                                    }
                                  });
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: TossSpacing.space4),

              // Account Information (Read-only)
              Container(
                width: double.infinity,
                margin: const EdgeInsets.symmetric(horizontal: TossSpacing.space4),
                child: TossWhiteCard(
                  padding: EdgeInsets.zero,
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(TossSpacing.space4),
                        decoration: const BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              color: TossColors.gray100,
                              width: 1,
                            ),
                          ),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.info_outline,
                              color: TossColors.primary,
                              size: TossSpacing.iconSM,
                            ),
                            const SizedBox(width: TossSpacing.space2),
                            Text(
                              'Account Information',
                              style: TossTextStyles.bodyLarge.copyWith(
                                fontWeight: FontWeight.w700,
                                color: TossColors.gray900,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(TossSpacing.space5),
                        child: Column(
                          children: [
                            _buildReadOnlyField('Email', _profile!.email),
                            const SizedBox(height: TossSpacing.space4),
                            _buildReadOnlyField('Role', _profile!.displayRole),
                            if (_profile!.companyName?.isNotEmpty == true) ...[
                              const SizedBox(height: TossSpacing.space4),
                              _buildReadOnlyField('Company', _profile!.companyName!),
                            ],
                            if (_profile!.storeName?.isNotEmpty == true) ...[
                              const SizedBox(height: TossSpacing.space4),
                              _buildReadOnlyField('Store', _profile!.storeName!),
                            ],
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: TossSpacing.space12),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildReadOnlyField(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TossTextStyles.labelLarge.copyWith(
            color: TossColors.gray700,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: TossSpacing.space2),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(
            vertical: TossSpacing.space3,
            horizontal: TossSpacing.space4,
          ),
          decoration: BoxDecoration(
            color: TossColors.gray50,
            borderRadius: BorderRadius.circular(TossBorderRadius.md),
            border: Border.all(color: TossColors.gray100),
          ),
          child: Text(
            value,
            style: TossTextStyles.body.copyWith(
              color: TossColors.gray600,
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final userId = Supabase.instance.client.auth.currentUser?.id;
      if (userId == null) throw Exception('User not authenticated');

      final appState = ref.read(appStateProvider);
      final companyId = appState.companyChoosen;
      final repository = ref.read(userProfileRepositoryProvider);

      // Save profile data via repository
      final currentDob = _selectedDateOfBirth?.toIso8601String().split('T').first ?? '';

      if (_firstNameController.text.trim() != (_originalFirstName ?? '') ||
          _lastNameController.text.trim() != (_originalLastName ?? '') ||
          _phoneNumberController.text.trim() != (_originalPhoneNumber ?? '') ||
          currentDob != (_originalDateOfBirth ?? '')) {

        await repository.updateUserProfile(
          userId: userId,
          firstName: _firstNameController.text.trim(),
          lastName: _lastNameController.text.trim(),
          phoneNumber: _phoneNumberController.text.trim().isEmpty ? null : _phoneNumberController.text.trim(),
          dateOfBirth: currentDob.isEmpty ? null : currentDob,
        );
      }

      // Save bank information via repository
      if (companyId.isNotEmpty) {
        if (_bankNameController.text.trim() != (_originalBankName ?? '') ||
            _bankAccountController.text.trim() != (_originalBankAccount ?? '') ||
            _bankDescriptionController.text.trim() != (_originalBankDescription ?? '')) {
          if (_bankNameController.text.trim().isNotEmpty ||
              _bankAccountController.text.trim().isNotEmpty ||
              _bankDescriptionController.text.trim().isNotEmpty) {
            await repository.saveUserBankAccount(
              userId: userId,
              companyId: companyId,
              bankName: _bankNameController.text.trim(),
              accountNumber: _bankAccountController.text.trim(),
              description: _bankDescriptionController.text.trim(),
            );
          }
        }
      }

      // Update original values
      setState(() {
        _originalFirstName = _firstNameController.text.trim();
        _originalLastName = _lastNameController.text.trim();
        _originalPhoneNumber = _phoneNumberController.text.trim();
        _originalDateOfBirth = _selectedDateOfBirth?.toIso8601String().split('T').first ?? '';
        _originalBankName = _bankNameController.text.trim();
        _originalBankAccount = _bankAccountController.text.trim();
        _originalBankDescription = _bankDescriptionController.text.trim();
        _hasChanges = false;
      });

      ref.invalidate(currentUserProfileProvider);

      if (mounted) {
        HapticFeedback.lightImpact();

        // Show success dialog
        await showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => TossDialog.success(
            title: 'Profile Updated!',
            message: 'Your profile has been updated successfully',
            primaryButtonText: 'Done',
            onPrimaryPressed: () => context.pop(),
          ),
        );

        context.pop();
      }
    } catch (e) {
      if (mounted) {
        // Show error dialog
        await showDialog(
          context: context,
          barrierDismissible: true,
          builder: (context) => TossDialog.error(
            title: 'Update Failed',
            message: 'Failed to update profile: $e',
            primaryButtonText: 'OK',
            onPrimaryPressed: () => context.pop(),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Widget _buildDatePickerField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Date of Birth',
          style: TossTextStyles.label.copyWith(
            color: TossColors.gray700,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: TossSpacing.space2),
        InkWell(
          onTap: () => _showDatePickerBottomSheet(),
          borderRadius: BorderRadius.circular(TossBorderRadius.lg),
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: TossSpacing.space4,
              vertical: TossSpacing.space4,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(TossBorderRadius.lg),
              border: Border.all(
                color: TossColors.gray100,
                width: 1,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _selectedDateOfBirth != null
                      ? _formatDate(_selectedDateOfBirth!)
                      : 'Select date',
                  style: TossTextStyles.body.copyWith(
                    color: _selectedDateOfBirth != null
                        ? TossColors.gray900
                        : TossColors.gray500,
                    fontWeight: _selectedDateOfBirth != null
                        ? FontWeight.w500
                        : FontWeight.w400,
                  ),
                ),
                const Icon(
                  Icons.calendar_today_outlined,
                  size: 20,
                  color: TossColors.gray600,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  String _formatDate(DateTime date) {
    final months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }

  void _showDatePickerBottomSheet() {
    final now = DateTime.now();
    final initialDate = _selectedDateOfBirth ?? DateTime(now.year - 25, now.month, now.day);

    DateTime tempSelectedDate = initialDate;
    int selectedYear = tempSelectedDate.year;
    int selectedMonth = tempSelectedDate.month;
    int selectedDay = tempSelectedDate.day;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            final daysInMonth = DateTime(selectedYear, selectedMonth + 1, 0).day;
            if (selectedDay > daysInMonth) {
              selectedDay = daysInMonth;
            }

            return Container(
              height: 400,
              padding: const EdgeInsets.all(TossSpacing.space6),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text(
                          'Cancel',
                          style: TossTextStyles.body.copyWith(
                            color: TossColors.gray600,
                          ),
                        ),
                      ),
                      Text(
                        'Select Date',
                        style: TossTextStyles.h3.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          setState(() {
                            _selectedDateOfBirth = DateTime(selectedYear, selectedMonth, selectedDay);
                          });
                          _onFieldChanged();
                          Navigator.pop(context);
                        },
                        child: Text(
                          'Done',
                          style: TossTextStyles.body.copyWith(
                            color: TossColors.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: TossSpacing.space4),
                  Expanded(
                    child: Row(
                      children: [
                        Expanded(
                          child: _buildDropdown(
                            items: List.generate(100, (i) => now.year - i)
                                .map((y) => y.toString())
                                .toList(),
                            selectedValue: selectedYear.toString(),
                            onChanged: (value) {
                              setModalState(() {
                                selectedYear = int.parse(value!);
                              });
                            },
                          ),
                        ),
                        const SizedBox(width: TossSpacing.space2),
                        Expanded(
                          child: _buildDropdown(
                            items: [
                              'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
                              'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
                            ],
                            selectedValue: [
                              'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
                              'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
                            ][selectedMonth - 1],
                            onChanged: (value) {
                              setModalState(() {
                                selectedMonth = [
                                  'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
                                  'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
                                ].indexOf(value!) + 1;
                              });
                            },
                          ),
                        ),
                        const SizedBox(width: TossSpacing.space2),
                        Expanded(
                          child: _buildDropdown(
                            items: List.generate(daysInMonth, (i) => (i + 1).toString()),
                            selectedValue: selectedDay.toString(),
                            onChanged: (value) {
                              setModalState(() {
                                selectedDay = int.parse(value!);
                              });
                            },
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
      },
    );
  }

  Widget _buildDropdown({
    required List<String> items,
    required String selectedValue,
    required void Function(String?) onChanged,
  }) {
    return Container(
      height: 200,
      decoration: BoxDecoration(
        border: Border.all(color: TossColors.gray200),
        borderRadius: BorderRadius.circular(TossBorderRadius.md),
      ),
      child: ListWheelScrollView.useDelegate(
        itemExtent: 40,
        physics: const FixedExtentScrollPhysics(),
        diameterRatio: 1.5,
        perspective: 0.002,
        controller: FixedExtentScrollController(
          initialItem: items.indexOf(selectedValue),
        ),
        onSelectedItemChanged: (index) {
          onChanged(items[index]);
        },
        childDelegate: ListWheelChildBuilderDelegate(
          builder: (context, index) {
            if (index < 0 || index >= items.length) return null;
            final isSelected = items[index] == selectedValue;
            return Center(
              child: Text(
                items[index],
                style: TossTextStyles.body.copyWith(
                  fontSize: isSelected ? 18 : 16,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                  color: isSelected ? TossColors.gray900 : TossColors.gray500,
                ),
              ),
            );
          },
          childCount: items.length,
        ),
      ),
    );
  }
}
