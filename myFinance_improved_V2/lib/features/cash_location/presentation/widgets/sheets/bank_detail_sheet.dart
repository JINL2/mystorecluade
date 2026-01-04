import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:myfinance_improved/shared/themes/toss_border_radius.dart';
import 'package:myfinance_improved/shared/themes/toss_colors.dart';
import 'package:myfinance_improved/shared/themes/toss_spacing.dart';
import 'package:myfinance_improved/shared/themes/toss_text_styles.dart';
import 'package:myfinance_improved/shared/widgets/index.dart';

// Import presentation display model
import '../../providers/cash_location_providers.dart' show BankRealDisplay;

/// Bottom sheet for displaying bank balance details
/// Uses domain entity: BankRealDisplay (from presentation providers)
class BankDetailSheet extends StatelessWidget {
  final BankRealDisplay bankRealItem;

  const BankDetailSheet({
    super.key,
    required this.bankRealItem,
  });

  String _formatCurrency(double amount, [String? currencySymbol]) {
    final formatter = NumberFormat('#,###', 'en_US');
    final symbol = currencySymbol ?? '';
    return '$symbol${formatter.format(amount.round())}';
  }

  String _formatDate(String dateStr) {
    try {
      final date = DateTime.parse(dateStr);
      return DateFormat('MMM d, yyyy').format(date);
    } catch (e) {
      return dateStr;
    }
  }

  String _formatTime(String createdAt) {
    try {
      final dateTime = DateTime.parse(createdAt);
      return DateFormat('h:mm a').format(dateTime);
    } catch (e) {
      return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    final realEntry = bankRealItem.realEntry;
    final currencySymbol = bankRealItem.currencySymbol;

    return Container(
      decoration: const BoxDecoration(
        color: TossColors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
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
                    'Bank Balance Details',
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
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: TossSpacing.space6),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Total Amount
                Container(
                  padding: const EdgeInsets.all(TossSpacing.space4),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(TossBorderRadius.lg),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Bank Balance',
                            style: TossTextStyles.caption.copyWith(
                              color: TossColors.gray600,
                            ),
                          ),
                          const SizedBox(height: TossSpacing.space1),
                          Text(
                            _formatCurrency(realEntry.totalAmount, currencySymbol),
                            style: TossTextStyles.h1.copyWith(
                              fontWeight: FontWeight.w700,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                        ],
                      ),
                      Icon(
                        Icons.account_balance,
                        color: Theme.of(context).colorScheme.primary,
                        size: 32,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: TossSpacing.space6),

                // Details
                _buildDetailRow('Date', _formatDate(realEntry.recordDate)),
                _buildDetailRow('Time', _formatTime(realEntry.createdAt)),
                _buildDetailRow('Bank', realEntry.locationName),
                _buildDetailRow('Currency', realEntry.currencyCode),

                const SizedBox(height: TossSpacing.space5),
              ],
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
}
