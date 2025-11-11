import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/providers/app_state.dart';
import '../../../../app/providers/app_state_provider.dart';
import '../../../../shared/themes/toss_border_radius.dart';
import '../../../../shared/themes/toss_colors.dart';
import '../../../../shared/themes/toss_shadows.dart';
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
  Homepage({super.key}); // ✅ Removed const to allow rebuilds

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
      loading: () => Scaffold(
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
      backgroundColor: TossColors.gray100,
      body: RefreshIndicator(
        onRefresh: () => _handleRefresh(),
        color: TossColors.primary,
        child: CustomScrollView(
          slivers: [
            // App Bar
            _buildAppBar(),

            // Hello Section (Pinned)
            _buildHelloSection(),

            // Revenue Card (if company selected)
            if (appState.companyChoosen.isNotEmpty)
              const SliverToBoxAdapter(
                child: RevenueCard(),
              ),

            const SliverToBoxAdapter(
              child: SizedBox(height: TossSpacing.space4),
            ),

            // Quick Access Section
            const SliverToBoxAdapter(
              child: QuickAccessSection(),
            ),

            // Feature Grid
            const SliverToBoxAdapter(
              child: FeatureGrid(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return SliverAppBar(
      pinned: true,
      floating: false,
      snap: false,
      backgroundColor: TossColors.gray100,
      surfaceTintColor: TossColors.transparent,
      shadowColor: TossColors.transparent,
      elevation: 0,
      toolbarHeight: 64,
      leading: IconButton(
        icon: Icon(Icons.menu, color: TossColors.textSecondary, size: 24),
        onPressed: () {
          _showCompanyStoreDrawer();
        },
        padding: const EdgeInsets.all(TossSpacing.space3),
      ),
      actions: [
        // Notifications
        IconButton(
          icon: Icon(
            Icons.notifications_none_rounded,
            color: TossColors.textSecondary,
            size: 24,
          ),
          onPressed: () {
            // TODO: Navigate to notifications
          },
          padding: const EdgeInsets.all(TossSpacing.space3),
        ),

        // Profile
        Padding(
          padding: const EdgeInsets.only(right: TossSpacing.space4),
          child: GestureDetector(
            onTap: () {
              // Show popup menu
              showMenu<String>(
                context: context,
                position: RelativeRect.fromLTRB(
                  MediaQuery.of(context).size.width - 200,
                  64 + 48,
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
                        Icon(
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
                        Icon(
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
                  // Navigate to My Page
                  if (mounted) {
                    context.go('/my-page');
                  }
                }
              });
            },
            child: _buildProfileAvatar(),
          ),
        ),
      ],
    );
  }

  Widget _buildHelloSection() {
    final appState = ref.watch(appStateProvider);

    return SliverPersistentHeader(
      pinned: true,
      delegate: _PinnedHelloDelegate(
        appState: appState,
      ),
    );
  }

  /// Build profile avatar with image or initials fallback
  Widget _buildProfileAvatar() {
    // ✅ CRITICAL FIX: Use ref.watch() instead of ref.read() to rebuild when AppState changes
    final appState = ref.watch(appStateProvider);
    final profileImage = appState.user['profile_image'] as String? ?? '';

    // Debug: Log profile image URL

    // If profile image exists and is not empty, show image
    if (profileImage.isNotEmpty) {
      return CircleAvatar(
        radius: 20,
        backgroundColor: TossColors.primary.withValues(alpha: 0.1),
        child: ClipOval(
          child: Image.network(
            profileImage,
            width: 40,
            height: 40,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              // If image fails to load, show initials
              return Center(
                child: Text(
                  _getUserInitials(),
                  style: TossTextStyles.bodyLarge.copyWith(
                    color: TossColors.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              );
            },
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) {
                return child;
              }
              // Show loading indicator while image is loading
              return Center(
                child: SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    color: TossColors.primary,
                    strokeWidth: 2,
                    value: loadingProgress.expectedTotalBytes != null
                        ? loadingProgress.cumulativeBytesLoaded /
                            loadingProgress.expectedTotalBytes!
                        : null,
                  ),
                ),
              );
            },
          ),
        ),
      );
    }

    // Fallback to initials
    return CircleAvatar(
      radius: 20,
      backgroundColor: TossColors.primary.withValues(alpha: 0.1),
      child: Text(
        _getUserInitials(),
        style: TossTextStyles.bodyLarge.copyWith(
          color: TossColors.primary,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
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
        SnackBar(
          content: Row(
            children: [
              const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(TossColors.white),
                ),
              ),
              const SizedBox(width: TossSpacing.space3),
              const Text('Logging out...'),
            ],
          ),
          backgroundColor: TossColors.primary,
          duration: const Duration(seconds: 2),
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

class _PinnedHelloDelegate extends SliverPersistentHeaderDelegate {
  final AppState appState;

  const _PinnedHelloDelegate({
    required this.appState,
  });

  @override
  double get minExtent => 85.0;

  @override
  double get maxExtent => 85.0;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    // Debug: Check AppState values

    // Extract user name from AppState
    final firstName = appState.user['user_first_name'] as String? ?? '';
    final lastName = appState.user['user_last_name'] as String? ?? '';
    final userName = firstName.isNotEmpty
        ? (lastName.isNotEmpty ? '$firstName $lastName' : firstName)
        : 'User';


    // Get company and store names from AppState
    final companyName = appState.companyName.isNotEmpty
        ? appState.companyName
        : (appState.companyChoosen.isNotEmpty ? 'Company Selected' : 'No Company');
    final storeName = appState.storeName;


    return Container(
      color: TossColors.gray100,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: TossSpacing.space4),
        decoration: BoxDecoration(
          color: TossColors.surface,
          borderRadius: BorderRadius.circular(TossBorderRadius.xl),
          boxShadow: TossShadows.card,
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: TossSpacing.space4,
          vertical: TossSpacing.space3,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // User greeting with actual name
            Text(
              'Hello, $userName!',
              style: TossTextStyles.h2.copyWith(
                color: TossColors.textPrimary,
                fontWeight: FontWeight.w700,
                letterSpacing: -0.5,
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),

            const SizedBox(height: TossSpacing.space1),

            // Company and Store info with actual names
            Row(
              children: [
                Text(
                  companyName,
                  style: TossTextStyles.body.copyWith(
                    color: TossColors.primary,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    letterSpacing: -0.2,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
                if (appState.storeChoosen.isNotEmpty && storeName.isNotEmpty) ...[
                  Text(
                    ' • ',
                    style: TossTextStyles.body.copyWith(
                      color: TossColors.textTertiary,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      storeName,
                      style: TossTextStyles.caption.copyWith(
                        color: TossColors.textSecondary,
                        fontWeight: FontWeight.w500,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }
}
