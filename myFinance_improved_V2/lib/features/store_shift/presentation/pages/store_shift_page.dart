import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../app/providers/app_state_provider.dart';
import '../../../../core/constants/icon_mapper.dart';
import '../../../../shared/themes/toss_border_radius.dart';
import '../../../../shared/themes/toss_colors.dart';
import '../../../../shared/themes/toss_spacing.dart';
import '../../../../shared/themes/toss_text_styles.dart';
import '../../../../shared/widgets/common/store_selector_popup.dart';
import '../../../../shared/widgets/common/toss_app_bar_1.dart';
import '../../../../shared/widgets/common/toss_empty_view.dart';
import '../../../../shared/widgets/common/toss_loading_view.dart';
import '../../../../shared/widgets/common/toss_scaffold.dart';
import '../../../../shared/widgets/toss/toss_tab_bar_1.dart';
import '../../domain/entities/store_shift.dart';
import '../providers/store_shift_providers.dart';
import '../widgets/shift_list_item.dart';
import '../widgets/store_config_section.dart';
import '../widgets/store_info_card.dart';
import '../widgets/store_operating_hours_widget.dart';
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

  // Store Selector Widget
  Widget _buildStoreSelector(BuildContext context) {
    final appState = ref.watch(appStateProvider);

    // Get selected store name
    String storeName = 'Select Store';
    if (appState.storeChoosen.isNotEmpty && appState.user.isNotEmpty) {
      try {
        final companies = appState.user['companies'] as List<dynamic>?;
        if (companies != null && companies.isNotEmpty) {
          final firstCompany = companies[0] as Map<String, dynamic>;
          final stores = firstCompany['stores'] as List<dynamic>?;
          if (stores != null) {
            final selectedStore = stores.firstWhere(
              (store) => store['store_id'] == appState.storeChoosen,
              orElse: () => null,
            );
            if (selectedStore != null) {
              storeName = (selectedStore['store_name'] ?? 'Select Store').toString();
            }
          }
        }
      } catch (e) {
        // Fallback to default
      }
    }

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
          onTap: () {
            StoreSelectorPopup.show(
              context,
              onStoreSelected: (storeId, storeName) {
                ref.read(appStateProvider.notifier).selectStore(storeId, storeName: storeName);
                Navigator.pop(context);
              },
              currentStoreId: appState.storeChoosen,
            );
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
                    FontAwesomeIcons.store,
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
              TossEmptyView(
                icon: Icon(
                  FontAwesomeIcons.store,
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
                        TossEmptyView(
                          icon: Icon(
                            FontAwesomeIcons.clock,
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
                          icon: const Icon(FontAwesomeIcons.plus, size: TossSpacing.iconSM),
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
                              FontAwesomeIcons.plus,
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
                  icon: Icon(
                    FontAwesomeIcons.circleExclamation,
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
              TossEmptyView(
                icon: Icon(
                  FontAwesomeIcons.store,
                  size: 64,
                  color: TossColors.gray400,
                ),
                title: 'Please select a store first',
              )
            else
              storeDetailsAsync.when(
                data: (store) {
                  if (store == null) {
                    return TossEmptyView(
                      icon: Icon(
                        FontAwesomeIcons.store,
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
                        onEdit: () {
                          // TODO: Show edit store dialog
                        },
                      ),
                      const SizedBox(height: TossSpacing.space4),

                      // Store Configuration
                      StoreConfigSection(
                        store: store,
                        onEditSettings: () {
                          // TODO: Show edit settings dialog
                        },
                        onEditLocation: () {
                          // TODO: Show location setting dialog
                        },
                        onViewPerformance: () {
                          // TODO: Navigate to performance page
                        },
                      ),
                      const SizedBox(height: TossSpacing.space4),

                      // Operating Hours
                      StoreOperatingHoursWidget(
                        store: store,
                        onEdit: () {
                          // TODO: Show edit operating hours dialog
                        },
                      ),
                    ],
                  );
                },
                loading: () => const TossLoadingView(
                  message: 'Loading store details...',
                ),
                error: (error, stack) => TossEmptyView(
                  icon: Icon(
                    FontAwesomeIcons.circleExclamation,
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
}
