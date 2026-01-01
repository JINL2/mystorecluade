/// Counterparty Cash Location Selector - Cash location for internal counterparties
///
/// Purpose: Displays cash location selector for internal counterparty transactions
/// Requires store to be selected first before showing cash locations
///
/// Clean Architecture: PRESENTATION LAYER - Widget
library;

import 'package:myfinance_improved/shared/widgets/index.dart';

import 'package:flutter/material.dart';
import 'package:myfinance_improved/shared/themes/index.dart';

/// Cash location selector for internal counterparties
class CounterpartyCashLocationSelector extends StatelessWidget {
  final String? selectedStoreId;
  final String? selectedCashLocationId;
  final ValueChanged<String?> onChanged;

  const CounterpartyCashLocationSelector({
    super.key,
    this.selectedStoreId,
    this.selectedCashLocationId,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'Counterparty Cash Location',
              style: TossTextStyles.label.copyWith(
                color: TossColors.gray700,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(width: 2),
            Text(
              '*',
              style: TossTextStyles.label.copyWith(
                color: TossColors.error,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: TossSpacing.space2),
        if (selectedStoreId == null)
          Container(
            padding: const EdgeInsets.all(TossSpacing.space3),
            decoration: BoxDecoration(
              color: TossColors.gray50,
              border: Border.all(color: TossColors.gray300),
              borderRadius: BorderRadius.circular(TossBorderRadius.md),
            ),
            child: Row(
              children: [
                const Icon(Icons.account_balance_outlined,
                    color: TossColors.gray400),
                const SizedBox(width: TossSpacing.space2),
                Text(
                  'Select store first',
                  style: TossTextStyles.body.copyWith(color: TossColors.gray400),
                ),
              ],
            ),
          )
        else
          AutonomousCashLocationSelector(
            storeId: selectedStoreId!,
            selectedLocationId: selectedCashLocationId,
            hideLabel: true,
            onChanged: onChanged,
          ),
      ],
    );
  }
}
