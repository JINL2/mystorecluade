import 'package:flutter/material.dart';
import 'package:myfinance_improved/shared/themes/index.dart';

import '../../../domain/entities/transfer_scope.dart';
import '../amount_input_keypad.dart';
import 'transfer_selection_cards.dart';
import 'transfer_summary_widgets.dart';

/// Amount Input Section - Final step for all transfer types
class AmountInputSection extends StatelessWidget {
  final TransferScope? selectedScope;
  final String fromStoreName;
  final String fromCashLocationName;
  final String? toCompanyName;
  final String? toStoreName;
  final String? toCashLocationName;
  final double amount;
  final void Function(double) onAmountChanged;

  const AmountInputSection({
    super.key,
    required this.selectedScope,
    required this.fromStoreName,
    required this.fromCashLocationName,
    this.toCompanyName,
    this.toStoreName,
    this.toCashLocationName,
    required this.amount,
    required this.onAmountChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Transfer summary (no top padding - header has enough)
        TransferSummaryWidget(
          selectedScope: selectedScope,
          fromStoreName: fromStoreName,
          fromCashLocationName: fromCashLocationName,
          toCompanyName: toCompanyName,
          toStoreName: toStoreName,
          toCashLocationName: toCashLocationName,
        ),

        // Debt transaction notice
        if (selectedScope?.isDebtTransaction == true) ...[
          const SizedBox(height: TossSpacing.space2),
          const DebtTransactionNotice(),
        ],

        const SizedBox(height: TossSpacing.space3),

        // Amount keypad
        AmountInputKeypad(
          initialAmount: amount,
          onAmountChanged: onAmountChanged,
          showSubmitButton: false,
        ),

        // Bottom padding for fixed button
        const SizedBox(height: 80),
      ],
    );
  }
}
