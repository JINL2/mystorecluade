import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/providers/app_state_provider.dart';
import '../../../../shared/themes/toss_border_radius.dart';
import '../../../../shared/themes/toss_colors.dart';
import '../../../../shared/themes/toss_spacing.dart';
import '../../../../shared/themes/toss_text_styles.dart';
import '../../../../shared/widgets/common/toss_loading_view.dart';
import '../../../auth/presentation/providers/auth_service.dart';
import '../../../notifications/presentation/providers/notification_provider.dart';
import '../providers/homepage_providers.dart';
import '../widgets/company_store_selector.dart';
import '../widgets/feature_grid.dart';
import '../widgets/quick_access_section.dart';
import '../widgets/revenue_card.dart';
import '../widgets/salary_card.dart';

class Homepage extends ConsumerStatefulWidget {
  const Homepage({super.key}); // ✅ Removed const to allow rebuilds

  @override
  ConsumerState<Homepage> createState() => _HomepageState();
}

class _HomepageState extends ConsumerState<Homepage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _isLoggingOut = false;

  @override
  Widget build(BuildContext context) {
    // Show loading view during logout
    if (_isLoggingOut) {
      return const Scaffold(
        backgroundColor: TossColors.surface,
        body: TossLoadingView(
          message: 'Logging out...',
        ),
      );
    }
    // Watch user companies provider to ensure AppState is initialized
    final userCompaniesAsync = ref.watch(userCompaniesProvider);

    // Wait for user companies to load before building UI
    return userCompaniesAsync.when(
      data: (userData) {
        // Check if userData is null or has no companies
        if (userData == null) {
          // Show loading - router will redirect to /onboarding/choose-role
          return const Scaffold(
            backgroundColor: TossColors.gray100,
            body: Center(
              child: CircularProgressIndicator(color: TossColors.primary),
            ),
          );
        }

        // Check if user has any companies
        final companies = (userData['companies'] as List<dynamic>?) ?? [];
        if (companies.isEmpty) {
          // Show loading - router will redirect to /onboarding/choose-role
          return const Scaffold(
            backgroundColor: TossColors.gray100,
            body: Center(
              child: CircularProgressIndicator(color: TossColors.primary),
            ),
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
        // Show loading - router will redirect appropriately
        return const Scaffold(
          backgroundColor: TossColors.gray100,
          body: Center(
            child: CircularProgressIndicator(color: TossColors.primary),
          ),
        );
      },
    );
  }

  /// Check if user has permission to view company revenue
  /// Permission ID: aef426a2-c50a-4ce2-aee9-c6509cfbd571
  bool _hasRevenuePermission() {
    final appState = ref.read(appStateProvider);
    const revenuePermissionId = 'aef426a2-c50a-4ce2-aee9-c6509cfbd571';

    try {
      final companies = appState.user['companies'] as List<dynamic>?;
      if (companies == null || companies.isEmpty) {
        return false;
      }

      final currentCompanyId = appState.companyChoosen;
      if (currentCompanyId.isEmpty) {
        return false;
      }

      final currentCompany = companies.firstWhere(
        (c) => c['company_id'] == currentCompanyId,
      ) as Map<String, dynamic>?;

      if (currentCompany == null) {
        return false;
      }

      final role = currentCompany['role'] as Map<String, dynamic>?;
      if (role == null) {
        return false;
      }

      final permissions = role['permissions'] as List<dynamic>?;
      if (permissions == null) {
        return false;
      }

      return permissions.contains(revenuePermissionId);
    } catch (e) {
      print('⚠️ Error checking revenue permission: $e');
      return false;
    }
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

              // Revenue Card or Salary Card (based on permission)
              if (appState.companyChoosen.isNotEmpty)
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: _hasRevenuePermission()
                        ? const RevenueCard()
                        : const SalaryCard(), // Show salary if no revenue permission
                  ),
                ),

              // Quick Access Section
              const SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: QuickAccessSection(),
                ),
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
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: FeatureGrid(),
                ),
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

                    // Company name (top) and Store name (bottom) with chevron
                    Expanded(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Flexible(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                // Company name (large, on top) - Title Medium: 15px/Bold
                                Text(
                                  companyName,
                                  style: TossTextStyles.bodyLarge.copyWith(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w700,
                                    color: TossColors.textPrimary,
                                    height: 1.2,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                ),

                                // Store name (small, on bottom)
                                Text(
                                  storeName,
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
                Consumer(
                  builder: (context, ref, child) {
                    final unreadCountAsync = ref.watch(unreadNotificationCountProvider);
                    final unreadCount = unreadCountAsync.when(
                      data: (count) => count,
                      loading: () => 0,
                      error: (_, __) => 0,
                    );

                    return _buildIconGhost(
                      icon: Icons.notifications_none_rounded,
                      showBadge: unreadCount > 0,
                      badgeCount: unreadCount,
                      onTap: () {
                        context.push('/notifications');
                      },
                    );
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
        width: 33,
        height: 33,
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
      width: 33,
      height: 33,
      decoration: BoxDecoration(
        color: TossColors.primarySurface,
        borderRadius: BorderRadius.circular(TossBorderRadius.md),
      ),
      child: Center(
        child: Text(
          _getUserInitials(),
          style: TossTextStyles.caption.copyWith(
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
            width: 36,
            height: 36,
            child: Icon(
              icon,
              size: 24,
              color: TossColors.textPrimary,
            ),
          ),
          if (showBadge && badgeCount > 0)
            Positioned(
              top: 0,
              right: 0,
              child: Container(
                constraints: const BoxConstraints(minWidth: 15),
                height: 15,
                padding: const EdgeInsets.symmetric(horizontal: 3),
                decoration: BoxDecoration(
                  color: TossColors.primary,
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Center(
                  child: Text(
                    badgeCount.toString(),
                    style: TossTextStyles.caption.copyWith(
                      fontSize: 9,
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

  /// Handle logout with smooth UX
  ///
  /// Improved logout flow:
  /// 1. Show full-screen loading view immediately
  /// 2. Clear app state BEFORE auth signOut (prevents "dispose" error)
  /// 3. Execute auth signOut (triggers GoRouter redirect)
  /// 4. Let GoRouter handle navigation to login page
  Future<void> _handleLogout() async {
    try {
      // ✅ Read all providers BEFORE logout starts
      final authService = ref.read(authServiceProvider);
      final appStateNotifier = ref.read(appStateProvider.notifier);

      if (!mounted) return;

      // ✅ Show full-screen loading view
      setState(() {
        _isLoggingOut = true;
      });

      // ✅ Clear app state FIRST (before auth logout)
      // This prevents "Bad state: Tried to use AppStateNotifier after dispose"
      // because authService.signOut() will invalidate all providers
      appStateNotifier.signOut();

      // ✅ Execute auth logout AFTER clearing app state
      // This will:
      // 1. Clear session
      // 2. Sign out from Supabase
      // 3. Invalidate providers (including appStateProvider)
      // 4. Trigger GoRouter redirect (auth state changes to null)
      await authService.signOut();

      // GoRouter will automatically redirect to /auth/login
      // Loading view will be visible until navigation completes

    } catch (e) {
      // ✅ Reset loading state on error
      if (mounted) {
        setState(() {
          _isLoggingOut = false;
        });

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

