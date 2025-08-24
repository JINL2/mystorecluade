import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../core/themes/toss_colors.dart';
import '../../../../core/themes/toss_spacing.dart';
import '../../../../core/themes/toss_text_styles.dart';
import '../../../../core/themes/toss_shadows.dart';
import '../../../../core/constants/ui_constants.dart';
import '../../../widgets/common/toss_profile_avatar.dart';
import '../../../widgets/toss/toss_primary_button.dart';
import '../../../../domain/entities/user_profile.dart';
import '../providers/user_profile_provider.dart';

class EditProfileSheet extends ConsumerStatefulWidget {
  final UserProfile profile;

  const EditProfileSheet({
    super.key,
    required this.profile,
  });

  @override
  ConsumerState<EditProfileSheet> createState() => _EditProfileSheetState();
}

class _EditProfileSheetState extends ConsumerState<EditProfileSheet> {
  late final TextEditingController _firstNameController;
  late final TextEditingController _lastNameController;
  late final TextEditingController _emailController;
  
  final _formKey = GlobalKey<FormState>();
  final _imagePicker = ImagePicker();
  File? _selectedImage;
  bool _isChanged = false;

  @override
  void initState() {
    super.initState();
    _firstNameController = TextEditingController(text: widget.profile.firstName ?? '');
    _lastNameController = TextEditingController(text: widget.profile.lastName ?? '');
    _emailController = TextEditingController(text: widget.profile.email);
    
    // Listen for changes
    _firstNameController.addListener(_onFieldChanged);
    _lastNameController.addListener(_onFieldChanged);
  }

  void _onFieldChanged() {
    final hasChanges = _firstNameController.text != (widget.profile.firstName ?? '') ||
                      _lastNameController.text != (widget.profile.lastName ?? '') ||
                      _selectedImage != null;
    
    if (hasChanges != _isChanged) {
      setState(() {
        _isChanged = hasChanges;
      });
    }
  }

