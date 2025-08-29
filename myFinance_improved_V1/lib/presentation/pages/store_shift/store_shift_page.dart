import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../helpers/navigation_helper.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:url_launcher/url_launcher.dart';
import 'providers/store_shift_providers.dart';
import '../../providers/app_state_provider.dart';
import '../../../core/themes/toss_colors.dart';
import '../../../core/themes/toss_text_styles.dart';
import '../../../core/themes/toss_spacing.dart';
import '../../../core/themes/toss_border_radius.dart';
import '../../../core/themes/toss_animations.dart';
import '../../widgets/common/toss_app_bar.dart';
import '../../widgets/toss/toss_time_picker.dart';
import '../../widgets/toss/toss_primary_button.dart';
import '../../widgets/toss/toss_secondary_button.dart';
import '../../widgets/toss/toss_text_field.dart';
import '../../widgets/toss/toss_card.dart';
import '../../widgets/toss/toss_tab_bar.dart';
import '../../widgets/toss/toss_selection_bottom_sheet.dart';
import '../../widgets/common/toss_empty_view.dart';
import '../../../core/constants/icon_mapper.dart';
import '../../../core/constants/ui_constants.dart';
import '../../widgets/common/toss_scaffold.dart';
import '../../../data/services/store_service.dart';
import '../../widgets/toss/toss_bottom_sheet.dart';
import '../../widgets/common/toss_number_input.dart';

class StoreShiftPage extends ConsumerStatefulWidget {
  const StoreShiftPage({super.key});

  @override
  ConsumerState<StoreShiftPage> createState() => _StoreShiftPageState();
}

