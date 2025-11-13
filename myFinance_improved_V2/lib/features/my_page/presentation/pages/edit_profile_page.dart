import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:myfinance_improved/app/providers/app_state_provider.dart';
import 'package:myfinance_improved/core/utils/datetime_utils.dart';
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

  // Store original values to detect real changes
  String? _originalFirstName;
  String? _originalLastName;
  String? _originalPhoneNumber;
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

      // Query bank account from users_bank_account table
      Map<String, dynamic>? bankResponse;
      if (companyId.isNotEmpty) {
        try {
          bankResponse = await Supabase.instance.client
              .from('users_bank_account')
              .select('user_bank_name, user_account_number, description')
              .eq('user_id', userId)
              .eq('company_id', companyId)
              .maybeSingle();
        } catch (bankError) {
          // Bank account fetch error (non-fatal)
        }
      }

      if (profile != null) {
        _profile = profile;

        // Store original values
        _originalFirstName = _profile!.firstName ?? '';
        _originalLastName = _profile!.lastName ?? '';
        _originalPhoneNumber = _profile!.phoneNumber ?? '';

        // Store bank info
        _originalBankName = bankResponse?['user_bank_name']?.toString() ?? '';
        _originalBankAccount = bankResponse?['user_account_number']?.toString() ?? '';
        _originalBankDescription = bankResponse?['description']?.toString() ?? '';

        // Set controller values
        _firstNameController.text = _originalFirstName!;
        _lastNameController.text = _originalLastName!;
        _phoneNumberController.text = _originalPhoneNumber!;
        _bankNameController.text = _originalBankName!;
        _bankAccountController.text = _originalBankAccount!;
        _bankDescriptionController.text = _originalBankDescription!;

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
    final hasActualChanges = _firstNameController.text != (_originalFirstName ?? '') ||
        _lastNameController.text != (_originalLastName ?? '') ||
        _phoneNumberController.text != (_originalPhoneNumber ?? '') ||
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
                              validator: (value) {
                                if (value?.trim().isEmpty ?? true) {
                                  return 'Please enter your first name';
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
                              validator: (value) {
                                if (value?.trim().isEmpty ?? true) {
                                  return 'Please enter your last name';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: TossSpacing.space4),
                            TossEnhancedTextField(
                              controller: _phoneNumberController,
                              label: 'Phone Number',
                              hintText: 'Enter your phone number',
                              keyboardType: TextInputType.phone,
                              showKeyboardToolbar: true,
                              textInputAction: TextInputAction.next,
                              validator: (value) {
                                if (value?.isNotEmpty == true) {
                                  final phoneRegex = RegExp(r'^\+?[\d\s\-\(\)]{10,}$');
                                  if (!phoneRegex.hasMatch(value!)) {
                                    return 'Please enter a valid phone number';
                                  }
                                }
                                return null;
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
                            ),
                            const SizedBox(height: TossSpacing.space4),
                            TossEnhancedTextField(
                              controller: _bankAccountController,
                              label: 'Bank Account Number',
                              hintText: 'Enter your bank account number',
                              keyboardType: TextInputType.number,
                              showKeyboardToolbar: true,
                              textInputAction: TextInputAction.next,
                              validator: (value) {
                                if (value?.isNotEmpty == true) {
                                  final accountRegex = RegExp(r'^\d+$');
                                  if (!accountRegex.hasMatch(value!)) {
                                    return 'Account number should contain only digits';
                                  }
                                  if (value.length < 8) {
                                    return 'Account number should be at least 8 digits';
                                  }
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: TossSpacing.space4),
                            TossEnhancedTextField(
                              controller: _bankDescriptionController,
                              label: 'Description',
                              hintText: 'Enter description (optional)',
                              showKeyboardToolbar: true,
                              textInputAction: TextInputAction.done,
                              maxLines: 2,
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

      // Save profile via repository
      if (_firstNameController.text.trim() != (_originalFirstName ?? '') ||
          _lastNameController.text.trim() != (_originalLastName ?? '') ||
          _phoneNumberController.text.trim() != (_originalPhoneNumber ?? '')) {
        await ref.read(myPageProvider.notifier).updateProfile(
              firstName: _firstNameController.text.trim(),
              lastName: _lastNameController.text.trim(),
              phoneNumber: _phoneNumberController.text.trim().isEmpty ? null : _phoneNumberController.text.trim(),
            );
      }

      // Save bank information (direct query as it's outside repository scope)
      if (companyId.isNotEmpty) {
        if (_bankNameController.text.trim() != (_originalBankName ?? '') ||
            _bankAccountController.text.trim() != (_originalBankAccount ?? '') ||
            _bankDescriptionController.text.trim() != (_originalBankDescription ?? '')) {
          if (_bankNameController.text.trim().isNotEmpty ||
              _bankAccountController.text.trim().isNotEmpty ||
              _bankDescriptionController.text.trim().isNotEmpty) {
            final existingBank = await Supabase.instance.client
                .from('users_bank_account')
                .select('id')
                .eq('user_id', userId)
                .eq('company_id', companyId)
                .maybeSingle();

            if (existingBank != null) {
              await Supabase.instance.client.from('users_bank_account').update({
                'user_bank_name': _bankNameController.text.trim(),
                'user_account_number': _bankAccountController.text.trim(),
                'description': _bankDescriptionController.text.trim(),
                'updated_at': DateTimeUtils.nowUtc(),
              }).eq('user_id', userId).eq('company_id', companyId);
            } else {
              await Supabase.instance.client.from('users_bank_account').insert({
                'user_id': userId,
                'company_id': companyId,
                'user_bank_name': _bankNameController.text.trim(),
                'user_account_number': _bankAccountController.text.trim(),
                'description': _bankDescriptionController.text.trim(),
                'created_at': DateTimeUtils.nowUtc(),
                'updated_at': DateTimeUtils.nowUtc(),
              });
            }
          }
        }
      }

      // Update original values
      setState(() {
        _originalFirstName = _firstNameController.text.trim();
        _originalLastName = _lastNameController.text.trim();
        _originalPhoneNumber = _phoneNumberController.text.trim();
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
}
