import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../../../../core/themes/toss_colors.dart';
import '../../../../core/themes/toss_spacing.dart';
import '../../../../core/themes/toss_border_radius.dart';
import '../../../../core/themes/toss_text_styles.dart';
import '../../../widgets/common/toss_scaffold.dart';
import '../../../widgets/common/toss_app_bar.dart';
import '../../../widgets/toss/toss_card.dart';
import '../../../widgets/toss/toss_enhanced_text_field.dart';
import '../../../providers/user_profile_provider.dart';
import '../../../services/profile_image_service.dart';
import '../../../../core/navigation/safe_navigation.dart';

class EditProfilePage extends ConsumerStatefulWidget {
  const EditProfilePage({super.key});

  @override
  ConsumerState<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends ConsumerState<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _phoneNumberController = TextEditingController();
  final _bankNameController = TextEditingController();
  final _bankAccountController = TextEditingController();
  
  bool _isLoading = false;
  bool _hasChanges = false;
  bool _hasInitialized = false;
  File? _selectedImage;
  
  @override
  void initState() {
    super.initState();
    // Listen for changes
    _firstNameController.addListener(_onFieldChanged);
    _lastNameController.addListener(_onFieldChanged);
    _phoneNumberController.addListener(_onFieldChanged);
    _bankNameController.addListener(_onFieldChanged);
    _bankAccountController.addListener(_onFieldChanged);
  }
  
  void _onFieldChanged() {
    setState(() {
      _hasChanges = true;
    });
  }
  
  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _phoneNumberController.dispose();
    _bankNameController.dispose();
    _bankAccountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final profileAsync = ref.watch(currentUserProfileProvider);
    final profile = profileAsync.value;
    final businessData = ref.watch(businessDashboardDataProvider);
    
    // Initialize form fields if profile is available and fields are empty
    if (profile != null && !_hasInitialized) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _firstNameController.text = profile.firstName ?? '';
        _lastNameController.text = profile.lastName ?? '';
        _phoneNumberController.text = profile.phoneNumber ?? '';
        _bankNameController.text = profile.bankName ?? '';
        _bankAccountController.text = profile.bankAccountNumber ?? '';
        setState(() {
          _hasInitialized = true;
        });
      });
    }
    
    return TossScaffold(
      backgroundColor: TossColors.surface,
      appBar: TossAppBar(
        title: 'Edit Profile',
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
                              : profile?.hasProfileImage == true
                                  ? CircleAvatar(
                                      radius: 47,
                                      backgroundImage: NetworkImage(profile!.profileImage!),
                                    )
                                  : CircleAvatar(
                                      radius: 47,
                                      backgroundColor: TossColors.primary.withValues(alpha: 0.1),
                                      child: Text(
                                        profile?.initials ?? 'U',
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
                                  color: TossColors.surface,
                                  width: 2,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: TossColors.gray900.withValues(alpha: 0.1),
                                    blurRadius: 6,
                                    offset: Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Icon(
                                Icons.camera_alt,
                                size: 14,
                                color: TossColors.surface,
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
                      textInputAction: TextInputAction.done,
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
                    _buildReadOnlyField('Email', profile?.email ?? ''),
                    SizedBox(height: TossSpacing.space4),
                    _buildReadOnlyField('Role', businessData.value?.userRole ?? profile?.displayRole ?? ''),
                    if (profile?.companyName?.isNotEmpty == true) ...[
                      SizedBox(height: TossSpacing.space4),
                      _buildReadOnlyField('Company', profile!.companyName!),
                    ],
                    if (profile?.storeName?.isNotEmpty == true) ...[
                      SizedBox(height: TossSpacing.space4),
                      _buildReadOnlyField('Store', profile!.storeName!),
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
  
  void _handleAvatarTap() {
    HapticFeedback.lightImpact();
    _showImagePickerOptions();
  }

  void _showImagePickerOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: TossColors.surface,
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
                  borderRadius: BorderRadius.circular(TossBorderRadius.micro),
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

  Widget _buildImageOption({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(TossBorderRadius.lg),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: TossSpacing.space4,
          vertical: TossSpacing.space4,
        ),
        decoration: BoxDecoration(
          color: TossColors.gray50,
          borderRadius: BorderRadius.circular(TossBorderRadius.lg),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 24,
              color: TossColors.gray700,
            ),
            SizedBox(width: TossSpacing.space4),
            Expanded(
              child: Text(
                title,
                style: TossTextStyles.bodyLarge.copyWith(
                  fontWeight: FontWeight.w600,
                  color: TossColors.gray900,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    final imageFile = await ProfileImageService.pickImage(source, context);
    if (imageFile != null) {
      setState(() {
        _selectedImage = imageFile;
        _hasChanges = true;
      });
      await _uploadProfileImage(imageFile);
    }
  }

  Future<void> _uploadProfileImage(File imageFile) async {
    setState(() {
      _isLoading = true;
    });

    try {
      await ProfileImageService.uploadProfileImage(imageFile, ref);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Profile picture updated successfully'),
            backgroundColor: TossColors.success,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString()),
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
  
  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;
    
    setState(() {
      _isLoading = true;
    });
    
    try {
      final userProfileService = ref.read(userProfileServiceProvider.notifier);
      
      final phoneValue = _phoneNumberController.text.trim().isEmpty ? null : _phoneNumberController.text.trim();
      
      await userProfileService.updateProfile(
        firstName: _firstNameController.text.trim(),
        lastName: _lastNameController.text.trim(),
        phoneNumber: phoneValue,
        bankName: _bankNameController.text.trim().isEmpty ? null : _bankNameController.text.trim(),
        bankAccountNumber: _bankAccountController.text.trim().isEmpty ? null : _bankAccountController.text.trim(),
      );
      
      setState(() {
        _hasChanges = false;
      });
      
      // Refresh the profile data to show updated values
      ref.invalidate(currentUserProfileProvider);
      
      if (mounted) {
        HapticFeedback.lightImpact();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Profile updated successfully'),
            backgroundColor: TossColors.success,
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