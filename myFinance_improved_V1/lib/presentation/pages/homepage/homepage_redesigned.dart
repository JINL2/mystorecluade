import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:myfinance_improved/core/themes/toss_colors.dart';
import 'package:myfinance_improved/core/themes/toss_text_styles.dart';
import 'package:myfinance_improved/core/themes/toss_spacing.dart';
import 'package:myfinance_improved/core/themes/toss_shadows.dart';
import 'providers/homepage_providers.dart' hide selectedCompanyProvider, selectedStoreProvider;
import '../../providers/app_state_provider.dart';
import '../../providers/auth_provider.dart';
import 'models/homepage_models.dart';
import 'widgets/modern_drawer.dart';
import '../../../data/services/click_tracking_service.dart';

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
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // No longer checking for refresh flag
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }


  @override
  Widget build(BuildContext context) {
    final userCompaniesAsync = ref.watch(userCompaniesProvider);
    final categoriesAsync = ref.watch(categoriesWithFeaturesProvider);
    final appState = ref.watch(appStateProvider);
    // Watch the selections so they update when changed
    final selectedCompany = ref.watch(selectedCompanyProvider);
    final selectedStore = ref.watch(selectedStoreProvider);

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Stack(
        children: [
          // Main Content
          userCompaniesAsync.when(
            data: (userData) => RefreshIndicator(
              onRefresh: () => _handleRefresh(ref),
              color: Theme.of(context).colorScheme.primary,
              child: CustomScrollView(
                slivers: [
                  // Simple App Bar
                  _buildSimpleAppBar(context, userData),
                  
                  // Pinned Hello Section
                  _buildPinnedHelloSection(context, userData, selectedCompany, selectedStore),
                  
                  // Add spacing after Hello section
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
              child: CircularProgressIndicator(color: Theme.of(context).colorScheme.primary),
            ),
            error: (error, stack) => Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 48, color: Theme.of(context).colorScheme.error),
                  const SizedBox(height: 16),
                  Text('Something went wrong', style: TossTextStyles.h3),
                  const SizedBox(height: 8),
                  Text(error.toString(), style: TossTextStyles.caption),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSimpleAppBar(BuildContext context, dynamic userData) {
    return SliverAppBar(
      pinned: true,
      floating: false,
      snap: false,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      surfaceTintColor: Colors.transparent, // Prevents color change on scroll
      shadowColor: Colors.transparent,
      elevation: 0,
      toolbarHeight: 56, // Standard app bar height
      leading: IconButton(
        icon: Icon(Icons.menu, color: Theme.of(context).colorScheme.onSurface),
        onPressed: () => _showCompanyStoreBottomSheet(context, ref),
      ),
      actions: [
        // Notifications
        IconButton(
          icon: Badge(
            isLabelVisible: true,
            smallSize: 6,
            largeSize: 6,
            backgroundColor: Theme.of(context).colorScheme.primary,
            child: Icon(
              Icons.notifications_none_rounded,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
              size: 26,
            ),
          ),
          onPressed: () {},
        ),
        // Profile
        Padding(
          padding: const EdgeInsets.only(right: 16),
          child: PopupMenuButton<String>(
            offset: const Offset(0, 40),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            color: Theme.of(context).colorScheme.surface,
            elevation: 4,
            onSelected: (value) {
              if (value == 'settings') {
                // Navigate to settings
                context.push('/settings');
              } else if (value == 'logout') {
                // Handle logout
                ref.read(authStateProvider.notifier).signOut();
              }
            },
            itemBuilder: (BuildContext context) => [
              PopupMenuItem<String>(
                value: 'settings',
                child: Row(
                  children: [
                    Icon(
                      Icons.settings_outlined,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                      size: 20,
                    ),
                    SizedBox(width: TossSpacing.space3),
                    Text(
                      'Settings',
                      style: TossTextStyles.body.copyWith(
                        color: Theme.of(context).colorScheme.onSurface,
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
                      color: Theme.of(context).colorScheme.error,
                      size: 20,
                    ),
                    SizedBox(width: TossSpacing.space3),
                    Text(
                      'Logout',
                      style: TossTextStyles.body.copyWith(
                        color: Theme.of(context).colorScheme.error,
                      ),
                    ),
                  ],
                ),
              ),
            ],
            child: CircleAvatar(
              radius: 18,
              backgroundImage: (userData['profile_image'] ?? '').isNotEmpty
                  ? NetworkImage(userData['profile_image'])
                  : null,
              backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.1),
              child: (userData['profile_image'] ?? '').isEmpty
                  ? Text(
                      (userData['user_first_name'] ?? '').isNotEmpty ? userData['user_first_name'][0] : 'U',
                      style: TossTextStyles.body.copyWith(
                        color: Theme.of(context).colorScheme.primary,
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
    // Use the topFeaturesByUserProvider to get quick access features from RPC
    final topFeaturesAsync = ref.watch(topFeaturesByUserProvider);
    
    return SliverToBoxAdapter(
      child: topFeaturesAsync.when(
        data: (topFeatures) {
          if (topFeatures.isEmpty) return const SizedBox.shrink();
          
          // Take only the first 6 features for the quick actions grid
          final quickFeatures = topFeatures.take(6).toList();
          
          return Container(
            color: Theme.of(context).scaffoldBackgroundColor,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: TossSpacing.space4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Section header with consistent spacing
                  Text(
                    'Quick Actions',
                    style: TossTextStyles.h3.copyWith(
                      color: Theme.of(context).colorScheme.onSurface,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: TossSpacing.space3),
                  
                  // Container with consistent padding
                  Container(
                    padding: EdgeInsets.all(TossSpacing.space2),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surface,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: TossShadows.cardShadow,
                    ),
                  child: GridView.builder(
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 1,
                      mainAxisSpacing: 1,
                      childAspectRatio: 1.3, // Adjust for better proportions with spacing
                    ),
                    itemCount: quickFeatures.length,
                    itemBuilder: (context, index) {
                      final feature = quickFeatures[index];
                      return _buildQuickActionItemFromTopFeature(feature);
                    },
                  ),
                ),
                SizedBox(height: TossSpacing.space4),
                ],
              ),
            ),
          );
        },
        loading: () => _buildQuickActionsLoading(),
        error: (_, __) => const SizedBox.shrink(),
      ),
    );
  }

  Widget _buildQuickActionsLoading() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: TossSpacing.space4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: TossSpacing.space1),
            child: Text(
              'Quick Actions',
              style: TossTextStyles.h3.copyWith(
                color: Theme.of(context).colorScheme.onSurface,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          SizedBox(height: TossSpacing.space4),
          Container(
            padding: EdgeInsets.all(TossSpacing.space4),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(20),
              boxShadow: TossShadows.cardShadow,
            ),
            child: GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: TossSpacing.space3,
                mainAxisSpacing: TossSpacing.space3,
                childAspectRatio: 1.0,
              ),
              itemCount: 6,
              itemBuilder: (context, index) {
                return Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surfaceContainer,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.surfaceContainerHighest,
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      SizedBox(height: TossSpacing.space2),
                      Container(
                        width: 50,
                        height: 12,
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.surfaceContainerHighest,
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          SizedBox(height: TossSpacing.space8),
        ],
      ),
    );
  }

  Widget _buildQuickActionItem(dynamic feature, String categoryId) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => _handleFeatureTap(feature, categoryId),
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: EdgeInsets.zero,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: Theme.of(context).colorScheme.outline.withOpacity(0.06),
              width: 1,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Icon with compact sizing
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: (feature['icon'] ?? '').isNotEmpty &&
                        ((feature['icon'] ?? '').startsWith('http://') ||
                         (feature['icon'] ?? '').startsWith('https://'))
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network(
                          feature['icon'],
                          width: 40,
                          height: 40,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Icon(
                            Icons.apps,
                            color: Theme.of(context).colorScheme.primary,
                            size: 20,
                          ),
                        ),
                      )
                    : Icon(
                        Icons.apps,
                        color: Theme.of(context).colorScheme.primary,
                        size: 20,
                      ),
              ),
              SizedBox(height: TossSpacing.space1),
              Text(
                feature['feature_name'] ?? '',
                style: TossTextStyles.caption.copyWith(
                  color: Theme.of(context).colorScheme.onSurface,
                  fontWeight: FontWeight.w500,
                  fontSize: 12,
                  height: 1.2,
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

  Widget _buildQuickActionItemFromTopFeature(TopFeature feature) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          // Navigate directly using the route from TopFeature
          context.push('/${feature.route}');
          
          // Track the click if needed
          final clickService = ClickTrackingService();
          clickService.trackFeatureClick(
            featureId: feature.featureId,
            featureName: feature.featureName,
            categoryId: feature.categoryId ?? '',
          );
        },
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: EdgeInsets.zero,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: Theme.of(context).colorScheme.outline.withOpacity(0.06),
              width: 1,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Icon with compact sizing
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: feature.icon.isNotEmpty &&
                        (feature.icon.contains('http://') ||
                         feature.icon.contains('https://'))
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network(
                          // Clean up the icon URL by removing any Unicode directional characters
                          feature.icon.replaceAll(RegExp(r'[\u2066\u2069]'), ''),
                          width: 40,
                          height: 40,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Icon(
                            Icons.apps,
                            color: Theme.of(context).colorScheme.primary,
                            size: 20,
                          ),
                        ),
                      )
                    : Icon(
                        Icons.apps,
                        color: Theme.of(context).colorScheme.primary,
                        size: 20,
                      ),
              ),
              SizedBox(height: TossSpacing.space1),
              Text(
                feature.featureName,
                style: TossTextStyles.caption.copyWith(
                  color: Theme.of(context).colorScheme.onSurface,
                  fontWeight: FontWeight.w500,
                  fontSize: 12,
                  height: 1.2,
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

  Widget _buildMainFeaturesSection(AsyncValue<dynamic> categoriesAsync) {
    return SliverToBoxAdapter(
      child: categoriesAsync.when(
        data: (categories) {
          if (categories.isEmpty) {
            return Container(
              color: Theme.of(context).scaffoldBackgroundColor,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: TossSpacing.space4),
                child: Container(
                  padding: EdgeInsets.all(TossSpacing.space10),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: TossShadows.cardShadow,
                  ),
                  child: Column(
                    children: [
                      Icon(
                        Icons.inbox_outlined,
                        size: 48,
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                      SizedBox(height: TossSpacing.space4),
                      Text(
                        'No features available',
                        style: TossTextStyles.body.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }

          return Container(
            color: Theme.of(context).scaffoldBackgroundColor,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: TossSpacing.space4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'All Features',
                    style: TossTextStyles.h3.copyWith(
                      color: Theme.of(context).colorScheme.onSurface,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: TossSpacing.space3),
                  ...categories.map((category) => _buildCategorySection(category)),
                  SizedBox(height: TossSpacing.space24), // Space for debug panel
                ],
              ),
            ),
          );
        },
        loading: () => Container(
          color: Theme.of(context).scaffoldBackgroundColor,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: TossSpacing.space4),
            child: Center(
              child: CircularProgressIndicator(color: Theme.of(context).colorScheme.primary),
            ),
          ),
        ),
        error: (error, _) => Container(
          color: Theme.of(context).scaffoldBackgroundColor,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: TossSpacing.space4),
            child: Container(
              padding: EdgeInsets.all(TossSpacing.space4),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(16),
                boxShadow: TossShadows.cardShadow,
              ),
              child: Text(
                'Error loading features: $error',
                style: TossTextStyles.body.copyWith(
                  color: Theme.of(context).colorScheme.error,
                ),
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
      padding: EdgeInsets.all(TossSpacing.space4),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: TossShadows.cardShadow,
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
                  color: Theme.of(context).colorScheme.primary,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              SizedBox(width: TossSpacing.space3),
              Text(
                category['category_name'] ?? '',
                style: TossTextStyles.h3.copyWith(
                  color: Theme.of(context).colorScheme.onSurface,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          SizedBox(height: TossSpacing.space4),
          
          // Features List with minimal spacing
          ...(category['features'] as List<dynamic>? ?? []).asMap().entries.map((entry) {
            final index = entry.key;
            final feature = entry.value;
            final features = category['features'] as List<dynamic>? ?? [];
            return Column(
              children: [
                _buildFeatureListItem(feature, category['category_id']),
                if (index < features.length - 1)
                  SizedBox(height: TossSpacing.space1),
              ],
            );
          }),
        ],
      ),
    );
  }

  Widget _buildFeatureListItem(dynamic feature, String categoryId) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => _handleFeatureTap(feature, categoryId),
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: TossSpacing.space3, 
            vertical: TossSpacing.space3,
          ),
          child: Row(
            children: [
              // Icon with theme colors
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: (feature['icon'] ?? '').isNotEmpty &&
                        ((feature['icon'] ?? '').startsWith('http://') ||
                         (feature['icon'] ?? '').startsWith('https://'))
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          feature['icon'],
                          width: 32,
                          height: 32,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Icon(
                            Icons.apps,
                            color: Theme.of(context).colorScheme.primary,
                            size: 16,
                          ),
                        ),
                      )
                    : Icon(
                        Icons.apps,
                        color: Theme.of(context).colorScheme.primary,
                        size: 16,
                      ),
              ),
              SizedBox(width: TossSpacing.space3),
              
              // Feature Name with theme colors
              Expanded(
                child: Text(
                  feature['feature_name'] ?? '',
                  style: TossTextStyles.body.copyWith(
                    color: Theme.of(context).colorScheme.onSurface,
                    fontWeight: FontWeight.w500,
                    fontSize: 15,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ),
              
              // Arrow with theme colors
              Icon(
                Icons.chevron_right,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
                size: 20,
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
        await context.push(fullRoute);
        
        // Reset the flag after navigation completes
        if (mounted) {
          // Add a small delay to prevent immediate re-taps
          await Future.delayed(const Duration(milliseconds: 500));
          setState(() {
            _isNavigating = false;
          });
        }
      } else {
        // Show message if no route is defined
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${feature['feature_name']} coming soon!'),
            backgroundColor: Theme.of(context).colorScheme.primary,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
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
            backgroundColor: Theme.of(context).colorScheme.error,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
        );
      }
    }
  }

  Future<void> _handleRefresh(WidgetRef ref) async {
    try {
      
      // First, invalidate the force refresh providers to ensure they re-execute
      ref.invalidate(forceRefreshUserCompaniesProvider);
      ref.invalidate(forceRefreshCategoriesProvider);
      
      
      // Now call the force refresh providers that ALWAYS fetch from API
      final userCompaniesResult = await ref.read(forceRefreshUserCompaniesProvider.future);
      final categoriesResult = await ref.read(forceRefreshCategoriesProvider.future);
      
      final companies = userCompaniesResult['companies'] as List<dynamic>? ?? [];
      
      // Invalidate the regular providers to show the new data
      ref.invalidate(userCompaniesProvider);
      ref.invalidate(categoriesWithFeaturesProvider);
      
      
      // Show success feedback
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Data refreshed successfully'),
            backgroundColor: Theme.of(context).colorScheme.primary,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
        );
      }
    } catch (e) {
      
      // Show error feedback
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to refresh: ${e.toString()}'),
            backgroundColor: Theme.of(context).colorScheme.error,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
        );
      }
    }
  }

  void _showCompanyStoreBottomSheet(BuildContext context, WidgetRef ref) {
    // No longer refresh automatically when showing drawer
    final userCompaniesAsync = ref.read(userCompaniesProvider);
    
    userCompaniesAsync.when(
      data: (userData) {
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          builder: (context) => Container(
            height: MediaQuery.of(context).size.height * 0.85,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: ModernDrawer(userData: userData),
          ),
        );
      },
      loading: () {
        // Show loading indicator if data is not available
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Loading user data...'),
            backgroundColor: Theme.of(context).colorScheme.primary,
          ),
        );
      },
      error: (error, _) {
        // Show error message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error loading data: $error'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      },
    );
  }
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
      color: Theme.of(context).scaffoldBackgroundColor,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: TossSpacing.space4),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
          boxShadow: TossShadows.cardShadow,
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
              'Hello, ${userData['user_first_name'] ?? 'User'}!',
              style: TossTextStyles.h2.copyWith(
                color: Theme.of(context).colorScheme.onSurface,
                fontWeight: FontWeight.w700,
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
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                  if (selectedStore != null) ...[
                    Text(
                      ' • ',
                      style: TossTextStyles.body.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        selectedStore!['store_name'] ?? '',
                        style: TossTextStyles.caption.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
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