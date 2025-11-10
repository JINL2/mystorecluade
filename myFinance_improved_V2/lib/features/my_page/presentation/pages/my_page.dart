import 'dart:io';
import 'package:go_router/go_router.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:myfinance_improved/core/navigation/safe_navigation.dart';
import 'package:myfinance_improved/shared/themes/toss_colors.dart';
import 'package:myfinance_improved/shared/themes/toss_spacing.dart';
import 'package:myfinance_improved/shared/themes/toss_text_styles.dart';
import 'package:myfinance_improved/shared/widgets/common/toss_loading_view.dart';
import 'package:myfinance_improved/shared/widgets/common/toss_scaffold.dart';
import 'package:myfinance_improved/shared/widgets/common/toss_confirm_cancel_dialog.dart';
import 'package:myfinance_improved/shared/widgets/common/toss_success_error_dialog.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../providers/user_profile_providers.dart';
import '../widgets/profile_avatar_section.dart';
import '../widgets/profile_header_section.dart';
import '../widgets/settings_section.dart';

class MyPage extends ConsumerStatefulWidget {
  const MyPage({super.key});

  @override
  ConsumerState<MyPage> createState() => _MyPageState();
}

class _MyPageState extends ConsumerState<MyPage> with TickerProviderStateMixin {
  late AnimationController _entryController;
  late ScrollController _scrollController;
  late List<Animation<double>> _animations;

