import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../app/providers/app_state_provider.dart';
import '../../../../app/providers/auth_providers.dart';
import '../../../../core/constants/auth_constants.dart';
import '../../../../shared/themes/index.dart';
import '../../../homepage/presentation/providers/homepage_providers.dart';
import '../providers/repository_providers.dart';
import 'package:myfinance_improved/shared/widgets/index.dart';

/// Complete Profile Page - For Email Signup and Apple Sign-In Users
///
/// This page is shown when the user's first_name is NULL in the database.
/// This happens for:
/// - Email signup (name collected here instead of signup form)
/// - Apple Sign-In (we don't auto-save Apple's name)
///
/// Note: Google Sign-In auto-fetches name/photo from Google account,
/// so Google users typically don't see this page.
///
/// Flow:
/// 1. Email signup → OTP verification → this page
/// 2. Apple Sign-In → this page (first_name is NULL)
/// 3. User enters first name (required), last name (required), and profile photo (optional)
/// 4. Save to database → redirect to Choose Role page
class CompleteProfilePage extends ConsumerStatefulWidget {
  const CompleteProfilePage({super.key});

  @override
  ConsumerState<CompleteProfilePage> createState() => _CompleteProfilePageState();
}

class _CompleteProfilePageState extends ConsumerState<CompleteProfilePage>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _firstNameFocusNode = FocusNode();
  final _lastNameFocusNode = FocusNode();

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  bool _isLoading = false;
  bool _isFirstNameValid = false;
  bool _isLastNameValid = false;

  // Profile image
  File? _selectedImage;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      duration: TossAnimations.normal,
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: TossAnimations.standard,
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.2),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: TossAnimations.standard,
    ));

    _firstNameController.addListener(_validateFirstName);
    _lastNameController.addListener(_validateLastName);

    _animationController.forward();
  }

  void _validateFirstName() {
    final isValid = _firstNameController.text.trim().isNotEmpty;
    if (isValid != _isFirstNameValid) {
      setState(() => _isFirstNameValid = isValid);
    }
  }

  void _validateLastName() {
    final isValid = _lastNameController.text.trim().isNotEmpty;
    if (isValid != _isLastNameValid) {
      setState(() => _isLastNameValid = isValid);
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _firstNameFocusNode.dispose();
    _lastNameFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TossColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: TossSpacing.space4 * 2),
          child: SlideTransition(
            position: _slideAnimation,
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    const SizedBox(height: 60),

                    // Profile Image Picker
                    _buildProfileImagePicker(),

                    const SizedBox(height: TossSpacing.space5),

                    // Title
                    Text(
                      'Complete Your Profile',
                      style: TossTextStyles.h1.copyWith(
                        color: TossColors.textPrimary,
                        fontWeight: FontWeight.w800,
                        fontSize: 28,
                        letterSpacing: -0.6,
                      ),
                    ),

                    const SizedBox(height: TossSpacing.space2),

                    // Subtitle
                    Text(
                      'Add your name and photo to personalize your account',
                      textAlign: TextAlign.center,
                      style: TossTextStyles.body.copyWith(
                        color: TossColors.textSecondary,
                        height: 1.5,
                      ),
                    ),

                    const SizedBox(height: TossSpacing.space8),

                    // Form Fields
                    _buildNameFields(),

                    const SizedBox(height: TossSpacing.space8),

                    // Continue Button
                    _buildContinueButton(),

                    const SizedBox(height: TossSpacing.space8),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProfileImagePicker() {
    return GestureDetector(
      onTap: _isLoading ? null : _showImagePickerOptions,
      child: Stack(
        children: [
          // Avatar circle
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: TossColors.gray100,
              shape: BoxShape.circle,
              border: Border.all(
                color: TossColors.gray200,
                width: 2,
              ),
              image: _selectedImage != null
                  ? DecorationImage(
                      image: FileImage(_selectedImage!),
                      fit: BoxFit.cover,
                    )
                  : null,
            ),
            child: _selectedImage == null
                ? Icon(
                    Icons.person_rounded,
                    size: 60,
                    color: TossColors.gray400,
                  )
                : null,
          ),

          // Camera icon overlay
          Positioned(
            bottom: 0,
            right: 0,
            child: Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: TossColors.primary,
                shape: BoxShape.circle,
                border: Border.all(
                  color: TossColors.white,
                  width: 2,
                ),
              ),
              child: const Icon(
                Icons.camera_alt_rounded,
                size: 18,
                color: TossColors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showImagePickerOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: TossColors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: TossSpacing.space4),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Handle bar
              Container(
                width: TossSpacing.iconXL,
                height: 4,
                margin: const EdgeInsets.only(bottom: TossSpacing.space4),
                decoration: BoxDecoration(
                  color: TossColors.gray300,
                  borderRadius: BorderRadius.circular(TossBorderRadius.xs / 2),
                ),
              ),

              // Title
              Padding(
                padding: const EdgeInsets.only(bottom: TossSpacing.space4),
                child: Text(
                  'Choose Photo',
                  style: TossTextStyles.h3.copyWith(
                    color: TossColors.textPrimary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),

              // Camera option
              ListTile(
                leading: Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: TossColors.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(TossBorderRadius.lg),
                  ),
                  child: Icon(
                    Icons.camera_alt_rounded,
                    color: TossColors.primary,
                  ),
                ),
                title: Text(
                  'Take Photo',
                  style: TossTextStyles.body.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.camera);
                },
              ),

              // Gallery option
              ListTile(
                leading: Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: TossColors.success.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(TossBorderRadius.lg),
                  ),
                  child: Icon(
                    Icons.photo_library_rounded,
                    color: TossColors.success,
                  ),
                ),
                title: Text(
                  'Choose from Gallery',
                  style: TossTextStyles.body.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.gallery);
                },
              ),

              // Remove photo option (if photo selected)
              if (_selectedImage != null)
                ListTile(
                  leading: Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: TossColors.error.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(TossBorderRadius.lg),
                    ),
                    child: Icon(
                      Icons.delete_outline_rounded,
                      color: TossColors.error,
                    ),
                  ),
                  title: Text(
                    'Remove Photo',
                    style: TossTextStyles.body.copyWith(
                      fontWeight: FontWeight.w600,
                      color: TossColors.error,
                    ),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    setState(() => _selectedImage = null);
                  },
                ),

              const SizedBox(height: TossSpacing.space2),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(
        source: source,
        maxWidth: 400,
        maxHeight: 400,
        imageQuality: 50,
      );

      if (pickedFile != null) {
        setState(() {
          _selectedImage = File(pickedFile.path);
        });
      }
    } catch (e) {
      if (mounted) {
        TossToast.error(context, 'Failed to pick image: $e');
      }
    }
  }

  Widget _buildNameFields() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // First Name
        Text(
          'First Name',
          style: TossTextStyles.label.copyWith(
            color: TossColors.textPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: TossSpacing.space2),
        TossTextField(
          controller: _firstNameController,
          focusNode: _firstNameFocusNode,
          hintText: 'Enter your first name',
          textInputAction: TextInputAction.next,
          onFieldSubmitted: (_) => _lastNameFocusNode.requestFocus(),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'First name is required';
            }
            return null;
          },
        ),

        const SizedBox(height: TossSpacing.space4),

        // Last Name
        Text(
          'Last Name',
          style: TossTextStyles.label.copyWith(
            color: TossColors.textPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: TossSpacing.space2),
        TossTextField(
          controller: _lastNameController,
          focusNode: _lastNameFocusNode,
          hintText: 'Enter your last name',
          textInputAction: TextInputAction.done,
          onFieldSubmitted: (_) => _handleContinue(),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Last name is required';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildContinueButton() {
    final canContinue = _isFirstNameValid && _isLastNameValid && !_isLoading;

    return TossButton.primary(
      text: 'Continue',
      onPressed: canContinue ? _handleContinue : null,
      isLoading: _isLoading,
      fullWidth: true,
      height: TossSpacing.icon3XL,
    );
  }

  Future<void> _handleContinue() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final userId = ref.read(currentUserIdProvider);
      if (userId == null) {
        throw Exception('User not authenticated');
      }

      final firstName = _firstNameController.text.trim();
      final lastName = _lastNameController.text.trim();

      // Update profile via Repository (handles image upload internally)
      final userRepository = ref.read(userRepositoryProvider);
      final updatedUser = await userRepository.updateProfile(
        userId: userId,
        firstName: firstName,
        lastName: lastName,
        profileImagePath: _selectedImage?.path,
      );

      // Invalidate user companies provider to refresh data
      ref.invalidate(userCompaniesProvider);

      // Update AppState with new user info
      final appStateNotifier = ref.read(appStateProvider.notifier);
      final currentUser = ref.read(appStateProvider).user;

      appStateNotifier.updateUser(
        user: {
          ...currentUser,
          'user_first_name': firstName,
          'user_last_name': lastName,
          if (updatedUser.profileImage != null) 'user_profile_image': updatedUser.profileImage,
        },
        isAuthenticated: true,
      );

      if (!mounted) return;

      // Show success message
      TossToast.success(context, 'Welcome, $firstName!');

      // Navigate to onboarding (choose role)
      if (mounted) {
        context.go('/onboarding/choose-role');
      }
    } catch (e) {
      if (mounted) {
        TossToast.error(context, 'Failed to save profile: $e');
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }
}
