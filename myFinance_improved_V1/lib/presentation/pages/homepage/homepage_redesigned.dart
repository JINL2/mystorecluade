import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:myfinance_improved/core/themes/toss_colors.dart';
import 'package:myfinance_improved/core/themes/toss_text_styles.dart';
import 'package:myfinance_improved/core/themes/toss_spacing.dart';
import 'package:myfinance_improved/core/themes/toss_shadows.dart';
import 'package:myfinance_improved/core/themes/toss_animations.dart';
import 'package:myfinance_improved/core/constants/icon_mapper.dart';
import 'providers/homepage_providers.dart';
import 'providers/revenue_provider.dart';
import 'widgets/revenue_card.dart';
import '../../widgets/common/safe_popup_menu.dart';
import '../../providers/app_state_provider.dart';
import '../../providers/enhanced_auth_provider.dart';
import '../../providers/notification_provider.dart';
import 'models/homepage_models.dart';
import 'widgets/modern_bottom_drawer.dart';
import '../notifications/notifications_page.dart';
import '../../../data/services/click_tracking_service.dart';
import '../../widgets/common/toss_scaffold.dart';
import '../../widgets/common/toss_loading_view.dart';
import '../../../core/navigation/safe_navigation.dart';
import 'package:myfinance_improved/core/themes/index.dart';
import 'package:myfinance_improved/core/themes/toss_border_radius.dart';
import '../../../core/notifications/services/production_token_service.dart';
import '../../../core/notifications/repositories/notification_repository.dart';
import 'package:flutter/foundation.dart';
class HomePageRedesigned extends ConsumerStatefulWidget {
  const HomePageRedesigned({super.key});

  @override
  ConsumerState<HomePageRedesigned> createState() => _HomePageRedesignedState();
}

class _HomePageRedesignedState extends ConsumerState<HomePageRedesigned> with WidgetsBindingObserver {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _isNavigating = false; // Add flag to prevent multiple navigations

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    
    // Ensure company and store are always selected on homepage load
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      _ensureCompanyAndStoreSelected();
      