  // Local state for optimistic UI updates
  String? _temporaryProfileImageUrl;
  bool _isUploadingImage = false;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _setupAnimations();
    _entryController.forward();
  }

  void _setupAnimations() {
    _entryController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _animations = [
      Tween<double>(begin: 0, end: 1).animate(
        CurvedAnimation(
          parent: _entryController,
          curve: const Interval(0, 0.3, curve: Curves.easeOutCubic),
        ),
      ),
      Tween<double>(begin: 0, end: 1).animate(
        CurvedAnimation(
          parent: _entryController,
          curve: const Interval(0.1, 0.4, curve: Curves.easeOutCubic),
        ),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final myPageState = ref.watch(myPageProvider);
    final userProfile = myPageState.userProfile;
    final businessData = myPageState.businessDashboard;

    return TossScaffold(
      backgroundColor: TossColors.gray100,
      body: SafeArea(
        child: Column(
          children: [
            // App Bar
            Container(
              color: TossColors.gray100,
              padding: const EdgeInsets.symmetric(
                horizontal: TossSpacing.space4,
                vertical: TossSpacing.space3,
              ),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, size: 24),
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

            // Body content
            Expanded(
              child: RefreshIndicator(
                onRefresh: _handleRefresh,
                color: TossColors.primary,
                child: myPageState.isLoading
                    ? const Center(child: TossLoadingView())
                    : myPageState.errorMessage != null
                        ? Center(
                            child: Text('Error loading profile: ${myPageState.errorMessage}'),
                          )
                        : userProfile == null
                            ? const Center(child: Text('No profile data'))
                            : SingleChildScrollView(
                                controller: _scrollController,
                                physics: const BouncingScrollPhysics(),
                                child: Column(
                                  children: [
                                    // Profile Header Section
                                    FadeTransition(
                                      opacity: _animations[0],
                                      child: ProfileHeaderSection(
                                        profile: userProfile,
                                        businessData: businessData,
                                        temporaryImageUrl: _temporaryProfileImageUrl,
                                        onAvatarTap: _handleAvatarTap,
                                      ),
                                    ),

                                    SizedBox(height: TossSpacing.space4),

                                    // Settings Section
                                    FadeTransition(
                                      opacity: _animations[1],
                                      child: SettingsSection(
                                        onEditProfile: _navigateToEditProfile,
                                        onNotifications: _navigateToNotifications,
                                        onPrivacySecurity: _navigateToPrivacySecurity,
                                        onSignOut: _handleSignOut,
                                      ),
                                    ),

                                    // Bottom spacing
                                    SizedBox(height: TossSpacing.space12),
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

  Future<void> _handleRefresh() async {
    HapticFeedback.mediumImpact();

    // Refresh user data using new pattern
    final authState = await ref.read(authStateProvider.future);
    if (authState != null) {
      await ref.read(myPageProvider.notifier).loadUserData(authState.id);
    }
  }

  void _handleAvatarTap() {
    HapticFeedback.lightImpact();
    _showAvatarOptions();
  }

  void _showAvatarOptions() {
    final profile = ref.read(currentUserProfileProvider);
    if (profile == null) return;

    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => AvatarOptionsBottomSheet(
        hasProfileImage: profile.hasProfileImage,
        onPickImage: _pickImage,
        onRemoveImage: _removeProfileImage,
      ),
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(
        source: source,
        maxWidth: 600,
        maxHeight: 600,
        imageQuality: 70,
      );

      if (image != null) {
        await _uploadProfileImage(File(image.path));
      }
    } catch (e) {
      if (mounted) {
        await showDialog(
          context: context,
          barrierDismissible: true,
          builder: (context) => TossDialog.error(
            title: 'Image Selection Failed',
            message: 'Failed to pick image: $e',
            primaryButtonText: 'OK',
            onPrimaryPressed: () => context.pop(),
          ),
        );
      }
    }
  }

  Future<void> _uploadProfileImage(File imageFile) async {
    // Set optimistic UI update - show image immediately
    setState(() {
      _isUploadingImage = true;
      _temporaryProfileImageUrl = imageFile.path;
    });

    // Show loading dialog
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (context) => Center(
        child: Container(
          padding: EdgeInsets.all(TossSpacing.space6),
          decoration: BoxDecoration(
            color: TossColors.surface,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const TossLoadingView(),
              SizedBox(height: TossSpacing.space3),
              Text(
                'Uploading...',
                style: TossTextStyles.caption.copyWith(
                  color: TossColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );

    try {
      final publicUrl = await ref
          .read(myPageProvider.notifier)
          .uploadProfileImage(imageFile.path);

      if (mounted) {
        // Update with the actual URL
        setState(() {
          _temporaryProfileImageUrl = publicUrl;
          _isUploadingImage = false;
        });

        Navigator.pop(context); // Close loading dialog

        // Refresh profile
        ref.invalidate(currentUserProfileProvider);

        // Show success dialog
        await showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => TossDialog.success(
            title: 'Profile Picture Updated!',
            message: 'Your profile picture has been updated successfully',
            primaryButtonText: 'Done',
            onPrimaryPressed: () => context.pop(),
          ),
        );

        // Clear temporary URL
        Future.delayed(const Duration(seconds: 1), () {
          if (mounted) {
            setState(() {
              _temporaryProfileImageUrl = null;
            });
          }
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _temporaryProfileImageUrl = null;
          _isUploadingImage = false;
        });

        Navigator.pop(context); // Close loading dialog

        // Show error dialog
        await showDialog(
          context: context,
          barrierDismissible: true,
          builder: (context) => TossDialog.error(
            title: 'Upload Failed',
            message: 'Failed to upload profile picture: ${e.toString()}',
            primaryButtonText: 'OK',
            onPrimaryPressed: () => context.pop(),
          ),
        );
      }
    }
  }

  Future<void> _removeProfileImage() async {
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (context) => Center(
        child: Container(
          padding: EdgeInsets.all(TossSpacing.space6),
          decoration: BoxDecoration(
            color: TossColors.surface,
            borderRadius: BorderRadius.circular(12),
          ),
          child: const TossLoadingView(),
        ),
      ),
    );

    try {
      await ref.read(myPageProvider.notifier).removeProfileImage();

      if (mounted) {
        Navigator.pop(context); // Close loading dialog

        // Refresh profile
        ref.invalidate(currentUserProfileProvider);

        // Show success dialog
        await showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => TossDialog.success(
            title: 'Profile Picture Removed!',
            message: 'Your profile picture has been removed successfully',
            primaryButtonText: 'Done',
            onPrimaryPressed: () => context.pop(),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        Navigator.pop(context); // Close loading dialog

        // Show error dialog
        await showDialog(
          context: context,
          barrierDismissible: true,
          builder: (context) => TossDialog.error(
            title: 'Remove Failed',
            message: 'Failed to remove profile picture: ${e.toString()}',
            primaryButtonText: 'OK',
            onPrimaryPressed: () => context.pop(),
          ),
        );
      }
    }
  }

  void _navigateToEditProfile() async {
    HapticFeedback.lightImpact();
    await context.safePush('/edit-profile');

    if (mounted) {
      ref.invalidate(currentUserProfileProvider);
    }
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

    final confirmed = await TossConfirmCancelDialog.show(
      context: context,
      title: 'Sign Out',
      message: 'Are you sure you want to sign out?',
      confirmButtonText: 'Sign Out',
      cancelButtonText: 'Cancel',
      isDangerousAction: true,
    );

    if (confirmed == true) {
      try {
        await Supabase.instance.client.auth.signOut();
        if (mounted) {
          context.safeGo('/auth/login');
        }
      } catch (e) {
        if (mounted) {
          await showDialog(
            context: context,
            barrierDismissible: true,
            builder: (context) => TossDialog.error(
              title: 'Sign Out Failed',
              message: 'Failed to sign out: $e',
              primaryButtonText: 'OK',
              onPrimaryPressed: () => context.pop(),
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
