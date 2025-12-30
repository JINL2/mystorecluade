// lib/features/cash_ending/presentation/widgets/tabs/cash_tab/location_selection_card.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../app/providers/app_state_provider.dart';
import '../../../../../../shared/themes/toss_border_radius.dart';
import '../../../../../../shared/themes/toss_colors.dart';
import '../../../../../../shared/themes/toss_icons.dart';
import '../../../../../../shared/themes/toss_spacing.dart';
import '../../../../../../shared/themes/toss_text_styles.dart';
import '../../../../../../shared/widgets/toss/toss_dropdown.dart';
import '../../../providers/cash_ending_provider.dart';
import '../../../providers/cash_ending_state.dart';
import '../../store_selector.dart';

/// Location Selection Card for Cash Tab
/// Handles store and cash location selection
class LocationSelectionCard extends ConsumerWidget {
  final CashEndingState state;
  final String companyId;

  const LocationSelectionCard({
    super.key,
    required this.state,
    required this.companyId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Store Selector
        StoreSelector(
          stores: state.stores,
          selectedStoreId: state.selectedStoreId,
          onChanged: (storeId) async {
            if (storeId != null) {
              // Sync global app state for Account Detail Page
              final store = state.stores.firstWhere(
                (s) => s.storeId == storeId,
                orElse: () => state.stores.first,
              );
              ref.read(appStateProvider.notifier).selectStore(
                storeId,
                storeName: store.storeName,
              );

              await ref.read(cashEndingProvider.notifier).selectStore(
                storeId,
                companyId,
              );
            }
          },
        ),

        const SizedBox(height: TossSpacing.space4),

        if (state.cashLocations.isEmpty)
          _buildEmptyLocationState()
        else
          _buildLocationSelector(ref),
      ],
    );
  }

  Widget _buildEmptyLocationState() {
    return Container(
      padding: const EdgeInsets.all(TossSpacing.space4),
      decoration: BoxDecoration(
        color: TossColors.gray100,
        borderRadius: BorderRadius.circular(TossBorderRadius.lg),
        border: Border.all(color: TossColors.gray300, width: 1),
      ),
      child: Row(
        children: [
          Icon(TossIcons.wallet, size: 20, color: TossColors.gray400),
          const SizedBox(width: TossSpacing.space3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Cash Location',
                  style: TossTextStyles.caption.copyWith(
                    color: TossColors.gray600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'No cash locations available',
                  style: TossTextStyles.bodyMedium.copyWith(
                    color: TossColors.gray500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLocationSelector(WidgetRef ref) {
    return TossDropdown<String>(
      label: 'Cash Location',
      hint: 'Select Cash Location',
      value: state.selectedCashLocationId,
      items: state.cashLocations
          .map((location) => TossDropdownItem(
                value: location.locationId,
                label: location.locationName,
              ))
          .toList(),
      onChanged: (locationId) {
        if (locationId != null) {
          ref.read(cashEndingProvider.notifier).setSelectedCashLocation(locationId);
        }
      },
    );
  }
}
