import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:myfinance_improved/core/themes/toss_colors.dart';
import 'package:myfinance_improved/core/themes/toss_text_styles.dart';
import 'package:myfinance_improved/core/themes/toss_spacing.dart';
import 'package:myfinance_improved/core/themes/toss_shadows.dart';
import 'package:myfinance_improved/core/themes/toss_animations.dart';
import 'package:myfinance_improved/core/constants/icon_mapper.dart';
import 'providers/homepage_providers.dart';
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
    // Handle app lifecycle changes if needed
  }

  @override
  Widget build(BuildContext context) {
    final userCompaniesAsync = ref.watch(userCompaniesProvider);
    final categoriesAsync = ref.watch(categoriesWithFeaturesProvider);
    // Watch the selections so they update when changed
    final selectedCompany = ref.watch(selectedCompanyProvider);
    final selectedStore = ref.watch(selectedStoreProvider);

    return Scaffold(
      key: _scaffoldKey,
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
              child: CircularProgressIndicator(color: TossColors.primary),
            ),
            error: (error, stack) => Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 48, color: TossColors.error),
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
      backgroundColor: TossColors.gray100, // Seamless with body background
      surfaceTintColor: TossColors.transparent,
      shadowColor: TossColors.transparent,
      elevation: 0,
      toolbarHeight: 64, // Slightly taller for better visual weight
      leading: IconButton(
        icon: Icon(Icons.menu, color: TossColors.textSecondary, size: 24),
        onPressed: () => _showCompanyStoreBottomSheet(context, ref),
        padding: EdgeInsets.all(TossSpacing.space3),
      ),
      actions: [
        // Notifications with improved Toss styling
        IconButton(
          icon: Badge(
            isLabelVisible: true,
            smallSize: 6,
            largeSize: 6,
            backgroundColor: TossColors.primary,
            child: Icon(
              Icons.notifications_none_rounded,
              color: TossColors.textSecondary,
              size: 24,
            ),
          ),
          onPressed: () {},
          padding: EdgeInsets.all(TossSpacing.space3),
        ),
        // Profile with improved Toss styling
        Padding(
          padding: EdgeInsets.only(right: TossSpacing.space4),
          child: PopupMenuButton<String>(
            offset: const Offset(0, 48),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(TossSpacing.space3),
            ),
            color: TossColors.surface,
            elevation: 2, // Reduced for cleaner look
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
                      color: TossColors.textSecondary,
                      size: 20,
                    ),
                    SizedBox(width: TossSpacing.space3),
                    Text(
                      'Settings',
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
              backgroundImage: (userData['profile_image'] ?? '').isNotEmpty
                  ? NetworkImage(userData['profile_image'])
                  : null,
              backgroundColor: TossColors.primary.withOpacity(0.1),
              child: (userData['profile_image'] ?? '').isEmpty
                  ? Text(
                      (userData['user_first_name'] ?? '').isNotEmpty ? userData['user_first_name'][0] : 'U',
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
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: TossColors.borderLight,
                        width: 0.5,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: TossColors.textPrimary.withOpacity(0.02),
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
                                    borderRadius: BorderRadius.circular(2),
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
                        
                        // Grid of Quick Actions
                        GridView.builder(
                          padding: EdgeInsets.zero,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            crossAxisSpacing: TossSpacing.space4,
                            mainAxisSpacing: TossSpacing.space5,
                            childAspectRatio: 0.95,
                          ),
                          itemCount: quickFeatures.length,
                          itemBuilder: (context, index) {
                            final feature = quickFeatures[index];
                            return _buildQuickActionItemFromTopFeature(feature);
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
        },
        loading: () => _buildQuickActionsLoading(),
        error: (_, __) => const SizedBox.shrink(),
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
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: TossColors.borderLight,
                  width: 0.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: TossColors.textPrimary.withOpacity(0.02),
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
                              borderRadius: BorderRadius.circular(2),
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
                      crossAxisSpacing: TossSpacing.space4,
                      mainAxisSpacing: TossSpacing.space5,
                      childAspectRatio: 0.95,
                    ),
                    itemCount: 6,
                    itemBuilder: (context, index) {
                      return Container(
                        padding: EdgeInsets.symmetric(vertical: TossSpacing.space2),
                        decoration: BoxDecoration(
                          color: TossColors.transparent,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // Skeleton icon container
                            Container(
                              width: 48,
                              height: 48,
                              decoration: BoxDecoration(
                                color: TossColors.gray200,
                                borderRadius: BorderRadius.circular(14),
                              ),
                            ),
                            SizedBox(height: TossSpacing.space2),
                            // Skeleton text
                            Container(
                              width: 60,
                              height: 10,
                              decoration: BoxDecoration(
                                color: TossColors.gray200,
                                borderRadius: BorderRadius.circular(5),
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
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: TossSpacing.space2),
          decoration: BoxDecoration(
            color: TossColors.transparent,
            borderRadius: BorderRadius.circular(12),
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
                  borderRadius: BorderRadius.circular(14),
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

  Widget _buildQuickActionItemFromTopFeature(TopFeature feature) {
    return Material(
      color: TossColors.transparent,
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
        splashColor: TossColors.primary.withOpacity(0.1),
        highlightColor: TossColors.primary.withOpacity(0.05),
        child: AnimatedContainer(
          duration: TossAnimations.normal,
          curve: TossAnimations.standard,
          padding: EdgeInsets.symmetric(vertical: TossSpacing.space2),
          decoration: BoxDecoration(
            color: TossColors.transparent,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Icon with ultra-minimal Toss design and hover effect
              AnimatedContainer(
                duration: TossAnimations.normal,
                curve: TossAnimations.standard,
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: TossColors.gray100, // Even more subtle background
                  borderRadius: BorderRadius.circular(14),
                  // No border for cleaner look
                ),
                child: DynamicIcon(
                  iconKey: feature.iconKey,
                  featureName: feature.featureName,
                  size: 22,
                  color: TossColors.gray700, // More neutral, less blue
                  useDefaultColor: false,
                ),
              ),
              SizedBox(height: TossSpacing.space1),
              Text(
                feature.featureName,
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

  Widget _buildMainFeaturesSection(AsyncValue<dynamic> categoriesAsync) {
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
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: TossColors.borderLight,
                      width: 0.5,
                    ),
                  ),
                  child: Column(
                    children: [
                      Icon(
                        Icons.inbox_outlined,
                        size: 48,
                        color: TossColors.textTertiary,
                      ),
                      SizedBox(height: TossSpacing.space4),
                      Text(
                        'No features available',
                        style: TossTextStyles.body.copyWith(
                          color: TossColors.textSecondary,
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
                  child: CircularProgressIndicator(color: TossColors.primary),
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
                borderRadius: BorderRadius.circular(20),
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
        borderRadius: BorderRadius.circular(20), // More rounded for modern look
        border: Border.all(
          color: TossColors.borderLight,
          width: 0.5,
        ),
        boxShadow: [
          BoxShadow(
            color: TossColors.textPrimary.withOpacity(0.02),
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
                  borderRadius: BorderRadius.circular(2),
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
        borderRadius: BorderRadius.circular(12),
        splashColor: TossColors.primary.withOpacity(0.08),
        highlightColor: TossColors.primary.withOpacity(0.04),
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
                  borderRadius: BorderRadius.circular(12), // More subtle rounding
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
        await context.push(fullRoute);
        
        // Reset the flag after navigation completes
        if (mounted) {
          // Add a small delay to prevent immediate re-taps
          await Future.delayed(TossAnimations.medium);
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
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
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
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
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
            backgroundColor: TossColors.success,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
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
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
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
          backgroundColor: TossColors.transparent,
          builder: (context) => Container(
            height: MediaQuery.of(context).size.height * 0.85,
            decoration: BoxDecoration(
              color: TossColors.surface,
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
            backgroundColor: TossColors.primary,
          ),
        );
      },
      error: (error, _) {
        // Show error message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error loading data: $error'),
            backgroundColor: TossColors.error,
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
      color: TossColors.gray100,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: TossSpacing.space4),
        decoration: BoxDecoration(
          color: TossColors.surface,
          borderRadius: BorderRadius.circular(16),
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
              'Hello, ${userData['user_first_name'] ?? 'User'}!',
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