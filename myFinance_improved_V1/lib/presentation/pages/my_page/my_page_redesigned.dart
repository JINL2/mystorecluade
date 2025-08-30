import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../../core/themes/toss_colors.dart';
import '../../../core/themes/toss_spacing.dart';
import '../../../core/themes/toss_border_radius.dart';
import '../../../core/themes/toss_text_styles.dart';
import '../../../core/constants/ui_constants.dart';
import '../../widgets/common/toss_scaffold.dart';
import '../../widgets/toss/toss_card.dart';
import '../../providers/user_profile_provider.dart';
import '../../../domain/entities/user_profile.dart';
import '../../services/profile_image_service.dart';
import '../../../core/navigation/safe_navigation.dart';

/// Modern finance app-inspired My Page with comprehensive analytics
class MyPageRedesigned extends ConsumerStatefulWidget {
  const MyPageRedesigned({super.key});

  @override
  ConsumerState<MyPageRedesigned> createState() => _MyPageRedesignedState();
}

class _MyPageRedesignedState extends ConsumerState<MyPageRedesigned> 
    with TickerProviderStateMixin {
  late AnimationController _entryController;
  late ScrollController _scrollController;
  late List<Animation<double>> _animations;
  
  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _setupAnimations();
    _entryController.forward();
  }

  void _setupAnimations() {
    _entryController = AnimationController(
      duration: Duration(milliseconds: UIConstants.extendedAnimationMs),
      vsync: this,
    );

    // Only create the animations we actually use
    _animations = [
      Tween<double>(begin: 0, end: 1).animate(
        CurvedAnimation(
          parent: _entryController,
          curve: Interval(0, 0.3, curve: Curves.easeOutCubic),
        ),
      ),
      Tween<double>(begin: 0, end: 1).animate(
        CurvedAnimation(
          parent: _entryController,
          curve: Interval(0.1, 0.4, curve: Curves.easeOutCubic),
        ),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final userProfile = ref.watch(currentUserProfileProvider).value;
    final businessData = ref.watch(businessDashboardDataProvider);
    
    return TossScaffold(
      backgroundColor: TossColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // App Bar - matching attendance page style
            Container(
              color: TossColors.background,
              child: Column(
                children: [
                  // Title Bar
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: TossSpacing.space5,
                      vertical: TossSpacing.space4,
                    ),
                    child: Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.arrow_back_ios, size: 24),
                          onPressed: () => context.safePop(),
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                        ),
                        const Spacer(),
                        Text(
                          'Account',
                          style: TossTextStyles.h3.copyWith(
                            color: TossColors.gray900,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const Spacer(),
                        const SizedBox(width: 24), // Balance for back button
                      ],
                    ),
                  ),
                ],
              ),
            ),
            
            // Body content
            Expanded(
              child: RefreshIndicator(
                onRefresh: _handleRefresh,
                color: TossColors.primary,
                child: SingleChildScrollView(
                  controller: _scrollController,
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    children: [
                      // Main Profile Section - User's Account Information
                      FadeTransition(
                        opacity: _animations[0],
                        child: _buildMainProfileSection(userProfile, businessData.value),
                      ),
                      
                      // Account Settings Section
                      FadeTransition(
                        opacity: _animations[1],
                        child: _buildAccountSettingsSection(),
                      ),
                      
                      // Bottom spacing
                      SizedBox(height: TossSpacing.space12), // More breathing space at bottom
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMainProfileSection(UserProfile? profile, BusinessDashboardData? businessData) {
    if (profile == null) return const SizedBox.shrink();

    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: TossSpacing.screenPaddingMobile,
        vertical: TossSpacing.space6, // Reduced breathing space
      ),
      child: Column(
        children: [
          // Hero Profile Section
          Column(
            children: [
              // Large Avatar with better spacing
              GestureDetector(
                onTap: _handleAvatarTap,
                child: Stack(
                  children: [
                    Container(
                      width: 120, // Much larger avatar
                      height: 120,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: TossColors.gray100,
                          width: 4,
                        ),
                      ),
                      child: profile.hasProfileImage
                          ? CircleAvatar(
                              radius: 56,
                              backgroundImage: NetworkImage(profile.profileImage!),
                            )
                          : CircleAvatar(
                              radius: 56,
                              backgroundColor: TossColors.primary.withValues(alpha: 0.1),
                              child: Text(
                                profile.initials,
                                style: TossTextStyles.display.copyWith(
                                  color: TossColors.primary,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                    ),
                    // Edit indicator
                    Positioned(
                      bottom: 4,
                      right: 4,
                      child: Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: TossColors.primary,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: TossColors.surface,
                            width: 3,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: TossColors.gray900.withValues(alpha: 0.1),
                              blurRadius: 8,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Icon(
                          Icons.camera_alt,
                          size: 16,
                          color: TossColors.surface,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              
              SizedBox(height: TossSpacing.space8), // More breathing space
              
              // Name - Much larger and prominent
              Text(
                _getDisplayName(profile),
                style: TossTextStyles.h1.copyWith(
                  fontWeight: FontWeight.w800,
                  color: TossColors.gray900,
                ),
                textAlign: TextAlign.center,
              ),
              
              SizedBox(height: TossSpacing.space3),
              
              // Role badge - cleaner design
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: TossSpacing.space4,
                  vertical: TossSpacing.space2,
                ),
                decoration: BoxDecoration(
                  color: TossColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(TossBorderRadius.xxl),
                ),
                child: Text(
                  businessData?.userRole ?? profile.displayRole,
                  style: TossTextStyles.labelLarge.copyWith(
                    color: TossColors.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              
              SizedBox(height: TossSpacing.space4),
              
              // Clean info display
              if (businessData?.companyName.isNotEmpty == true)
                Text(
                  businessData!.companyName,
                  style: TossTextStyles.bodyLarge.copyWith(
                    color: TossColors.gray700,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),
              
              if (businessData?.storeName.isNotEmpty == true) ...[
                SizedBox(height: TossSpacing.space1),
                Text(
                  businessData!.storeName,
                  style: TossTextStyles.body.copyWith(
                    color: TossColors.gray600,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }



  Widget _buildAccountSettingsSection() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: TossSpacing.screenPaddingMobile),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Settings',
            style: TossTextStyles.h2.copyWith(
              fontWeight: FontWeight.w700,
              color: TossColors.gray900,
            ),
          ),
          SizedBox(height: TossSpacing.space6),
          
          // Settings List - Cleaner design
          TossCard(
            padding: EdgeInsets.zero,
            child: Column(
              children: [
                _buildCleanSettingsItem(
                  Icons.person_outline,
                  'Edit Profile',
                  () => _navigateToEditProfile(),
                ),
                _buildCleanSettingsItem(
                  Icons.notifications_outlined,
                  'Notifications',
                  () => _navigateToNotifications(),
                ),
                _buildCleanSettingsItem(
                  Icons.security_outlined,
                  'Privacy & Security',
                  () => _navigateToPrivacySecurity(),
                ),
                _buildCleanSettingsItem(
                  Icons.logout,
                  'Sign Out',
                  () => _handleSignOut(),
                  isDestructive: true,
                ),
              ],
            ),
          ),
          
          SizedBox(height: TossSpacing.space12), // More breathing space
        ],
      ),
    );
  }

  String _getDisplayName(UserProfile profile) {
    // If we have first name or last name, use fullName (which combines them)
    if ((profile.firstName?.isNotEmpty == true) || (profile.lastName?.isNotEmpty == true)) {
      return profile.fullName;
    }
    
    // If no names available, extract name from email or use 'User'
    final email = profile.email;
    if (email.isNotEmpty) {
      // Try to extract a reasonable name from email (e.g., "john.doe@example.com" → "John Doe")
      final localPart = email.split('@').first;
      if (localPart.contains('.')) {
        final parts = localPart.split('.');
        return parts.map((part) => part.isEmpty ? '' : part[0].toUpperCase() + part.substring(1)).join(' ');
      } else if (localPart.contains('_')) {
        final parts = localPart.split('_');
        return parts.map((part) => part.isEmpty ? '' : part[0].toUpperCase() + part.substring(1)).join(' ');
      } else {
        // Single word email, capitalize it
        return localPart.isEmpty ? 'User' : localPart[0].toUpperCase() + localPart.substring(1);
      }
    }
    
    return 'User';
  }

  Widget _buildCleanSettingsItem(
    IconData icon,
    String title,
    VoidCallback onTap, {
    bool isDestructive = false,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(TossSpacing.space4),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: (isDestructive ? TossColors.error : TossColors.gray500).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(TossBorderRadius.buttonLarge),
              ),
              child: Icon(
                icon,
                size: 20,
                color: isDestructive ? TossColors.error : TossColors.gray700,
              ),
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
            Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: TossColors.gray400,
            ),
          ],
        ),
      ),
    );
  }

  






  // Navigation methods
  Future<void> _handleRefresh() async {
    HapticFeedback.mediumImpact();
    
    // Refresh business dashboard data
    ref.invalidate(businessDashboardDataProvider);
    
    await Future.delayed(const Duration(seconds: 1));
  }

  void _handleAvatarTap() {
    HapticFeedback.lightImpact();
    _showAvatarOptions();
  }

  void _showAvatarOptions() {
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
                    _buildAvatarOption(
                      icon: Icons.camera_alt_outlined,
                      title: 'Take Photo',
                      onTap: () async {
                        Navigator.pop(context);
                        // Check camera permission first
                        final status = await Permission.camera.status;
                        if (!status.isGranted) {
                          final result = await Permission.camera.request();
                          if (result.isGranted) {
                            _pickImage(ImageSource.camera);
                          } else {
                            _showPermissionDeniedDialog();
                          }
                        } else {
                          _pickImage(ImageSource.camera);
                        }
                      },
                    ),
                    SizedBox(height: TossSpacing.space3),
                    _buildAvatarOption(
                      icon: Icons.photo_library_outlined,
                      title: 'Choose from Gallery',
                      onTap: () async {
                        Navigator.pop(context);
                        // Check permission first
                        final status = await Permission.photos.status;
                        if (!status.isGranted) {
                          final result = await Permission.photos.request();
                          if (result.isGranted) {
                            _pickImage(ImageSource.gallery);
                          } else {
                            _showPermissionDeniedDialog();
                          }
                        } else {
                          _pickImage(ImageSource.gallery);
                        }
                      },
                    ),
                    if (ref.read(currentUserProfileProvider).value?.hasProfileImage == true) ...[
                      SizedBox(height: TossSpacing.space3),
                      _buildAvatarOption(
                        icon: Icons.delete_outline,
                        title: 'Remove Photo',
                        onTap: () {
                          Navigator.pop(context);
                          _removeProfileImage();
                        },
                        isDestructive: true,
                      ),
                    ],
                    SizedBox(height: TossSpacing.space3),
                    _buildAvatarOption(
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

  Widget _buildAvatarOption({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    bool isDestructive = false,
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
    final imageFile = await ProfileImageService.pickImage(source, context);
    if (imageFile != null) {
      await _uploadProfileImage(imageFile);
    }
  }

  Future<void> _uploadProfileImage(File imageFile) async {
    // Show loading indicator
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Center(
        child: Container(
          padding: EdgeInsets.all(TossSpacing.space6),
          decoration: BoxDecoration(
            color: TossColors.surface,
            borderRadius: BorderRadius.circular(TossBorderRadius.lg),
          ),
          child: CircularProgressIndicator(
            color: TossColors.primary,
          ),
        ),
      ),
    );

    try {
      await ProfileImageService.uploadProfileImage(imageFile, ref);
      
      if (mounted) {
        Navigator.pop(context); // Close loading dialog
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Profile picture updated successfully'),
            backgroundColor: TossColors.success,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        Navigator.pop(context); // Close loading dialog
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString()),
            backgroundColor: TossColors.error,
          ),
        );
      }
    }
  }

  Future<void> _removeProfileImage() async {
    // Show loading indicator
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Center(
        child: Container(
          padding: EdgeInsets.all(TossSpacing.space6),
          decoration: BoxDecoration(
            color: TossColors.surface,
            borderRadius: BorderRadius.circular(TossBorderRadius.lg),
          ),
          child: CircularProgressIndicator(
            color: TossColors.primary,
          ),
        ),
      ),
    );

    try {
      await ProfileImageService.removeProfileImage(ref);
      
      if (mounted) {
        Navigator.pop(context); // Close loading dialog
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Profile picture removed'),
            backgroundColor: TossColors.success,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        Navigator.pop(context); // Close loading dialog
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString()),
            backgroundColor: TossColors.error,
          ),
        );
      }
    }
  }

  void _showPermissionDeniedDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Permission Required'),
        content: Text('This app needs access to your photos to change your profile picture. Please enable photo access in Settings.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              openAppSettings();
            },
            child: Text('Open Settings'),
          ),
        ],
      ),
    );
  }

  void _navigateToEditProfile() {
    HapticFeedback.lightImpact();
    context.safePush('/edit-profile');
  }

  void _navigateToNotifications() {
    HapticFeedback.lightImpact();
    context.safePush('/notifications-settings');
  }

  void _navigateToPrivacySecurity() {
    HapticFeedback.lightImpact();
    context.safePush('/privacy-security');
  }

  void _handleSignOut() async {
    HapticFeedback.lightImpact();
    // Show confirmation dialog
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Sign Out'),
        content: Text('Are you sure you want to sign out?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(
              foregroundColor: TossColors.error,
            ),
            child: Text('Sign Out'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        await Supabase.instance.client.auth.signOut();
        if (mounted) {
          context.safeGo('/auth/login');
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error signing out: $e'),
              backgroundColor: TossColors.error,
            ),
          );
        }
      }
    }
  }

  @override
  void dispose() {
    _entryController.dispose();
    _scrollController.dispose();
    super.dispose();
  }
}