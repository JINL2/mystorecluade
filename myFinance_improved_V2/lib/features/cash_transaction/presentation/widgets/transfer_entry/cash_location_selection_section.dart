import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myfinance_improved/shared/themes/index.dart';

import '../../../domain/entities/transfer_scope.dart';
import '../../providers/cash_transaction_providers.dart';
import 'transfer_selection_cards.dart';
import 'transfer_summary_widgets.dart';

/// Cash Location entity for this widget
typedef CashLocationData = ({
  String cashLocationId,
  String locationName,
  String storeId,
});

/// Cash Location Selection Section - Within Store (Step 1)
class WithinStoreCashLocationSection extends ConsumerWidget {
  final String fromCashLocationId;
  final String fromCashLocationName;
  final String? fromStoreName;
  final String companyId;
  final String storeId;
  final String? selectedCashLocationId;
  final void Function(CashLocation location) onLocationSelected;
  final VoidCallback onChangeFromPressed;

  const WithinStoreCashLocationSection({
    super.key,
    required this.fromCashLocationId,
    required this.fromCashLocationName,
    this.fromStoreName,
    required this.companyId,
    required this.storeId,
    required this.selectedCashLocationId,
    required this.onLocationSelected,
    required this.onChangeFromPressed,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cashLocationsAsync = ref.watch(
      cashLocationsForStoreProvider(companyId: companyId, storeId: storeId),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: TossSpacing.space3),

        // From summary
        FromSummaryCard(
          fromCashLocationName: fromCashLocationName,
          onChangePressed: onChangeFromPressed,
        ),

        // Arrow
        const TransferArrow(),

        Text(
          'Which Cash Location?',
          style: TossTextStyles.h4.copyWith(
            fontWeight: FontWeight.bold,
            color: TossColors.gray900,
          ),
        ),
        const SizedBox(height: TossSpacing.space1),
        Text(
          'Select destination in ${fromStoreName ?? 'this store'}',
          style: TossTextStyles.body.copyWith(
            color: TossColors.gray500,
          ),
        ),

        const SizedBox(height: TossSpacing.space4),

        cashLocationsAsync.when(
          data: (locations) {
            // Exclude the FROM location
            final availableLocations = locations
                .where((loc) => loc.cashLocationId != fromCashLocationId)
                .toList();

            if (availableLocations.isEmpty) {
              return Center(
                child: Text(
                  'No other cash locations available',
                  style: TossTextStyles.body.copyWith(color: TossColors.gray500),
                ),
              );
            }

            return Column(
              children: availableLocations.map((location) {
                final isSelected = selectedCashLocationId == location.cashLocationId;
                return Padding(
                  padding: const EdgeInsets.only(bottom: TossSpacing.space2),
                  child: SelectionCard(
                    title: location.locationName,
                    icon: Icons.account_balance_wallet,
                    isSelected: isSelected,
                    onTap: () {
                      HapticFeedback.lightImpact();
                      onLocationSelected(location);
                    },
                  ),
                );
              }).toList(),
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (_, __) => Center(
            child: Text(
              'Error loading locations',
              style: TossTextStyles.body.copyWith(color: TossColors.gray500),
            ),
          ),
        ),
      ],
    );
  }
}

/// Cash Location Selection Section - For Inter-Store/Company transfers
class InterEntityCashLocationSection extends ConsumerWidget {
  final TransferScope selectedScope;
  final String fromCashLocationName;
  final String targetCompanyId;
  final String targetStoreId;
  final String? targetStoreName;
  final String? targetCompanyName;
  final String? selectedCashLocationId;
  final void Function(CashLocation location) onLocationSelected;
  final VoidCallback onChangeFromPressed;
  final VoidCallback onChangeStorePressed;

  const InterEntityCashLocationSection({
    super.key,
    required this.selectedScope,
    required this.fromCashLocationName,
    required this.targetCompanyId,
    required this.targetStoreId,
    this.targetStoreName,
    this.targetCompanyName,
    required this.selectedCashLocationId,
    required this.onLocationSelected,
    required this.onChangeFromPressed,
    required this.onChangeStorePressed,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cashLocationsAsync = ref.watch(
      cashLocationsForStoreProvider(
        companyId: targetCompanyId,
        storeId: targetStoreId,
      ),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: TossSpacing.space3),

        // From summary
        FromSummaryCard(
          fromCashLocationName: fromCashLocationName,
          onChangePressed: onChangeFromPressed,
        ),

        // Arrow
        const TransferArrow(),

        // To store summary
        SummaryCard(
          icon: Icons.store,
          label: selectedScope == TransferScope.betweenCompanies
              ? targetCompanyName ?? ''
              : 'TO Store',
          value: targetStoreName ?? '',
          onEdit: onChangeStorePressed,
        ),

        const SizedBox(height: TossSpacing.space4),

        Text(
          'Which Cash Location?',
          style: TossTextStyles.h4.copyWith(
            fontWeight: FontWeight.bold,
            color: TossColors.gray900,
          ),
        ),
        const SizedBox(height: TossSpacing.space1),
        Text(
          'Select destination in ${targetStoreName ?? 'the store'}',
          style: TossTextStyles.body.copyWith(
            color: TossColors.gray500,
          ),
        ),

        const SizedBox(height: TossSpacing.space4),

        cashLocationsAsync.when(
          data: (locations) {
            if (locations.isEmpty) {
              return Center(
                child: Text(
                  'No cash locations available in this store',
                  style: TossTextStyles.body.copyWith(color: TossColors.gray500),
                ),
              );
            }

            return Column(
              children: locations.map((location) {
                final isSelected = selectedCashLocationId == location.cashLocationId;
                return Padding(
                  padding: const EdgeInsets.only(bottom: TossSpacing.space2),
                  child: SelectionCard(
                    title: location.locationName,
                    icon: Icons.account_balance_wallet,
                    isSelected: isSelected,
                    onTap: () {
                      HapticFeedback.lightImpact();
                      onLocationSelected(location);
                    },
                  ),
                );
              }).toList(),
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stack) => Center(
            child: Text(
              'Error loading cash locations',
              style: TossTextStyles.body.copyWith(color: TossColors.gray500),
            ),
          ),
        ),
      ],
    );
  }
}