      // Also ensure FCM token is saved when homepage loads
      // This catches cases where login didn't save the token
      await _ensureFcmTokenSaved();
    });
    
    // Listen for store join events to refresh UI
    _setupStoreJoinListener();
  }
  
  void _setupStoreJoinListener() {
    // This will be called from build method to properly listen
    // The actual listening is done in the build method using ref.listen
  }
  
  bool _shouldRefreshStores(dynamic previousData, dynamic currentData) {
    if (previousData == null || currentData == null) return false;
    
    // Check if store count changed in any company
    final previousCompanies = previousData['companies'] as List? ?? [];
    final currentCompanies = currentData['companies'] as List? ?? [];
    
    for (final currentCompany in currentCompanies) {
      final companyId = currentCompany['company_id'];
      final previousCompany = previousCompanies.firstWhere(
        (c) => c['company_id'] == companyId,
        orElse: () => null,
      );
      
      if (previousCompany != null) {
        final previousStores = previousCompany['stores'] as List? ?? [];
        final currentStores = currentCompany['stores'] as List? ?? [];
        
        if (currentStores.length > previousStores.length) {
          return true; // New store added
        }
      }
    }
    
    return false;
  }

  /// Ensures first company and first store are always selected on homepage entry
  Future<void> _ensureCompanyAndStoreSelected() async {
    try {
      if (!mounted) return;
      
      final appStateNotifier = ref.read(appStateProvider.notifier);
      final currentState = ref.read(appStateProvider);
      
      // Get user data from app state (already loaded by userCompaniesProvider)
      final userData = currentState.user;
      
      // If no user data yet, wait for it to load
      if (userData == null || (userData is Map && userData.isEmpty)) {
        return;
      }
      
      final companies = userData['companies'] as List<dynamic>? ?? [];
      
      if (companies.isEmpty) {
        return; // No companies available
      }
      
      bool stateChanged = false;
      
      // CASE 1: No company selected - auto-select first company and its first store
      if (currentState.companyChoosen.isEmpty) {
        final firstCompany = companies.first;
        final companyId = firstCompany['company_id'] as String;
        
        await appStateNotifier.setCompanyChoosen(companyId);
        stateChanged = true;
        
        // Auto-select first store from first company
        final stores = firstCompany['stores'] as List<dynamic>? ?? [];
        if (stores.isNotEmpty) {
          final firstStore = stores.first;
          final storeId = firstStore['store_id'] as String;
          await appStateNotifier.setStoreChoosen(storeId);
        }
      } 
      // CASE 2: Company selected but validate and ensure store is selected
      else {
        final selectedCompanyExists = companies.any((company) => 
          company['company_id'] == currentState.companyChoosen);
          
        if (!selectedCompanyExists) {
          // Selected company no longer exists - fallback to first company
          final firstCompany = companies.first;
          final companyId = firstCompany['company_id'] as String;
          
          await appStateNotifier.setCompanyChoosen(companyId);
          await appStateNotifier.setStoreChoosen(''); // Reset store selection
          stateChanged = true;
          
          // Auto-select first store from new company
          final stores = firstCompany['stores'] as List<dynamic>? ?? [];
          if (stores.isNotEmpty) {
            final firstStore = stores.first;
            final storeId = firstStore['store_id'] as String;
            await appStateNotifier.setStoreChoosen(storeId);
          }
        } else {
          // Company exists - ensure store is selected
          final selectedCompany = companies.firstWhere((company) => 
            company['company_id'] == currentState.companyChoosen);
          final stores = selectedCompany['stores'] as List<dynamic>? ?? [];
          
          // Check if current store selection is valid
          bool hasValidStore = false;
          if (currentState.storeChoosen.isNotEmpty) {
            hasValidStore = stores.any((store) => 
              store['store_id'] == currentState.storeChoosen);
          }
          
          // If no store selected or invalid store, auto-select first store
          if (currentState.storeChoosen.isEmpty || !hasValidStore) {
            if (stores.isNotEmpty) {
              final firstStore = stores.first;
              final storeId = firstStore['store_id'] as String;
              await appStateNotifier.setStoreChoosen(storeId);
              stateChanged = true;
            }
          }
        }
      }
      
      if (stateChanged && mounted) {
        // Force UI rebuild to reflect new selections
        setState(() {});
      }
      
    } catch (e) {
      // Silent error handling - don't crash the homepage
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // Handle app lifecycle changes if needed
  }

  @override
  Widget build(BuildContext context) {
    final userCompaniesAsync = ref.watch(userCompaniesProvider);
    // Use filtered categories to ensure is_show_main filtering is applied
    final categoriesAsync = ref.watch(categoriesWithFeaturesProvider);
    // Watch the selections so they update when changed
    final selectedCompany = ref.watch(selectedCompanyProvider);
    final selectedStore = ref.watch(selectedStoreProvider);
    
    // Listen for changes to user companies to detect new store joins
    ref.listen(userCompaniesProvider, (previous, next) {
      next.whenData((data) {
        // Check if store count changed
        if (previous != null && previous.hasValue) {
          final previousData = previous.valueOrNull;
          if (_shouldRefreshStores(previousData, data)) {
            // Show a snackbar to indicate refresh
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Row(
                  children: [
                    Icon(Icons.refresh, color: TossColors.white, size: 20),
                    SizedBox(width: TossSpacing.space3),
                    Text('Store list updated'),
                  ],
                ),
                backgroundColor: TossColors.primary,
                behavior: SnackBarBehavior.floating,
                duration: Duration(seconds: 2),
              ),
            );
          }
        }
      });
    });

    return TossScaffold(
      scaffoldKey: _scaffoldKey,
      backgroundColor: TossColors.gray100, // Proper Toss background color
      body: Stack(
        children: [
          // Main Content
          userCompaniesAsync.when(
            data: (userData) => RefreshIndicator(
              onRefresh: () => _handleRefresh(ref),
              color: TossColors.primary,
              child: CustomScrollView(
                slivers: [
                  // Simple App Bar
                  _buildSimpleAppBar(context, userData),
                  
                  // Pinned Hello Section
                  _buildPinnedHelloSection(context, userData, selectedCompany, selectedStore),
                  
                  // Revenue Card Section (only show if store is selected AND user has revenue feature)
                  if (ref.watch(appStateProvider).storeChoosen.isNotEmpty && 
                      _hasRevenueFeature(ref))
                    SliverToBoxAdapter(
                      child: const RevenueCard(),
                    ),
                  
                  // Shift Overview Card Section (show if store selected but NO revenue feature)
                  if (ref.watch(appStateProvider).storeChoosen.isNotEmpty && 
                      !_hasRevenueFeature(ref))
                    SliverToBoxAdapter(
                      child: _buildShiftOverviewCard(ref),
                    ),
                  
                  // Add spacing after Revenue card or Hello section
                  SliverToBoxAdapter(
                    child: SizedBox(height: TossSpacing.space4),
                  ),
                  
                  // Quick Actions Section
                  _buildQuickActionsSection(categoriesAsync),
                  
                  // Main Features
                  _buildMainFeaturesSection(categoriesAsync),
                ],
              ),
            ),
            loading: () => Center(
              child: TossLoadingView(),
            ),
            error: (error, stack) => Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 48, color: TossColors.error),
                  const SizedBox(height: TossSpacing.space4),
                  Text('Something went wrong', style: TossTextStyles.h3),
                  const SizedBox(height: TossSpacing.space2),
                  Text(error.toString(), style: TossTextStyles.caption),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Check if user has the revenue feature permission
  bool _hasRevenueFeature(WidgetRef ref) {
    const revenueFeatureId = 'aef426a2-c50a-4ce2-aee9-c6509cfbd571';
    
    try {
      // Get user data from userCompaniesProvider
      final userDataAsync = ref.watch(userCompaniesProvider);
      
      return userDataAsync.maybeWhen(
        data: (userData) {
          if (userData == null) return false;
          
          final companies = userData['companies'] as List<dynamic>? ?? [];
          
          // Search through all companies and their permissions
          for (final company in companies) {
            final role = company['role'] as Map<String, dynamic>?;
            if (role != null) {
              final permissions = role['permissions'] as List<dynamic>? ?? [];
              
              // Check if the revenue feature ID is in the permissions
              if (permissions.contains(revenueFeatureId)) {
                return true;
              }
            }
          }
          
          return false;
        },
        orElse: () => false,
      );
    } catch (e) {
      return false;
    }
  }
  
  /// Build shift overview card for users without revenue feature
  Widget _buildShiftOverviewCard(WidgetRef ref) {
    final shiftOverviewAsync = ref.watch(userShiftOverviewProvider);
    
    return Container(
      margin: const EdgeInsets.all(TossSpacing.space4),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            TossColors.primary,
            TossColors.primary.withOpacity(0.8),
          ],
        ),
        borderRadius: BorderRadius.circular(TossBorderRadius.xxxl),
        boxShadow: TossShadows.elevation3,
      ),
      child: Padding(
        padding: const EdgeInsets.all(TossSpacing.space6),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header - This Month Estimated Salary
            Text(
              'This Month Estimated Salary',
              style: TossTextStyles.h3.copyWith(
                color: TossColors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
            
            const SizedBox(height: TossSpacing.space4),
            
            // Salary amount
            shiftOverviewAsync.when(
              data: (shiftData) {
                if (shiftData == null) {
                  return _buildNoDataState();
                }
                
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Format salary amount
                    Text(
                      '${shiftData.currencySymbol}${_formatCurrency(shiftData.estimatedSalary.toInt())}',
                      style: TossTextStyles.display.copyWith(
                        color: TossColors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 36,
                      ),
                    ),
                        const SizedBox(height: TossSpacing.space3),
                        
                        // Quick stats row
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _buildShiftStat(
                              'Work Shifts',
                              '${shiftData.actualWorkDays}',
                              Icons.calendar_today,
                            ),
                            _buildShiftStat(
                              'Work Hours',
                              '${shiftData.actualWorkHours.toStringAsFixed(1)}',
                              Icons.access_time,
                            ),
                            _buildShiftStat(
                              'Overtime',
                              '${shiftData.overtimeTotal.toInt()}',
                              Icons.trending_up,
                            ),
                          ],
                        ),
                      ],
                    );
                  },
                  loading: () => _buildLoadingSalary(),
                  error: (error, _) => _buildErrorSalary(),
                ),
              ],
            ),
      ),
    );
  }
  
  Widget _buildShiftStat(String label, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(TossSpacing.space2),
      decoration: BoxDecoration(
        color: TossColors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(TossBorderRadius.lg),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: TossColors.white.withOpacity(0.9),
            size: 20,
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TossTextStyles.body.copyWith(
              color: TossColors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            label,
            style: TossTextStyles.caption.copyWith(
              color: TossColors.white.withOpacity(0.8),
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildLoadingSalary() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 200,
          height: 36,
          decoration: BoxDecoration(
            color: TossColors.white.withOpacity(0.2),
            borderRadius: BorderRadius.circular(TossBorderRadius.md),
          ),
        ),
        const SizedBox(height: TossSpacing.space2),
        Container(
          width: 150,
          height: 20,
          decoration: BoxDecoration(
            color: TossColors.white.withOpacity(0.15),
            borderRadius: BorderRadius.circular(TossBorderRadius.xs),
          ),
        ),
      ],
    );
  }
  
  Widget _buildErrorSalary() {
    return Container(
      padding: const EdgeInsets.all(TossSpacing.space3),
      decoration: BoxDecoration(
        color: TossColors.error.withOpacity(0.2),
        borderRadius: BorderRadius.circular(TossBorderRadius.lg),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.error_outline,
            color: TossColors.white,
            size: 20,
          ),
          const SizedBox(width: TossSpacing.space2),
          Expanded(
            child: Text(
              'Unable to load salary data',
              style: TossTextStyles.body.copyWith(
                color: TossColors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildNoDataState() {
    return Text(
      'No salary data available',
      style: TossTextStyles.body.copyWith(
        color: TossColors.white.withOpacity(0.8),
      ),
    );
  }

  Widget _buildSimpleAppBar(BuildContext context, dynamic userData) {
    return SliverAppBar(
      pinned: true,
      floating: false,
      snap: false,
      backgroundColor: TossColors.gray100, // Seamless with body background
      surfaceTintColor: TossColors.transparent,
      shadowColor: TossColors.transparent,
      elevation: 0,
      toolbarHeight: 64, // Slightly taller for better visual weight
      leading: IconButton(
        icon: Icon(Icons.menu, color: TossColors.textSecondary, size: 24),
        onPressed: () {
          final userData = ref.read(userCompaniesProvider).maybeWhen(
            data: (data) => data,
            orElse: () => null,
          );
          if (userData != null) {
            ModernBottomDrawer.show(
              context: context,
              userData: userData,
            );
          }
        },
        padding: EdgeInsets.all(TossSpacing.space3),
      ),
      actions: [
        // Notifications with unread count badge
        Consumer(
          builder: (context, ref, child) {
            final unreadCountAsync = ref.watch(unreadNotificationCountProvider);
            
            return IconButton(
              icon: unreadCountAsync.when(
                data: (unreadCount) => AnimatedNotificationBadge(
                  count: unreadCount,
                  animate: true,
                  child: Icon(
                    Icons.notifications_none_rounded,
                    color: TossColors.textSecondary,
                    size: 24,
                  ),
                ),
                loading: () => AnimatedNotificationBadge(
                  count: 0,
                  animate: false,
                  child: Icon(
                    Icons.notifications_none_rounded,
                    color: TossColors.textSecondary,
                    size: 24,
                  ),
                ),
                error: (_, __) => AnimatedNotificationBadge(
                  count: 0,
                  animate: false,
                  child: Icon(
                    Icons.notifications_none_rounded,
                    color: TossColors.textSecondary,
                    size: 24,
                  ),
                ),
              ),
              onPressed: () {
                // Navigate to notifications page
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const NotificationsPage(),
                  ),
                ).then((_) {
                  // Refresh unread count when returning from notifications page
                  ref.invalidate(unreadNotificationCountProvider);
                });
              },
              padding: EdgeInsets.all(TossSpacing.space3),
            );
          },
        ),
        // Profile with improved Toss styling
        Padding(
          padding: EdgeInsets.only(right: TossSpacing.space4),
          child: SafePopupMenuButton<String>(
            offset: const Offset(0, 48),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(TossSpacing.space3),
            ),
            color: TossColors.surface,
            elevation: 2, // Reduced for cleaner look
            onSelected: (value) async {
              // Add safety check for widget lifecycle
              if (!mounted) return;
              
              if (value == 'settings') {
                // Navigate to My Page (user profile) with safety check
                if (mounted) {
                  context.safePush('/myPage');
                }
              } else if (value == 'debug') {
                // Navigate to debug page with safety check
                if (mounted) {
                  context.safePush('/debug/supabase');
                }
              } else if (value == 'notifications') {
                // Navigate to notification debug page
                if (mounted) {
                  context.safePush('/debug/notifications');
                }
              } else if (value == 'fcm_debug') {
                // Navigate to FCM token debug page
                if (mounted) {
                  context.safePush('/debug/fcm-token');
                }
              } else if (value == 'theme_monitor') {
                // Navigate to Theme Monitor page
                if (mounted) {
                  context.safePush('/debug/theme-monitor');
                }
              } else if (value == 'widget_analyzer') {
                // Navigate to Widget Consistency Analyzer page
                if (mounted) {
                  context.safePush('/debug/widget-analyzer');
                }
              } else if (value == 'logout') {
                // 🔧 SAFE LOGOUT: The SafePopupMenuButton now handles menu closing
                // and mounted checks internally, so we can directly execute logout
                try {
                  final enhancedAuth = ref.read(enhancedAuthProvider);
                  await enhancedAuth.signOut();
                } catch (e) {
                  // Handle logout error silently
                }
              }
            },
            itemBuilder: (BuildContext context) => [
              PopupMenuItem<String>(
                value: 'settings',
                child: Row(
                  children: [
                    Icon(
                      Icons.person_outline,
                      color: TossColors.textSecondary,
                      size: 20,
                    ),
                    SizedBox(width: TossSpacing.space3),
                    Text(
                      'My Profile',
                      style: TossTextStyles.body.copyWith(
                        color: TossColors.textPrimary,
                      ),
                    ),
                  ],
                ),
              ),
              PopupMenuItem<String>(
                value: 'debug',
                child: Row(
                  children: [
                    Icon(
                      Icons.bug_report_outlined,
                      color: TossColors.textSecondary,
                      size: 20,
                    ),
                    SizedBox(width: TossSpacing.space3),
                    Text(
                      'Debug Connection',
                      style: TossTextStyles.body.copyWith(
                        color: TossColors.textPrimary,
                      ),
                    ),
                  ],
                ),
              ),
              PopupMenuItem<String>(
                value: 'notifications',
                child: Row(
                  children: [
                    Icon(
                      Icons.notifications_outlined,
                      color: TossColors.textSecondary,
                      size: 20,
                    ),
                    SizedBox(width: TossSpacing.space3),
                    Text(
                      '🔔 Test Notifications',
                      style: TossTextStyles.body.copyWith(
                        color: TossColors.textPrimary,
                      ),
                    ),
                  ],
                ),
              ),
              PopupMenuItem<String>(
                value: 'fcm_debug',
                child: Row(
                  children: [
                    Icon(
                      Icons.key,
                      color: TossColors.textSecondary,
                      size: 20,
                    ),
                    SizedBox(width: TossSpacing.space3),
                    Text(
                      '🔑 FCM Token Debug',
                      style: TossTextStyles.body.copyWith(
                        color: TossColors.textPrimary,
                      ),
                    ),
                  ],
                ),
              ),
              PopupMenuItem<String>(
                value: 'theme_monitor',
                child: Row(
                  children: [
                    Icon(
                      Icons.palette_outlined,
                      color: TossColors.textSecondary,
                      size: 20,
                    ),
                    SizedBox(width: TossSpacing.space3),
                    Text(
                      '🎨 Theme Monitor',
                      style: TossTextStyles.body.copyWith(
                        color: TossColors.textPrimary,
                      ),
                    ),
                  ],
                ),
              ),
              PopupMenuItem<String>(
                value: 'widget_analyzer',
                child: Row(
                  children: [
                    Icon(
                      Icons.widgets_outlined,
                      color: TossColors.textSecondary,
                      size: 20,
                    ),
                    SizedBox(width: TossSpacing.space3),
                    Text(
                      '🔬 Widget Analyzer',
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
                    SizedBox(width: TossSpacing.space3),
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
            child: CircleAvatar(
              radius: 20, // Slightly larger for better visual weight
              backgroundImage: userData != null && (userData['profile_image'] ?? '').isNotEmpty
                  ? NetworkImage(userData['profile_image'])
                  : null,
              backgroundColor: TossColors.primary.withValues(alpha: 0.1),
              child: userData == null || (userData['profile_image'] ?? '').isEmpty
                  ? Text(
                      userData != null && (userData['user_first_name'] ?? '').isNotEmpty 
                          ? userData['user_first_name'][0] 
                          : 'U',
                      style: TossTextStyles.bodyLarge.copyWith(
                        color: TossColors.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    )
                  : null,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPinnedHelloSection(BuildContext context, dynamic userData, dynamic selectedCompany, dynamic selectedStore) {
    // Check if user has any companies
    final companies = userData != null ? (userData['companies'] as List<dynamic>? ?? []) : [];
    final hasNoCompanies = companies.isEmpty;
    
    // If no companies, show enhanced onboarding experience
    if (hasNoCompanies) {
      return SliverToBoxAdapter(
        child: Container(
          margin: EdgeInsets.all(TossSpacing.space4),
          padding: EdgeInsets.all(TossSpacing.space5),
          decoration: BoxDecoration(
            color: TossColors.primary.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(TossBorderRadius.xl),
            border: Border.all(
              color: TossColors.primary.withValues(alpha: 0.2),
              width: 1,
            ),
          ),
          child: Column(
            children: [
              Icon(
                Icons.business,
                size: 48,
                color: TossColors.primary,
              ),
              SizedBox(height: TossSpacing.space4),
              Text(
                'Welcome to Storebase!',
                style: TossTextStyles.h2.copyWith(
                  color: TossColors.textPrimary,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: TossSpacing.space2),
              Text(
                'Complete your business setup to access powerful features',
                textAlign: TextAlign.center,
                style: TossTextStyles.body.copyWith(
                  color: TossColors.textSecondary,
                ),
              ),
              SizedBox(height: TossSpacing.space4),
              
              // Feature preview cards
              _buildFeaturePreviewCards(),
              
              SizedBox(height: TossSpacing.space5),
              ElevatedButton.icon(
                onPressed: () {
                  context.safeGo('/onboarding/choose-role');
                },
                icon: Icon(Icons.arrow_forward),
                label: Text('Get Started'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: TossColors.primary,
                  foregroundColor: TossColors.white,
                  padding: EdgeInsets.symmetric(
                    horizontal: TossSpacing.space5,
                    vertical: TossSpacing.space3,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(TossBorderRadius.lg),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }
    
    return SliverPersistentHeader(
      pinned: true,
      delegate: _PinnedHelloDelegate(
        userData: userData,
        selectedCompany: selectedCompany,
        selectedStore: selectedStore,
        context: context,
      ),
    );
  }


  Widget _buildQuickActionsSection(AsyncValue<dynamic> categoriesAsync) {
    // Check if user has companies first
    final userData = ref.watch(userCompaniesProvider).valueOrNull;
    final hasNoCompanies = userData == null || 
                          (userData['companies'] as List?)?.isEmpty == true;
    
    // Don't show quick actions if no companies
    if (hasNoCompanies) {
      return const SliverToBoxAdapter(child: SizedBox.shrink());
    }
    
    // Use the same categoriesAsync parameter as main features for consistency
    return SliverToBoxAdapter(
      child: categoriesAsync.when(
        data: (categoriesData) {
          
          // Now that categories are loaded, get top features (which will be filtered)
          final topFeaturesAsync = ref.watch(topFeaturesByUserProvider);
          
          return topFeaturesAsync.when(
            data: (topFeatures) => _buildQuickActionsContent(topFeatures),
            loading: () => _buildQuickActionsLoading(),
            error: (error, stackTrace) => _buildQuickActionsError(error, stackTrace),
          );
        },
        loading: () {
          return _buildQuickActionsLoading();
        },
        error: (error, stackTrace) {
          return _buildQuickActionsError(error, stackTrace);
        },
      ),
    );
  }

  /// Content builder for quick actions (extracted for clarity)
  Widget _buildQuickActionsContent(List<TopFeature> topFeatures) {
    if (topFeatures.isEmpty) {
      
      // 🎯 OPTIONAL: Show progress hint to encourage exploration (disabled for now)
      // return _buildQuickAccessProgress();
      
      // Clean UX: Hide completely until user has enough real usage
      return const SizedBox.shrink();
    }
    
    // Take only the first 6 features for the quick actions grid
    final quickFeatures = topFeatures.take(6).toList();
    
    return Container(
      color: TossColors.gray100,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: TossSpacing.space4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Quick Actions container with white background and blue label
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(TossSpacing.space5),
              decoration: BoxDecoration(
                color: TossColors.surface,
                borderRadius: BorderRadius.circular(TossBorderRadius.xxl),
                border: Border.all(
                  color: TossColors.borderLight,
                  width: 0.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: TossColors.textPrimary.withValues(alpha: 0.02),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Blue label header (like Finance section)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 4,
                            height: 20,
                            decoration: BoxDecoration(
                              color: TossColors.primary, // Blue accent line
                              borderRadius: BorderRadius.circular(TossBorderRadius.xs),
                            ),
                          ),
                          SizedBox(width: TossSpacing.space3),
                          Text(
                            'Quick Actions',
                            style: TossTextStyles.h3.copyWith(
                              color: TossColors.textPrimary,
                              fontWeight: FontWeight.w700,
                              letterSpacing: -0.4,
                            ),
                          ),
                        ],
                      ),
                      // "Most Used" indicator
                      Text(
                        'Most Used',
                        style: TossTextStyles.caption.copyWith(
                          color: TossColors.textTertiary,
                          fontWeight: FontWeight.w500,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: TossSpacing.space4),
                  
                  // Adaptive Grid/Layout for Quick Actions
                  _buildAdaptiveQuickActionsLayout(quickFeatures),
                ],
              ),
            ),
            SizedBox(height: TossSpacing.space6), // Space before next section
          ],
        ),
      ),
    );
  }


  Widget _buildQuickActionsLoading() {
    return Container(
      color: TossColors.gray100,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: TossSpacing.space4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Quick Actions loading container with white background and blue label
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(TossSpacing.space5),
              decoration: BoxDecoration(
                color: TossColors.surface,
                borderRadius: BorderRadius.circular(TossBorderRadius.xxl),
                border: Border.all(
                  color: TossColors.borderLight,
                  width: 0.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: TossColors.textPrimary.withValues(alpha: 0.02),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Blue label header (like Finance section)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 4,
                            height: 20,
                            decoration: BoxDecoration(
                              color: TossColors.primary, // Blue accent line
                              borderRadius: BorderRadius.circular(TossBorderRadius.xs),
                            ),
                          ),
                          SizedBox(width: TossSpacing.space3),
                          Text(
                            'Quick Actions',
                            style: TossTextStyles.h3.copyWith(
                              color: TossColors.textPrimary,
                              fontWeight: FontWeight.w700,
                              letterSpacing: -0.4,
                            ),
                          ),
                        ],
                      ),
                      // Loading indicator
                      Text(
                        'Loading...',
                        style: TossTextStyles.caption.copyWith(
                          color: TossColors.textTertiary,
                          fontWeight: FontWeight.w500,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: TossSpacing.space4),
                  
                  // Grid of loading skeletons
                  GridView.builder(
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: TossSpacing.space3, // Reduced from space4 to space3
                      mainAxisSpacing: TossSpacing.space3,  // Reduced from space5 to space3
                      childAspectRatio: 0.85, // Reduced from 0.95 to 0.85 for more height
                    ),
                    itemCount: 6,
                    itemBuilder: (context, index) {
                      return Container(
                        padding: EdgeInsets.symmetric(vertical: TossSpacing.space1), // Reduced padding
                        decoration: BoxDecoration(
                          color: TossColors.transparent,
                          borderRadius: BorderRadius.circular(TossBorderRadius.lg),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min, // Added to prevent overflow
                          children: [
                            // Skeleton icon container
                            Container(
                              width: 44, // Reduced from 48 to 44 to match updated size
                              height: 44, // Reduced from 48 to 44 to match updated size
                              decoration: BoxDecoration(
                                color: TossColors.gray200,
                                borderRadius: BorderRadius.circular(TossBorderRadius.lg), // Reduced from 14 to 12
                              ),
                            ),
                            SizedBox(height: TossSpacing.space1), // Reduced from space2 to space1
                            // Skeleton text
                            Container(
                              width: 60,
                              height: 10,
                              decoration: BoxDecoration(
                                color: TossColors.gray200,
                                borderRadius: BorderRadius.circular(TossBorderRadius.xs * 1.25),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            SizedBox(height: TossSpacing.space6), // Space before next section
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActionItem(dynamic feature, String categoryId) {
    return Material(
      color: TossColors.transparent,
      child: InkWell(
        onTap: () => _handleFeatureTap(feature, categoryId),
        borderRadius: BorderRadius.circular(TossBorderRadius.lg),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: TossSpacing.space2),
          decoration: BoxDecoration(
            color: TossColors.transparent,
            borderRadius: BorderRadius.circular(TossBorderRadius.lg),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Icon with ultra-minimal Toss design
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: TossColors.gray100, // Even more subtle background
                  borderRadius: BorderRadius.circular(TossBorderRadius.lg),
                  // No border for cleaner look
                ),
                child: DynamicIcon(
                  iconKey: feature['icon_key'],
                  featureName: feature['feature_name'],
                  size: 22,
                  color: TossColors.gray700, // More neutral, less blue
                  useDefaultColor: false,
                ),
              ),
              SizedBox(height: TossSpacing.space1),
              Text(
                feature['feature_name'] ?? '',
                style: TossTextStyles.caption.copyWith(
                  color: TossColors.textPrimary,
                  fontWeight: FontWeight.w600,
                  fontSize: 13, // Increased from 11 to 13 for better readability
                  height: 1.3,
                  letterSpacing: -0.2,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Comprehensive error handling with fallback options
  /// SECURITY: Attempts fallback provider if main provider fails
  Widget _buildQuickActionsError(Object error, StackTrace stackTrace) {
    
    return Container(
      color: TossColors.gray100,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: TossSpacing.space4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Error container with user-friendly message
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(TossSpacing.space5),
              decoration: BoxDecoration(
                color: TossColors.surface,
                borderRadius: BorderRadius.circular(TossBorderRadius.xxl),
                border: Border.all(
                  color: TossColors.borderLight,
                  width: 0.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: TossColors.textPrimary.withValues(alpha: 0.02),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Error header with retry option
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 4,
                            height: 20,
                            decoration: BoxDecoration(
                              color: TossColors.warning,
                              borderRadius: BorderRadius.circular(TossBorderRadius.xs),
                            ),
                          ),
                          SizedBox(width: TossSpacing.space3),
                          Text(
                            'Quick Actions',
                            style: TossTextStyles.h3.copyWith(
                              color: TossColors.textPrimary,
                              fontWeight: FontWeight.w700,
                              letterSpacing: -0.4,
                            ),
                          ),
                        ],
                      ),
                      // Retry button
                      TextButton.icon(
                        onPressed: () {
                          // Invalidate the provider to retry
                          ref.invalidate(topFeaturesByUserProvider);
                        },
                        icon: Icon(
                          Icons.refresh, 
                          size: 16, 
                          color: TossColors.primary,
                        ),
                        label: Text(
                          'Retry',
                          style: TossTextStyles.caption.copyWith(
                            color: TossColors.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.symmetric(
                            horizontal: TossSpacing.space2,
                            vertical: TossSpacing.space1,
                          ),
                          minimumSize: Size.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: TossSpacing.space3),
                  
                  // User-friendly error message
                  Container(
                    padding: EdgeInsets.all(TossSpacing.space3),
                    decoration: BoxDecoration(
                      color: TossColors.warning.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(TossBorderRadius.lg),
                      border: Border.all(
                        color: TossColors.warning.withValues(alpha: 0.3),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.info_outline,
                          size: 20,
                          color: TossColors.warning,
                        ),
                        SizedBox(width: TossSpacing.space2),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Quick Actions Temporarily Unavailable',
                                style: TossTextStyles.body.copyWith(
                                  color: TossColors.textPrimary,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 13,
                                ),
                              ),
                              SizedBox(height: TossSpacing.space1),
                              Text(
                                'You can still access all features from the main sections below.',
                                style: TossTextStyles.caption.copyWith(
                                  color: TossColors.textSecondary,
                                  fontSize: 12,
                                  height: 1.3,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: TossSpacing.space6),
          ],
        ),
      ),
    );
  }

  /// Adaptive layout that handles different numbers of features gracefully
  /// SECURITY: Shows properly filtered features from topFeaturesByUserProvider
  Widget _buildAdaptiveQuickActionsLayout(List<TopFeature> quickFeatures) {
    if (quickFeatures.isEmpty) return const SizedBox.shrink();
    
    final featureCount = quickFeatures.length;
    
    // Handle single item with centered, larger display
    if (featureCount == 1) {
      return Center(
        child: Container(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.4, // 40% of screen width
          ),
          child: _buildQuickActionItemFromTopFeature(quickFeatures.first),
        ),
      );
    }
    
    // Handle two items side by side
    if (featureCount == 2) {
      return Row(
        children: quickFeatures.map((feature) => 
          Expanded(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: TossSpacing.space1),
              child: _buildQuickActionItemFromTopFeature(feature),
            ),
          ),
        ).toList(),
      );
    }
    
    // Handle 3+ items with adaptive grid
    final columns = featureCount >= 6 ? 3 : 
                   featureCount >= 4 ? 3 : 
                   featureCount == 3 ? 3 : 2;
    
    return GridView.builder(
      padding: EdgeInsets.zero,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: columns,
        crossAxisSpacing: TossSpacing.space3,
        mainAxisSpacing: TossSpacing.space3,
        childAspectRatio: 0.85,
      ),
      itemCount: featureCount,
      itemBuilder: (context, index) {
        final feature = quickFeatures[index];
        return _buildQuickActionItemFromTopFeature(feature);
      },
    );
  }

  Widget _buildQuickActionItemFromTopFeature(TopFeature feature) {
    return Material(
      color: TossColors.transparent,
      child: InkWell(
        onTap: () {
          // Navigate directly using the route from TopFeature
          context.safePush('/${feature.route}');
          
          // Track the click if needed
          final clickService = ref.read(clickTrackingServiceProvider);
          clickService.trackFeatureClick(
            featureId: feature.featureId,
            featureName: feature.featureName,
            categoryId: feature.categoryId ?? '',
          );
        },
        borderRadius: BorderRadius.circular(TossBorderRadius.lg),
        splashColor: TossColors.primary.withValues(alpha: 0.1),
        highlightColor: TossColors.primary.withValues(alpha: 0.05),
        child: AnimatedContainer(
          duration: TossAnimations.normal,
          curve: TossAnimations.standard,
          padding: EdgeInsets.symmetric(vertical: TossSpacing.space1), // Reduced padding
          decoration: BoxDecoration(
            color: TossColors.transparent,
            borderRadius: BorderRadius.circular(TossBorderRadius.lg),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min, // Added to prevent overflow
            children: [
              // Icon with ultra-minimal Toss design and hover effect
              AnimatedContainer(
                duration: TossAnimations.normal,
                curve: TossAnimations.standard,
                width: 44, // Reduced from 48 to 44
                height: 44, // Reduced from 48 to 44
                decoration: BoxDecoration(
                  color: TossColors.gray100, // Even more subtle background
                  borderRadius: BorderRadius.circular(TossBorderRadius.lg), // Reduced from 14 to 12
                  // No border for cleaner look
                ),
                child: DynamicIcon(
                  iconKey: feature.iconKey,
                  featureName: feature.featureName,
                  size: 20, // Reduced from 22 to 20
                  color: TossColors.gray700, // More neutral, less blue
                  useDefaultColor: false,
                ),
              ),
              SizedBox(height: TossSpacing.space1),
              Flexible( // Wrap text in Flexible to prevent overflow
                child: Text(
                  feature.featureName,
                  style: TossTextStyles.caption.copyWith(
                    color: TossColors.textPrimary,
                    fontWeight: FontWeight.w600,
                    fontSize: 12, // Reduced from 13 to 12 for better fit
                    height: 1.2, // Reduced from 1.3 to 1.2 for more compact text
                    letterSpacing: -0.2,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Build feature preview cards for onboarding users
  Widget _buildFeaturePreviewCards() {
    final previewFeatures = [
      {'name': 'Employee Management', 'icon': Icons.people, 'description': 'Manage your team'},
      {'name': 'Financial Tracking', 'icon': Icons.account_balance, 'description': 'Track your finances'},
      {'name': 'Inventory Control', 'icon': Icons.inventory, 'description': 'Manage your inventory'},
    ];
    
    return Container(
      child: Row(
        children: previewFeatures.map((feature) => Expanded(
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: TossSpacing.space1),
            padding: EdgeInsets.all(TossSpacing.space3),
            decoration: BoxDecoration(
              color: TossColors.white,
              borderRadius: BorderRadius.circular(TossBorderRadius.lg),
              border: Border.all(
                color: TossColors.borderLight,
                width: 0.5,
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: TossColors.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(TossBorderRadius.md),
                  ),
                  child: Icon(
                    feature['icon'] as IconData,
                    size: 18,
                    color: TossColors.primary,
                  ),
                ),
                SizedBox(height: TossSpacing.space2),
                Text(
                  feature['name'] as String,
                  style: TossTextStyles.caption.copyWith(
                    color: TossColors.textPrimary,
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                ),
                SizedBox(height: TossSpacing.space1),
                Text(
                  feature['description'] as String,
                  style: TossTextStyles.caption.copyWith(
                    color: TossColors.textTertiary,
                    fontSize: 10,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                ),
              ],
            ),
          ),
        )).toList(),
      ),
    );
  }

  Widget _buildMainFeaturesSection(AsyncValue<dynamic> categoriesAsync) {
    // Check if user has companies - don't show features section if no companies
    final userData = ref.watch(userCompaniesProvider).valueOrNull;
    final hasNoCompanies = userData == null || 
                          (userData['companies'] as List?)?.isEmpty == true;
    
    // Don't show features section for onboarding users
    if (hasNoCompanies) {
      return const SliverToBoxAdapter(child: SizedBox.shrink());
    }
    
    return SliverToBoxAdapter(
      child: categoriesAsync.when(
        data: (categories) {
          if (categories.isEmpty) {
            return Container(
              color: TossColors.gray100,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: TossSpacing.space4),
                child: Container(
                  padding: EdgeInsets.all(TossSpacing.space8),
                  decoration: BoxDecoration(
                    color: TossColors.surface,
                    borderRadius: BorderRadius.circular(TossBorderRadius.xxl),
                    border: Border.all(
                      color: TossColors.borderLight,
                      width: 0.5,
                    ),
                  ),
                  child: Column(
                    children: [
                      Icon(
                        Icons.sync,
                        size: 48,
                        color: TossColors.textTertiary,
                      ),
                      SizedBox(height: TossSpacing.space4),
                      Text(
                        'Setting up your workspace...',
                        style: TossTextStyles.body.copyWith(
                          color: TossColors.textSecondary,
                        ),
                      ),
                      SizedBox(height: TossSpacing.space2),
                      Text(
                        'Please wait while we load your features',
                        style: TossTextStyles.caption.copyWith(
                          color: TossColors.textTertiary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }

          return Container(
            color: TossColors.gray100,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: TossSpacing.space4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Enhanced "All Features" header
                  Text(
                    'All Features',
                    style: TossTextStyles.h2.copyWith(
                      color: TossColors.textPrimary,
                      fontWeight: FontWeight.w800, // Stronger weight for better hierarchy
                      letterSpacing: -0.6,
                    ),
                  ),
                  SizedBox(height: TossSpacing.space4),
                  ...categories.map((category) => _buildCategorySection(category)),
                  SizedBox(height: TossSpacing.space10), // Proper bottom spacing
                ],
              ),
            ),
          );
        },
        loading: () => Container(
          color: TossColors.gray100,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: TossSpacing.space4),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'All Features',
                  style: TossTextStyles.h2.copyWith(
                    color: TossColors.textPrimary,
                    fontWeight: FontWeight.w800, // Stronger weight for better hierarchy
                    letterSpacing: -0.6,
                  ),
                ),
                SizedBox(height: TossSpacing.space6),
                Center(
                  child: TossLoadingView(),
                ),
              ],
            ),
          ),
        ),
        error: (error, _) => Container(
          color: TossColors.gray100,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: TossSpacing.space4),
            child: Container(
              padding: EdgeInsets.all(TossSpacing.space6),
              decoration: BoxDecoration(
                color: TossColors.surface,
                borderRadius: BorderRadius.circular(TossBorderRadius.xxl),
                border: Border.all(
                  color: TossColors.borderLight,
                  width: 0.5,
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.error_outline,
                    color: TossColors.error,
                    size: 24,
                  ),
                  SizedBox(width: TossSpacing.space3),
                  Expanded(
                    child: Text(
                      'Unable to load features',
                      style: TossTextStyles.body.copyWith(
                        color: TossColors.textPrimary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCategorySection(dynamic category) {
    return Container(
      margin: EdgeInsets.only(bottom: TossSpacing.space4),
      padding: EdgeInsets.all(TossSpacing.space5), // More generous padding
      decoration: BoxDecoration(
        color: TossColors.surface,
        borderRadius: BorderRadius.circular(TossBorderRadius.xxl), // More rounded for modern look
        border: Border.all(
          color: TossColors.borderLight,
          width: 0.5,
        ),
        boxShadow: [
          BoxShadow(
            color: TossColors.textPrimary.withValues(alpha: 0.02),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Category Header with Toss-style minimal design
          Row(
            children: [
              Container(
                width: 4,
                height: 20,
                decoration: BoxDecoration(
                  color: TossColors.primary,
                  borderRadius: BorderRadius.circular(TossBorderRadius.xs),
                ),
              ),
              SizedBox(width: TossSpacing.space3),
              Text(
                category['category_name'] ?? '',
                style: TossTextStyles.h3.copyWith(
                  color: TossColors.textPrimary,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.4,
                ),
              ),
            ],
          ),
          SizedBox(height: TossSpacing.space4),
          
          // Features List with improved spacing
          ...(category['features'] as List<dynamic>? ?? []).asMap().entries.map((entry) {
            final index = entry.key;
            final feature = entry.value;
            final features = category['features'] as List<dynamic>? ?? [];
            return Column(
              children: [
                _buildFeatureListItem(feature, category['category_id']),
                if (index < features.length - 1)
                  Container(
                    margin: EdgeInsets.symmetric(vertical: TossSpacing.space2),
                    height: 0.5,
                    color: TossColors.borderLight,
                  ),
              ],
            );
          }),
        ],
      ),
    );
  }

  Widget _buildFeatureListItem(dynamic feature, String categoryId) {
    return Material(
      color: TossColors.transparent,
      child: InkWell(
        onTap: () => _handleFeatureTap(feature, categoryId),
        borderRadius: BorderRadius.circular(TossBorderRadius.lg),
        splashColor: TossColors.primary.withValues(alpha: 0.08),
        highlightColor: TossColors.primary.withValues(alpha: 0.04),
        child: AnimatedContainer(
          duration: TossAnimations.normal,
          curve: TossAnimations.standard,
          padding: EdgeInsets.symmetric(
            horizontal: TossSpacing.space3, 
            vertical: TossSpacing.space3,
          ),
          child: Row(
            children: [
              // Icon with ultra-minimal Toss design and subtle animation
              AnimatedContainer(
                duration: TossAnimations.normal,
                curve: TossAnimations.standard,
                width: 44, // Slightly larger for better proportion
                height: 44,
                decoration: BoxDecoration(
                  color: TossColors.gray100, // Even more subtle background
                  borderRadius: BorderRadius.circular(TossBorderRadius.lg), // More subtle rounding
                  // No border for cleaner look
                ),
                child: DynamicIcon(
                  iconKey: feature['icon_key'],
                  featureName: feature['feature_name'],
                  size: 20,
                  color: TossColors.gray700, // More neutral, less blue
                  useDefaultColor: false,
                ),
              ),
              SizedBox(width: TossSpacing.space3),
              
              // Feature Name with Toss colors
              Expanded(
                child: Text(
                  feature['feature_name'] ?? '',
                  style: TossTextStyles.body.copyWith(
                    color: TossColors.textPrimary,
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                    letterSpacing: -0.4,
                    height: 1.3,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ),
              
              // Arrow with Toss colors and subtle animation
              AnimatedContainer(
                duration: TossAnimations.normal,
                curve: TossAnimations.standard,
                child: Icon(
                  Icons.chevron_right,
                  color: TossColors.textTertiary,
                  size: 20,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _handleFeatureTap(dynamic feature, [String? categoryId]) async {
    // Prevent multiple rapid taps
    if (_isNavigating) {
      return;
    }
    
    try {
      // Set the flag to prevent multiple navigations
      setState(() {
        _isNavigating = true;
      });
      
      // Track the feature click only if categoryId is provided
      if (categoryId != null) {
        // Use the click tracking service
        final clickTracker = ref.read(clickTrackingServiceProvider);
        await clickTracker.trackFeatureClick(
          featureId: feature['feature_id'],
          featureName: feature['feature_name'],
          categoryId: categoryId,
        );
      } else {
      }
      
      // Navigate to the feature route
      final route = feature['route'] ?? '';
      if (route.isNotEmpty) {
        // Ensure route starts with / for proper navigation
        final fullRoute = route.startsWith('/') 
            ? route 
            : '/$route';
        
        // Navigate and wait a bit before resetting the flag
        await context.safePush(fullRoute);
        
        // Reset the flag after navigation completes
        // Wait a short time to ensure navigation is stable
        await Future.delayed(const Duration(milliseconds: 100));
        if (mounted) {
          setState(() {
            _isNavigating = false;
          });
        }
      } else {
        // Show message if no route is defined
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${feature['feature_name']} coming soon!'),
            backgroundColor: TossColors.primary,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(TossBorderRadius.lg)),
          ),
        );
        // Reset the flag since we're not navigating
        setState(() {
          _isNavigating = false;
        });
      }
    } catch (e) {
      // Reset the flag on error
      if (mounted) {
        setState(() {
          _isNavigating = false;
        });
      }
      // Show error message
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error opening ${feature['feature_name']}'),
            backgroundColor: TossColors.error,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(TossBorderRadius.lg)),
          ),
        );
      }
    }
  }

  Future<void> _handleRefresh(WidgetRef ref) async {
    try {
      
      // Use the enhanced auth service for smart refresh
      final enhancedAuth = ref.read(enhancedAuthProvider);
      await enhancedAuth.forceRefreshData();
      
      // IMPORTANT: Verify and save FCM token on refresh
      await _ensureFcmTokenSaved();
      
      // Refresh revenue data if store is selected
      if (ref.read(appStateProvider).storeChoosen.isNotEmpty) {
        await ref.read(revenueProvider.notifier).fetchRevenue(forceRefresh: true);
      }
      
      // Wait for providers to update
      await Future.delayed(Duration(milliseconds: 500));
      
      
      // Show success feedback
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Data refreshed successfully'),
            backgroundColor: TossColors.success,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(TossBorderRadius.lg)),
          ),
        );
      }
    } catch (e) {
      
      // Show error feedback
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to refresh: ${e.toString()}'),
            backgroundColor: TossColors.error,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(TossBorderRadius.lg)),
          ),
        );
      }
    }
  }

  // Helper method to format currency without decimals
  String _formatCurrency(int amount) {
    final formatter = NumberFormat('#,###', 'en_US');
    return formatter.format(amount);
  }

  /// Ensure FCM token is saved to Supabase - called on refresh
  Future<void> _ensureFcmTokenSaved() async {
    try {
      final productionTokenService = ProductionTokenService();
      
      // First, check if token is already saved
      final isVerified = await productionTokenService.verifyTokenSaved();
      
      if (!isVerified) {
        if (kDebugMode) {
          print('🔔 FCM token not found in database - attempting to save...');
        }
        
        // Skip diagnostics - method doesn't exist
        // Just try to save the token directly
        if (kDebugMode) {
          print('📊 Attempting to save FCM token...');
        }
        
        // Try emergency token refresh if table exists but save fails
        final success = await productionTokenService.emergencyTokenRefresh();
        
        if (success && mounted) {
          if (kDebugMode) {
            print('✅ FCM token saved successfully on refresh');
          }
        } else if (!success && mounted) {
          // Show warning only in debug mode
          if (kDebugMode) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('FCM token save failed - check RLS policies'),
                backgroundColor: TossColors.warning,
                duration: Duration(seconds: 3),
              ),
            );
          }
        }
      } else {
        if (kDebugMode) {
          print('✅ FCM token already saved and verified');
        }
      }
      
      // Get production stats for monitoring
      final stats = productionTokenService.getProductionStats();
      if (kDebugMode) {
        print('📊 FCM Stats: ${stats['stats']}');
      }
      
    } catch (e) {
      if (kDebugMode) {
        print('❌ FCM token check error: $e');
      }
    }
  }
  
  /// Build dialog with FCM setup instructions
  Widget _buildFcmSetupDialog() {
    return AlertDialog(
      title: Text('FCM Token Setup Required'),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('The user_fcm_tokens table needs RLS policies.'),
            SizedBox(height: 16),
            Text('Run this SQL in Supabase:', style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: SelectableText(
                '''-- Enable RLS
ALTER TABLE user_fcm_tokens ENABLE ROW LEVEL SECURITY;

-- Allow users to insert their own tokens
CREATE POLICY "Users can insert own tokens" 
ON user_fcm_tokens FOR INSERT 
WITH CHECK (auth.uid() = user_id);

-- Allow users to update their own tokens
CREATE POLICY "Users can update own tokens" 
ON user_fcm_tokens FOR UPDATE 
USING (auth.uid() = user_id);

-- Allow users to select their own tokens
CREATE POLICY "Users can select own tokens" 
ON user_fcm_tokens FOR SELECT 
USING (auth.uid() = user_id);

-- Allow users to delete their own tokens
CREATE POLICY "Users can delete own tokens" 
ON user_fcm_tokens FOR DELETE 
USING (auth.uid() = user_id);''',
                style: TextStyle(fontFamily: 'monospace', fontSize: 12),
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text('Close'),
        ),
      ],
    );
  }

  // Removed - no longer needed since drawer is integrated in scaffold
}

class _PinnedHelloDelegate extends SliverPersistentHeaderDelegate {
  final dynamic userData;
  final dynamic selectedCompany;
  final dynamic selectedStore;
  final BuildContext context;

  _PinnedHelloDelegate({
    required this.userData,
    required this.selectedCompany,
    required this.selectedStore,
    required this.context,
  });

  @override
  double get minExtent => 85.0;

  @override
  double get maxExtent => 85.0;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: TossColors.gray100,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: TossSpacing.space4),
        decoration: BoxDecoration(
          color: TossColors.surface,
          borderRadius: BorderRadius.circular(TossBorderRadius.xl),
          boxShadow: TossShadows.card,
        ),
        padding: EdgeInsets.symmetric(
          horizontal: TossSpacing.space4,
          vertical: TossSpacing.space3,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Hello, ${userData != null ? (userData['user_first_name'] ?? 'User') : 'User'}!',
              style: TossTextStyles.h2.copyWith(
                color: TossColors.textPrimary,
                fontWeight: FontWeight.w700,
                letterSpacing: -0.5,
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
            if (selectedCompany != null) ...[
              SizedBox(height: TossSpacing.space1),
              Row(
                children: [
                  Text(
                    selectedCompany!['company_name'] ?? '',
                    style: TossTextStyles.body.copyWith(
                      color: TossColors.primary,
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      letterSpacing: -0.2,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                  if (selectedStore != null) ...[
                    Text(
                      ' • ',
                      style: TossTextStyles.body.copyWith(
                        color: TossColors.textTertiary,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        selectedStore!['store_name'] ?? '',
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
          ],
        ),
      ),
    );
  }

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return oldDelegate != this;
  }
}

// Local widget - only used in this file
class AnimatedNotificationBadge extends StatefulWidget {
  final int count;
  final Widget child;
  final bool animate;
  final Color? badgeColor;
  final Color? textColor;
  final Duration animationDuration;
  final double? maxBadgeSize;

  const AnimatedNotificationBadge({
    super.key,
    required this.count,
    required this.child,
    this.animate = true,
    this.badgeColor,
    this.textColor,
    this.animationDuration = const Duration(milliseconds: 300),
    this.maxBadgeSize,
  });

  @override
  State<AnimatedNotificationBadge> createState() => _AnimatedNotificationBadgeState();
}

class _AnimatedNotificationBadgeState extends State<AnimatedNotificationBadge>
    with TickerProviderStateMixin {
  late AnimationController _scaleController;
  late AnimationController _pulseController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _pulseAnimation;
  
  int _previousCount = 0;
  
  @override
  void initState() {
    super.initState();
    
    _previousCount = widget.count;
    
    // Scale animation for badge appearance/count change
    _scaleController = AnimationController(
      duration: widget.animationDuration,
      vsync: this,
    );
    
    _scaleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _scaleController,
      curve: Curves.elasticOut,
    ));
    
    // Subtle pulse animation for new notifications
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    
    _pulseAnimation = Tween<double>(
      begin: 1.0,
      end: 1.15,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));
    
    // Initial animation
    if (widget.count > 0) {
      _scaleController.forward();
    }
  }
  
  @override
  void didUpdateWidget(AnimatedNotificationBadge oldWidget) {
    super.didUpdateWidget(oldWidget);
    
    // Check if count changed
    if (oldWidget.count != widget.count) {
      _handleCountChange(oldWidget.count, widget.count);
    }
  }
  
  void _handleCountChange(int oldCount, int newCount) {
    setState(() {
      _previousCount = oldCount;
    });
    
    if (newCount > 0 && oldCount == 0) {
      // Badge appearing
      _scaleController.forward(from: 0.0);
      _triggerPulseIfEnabled();
    } else if (newCount == 0 && oldCount > 0) {
      // Badge disappearing
      _scaleController.reverse();
    } else if (newCount > oldCount) {
      // Count increased - subtle pulse
      _triggerPulseIfEnabled();
    }
  }
  
  void _triggerPulseIfEnabled() {
    if (!widget.animate) {
      return;
    }
    
    // Only pulse once, not repeatedly
    _pulseController.forward().then((_) {
      Future.delayed(const Duration(milliseconds: 200), () {
        if (mounted) {
          _pulseController.reverse();
        }
      });
    });
  }
  
  @override
  void dispose() {
    _scaleController.dispose();
    _pulseController.dispose();
    super.dispose();
  }
  
  String _formatCount(int count) {
    if (count > 99) {
      return '99+';
    }
    return count.toString();
  }
  
  @override
  Widget build(BuildContext context) {
    final badgeColor = widget.badgeColor ?? TossColors.primary;
    final textColor = widget.textColor ?? TossColors.white;
    
    return Stack(
      clipBehavior: Clip.none,
      children: [
        widget.child,
        if (widget.count > 0)
          Positioned(
            right: -4,
            top: -4,
            child: AnimatedBuilder(
              animation: Listenable.merge([_scaleAnimation, _pulseAnimation]),
              builder: (context, child) {
                final scale = _scaleAnimation.value * _pulseAnimation.value;
                
                return Transform.scale(
                  scale: scale,
                  child: Container(
                    constraints: BoxConstraints(
                      minWidth: 18,
                      minHeight: 18,
                      maxWidth: widget.maxBadgeSize ?? 30,
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 5,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: badgeColor,
                      borderRadius: BorderRadius.circular(TossBorderRadius.md),
                      boxShadow: [
                        BoxShadow(
                          color: badgeColor.withOpacity(0.3),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Center(
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 200),
                        transitionBuilder: (child, animation) {
                          return ScaleTransition(
                            scale: animation,
                            child: child,
                          );
                        },
                        child: Text(
                          _formatCount(widget.count),
                          key: ValueKey<int>(widget.count),
                          style: TossTextStyles.caption.copyWith(
                            color: textColor,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            height: 1.0,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
      ],
    );
  }
}