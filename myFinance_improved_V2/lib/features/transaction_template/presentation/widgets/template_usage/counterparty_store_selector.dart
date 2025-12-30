/// Counterparty Store Selector - Store selection for internal counterparties
///
/// Purpose: Displays store selection placeholder for internal counterparty transactions
/// Used when template requires selecting a store from linked company
///
/// Clean Architecture: PRESENTATION LAYER - Widget
library;

import 'package:flutter/material.dart';
import 'package:myfinance_improved/shared/themes/index.dart';

/// Store selector for internal counterparties
class CounterpartyStoreSelector extends StatelessWidget {
  final String? selectedStoreId;
  final String? linkedCompanyId;
  final ValueChanged<String?>? onChanged;

  const CounterpartyStoreSelector({
    super.key,
    this.selectedStoreId,
    this.linkedCompanyId,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'Counterparty Store',
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
        // TODO: Implement AutonomousStoreSelector for linked company
        Container(
          padding: const EdgeInsets.all(TossSpacing.space3),
          decoration: BoxDecoration(
            color: TossColors.gray50,
            border: Border.all(color: TossColors.gray300),
            borderRadius: BorderRadius.circular(TossBorderRadius.md),
          ),
          child: Row(
            children: [
              const Icon(Icons.store_outlined, color: TossColors.gray500),
              const SizedBox(width: TossSpacing.space2),
              Expanded(
                child: Text(
                  selectedStoreId != null
                      ? 'Store selected'
                      : 'Select counterparty store',
                  style: TossTextStyles.body.copyWith(
                    color: selectedStoreId != null
                        ? TossColors.gray900
                        : TossColors.gray500,
                  ),
                ),
              ),
              const Icon(Icons.chevron_right, color: TossColors.gray400),
            ],
          ),
        ),
        if (linkedCompanyId != null)
          Padding(
            padding: const EdgeInsets.only(top: TossSpacing.space1),
            child: Text(
              'Select a store from the linked company',
              style: TossTextStyles.caption.copyWith(color: TossColors.gray500),
            ),
          ),
      ],
    );
  }
}
