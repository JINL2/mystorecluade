import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../../app/providers/app_state_provider.dart';
import '../../../../core/utils/location_utils.dart';
import '../../../../shared/themes/toss_colors.dart';
import '../../../../shared/themes/toss_spacing.dart';
import '../../../../shared/themes/toss_text_styles.dart';
import '../../domain/entities/store_shift.dart';
import '../providers/store_shift_providers.dart';
import '../widgets/business_hours_section.dart';
import '../widgets/qr_code_section.dart';
import '../widgets/shift_list_item.dart';
import '../widgets/store_config_section.dart';
import '../widgets/store_info_card.dart';
import '../widgets/store_selector_widget.dart';
import '../widgets/schedule/schedule_tab.dart';
import 'store_shift_page_dialogs.dart';
import 'package:myfinance_improved/shared/widgets/index.dart';

/// Store Shift Page
///
/// Main page for managing store shifts and settings.
/// Migrated from lib_old following Clean Architecture.
class StoreShiftPage extends ConsumerStatefulWidget {
  const StoreShiftPage({super.key});

  @override
  ConsumerState<StoreShiftPage> createState() => _StoreShiftPageState();
}

class _StoreShiftPageState extends ConsumerState<StoreShiftPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  // Show Edit Shift Bottom Sheet
  void _showEditShiftBottomSheet(BuildContext context, StoreShift shift) {
    final appState = ref.read(appStateProvider);
    showEditShiftDialog(context, ref, shift, appState.storeChoosen);
  }

  // Show Delete Confirmation Dialog
  void _showDeleteConfirmationDialog(BuildContext context, StoreShift shift) {
    showDeleteShiftDialog(context, ref, shift);
  }

  // Show Add Shift Bottom Sheet
  void _showAddShiftBottomSheet(BuildContext context) {
    final appState = ref.read(appStateProvider);
    showAddShiftDialog(context, ref, appState.storeChoosen);
  }

  // Build Shift Settings Tab
  Widget _buildShiftSettingsTab() {
    final shiftsAsync = ref.watch(storeShiftsProvider);
    final appState = ref.watch(appStateProvider);

    return RefreshIndicator(
      onRefresh: () async {
        ref.invalidate(storeShiftsProvider);
      },
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(TossSpacing.space4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Store Selector
            const StoreSelectorWidget(),
            const SizedBox(height: TossSpacing.space4),

            // Shifts List
            if (appState.storeChoosen.isEmpty)
              const TossEmptyView(
                icon: Icon(
                  LucideIcons.store,
                  size: 64,
                  color: TossColors.gray400,
                ),
                title: 'Please select a store first',
              )
            else
              shiftsAsync.when(
                data: (shifts) {
                  if (shifts.isEmpty) {
                    return Column(
                      children: [
                        const TossEmptyView(
                          icon: Icon(
                            LucideIcons.clock,
                            size: 64,
                            color: TossColors.gray400,
                          ),
                          title: 'No shifts configured',
                          description: 'Add your first shift to get started',
                        ),
                        const SizedBox(height: TossSpacing.space4),
                        TossButton.primary(
                          onPressed: () {
                            _showAddShiftBottomSheet(context);
                          },
                          leadingIcon: const Icon(LucideIcons.plus, size: 20, color: TossColors.white),
                          text: 'Add Shift',
                        ),
                      ],
                    );
                  }

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header with Add Button
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Shift Management',
                            style: TossTextStyles.bodyLarge.copyWith(
                              color: TossColors.gray900,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              _showAddShiftBottomSheet(context);
                            },
                            icon: const Icon(
                              LucideIcons.plus,
                              color: TossColors.primary,
                              size: TossSpacing.iconSM,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: TossSpacing.space3),

                      // Shifts List
                      ...shifts.map(
                        (shift) => Padding(
                          padding:
                              const EdgeInsets.only(bottom: TossSpacing.space3),
                          child: ShiftListItem(
                            shift: shift,
                            onEdit: () {
                              _showEditShiftBottomSheet(context, shift);
                            },
                            onDelete: () {
                              _showDeleteConfirmationDialog(context, shift);
                            },
                          ),
                        ),
                      ),
                    ],
                  );
                },
                loading: () => const TossLoadingView(
                  message: 'Loading shifts...',
                ),
                error: (error, stack) => TossEmptyView(
                  icon: const Icon(
                    LucideIcons.alertCircle,
                    size: 64,
                    color: TossColors.error,
                  ),
                  title: 'Error loading shifts',
                  description: error.toString(),
                ),
              ),
          ],
        ),
      ),
    );
  }

  // Build Store Settings Tab
  Widget _buildStoreSettingsTab() {
    final appState = ref.watch(appStateProvider);
    final storeDetailsAsync = ref.watch(storeDetailsProvider);

    return RefreshIndicator(
      onRefresh: () async {
        ref.invalidate(storeDetailsProvider);
      },
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(TossSpacing.space4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Store Selector
            const StoreSelectorWidget(),
            const SizedBox(height: TossSpacing.space4),

            // Store Details
            if (appState.storeChoosen.isEmpty)
              const TossEmptyView(
                icon: Icon(
                  LucideIcons.store,
                  size: 64,
                  color: TossColors.gray400,
                ),
                title: 'Please select a store first',
              )
            else
              storeDetailsAsync.when(
                data: (store) {
                  if (store == null) {
                    return const TossEmptyView(
                      icon: Icon(
                        LucideIcons.store,
                        size: 64,
                        color: TossColors.gray400,
                      ),
                      title: 'Store not found',
                    );
                  }

                  return Column(
                    children: [
                      // Store Info Card
                      StoreInfoCard(store: store),
                      const SizedBox(height: TossSpacing.space4),

                      // Business Hours Section
                      BusinessHoursSection(
                        storeId: appState.storeChoosen,
                      ),
                      const SizedBox(height: TossSpacing.space4),

                      // Store Configuration
                      StoreConfigSection(
                        store: store,
                        onEditSettings: () {
                          _showEditOperationalSettingsSheet(context, store);
                        },
                        onEditLocation: () {
                          _showSetStoreLocationDialog(context, store);
                        },
                      ),
                      const SizedBox(height: TossSpacing.space4),

                      // QR Code Section
                      QRCodeSection(store: store),
                    ],
                  );
                },
                loading: () => const TossLoadingView(
                  message: 'Loading store details...',
                ),
                error: (error, stack) => TossEmptyView(
                  icon: const Icon(
                    LucideIcons.alertCircle,
                    size: 64,
                    color: TossColors.error,
                  ),
                  title: 'Error loading store',
                  description: error.toString(),
                ),
              ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return TossScaffold(
      backgroundColor: TossColors.gray100,
      appBar: const TossAppBar(
        title: 'Staff & Store Settings',
        backgroundColor: TossColors.gray100,
      ),
      body: Column(
        children: [
          // Tab Bar - Shift (store-level), Schedule (company-level), Store (store-level)
          TossTabBar(
            controller: _tabController,
            tabs: const ['Shift', 'Schedule', 'Store'],
          ),

          // Tab Views
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildShiftSettingsTab(),
                const ScheduleTab(), // Company-level work schedule templates
                _buildStoreSettingsTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Show Edit Operational Settings Bottom Sheet
  void _showEditOperationalSettingsSheet(
    BuildContext context,
    Map<String, dynamic> store,
  ) {
    showOperationalSettingsDialog(context, store);
  }

  /// Show Store Location Confirmation Dialog
  Future<void> _showSetStoreLocationDialog(
    BuildContext context,
    Map<String, dynamic> store,
  ) async {
    final confirmed = await TossConfirmCancelDialog.show(
      context: context,
      title: 'Set Store Location',
      message:
          'Do you want to set the store location to your current position?',
      confirmButtonText: 'Set Location',
      cancelButtonText: 'Cancel',
    );

    if (confirmed == true && mounted) {
      await _updateStoreLocation(store);
    }
  }

  /// Update store location using current GPS position
  Future<void> _updateStoreLocation(Map<String, dynamic> store) async {
    if (!mounted) return;

    final currentContext = context;

    // Show loading indicator
    showDialog<void>(
      context: currentContext,
      barrierDismissible: false,
      builder: (dialogContext) => const TossLoadingView(),
    );

    try {
      // Get current location
      final position = await LocationUtils.getCurrentLocation();

      if (position == null) {
        if (mounted) {
          Navigator.pop(currentContext); // Close loading
          TossToast.error(
            currentContext,
            'Unable to get current location. Please check location permissions.',
          );
        }
        return;
      }

      final storeId = store['store_id'] as String?;
      if (storeId == null) {
        if (mounted) {
          Navigator.pop(currentContext); // Close loading
          TossToast.error(currentContext, 'Store ID not found');
        }
        return;
      }

      // Use provider to update store location (Clean Architecture compliant)
      await ref.read(updateStoreLocationProvider)(
        storeId: storeId,
        latitude: position.latitude,
        longitude: position.longitude,
        address: '', // Address will be resolved by RPC if needed
      );

      if (mounted) {
        Navigator.pop(currentContext); // Close loading

        // Refresh store details
        ref.invalidate(storeDetailsProvider);

        // Show success dialog
        await showDialog<void>(
          context: currentContext,
          barrierDismissible: false,
          builder: (dialogContext) => TossDialog.success(
            title: 'Location Updated',
            message: 'Store location has been updated successfully.',
            primaryButtonText: 'OK',
            onPrimaryPressed: () => Navigator.of(dialogContext).pop(),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        Navigator.pop(currentContext); // Close loading

        // Show error dialog
        await showDialog<void>(
          context: currentContext,
          barrierDismissible: true,
          builder: (dialogContext) => TossDialog.error(
            title: 'Update Failed',
            message: 'Failed to update location: $e',
            primaryButtonText: 'OK',
            onPrimaryPressed: () => Navigator.of(dialogContext).pop(),
          ),
        );
      }
    }
  }
}
