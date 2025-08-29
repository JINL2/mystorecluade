import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io';
import '../../../../core/themes/toss_colors.dart';
import '../../../../core/themes/toss_spacing.dart';
import '../../../../core/themes/toss_text_styles.dart';
import '../../../widgets/common/toss_scaffold.dart';
import '../../../widgets/common/toss_app_bar.dart';
import '../../../widgets/common/toss_loading_overlay.dart';
import '../../../widgets/common/toss_result_dialog.dart';
import '../../../widgets/toss/toss_card.dart';
import '../../../widgets/toss/toss_enhanced_text_field.dart';
import '../../../providers/user_profile_provider.dart';
import '../../../providers/auth_provider.dart';
import '../../../providers/app_state_provider.dart';
import '../../../../core/navigation/safe_navigation.dart';

// Provider to fetch user profile data from users table
final editProfileDataProvider = FutureProvider.autoDispose<Map<String, dynamic>?>((ref) async {
  final user = ref.watch(authStateProvider);
  if (user == null) return null;
  
  try {
    print('[EditProfile] Fetching profile data for user: ${user.id}');
    final response = await Supabase.instance.client
        .from('users')
        .select('user_id, first_name, last_name, email, profile_image, user_phone_number, created_at, updated_at')
        .eq('user_id', user.id)
        .maybeSingle();
    
    print('[EditProfile] Profile data response: $response');
    
    // If no user exists, return basic data with user metadata
    if (response == null) {
      print('[EditProfile] No user found, using metadata: ${user.userMetadata}');
      return {
        'user_id': user.id,
        'email': user.email ?? '',
        'first_name': user.userMetadata?['first_name'] ?? '',
        'last_name': user.userMetadata?['last_name'] ?? '',
        'profile_image': null,
        'user_phone_number': null,
      };
    }
    
    // Map the response to expected format
    return {
      'id': response['user_id'],
      'email': response['email'],
      'first_name': response['first_name'],
      'last_name': response['last_name'],
      'profile_image': response['profile_image'],
      'phone_number': response['user_phone_number'],
    };
  } catch (e) {
    print('[EditProfile] Error fetching profile: $e');
    // Return basic data on error
    return {
      'id': user.id,
      'email': user.email ?? '',
      'first_name': user.userMetadata?['first_name'] ?? '',
      'last_name': user.userMetadata?['last_name'] ?? '',
      'profile_image': null,
      'phone_number': null,
    };
  }
});

