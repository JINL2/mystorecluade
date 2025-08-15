import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'providers/store_shift_providers.dart';
import '../../providers/app_state_provider.dart';
import '../../../core/themes/toss_colors.dart';
import '../../../core/themes/toss_text_styles.dart';
import '../../../core/themes/toss_spacing.dart';
import '../../../core/themes/toss_border_radius.dart';

class StoreShiftPage extends ConsumerStatefulWidget {
  const StoreShiftPage({super.key});

  @override
  ConsumerState<StoreShiftPage> createState() => _StoreShiftPageState();
}

class _StoreShiftPageState extends ConsumerState<StoreShiftPage> with WidgetsBindingObserver {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

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
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final userCompaniesAsync = ref.watch(userCompaniesProvider);

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: TossColors.background,
      body: userCompaniesAsync.when(
        data: (userData) => SafeArea(
          child: Column(
            children: [
              // Header - Similar to Financial Statements
              Container(
                height: 56,
                color: TossColors.background,
                padding: const EdgeInsets.symmetric(horizontal: TossSpacing.space4),
                child: Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.arrow_back_ios_rounded,
                        color: TossColors.gray700,
                        size: 22,
                      ),
                      onPressed: () => context.pop(),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                    const Spacer(),
                    Text(
                      'Store Shift',
                      style: TossTextStyles.h3.copyWith(
                        color: TossColors.gray900,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const Spacer(),
                  ],
                ),
              ),
              
              // Divider
              Container(
                height: 1,
                color: TossColors.gray100,
              ),
              
              // Content Area
              Expanded(
                child: Stack(
                  children: [
                    RefreshIndicator(
                      onRefresh: () => _handleRefresh(ref),
                      color: TossColors.primary,
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.all(TossSpacing.space4),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Store Selector
                            _buildStoreSelector(userData),
                            const SizedBox(height: TossSpacing.space6),
                            
                            // Add Shift Button Section
                            _buildAddShiftSection(),
                            const SizedBox(height: TossSpacing.space6),
                            
                            // Existing Shifts Section (Placeholder)
                            _buildExistingShiftsSection(),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
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
              const Text('Something went wrong'),
              const SizedBox(height: 8),
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
  
  // Store Selector Widget - Using the same data structure as homepage
  Widget _buildStoreSelector(dynamic userData) {
    final appState = ref.watch(appStateProvider);
    final selectedCompany = ref.watch(selectedCompanyProvider);
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
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: const EdgeInsets.all(TossSpacing.space4),
            decoration: BoxDecoration(
              color: TossColors.background,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: selectedStore != null ? TossColors.primary.withOpacity(0.3) : TossColors.gray200,
                width: selectedStore != null ? 1.5 : 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: selectedStore != null
                      ? TossColors.primary.withOpacity(0.1) 
                      : TossColors.gray50,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    Icons.store_outlined,
                    size: 20,
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
                        style: TossTextStyles.caption.copyWith(
                          color: TossColors.gray500,
                          fontSize: 11,
                        ),
                      ),
                      const SizedBox(height: 2),
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
                  Icons.chevron_right,
                  color: selectedStore != null 
                    ? TossColors.primary 
                    : TossColors.gray400,
                  size: 24,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
  
  // Show Store Selector Modal - Using the same data structure as homepage
  void _showStoreSelector() {
    final appState = ref.read(appStateProvider);
    final selectedCompany = ref.read(selectedCompanyProvider);
    final stores = selectedCompany?['stores'] as List<dynamic>? ?? [];
    
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle bar
            Container(
              margin: const EdgeInsets.only(top: TossSpacing.space3),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: TossColors.gray300,
                borderRadius: BorderRadius.circular(100),
              ),
            ),
            // Title
            Padding(
              padding: const EdgeInsets.all(TossSpacing.space5),
              child: Row(
                children: [
                  Text(
                    'Select Store',
                    style: TossTextStyles.h3.copyWith(
                      color: TossColors.gray900,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
            // Store list without Headquarters
            Container(
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.5,
              ),
              child: ListView.builder(
                shrinkWrap: true,
                padding: EdgeInsets.zero,
                itemCount: stores.length,
                itemBuilder: (context, index) {
                  final store = stores[index];
                  final isSelected = appState.storeChoosen == store['store_id'];
                  
                  return InkWell(
                    onTap: () async {
                      // Update app state with selected store
                      await ref.read(appStateProvider.notifier).setStoreChoosen(store['store_id'] ?? '');
                      Navigator.pop(context);
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: TossSpacing.space5,
                        vertical: TossSpacing.space4,
                      ),
                      decoration: BoxDecoration(
                        color: isSelected ? TossColors.primary.withOpacity(0.05) : Colors.transparent,
                        border: Border(
                          bottom: BorderSide(
                            color: TossColors.gray100,
                            width: index == stores.length - 1 ? 0 : 1, // Last item has no border
                          ),
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: isSelected 
                                ? TossColors.primary.withOpacity(0.1) 
                                : TossColors.gray50,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Icon(
                              Icons.store_outlined,
                              size: 20,
                              color: isSelected ? TossColors.primary : TossColors.gray600,
                            ),
                          ),
                          const SizedBox(width: TossSpacing.space3),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  store['store_name'] ?? '',
                                  style: TossTextStyles.body.copyWith(
                                    color: TossColors.gray900,
                                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                                  ),
                                ),
                                if (store['store_code'] != null) ...[
                                  const SizedBox(height: 2),
                                  Text(
                                    'Code: ${store['store_code']}',
                                    style: TossTextStyles.caption.copyWith(
                                      color: TossColors.gray500,
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                          if (isSelected)
                            Icon(
                              Icons.check_circle,
                              color: TossColors.primary,
                              size: 24,
                            ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            // Bottom padding for safe area
            SizedBox(height: MediaQuery.of(context).padding.bottom + TossSpacing.space4),
          ],
        ),
      ),
    );
  }
  
  // Build Add Shift Section with + Button
  Widget _buildAddShiftSection() {
    return Container(
      decoration: BoxDecoration(
        color: TossColors.background,
        borderRadius: BorderRadius.circular(TossBorderRadius.xl),
        border: Border.all(
          color: TossColors.gray100,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
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
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        TossColors.primary,
                        TossColors.primary.withOpacity(0.8),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: TossColors.primary.withOpacity(0.3),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.add_rounded,
                    color: Colors.white,
                    size: 32,
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
                  Icons.arrow_forward_ios_rounded,
                  color: TossColors.gray400,
                  size: 18,
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
      return Center(
        child: Container(
          padding: const EdgeInsets.all(TossSpacing.space6),
          decoration: BoxDecoration(
            color: TossColors.gray50,
            borderRadius: BorderRadius.circular(TossBorderRadius.lg),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.store_outlined,
                size: 48,
                color: TossColors.gray400,
              ),
              const SizedBox(height: TossSpacing.space3),
              Text(
                'No Store Selected',
                style: TossTextStyles.bodyLarge.copyWith(
                  color: TossColors.gray700,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: TossSpacing.space2),
              Text(
                'Please select a store to manage shifts.',
                style: TossTextStyles.bodySmall.copyWith(
                  color: TossColors.gray500,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }
    
    // Fetch real shift data from database
    final shiftsAsync = ref.watch(storeShiftsProvider);
    
    return shiftsAsync.when(
      data: (shifts) {
        if (shifts.isEmpty) {
          return Center(
            child: Container(
              padding: const EdgeInsets.all(TossSpacing.space6),
              decoration: BoxDecoration(
                color: TossColors.gray50,
                borderRadius: BorderRadius.circular(TossBorderRadius.lg),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.schedule_outlined,
                    size: 48,
                    color: TossColors.gray400,
                  ),
                  const SizedBox(height: TossSpacing.space3),
                  Text(
                    'No Shifts Yet',
                    style: TossTextStyles.bodyLarge.copyWith(
                      color: TossColors.gray700,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: TossSpacing.space2),
                  Text(
                    'Create your first shift for this store.',
                    style: TossTextStyles.bodySmall.copyWith(
                      color: TossColors.gray500,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
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
                    style: TossTextStyles.h3.copyWith(
                      color: TossColors.gray900,
                      fontWeight: FontWeight.w700,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(width: TossSpacing.space2),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: TossSpacing.space2,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: TossColors.primary.withOpacity(0.1),
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
          color: TossColors.error.withOpacity(0.1),
          borderRadius: BorderRadius.circular(TossBorderRadius.lg),
        ),
        child: Column(
          children: [
            Icon(
              Icons.error_outline,
              size: 32,
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
    
    // Determine icon and color based on start time
    IconData icon = Icons.schedule_outlined;
    Color color = TossColors.info;
    
    // Parse start hour to determine icon and color
    if (startTime.isNotEmpty) {
      try {
        final hour = int.parse(startTime.split(':')[0]);
        if (hour >= 5 && hour < 12) {
          icon = Icons.wb_sunny_outlined;
          color = TossColors.success;
        } else if (hour >= 12 && hour < 17) {
          icon = Icons.wb_twilight_outlined;
          color = TossColors.info;
        } else if (hour >= 17 && hour < 22) {
          icon = Icons.nightlight_outlined;
          color = TossColors.warning;
        } else {
          icon = Icons.nights_stay_outlined;
          color = TossColors.gray600;
        }
      } catch (e) {
      }
    }
    
    return Container(
      decoration: BoxDecoration(
        color: TossColors.background,
        borderRadius: BorderRadius.circular(TossBorderRadius.lg),
        border: Border.all(
          color: TossColors.gray100,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            // Edit shift functionality - pass shiftId
          },
          borderRadius: BorderRadius.circular(TossBorderRadius.lg),
          child: Padding(
            padding: const EdgeInsets.all(TossSpacing.space4),
            child: Row(
              children: [
                // Icon Container
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    icon,
                    color: color,
                    size: 24,
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
                      const SizedBox(height: 2),
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
                      icon: Icon(
                        Icons.edit_outlined,
                        color: TossColors.gray500,
                        size: 20,
                      ),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(
                        minWidth: 32,
                        minHeight: 32,
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        // Delete functionality with shiftId
                        _showDeleteConfirmation(shiftId, shiftName);
                      },
                      icon: Icon(
                        Icons.delete_outline,
                        color: TossColors.error,
                        size: 20,
                      ),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(
                        minWidth: 32,
                        minHeight: 32,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  
  // Individual Shift Card Widget (for mock data - kept for reference)
  Widget _buildShiftCard({
    required String shiftName,
    required String time,
    required Color color,
    required IconData icon,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: TossColors.background,
        borderRadius: BorderRadius.circular(TossBorderRadius.lg),
        border: Border.all(
          color: TossColors.gray100,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            // Edit shift functionality
          },
          borderRadius: BorderRadius.circular(TossBorderRadius.lg),
          child: Padding(
            padding: const EdgeInsets.all(TossSpacing.space4),
            child: Row(
              children: [
                // Icon Container
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    icon,
                    color: color,
                    size: 24,
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
                      const SizedBox(height: 2),
                      Text(
                        time,
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
                        // Edit functionality
                      },
                      icon: Icon(
                        Icons.edit_outlined,
                        color: TossColors.gray500,
                        size: 20,
                      ),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(
                        minWidth: 32,
                        minHeight: 32,
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        // Delete functionality
                      },
                      icon: Icon(
                        Icons.delete_outline,
                        color: TossColors.error,
                        size: 20,
                      ),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(
                        minWidth: 32,
                        minHeight: 32,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  
  // Show Create Shift Bottom Sheet
  void _showCreateShiftBottomSheet() {
    // State variables for the bottom sheet
    String shiftName = '';
    String? selectedStartTime;
    String? selectedEndTime;
    
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => Container(
          height: MediaQuery.of(context).size.height * 0.85,
          decoration: const BoxDecoration(
            color: Colors.white,
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
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: TossColors.gray300,
                  borderRadius: BorderRadius.circular(100),
                ),
              ),
              
              // Header
              Container(
                padding: const EdgeInsets.all(TossSpacing.space5),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: TossColors.gray100,
                      width: 1,
                    ),
                  ),
                ),
                child: Row(
                  children: [
                    // Cancel button
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text(
                        'Cancel',
                        style: TossTextStyles.body.copyWith(
                          color: TossColors.gray600,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    const Spacer(),
                    Text(
                      'Create New Shift',
                      style: TossTextStyles.h3.copyWith(
                        color: TossColors.gray900,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const Spacer(),
                    // Create button
                    TextButton(
                      onPressed: (shiftName.isEmpty || selectedStartTime == null || selectedEndTime == null) ? null : () {
                        // Show confirmation dialog
                        _showCreateConfirmation(
                          context: context,
                          shiftName: shiftName,
                          startTime: selectedStartTime!,
                          endTime: selectedEndTime!,
                        );
                      },
                      child: Text(
                        'Create',
                        style: TossTextStyles.body.copyWith(
                          color: (shiftName.isEmpty || selectedStartTime == null || selectedEndTime == null) 
                            ? TossColors.gray400 
                            : TossColors.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
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
                      Text(
                        'Shift Name',
                        style: TossTextStyles.body.copyWith(
                          color: TossColors.gray700,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: TossSpacing.space3),
                      Container(
                        decoration: BoxDecoration(
                          color: TossColors.gray50,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: shiftName.isNotEmpty 
                              ? TossColors.primary.withOpacity(0.3)
                              : TossColors.gray200,
                            width: shiftName.isNotEmpty ? 1.5 : 1,
                          ),
                        ),
                        child: TextField(
                          onChanged: (value) {
                            setState(() {
                              shiftName = value;
                            });
                          },
                          style: TossTextStyles.bodyLarge.copyWith(
                            color: TossColors.gray900,
                          ),
                          decoration: InputDecoration(
                            hintText: 'e.g., Morning Shift, Night Shift',
                            hintStyle: TossTextStyles.body.copyWith(
                              color: TossColors.gray400,
                            ),
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.all(TossSpacing.space4),
                            prefixIcon: Icon(
                              Icons.badge_outlined,
                              color: shiftName.isNotEmpty 
                                ? TossColors.primary
                                : TossColors.gray400,
                              size: 20,
                            ),
                          ),
                        ),
                      ),
                      
                      const SizedBox(height: TossSpacing.space6),
                      
                      // Time Settings Section
                      Container(
                        padding: const EdgeInsets.all(TossSpacing.space4),
                        decoration: BoxDecoration(
                          color: TossColors.primary.withOpacity(0.03),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: TossColors.primary.withOpacity(0.1),
                            width: 1,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.schedule,
                                  color: TossColors.primary,
                                  size: 20,
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
                                InkWell(
                                  onTap: () {
                                    _showTimePickerDialog(
                                      context,
                                      selectedStartTime,
                                      (newTime) {
                                        setState(() {
                                          selectedStartTime = newTime;
                                        });
                                      },
                                    );
                                  },
                                  borderRadius: BorderRadius.circular(12),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: TossSpacing.space4,
                                      vertical: TossSpacing.space3,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                        color: selectedStartTime != null 
                                          ? TossColors.primary.withOpacity(0.3)
                                          : TossColors.gray200,
                                        width: selectedStartTime != null ? 1.5 : 1,
                                      ),
                                    ),
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.access_time,
                                          color: selectedStartTime != null 
                                            ? TossColors.primary
                                            : TossColors.gray400,
                                          size: 18,
                                        ),
                                        const SizedBox(width: TossSpacing.space3),
                                        Text(
                                          selectedStartTime ?? 'Select time',
                                          style: TossTextStyles.bodyLarge.copyWith(
                                            color: selectedStartTime != null 
                                              ? TossColors.gray900
                                              : TossColors.gray400,
                                            fontWeight: selectedStartTime != null 
                                              ? FontWeight.w600
                                              : FontWeight.w400,
                                          ),
                                        ),
                                        const Spacer(),
                                        Icon(
                                          Icons.keyboard_arrow_down,
                                          color: TossColors.gray400,
                                          size: 20,
                                        ),
                                      ],
                                    ),
                                  ),
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
                                InkWell(
                                  onTap: () {
                                    _showTimePickerDialog(
                                      context,
                                      selectedEndTime,
                                      (newTime) {
                                        setState(() {
                                          selectedEndTime = newTime;
                                        });
                                      },
                                    );
                                  },
                                  borderRadius: BorderRadius.circular(12),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: TossSpacing.space4,
                                      vertical: TossSpacing.space3,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                        color: selectedEndTime != null 
                                          ? TossColors.primary.withOpacity(0.3)
                                          : TossColors.gray200,
                                        width: selectedEndTime != null ? 1.5 : 1,
                                      ),
                                    ),
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.access_time,
                                          color: selectedEndTime != null 
                                            ? TossColors.primary
                                            : TossColors.gray400,
                                          size: 18,
                                        ),
                                        const SizedBox(width: TossSpacing.space3),
                                        Text(
                                          selectedEndTime ?? 'Select time',
                                          style: TossTextStyles.bodyLarge.copyWith(
                                            color: selectedEndTime != null 
                                              ? TossColors.gray900
                                              : TossColors.gray400,
                                            fontWeight: selectedEndTime != null 
                                              ? FontWeight.w600
                                              : FontWeight.w400,
                                          ),
                                        ),
                                        const Spacer(),
                                        Icon(
                                          Icons.keyboard_arrow_down,
                                          color: TossColors.gray400,
                                          size: 20,
                                        ),
                                      ],
                                    ),
                                  ),
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
                            color: TossColors.info.withOpacity(0.05),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: TossColors.info.withOpacity(0.2),
                              width: 1,
                            ),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.timer_outlined,
                                color: TossColors.info,
                                size: 20,
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
                                  const SizedBox(height: 2),
                                  Text(
                                    _calculateDuration(selectedStartTime!, selectedEndTime!),
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
                      
                      // Shift Preview Card
                      Container(
                        padding: const EdgeInsets.all(TossSpacing.space4),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              TossColors.primary.withOpacity(0.05),
                              TossColors.primary.withOpacity(0.02),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: TossColors.primary.withOpacity(0.2),
                            width: 1,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Preview',
                              style: TossTextStyles.caption.copyWith(
                                color: TossColors.gray600,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: TossSpacing.space3),
                            Row(
                              children: [
                                Container(
                                  width: 48,
                                  height: 48,
                                  decoration: BoxDecoration(
                                    color: TossColors.primary.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Icon(
                                    _getShiftIcon(selectedStartTime ?? ''),
                                    color: TossColors.primary,
                                    size: 24,
                                  ),
                                ),
                                const SizedBox(width: TossSpacing.space3),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        shiftName.isEmpty ? 'New Shift' : shiftName,
                                        style: TossTextStyles.body.copyWith(
                                          color: TossColors.gray900,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        (selectedStartTime != null && selectedEndTime != null)
                                          ? '$selectedStartTime - $selectedEndTime'
                                          : 'No time set',
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
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  // Helper method to get shift icon based on time
  IconData _getShiftIcon(String startTime) {
    if (startTime.isEmpty) return Icons.schedule_outlined;
    
    try {
      final hour = int.parse(startTime.split(':')[0]);
      if (hour >= 5 && hour < 12) {
        return Icons.wb_sunny_outlined;
      } else if (hour >= 12 && hour < 17) {
        return Icons.wb_twilight_outlined;
      } else if (hour >= 17 && hour < 22) {
        return Icons.nightlight_outlined;
      } else {
        return Icons.nights_stay_outlined;
      }
    } catch (e) {
      return Icons.schedule_outlined;
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
    String selectedStartTime = startTime;
    String selectedEndTime = endTime;
    
    // Create a TextEditingController for the shift name
    final shiftNameController = TextEditingController(text: existingShiftName);
    
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => Container(
          height: MediaQuery.of(context).size.height * 0.85,
          decoration: const BoxDecoration(
            color: Colors.white,
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
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: TossColors.gray300,
                  borderRadius: BorderRadius.circular(100),
                ),
              ),
              
              // Header
              Container(
                padding: const EdgeInsets.all(TossSpacing.space5),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: TossColors.gray100,
                      width: 1,
                    ),
                  ),
                ),
                child: Row(
                  children: [
                    // Close button
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: Icon(
                        Icons.close,
                        color: TossColors.gray700,
                        size: 24,
                      ),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                    const Spacer(),
                    Text(
                      'Edit Shift',
                      style: TossTextStyles.h3.copyWith(
                        color: TossColors.gray900,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const Spacer(),
                    // Save button
                    TextButton(
                      onPressed: (shiftName.isEmpty) ? null : () {
                        // Show confirmation dialog
                        _showEditConfirmation(
                          context: context,
                          shiftId: shiftId,
                          shiftName: shiftName,
                          startTime: selectedStartTime,
                          endTime: selectedEndTime,
                        );
                      },
                      child: Text(
                        'Save',
                        style: TossTextStyles.body.copyWith(
                          color: shiftName.isEmpty ? TossColors.gray400 : TossColors.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              
              // Content
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(TossSpacing.space5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Shift Preview Card
                      Container(
                        padding: const EdgeInsets.all(TossSpacing.space4),
                        decoration: BoxDecoration(
                          color: TossColors.primary.withOpacity(0.05),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: TossColors.primary.withOpacity(0.2),
                            width: 1,
                          ),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 48,
                              height: 48,
                              decoration: BoxDecoration(
                                color: TossColors.primary.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Icon(
                                _getShiftIcon(selectedStartTime),
                                color: TossColors.primary,
                                size: 24,
                              ),
                            ),
                            const SizedBox(width: TossSpacing.space3),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    shiftName.isEmpty ? 'Unnamed Shift' : shiftName,
                                    style: TossTextStyles.body.copyWith(
                                      color: TossColors.gray900,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    '$selectedStartTime - $selectedEndTime',
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
                      ),
                      
                      const SizedBox(height: TossSpacing.space6),
                      
                      // Shift Name Input Section
                      Text(
                        'Shift Name',
                        style: TossTextStyles.body.copyWith(
                          color: TossColors.gray700,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: TossSpacing.space3),
                      Container(
                        decoration: BoxDecoration(
                          color: TossColors.gray50,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: shiftName.isNotEmpty 
                              ? TossColors.primary.withOpacity(0.3)
                              : TossColors.gray200,
                            width: shiftName.isNotEmpty ? 1.5 : 1,
                          ),
                        ),
                        child: TextField(
                          controller: shiftNameController,
                          onChanged: (value) {
                            setState(() {
                              shiftName = value;
                            });
                          },
                          style: TossTextStyles.bodyLarge.copyWith(
                            color: TossColors.gray900,
                          ),
                          decoration: InputDecoration(
                            hintText: 'e.g., Morning Shift, Night Shift',
                            hintStyle: TossTextStyles.body.copyWith(
                              color: TossColors.gray400,
                            ),
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.all(TossSpacing.space4),
                            prefixIcon: Icon(
                              Icons.badge_outlined,
                              color: shiftName.isNotEmpty 
                                ? TossColors.primary
                                : TossColors.gray400,
                              size: 20,
                            ),
                          ),
                        ),
                      ),
                      
                      const SizedBox(height: TossSpacing.space5),
                      
                      // Start Time Section
                      Text(
                        'Start Time',
                        style: TossTextStyles.body.copyWith(
                          color: TossColors.gray700,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: TossSpacing.space3),
                      InkWell(
                        onTap: () {
                          // Show time picker for start time
                          _showTimePicker(
                            context,
                            selectedStartTime,
                            (newTime) {
                              setState(() {
                                selectedStartTime = newTime;
                              });
                            },
                          );
                        },
                        borderRadius: BorderRadius.circular(12),
                        child: Container(
                          padding: const EdgeInsets.all(TossSpacing.space4),
                          decoration: BoxDecoration(
                            color: TossColors.gray50,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: TossColors.gray200,
                              width: 1,
                            ),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.access_time,
                                color: TossColors.gray600,
                                size: 20,
                              ),
                              const SizedBox(width: TossSpacing.space3),
                              Text(
                                selectedStartTime,
                                style: TossTextStyles.bodyLarge.copyWith(
                                  color: TossColors.gray900,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const Spacer(),
                              Icon(
                                Icons.edit,
                                color: TossColors.gray400,
                                size: 18,
                              ),
                            ],
                          ),
                        ),
                      ),
                      
                      const SizedBox(height: TossSpacing.space5),
                      
                      // End Time Section
                      Text(
                        'End Time',
                        style: TossTextStyles.body.copyWith(
                          color: TossColors.gray700,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: TossSpacing.space3),
                      InkWell(
                        onTap: () {
                          // Show time picker for end time
                          _showTimePicker(
                            context,
                            selectedEndTime,
                            (newTime) {
                              setState(() {
                                selectedEndTime = newTime;
                              });
                            },
                          );
                        },
                        borderRadius: BorderRadius.circular(12),
                        child: Container(
                          padding: const EdgeInsets.all(TossSpacing.space4),
                          decoration: BoxDecoration(
                            color: TossColors.gray50,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: TossColors.gray200,
                              width: 1,
                            ),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.access_time,
                                color: TossColors.gray600,
                                size: 20,
                              ),
                              const SizedBox(width: TossSpacing.space3),
                              Text(
                                selectedEndTime,
                                style: TossTextStyles.bodyLarge.copyWith(
                                  color: TossColors.gray900,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const Spacer(),
                              Icon(
                                Icons.edit,
                                color: TossColors.gray400,
                                size: 18,
                              ),
                            ],
                          ),
                        ),
                      ),
                      
                      const SizedBox(height: TossSpacing.space6),
                      
                      // Duration Display
                      Container(
                        padding: const EdgeInsets.all(TossSpacing.space4),
                        decoration: BoxDecoration(
                          color: TossColors.info.withOpacity(0.05),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: TossColors.info.withOpacity(0.2),
                            width: 1,
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.timer_outlined,
                              color: TossColors.info,
                              size: 20,
                            ),
                            const SizedBox(width: TossSpacing.space3),
                            Text(
                              'Duration: ',
                              style: TossTextStyles.body.copyWith(
                                color: TossColors.gray600,
                              ),
                            ),
                            Text(
                              _calculateDuration(selectedStartTime, selectedEndTime),
                              style: TossTextStyles.body.copyWith(
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
              ),
            ],
          ),
        ),
      ),
    );
    
    // Note: The controller will be automatically garbage collected when the bottom sheet is closed
    // since it's a local variable and the TextField will properly detach from it
  }
  
  // Helper method to get shift name based on time
  String _getShiftName(String startTime) {
    if (startTime.isEmpty) return 'Shift';
    
    try {
      final hour = int.parse(startTime.split(':')[0]);
      if (hour >= 5 && hour < 12) {
        return 'Morning Shift';
      } else if (hour >= 12 && hour < 17) {
        return 'Afternoon Shift';
      } else if (hour >= 17 && hour < 22) {
        return 'Evening Shift';
      } else {
        return 'Night Shift';
      }
    } catch (e) {
      return 'Shift';
    }
  }
  
  // Calculate duration between two times
  String _calculateDuration(String startTime, String endTime) {
    try {
      final startParts = startTime.split(':');
      final endParts = endTime.split(':');
      
      final startHour = int.parse(startParts[0]);
      final startMin = int.parse(startParts[1]);
      final endHour = int.parse(endParts[0]);
      final endMin = int.parse(endParts[1]);
      
      var totalMinutes = (endHour * 60 + endMin) - (startHour * 60 + startMin);
      
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
  
  // Show time picker dialog for create shift
  void _showTimePickerDialog(BuildContext context, String? currentTime, Function(String) onTimeSelected) async {
    // Parse current time or use default
    TimeOfDay initialTime = TimeOfDay.now();
    if (currentTime != null && currentTime.isNotEmpty) {
      try {
        final parts = currentTime.split(':');
        initialTime = TimeOfDay(
          hour: int.parse(parts[0]),
          minute: int.parse(parts[1]),
        );
      } catch (e) {
        // Use default if parsing fails
      }
    }
    
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: initialTime,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: TossColors.primary,
              onPrimary: Colors.white,
              onSurface: TossColors.gray900,
            ),
            dialogBackgroundColor: Colors.white,
          ),
          child: child!,
        );
      },
    );
    
    if (picked != null) {
      final hour = picked.hour.toString().padLeft(2, '0');
      final minute = picked.minute.toString().padLeft(2, '0');
      onTimeSelected('$hour:$minute');
    }
  }
  
  // Show time picker (for edit shift - kept for compatibility)
  void _showTimePicker(BuildContext context, String currentTime, Function(String) onTimeSelected) {
    _showTimePickerDialog(context, currentTime, onTimeSelected);
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
          borderRadius: BorderRadius.circular(16),
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
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: TossColors.gray50,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.badge_outlined, size: 16, color: TossColors.gray600),
                      const SizedBox(width: 8),
                      Text(
                        shiftName,
                        style: TossTextStyles.body.copyWith(
                          color: TossColors.gray900,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.schedule, size: 16, color: TossColors.gray600),
                      const SizedBox(width: 8),
                      Text(
                        '$startTime - $endTime',
                        style: TossTextStyles.body.copyWith(
                          color: TossColors.gray700,
                        ),
                      ),
                    ],
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
              await Future.delayed(const Duration(milliseconds: 100));
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
          borderRadius: BorderRadius.circular(16),
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
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: TossColors.gray50,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.badge_outlined, size: 16, color: TossColors.gray600),
                      const SizedBox(width: 8),
                      Text(
                        shiftName,
                        style: TossTextStyles.body.copyWith(
                          color: TossColors.gray900,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.schedule, size: 16, color: TossColors.gray600),
                      const SizedBox(width: 8),
                      Text(
                        '$startTime - $endTime',
                        style: TossTextStyles.body.copyWith(
                          color: TossColors.gray700,
                        ),
                      ),
                    ],
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
      
      // Format times with seconds
      final formattedStartTime = '$startTime:00';
      final formattedEndTime = '$endTime:00';
      
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
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
        );
      }
    } catch (e) {
      
      // Show error message
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to create shift: ${e.toString()}'),
            backgroundColor: TossColors.error,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
        );
      }
    }
  }
  
  // Show delete confirmation dialog
  void _showDeleteConfirmation(String shiftId, String shiftName) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
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
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: TossColors.error.withOpacity(0.05),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: TossColors.error.withOpacity(0.2),
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.delete_outline,
                    size: 20,
                    color: TossColors.error,
                  ),
                  const SizedBox(width: 8),
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
            const SizedBox(height: 12),
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
      // Format times with seconds (HH:mm:ss)
      String formattedStartTime;
      String formattedEndTime;
      
      // Check if time already has seconds
      if (startTime.split(':').length == 3) {
        formattedStartTime = startTime;
      } else {
        formattedStartTime = '$startTime:00';
      }
      
      if (endTime.split(':').length == 3) {
        formattedEndTime = endTime;
      } else {
        formattedEndTime = '$endTime:00';
      }
      
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
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
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
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
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
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
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
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
        );
      }
    }
  }
}