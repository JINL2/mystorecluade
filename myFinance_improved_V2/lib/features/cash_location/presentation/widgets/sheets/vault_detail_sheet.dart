import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:myfinance_improved/shared/themes/toss_border_radius.dart';
import 'package:myfinance_improved/shared/themes/toss_colors.dart';
import 'package:myfinance_improved/shared/themes/toss_spacing.dart';
import 'package:myfinance_improved/shared/themes/toss_text_styles.dart';
import 'package:myfinance_improved/shared/widgets/index.dart';

// Import domain entities
import '../../../domain/entities/bank_real_entry.dart' as bank;

// Import presentation display model
import '../../providers/cash_location_providers.dart' show VaultRealDisplay;

/// Bottom sheet for displaying vault balance details
/// Uses domain entity: VaultRealDisplay (from presentation providers)
class VaultDetailSheet extends StatelessWidget {
  final VaultRealDisplay vaultRealItem;

  const VaultDetailSheet({
    super.key,
    required this.vaultRealItem,
  });

  String _formatCurrency(double amount, [String? currencySymbol]) {
    final formatter = NumberFormat('#,###', 'en_US');
    final symbol = currencySymbol ?? '';
    final isNegative = amount < 0;
    final absAmount = amount.abs();
    return '${isNegative ? "-" : ""}$symbol${formatter.format(absAmount.round())}';
  }

  String _formatDate(String dateStr) {
    try {
      final date = DateTime.parse(dateStr);
      return DateFormat('MMM d, yyyy').format(date);
    } catch (e) {
      return dateStr;
    }
  }

  @override
  Widget build(BuildContext context) {
    final realEntry = vaultRealItem.realEntry;
    final currencySymbol = vaultRealItem.currencySymbol;
    final totalValue = realEntry.totalAmount;
    final isNegative = totalValue < 0;

    return Container(
      decoration: const BoxDecoration(
        color: TossColors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.9,
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
              borderRadius: BorderRadius.circular(TossBorderRadius.xs),
            ),
          ),

          // Header
          Padding(
            padding: const EdgeInsets.fromLTRB(TossSpacing.space6, TossSpacing.space5, TossSpacing.space5, TossSpacing.space4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    'Vault Balance Details',
                    style: TossTextStyles.h2.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close, size: 24),
                  onPressed: () => Navigator.pop(context),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ],
            ),
          ),

          // Content
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: TossSpacing.space6),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Total Running Balance
                  Container(
                    padding: const EdgeInsets.all(TossSpacing.space4),
                    decoration: BoxDecoration(
                      color: isNegative
                          ? TossColors.error.withOpacity(0.1)
                          : Theme.of(context).colorScheme.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(TossBorderRadius.lg),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Running Balance',
                              style: TossTextStyles.caption.copyWith(
                                color: TossColors.gray600,
                              ),
                            ),
                            const SizedBox(height: TossSpacing.space1),
                            Text(
                              _formatCurrency(totalValue, currencySymbol),
                              style: TossTextStyles.h1.copyWith(
                                fontWeight: FontWeight.w700,
                                color: isNegative
                                    ? TossColors.error
                                    : Theme.of(context).colorScheme.primary,
                              ),
                            ),
                          ],
                        ),
                        Icon(
                          Icons.lock_outline,
                          color: isNegative
                              ? TossColors.error
                              : Theme.of(context).colorScheme.primary,
                          size: 32,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: TossSpacing.space6),

                  // Details
                  _buildDetailRow('Date', _formatDate(realEntry.recordDate)),
                  _buildDetailRow('Location', realEntry.locationName),

                  const SizedBox(height: TossSpacing.space6),

                  // Running Denomination Breakdown
                  if (realEntry.currencySummary.isNotEmpty) ...[
                    Text(
                      'Running Denomination Balance',
                      style: TossTextStyles.h4,
                    ),
                    const SizedBox(height: TossSpacing.space3),

                    ...realEntry.currencySummary.expand((currency) =>
                      currency.denominations
                        .where((d) => d.quantity != 0) // Only show non-zero quantities
                        .map((denomination) => _buildRunningDenominationItem(denomination, currency.symbol)),
                    ),
                  ],

                  // Bottom padding
                  const SizedBox(height: TossSpacing.space5),
                ],
              ),
            ),
          ),

          // Bottom safe area
          SizedBox(height: MediaQuery.of(context).padding.bottom),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: TossSpacing.space2),
      child: InfoRow.fixed(
        label: label,
        value: value,
        labelWidth: 80,
      ),
    );
  }

  Widget _buildRunningDenominationItem(bank.Denomination denomination, String symbol) {
    final isNegative = denomination.quantity < 0;

    return Container(
      margin: const EdgeInsets.only(bottom: TossSpacing.space2),
      padding: const EdgeInsets.all(TossSpacing.space3),
      decoration: BoxDecoration(
        color: TossColors.gray50,
        borderRadius: BorderRadius.circular(TossBorderRadius.md),
        border: Border.all(color: TossColors.gray200),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Denomination value
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: TossSpacing.space2, vertical: TossSpacing.space1),
                    decoration: BoxDecoration(
                      color: TossColors.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(TossBorderRadius.xs),
                    ),
                    child: Text(
                      _formatCurrency(denomination.denominationValue, symbol),
                      style: TossTextStyles.bodyMedium.copyWith(
                        color: TossColors.primary,
                      ),
                    ),
                  ),
                ],
              ),

              // Running quantity
              Text(
                'Qty: ${denomination.quantity}',
                style: TossTextStyles.body.copyWith(
                  fontWeight: FontWeight.w500,
                  color: isNegative ? TossColors.error : TossColors.black87,
                ),
              ),
            ],
          ),

          const SizedBox(height: TossSpacing.space2),

          // Running total
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Spacer(),

              // Running total (using subtotal since runningTotal doesn't exist)
              Text(
                _formatCurrency(denomination.subtotal, symbol),
                style: TossTextStyles.bodyMedium.copyWith(
                  color: isNegative ? TossColors.error : TossColors.black87,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
