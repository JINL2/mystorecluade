import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_gallery_saver_plus/image_gallery_saver_plus.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../app/providers/app_state_provider.dart';
import '../../../../core/constants/icon_mapper.dart';
import '../../../../core/utils/location_utils.dart';
import '../../../../shared/widgets/common/toss_confirm_cancel_dialog.dart';
import '../../../../shared/widgets/common/toss_success_error_dialog.dart';
import '../../../../shared/themes/toss_border_radius.dart';
import '../../../../shared/themes/toss_colors.dart';
import '../../../../shared/themes/toss_spacing.dart';
import '../../../../shared/themes/toss_text_styles.dart';
import '../../../../shared/widgets/common/toss_app_bar_1.dart';
import '../../../../shared/widgets/common/toss_empty_view.dart';
import '../../../../shared/widgets/common/toss_loading_view.dart';
import '../../../../shared/widgets/common/toss_scaffold.dart';
import '../../../../shared/widgets/toss/toss_selection_bottom_sheet.dart';
import '../../../../shared/widgets/toss/toss_tab_bar_1.dart';
import '../../domain/entities/store_shift.dart';
import '../providers/store_shift_providers.dart';
import '../widgets/shift_list_item.dart';
import '../widgets/store_config_section.dart';
import '../widgets/store_info_card.dart';
import 'store_shift_page_dialogs.dart';

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
    _tabController = TabController(length: 2, vsync: this);
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

  // Extract stores from user data
  List<dynamic> _extractStores(Map<String, dynamic> userData) {
    if (userData.isEmpty) return [];

    try {
      final companies = userData['companies'] as List<dynamic>?;
      if (companies == null || companies.isEmpty) return [];

      final firstCompany = companies[0] as Map<String, dynamic>;
      final stores = firstCompany['stores'] as List<dynamic>?;
      if (stores == null) return [];

      return stores;
    } catch (e) {
      return [];
    }
  }

  // Store Selector Widget
  Widget _buildStoreSelector(BuildContext context) {
    final appState = ref.watch(appStateProvider);

    // Get selected store name from AppState (single source of truth)
    final storeName = appState.storeName.isNotEmpty
        ? appState.storeName
        : 'Select Store';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Store',
          style: TossTextStyles.caption.copyWith(
            color: TossColors.gray600,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: TossSpacing.space2),
        InkWell(
          onTap: () async {
            // Extract stores from user data
            final stores = _extractStores(appState.user);

            // Show store selector using TossSelectionBottomSheet
            final selectedItem = await TossSelectionBottomSheet.show<TossSelectionItem>(
              context: context,
              title: 'Select Store',
              items: stores.map((store) {
                final storeMap = store as Map<String, dynamic>;
                return TossSelectionItem.fromStore(storeMap);
              }).toList(),
              selectedId: appState.storeChoosen,
              showSubtitle: false, // Hide store code subtitle
              onItemSelected: (item) {
                // Item will be returned when bottom sheet closes
              },
            );

            // Update app state if store was selected
            if (selectedItem != null && selectedItem.data != null) {
              final storeId = selectedItem.data!['store_id'] as String? ?? '';
              final storeName = selectedItem.data!['store_name'] as String? ?? '';
              ref.read(appStateProvider.notifier).selectStore(storeId, storeName: storeName);
            }
          },
          borderRadius: BorderRadius.circular(TossBorderRadius.lg),
          child: Container(
            padding: const EdgeInsets.all(TossSpacing.space4),
            decoration: BoxDecoration(
              color: TossColors.white,
              borderRadius: BorderRadius.circular(TossBorderRadius.lg),
              border: Border.all(color: TossColors.gray300),
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
                  child: const Icon(
                    LucideIcons.store,
                    color: TossColors.primary,
                    size: TossSpacing.iconSM,
                  ),
                ),
                const SizedBox(width: TossSpacing.space3),
                Expanded(
                  child: Text(
                    storeName,
                    style: TossTextStyles.body.copyWith(
                      color: TossColors.gray900,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Icon(
                  IconMapper.getIcon('chevronDown'),
                  color: TossColors.gray500,
                  size: TossSpacing.iconSM,
                ),
              ],
            ),
          ),
        ),
      ],
    );
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
            _buildStoreSelector(context),
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
                        ElevatedButton.icon(
                          onPressed: () {
                            _showAddShiftBottomSheet(context);
                          },
                          icon: const Icon(LucideIcons.plus, size: TossSpacing.iconSM),
                          label: const Text('Add Shift'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: TossColors.primary,
                            foregroundColor: TossColors.white,
                          ),
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
                          padding: const EdgeInsets.only(bottom: TossSpacing.space3),
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
            _buildStoreSelector(context),
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
                      StoreInfoCard(
                        store: store,
                        // onEdit removed - no edit functionality for store info
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
                      _buildQRCodeSection(context, store),
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
      appBar: const TossAppBar1(
        title: 'Store Shift Settings',
        backgroundColor: TossColors.gray100,
      ),
      body: Column(
        children: [
          // Tab Bar
          TossTabBar1(
            controller: _tabController,
            tabs: const ['Shift Settings', 'Store Settings'],
          ),

          // Tab Views
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildShiftSettingsTab(),
                _buildStoreSettingsTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Build QR Code Section
  Widget _buildQRCodeSection(BuildContext context, Map<String, dynamic> store) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: TossColors.white,
        borderRadius: BorderRadius.circular(TossBorderRadius.xl),
        boxShadow: [
          BoxShadow(
            color: TossColors.gray900.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: TossColors.transparent,
        child: InkWell(
          onTap: () {
            _showStoreQRCode(context, store);
          },
          borderRadius: BorderRadius.circular(TossBorderRadius.xl),
          child: Padding(
            padding: const EdgeInsets.all(TossSpacing.space4),
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
                    IconMapper.getIcon('qrCode'),
                    color: TossColors.primary,
                    size: TossSpacing.iconMD,
                  ),
                ),
                const SizedBox(width: TossSpacing.space3),
                Expanded(
                  child: Text(
                    'View My Store QR Code',
                    style: TossTextStyles.body.copyWith(
                      color: TossColors.gray900,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Icon(
                  IconMapper.getIcon('chevronRight'),
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

  /// Show Store QR Code Dialog
  void _showStoreQRCode(BuildContext context, Map<String, dynamic> store) {
    final storeId = store['store_id'] as String? ?? '';
    final storeName = store['store_name'] as String? ?? 'Store';
    final qrKey = GlobalKey();

    showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(TossBorderRadius.xl),
        ),
        title: Text(
          storeName,
          style: TossTextStyles.h3.copyWith(
            color: TossColors.gray900,
            fontWeight: FontWeight.w700,
          ),
          textAlign: TextAlign.center,
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RepaintBoundary(
              key: qrKey,
              child: Container(
                padding: const EdgeInsets.all(TossSpacing.space4),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(TossBorderRadius.lg),
                ),
                child: SizedBox(
                  width: 180,
                  height: 180,
                  child: QrImageView(
                    data: storeId,
                    version: QrVersions.auto,
                    backgroundColor: Colors.white,
                    errorCorrectionLevel: QrErrorCorrectLevel.M,
                  ),
                ),
              ),
            ),
            const SizedBox(height: TossSpacing.space3),
            Text(
              'Scan this QR code to access store',
              style: TossTextStyles.caption.copyWith(
                color: TossColors.gray500,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(
              'Close',
              style: TossTextStyles.body.copyWith(
                color: TossColors.gray600,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          TextButton(
            onPressed: () => _saveQRCodeToGallery(dialogContext, qrKey, storeName),
            child: Text(
              'Save Photo',
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

  /// Save QR Code to device gallery
  Future<void> _saveQRCodeToGallery(
    BuildContext context,
    GlobalKey qrKey,
    String storeName,
  ) async {
    try {
      final boundary = qrKey.currentContext?.findRenderObject() as RenderRepaintBoundary?;
      if (boundary == null) {
        throw Exception('QR code not found');
      }

      final image = await boundary.toImage(pixelRatio: 3.0);
      final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      if (byteData == null) {
        throw Exception('Failed to convert image');
      }

      final pngBytes = byteData.buffer.asUint8List();
      final result = await ImageGallerySaverPlus.saveImage(
        pngBytes,
        quality: 100,
        name: '${storeName}_QR_${DateTime.now().millisecondsSinceEpoch}',
      );

      if (context.mounted) {
        final success = result['isSuccess'] == true;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              success ? 'QR code saved to gallery' : 'Failed to save QR code',
            ),
            backgroundColor: success ? TossColors.success : TossColors.error,
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to save: $e'),
            backgroundColor: TossColors.error,
          ),
        );
      }
    }
  }

  /// Show Edit Operational Settings Bottom Sheet
  void _showEditOperationalSettingsSheet(BuildContext context, Map<String, dynamic> store) {
    showOperationalSettingsDialog(context, store);
  }

  /// Show Store Location Confirmation Dialog
  Future<void> _showSetStoreLocationDialog(BuildContext context, Map<String, dynamic> store) async {
    final confirmed = await TossConfirmCancelDialog.show(
      context: context,
      title: 'Set Store Location',
      message: 'Do you want to set the store location to your current position?',
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
      builder: (dialogContext) => const Center(
        child: CircularProgressIndicator(),
      ),
    );

    try {
      // Get current location
      final position = await LocationUtils.getCurrentLocation();

      if (position == null) {
        if (mounted) {
          Navigator.pop(currentContext); // Close loading
          ScaffoldMessenger.of(currentContext).showSnackBar(
            const SnackBar(
              content: Text('Unable to get current location. Please check location permissions.'),
              backgroundColor: TossColors.error,
            ),
          );
        }
        return;
      }

      final storeId = store['store_id'] as String?;
      if (storeId == null) {
        if (mounted) {
          Navigator.pop(currentContext); // Close loading
          ScaffoldMessenger.of(currentContext).showSnackBar(
            const SnackBar(
              content: Text('Store ID not found'),
              backgroundColor: TossColors.error,
            ),
          );
        }
        return;
      }

      // Call update_store_location RPC
      await Supabase.instance.client.rpc<void>(
        'update_store_location',
        params: {
          'p_store_id': storeId,
          'p_store_lat': position.latitude,
          'p_store_lng': position.longitude,
        },
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