  Future<void> _pickImage() async {
    try {
      HapticFeedback.lightImpact();
      
      // Show CupertinoActionSheet for iOS-native experience
      await showCupertinoModalPopup(
        context: context,
        builder: (BuildContext context) => CupertinoActionSheet(
          title: Text('Select Photo Source'),
          actions: [
            CupertinoActionSheetAction(
              onPressed: () async {
                Navigator.pop(context);
                final pickedFile = await _imagePicker.pickImage(
                  source: ImageSource.camera,
                  maxWidth: UIConstants.imageMaxWidth,
                  maxHeight: UIConstants.imageMaxHeight,
                  imageQuality: UIConstants.imageQuality,
                );
                
                if (pickedFile != null) {
                  setState(() {
                    _selectedImage = File(pickedFile.path);
                    _isChanged = true;
                  });
                }
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.camera_alt_rounded, size: 20),
                  SizedBox(width: 8),
                  Text('Camera'),
                ],
              ),
            ),
            CupertinoActionSheetAction(
              onPressed: () async {
                Navigator.pop(context);
                final pickedFile = await _imagePicker.pickImage(
                  source: ImageSource.gallery,
                  maxWidth: UIConstants.imageMaxWidth,
                  maxHeight: UIConstants.imageMaxHeight,
                  imageQuality: UIConstants.imageQuality,
                );
                
                if (pickedFile != null) {
                  setState(() {
                    _selectedImage = File(pickedFile.path);
                    _isChanged = true;
                  });
                }
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.photo_library_rounded, size: 20),
                  SizedBox(width: 8),
                  Text('Photo Library'),
                ],
              ),
            ),
          ],
          cancelButton: CupertinoActionSheetAction(
            isDefaultAction: true,
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text('Cancel'),
          ),
        ),
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to pick image: $e'),
            backgroundColor: TossColors.error,
          ),
        );
      }
    }
  }


  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate() || !_isChanged) return;

    HapticFeedback.lightImpact();

    try {
      final notifier = ref.read(userProfileProvider.notifier);
      
      // Upload image first if selected
      String? imageUrl;
      if (_selectedImage != null) {
        final imageBytes = await _selectedImage!.readAsBytes();
        final fileName = 'profile_${DateTime.now().millisecondsSinceEpoch}.jpg';
        
        final success = await notifier.uploadProfileImage(
          imageBytes: imageBytes,
          fileName: fileName,
        );
        
        if (!success) {
          throw Exception(UIConstants.messageImageUploadFailed);
        }
      }

      // Update profile
      final success = await notifier.updateProfile(
        firstName: _firstNameController.text.trim(),
        lastName: _lastNameController.text.trim(),
      );

      if (mounted) {
        if (success) {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  Icon(
                    Icons.check_circle,
                    color: TossColors.surface,
                    size: UIConstants.iconSizeMedium,
                  ),
                  SizedBox(width: TossSpacing.space2),
                  const Text(UIConstants.messageProfileUpdated),
                ],
              ),
              backgroundColor: TossColors.success,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(UIConstants.borderRadiusMedium),
              ),
            ),
          );
        } else {
          throw Exception(UIConstants.messageProfileUpdateFailed);
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Icon(
                  Icons.error_outline,
                  color: TossColors.surface,
                  size: UIConstants.iconSizeMedium,
                ),
                SizedBox(width: TossSpacing.space2),
                Expanded(
                  child: Text('${UIConstants.messageProfileUpdateFailed}: $e'),
                ),
              ],
            ),
            backgroundColor: TossColors.error,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(UIConstants.borderRadiusMedium),
            ),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isUpdating = ref.watch(isProfileUpdatingProvider);

    return Container(
      decoration: BoxDecoration(
        color: TossColors.surface,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle bar
          Container(
            width: UIConstants.sheetHandleWidth,
            height: UIConstants.sheetHandleHeight,
            margin: EdgeInsets.only(top: TossSpacing.space3),
            decoration: BoxDecoration(
              color: TossColors.gray300,
              borderRadius: BorderRadius.circular(UIConstants.modalDragHandleBorderRadius),
            ),
          ),
          
          // Header
          Padding(
            padding: EdgeInsets.all(TossSpacing.space5),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    'Edit Profile',
                    style: TossTextStyles.h2.copyWith(
                      fontWeight: FontWeight.w700,
                      color: TossColors.gray900,
                      letterSpacing: -0.3,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close),
                  color: TossColors.gray500,
                  iconSize: 24,
                ),
              ],
            ),
          ),
          
          // Content
          Flexible(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: TossSpacing.space5),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Profile Image Section - Using TossProfileAvatar
                    Center(
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          boxShadow: TossShadows.card,
                        ),
                        child: Stack(
                          children: [
                            TossProfileAvatar(
                              imageUrl: _selectedImage == null ? widget.profile.profileImage : null,
                              initials: widget.profile.initials,
                              size: 100,
                              onTap: _pickImage,
                              showBorder: true,
                            ),
                            if (_selectedImage != null)
                              ClipOval(
                                child: Image.file(
                                  _selectedImage!,
                                  width: 100,
                                  height: 100,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            // Edit Icon
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: GestureDetector(
                                onTap: _pickImage,
                                child: Container(
                                  width: 32,
                                  height: 32,
                                  decoration: BoxDecoration(
                                    color: TossColors.primary,
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: TossColors.surface,
                                      width: 2,
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.1),
                                        blurRadius: 4,
                                        offset: const Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: const Icon(
                                    Icons.camera_alt,
                                    color: TossColors.surface,
                                    size: 16,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    
                    SizedBox(height: TossSpacing.space6),
                    
                    // Profile hint text
                    Text(
                      'Tap photo to change your profile picture',
                      style: TossTextStyles.caption.copyWith(
                        color: TossColors.gray500,
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    
                    SizedBox(height: TossSpacing.space6),
                    
                    // Form Fields
                    _buildFormField(
                      label: 'First Name',
                      controller: _firstNameController,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return UIConstants.validationFirstNameRequired;
                        }
                        return null;
                      },
                    ),
                    
                    SizedBox(height: TossSpacing.space5),
                    
                    _buildFormField(
                      label: 'Last Name',
                      controller: _lastNameController,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return UIConstants.validationLastNameRequired;
                        }
                        return null;
                      },
                    ),
                    
                    SizedBox(height: TossSpacing.space5),
                    
                    _buildFormField(
                      label: 'Email',
                      controller: _emailController,
                      enabled: false,
                      suffixIcon: Icons.lock_outline,
                    ),
                    
                    SizedBox(height: TossSpacing.space8),
                  ],
                ),
              ),
            ),
          ),
          
          // Bottom Actions
          Container(
            padding: EdgeInsets.all(TossSpacing.space5),
            decoration: BoxDecoration(
              color: TossColors.surface,
              border: Border(
                top: BorderSide(
                  color: TossColors.gray200,
                  width: 0.5,
                ),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: SafeArea(
              child: TossPrimaryButton(
                text: UIConstants.actionSaveChanges,
                onPressed: _isChanged && !isUpdating ? _saveProfile : null,
                isLoading: isUpdating,
                isEnabled: _isChanged,
                fullWidth: true,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFormField({
    required String label,
    required TextEditingController controller,
    String? Function(String?)? validator,
    bool enabled = true,
    IconData? suffixIcon,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TossTextStyles.bodyLarge.copyWith(
            fontWeight: FontWeight.w600,
            color: TossColors.gray900,
            letterSpacing: -0.1,
          ),
        ),
        SizedBox(height: TossSpacing.space2),
        TextFormField(
          controller: controller,
          validator: validator,
          enabled: enabled,
          style: TossTextStyles.body.copyWith(
            color: enabled ? TossColors.gray900 : TossColors.gray500,
          ),
          decoration: InputDecoration(
            hintText: 'Enter your $label',
            hintStyle: TossTextStyles.body.copyWith(
              color: TossColors.gray400,
            ),
            suffixIcon: suffixIcon != null
                ? Icon(
                    suffixIcon,
                    color: TossColors.gray400,
                    size: UIConstants.iconSizeMedium,
                  )
                : null,
            filled: true,
            fillColor: enabled ? TossColors.gray50 : TossColors.gray100,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(UIConstants.borderRadiusMedium),
              borderSide: BorderSide(
                color: TossColors.gray200,
                width: 1,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(UIConstants.borderRadiusMedium),
              borderSide: BorderSide(
                color: TossColors.gray200,
                width: 1,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(UIConstants.borderRadiusMedium),
              borderSide: BorderSide(
                color: TossColors.primary,
                width: 2,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(UIConstants.borderRadiusMedium),
              borderSide: BorderSide(
                color: TossColors.error,
                width: 1,
              ),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(UIConstants.borderRadiusMedium),
              borderSide: BorderSide(
                color: TossColors.error,
                width: 2,
              ),
            ),
            contentPadding: EdgeInsets.all(TossSpacing.space4),
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    super.dispose();
  }
}