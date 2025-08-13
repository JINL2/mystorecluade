import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:myfinance_improved/core/themes/toss_colors.dart';
import 'package:myfinance_improved/core/themes/toss_text_styles.dart';
import 'package:myfinance_improved/presentation/widgets/toss/toss_loading_overlay.dart';
import 'package:myfinance_improved/presentation/widgets/common/toss_error_view.dart';
import 'package:myfinance_improved/presentation/widgets/debug/debug_panel.dart';
import 'providers/homepage_providers.dart';
import 'widgets/homepage_app_bar.dart';
import 'widgets/homepage_drawer.dart';
import 'widgets/feature_grid.dart';
import 'widgets/quick_access_section.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({
    super.key,
    this.firstLogin = false,
    this.companyClicked = false,
    this.storeClicked = false,
  });

  final bool firstLogin;
  final bool companyClicked;
  final bool storeClicked;

  static const String routeName = 'homepage';
  static const String routePath = '/homepage';

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    // Handle first login or company changes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializePageData();
    });
  }

  Future<void> _initializePageData() async {
    if (widget.firstLogin) {
      // First login - data will be loaded automatically by providers
      return;
    }

    // Check if company count changed
    final localCount = ref.read(localCompanyCountProvider);
    final currentCount = ref.read(userCompaniesProvider).valueOrNull?.companyCount;
    
    if (localCount != currentCount) {
      // Refresh user data
      ref.invalidate(userCompaniesProvider);
    }

    // Handle company/store selection from navigation
    if (!widget.companyClicked && !widget.storeClicked) {
      // Reset to default selections
      final userCompanies = ref.read(userCompaniesProvider).valueOrNull;
      if (userCompanies != null && userCompanies.companies.isNotEmpty) {
        ref.read(selectedCompanyProvider.notifier).selectCompany(
          userCompanies.companies.first,
        );
      }
    }
  }

  Future<void> _handleSync() async {
    ref.read(homepageLoadingStateProvider.notifier).setSyncLoading(true);
    
    try {
      ref.invalidate(userCompaniesProvider);
      ref.invalidate(categoriesWithFeaturesProvider);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('데이터가 동기화되었습니다'),
            backgroundColor: TossColors.success,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('동기화 실패: ${e.toString()}'),
            backgroundColor: TossColors.error,
          ),
        );
      }
    } finally {
      ref.read(homepageLoadingStateProvider.notifier).setSyncLoading(false);
    }
  }

  void _handleLogout() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('로그아웃'),
        content: const Text('정말 로그아웃하시겠습니까?'),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              '취소',
              style: TossTextStyles.label.copyWith(
                color: TossColors.gray500,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              context.go('/auth/login');
            },
            child: Text(
              '로그아웃',
              style: TossTextStyles.label.copyWith(
                color: TossColors.error,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final userCompaniesAsync = ref.watch(userCompaniesProvider);
    final selectedCompany = ref.watch(selectedCompanyProvider);
    final selectedStore = ref.watch(selectedStoreProvider);
    final categoriesAsync = ref.watch(categoriesWithFeaturesProvider);
    final loadingState = ref.watch(homepageLoadingStateProvider);

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: TossColors.background,
      drawer: userCompaniesAsync.when(
        data: (userCompanies) => HomepageDrawer(
          companies: userCompanies.companies,
          selectedCompany: selectedCompany,
          selectedStore: selectedStore,
          onCompanySelect: (company) {
            ref.read(selectedCompanyProvider.notifier).selectCompany(company);
            _scaffoldKey.currentState?.closeDrawer();
          },
          onStoreSelect: (store) {
            ref.read(selectedStoreProvider.notifier).selectStore(store);
            _scaffoldKey.currentState?.closeDrawer();
          },
          canAddStore: ref.watch(canAddStoreProvider),
        ),
        loading: () => const SizedBox.shrink(),
        error: (error, _) => const SizedBox.shrink(),
      ),
      body: Stack(
        children: [
          SafeArea(
            child: Column(
              children: [
                // App Bar
                userCompaniesAsync.when(
                  data: (userCompanies) => HomepageAppBar(
                    userName: userCompanies.userFirstName,
                    companyName: selectedCompany?.companyName ?? '',
                    storeName: selectedStore?.storeName,
                    profileImageUrl: userCompanies.profileImage,
                    onMenuTap: () {
                      _scaffoldKey.currentState?.openDrawer();
                    },
                    onProfileTap: () {
                      // Navigate to profile edit
                      context.push('/profile/edit');
                    },
                    onLogoutTap: _handleLogout,
                    onSyncTap: _handleSync,
                    isSyncing: loadingState.isSyncLoading,
                  ),
                  loading: () => const SizedBox(height: 80),
                  error: (error, _) => const SizedBox(height: 80),
                ),
                
                // Main Content
                Expanded(
                  child: categoriesAsync.when(
                    data: (categories) {
                      if (categories.isEmpty) {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.inbox_outlined,
                                size: 64,
                                color: TossColors.gray300,
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'No features available',
                                style: TossTextStyles.body.copyWith(
                                  color: TossColors.gray500,
                                ),
                              ),
                            ],
                          ),
                        );
                      }
                      
                      return Column(
                        children: [
                          // Quick Access Section
                          const QuickAccessSection(),
                          
                          // All Features Section
                          Expanded(
                            child: FeatureGrid(
                              categories: categories,
                              onFeatureTap: (feature) {
                                context.push(feature.featureRoute);
                              },
                            ),
                          ),
                        ],
                      );
                    },
                    loading: () => const Center(
                      child: CircularProgressIndicator(
                        color: TossColors.primary,
                      ),
                    ),
                    error: (error, stackTrace) => TossErrorView(
                      error: error,
                      onRetry: () {
                        ref.invalidate(categoriesWithFeaturesProvider);
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          // Debug Panel (positioned at bottom)
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: const DebugPanel(),
          ),
          
          // Loading Overlay
          if (loadingState.isUserDataLoading || loadingState.isFeaturesLoading)
            const TossLoadingOverlay(),
        ],
      ),
    );
  }
}