// lib/features/cash_ending/presentation/widgets/cash_ending_complete_dialog.dart

import 'package:flutter/material.dart';
import '../../domain/entities/balance_summary.dart';

/// Dialog shown after successful cash ending submission
///
/// Displays balance summary comparing Journal (book) vs Real (actual) amounts
class CashEndingCompleteDialog extends StatelessWidget {
  final BalanceSummary balanceSummary;
  final VoidCallback? onAutoBalance;
  final VoidCallback onClose;

  const CashEndingCompleteDialog({
    super.key,
    required this.balanceSummary,
    this.onAutoBalance,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Success Icon and Title
            const Icon(
              Icons.check_circle,
              color: Colors.green,
              size: 64,
            ),
            const SizedBox(height: 16),
            const Text(
              'Ending Completed!',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 24),

            // Total Amount
            Text(
              balanceSummary.formattedTotalReal,
              style: const TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
            const SizedBox(height: 8),

            // Location Info
            Text(
              '${balanceSummary.locationType} · ${balanceSummary.locationName}',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 24),

            // Currency Info
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${balanceSummary.currencyCode} • ${balanceSummary.currencySymbol}',
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),
                  Text(
                    'Subtotal (${balanceSummary.currencyCode})',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                  Text(
                    balanceSummary.formattedTotalReal,
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Balance Summary Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey[300]!),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  _buildBalanceRow(
                    'Total Journal',
                    balanceSummary.formattedTotalJournal,
                    isHighlighted: false,
                  ),
                  const Divider(height: 24),
                  _buildBalanceRow(
                    'Total Real',
                    balanceSummary.formattedTotalReal,
                    isHighlighted: false,
                  ),
                  const Divider(height: 24),
                  _buildBalanceRow(
                    'Difference',
                    balanceSummary.formattedDifference,
                    isHighlighted: true,
                    color: _getDifferenceColor(),
                  ),

                  // Auto-Balance Button (if needed)
                  if (balanceSummary.needsAutoBalance && onAutoBalance != null)
                    ...[
                      const SizedBox(height: 16),
                      ElevatedButton.icon(
                        onPressed: onAutoBalance,
                        icon: const Icon(Icons.sync),
                        label: const Text('Auto-Balance to Match'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 12,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Make sure today\'s Journal entries are complete before using Auto-Balance - missing entries often cause differences.',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Close Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: onClose,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'Close',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBalanceRow(
    String label,
    String value, {
    bool isHighlighted = false,
    Color? color,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey[700],
            fontWeight: isHighlighted ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: isHighlighted ? FontWeight.bold : FontWeight.w500,
            color: color ?? Colors.black87,
          ),
        ),
      ],
    );
  }

  Color _getDifferenceColor() {
    if (balanceSummary.isBalanced) return Colors.green;
    if (balanceSummary.hasShortage) return Colors.red;
    if (balanceSummary.hasSurplus) return Colors.orange;
    return Colors.black87;
  }
}

/// Example usage in your cash ending provider/notifier:
///
/// ```dart
/// Future<void> submitCashEnding() async {
///   try {
///     // 1. Save cash ending
///     await repository.saveCashEnding(cashEnding);
///
///     // 2. Get balance summary
///     final balanceSummary = await repository.getBalanceSummary(
///       locationId: currentLocationId,
///     );
///
///     // 3. Show completion dialog
///     showDialog(
///       context: context,
///       builder: (_) => CashEndingCompleteDialog(
///         balanceSummary: balanceSummary,
///         onAutoBalance: _handleAutoBalance,
///         onClose: () => Navigator.of(context).pop(),
///       ),
///     );
///   } catch (e) {
///     // Handle error
///   }
/// }
/// ```