class _StoreShiftPageState extends ConsumerState<StoreShiftPage> with WidgetsBindingObserver, SingleTickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _tabController = TabController(length: 2, vsync: this);
    // TabController already tracks the index
  }

  @override
  void dispose() {
    _tabController.dispose();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }


  // Helper method to show error messages
  void _showErrorMessage(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: TossColors.error,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(TossBorderRadius.button)),
        ),
      );
    }
  }

  // Helper method to show success messages
  void _showSuccessMessage(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: TossColors.primary,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(TossBorderRadius.button)),
        ),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    final userCompaniesAsync = ref.watch(userCompaniesProvider);

    return TossScaffold(
      scaffoldKey: _scaffoldKey,
      backgroundColor: TossColors.gray100,
      appBar: TossAppBar(
        title: 'Store Settings',
        leading: IconButton(
          icon: FaIcon(FontAwesomeIcons.chevronLeft,
            color: TossColors.gray700,
            size: TossSpacing.iconMD,
          ),
          onPressed: () => NavigationHelper.safeGoBack(context),
        ),
      ),
      body: userCompaniesAsync.when(
        data: (userData) => Column(
          children: [
            // Tab Bar
            TossTabBar(
              tabs: const ['Shift Settings', 'Store Settings'],
              controller: _tabController,
              onTabChanged: (index) {
                // TabController automatically handles index changes
              },
            ),
            // Tab Content
            Expanded(
              child: TabBarView(
                controller: _tabController,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  // Shift Settings Tab
                  _buildShiftSettingsTab(userData),
                  // Store Settings Tab
                  _buildStoreSettingsTab(userData),
                ],
              ),
            ),
          ],
        ),
        loading: () => Center(
          child: CircularProgressIndicator(color: TossColors.primary),
        ),
        error: (error, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FaIcon(FontAwesomeIcons.circleExclamation, size: TossSpacing.iconXL, color: TossColors.error),
              const SizedBox(height: TossSpacing.paddingMD),
              const Text('Something went wrong'),
              const SizedBox(height: TossSpacing.space2),
              Text(error.toString()),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _handleRefresh(WidgetRef ref) async {
    try {
      // Invalidate providers to refresh data
      ref.invalidate(forceRefreshUserCompaniesProvider);
      ref.invalidate(forceRefreshCategoriesProvider);
      
      // Fetch fresh data
      await ref.read(forceRefreshUserCompaniesProvider.future);
      await ref.read(forceRefreshCategoriesProvider.future);
      
      // Invalidate regular providers to show new data
      ref.invalidate(userCompaniesProvider);
      ref.invalidate(categoriesWithFeaturesProvider);
      
      // Show success feedback
      _showSuccessMessage('Data refreshed successfully');
    } catch (e) {
      _showErrorMessage('Failed to refresh: ${e.toString()}');
    }
  }
  
  // Build Shift Settings Tab
  Widget _buildShiftSettingsTab(dynamic userData) {
    return RefreshIndicator(
      onRefresh: () => _handleRefresh(ref),
      color: TossColors.primary,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(TossSpacing.paddingMD),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Store Selector
            _buildStoreSelector(userData),
            const SizedBox(height: TossSpacing.space6),
            
            // Add Shift Button Section
            _buildAddShiftSection(),
            const SizedBox(height: TossSpacing.space6),
            
            // Existing Shifts Section
            _buildExistingShiftsSection(),
          ],
        ),
      ),
    );
  }

  // Build Store Settings Tab
  Widget _buildStoreSettingsTab(dynamic userData) {
    final selectedStore = ref.watch(selectedStoreProvider);
    final storeDetailsAsync = ref.watch(storeDetailsProvider);
    
    if (selectedStore == null) {
      return Center(
        child: TossEmptyView(
          icon: Icon(
            IconMapper.getIcon('building'),
            size: UIConstants.emptyStateIconSize,
            color: TossColors.gray400,
          ),
          title: 'No Store Selected',
          description: 'Please select a store from Shift Settings tab to configure store settings.',
        ),
      );
    }
    
    return RefreshIndicator(
      onRefresh: () => _handleRefresh(ref),
      color: TossColors.primary,
      child: storeDetailsAsync.when(
        data: (storeData) {
          if (storeData == null) {
            return Center(
              child: TossEmptyView(
                icon: Icon(
                  IconMapper.getIcon('building'),
                  size: UIConstants.emptyStateIconSize,
                  color: TossColors.gray400,
                ),
                title: 'Store Not Found',
                description: 'Unable to load store details.',
              ),
            );
          }
          
          return SingleChildScrollView(
            padding: const EdgeInsets.all(TossSpacing.paddingMD),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Store Information Card
                _buildStoreInfoCard(storeData),
                const SizedBox(height: TossSpacing.space5),
                
                // Store Configuration Options
                _buildStoreConfigSection(storeData),
                const SizedBox(height: TossSpacing.space5),
                
                // Store Operating Hours
                _buildStoreOperatingHours(storeData),
              ],
            ),
          );
        },
        loading: () => Center(
          child: CircularProgressIndicator(color: TossColors.primary),
        ),
        error: (error, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                FontAwesomeIcons.circleExclamation,
                size: TossSpacing.iconXL,
                color: TossColors.error,
              ),
              const SizedBox(height: TossSpacing.space3),
              Text(
                'Failed to load store details',
                style: TossTextStyles.body.copyWith(
                  color: TossColors.error,
                ),
              ),
              const SizedBox(height: TossSpacing.space2),
              Text(
                error.toString(),
                style: TossTextStyles.caption.copyWith(
                  color: TossColors.gray600,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Build Store Information Card
  Widget _buildStoreInfoCard(Map<String, dynamic> store) {
    return TossCard(
      padding: const EdgeInsets.all(TossSpacing.space5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: TossSpacing.iconXL + TossSpacing.space2,
                height: TossSpacing.iconXL + TossSpacing.space2,
                decoration: BoxDecoration(
                  color: TossColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(TossBorderRadius.lg),
                ),
                child: Icon(
                  IconMapper.getIcon('building'),
                  color: TossColors.primary,
                  size: TossSpacing.iconMD,
                ),
              ),
              const SizedBox(width: TossSpacing.space3),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Store Information',
                      style: TossTextStyles.caption.copyWith(
                        color: TossColors.gray600,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: TossSpacing.space1),
                    Text(
                      store['store_name'] ?? 'Unnamed Store',
                      style: TossTextStyles.bodyLarge.copyWith(
                        color: TossColors.gray900,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: () {
                  _showEditStoreInfoSheet(store);
                },
                icon: Icon(
                  IconMapper.getIcon('editRegular'),
                  color: TossColors.primary,
                  size: TossSpacing.iconSM,
                ),
              ),
            ],
          ),
          const SizedBox(height: TossSpacing.space4),
          
          // Store Details
          _buildDetailRow('Store Code', store['store_code'] ?? 'N/A'),
          const SizedBox(height: TossSpacing.space2),
          if (store['store_address'] != null && store['store_address'].toString().isNotEmpty) ...[
            _buildDetailRow('Address', store['store_address']),
            const SizedBox(height: TossSpacing.space2),
          ],
          if (store['store_phone'] != null && store['store_phone'].toString().isNotEmpty) ...[
            _buildDetailRow('Phone', store['store_phone']),
            const SizedBox(height: TossSpacing.space2),
          ],
          _buildDetailRow('Status', store['is_deleted'] == true ? 'Inactive' : 'Active', 
              color: store['is_deleted'] == true ? TossColors.error : TossColors.success),
        ],
      ),
    );
  }

  // Build Store Configuration Section
  Widget _buildStoreConfigSection(Map<String, dynamic> store) {
    return TossCard(
      padding: const EdgeInsets.all(TossSpacing.space5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Operational Settings',
                style: TossTextStyles.bodyLarge.copyWith(
                  color: TossColors.gray900,
                  fontWeight: FontWeight.w700,
                ),
              ),
              IconButton(
                onPressed: () {
                  _showEditOperationalSettingsSheet(store);
                },
                icon: Icon(
                  IconMapper.getIcon('editRegular'),
                  color: TossColors.primary,
                  size: TossSpacing.iconSM,
                ),
              ),
            ],
          ),
          const SizedBox(height: TossSpacing.space4),
          
          // Operational Settings
          _buildConfigOption(
            icon: FontAwesomeIcons.peopleGroup,
            title: 'Huddle Time',
            subtitle: '${store['huddle_time'] ?? 15} minutes for team meetings',
            onTap: null,
          ),
          const SizedBox(height: TossSpacing.space3),
          _buildConfigOption(
            icon: FontAwesomeIcons.clock,
            title: 'Payment Time',
            subtitle: '${store['payment_time'] ?? 30} minutes for payment processing',
            onTap: null,
          ),
          const SizedBox(height: TossSpacing.space3),
          _buildConfigOption(
            icon: FontAwesomeIcons.locationDot,
            title: 'Check-in Distance',
            subtitle: '${store['allowed_distance'] ?? 100} meters maximum distance',
            onTap: null,
          ),
          const SizedBox(height: TossSpacing.space3),
          _buildConfigOption(
            icon: FontAwesomeIcons.mapLocationDot,
            title: 'Store Location',
            subtitle: _getLocationSubtitle(store),
            onTap: () => _showLocationSettingSheet(store),
          ),
          const SizedBox(height: TossSpacing.space3),
          _buildConfigOption(
            icon: FontAwesomeIcons.chartLine,
            title: 'Store Performance',
            subtitle: 'View detailed analytics',
            onTap: () {
              // Navigate to store analytics
            },
          ),
        ],
      ),
    );
  }

  // Build Store Operating Hours
  Widget _buildStoreOperatingHours(Map<String, dynamic> store) {
    return TossCard(
      padding: const EdgeInsets.all(TossSpacing.space5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Operating Hours',
                style: TossTextStyles.bodyLarge.copyWith(
                  color: TossColors.gray900,
                  fontWeight: FontWeight.w700,
                ),
              ),
              IconButton(
                onPressed: () {
                  // Edit operating hours
                },
                icon: Icon(
                  IconMapper.getIcon('editRegular'),
                  color: TossColors.primary,
                  size: TossSpacing.iconSM,
                ),
              ),
            ],
          ),
          const SizedBox(height: TossSpacing.space3),
          
          // Operating hours list
          _buildDayHours('Monday', '09:00 AM - 10:00 PM'),
          _buildDayHours('Tuesday', '09:00 AM - 10:00 PM'),
          _buildDayHours('Wednesday', '09:00 AM - 10:00 PM'),
          _buildDayHours('Thursday', '09:00 AM - 10:00 PM'),
          _buildDayHours('Friday', '09:00 AM - 11:00 PM'),
          _buildDayHours('Saturday', '10:00 AM - 11:00 PM'),
          _buildDayHours('Sunday', '10:00 AM - 09:00 PM'),
        ],
      ),
    );
  }

  // Helper method to build detail rows
  Widget _buildDetailRow(String label, String value, {Color? color}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TossTextStyles.body.copyWith(
            color: TossColors.gray600,
          ),
        ),
        Text(
          value,
          style: TossTextStyles.body.copyWith(
            color: color ?? TossColors.gray900,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  // Helper method to build config options
  Widget _buildConfigOption({
    required IconData icon,
    required String title,
    required String subtitle,
    VoidCallback? onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(TossBorderRadius.lg),
        splashColor: TossColors.primary.withValues(alpha: 0.1),
        highlightColor: TossColors.primary.withValues(alpha: 0.05),
        child: Ink(
          padding: const EdgeInsets.all(TossSpacing.space3),
          decoration: BoxDecoration(
            color: onTap != null ? TossColors.gray50 : TossColors.gray50.withValues(alpha: 0.5),
            borderRadius: BorderRadius.circular(TossBorderRadius.lg),
          ),
        child: Row(
          children: [
            Container(
              width: TossSpacing.iconXL,
              height: TossSpacing.iconXL,
              decoration: BoxDecoration(
                color: TossColors.white,
                borderRadius: BorderRadius.circular(TossBorderRadius.md),
              ),
              child: Icon(
                icon,
                color: TossColors.primary,
                size: TossSpacing.iconSM,
              ),
            ),
            const SizedBox(width: TossSpacing.space3),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TossTextStyles.body.copyWith(
                      color: TossColors.gray900,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: TossTextStyles.caption.copyWith(
                      color: TossColors.gray600,
                    ),
                  ),
                ],
              ),
            ),
            if (onTap != null)
              Icon(
                FontAwesomeIcons.chevronRight,
                color: TossColors.gray400,
                size: TossSpacing.iconSM,
              ),
          ],
        ),
        ),
      ),
    );
  }

  // Helper method to build day hours
  Widget _buildDayHours(String day, String hours) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: TossSpacing.space2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            day,
            style: TossTextStyles.body.copyWith(
              color: TossColors.gray700,
            ),
          ),
          Text(
            hours,
            style: TossTextStyles.body.copyWith(
              color: TossColors.gray900,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  // Store Selector Widget - Using the same data structure as homepage
  Widget _buildStoreSelector(dynamic userData) {
    final appState = ref.watch(appStateProvider);
    final selectedStore = ref.watch(selectedStoreProvider);
    
    // Get selected store name - Fixed to properly display selected store
    String storeName = 'Select Store';
    if (selectedStore != null && selectedStore['store_name'] != null) {
      // If we have a selected store from app state, use its name
      storeName = selectedStore['store_name'];
    } else if (appState.storeChoosen.isNotEmpty) {
      // Store is selected but not found - this shouldn't happen
      storeName = 'Select Store';
    } else {
      // No store selected
      storeName = 'Select Store';
    }
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Store',
          style: TossTextStyles.caption.copyWith(
            color: TossColors.gray500,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: TossSpacing.space2),
        InkWell(
          onTap: () => _showStoreSelector(),
          borderRadius: BorderRadius.circular(TossBorderRadius.xl),
          child: Container(
            padding: const EdgeInsets.all(TossSpacing.space4),
            decoration: BoxDecoration(
              color: TossColors.background,
              borderRadius: BorderRadius.circular(TossBorderRadius.xl),
              border: Border.all(
                color: selectedStore != null ? TossColors.primary.withValues(alpha: 0.3) : TossColors.gray200,
                width: selectedStore != null ? 1.5 : 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: TossColors.black.withValues(alpha: 0.04),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  width: TossSpacing.iconXL,
                  height: TossSpacing.iconXL,
                  decoration: BoxDecoration(
                    color: selectedStore != null
                      ? TossColors.primary.withValues(alpha: 0.1) 
                      : TossColors.gray50,
                    borderRadius: BorderRadius.circular(TossBorderRadius.md),
                  ),
                  child: Icon(
                    IconMapper.getIcon('building'),
                    size: TossSpacing.iconSM,
                    color: selectedStore != null
                      ? TossColors.primary 
                      : TossColors.gray600,
                  ),
                ),
                const SizedBox(width: TossSpacing.space3),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Store',
                        style: TossTextStyles.small.copyWith(
                          color: TossColors.gray500,
                        ),
                      ),
                      const SizedBox(height: TossSpacing.space1/2),
                      Text(
                        storeName,
                        style: TossTextStyles.body.copyWith(
                          color: selectedStore != null 
                            ? TossColors.gray900 
                            : TossColors.gray500,
                          fontWeight: selectedStore != null 
                            ? FontWeight.w600 
                            : FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  FontAwesomeIcons.chevronRight,
                  color: selectedStore != null 
                    ? TossColors.primary 
                    : TossColors.gray400,
                  size: TossSpacing.iconMD,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
  
  // Show Store Selector Modal - Using the reusable TossStoreSelector component
  void _showStoreSelector() async {
    final appState = ref.read(appStateProvider);
    final selectedCompany = ref.read(selectedCompanyProvider);
    final stores = selectedCompany?['stores'] as List<dynamic>? ?? [];
    
    final selectedStore = await TossStoreSelector.show(
      context: context,
      stores: stores,
      selectedStoreId: appState.storeChoosen,
      title: 'Select Store',
    );
    
    if (selectedStore != null) {
      // Update app state with selected store
      await ref.read(appStateProvider.notifier).setStoreChoosen(selectedStore['store_id'] ?? '');
    }
  }
  
  // Build Add Shift Section with + Button
  Widget _buildAddShiftSection() {
    return Container(
      decoration: BoxDecoration(
        color: TossColors.background,
        borderRadius: BorderRadius.circular(TossBorderRadius.xl),
        border: Border.all(
          color: TossColors.gray100,
          width: TossSpacing.space1/4,
        ),
        boxShadow: [
          BoxShadow(
            color: TossColors.black.withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: TossColors.transparent,
        child: InkWell(
          onTap: () {
            // Add shift functionality
            _showCreateShiftBottomSheet();
          },
          borderRadius: BorderRadius.circular(TossBorderRadius.xl),
          child: Padding(
            padding: const EdgeInsets.all(TossSpacing.space5),
            child: Row(
              children: [
                // Plus Icon Container
                Container(
                  width: TossSpacing.buttonHeightXL,
                  height: TossSpacing.buttonHeightXL,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        TossColors.primary,
                        TossColors.primary.withValues(alpha: 0.8),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(TossBorderRadius.xl),
                    boxShadow: [
                      BoxShadow(
                        color: TossColors.primary.withValues(alpha: 0.3),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: const Icon(
                    FontAwesomeIcons.plus,
                    color: TossColors.white,
                    size: TossSpacing.iconLG,
                  ),
                ),
                const SizedBox(width: TossSpacing.space4),
                // Text Content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Create New Shift',
                        style: TossTextStyles.bodyLarge.copyWith(
                          color: TossColors.gray900,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: TossSpacing.space1),
                      Text(
                        'Add a new shift schedule for this store',
                        style: TossTextStyles.bodySmall.copyWith(
                          color: TossColors.gray500,
                        ),
                      ),
                    ],
                  ),
                ),
                // Arrow Icon
                Icon(
                  FontAwesomeIcons.chevronRight,
                  color: TossColors.gray400,
                  size: TossSpacing.iconSM,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  
  // Build Existing Shifts Section with real data
  Widget _buildExistingShiftsSection() {
    final selectedStore = ref.watch(selectedStoreProvider);
    
    // Check if no store is selected
    if (selectedStore == null) {
      return TossCard(
        child: TossEmptyView(
          icon: Icon(
            IconMapper.getIcon('building'),
            size: UIConstants.emptyStateIconSize,
            color: TossColors.gray400,
          ),
          title: 'No Store Selected',
          description: 'Please select a store to manage shifts.',
        ),
      );
    }
    
    // Fetch real shift data from database
    final shiftsAsync = ref.watch(storeShiftsProvider);
    
    return shiftsAsync.when(
      data: (shifts) {
        if (shifts.isEmpty) {
          return TossCard(
            child: TossEmptyView(
              icon: Icon(
                IconMapper.getIcon('clock'),
                size: UIConstants.emptyStateIconSize,
                color: TossColors.gray400,
              ),
              title: 'No Shifts Yet',
              description: 'Create your first shift for this store.',
            ),
          );
        }
        
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Section Title with actual count
            Padding(
              padding: const EdgeInsets.only(bottom: TossSpacing.space3),
              child: Row(
                children: [
                  Text(
                    'Existing Shifts',
                    style: TossTextStyles.h4.copyWith(
                      color: TossColors.gray900,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(width: TossSpacing.space2),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: TossSpacing.space2,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: TossColors.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(TossBorderRadius.full),
                    ),
                    child: Text(
                      '${shifts.length}',
                      style: TossTextStyles.caption.copyWith(
                        color: TossColors.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            // Display real shift cards
            ...shifts.asMap().entries.map((entry) {
              final index = entry.key;
              final shift = entry.value;
              return Column(
                children: [
                  _buildRealShiftCard(shift),
                  if (index < shifts.length - 1)
                    const SizedBox(height: TossSpacing.space3),
                ],
              );
            }).toList(),
          ],
        );
      },
      loading: () => Center(
        child: Padding(
          padding: const EdgeInsets.all(TossSpacing.space6),
          child: CircularProgressIndicator(
            color: TossColors.primary,
          ),
        ),
      ),
      error: (error, stack) => Container(
        padding: const EdgeInsets.all(TossSpacing.space4),
        decoration: BoxDecoration(
          color: TossColors.error.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(TossBorderRadius.lg),
        ),
        child: Column(
          children: [
            Icon(
              FontAwesomeIcons.circleExclamation,
              size: TossSpacing.iconLG,
              color: TossColors.error,
            ),
            const SizedBox(height: TossSpacing.space2),
            Text(
              'Failed to load shifts',
              style: TossTextStyles.body.copyWith(
                color: TossColors.error,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: TossSpacing.space1),
            Text(
              error.toString(),
              style: TossTextStyles.caption.copyWith(
                color: TossColors.gray600,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
  
  // Build shift card with real data from database
  Widget _buildRealShiftCard(Map<String, dynamic> shift) {
    // Parse shift data
    final startTime = shift['start_time'] ?? '';
    final endTime = shift['end_time'] ?? '';
    final shiftId = shift['shift_id'] ?? '';
    final shiftName = shift['shift_name'] ?? 'Unnamed Shift';
    
    // Determine icon and color based on start time - intuitive time-of-day representation
    IconData icon = FontAwesomeIcons.clock;
    Color color = TossColors.info;
    
    // Parse start hour to determine icon and color
    if (startTime.isNotEmpty) {
      try {
        final hour = int.parse(startTime.split(':')[0]);
        if (hour >= 5 && hour < 12) {
          icon = FontAwesomeIcons.sun; // Morning - sunrise/bright sun
          color = TossColors.success;
        } else if (hour >= 12 && hour < 17) {
          icon = FontAwesomeIcons.solidSun; // Afternoon - bright day
          color = TossColors.info;
        } else if (hour >= 17 && hour < 22) {
          icon = FontAwesomeIcons.cloudSun; // Evening - sun setting
          color = TossColors.warning;
        } else {
          icon = FontAwesomeIcons.moon; // Night - moon
          color = TossColors.gray600;
        }
      } catch (e) {
        // Use default icon and color on parse error
      }
    }
    
    return TossCard(
      onTap: () {
        // Edit shift functionality - pass shiftId
      },
      padding: const EdgeInsets.all(TossSpacing.space4),
      child: Row(
        children: [
          // Icon Container
          Container(
            width: TossSpacing.iconXL + TossSpacing.space2,
            height: TossSpacing.iconXL + TossSpacing.space2,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(TossBorderRadius.lg),
            ),
            child: Icon(
              icon,
              color: color,
              size: TossSpacing.iconMD,
            ),
          ),
          const SizedBox(width: TossSpacing.space3),
          // Shift Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  shiftName,
                  style: TossTextStyles.body.copyWith(
                    color: TossColors.gray900,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: TossSpacing.space1/2),
                Text(
                  '$startTime - $endTime',
                  style: TossTextStyles.caption.copyWith(
                    color: TossColors.gray500,
                  ),
                ),
              ],
            ),
          ),
          // Action Buttons
          Row(
            children: [
              IconButton(
                onPressed: () {
                  // Edit functionality with shiftId
                  _showEditShiftBottomSheet(shift);
                },
                icon: FaIcon(
                  IconMapper.getIcon('editRegular'),
                  color: TossColors.gray500,
                  size: TossSpacing.iconSM,
                ),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(
                  minWidth: TossSpacing.buttonHeightSM,
                  minHeight: TossSpacing.buttonHeightSM,
                ),
              ),
              IconButton(
                onPressed: () {
                  // Delete functionality with shiftId
                  _showDeleteConfirmation(shiftId, shiftName);
                },
                icon: FaIcon(
                  FontAwesomeIcons.trashCan,
                  color: TossColors.error,
                  size: TossSpacing.iconSM,
                ),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(
                  minWidth: TossSpacing.buttonHeightSM,
                  minHeight: TossSpacing.buttonHeightSM,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
  
  
  // Show Create Shift Bottom Sheet
  void _showCreateShiftBottomSheet() {
    // State variables for the bottom sheet
    String shiftName = '';
    TimeOfDay? selectedStartTime;
    TimeOfDay? selectedEndTime;
    
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: TossColors.transparent,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => Container(
          height: MediaQuery.of(context).size.height * 0.8,
          decoration: const BoxDecoration(
            color: TossColors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(24),
              topRight: Radius.circular(24),
            ),
          ),
          child: Column(
            children: [
              // Handle bar
              Container(
                margin: const EdgeInsets.only(top: TossSpacing.space3),
                width: TossSpacing.iconXL,
                height: TossSpacing.space1,
                decoration: BoxDecoration(
                  color: TossColors.gray300,
                  borderRadius: BorderRadius.circular(TossBorderRadius.full),
                ),
              ),
              
              // Header
              Container(
                padding: const EdgeInsets.all(TossSpacing.space5),
                child: Text(
                  'Create New Shift',
                  style: TossTextStyles.h3.copyWith(
                    color: TossColors.gray900,
                    fontWeight: FontWeight.w700,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              
              // Content
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(TossSpacing.space5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Shift Name Input Section
                      TossTextField(
                        label: 'Shift Name',
                        hintText: 'e.g., Morning Shift, Night Shift',
                        textInputAction: TextInputAction.next,
                        onChanged: (value) {
                          setState(() {
                            shiftName = value;
                          });
                        },
                      ),
                      
                      const SizedBox(height: TossSpacing.space6),
                      
                      // Time Settings Section
                      Container(
                        padding: const EdgeInsets.all(TossSpacing.space4),
                        decoration: BoxDecoration(
                          color: TossColors.primary.withValues(alpha: 0.03),
                          borderRadius: BorderRadius.circular(TossBorderRadius.xl),
                          border: Border.all(
                            color: _getShiftIconAndColorFromTimeString(
                              selectedStartTime != null ? selectedStartTime!.format(context) : ''
                            )['color'].withValues(alpha: 0.1),
                            width: TossSpacing.space1/4,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                FaIcon(
                                  IconMapper.getIcon('clock'),
                                  color: TossColors.primary,
                                  size: TossSpacing.iconSM,
                                ),
                                const SizedBox(width: TossSpacing.space2),
                                Text(
                                  'Shift Hours',
                                  style: TossTextStyles.body.copyWith(
                                    color: TossColors.gray700,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: TossSpacing.space4),
                            
                            // Start Time
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Start Time',
                                  style: TossTextStyles.caption.copyWith(
                                    color: TossColors.gray600,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(height: TossSpacing.space2),
                                TossSimpleTimePicker(
                                  time: selectedStartTime,
                                  placeholder: 'Select start time',
                                  onTimeChanged: (TimeOfDay time) {
                                    setState(() {
                                      selectedStartTime = time;
                                    });
                                  },
                                  use24HourFormat: false,
                                ),
                              ],
                            ),
                            
                            const SizedBox(height: TossSpacing.space4),
                            
                            // End Time
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'End Time',
                                  style: TossTextStyles.caption.copyWith(
                                    color: TossColors.gray600,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(height: TossSpacing.space2),
                                TossSimpleTimePicker(
                                  time: selectedEndTime,
                                  placeholder: 'Select end time',
                                  onTimeChanged: (TimeOfDay time) {
                                    setState(() {
                                      selectedEndTime = time;
                                    });
                                  },
                                  use24HourFormat: false,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      
                      const SizedBox(height: TossSpacing.space5),
                      
                      // Duration Display (only show if both times are selected)
                      if (selectedStartTime != null && selectedEndTime != null)
                        Container(
                          padding: const EdgeInsets.all(TossSpacing.space4),
                          decoration: BoxDecoration(
                            color: TossColors.success.withValues(alpha: 0.05),
                            borderRadius: BorderRadius.circular(TossBorderRadius.lg),
                            border: Border.all(
                              color: TossColors.success.withValues(alpha: 0.2),
                              width: TossSpacing.space1/4,
                            ),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                FontAwesomeIcons.stopwatch,
                                color: TossColors.success,
                                size: TossSpacing.iconSM,
                              ),
                              const SizedBox(width: TossSpacing.space3),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Total Duration',
                                    style: TossTextStyles.caption.copyWith(
                                      color: TossColors.gray600,
                                    ),
                                  ),
                                  const SizedBox(height: TossSpacing.space1/2),
                                  Text(
                                    _calculateDurationFromTimeOfDay(selectedStartTime!, selectedEndTime!),
                                    style: TossTextStyles.body.copyWith(
                                      color: TossColors.gray900,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      
                      const SizedBox(height: TossSpacing.space6),
                    ],
                  ),
                ),
              ),
              
              // Bottom Create Button
              Container(
                padding: EdgeInsets.fromLTRB(
                  TossSpacing.space5,
                  TossSpacing.space4,
                  TossSpacing.space5,
                  MediaQuery.of(context).padding.bottom + TossSpacing.space4,
                ),
                decoration: BoxDecoration(
                  color: TossColors.white,
                  border: Border(
                    top: BorderSide(
                      color: TossColors.gray100,
                      width: 0.5,
                    ),
                  ),
                ),
                child: TossPrimaryButton(
                  text: 'Create Shift',
                  fullWidth: true,
                  isEnabled: shiftName.isNotEmpty && selectedStartTime != null && selectedEndTime != null,
                  onPressed: (shiftName.isNotEmpty && selectedStartTime != null && selectedEndTime != null) ? () {
                    _showCreateConfirmation(
                      context: context,
                      shiftName: shiftName,
                      startTime: selectedStartTime!.format(context),
                      endTime: selectedEndTime!.format(context),
                    );
                  } : null,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  
  // Helper method to get shift icon and color from time string (for preview dialogs)
  Map<String, dynamic> _getShiftIconAndColorFromTimeString(String timeString) {
    IconData icon = FontAwesomeIcons.clock;
    Color color = TossColors.info;
    
    if (timeString.isEmpty) {
      return {'icon': icon, 'color': color};
    }
    
    try {
      // Simple parsing for formatted times like "9:00 AM" or "5:30 PM"
      if (timeString.contains('AM') || timeString.contains('PM')) {
        final parts = timeString.split(' ');
        if (parts.length >= 2) {
          final timePart = parts[0];
          final period = parts[1];
          final timeParts = timePart.split(':');
          
          if (timeParts.length >= 2) {
            var hour = int.parse(timeParts[0]);
            if (period == 'PM' && hour != 12) {
              hour += 12;
            } else if (period == 'AM' && hour == 12) {
              hour = 0;
            }
            
            // Use same intuitive time-based icons as shift cards
            if (hour >= 5 && hour < 12) {
              icon = FontAwesomeIcons.sun; // Morning - sunrise/bright sun
              color = TossColors.success;
            } else if (hour >= 12 && hour < 17) {
              icon = FontAwesomeIcons.solidSun; // Afternoon - bright day
              color = TossColors.info;
            } else if (hour >= 17 && hour < 22) {
              icon = FontAwesomeIcons.cloudSun; // Evening - sun setting
              color = TossColors.warning;
            } else {
              icon = FontAwesomeIcons.moon; // Night - moon
              color = TossColors.gray600;
            }
          }
        }
      }
    } catch (e) {
      // Fallback to default icon and color
    }
    
    return {'icon': icon, 'color': color};
  }
  
  // Helper method to calculate duration from time strings (for confirmation dialog)
  String _calculateDurationFromTimeStrings(String startTimeString, String endTimeString) {
    try {
      // Convert time strings to TimeOfDay objects for calculation
      TimeOfDay? startTime;
      TimeOfDay? endTime;
      
      // Parse AM/PM format
      if (startTimeString.contains('AM') || startTimeString.contains('PM')) {
        startTime = _parseTimeFromString(startTimeString);
      }
      
      if (endTimeString.contains('AM') || endTimeString.contains('PM')) {
        endTime = _parseTimeFromString(endTimeString);
      }
      
      if (startTime != null && endTime != null) {
        return _calculateDurationFromTimeOfDay(startTime, endTime);
      }
    } catch (e) {
      // Fallback to simple calculation
    }
    
    return 'Unable to calculate';
  }
  
  // Helper method to parse TimeOfDay from AM/PM string
  TimeOfDay? _parseTimeFromString(String timeString) {
    try {
      final parts = timeString.split(' ');
      if (parts.length >= 2) {
        final timePart = parts[0];
        final period = parts[1];
        final timeParts = timePart.split(':');
        
        if (timeParts.length >= 2) {
          var hour = int.parse(timeParts[0]);
          final minute = int.parse(timeParts[1]);
          
          if (period == 'PM' && hour != 12) {
            hour += 12;
          } else if (period == 'AM' && hour == 12) {
            hour = 0;
          }
          
          return TimeOfDay(hour: hour, minute: minute);
        }
      }
    } catch (e) {
      // Return null on parse error
    }
    
    return null;
  }
  
  
  // Calculate duration between two TimeOfDay objects
  String _calculateDurationFromTimeOfDay(TimeOfDay startTime, TimeOfDay endTime) {
    try {
      var totalMinutes = (endTime.hour * 60 + endTime.minute) - (startTime.hour * 60 + startTime.minute);
      
      // Handle overnight shifts
      if (totalMinutes < 0) {
        totalMinutes += 24 * 60;
      }
      
      final hours = totalMinutes ~/ 60;
      final minutes = totalMinutes % 60;
      
      if (minutes == 0) {
        return '$hours hours';
      } else {
        return '$hours hours $minutes minutes';
      }
    } catch (e) {
      return 'Invalid duration';
    }
  }
  
  // Show Edit Shift Bottom Sheet
  void _showEditShiftBottomSheet(Map<String, dynamic> shift) {
    // Parse existing shift data
    final startTime = shift['start_time'] ?? '09:00';
    final endTime = shift['end_time'] ?? '17:00';
    final shiftId = shift['shift_id'] ?? '';
    final existingShiftName = shift['shift_name'] ?? 'Unnamed Shift';
    
    // State variables for the bottom sheet
    String shiftName = existingShiftName;
    TimeOfDay selectedStartTime = _parseTimeOfDay(startTime);
    TimeOfDay selectedEndTime = _parseTimeOfDay(endTime);
    
    // Create a TextEditingController for the shift name
    final shiftNameController = TextEditingController(text: existingShiftName);
    
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: TossColors.transparent,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => Container(
          height: MediaQuery.of(context).size.height * 0.8,
          decoration: const BoxDecoration(
            color: TossColors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(24),
              topRight: Radius.circular(24),
            ),
          ),
          child: Column(
            children: [
              // Handle bar
              Container(
                margin: const EdgeInsets.only(top: TossSpacing.space3),
                width: TossSpacing.iconXL,
                height: TossSpacing.space1,
                decoration: BoxDecoration(
                  color: TossColors.gray300,
                  borderRadius: BorderRadius.circular(TossBorderRadius.full),
                ),
              ),
              
              // Header
              Container(
                padding: const EdgeInsets.all(TossSpacing.space5),
                child: Text(
                  'Edit Shift',
                  style: TossTextStyles.h3.copyWith(
                    color: TossColors.gray900,
                    fontWeight: FontWeight.w700,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              
              // Content
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(TossSpacing.space5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Shift Name Input Section - Using TossTextField for consistency
                      TossTextField(
                        label: 'Shift Name',
                        hintText: 'e.g., Morning Shift, Night Shift',
                        controller: shiftNameController,
                        textInputAction: TextInputAction.next,
                        onChanged: (value) {
                          setState(() {
                            shiftName = value;
                          });
                        },
                      ),
                      
                      const SizedBox(height: TossSpacing.space6),
                      
                      // Time Settings Section - Matching Create Shift design
                      Container(
                        padding: const EdgeInsets.all(TossSpacing.space4),
                        decoration: BoxDecoration(
                          color: TossColors.primary.withValues(alpha: 0.03),
                          borderRadius: BorderRadius.circular(TossBorderRadius.xl),
                          border: Border.all(
                            color: _getShiftIconAndColorFromTimeString(startTime)['color'].withValues(alpha: 0.1),
                            width: TossSpacing.space1/4,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                FaIcon(
                                  IconMapper.getIcon('clock'),
                                  color: TossColors.primary,
                                  size: TossSpacing.iconSM,
                                ),
                                const SizedBox(width: TossSpacing.space2),
                                Text(
                                  'Shift Hours',
                                  style: TossTextStyles.body.copyWith(
                                    color: TossColors.gray700,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: TossSpacing.space4),
                            
                            // Start Time
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Start Time',
                                  style: TossTextStyles.caption.copyWith(
                                    color: TossColors.gray600,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(height: TossSpacing.space2),
                                TossSimpleTimePicker(
                                  time: selectedStartTime,
                                  onTimeChanged: (TimeOfDay time) {
                                    setState(() {
                                      selectedStartTime = time;
                                    });
                                  },
                                  use24HourFormat: false,
                                ),
                              ],
                            ),
                            
                            const SizedBox(height: TossSpacing.space4),
                            
                            // End Time
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'End Time',
                                  style: TossTextStyles.caption.copyWith(
                                    color: TossColors.gray600,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(height: TossSpacing.space2),
                                TossSimpleTimePicker(
                                  time: selectedEndTime,
                                  onTimeChanged: (TimeOfDay time) {
                                    setState(() {
                                      selectedEndTime = time;
                                    });
                                  },
                                  use24HourFormat: false,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      
                      const SizedBox(height: TossSpacing.space5),
                      
                      // Duration Display - Matching Create Shift green styling
                      Container(
                        padding: const EdgeInsets.all(TossSpacing.space4),
                        decoration: BoxDecoration(
                          color: TossColors.success.withValues(alpha: 0.05),
                          borderRadius: BorderRadius.circular(TossBorderRadius.lg),
                          border: Border.all(
                            color: TossColors.success.withValues(alpha: 0.2),
                            width: TossSpacing.space1/4,
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              FontAwesomeIcons.stopwatch,
                              color: TossColors.success,
                              size: TossSpacing.iconSM,
                            ),
                            const SizedBox(width: TossSpacing.space3),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Total Duration',
                                  style: TossTextStyles.caption.copyWith(
                                    color: TossColors.gray600,
                                  ),
                                ),
                                const SizedBox(height: TossSpacing.space1/2),
                                Text(
                                  _calculateDurationFromTimeOfDay(selectedStartTime, selectedEndTime),
                                  style: TossTextStyles.body.copyWith(
                                    color: TossColors.gray900,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      
                      const SizedBox(height: TossSpacing.space6),
                    ],
                  ),
                ),
              ),
              
              // Bottom Save Button - Matching Create Shift design
              Container(
                padding: EdgeInsets.fromLTRB(
                  TossSpacing.space5,
                  TossSpacing.space4,
                  TossSpacing.space5,
                  MediaQuery.of(context).padding.bottom + TossSpacing.space4,
                ),
                decoration: BoxDecoration(
                  color: TossColors.white,
                  border: Border(
                    top: BorderSide(
                      color: TossColors.gray100,
                      width: 0.5,
                    ),
                  ),
                ),
                child: TossPrimaryButton(
                  text: 'Save Changes',
                  fullWidth: true,
                  isEnabled: shiftName.isNotEmpty,
                  onPressed: shiftName.isNotEmpty ? () {
                    _showEditConfirmation(
                      context: context,
                      shiftId: shiftId,
                      shiftName: shiftName,
                      startTime: selectedStartTime.format(context),
                      endTime: selectedEndTime.format(context),
                    );
                  } : null,
                ),
              ),
            ],
          ),
        ),
      ),
    );
    
  }
  
  // Helper method to parse TimeOfDay from string
  TimeOfDay _parseTimeOfDay(String timeString) {
    try {
      final parts = timeString.split(':');
      return TimeOfDay(
        hour: int.parse(parts[0]),
        minute: int.parse(parts[1]),
      );
    } catch (e) {
      return TimeOfDay.now();
    }
  }
  
  // Helper method to format time for database (converts 12-hour format to 24-hour HH:mm:ss)
  String _formatTimeForDatabase(String timeString) {
    try {
      // Check if it's already in 24-hour format (HH:mm or HH:mm:ss)
      if (!timeString.contains('AM') && !timeString.contains('PM')) {
        // Already in 24-hour format, just add seconds if missing
        if (timeString.split(':').length == 2) {
          return '$timeString:00';
        }
        return timeString;
      }
      
      // Parse 12-hour format (e.g., "6:00 PM" or "11:30 AM")
      final parts = timeString.trim().split(' ');
      if (parts.length != 2) {
        throw Exception('Invalid time format');
      }
      
      final timePart = parts[0];
      final period = parts[1].toUpperCase();
      final timeParts = timePart.split(':');
      
      if (timeParts.length != 2) {
        throw Exception('Invalid time format');
      }
      
      var hour = int.parse(timeParts[0]);
      final minute = int.parse(timeParts[1]);
      
      // Convert to 24-hour format
      if (period == 'PM' && hour != 12) {
        hour += 12;
      } else if (period == 'AM' && hour == 12) {
        hour = 0;
      }
      
      // Format as HH:mm:ss
      return '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}:00';
    } catch (e) {
      // Fallback: return current time formatted
      final now = TimeOfDay.now();
      return '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}:00';
    }
  }
  
  // Show edit confirmation dialog
  void _showEditConfirmation({
    required BuildContext context,
    required String shiftId,
    required String shiftName,
    required String startTime,
    required String endTime,
  }) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(TossBorderRadius.xl),
        ),
        title: Text(
          'Update Shift',
          style: TossTextStyles.h3.copyWith(
            color: TossColors.gray900,
            fontWeight: FontWeight.w700,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Are you sure you want to update this shift?',
              style: TossTextStyles.body.copyWith(
                color: TossColors.gray700,
              ),
            ),
            const SizedBox(height: TossSpacing.paddingMD),
            // Enhanced Shift Preview Card - Full width for consistent UI/UX
            Container(
              width: double.infinity, // Make horizontally bigger for consistency
              padding: const EdgeInsets.all(TossSpacing.space4),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    TossColors.primary.withValues(alpha: 0.05),
                    TossColors.primary.withValues(alpha: 0.02),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(TossBorderRadius.xl),
                border: Border.all(
                  color: TossColors.primary.withValues(alpha: 0.2),
                  width: TossSpacing.space1/4,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Preview header
                  Text(
                    'Shift Preview',
                    style: TossTextStyles.caption.copyWith(
                      color: TossColors.gray600,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: TossSpacing.space3),
                  
                  // Shift details with icon
                  Row(
                    children: [
                      Container(
                        width: TossSpacing.iconXL + TossSpacing.space2,
                        height: TossSpacing.iconXL + TossSpacing.space2,
                        decoration: BoxDecoration(
                          color: _getShiftIconAndColorFromTimeString(startTime)['color'].withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(TossBorderRadius.lg),
                        ),
                        child: Center(
                          child: FaIcon(
                            _getShiftIconAndColorFromTimeString(startTime)['icon'],
                            color: _getShiftIconAndColorFromTimeString(startTime)['color'],
                            size: TossSpacing.iconMD,
                          ),
                        ),
                      ),
                      const SizedBox(width: TossSpacing.space3),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              shiftName,
                              style: TossTextStyles.body.copyWith(
                                color: TossColors.gray900,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: TossSpacing.space1),
                            Text(
                              '$startTime - $endTime',
                              style: TossTextStyles.caption.copyWith(
                                color: TossColors.gray600,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: TossSpacing.space3),
                  
                  // Duration info
                  Container(
                    padding: const EdgeInsets.all(TossSpacing.space3),
                    decoration: BoxDecoration(
                      color: TossColors.success.withValues(alpha: 0.05),
                      borderRadius: BorderRadius.circular(TossBorderRadius.lg),
                      border: Border.all(
                        color: TossColors.success.withValues(alpha: 0.2),
                        width: TossSpacing.space1/4,
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          FontAwesomeIcons.stopwatch,
                          color: TossColors.success,
                          size: TossSpacing.iconSM,
                        ),
                        const SizedBox(width: TossSpacing.space2),
                        Text(
                          'Duration: ',
                          style: TossTextStyles.caption.copyWith(
                            color: TossColors.gray600,
                          ),
                        ),
                        Text(
                          _calculateDurationFromTimeStrings(startTime, endTime),
                          style: TossTextStyles.caption.copyWith(
                            color: TossColors.gray900,
                            fontWeight: FontWeight.w600,
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
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(
              'Cancel',
              style: TossTextStyles.body.copyWith(
                color: TossColors.gray600,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(dialogContext); // Close confirmation dialog
              Navigator.pop(context); // Close bottom sheet first
              // Small delay to ensure bottom sheet is closed before updating
              await Future.delayed(TossAnimations.quick);
              await _updateShift(shiftId, shiftName, startTime, endTime);
            },
            child: Text(
              'OK',
              style: TossTextStyles.body.copyWith(
                color: TossColors.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  // Show create confirmation dialog
  void _showCreateConfirmation({
    required BuildContext context,
    required String shiftName,
    required String startTime,
    required String endTime,
  }) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(TossBorderRadius.xl),
        ),
        title: Text(
          'Create New Shift',
          style: TossTextStyles.h3.copyWith(
            color: TossColors.gray900,
            fontWeight: FontWeight.w700,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Are you sure you want to create this shift?',
              style: TossTextStyles.body.copyWith(
                color: TossColors.gray700,
              ),
            ),
            const SizedBox(height: TossSpacing.paddingMD),
            // Enhanced Shift Preview Card - Full width for consistent UI/UX
            Container(
              width: double.infinity, // Make horizontally bigger for consistency
              padding: const EdgeInsets.all(TossSpacing.space4),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    TossColors.primary.withValues(alpha: 0.05),
                    TossColors.primary.withValues(alpha: 0.02),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(TossBorderRadius.xl),
                border: Border.all(
                  color: TossColors.primary.withValues(alpha: 0.2),
                  width: TossSpacing.space1/4,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Preview header
                  Text(
                    'Shift Preview',
                    style: TossTextStyles.caption.copyWith(
                      color: TossColors.gray600,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: TossSpacing.space3),
                  
                  // Shift details with icon
                  Row(
                    children: [
                      Container(
                        width: TossSpacing.iconXL + TossSpacing.space2,
                        height: TossSpacing.iconXL + TossSpacing.space2,
                        decoration: BoxDecoration(
                          color: _getShiftIconAndColorFromTimeString(startTime)['color'].withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(TossBorderRadius.lg),
                        ),
                        child: Center(
                          child: FaIcon(
                            _getShiftIconAndColorFromTimeString(startTime)['icon'],
                            color: _getShiftIconAndColorFromTimeString(startTime)['color'],
                            size: TossSpacing.iconMD,
                          ),
                        ),
                      ),
                      const SizedBox(width: TossSpacing.space3),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              shiftName,
                              style: TossTextStyles.body.copyWith(
                                color: TossColors.gray900,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: TossSpacing.space1),
                            Text(
                              '$startTime - $endTime',
                              style: TossTextStyles.caption.copyWith(
                                color: TossColors.gray600,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: TossSpacing.space3),
                  
                  // Duration info
                  Container(
                    padding: const EdgeInsets.all(TossSpacing.space3),
                    decoration: BoxDecoration(
                      color: TossColors.success.withValues(alpha: 0.05),
                      borderRadius: BorderRadius.circular(TossBorderRadius.lg),
                      border: Border.all(
                        color: TossColors.success.withValues(alpha: 0.2),
                        width: TossSpacing.space1/4,
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          FontAwesomeIcons.stopwatch,
                          color: TossColors.success,
                          size: TossSpacing.iconSM,
                        ),
                        const SizedBox(width: TossSpacing.space2),
                        Text(
                          'Duration: ',
                          style: TossTextStyles.caption.copyWith(
                            color: TossColors.gray600,
                          ),
                        ),
                        Text(
                          _calculateDurationFromTimeStrings(startTime, endTime),
                          style: TossTextStyles.caption.copyWith(
                            color: TossColors.gray900,
                            fontWeight: FontWeight.w600,
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
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(
              'Cancel',
              style: TossTextStyles.body.copyWith(
                color: TossColors.gray600,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(dialogContext); // Close confirmation dialog
              await _createShift(shiftName, startTime, endTime);
              Navigator.pop(context); // Close bottom sheet
            },
            child: Text(
              'OK',
              style: TossTextStyles.body.copyWith(
                color: TossColors.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  // Create shift in database
  Future<void> _createShift(String shiftName, String startTime, String endTime) async {
    try {
      final appState = ref.read(appStateProvider);
      final storeId = appState.storeChoosen;
      
      if (storeId.isEmpty) {
        throw Exception('No store selected');
      }
      
      // Get current timestamp
      final now = DateTime.now();
      final timestamp = now.toIso8601String();
      
      // Format times to 24-hour format (HH:mm:ss) for database
      final formattedStartTime = _formatTimeForDatabase(startTime);
      final formattedEndTime = _formatTimeForDatabase(endTime);
      
      final supabase = Supabase.instance.client;
      
      // Insert new shift
      await supabase.from('store_shifts').insert({
        'store_id': storeId,
        'shift_name': shiftName,
        'start_time': formattedStartTime,
        'end_time': formattedEndTime,
        'is_active': true,
        'created_at': timestamp,
        'updated_at': timestamp,
        'is_can_overtime': true,
      });
      
      // Refresh the shifts list
      ref.invalidate(storeShiftsProvider);
      
      // Show success message
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Shift created successfully'),
            backgroundColor: TossColors.success,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(TossBorderRadius.button)),
          ),
        );
      }
    } catch (e) {
      
      _showErrorMessage('Failed to create shift: ${e.toString()}');
    }
  }
  
  // Show delete confirmation dialog
  void _showDeleteConfirmation(String shiftId, String shiftName) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(TossBorderRadius.xl),
        ),
        title: Text(
          'Delete Shift',
          style: TossTextStyles.h3.copyWith(
            color: TossColors.gray900,
            fontWeight: FontWeight.w700,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Are you sure you want to delete this shift?',
              style: TossTextStyles.body.copyWith(
                color: TossColors.gray700,
              ),
            ),
            const SizedBox(height: TossSpacing.paddingMD),
            Container(
              padding: EdgeInsets.all(TossSpacing.space3),
              decoration: BoxDecoration(
                color: TossColors.error.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(TossBorderRadius.button),
                border: Border.all(
                  color: TossColors.error.withValues(alpha: 0.2),
                  width: TossSpacing.space1/4,
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    FontAwesomeIcons.trashCan,
                    size: TossSpacing.iconSM,
                    color: TossColors.error,
                  ),
                  const SizedBox(width: TossSpacing.space2),
                  Expanded(
                    child: Text(
                      shiftName,
                      style: TossTextStyles.body.copyWith(
                        color: TossColors.gray900,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: TossSpacing.space3),
            Text(
              'This shift will be deactivated and won\'t be visible anymore.',
              style: TossTextStyles.caption.copyWith(
                color: TossColors.gray500,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(
              'Cancel',
              style: TossTextStyles.body.copyWith(
                color: TossColors.gray600,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(dialogContext);
              await _deleteShift(shiftId, shiftName);
            },
            child: Text(
              'Yes, Delete',
              style: TossTextStyles.body.copyWith(
                color: TossColors.error,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  // Update shift in database
  Future<void> _updateShift(String shiftId, String shiftName, String startTime, String endTime) async {
    try {
      // Format times to 24-hour format (HH:mm:ss) for database
      final formattedStartTime = _formatTimeForDatabase(startTime);
      final formattedEndTime = _formatTimeForDatabase(endTime);
      
      // Get current timestamp in yyyy-MM-dd HH:mm:ss.SSSS format
      final now = DateTime.now();
      final timestamp = now.toIso8601String();
      
      final supabase = Supabase.instance.client;
      
      // Update shift with proper column names
      await supabase
          .from('store_shifts')
          .update({
            'shift_name': shiftName,
            'start_time': formattedStartTime,
            'end_time': formattedEndTime,
            'updated_at': timestamp,
          })
          .eq('shift_id', shiftId);
      
      // Refresh the shifts list
      ref.invalidate(storeShiftsProvider);
      
      // Show success message
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Shift updated successfully'),
            backgroundColor: TossColors.success,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(TossBorderRadius.button)),
          ),
        );
      }
    } catch (e) {
      
      // Show error message
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to update shift: ${e.toString()}'),
            backgroundColor: TossColors.error,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(TossBorderRadius.button)),
          ),
        );
      }
    }
  }
  
  // Delete shift (set is_active to false)
  Future<void> _deleteShift(String shiftId, String shiftName) async {
    try {
      final supabase = Supabase.instance.client;
      
      // Update shift to set is_active to false
      await supabase
          .from('store_shifts')
          .update({
            'is_active': false,
            'updated_at': DateTime.now().toIso8601String(),
          })
          .eq('shift_id', shiftId);
      
      // Refresh the shifts list
      ref.invalidate(storeShiftsProvider);
      
      // Show success message
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Shift "$shiftName" deleted successfully'),
            backgroundColor: TossColors.success,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(TossBorderRadius.button)),
          ),
        );
      }
    } catch (e) {
      
      // Show error message
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to delete shift: ${e.toString()}'),
            backgroundColor: TossColors.error,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(TossBorderRadius.button)),
          ),
        );
      }
    }
  }
  
  // Show Edit Store Information Bottom Sheet
  void _showEditStoreInfoSheet(Map<String, dynamic> store) {
    // Controllers for the form
    final storeNameController = TextEditingController(text: store['store_name'] ?? '');
    final storeAddressController = TextEditingController(text: store['store_address'] ?? '');
    final storePhoneController = TextEditingController(text: store['store_phone'] ?? '');
    
    TossBottomSheet.show(
      context: context,
      title: 'Edit Store Information',
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Store Name
          TossTextField(
            label: 'Store Name',
            controller: storeNameController,
            hintText: 'Enter store name',
            textInputAction: TextInputAction.next,
          ),
          
          const SizedBox(height: TossSpacing.space5),
          
          // Store Address
          TossTextField(
            label: 'Store Address',
            controller: storeAddressController,
            hintText: 'Enter store address',
            maxLines: 2,
            textInputAction: TextInputAction.next,
          ),
          
          const SizedBox(height: TossSpacing.space5),
          
          // Store Phone
          TossTextField(
            label: 'Store Phone',
            controller: storePhoneController,
            hintText: 'Enter store phone number',
            keyboardType: TextInputType.phone,
            textInputAction: TextInputAction.done,
          ),
          
          const SizedBox(height: TossSpacing.space4),
          
          // Save Button
          TossPrimaryButton(
            text: 'Save Changes',
            fullWidth: true,
            onPressed: () async {
              await _updateStoreInfo(
                store['store_id'],
                storeNameController.text.trim(),
                storeAddressController.text.trim(),
                storePhoneController.text.trim(),
              );
              if (mounted) {
                Navigator.pop(context);
              }
            },
          ),
        ],
      ),
    );
  }
  
  // Show Edit Operational Settings Bottom Sheet
  void _showEditOperationalSettingsSheet(Map<String, dynamic> store) {
    // Controllers for the form
    final huddleTimeController = TextEditingController(
      text: (store['huddle_time'] ?? 15).toString()
    );
    final paymentTimeController = TextEditingController(
      text: (store['payment_time'] ?? 30).toString()
    );
    final allowedDistanceController = TextEditingController(
      text: (store['allowed_distance'] ?? 100).toString()
    );
    
    TossBottomSheet.show(
      context: context,
      title: 'Edit Operational Settings',
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Huddle Time with description
          _buildNumberInputWithDescription(
            label: 'Huddle Time',
            controller: huddleTimeController,
            suffix: 'minutes',
            description: 'Time allocated for team meetings',
          ),
          
          const SizedBox(height: TossSpacing.space5),
          
          // Payment Time with description
          _buildNumberInputWithDescription(
            label: 'Payment Time',
            controller: paymentTimeController,
            suffix: 'minutes',
            description: 'Time allocated for payment processing',
          ),
          
          const SizedBox(height: TossSpacing.space5),
          
          // Check-in Distance with description
          _buildNumberInputWithDescription(
            label: 'Check-in Distance',
            controller: allowedDistanceController,
            suffix: 'meters',
            description: 'Maximum distance from store for check-in',
          ),
          
          const SizedBox(height: TossSpacing.space4),
          
          // Save Button
          TossPrimaryButton(
            text: 'Save Changes',
            fullWidth: true,
            onPressed: () async {
              await _updateOperationalSettings(
                store['store_id'],
                int.tryParse(huddleTimeController.text),
                int.tryParse(paymentTimeController.text),
                int.tryParse(allowedDistanceController.text),
              );
              if (mounted) {
                Navigator.pop(context);
              }
            },
          ),
        ],
      ),
    );
  }
  
  // Helper method to build number input with description
  Widget _buildNumberInputWithDescription({
    required String label,
    required TextEditingController controller,
    required String suffix,
    required String description,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TossTextStyles.labelLarge.copyWith(
            color: TossColors.gray900,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: TossSpacing.space2),
        TossNumberInput(
          controller: controller,
          hintText: '0',
          suffix: suffix,
          height: 48,
          textAlign: TextAlign.left,
        ),
        const SizedBox(height: TossSpacing.space2),
        Text(
          description,
          style: TossTextStyles.caption.copyWith(
            color: TossColors.gray500,
          ),
        ),
      ],
    );
  }
  
  // Update store information in database
  Future<void> _updateStoreInfo(
    String storeId,
    String storeName,
    String storeAddress,
    String storePhone,
  ) async {
    try {
      ref.read(storeUpdateLoadingProvider.notifier).state = true;
      
      final storeService = ref.read(storeServiceProvider);
      final success = await storeService.updateStore(
        storeId: storeId,
        storeName: storeName.isEmpty ? null : storeName,
        storeAddress: storeAddress.isEmpty ? null : storeAddress,
        storePhone: storePhone.isEmpty ? null : storePhone,
      );
      
      if (success) {
        // Refresh store details
        ref.invalidate(storeDetailsProvider);
        
        // Show success message
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Store information updated successfully'),
              backgroundColor: TossColors.success,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(TossBorderRadius.button),
              ),
            ),
          );
        }
      } else {
        throw Exception('Failed to update store information');
      }
    } catch (e) {
      // Show error message
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to update store: ${e.toString()}'),
            backgroundColor: TossColors.error,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(TossBorderRadius.button),
            ),
          ),
        );
      }
    } finally {
      ref.read(storeUpdateLoadingProvider.notifier).state = false;
    }
  }
  
  // Update operational settings in database
  Future<void> _updateOperationalSettings(
    String storeId,
    int? huddleTime,
    int? paymentTime,
    int? allowedDistance,
  ) async {
    try {
      ref.read(storeUpdateLoadingProvider.notifier).state = true;
      
      final storeService = ref.read(storeServiceProvider);
      final success = await storeService.updateStore(
        storeId: storeId,
        huddleTime: huddleTime,
        paymentTime: paymentTime,
        allowedDistance: allowedDistance,
      );
      
      if (success) {
        // Refresh store details
        ref.invalidate(storeDetailsProvider);
        
        // Show success message
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Operational settings updated successfully'),
              backgroundColor: TossColors.success,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(TossBorderRadius.button),
              ),
            ),
          );
        }
      } else {
        throw Exception('Failed to update operational settings');
      }
    } catch (e) {
      // Show error message
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to update settings: ${e.toString()}'),
            backgroundColor: TossColors.error,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(TossBorderRadius.button),
            ),
          ),
        );
      }
    } finally {
      ref.read(storeUpdateLoadingProvider.notifier).state = false;
    }
  }
  
  // Get location subtitle for the store
  String _getLocationSubtitle(Map<String, dynamic> store) {
    if (store['store_location'] != null) {
      // Parse location data if it exists
      // Format: POINT(longitude latitude) or similar PostGIS format
      return 'Location set - Tap to update';
    }
    return 'Tap to set store location';
  }
  
  // Show location setting bottom sheet
  void _showLocationSettingSheet(Map<String, dynamic> store) async {
    
    // Show options for setting store location
    TossBottomSheet.show(
      context: context,
      title: 'Set Store Location',
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Info message
          Container(
            padding: const EdgeInsets.all(TossSpacing.space3),
            decoration: BoxDecoration(
              color: TossColors.infoLight,
              borderRadius: BorderRadius.circular(TossBorderRadius.md),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  FontAwesomeIcons.circleInfo,
                  color: TossColors.info,
                  size: TossSpacing.iconSM,
                ),
                const SizedBox(width: TossSpacing.space2),
                Expanded(
                  child: Text(
                    'Choose how to set the store location for employee check-in validation.',
                    style: TossTextStyles.caption.copyWith(
                      color: TossColors.gray700,
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: TossSpacing.space4),
          
          // Option 1: Use Current Location
          _buildLocationOption(
            icon: FontAwesomeIcons.locationCrosshairs,
            title: 'Use Current Location',
            subtitle: 'Use your current GPS location',
            onTap: () {
              Navigator.pop(context);
              _captureCurrentLocation(store);
            },
          ),
          
          const SizedBox(height: TossSpacing.space3),
          
          // Option 2: Enter Manually
          _buildLocationOption(
            icon: FontAwesomeIcons.mapLocationDot,
            title: 'Enter Coordinates',
            subtitle: 'Manually enter latitude and longitude',
            onTap: () {
              Navigator.pop(context);
              _showManualLocationEntry(store);
            },
          ),
          
          const SizedBox(height: TossSpacing.space3),
          
          // Option 3: Use Mock Location (for testing)
          _buildLocationOption(
            icon: FontAwesomeIcons.vialCircleCheck,
            title: 'Use Test Location',
            subtitle: 'Use Apple Park coordinates for testing',
            onTap: () {
              Navigator.pop(context);
              _showLocationConfirmation(store, 37.334606, -122.009102, 5.0);
            },
          ),
        ],
      ),
    );
  }
  
  // Build location option widget
  Widget _buildLocationOption({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(TossBorderRadius.lg),
        splashColor: TossColors.primary.withValues(alpha: 0.1),
        highlightColor: TossColors.primary.withValues(alpha: 0.05),
        child: Ink(
          padding: const EdgeInsets.all(TossSpacing.space4),
          decoration: BoxDecoration(
            color: TossColors.gray50,
            borderRadius: BorderRadius.circular(TossBorderRadius.lg),
            border: Border.all(color: TossColors.gray200),
          ),
          child: Row(
            children: [
              Container(
                width: TossSpacing.iconXL,
                height: TossSpacing.iconXL,
                decoration: BoxDecoration(
                  color: TossColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(TossBorderRadius.md),
                ),
                child: Icon(
                  icon,
                  color: TossColors.primary,
                  size: TossSpacing.iconMD,
                ),
              ),
              const SizedBox(width: TossSpacing.space3),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TossTextStyles.body.copyWith(
                        color: TossColors.gray900,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      subtitle,
                      style: TossTextStyles.caption.copyWith(
                        color: TossColors.gray600,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                FontAwesomeIcons.chevronRight,
                color: TossColors.gray400,
                size: TossSpacing.iconSM,
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  // Show manual location entry dialog
  void _showManualLocationEntry(Map<String, dynamic> store) {
    final latController = TextEditingController();
    final lngController = TextEditingController();
    
    TossBottomSheet.show(
      context: context,
      title: 'Enter Coordinates',
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Latitude input
          TossTextField(
            label: 'Latitude',
            controller: latController,
            hintText: 'e.g., 37.334606',
            keyboardType: TextInputType.numberWithOptions(decimal: true),
          ),
          
          const SizedBox(height: TossSpacing.space4),
          
          // Longitude input
          TossTextField(
            label: 'Longitude',
            controller: lngController,
            hintText: 'e.g., -122.009102',
            keyboardType: TextInputType.numberWithOptions(decimal: true),
          ),
          
          const SizedBox(height: TossSpacing.space4),
          
          // Info message
          Container(
            padding: const EdgeInsets.all(TossSpacing.space3),
            decoration: BoxDecoration(
              color: TossColors.infoLight,
              borderRadius: BorderRadius.circular(TossBorderRadius.md),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  FontAwesomeIcons.circleInfo,
                  color: TossColors.info,
                  size: TossSpacing.iconSM,
                ),
                const SizedBox(width: TossSpacing.space2),
                Expanded(
                  child: Text(
                    'Enter the exact GPS coordinates of your store location.',
                    style: TossTextStyles.caption.copyWith(
                      color: TossColors.gray700,
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: TossSpacing.space5),
          
          // Action buttons
          Row(
            children: [
              Expanded(
                child: TossSecondaryButton(
                  text: 'Cancel',
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),
              const SizedBox(width: TossSpacing.space3),
              Expanded(
                child: TossPrimaryButton(
                  text: 'Set Location',
                  onPressed: () {
                    final lat = double.tryParse(latController.text);
                    final lng = double.tryParse(lngController.text);
                    
                    if (lat == null || lng == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Please enter valid coordinates'),
                          backgroundColor: TossColors.error,
                        ),
                      );
                      return;
                    }
                    
                    if (lat < -90 || lat > 90 || lng < -180 || lng > 180) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Coordinates are out of valid range'),
                          backgroundColor: TossColors.error,
                        ),
                      );
                      return;
                    }
                    
                    Navigator.pop(context);
                    _showLocationConfirmation(store, lat, lng, 0.0);
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
  
  // Separate method for location capture (with permission)
  Future<void> _captureCurrentLocation(Map<String, dynamic> store) async {
    
    try {
      // Check location permission
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          _showLocationError('Location permission denied', store);
          return;
        }
      }
      
      if (permission == LocationPermission.deniedForever) {
        _showLocationError('Location permission permanently denied', store);
        return;
      }
      
      // Check if location services are enabled
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        _showLocationError('Location services are disabled', store);
        return;
      }
      
      // Show loading while getting location
      if (mounted) {
        showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Center(
            child: Container(
              padding: const EdgeInsets.all(TossSpacing.space5),
              decoration: BoxDecoration(
                color: TossColors.white,
                borderRadius: BorderRadius.circular(TossBorderRadius.lg),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(color: TossColors.primary),
                  const SizedBox(height: TossSpacing.space3),
                  Text(
                    'Getting current location...',
                    style: TossTextStyles.body.copyWith(
                      color: TossColors.gray700,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );
      }
      
      // Get current position with timeout
      final Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: Duration(seconds: 15),
      );
      
      // Close loading dialog
      if (mounted) {
        Navigator.of(context).pop();
      }
      
      // Show confirmation bottom sheet
      if (mounted) {
        _showLocationConfirmation(store, position.latitude, position.longitude, position.accuracy);
      }
    } catch (e) {
      _showLocationError('Failed to get location: ${e.toString()}', store);
    }
  }
  
  // Show location error with alternatives
  void _showLocationError(String message, Map<String, dynamic> store) {
    // Close loading dialog if still open
    if (mounted) {
      try {
        Navigator.of(context, rootNavigator: true).pop();
      } catch (e) {
        // Dialog might not be open
      }
    }
    
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: TossColors.error,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(TossBorderRadius.button),
          ),
          action: SnackBarAction(
            label: 'Use Test Location',
            textColor: TossColors.white,
            onPressed: () {
              // Use a mock location for testing (Apple Park, Cupertino)
              _showLocationConfirmation(store, 37.334606, -122.009102, 5.0);
            },
          ),
        ),
      );
    }
  }
  
  // Open maps with coordinates
  Future<void> _openMaps(double latitude, double longitude) async {
    // iOS: Apple Maps, Android: Google Maps
    final String appleUrl = 'https://maps.apple.com/?q=$latitude,$longitude';
    final String googleUrl = 'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';
    
    try {
      if (Theme.of(context).platform == TargetPlatform.iOS) {
        final Uri uri = Uri.parse(appleUrl);
        if (await canLaunchUrl(uri)) {
          await launchUrl(uri);
        } else {
          // Fallback to Google Maps on web
          final Uri fallbackUri = Uri.parse(googleUrl);
          await launchUrl(fallbackUri);
        }
      } else {
        final Uri uri = Uri.parse(googleUrl);
        if (await canLaunchUrl(uri)) {
          await launchUrl(uri);
        } else {
          // Fallback to Apple Maps
          final Uri fallbackUri = Uri.parse(appleUrl);
          await launchUrl(fallbackUri);
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Could not open maps app'),
            backgroundColor: TossColors.error,
          ),
        );
      }
    }
  }
  
  // Show location confirmation with coordinates
  void _showLocationConfirmation(Map<String, dynamic> store, double latitude, double longitude, double accuracy) {
    
    if (mounted) {
      TossBottomSheet.show(
        context: context,
        title: 'Set Store Location',
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            
            // Location Preview Card
            Container(
              padding: const EdgeInsets.all(TossSpacing.space4),
              decoration: BoxDecoration(
                color: TossColors.gray50,
                borderRadius: BorderRadius.circular(TossBorderRadius.lg),
                border: Border.all(
                  color: TossColors.gray200,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        FontAwesomeIcons.mapLocationDot,
                        color: TossColors.primary,
                        size: TossSpacing.iconMD,
                      ),
                      const SizedBox(width: TossSpacing.space3),
                      Text(
                        'Location Details',
                        style: TossTextStyles.bodyLarge.copyWith(
                          color: TossColors.gray900,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: TossSpacing.space3),
                  _buildLocationDetailRow('Latitude', latitude.toStringAsFixed(6)),
                  const SizedBox(height: TossSpacing.space2),
                  _buildLocationDetailRow('Longitude', longitude.toStringAsFixed(6)),
                  const SizedBox(height: TossSpacing.space2),
                  _buildLocationDetailRow('Accuracy', accuracy > 0 ? '${accuracy.toStringAsFixed(0)} meters' : 'Manual entry'),
                ],
              ),
            ),
            
            const SizedBox(height: TossSpacing.space4),
            
            // View on Maps Button
            Center(
              child: TossSecondaryButton(
                text: 'View on Maps',
                leadingIcon: Icon(
                  FontAwesomeIcons.mapLocationDot,
                  size: TossSpacing.iconSM,
                ),
                onPressed: () => _openMaps(latitude, longitude),
              ),
            ),
            
            const SizedBox(height: TossSpacing.space4),
            
            // Info message
            Container(
              padding: const EdgeInsets.all(TossSpacing.space3),
              decoration: BoxDecoration(
                color: TossColors.infoLight,
                borderRadius: BorderRadius.circular(TossBorderRadius.md),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    FontAwesomeIcons.circleInfo,
                    color: TossColors.info,
                    size: TossSpacing.iconSM,
                  ),
                  const SizedBox(width: TossSpacing.space2),
                  Expanded(
                    child: Text(
                      'This location will be used for employee check-in/out validation. Employees must be within the allowed distance to check in.',
                      style: TossTextStyles.caption.copyWith(
                        color: TossColors.gray700,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: TossSpacing.space5),
            
            // Action Buttons
            Row(
              children: [
                Expanded(
                  child: TossSecondaryButton(
                    text: 'Cancel',
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
                const SizedBox(width: TossSpacing.space3),
                Expanded(
                  child: TossPrimaryButton(
                    text: 'Set Location',
                    onPressed: () async {
                      Navigator.pop(context);
                      await _updateStoreLocation(
                        store['store_id'],
                        latitude,
                        longitude,
                      );
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    }
  }
  
  // Build location detail row
  Widget _buildLocationDetailRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TossTextStyles.caption.copyWith(
            color: TossColors.gray600,
          ),
        ),
        Text(
          value,
          style: TossTextStyles.body.copyWith(
            color: TossColors.gray900,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
  
  // Update store location in database
  Future<void> _updateStoreLocation(
    String storeId,
    double latitude,
    double longitude,
  ) async {
    try {
      ref.read(storeUpdateLoadingProvider.notifier).state = true;
      
      final supabase = Supabase.instance.client;
      
      // Call the RPC function to update store location
      await supabase.rpc('update_store_location', params: {
        'p_store_id': storeId,
        'p_store_lat': latitude,
        'p_store_lng': longitude,
      });
      
      // Refresh store details
      ref.invalidate(storeDetailsProvider);
      
      // Show success message
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Store location updated successfully'),
            backgroundColor: TossColors.success,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(TossBorderRadius.button),
            ),
          ),
        );
      }
    } catch (e) {
      // Show error message
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to update location: ${e.toString()}'),
            backgroundColor: TossColors.error,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(TossBorderRadius.button),
            ),
          ),
        );
      }
    } finally {
      ref.read(storeUpdateLoadingProvider.notifier).state = false;
    }
  }
}