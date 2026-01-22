// lib/features/cash_ending/presentation/widgets/tabs/cash_tab/location_selection_card.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../app/providers/app_state_provider.dart';
import '../../../../../../shared/themes/toss_spacing.dart';
import '../../../providers/cash_ending_provider.dart';
import '../../../providers/cash_ending_state.dart';
import '../../store_selector.dart';
import 'package:myfinance_improved/shared/widgets/index.dart';

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

        const SizedBox(height: TossSpacing.space6),

        // Always show dropdown - it handles empty/loading states internally
        _buildLocationSelector(ref),
      ],
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
