import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../shared/themes/toss_colors.dart';

/// Balance card showing journal vs actual balances
///
/// Shows:
/// - Total Journal (from transactions)
/// - Total Actual (from real counts)
/// - Difference
class BalanceCard extends StatelessWidget {
  final int totalJournal;
  final int totalReal;
  final int difference;
  final VoidCallback? onTap;

  const BalanceCard({
    super.key,
    required this.totalJournal,
    required this.totalReal,
    required this.difference,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat('#,##0', 'en_US');

    return Card(
      margin: const EdgeInsets.all(16),
      elevation: 2,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Balance Summary',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 16),
              _buildRow(
                context,
                'Total Journal',
                currencyFormat.format(totalJournal),
                isJournal: true,
              ),
              const Divider(height: 24),
              _buildRow(
                context,
                'Total Actual',
                currencyFormat.format(totalReal),
                isJournal: false,
              ),
              const Divider(height: 24),
              _buildRow(
                context,
                'Difference',
                currencyFormat.format(difference),
                isHighlighted: true,
                isDifference: true,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRow(
    BuildContext context,
    String label,
    String amount, {
    bool isJournal = false,
    bool isHighlighted = false,
    bool isDifference = false,
  }) {
    Color? amountColor;
    if (isDifference) {
      amountColor = difference == 0
          ? Colors.green
          : difference > 0
              ? Colors.blue
              : Colors.red;
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Colors.grey[700],
                fontWeight: isHighlighted ? FontWeight.w600 : FontWeight.normal,
              ),
        ),
        Text(
          amount,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: amountColor ?? (isJournal ? TossColors.primary : TossColors.gray900),
              ),
        ),
      ],
    );
  }
}