// Provider to fetch user bank account data from users_bank_account table
final userBankAccountProvider = FutureProvider.autoDispose<Map<String, dynamic>?>((ref) async {
  final user = ref.watch(authStateProvider);
  final appState = ref.watch(appStateProvider);
  
  print('[EditProfile] Bank account provider - User: ${user?.id}, Company: ${appState.companyChoosen}');
  
  if (user == null || appState.companyChoosen.isEmpty) {
    print('[EditProfile] Missing required data for bank account query');
    return null;
  }
  
  try {
    final response = await Supabase.instance.client
        .from('users_bank_account')
        .select('user_bank_name, user_account_number, description')
        .eq('user_id', user.id)
        .eq('company_id', appState.companyChoosen)
        .maybeSingle();
    
    print('[EditProfile] Bank account data response: $response');
    return response;
  } catch (e) {
    print('[EditProfile] Error fetching bank account: $e');
    return null;
  }
});

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
  late final TextEditingController _descriptionController;
  
  // Store initial values to detect changes
  String _initialFirstName = '';
  String _initialLastName = '';
  String _initialPhoneNumber = '';
  String _initialBankName = '';
  String _initialBankAccount = '';
  String _initialDescription = '';
  String? _initialProfileImage;
  
  bool _isLoading = false;
  bool _hasChanges = false;
  bool _controllersInitialized = false;
  File? _selectedImage;
  bool _imageRemoved = false;
  bool _isSaving = false; // Prevent double-tap
  
  @override
  void initState() {
    super.initState();
    // Initialize controllers without values first
    _firstNameController = TextEditingController();
    _lastNameController = TextEditingController();
    _phoneNumberController = TextEditingController();
    _bankNameController = TextEditingController();
    _bankAccountController = TextEditingController();
    _descriptionController = TextEditingController();
  }
  
  void _initializeControllers(Map<String, dynamic>? profileData, Map<String, dynamic>? bankAccountData) {
    if (!_controllersInitialized && profileData != null) {
      print('[EditProfile] Initializing controllers with data:');
      print('[EditProfile] Profile data: $profileData');
      print('[EditProfile] Bank account data: $bankAccountData');
      
      // Set initial values - Convert nulls to empty strings
      final firstName = profileData['first_name']?.toString() ?? '';
      final lastName = profileData['last_name']?.toString() ?? '';
      final phoneNumber = profileData['phone_number']?.toString() ?? '';
      
      // Store initial values for change detection
      _initialFirstName = firstName;
      _initialLastName = lastName;
      _initialPhoneNumber = phoneNumber;
      _initialProfileImage = profileData['profile_image']?.toString();
      
      _firstNameController.text = firstName;
      _lastNameController.text = lastName;
      _phoneNumberController.text = phoneNumber;
      
      print('[EditProfile] Set first name: $firstName');
      print('[EditProfile] Set last name: $lastName');
      print('[EditProfile] Set phone: $phoneNumber');
      
      // Use bank account data from users_bank_account table if available
      if (bankAccountData != null) {
        final bankName = bankAccountData['user_bank_name']?.toString() ?? '';
        final accountNumber = bankAccountData['user_account_number']?.toString() ?? '';
        final description = bankAccountData['description']?.toString() ?? '';
        
        _initialBankName = bankName;
        _initialBankAccount = accountNumber;
        _initialDescription = description;
        
        _bankNameController.text = bankName;
        _bankAccountController.text = accountNumber;
        _descriptionController.text = description;
        
        print('[EditProfile] Set bank name from bank account: $bankName');
        print('[EditProfile] Set account number from bank account: $accountNumber');
        print('[EditProfile] Set description: $description');
      } else {
        // Fall back to profile data if no bank account data
        final bankName = profileData['bank_name']?.toString() ?? '';
        final accountNumber = profileData['bank_account_number']?.toString() ?? '';
        
        _initialBankName = bankName;
        _initialBankAccount = accountNumber;
        _initialDescription = '';
        
        _bankNameController.text = bankName;
        _bankAccountController.text = accountNumber;
        
        print('[EditProfile] Set bank name from profile: $bankName');
        print('[EditProfile] Set account number from profile: $accountNumber');
      }
      
      // Add listeners after setting initial values to avoid triggering hasChanges
      _firstNameController.addListener(_onFieldChanged);
      _lastNameController.addListener(_onFieldChanged);
      _phoneNumberController.addListener(_onFieldChanged);
      _bankNameController.addListener(_onFieldChanged);
      _bankAccountController.addListener(_onFieldChanged);
      _descriptionController.addListener(_onFieldChanged);
      
      _controllersInitialized = true;
      print('[EditProfile] Controllers initialized successfully');
    }
  }
  
  void _onFieldChanged() {
    // Only mark as changed if controllers are initialized (to avoid false positives during init)
    if (_controllersInitialized) {
      _checkForChanges();
    }
  }
  
  void _checkForChanges() {
    // Check if any field has actually changed from its initial value
    final hasTextChanges = 
        _firstNameController.text != _initialFirstName ||
        _lastNameController.text != _initialLastName ||
        _phoneNumberController.text != _initialPhoneNumber ||
        _bankNameController.text != _initialBankName ||
        _bankAccountController.text != _initialBankAccount ||
        _descriptionController.text != _initialDescription;
    
    final hasImageChanges = _selectedImage != null || _imageRemoved;
    
    setState(() {
      _hasChanges = hasTextChanges || hasImageChanges;
    });
  }
  
  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _phoneNumberController.dispose();
    _bankNameController.dispose();
    _bankAccountController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Use the new providers to fetch data
    final profileDataAsync = ref.watch(editProfileDataProvider);
    final bankAccountDataAsync = ref.watch(userBankAccountProvider);
    final businessData = ref.watch(businessDashboardDataProvider);
    
    // Handle loading state
    if (profileDataAsync.isLoading || bankAccountDataAsync.isLoading) {
      return TossScaffold(
        backgroundColor: TossColors.background,
        appBar: TossAppBar(
          title: 'Edit Profile',
          backgroundColor: TossColors.background,
        ),
        body: Center(
          child: CircularProgressIndicator(
            color: TossColors.primary,
          ),
        ),
      );
    }
    
    // Handle error state
    if (profileDataAsync.hasError) {
      return TossScaffold(
        backgroundColor: TossColors.background,
        appBar: TossAppBar(
          title: 'Edit Profile',
          backgroundColor: TossColors.background,
        ),
        body: Center(
          child: Text('Error loading profile data'),
        ),
      );
    }
    
    // Get the profile data and bank account data
    final profileData = profileDataAsync.value;
    final bankAccountData = bankAccountDataAsync.value;
    
    // Initialize controllers with fetched data
    _initializeControllers(profileData, bankAccountData);
    
    return TossScaffold(
      backgroundColor: TossColors.background,
      appBar: TossAppBar(
        title: 'Edit Profile',
        backgroundColor: TossColors.background,
        primaryActionText: 'Save',
        onPrimaryAction: _hasChanges && !_isLoading ? _saveProfile : null,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(TossSpacing.screenPaddingMobile),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Profile Avatar Section
              Center(
                child: Column(
                  children: [
                    Stack(
                      children: [
                        Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: TossColors.gray100,
                              width: 3,
                            ),
                          ),
                          child: _selectedImage != null
                              ? CircleAvatar(
                                  radius: 47,
                                  backgroundImage: FileImage(_selectedImage!),
                                )
                              : (profileData?['profile_image'] != null && !_imageRemoved)
                                  ? CircleAvatar(
                                      radius: 47,
                                      backgroundImage: NetworkImage(profileData!['profile_image']),
                                    )
                                  : CircleAvatar(
                                      radius: 47,
                                      backgroundColor: TossColors.primary.withOpacity(0.1),
                                      child: Text(
                                        _getInitials(profileData),
                                        style: TossTextStyles.h2.copyWith(
                                          color: TossColors.primary,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: GestureDetector(
                            onTap: _handleAvatarTap,
                            child: Container(
                              width: 28,
                              height: 28,
                              decoration: BoxDecoration(
                                color: TossColors.primary,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: TossColors.background,
                                  width: 2,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: TossColors.gray900.withOpacity(0.1),
                                    blurRadius: 6,
                                    offset: Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Icon(
                                Icons.camera_alt,
                                size: 14,
                                color: TossColors.background,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: TossSpacing.space4),
                    Text(
                      'Tap to change photo',
                      style: TossTextStyles.caption.copyWith(
                        color: TossColors.gray600,
                      ),
                    ),
                  ],
                ),
              ),
              
              SizedBox(height: TossSpacing.space8),
              
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
                    SizedBox(height: TossSpacing.space4),
                    
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
                      controller: _descriptionController,
                      label: 'Description',
                      hintText: 'Enter description',
                      showKeyboardToolbar: true,
                      textInputAction: TextInputAction.done,
                      maxLines: 3,
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
                    _buildReadOnlyField('Email', profileData?['email'] ?? ''),
                    SizedBox(height: TossSpacing.space4),
                    _buildReadOnlyField('Role', businessData.value?.userRole ?? 'User'),
                    if (businessData.value?.companyName?.isNotEmpty == true) ...[
                      SizedBox(height: TossSpacing.space4),
                      _buildReadOnlyField('Company', businessData.value!.companyName),
                    ],
                    if (businessData.value?.storeName?.isNotEmpty == true) ...[
                      SizedBox(height: TossSpacing.space4),
                      _buildReadOnlyField('Store', businessData.value!.storeName),
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
  
  String _getInitials(Map<String, dynamic>? profileData) {
    if (profileData == null) return 'U';
    
    final firstName = profileData['first_name'] ?? '';
    final lastName = profileData['last_name'] ?? '';
    
    if (firstName.isEmpty && lastName.isEmpty) {
      // Try to get from email
      final email = profileData['email'] ?? '';
      if (email.isNotEmpty) {
        return email[0].toUpperCase();
      }
      return 'U';
    }
    
    String initials = '';
    if (firstName.isNotEmpty) initials += firstName[0].toUpperCase();
    if (lastName.isNotEmpty) initials += lastName[0].toUpperCase();
    
    return initials.isEmpty ? 'U' : initials;
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
            borderRadius: BorderRadius.circular(8),
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
  
  void _handleAvatarTap() {
    HapticFeedback.lightImpact();
    _showImagePickerOptions();
  }

  void _showImagePickerOptions() {
    final profileDataAsync = ref.read(editProfileDataProvider);
    final hasImage = _selectedImage != null || 
                    (profileDataAsync.value?['profile_image'] != null && !_imageRemoved);
    
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: TossColors.background,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                margin: EdgeInsets.symmetric(vertical: TossSpacing.space3),
                decoration: BoxDecoration(
                  color: TossColors.gray300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(TossSpacing.space4),
                child: Column(
                  children: [
                    Text(
                      'Change Profile Picture',
                      style: TossTextStyles.h3.copyWith(
                        fontWeight: FontWeight.w700,
                        color: TossColors.gray900,
                      ),
                    ),
                    SizedBox(height: TossSpacing.space6),
                    _buildImageOption(
                      icon: Icons.camera_alt_outlined,
                      title: 'Take Photo',
                      onTap: () async {
                        Navigator.pop(context);
                        await _pickImage(ImageSource.camera);
                      },
                    ),
                    SizedBox(height: TossSpacing.space3),
                    _buildImageOption(
                      icon: Icons.photo_library_outlined,
                      title: 'Choose from Gallery',
                      onTap: () async {
                        Navigator.pop(context);
                        await _pickImage(ImageSource.gallery);
                      },
                    ),
                    if (hasImage) ...[
                      SizedBox(height: TossSpacing.space3),
                      _buildImageOption(
                        icon: Icons.delete_outline,
                        title: 'Remove Photo',
                        onTap: () {
                          Navigator.pop(context);
                          _removeImage();
                        },
                        isDestructive: true,
                      ),
                    ],
                    SizedBox(height: TossSpacing.space3),
                    _buildImageOption(
                      icon: Icons.close,
                      title: 'Cancel',
                      onTap: () => Navigator.pop(context),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  void _removeImage() {
    setState(() {
      _selectedImage = null;
      _imageRemoved = true;
      _checkForChanges();
    });
  }

  Widget _buildImageOption({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: TossSpacing.space4,
          vertical: TossSpacing.space4,
        ),
        decoration: BoxDecoration(
          color: TossColors.gray50,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 24,
              color: isDestructive ? TossColors.error : TossColors.gray700,
            ),
            SizedBox(width: TossSpacing.space4),
            Expanded(
              child: Text(
                title,
                style: TossTextStyles.bodyLarge.copyWith(
                  fontWeight: FontWeight.w600,
                  color: isDestructive ? TossColors.error : TossColors.gray900,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      // Check permissions
      PermissionStatus status;
      if (source == ImageSource.camera) {
        status = await Permission.camera.request();
      } else {
        status = await Permission.photos.request();
      }
      
      if (!status.isGranted) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Permission denied. Please grant access in settings.'),
              backgroundColor: TossColors.error,
              action: SnackBarAction(
                label: 'Settings',
                onPressed: () => openAppSettings(),
              ),
            ),
          );
        }
        return;
      }
      
      final ImagePicker picker = ImagePicker();
      final XFile? pickedFile = await picker.pickImage(
        source: source,
        imageQuality: 80,
        maxWidth: 1024,
        maxHeight: 1024,
      );
      
      if (pickedFile != null) {
        setState(() {
          _selectedImage = File(pickedFile.path);
          _imageRemoved = false;
          _checkForChanges();
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error picking image: $e'),
            backgroundColor: TossColors.error,
          ),
        );
      }
    }
  }

  
  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;
    
    // Prevent double-tap
    if (_isSaving) return;
    
    setState(() {
      _isSaving = true;
      _isLoading = true;
    });
    
    // Show loading overlay
    if (!mounted) return;
    TossLoadingOverlay.show(
      context: context,
      message: 'Saving profile...',
    );
    
    try {
      // Add a small delay for better UX
      await Future.delayed(const Duration(milliseconds: 800));
      
      final user = ref.read(authStateProvider);
      final appState = ref.read(appStateProvider);
      
      if (user == null) {
        throw Exception('User not authenticated');
      }
      
      // Determine profile image URL
      String? profileImageUrl;
      if (_selectedImage != null) {
        // Upload new image and get URL
        final imagePath = 'profile_images/${user.id}/${DateTime.now().millisecondsSinceEpoch}.jpg';
        final uploadResponse = await Supabase.instance.client.storage
            .from('icon')
            .upload(imagePath, _selectedImage!);
        
        if (uploadResponse.isNotEmpty) {
          // Get the public URL
          profileImageUrl = Supabase.instance.client.storage
              .from('icon')
              .getPublicUrl(imagePath);
        }
      } else if (_imageRemoved) {
        // Set to null if image was removed
        profileImageUrl = null;
      } else {
        // Keep existing image URL
        final currentData = ref.read(editProfileDataProvider).value;
        profileImageUrl = currentData?['profile_image'];
      }
      
      // Update personal info in users table
      final personalInfoUpdates = <String, dynamic>{
        'first_name': _firstNameController.text.trim().isEmpty ? null : _firstNameController.text.trim(),
        'last_name': _lastNameController.text.trim().isEmpty ? null : _lastNameController.text.trim(),
        'user_phone_number': _phoneNumberController.text.trim().isEmpty ? null : _phoneNumberController.text.trim(),
        'updated_at': DateTime.now().toIso8601String(),
      };
      
      // Only include profile_image if it changed
      if (_selectedImage != null || _imageRemoved) {
        personalInfoUpdates['profile_image'] = profileImageUrl;
      }
      
      await Supabase.instance.client
          .from('users')
          .update(personalInfoUpdates)
          .eq('user_id', user.id);
      
      print('[EditProfile] Updated users table with: $personalInfoUpdates');
      
      // Update bank account data in users_bank_account table
      if (appState.companyChoosen.isNotEmpty) {
        final bankName = _bankNameController.text.trim();
        final accountNumber = _bankAccountController.text.trim();
        final description = _descriptionController.text.trim();
        
        // Check if any bank fields have values
        if (bankName.isNotEmpty || accountNumber.isNotEmpty || description.isNotEmpty) {
          // Check if record exists
          final existingRecord = await Supabase.instance.client
              .from('users_bank_account')
              .select()
              .eq('user_id', user.id)
              .eq('company_id', appState.companyChoosen)
              .maybeSingle();
          
          if (existingRecord != null) {
            // Update existing record
            await Supabase.instance.client
                .from('users_bank_account')
                .update({
                  'user_bank_name': bankName.isEmpty ? null : bankName,
                  'user_account_number': accountNumber.isEmpty ? null : accountNumber,
                  'description': description.isEmpty ? null : description,
                  'updated_at': DateTime.now().toIso8601String(),
                })
                .eq('user_id', user.id)
                .eq('company_id', appState.companyChoosen);
            
            print('[EditProfile] Updated users_bank_account table');
          } else {
            // Insert new record only if at least one field has value
            await Supabase.instance.client
                .from('users_bank_account')
                .insert({
                  'user_id': user.id,
                  'company_id': appState.companyChoosen,
                  'user_bank_name': bankName.isEmpty ? null : bankName,
                  'user_account_number': accountNumber.isEmpty ? null : accountNumber,
                  'description': description.isEmpty ? null : description,
                  'created_at': DateTime.now().toIso8601String(),
                  'updated_at': DateTime.now().toIso8601String(),
                });
            
            print('[EditProfile] Inserted new users_bank_account record');
          }
        }
      }
      
      // Update initial values after successful save
      _initialFirstName = _firstNameController.text.trim();
      _initialLastName = _lastNameController.text.trim();
      _initialPhoneNumber = _phoneNumberController.text.trim();
      _initialBankName = _bankNameController.text.trim();
      _initialBankAccount = _bankAccountController.text.trim();
      _initialDescription = _descriptionController.text.trim();
      
      setState(() {
        _hasChanges = false;
        _selectedImage = null;
        _imageRemoved = false;
        _isLoading = false;
        _isSaving = false;
      });
      
      // Refresh the profile data to show updated values
      ref.invalidate(editProfileDataProvider);
      ref.invalidate(userBankAccountProvider);
      ref.invalidate(currentUserProfileProvider);
      ref.invalidate(userProfileProvider);
      
      if (mounted) {
        // Hide loading overlay
        TossLoadingOverlay.hide(context);
        
        // Show success dialog
        await TossResultDialog.showSuccess(
          context: context,
          title: 'Profile Updated',
          message: 'Your profile has been successfully updated.',
          autoDismiss: true,
          autoDismissDelay: const Duration(seconds: 2),
          onButtonPressed: () {
            if (mounted) {
              context.safePop();
            }
          },
        );
        
        // Navigate back after dialog auto-dismisses
        if (mounted) {
          context.safePop();
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _isSaving = false;
        });
        
        // Hide loading overlay
        TossLoadingOverlay.hide(context);
        
        // Show error dialog
        await TossResultDialog.showError(
          context: context,
          title: 'Update Failed',
          message: 'Failed to update profile. Please try again.',
          buttonText: 'OK',
        );
      }
    }
  }
}