import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:myfinance_improved/shared/themes/toss_colors.dart';
import 'package:myfinance_improved/shared/themes/toss_spacing.dart';
import 'package:myfinance_improved/shared/themes/toss_text_styles.dart';
import 'package:myfinance_improved/shared/themes/toss_border_radius.dart';
import 'package:myfinance_improved/shared/widgets/common/toss_confirm_cancel_dialog.dart';
import 'package:myfinance_improved/shared/widgets/common/toss_loading_view.dart';
import 'package:myfinance_improved/shared/widgets/common/toss_scaffold.dart';
import 'package:myfinance_improved/shared/widgets/common/toss_success_error_dialog.dart';

import '../../../../app/providers/auth_providers.dart';
import '../../../auth/presentation/providers/auth_service.dart';
import '../providers/my_page_notifier.dart';
import '../widgets/profile_avatar_section.dart';
import '../widgets/profile_header_section.dart';
import '../widgets/settings_section.dart';
import '../widgets/subscription_section.dart';

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
  bool _isLoggingOut = false;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _setupAnimations();
    _entryController.forward();

    // Load user data when page is initialized
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadInitialData();
    });
  }

  Future<void> _loadInitialData() async {
    final authState = await ref.read(authStateProvider.future);
    if (authState != null) {
      await ref.read(myPageNotifierProvider.notifier).loadUserData(authState.id);
    }
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
      Tween<double>(begin: 0, end: 1).animate(
        CurvedAnimation(
          parent: _entryController,
          curve: const Interval(0.2, 0.5, curve: Curves.easeOutCubic),
        ),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    // Show loading view during logout
    if (_isLoggingOut) {
      return TossScaffold(
        backgroundColor: TossColors.gray100,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const TossLoadingView(),
              const SizedBox(height: TossSpacing.space4),
              Text(
                'Signing out...',
                style: TossTextStyles.body.copyWith(
                  color: TossColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      );
    }

    final myPageState = ref.watch(myPageNotifierProvider);
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
                    onPressed: () {
                      if (context.canPop()) {
                        context.pop();
                      } else {
                        context.go('/');
                      }
                    },
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

                                    const SizedBox(height: TossSpacing.space4),

                                    // Subscription Section
                                    FadeTransition(
                                      opacity: _animations[1],
                                      child: const SubscriptionSection(),
                                    ),

                                    const SizedBox(height: TossSpacing.space4),

                                    // Settings Section
                                    FadeTransition(
                                      opacity: _animations[2],
                                      child: SettingsSection(
                                        onEditProfile: _navigateToEditProfile,
                                        onNotifications: _navigateToNotifications,
                                        onPrivacySecurity: _navigateToPrivacySecurity,
                                        onLanguage: _navigateToLanguage,
                                        onSignOut: _handleSignOut,
                                      ),
                                    ),

                                    // Bottom spacing
                                    const SizedBox(height: TossSpacing.space12),
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
      await ref.read(myPageNotifierProvider.notifier).loadUserData(authState.id);
    }
  }

  void _handleAvatarTap() {
    HapticFeedback.lightImpact();
    _showAvatarOptions();
  }

  void _showAvatarOptions() {
    final myPageState = ref.read(myPageNotifierProvider);
    final profile = myPageState.userProfile;
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
        maxWidth: 400,
        maxHeight: 400,
        imageQuality: 50,
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
          padding: const EdgeInsets.all(TossSpacing.space6),
          decoration: BoxDecoration(
            color: TossColors.surface,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const TossLoadingView(),
              const SizedBox(height: TossSpacing.space3),
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
          .read(myPageNotifierProvider.notifier)
          .uploadProfileImage(imageFile.path);

      if (mounted) {
        // Update with the actual URL
        setState(() {
          _temporaryProfileImageUrl = publicUrl;
          _isUploadingImage = false;
        });

        Navigator.pop(context); // Close loading dialog

        // Refresh profile
        ref.invalidate(myPageNotifierProvider);

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
          padding: const EdgeInsets.all(TossSpacing.space6),
          decoration: BoxDecoration(
            color: TossColors.surface,
            borderRadius: BorderRadius.circular(12),
          ),
          child: const TossLoadingView(),
        ),
      ),
    );

    try {
      await ref.read(myPageNotifierProvider.notifier).removeProfileImage();

      if (mounted) {
        Navigator.pop(context); // Close loading dialog

        // Refresh profile
        ref.invalidate(myPageNotifierProvider);

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
    await context.push('/edit-profile');

    if (mounted) {
      ref.invalidate(myPageNotifierProvider);
    }
  }

  void _navigateToNotifications() {
    HapticFeedback.lightImpact();
    context.push('/notifications-settings');
  }

  void _navigateToPrivacySecurity() {
    HapticFeedback.lightImpact();
    context.push('/privacy-security');
  }

  void _navigateToLanguage() {
    HapticFeedback.lightImpact();
    context.push('/language-settings');
  }

  /// Handle logout with smooth UX (same pattern as homepage.dart)
  ///
  /// Improved logout flow:
  /// 1. Show confirmation dialog
  /// 2. Show full-screen loading view immediately
  /// 3. Clear app state BEFORE auth signOut (prevents "dispose" error)
  /// 4. Execute auth signOut (triggers GoRouter redirect)
  /// 5. Let GoRouter handle navigation to login page
  Future<void> _handleSignOut() async {
    // Prevent double logout
    if (_isLoggingOut) return;

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
        final authService = ref.read(authServiceProvider);
        if (!mounted) return;

        setState(() {
          _isLoggingOut = true;
        });

        // AuthService.signOut() handles all cleanup internally:
        // 1. Clears session
        // 2. Clears AppState
        // 3. Signs out from Supabase
        // 4. Invalidates all providers
        await authService.signOut();

        // GoRouter will automatically redirect to /auth/login

      } catch (e) {
        if (mounted) {
          setState(() {
            _isLoggingOut = false;
          });

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Sign out failed: $e'),
              backgroundColor: TossColors.error,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(TossBorderRadius.lg),
              ),
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
