import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../app/providers/app_state_provider.dart';
import '../../../../core/cache/auth_data_cache.dart';
import '../../../../core/monitoring/sentry_config.dart';
import '../../../../core/notifications/services/production_token_service.dart';
import '../../../../shared/themes/toss_border_radius.dart';
import '../../../../shared/themes/toss_colors.dart';
import '../../../../shared/widgets/ai_chat/ai_chat.dart';
import '../../../attendance/presentation/providers/attendance_providers.dart';
import '../../../auth/presentation/providers/auth_service.dart';
import '../../domain/providers/repository_providers.dart';
import '../providers/homepage_providers.dart';
import '../widgets/dialogs/homepage_alert_dialog.dart';
import '../widgets/feature_grid.dart';
import '../widgets/homepage/homepage_widgets.dart';
import '../widgets/quick_access_section.dart';
import '../widgets/revenue_card.dart';
import '../widgets/revenue_chart_card.dart';
import '../widgets/salary_card.dart';
import 'package:myfinance_improved/shared/widgets/index.dart';

class Homepage extends ConsumerStatefulWidget {
  const Homepage({super.key}); // ✅ Removed const to allow rebuilds

  @override
  ConsumerState<Homepage> createState() => _HomepageState();
}

class _HomepageState extends ConsumerState<Homepage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _isLoggingOut = false;
  bool _isRefreshing = false;
  bool _alertShown = false; // Prevent showing alert multiple times per session
  bool _versionChecked = false; // Prevent checking version multiple times
  bool _updateDialogShown = false; // Prevent showing update dialog multiple times

  @override
  Widget build(BuildContext context) {
    // 🔒 Check app version FIRST before loading any other data
    _checkAppVersion();

    // Show loading view during logout
    if (_isLoggingOut) {
      return const LogoutLoadingView();
    }

    // Show loading view during refresh
    if (_isRefreshing) {
      return const RefreshLoadingView();
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
            backgroundColor: TossColors.surface,
            body: TossLoadingView(message: 'Loading...'),
          );
        }

        // Check if user has any companies
        final companies = (userData['companies'] as List<dynamic>?) ?? [];
        if (companies.isEmpty) {
          // Show loading - router will redirect to /onboarding/choose-role
          return const Scaffold(
            backgroundColor: TossColors.surface,
            body: TossLoadingView(message: 'Loading...'),
          );
        }

        // 🔒 Wait for ALL essential data to load before showing homepage
        return _buildHomepageWithDataCheck();
      },
      loading: () => const Scaffold(
        backgroundColor: TossColors.surface,
        body: TossLoadingView(message: 'Loading...'),
      ),
      error: (error, stack) {
        // Show loading - router will redirect appropriately
        return const Scaffold(
          backgroundColor: TossColors.surface,
          body: TossLoadingView(message: 'Loading...'),
        );
      },
    );
  }

  /// Build homepage only when ALL essential data is loaded
  /// Shows full-screen loading until:
  /// - Quick access features loaded
  /// - Categories with features loaded
  /// - Revenue/Salary data loaded (based on permission)
  Widget _buildHomepageWithDataCheck() {
    // Watch all essential providers
    final quickAccessAsync = ref.watch(quickAccessFeaturesProvider);
    final categoriesAsync = ref.watch(categoriesWithFeaturesProvider);

    // Check if user has revenue permission to decide which data to wait for
    final hasRevenue = _hasRevenuePermission();

    // Determine loading state for revenue/salary
    final AsyncValue<dynamic> revenueOrSalaryAsync;
    if (hasRevenue) {
      final selectedPeriod = ref.watch(selectedRevenuePeriodProvider);
      revenueOrSalaryAsync = ref.watch(revenueProvider(selectedPeriod));
    } else {
      revenueOrSalaryAsync = ref.watch(homepageUserSalaryProvider);
    }

    // Check if ALL data is loaded (hasValue or hasError means loading is complete)
    final isQuickAccessLoaded = quickAccessAsync.hasValue || quickAccessAsync.hasError;
    final isCategoriesLoaded = categoriesAsync.hasValue || categoriesAsync.hasError;
    final isRevenueOrSalaryLoaded = revenueOrSalaryAsync.hasValue || revenueOrSalaryAsync.hasError;

    // Show loading until all data is ready
    if (!isQuickAccessLoaded || !isCategoriesLoaded || !isRevenueOrSalaryLoaded) {
      return const Scaffold(
        backgroundColor: TossColors.surface,
        body: TossLoadingView(message: 'Loading...'),
      );
    }

    // All data loaded - check and show homepage alert
    _checkAndShowAlert();

    return _buildHomepage();
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
      return false;
    }
  }

  Widget _buildHomepage() {
    final appState = ref.watch(appStateProvider);

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: TossColors.surface,
      floatingActionButton: const AiChatFab(
        featureName: 'Homepage',
      ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () => _handleRefresh(),
          color: TossColors.primary,
          child: CustomScrollView(
            slivers: [
              // App Header (Non-pinned)
              HomepageHeader(
                onProfileMenuTap: () => showProfileMenu(
                  context: context,
                  onLogout: _handleLogout,
                ),
                onLogout: _handleLogout,
              ),

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

              // Revenue Chart Card (only for managers with revenue permission)
              if (appState.companyChoosen.isNotEmpty && _hasRevenuePermission())
                const SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.only(left: 16, right: 16, top: 16),
                    child: RevenueChartCard(),
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

  /// Handle logout with smooth UX
  ///
  /// Improved logout flow:
  /// 1. Show full-screen loading view immediately
  /// 2. Clear app state BEFORE auth signOut (prevents "dispose" error)
  /// 3. Execute auth signOut (triggers GoRouter redirect)
  /// 4. Let GoRouter handle navigation to login page
  Future<void> _handleLogout() async {
    // Prevent double logout
    if (_isLoggingOut) return;

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

  /// Check app version against server and show update dialog if needed
  ///
  /// This is called BEFORE loading other homepage data.
  /// If version doesn't match, shows a non-dismissible dialog and exits app on OK.
  void _checkAppVersion() {
    if (_versionChecked) return;

    final versionAsync = ref.read(appVersionCheckProvider);

    versionAsync.whenData((isUpToDate) {
      if (!isUpToDate && !_updateDialogShown) {
        _updateDialogShown = true;
        _versionChecked = true;

        // Show force update dialog after build completes
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            TossDialogs.showForceUpdateRequired(
              context: context,
              onOkPressed: () async {
                // Try App Store app first, fallback to web App Store
                const appStoreUrl = 'itms-apps://';
                const webAppStoreUrl = 'https://apps.apple.com';

                final Uri url = Uri.parse(appStoreUrl);
                final canLaunch = await canLaunchUrl(url);

                if (canLaunch) {
                  await launchUrl(url, mode: LaunchMode.externalApplication);
                } else {
                  // Fallback for simulator - open web App Store
                  final Uri webUrl = Uri.parse(webAppStoreUrl);
                  await launchUrl(webUrl, mode: LaunchMode.externalApplication);
                }

                // Exit app after opening store (Android only, iOS ignores this)
                SystemNavigator.pop();
              },
            );
          }
        });
      } else {
        _versionChecked = true;
      }
    });
  }

  /// Check and show homepage alert if conditions are met
  ///
  /// Shows alert only if:
  /// - is_show = true
  /// - is_checked = false
  /// - Alert hasn't been shown in this session
  void _checkAndShowAlert() {
    if (_alertShown) return;

    final alertAsync = ref.read(homepageAlertProvider);

    alertAsync.whenData((alert) {
      // Check conditions: is_show = true AND is_checked = false
      if (alert.shouldDisplay && !_alertShown) {
        _alertShown = true;

        // Show dialog after build completes
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            showDialog<void>(
              context: context,
              barrierDismissible: true,
              builder: (_) => HomepageAlertDialog(
                message: alert.content ?? '',
                onDontShowAgain: (bool isChecked) {
                  // Call RPC to update is_checked (true = don't show again, false = show again)
                  _responseHomepageAlert(isChecked);
                },
              ),
            );
          }
        });
      }
    });
  }

  /// Call homepage_response_alert RPC to update is_checked status
  Future<void> _responseHomepageAlert(bool isChecked) async {
    final userId = ref.read(appStateProvider).userId;
    if (userId.isEmpty) return;

    final repository = ref.read(homepageRepositoryProvider);
    await repository.responseHomepageAlert(
      userId: userId,
      isChecked: isChecked,
    );
  }

  Future<void> _handleRefresh() async {
    final appStateNotifier = ref.read(appStateProvider.notifier);

    // Show loading view
    if (mounted) {
      setState(() {
        _isRefreshing = true;
      });
    }

    try {
      // Clear AppState cache to force fresh fetch
      appStateNotifier.updateCategoryFeatures([]);

      // Reset alert shown flag to allow showing again after refresh
      _alertShown = false;

      // Invalidate homepage alert cache (6-hour cache)
      final userId = ref.read(appStateProvider).userId;
      if (userId.isNotEmpty) {
        AuthDataCache.instance.invalidate('homepage_get_alert_$userId');
      }

      // Invalidate all homepage providers to refresh data
      ref.invalidate(userCompaniesProvider);
      ref.invalidate(categoriesWithFeaturesProvider);
      ref.invalidate(quickAccessFeaturesProvider);
      ref.invalidate(revenueProvider);
      ref.invalidate(homepageAlertProvider);

      // Invalidate salary-related providers
      ref.invalidate(homepageUserSalaryProvider);
      ref.invalidate(userShiftStatsProvider);

      // 🔥 Force FCM token refresh on manual refresh (scenario 3)
      try {
        await ProductionTokenService().registerTokenAfterAuth();
      } catch (e, stackTrace) {
        // Don't fail the refresh if FCM fails
        SentryConfig.captureException(
          e,
          stackTrace,
          hint: 'Homepage FCM token refresh failed',
        );
      }

      // Wait for essential provider to reload (others will load in background)
      await ref.read(userCompaniesProvider.future);

      // Hide loading view
      if (mounted) {
        setState(() {
          _isRefreshing = false;
        });
      }
    } catch (e, stackTrace) {
      // Hide loading view on error
      SentryConfig.captureException(
        e,
        stackTrace,
        hint: 'Homepage refresh failed',
      );
      if (mounted) {
        setState(() {
          _isRefreshing = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to refresh: $e'),
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
