import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myfinance_improved/core/themes/index.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/navigation/safe_navigation.dart';
import '../../../../domain/entities/user_profile.dart';
import '../../../providers/app_state_provider.dart';
import '../../../providers/user_profile_provider.dart';
import '../../../widgets/common/toss_app_bar.dart';
import '../../../widgets/common/toss_scaffold.dart';
import '../../../widgets/toss/toss_card.dart';
import '../../../widgets/toss/toss_enhanced_text_field.dart';
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
        // No user ID found
        setState(() {
          _isLoading = false;
        });
        return;
      }
      
      // Get the chosen company from app state
      final appState = ref.read(appStateProvider);
      final companyId = appState.companyChoosen;
      // Get company ID from app state
      
      // Directly query Supabase for user profile
      final response = await Supabase.instance.client
          .from('users')
          .select('*')
          .eq('user_id', userId)
          .maybeSingle();
      
      // Query bank account from users_bank_account table (only if companyId exists)
      Map<String, dynamic>? bankResponse;
      if (companyId != null && companyId.isNotEmpty) {
        // Fetch bank account data for company
        try {
          bankResponse = await Supabase.instance.client
              .from('users_bank_account')
              .select('user_bank_name, user_account_number, description')
              .eq('user_id', userId)
              .eq('company_id', companyId)
              .maybeSingle();
          // Bank data fetched successfully
        } catch (bankError) {
          // Bank account fetch error (non-fatal) - continue without bank data
        }
      } else {
        // No company ID, skipping bank account fetch
      }
      
      if (response != null) {
        // User data fetched successfully
        // Create UserProfile from response (without bank info)
        _profile = UserProfile(
          userId: (response['user_id'] ?? userId).toString(),
          firstName: response['first_name']?.toString(),
          lastName: response['last_name']?.toString(),
          email: (response['email'] ?? Supabase.instance.client.auth.currentUser?.email ?? '').toString(),
          phoneNumber: response['user_phone_number']?.toString(),
          profileImage: response['profile_image']?.toString(),
          bankName: '', // Will be set from users_bank_account
          bankAccountNumber: '', // Will be set from users_bank_account
          createdAt: response['created_at'] != null ? DateTime.parse(response['created_at'].toString()) : DateTime.now(),
          updatedAt: response['updated_at'] != null ? DateTime.parse(response['updated_at'].toString()) : DateTime.now(),
        );
        
        // Store original values from user profile
        _originalFirstName = _profile!.firstName ?? '';
        _originalLastName = _profile!.lastName ?? '';
        _originalPhoneNumber = _profile!.phoneNumber ?? '';
        
        // Store original values from bank account (if exists)
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
        
        // Add listeners after setting values
        _firstNameController.addListener(_onFieldChanged);
        _lastNameController.addListener(_onFieldChanged);
        _phoneNumberController.addListener(_onFieldChanged);
        _bankNameController.addListener(_onFieldChanged);
        _bankAccountController.addListener(_onFieldChanged);
        _bankDescriptionController.addListener(_onFieldChanged);
      } else {
        // Create a minimal profile
        _profile = UserProfile(
          userId: userId,
          email: Supabase.instance.client.auth.currentUser?.email ?? '',
          firstName: '',
          lastName: '',
          phoneNumber: '',
          bankName: '',
          bankAccountNumber: '',
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );
        
        // Add listeners for empty controllers
        _firstNameController.addListener(_onFieldChanged);
        _lastNameController.addListener(_onFieldChanged);
        _phoneNumberController.addListener(_onFieldChanged);
        _bankNameController.addListener(_onFieldChanged);
        _bankAccountController.addListener(_onFieldChanged);
        _bankDescriptionController.addListener(_onFieldChanged);
      }
      
      // Profile loaded successfully
      setState(() {
        _isLoading = false;
      });
    } catch (e, stackTrace) {
      // Error loading profile data
      setState(() {
        _isLoading = false;
      });
    }
  }
  
  void _onFieldChanged() {
    // Check if values are actually different from original
    final hasActualChanges = 
        _firstNameController.text != (_originalFirstName ?? '') ||
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
    final profileFromProvider = ref.watch(currentUserProfileProvider).valueOrNull;
    
    // Use provider data as fallback if direct load failed
    if (_profile == null && profileFromProvider != null && !_isLoading) {
      // Using profile data from provider as fallback
      _profile = profileFromProvider;
      // Update controllers with provider data
      _firstNameController.text = profileFromProvider.firstName ?? '';
      _lastNameController.text = profileFromProvider.lastName ?? '';
      _phoneNumberController.text = profileFromProvider.phoneNumber ?? '';
      // Bank data will be empty as it's not in the provider
      _originalFirstName = profileFromProvider.firstName ?? '';
      _originalLastName = profileFromProvider.lastName ?? '';
      _originalPhoneNumber = profileFromProvider.phoneNumber ?? '';
      _originalBankName = '';
      _originalBankAccount = '';
      _originalBankDescription = '';
      
      // Add listeners if not already added
      if (!_firstNameController.hasListeners) {
        _firstNameController.addListener(_onFieldChanged);
        _lastNameController.addListener(_onFieldChanged);
        _phoneNumberController.addListener(_onFieldChanged);
        _bankNameController.addListener(_onFieldChanged);
        _bankAccountController.addListener(_onFieldChanged);
        _bankDescriptionController.addListener(_onFieldChanged);
      }
    }
    
    if (_isLoading) {
      return TossScaffold(
        backgroundColor: TossColors.surface,
        appBar: TossAppBar(
          title: 'Edit Profile',
          backgroundColor: TossColors.surface,
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
        backgroundColor: TossColors.surface,
        appBar: TossAppBar(
          title: 'Edit Profile',
          backgroundColor: TossColors.surface,
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline,
                size: 64,
                color: TossColors.error,
              ),
              SizedBox(height: TossSpacing.space4),
              Text(
                'Failed to load profile',
                style: TossTextStyles.h3.copyWith(
                  color: TossColors.gray900,
                ),
              ),
              SizedBox(height: TossSpacing.space6),
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
                child: Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }
    
    return TossScaffold(
      backgroundColor: TossColors.surface,
      appBar: TossAppBar(
        title: 'Edit Profile',
        backgroundColor: TossColors.surface,
        primaryActionText: _hasChanges ? (_isLoading ? null : 'Save') : null,
        onPrimaryAction: _hasChanges && !_isLoading ? _saveProfile : null,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(TossSpacing.screenPaddingMobile),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Personal Information Section
              Text(
                'Personal Information',
                style: TossTextStyles.h3.copyWith(
                  fontWeight: FontWeight.w600,
                  color: TossColors.gray900,
                ),
              ),
              SizedBox(height: TossSpacing.space4),
              
              TossCard(
                padding: EdgeInsets.all(TossSpacing.space5),
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
                    SizedBox(height: TossSpacing.space4),
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
                    
                    SizedBox(height: TossSpacing.space4),
                    
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
              
              SizedBox(height: TossSpacing.space6),
              
              // Bank Information Section
              Text(
                'Bank Information',
                style: TossTextStyles.h3.copyWith(
                  fontWeight: FontWeight.w600,
                  color: TossColors.gray900,
                ),
              ),
              SizedBox(height: TossSpacing.space4),
              
              TossCard(
                padding: EdgeInsets.all(TossSpacing.space5),
                child: Column(
                  children: [
                    TossEnhancedTextField(
                      controller: _bankNameController,
                      label: 'Bank Name',
                      hintText: 'Enter your bank name',
                      showKeyboardToolbar: true,
                      textInputAction: TextInputAction.next,
                    ),
                    SizedBox(height: TossSpacing.space4),
                    
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
                    SizedBox(height: TossSpacing.space4),
                    
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
              
              SizedBox(height: TossSpacing.space6),
              
              // Account Information (Read-only)
              Text(
                'Account Information',
                style: TossTextStyles.h3.copyWith(
                  fontWeight: FontWeight.w600,
                  color: TossColors.gray900,
                ),
              ),
              SizedBox(height: TossSpacing.space4),
              
              TossCard(
                padding: EdgeInsets.all(TossSpacing.space5),
                child: Column(
                  children: [
                    _buildReadOnlyField('Email', _profile!.email),
                    SizedBox(height: TossSpacing.space4),
                    _buildReadOnlyField('Role', _profile!.displayRole),
                    if (_profile!.companyName?.isNotEmpty == true) ...[
                      SizedBox(height: TossSpacing.space4),
                      _buildReadOnlyField('Company', _profile!.companyName!),
                    ],
                    if (_profile!.storeName?.isNotEmpty == true) ...[
                      SizedBox(height: TossSpacing.space4),
                      _buildReadOnlyField('Store', _profile!.storeName!),
                    ],
                  ],
                ),
              ),
              
              SizedBox(height: TossSpacing.space8),
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
        SizedBox(height: TossSpacing.space2),
        Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(
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
      
      // Save profile changes
      
      // 1. Update users table for profile information
      // Only update if profile fields have changed
      if (_firstNameController.text.trim() != (_originalFirstName ?? '') ||
          _lastNameController.text.trim() != (_originalLastName ?? '') ||
          _phoneNumberController.text.trim() != (_originalPhoneNumber ?? '')) {
        
        // Update user profile in database
        final phoneValue = _phoneNumberController.text.trim().isEmpty ? null : _phoneNumberController.text.trim();
        
        await Supabase.instance.client
            .from('users')
            .update({
              'first_name': _firstNameController.text.trim(),
              'last_name': _lastNameController.text.trim(),
              'user_phone_number': phoneValue,
              'updated_at': DateTime.now().toIso8601String(),
            })
            .eq('user_id', userId);
        
        // User profile updated
        
        // Update app state locally without RPC call
        await ref.read(appStateProvider.notifier).updateUserProfileLocally(
          firstName: _firstNameController.text.trim(),
          lastName: _lastNameController.text.trim(),
        );
        // App state updated locally
      }
      
      // 2. Update users_bank_account table for bank information
      // Only process if company ID exists and bank fields have changed
      if (companyId != null && companyId.isNotEmpty) {
        if (_bankNameController.text.trim() != (_originalBankName ?? '') ||
            _bankAccountController.text.trim() != (_originalBankAccount ?? '') ||
            _bankDescriptionController.text.trim() != (_originalBankDescription ?? '')) {
          
          // Only save if at least one bank field has content
          if (_bankNameController.text.trim().isNotEmpty || 
              _bankAccountController.text.trim().isNotEmpty ||
              _bankDescriptionController.text.trim().isNotEmpty) {
            
            // Update bank account information
            
            // Check if bank account exists for this user and company
            final existingBank = await Supabase.instance.client
                .from('users_bank_account')
                .select('id')
                .eq('user_id', userId)
                .eq('company_id', companyId)
                .maybeSingle();
            
            if (existingBank != null) {
              // Update existing bank account
              // Update existing bank account
              await Supabase.instance.client
                  .from('users_bank_account')
                  .update({
                    'user_bank_name': _bankNameController.text.trim(),
                    'user_account_number': _bankAccountController.text.trim(),
                    'description': _bankDescriptionController.text.trim(),
                    'updated_at': DateTime.now().toIso8601String(),
                  })
                  .eq('user_id', userId)
                  .eq('company_id', companyId);
            } else {
              // Create new bank account
              // Create new bank account record
              await Supabase.instance.client
                  .from('users_bank_account')
                  .insert({
                    'user_id': userId,
                    'company_id': companyId,
                    'user_bank_name': _bankNameController.text.trim(),
                    'user_account_number': _bankAccountController.text.trim(),
                    'description': _bankDescriptionController.text.trim(),
                    'created_at': DateTime.now().toIso8601String(),
                    'updated_at': DateTime.now().toIso8601String(),
                  });
            }
            
            // Bank account updated
          }
        }
      } else {
        // No company selected, skipping bank account update
      }
      
      // Update original values after successful save
      setState(() {
        _originalFirstName = _firstNameController.text.trim();
        _originalLastName = _lastNameController.text.trim();
        _originalPhoneNumber = _phoneNumberController.text.trim();
        _originalBankName = _bankNameController.text.trim();
        _originalBankAccount = _bankAccountController.text.trim();
        _originalBankDescription = _bankDescriptionController.text.trim();
        _hasChanges = false;
      });
      
      // Only refresh the local user profile provider
      // App state was already updated locally above
      // Refresh local user profile
      ref.invalidate(currentUserProfileProvider);
      
      // Profile updated successfully
      
      if (mounted) {
        HapticFeedback.lightImpact();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Icon(Icons.check_circle, color: TossColors.white, size: 20),
                SizedBox(width: TossSpacing.space2),
                Text('Profile updated successfully'),
              ],
            ),
            backgroundColor: TossColors.success,
            behavior: SnackBarBehavior.floating,
            duration: Duration(seconds: 2),
          ),
        );
        context.safePop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error updating profile: $e'),
            backgroundColor: TossColors.error,
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