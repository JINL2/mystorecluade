import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/providers/app_state_provider.dart';
import '../../../../shared/themes/toss_border_radius.dart';
import '../../../../shared/themes/toss_colors.dart';
import '../../../../shared/themes/toss_spacing.dart';
import '../../../../shared/themes/toss_text_styles.dart';
import '../../../auth/presentation/providers/auth_service.dart';
import '../providers/homepage_providers.dart';
import '../widgets/company_store_selector.dart';
import '../widgets/empty_state_screen.dart';
import '../widgets/feature_grid.dart';
import '../widgets/quick_access_section.dart';
import '../widgets/revenue_card.dart';

class Homepage extends ConsumerStatefulWidget {
  const Homepage({super.key}); // ✅ Removed const to allow rebuilds

  @override
  ConsumerState<Homepage> createState() => _HomepageState();
}

class _HomepageState extends ConsumerState<Homepage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    // Watch user companies provider to ensure AppState is initialized
    final userCompaniesAsync = ref.watch(userCompaniesProvider);

    // Wait for user companies to load before building UI
    return userCompaniesAsync.when(
      data: (userData) {
        // Check if userData is null or has no companies
        if (userData == null) {
          return EmptyStateScreen(
            errorMessage: 'You haven\'t created or joined any company yet.',
            onRetry: () => ref.invalidate(userCompaniesProvider),
          );
        }

        final companies = (userData['companies'] as List<dynamic>?) ?? [];
        if (companies.isEmpty) {
          return EmptyStateScreen(
            errorMessage: 'You haven\'t created or joined any company yet.',
            onRetry: () => ref.invalidate(userCompaniesProvider),
          );
        }

        return _buildHomepage();
      },
      loading: () => const Scaffold(
        backgroundColor: TossColors.gray100,
        body: Center(
          child: CircularProgressIndicator(color: TossColors.primary),
        ),
      ),
      error: (error, stack) {
        // Check if it's a "no companies" error
        final errorMessage = error.toString();
        if (errorMessage.contains('No user companies data')) {
          return EmptyStateScreen(
            errorMessage: 'Unable to load your company information.',
            onRetry: () => ref.invalidate(userCompaniesProvider),
          );
        }

        // For other errors, show generic error screen with retry
        return EmptyStateScreen(
          errorMessage: 'Something went wrong: $errorMessage',
          onRetry: () => ref.invalidate(userCompaniesProvider),
        );
      },
    );
  }

  Widget _buildHomepage() {
    final appState = ref.watch(appStateProvider);

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: TossColors.surface,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () => _handleRefresh(),
          color: TossColors.primary,
          child: CustomScrollView(
            slivers: [
              // App Header (Non-pinned)
              _buildAppHeader(),

              const SliverToBoxAdapter(
                child: SizedBox(height: TossSpacing.space4),
              ),

              // Revenue Card with inline company/store selector (if company selected)
              if (appState.companyChoosen.isNotEmpty)
                const SliverToBoxAdapter(
                  child: RevenueCard(),
                ),

              // Quick Access Section
              const SliverToBoxAdapter(
                child: QuickAccessSection(),
              ),

              // Line Divider
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 21),
                  child: Container(
                    height: 18,
                    color: TossColors.borderLight,
                  ),
                ),
              ),

              // Feature Grid
              const SliverToBoxAdapter(
                child: FeatureGrid(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppHeader() {
    final appState = ref.watch(appStateProvider);

    // Get company and store names
    final companyName = appState.companyName.isNotEmpty
        ? appState.companyName
        : 'Select Company';
    final storeName = appState.storeName.isNotEmpty
        ? appState.storeName
        : 'Select Store';

    return SliverToBoxAdapter(
      child: Container(
        height: 83,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: TossColors.surface,
          border: Border(
            bottom: BorderSide(
              color: TossColors.borderLight,
              width: 1,
            ),
          ),
        ),
        child: Row(
          children: [
            // Left: Avatar + Company/Store selector
            Expanded(
              child: GestureDetector(
                onTap: () => _showCompanyStoreDrawer(),
                child: Row(
                  children: [
                    // Square avatar with rounded corners
                    ClipRRect(
                      borderRadius: BorderRadius.circular(TossBorderRadius.md),
                      child: _buildSquareAvatar(),
                    ),

                    const SizedBox(width: 13),

                    // Store name (top) and Company name (bottom) with chevron
                    Expanded(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Flexible(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                // Store name (large, on top)
                                if (appState.storeChoosen.isNotEmpty && storeName.isNotEmpty)
                                  Text(
                                    storeName,
                                    style: TossTextStyles.bodyLarge.copyWith(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w700,
                                      color: TossColors.textPrimary,
                                      height: 1.2,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                  ),

                                // Company name (small, on bottom)
                                Text(
                                  companyName,
                                  style: TossTextStyles.caption.copyWith(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w500,
                                    color: TossColors.textSecondary,
                                    height: 1.2,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                ),
                              ],
                            ),
                          ),

                          // Up arrow
                          Padding(
                            padding: const EdgeInsets.only(left: 5),
                            child: Icon(
                              Icons.keyboard_arrow_up_rounded,
                              size: 20,
                              color: TossColors.textPrimary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(width: 13),

            // Right: Notification + Menu
            Row(
              children: [
                // Notification bell with badge
                _buildIconGhost(
                  icon: Icons.notifications_none_rounded,
                  showBadge: true,
                  badgeCount: 2,
                  onTap: () {
                    // TODO: Navigate to notifications
                  },
                ),

                const SizedBox(width: 13),

                // More menu
                _buildIconGhost(
                  icon: Icons.more_horiz_rounded,
                  showBadge: false,
                  onTap: () => _showProfileMenu(),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSquareAvatar() {
    final appState = ref.watch(appStateProvider);
    final profileImage = appState.user['profile_image'] as String? ?? '';

    if (profileImage.isNotEmpty) {
      return Image.network(
        profileImage,
        width: 47,
        height: 47,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return _buildAvatarFallback();
        },
      );
    }

    return _buildAvatarFallback();
  }

  Widget _buildAvatarFallback() {
    return Container(
      width: 47,
      height: 47,
      decoration: BoxDecoration(
        color: TossColors.primarySurface,
        borderRadius: BorderRadius.circular(TossBorderRadius.md),
      ),
      child: Center(
        child: Text(
          _getUserInitials(),
          style: TossTextStyles.body.copyWith(
            color: TossColors.primary,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _buildIconGhost({
    required IconData icon,
    required bool showBadge,
    int badgeCount = 0,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          SizedBox(
            width: 47,
            height: 47,
            child: Icon(
              icon,
              size: 31,
              color: TossColors.textPrimary,
            ),
          ),
          if (showBadge && badgeCount > 0)
            Positioned(
              top: 2,
              right: 2,
              child: Container(
                constraints: const BoxConstraints(minWidth: 16),
                height: 16,
                padding: const EdgeInsets.symmetric(horizontal: 4),
                decoration: BoxDecoration(
                  color: TossColors.primary,
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Center(
                  child: Text(
                    badgeCount.toString(),
                    style: TossTextStyles.caption.copyWith(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: TossColors.white,
                      height: 1,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  void _showProfileMenu() {
    showMenu<String>(
      context: context,
      position: RelativeRect.fromLTRB(
        MediaQuery.of(context).size.width - 200,
        80,
        16,
        0,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(TossSpacing.space3),
      ),
      color: TossColors.surface,
      elevation: 2,
      items: [
        PopupMenuItem<String>(
          value: 'profile',
          child: Row(
            children: [
              const Icon(
                Icons.person_outline,
                color: TossColors.textSecondary,
                size: 20,
              ),
              const SizedBox(width: TossSpacing.space3),
              Text(
                'My Profile',
                style: TossTextStyles.body.copyWith(
                  color: TossColors.textPrimary,
                ),
              ),
            ],
          ),
        ),
        const PopupMenuDivider(),
        PopupMenuItem<String>(
          value: 'logout',
          child: Row(
            children: [
              const Icon(
                Icons.logout_rounded,
                color: TossColors.error,
                size: 20,
              ),
              const SizedBox(width: TossSpacing.space3),
              Text(
                'Logout',
                style: TossTextStyles.body.copyWith(
                  color: TossColors.error,
                ),
              ),
            ],
          ),
        ),
      ],
    ).then((value) async {
      if (value == 'logout') {
        await _handleLogout();
      } else if (value == 'profile') {
        if (mounted) {
          context.push('/my-page');
        }
      }
    });
  }


  String _getUserInitials() {
    final appState = ref.watch(appStateProvider);
    final firstName = appState.user['user_first_name'] as String? ?? '';
    final lastName = appState.user['user_last_name'] as String? ?? '';

    if (firstName.isEmpty && lastName.isEmpty) return 'U';

    // Get first character of first name and last name
    final firstInitial = firstName.isNotEmpty ? firstName[0].toUpperCase() : '';
    final lastInitial = lastName.isNotEmpty ? lastName[0].toUpperCase() : '';

    if (firstInitial.isNotEmpty && lastInitial.isNotEmpty) {
      return '$firstInitial$lastInitial';
    } else if (firstInitial.isNotEmpty) {
      return firstInitial;
    } else if (lastInitial.isNotEmpty) {
      return lastInitial;
    }

    return 'U';
  }

  /// Show company & store selector drawer
  void _showCompanyStoreDrawer() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      isDismissible: true,
      enableDrag: true,
      builder: (context) => const CompanyStoreSelector(),
    );
  }

  /// Handle logout with enterprise-grade cleanup
  ///
  /// Safe logout flow that prevents widget tree errors:
  /// 1. Read all providers BEFORE starting logout
  /// 2. Execute auth signOut (triggers GoRouter redirect)
  /// 3. Let GoRouter handle navigation automatically
  /// 4. NO manual pop() - let the menu close naturally during navigation
  Future<void> _handleLogout() async {
    try {
      // ✅ Read all providers BEFORE logout starts
      // This prevents "Cannot use ref after dispose" errors
      final authService = ref.read(authServiceProvider);
      final appStateNotifier = ref.read(appStateProvider.notifier);

      if (!mounted) return;

      // ✅ Save ScaffoldMessenger reference BEFORE async operations
      final messenger = ScaffoldMessenger.of(context);

      // Show loading indicator
      messenger.showSnackBar(
        const SnackBar(
          content: Row(
            children: [
              SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(TossColors.white),
                ),
              ),
              SizedBox(width: TossSpacing.space3),
              Text('Logging out...'),
            ],
          ),
          backgroundColor: TossColors.primary,
          duration: Duration(seconds: 2),
        ),
      );

      // ✅ Small delay to show the loading message
      await Future.delayed(const Duration(milliseconds: 300));

      // ✅ Clear app state FIRST (before widget disposal)
      // This must happen before authService.signOut() which triggers navigation
      appStateNotifier.signOut();

      // ✅ Execute auth logout
      // This will:
      // 1. Clear session
      // 2. Sign out from Supabase
      // 3. Invalidate providers
      // 4. Trigger GoRouter redirect (auth state changes to null)
      // 5. PopupMenu will close automatically during navigation
      await authService.signOut();

      // Note: Widget is disposed here due to GoRouter redirect
      // PopupMenu closes automatically, no manual pop() needed
      // This prevents "You have popped the last page" error

      // ✅ Use saved messenger reference (safe even after dispose)
      if (mounted) {
        messenger.hideCurrentSnackBar();
      }

      // GoRouter will automatically redirect to /auth/login
      // No manual navigation needed!

    } catch (e) {
      // ✅ Only show error if widget is still mounted
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Logout failed: $e'),
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

  Future<void> _handleRefresh() async {
    final appStateNotifier = ref.read(appStateProvider.notifier);

    try {
      // Clear AppState cache to force fresh fetch
      appStateNotifier.updateCategoryFeatures([]);

      // Invalidate all homepage providers to refresh data
      ref.invalidate(userCompaniesProvider);
      ref.invalidate(categoriesWithFeaturesProvider);
      ref.invalidate(quickAccessFeaturesProvider);
      ref.invalidate(revenueProvider);

      // Wait for providers to reload and update AppState
      await Future.wait([
        ref.read(userCompaniesProvider.future),
        ref.read(categoriesWithFeaturesProvider.future),
      ]);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Data refreshed successfully'),
            backgroundColor: TossColors.success,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(TossBorderRadius.lg),
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Failed to refresh data'),
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

