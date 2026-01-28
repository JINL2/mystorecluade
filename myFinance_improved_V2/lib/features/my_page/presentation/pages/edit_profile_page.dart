import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:myfinance_improved/app/providers/app_state.dart';
import 'package:myfinance_improved/app/providers/app_state_provider.dart';
import 'package:myfinance_improved/app/providers/auth_providers.dart';
import 'package:myfinance_improved/shared/themes/toss_colors.dart';
import 'package:myfinance_improved/shared/themes/toss_text_styles.dart';
import 'package:myfinance_improved/shared/themes/toss_font_weight.dart';

import '../../domain/entities/user_profile.dart';
import '../providers/user_profile_providers.dart';
import '../widgets/edit_profile/edit_profile_widgets.dart';
import 'package:myfinance_improved/shared/widgets/index.dart';

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
      final userId = ref.read(currentUserIdProvider);
      final currentUser = ref.read(currentUserProvider);

      if (userId == null) {
        setState(() {
          _isLoading = false;
        });
        return;
      }

      final appState = ref.read(appStateProvider);
      final companyId = appState.companyChoosen;

      // Get user profile from repository (includes bank_accounts via RPC)
      final repository = ref.read(userProfileRepositoryProvider);
      final profile = await repository.getUserProfile(userId);

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

        // Get bank account for current company from RPC response
        final bankAccount = companyId.isNotEmpty
            ? _profile!.getBankAccountForCompany(companyId)
            : null;

        // Store bank info
        _originalBankName = bankAccount?.bankName ?? '';
        _originalBankAccount = bankAccount?.accountNumber ?? '';
        _originalBankDescription = bankAccount?.description ?? '';

        // Set controller values
        _firstNameController.text = _originalFirstName ?? '';
        _lastNameController.text = _originalLastName ?? '';
        _phoneNumberController.text = _originalPhoneNumber ?? '';
        _bankNameController.text = _originalBankName ?? '';
        _bankAccountController.text = _originalBankAccount ?? '';
        _bankDescriptionController.text = _originalBankDescription ?? '';

        // Add listeners
        _addControllerListeners();
      } else {
        // Create minimal profile
        _profile = UserProfile(
          userId: userId,
          email: currentUser?.email ?? '',
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );

        _addControllerListeners();
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

  void _addControllerListeners() {
    _firstNameController.addListener(_onFieldChanged);
    _lastNameController.addListener(_onFieldChanged);
    _phoneNumberController.addListener(_onFieldChanged);
    _bankNameController.addListener(_onFieldChanged);
    _bankAccountController.addListener(_onFieldChanged);
    _bankDescriptionController.addListener(_onFieldChanged);
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
        appBar: TossAppBar(
          title: 'Edit Profile',
        ),
        body: TossLoadingView(
          message: 'Loading profile...',
        ),
      );
    }

    if (_profile == null) {
      return TossScaffold(
        appBar: const TossAppBar(
          title: 'Edit Profile',
        ),
        body: TossErrorView(
          error: Exception('Failed to load profile'),
          title: 'Failed to load profile',
          onRetry: () {
            setState(() {
              _isLoading = true;
            });
            _loadProfileData();
          },
        ),
      );
    }

    return TossScaffold(
      appBar: TossAppBar(
        title: 'Edit Profile',
        actions: _hasChanges && !_isLoading
            ? [
                TossButton.textButton(
                  text: 'Save',
                  onPressed: _saveProfile,
                  textColor: TossColors.primary,
                  fontWeight: TossFontWeight.semibold,
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
              PersonalInfoSection(
                firstNameController: _firstNameController,
                lastNameController: _lastNameController,
                phoneNumberController: _phoneNumberController,
                selectedDateOfBirth: _selectedDateOfBirth,
                formKey: _formKey,
                onDatePickerTap: _showDatePicker,
              ),

              const GrayDividerSpace(),

              // Bank Information Section
              BankInfoSection(
                bankNameController: _bankNameController,
                bankAccountController: _bankAccountController,
                bankDescriptionController: _bankDescriptionController,
                formKey: _formKey,
              ),

              const GrayDividerSpace(),

              // Account Information (Read-only)
              Builder(
                builder: (context) {
                  final appState = ref.watch(appStateProvider);
                  return AccountInfoSection(
                    profile: _profile!,
                    roleName: appState.currentCompanyRoleName,
                    companyName: appState.companyName,
                    storeName: appState.storeName,
                  );
                },
              ),

              const GrayDividerSpace(),
            ],
          ),
        ),
      ),
    );
  }

  void _showDatePicker() {
    showDatePickerBottomSheet(
      context: context,
      initialDate: _selectedDateOfBirth,
      onDateSelected: (date) {
        setState(() {
          _selectedDateOfBirth = date;
        });
        _onFieldChanged();
      },
    );
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final userId = ref.read(currentUserIdProvider);
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
          phoneNumber: _phoneNumberController.text.trim().isEmpty
              ? null
              : _phoneNumberController.text.trim(),
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
}
