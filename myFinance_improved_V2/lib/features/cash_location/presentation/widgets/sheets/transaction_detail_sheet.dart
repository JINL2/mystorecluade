import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:myfinance_improved/shared/extensions/string_extensions.dart';
import 'package:myfinance_improved/shared/themes/toss_border_radius.dart';
import 'package:myfinance_improved/shared/themes/toss_colors.dart';
import 'package:myfinance_improved/shared/themes/toss_spacing.dart';
import 'package:myfinance_improved/shared/themes/toss_text_styles.dart';

// Import domain entities
import '../../../domain/entities/journal_entry.dart';

// Import presentation display model
import '../../providers/cash_location_providers.dart' show TransactionDisplay;

/// Bottom sheet for displaying TransactionDisplay details
/// Uses domain entities: TransactionDisplay, JournalEntry, JournalLine
class TransactionDetailSheet extends StatelessWidget {
  final TransactionDisplay transaction;

  const TransactionDetailSheet({
    super.key,
    required this.transaction,
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

  String _formatTime(DateTime dateTime) {
    return DateFormat('h:mm a').format(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    final journalEntry = transaction.journalEntry;

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
            margin: const EdgeInsets.only(top: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: TossColors.gray300,
              borderRadius: BorderRadius.circular(TossBorderRadius.xs),
            ),
          ),

          // Header
          Padding(
            padding: const EdgeInsets.fromLTRB(TossSpacing.space5, TossSpacing.space5, TossSpacing.space5, TossSpacing.space4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    transaction.title,
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

          // Transaction Info
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Amount and type
                Container(
                  padding: const EdgeInsets.all(TossSpacing.space4),
                  decoration: BoxDecoration(
                    color: transaction.isIncome
                        ? Theme.of(context).colorScheme.primary.withOpacity(0.1)
                        : TossColors.error.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(TossBorderRadius.lg),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            transaction.isIncome ? 'Money In' : 'Money Out',
                            style: TossTextStyles.caption.copyWith(
                              color: TossColors.gray600,
                              fontSize: 12,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            _formatCurrency(transaction.amount),
                            style: TossTextStyles.h1.copyWith(
                              fontWeight: FontWeight.w700,
                              color: transaction.isIncome
                                  ? Theme.of(context).colorScheme.primary
                                  : TossColors.error,
                            ),
                          ),
                        ],
                      ),
                      Icon(
                        transaction.isIncome ? Icons.trending_up : Icons.trending_down,
                        color: transaction.isIncome
                            ? Theme.of(context).colorScheme.primary
                            : TossColors.error,
                        size: 32,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // Transaction Details
                _buildDetailRow(
                  'Date',
                  _formatDate(transaction.date),
                ),
                _buildDetailRow(
                  'Time',
                  _formatTime(journalEntry.transactionDate),
                ),
                _buildDetailRow(
                  'Location',
                  transaction.locationName,
                ),
                if (transaction.description.isNotEmpty)
                  _buildDetailRow(
                    'Description',
                    transaction.description,
                  ),

                const SizedBox(height: 24),

                // Journal Lines Section
                if (journalEntry.lines.length > 1)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Transaction Details',
                        style: TossTextStyles.body.copyWith(
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: TossSpacing.space3),

                      ..._buildFilteredJournalLines(journalEntry, transaction),
                    ],
                  ),
              ],
            ),
          ),

          // Bottom safe area
          SizedBox(height: MediaQuery.of(context).padding.bottom + 20),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: TossSpacing.space2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              label,
              style: TossTextStyles.body.copyWith(
                color: TossColors.gray600,
                fontSize: 14,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TossTextStyles.body.copyWith(
                fontWeight: FontWeight.w500,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildFilteredJournalLines(JournalEntry journalEntry, TransactionDisplay transaction) {
    final filteredLines = <JournalLine>[];
    final seenCashLocations = <String>{};

    for (final line in journalEntry.lines) {
      // For cash locations, check if we've already added this location
      if (line.cashLocationId != null) {
        final locationKey = '${line.cashLocationId}_${line.locationName}';
        // Skip if we've seen this cash location and it's the same as the main transaction location
        if (seenCashLocations.contains(locationKey) &&
            line.locationName == transaction.locationName) {
          continue;
        }
        seenCashLocations.add(locationKey);
        filteredLines.add(line);
      } else {
        // Always include non-cash accounts
        filteredLines.add(line);
      }
    }

    return filteredLines.map((JournalLine line) => _buildJournalLine(line)).toList();
  }

  Widget _buildJournalLine(JournalLine line) {
    final amount = line.debit > 0 ? line.debit : line.credit;
    final isDebit = line.debit > 0;

    // Determine the display name - use location name for cash locations, otherwise account name
    String displayName;
    if (line.cashLocationId != null && line.locationName != null) {
      // This is a cash location transaction, show the location name
      displayName = line.locationName!;
      if (line.locationType != null) {
        // Add type indicator if available (e.g., "throng (Cash)")
        final typeLabel = line.locationType!.capitalize();
        displayName = '$displayName ($typeLabel)';
      }
    } else {
      // Regular account, format the account name
      displayName = _formatAccountName(line.accountName);
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(TossSpacing.space3),
      decoration: BoxDecoration(
        color: TossColors.gray50,
        borderRadius: BorderRadius.circular(TossBorderRadius.md),
        border: Border.all(color: TossColors.gray200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  displayName,
                  style: TossTextStyles.body.copyWith(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
              ),
              Text(
                '${isDebit ? '+' : '-'}${_formatCurrency(amount)}',
                style: TossTextStyles.body.copyWith(
                  fontWeight: FontWeight.w600,
                  color: isDebit ? TossColors.success : TossColors.error,
                  fontSize: 14,
                ),
              ),
            ],
          ),
          if (line.description.isNotEmpty) ...[
            const SizedBox(height: 4),
            Text(
              line.description,
              style: TossTextStyles.caption.copyWith(
                color: TossColors.gray600,
                fontSize: 12,
              ),
            ),
          ],
        ],
      ),
    );
  }

  String _formatAccountName(String accountName) {
    // Convert account names like "office supplies expenses" to "Office Supplies"
    final words = accountName.toLowerCase()
        .replaceAll('expenses', '')
        .replaceAll('expense', '')
        .replaceAll('_', ' ')
        .trim()
        .split(' ');

    return words.map((word) =>
      word.isNotEmpty ? word[0].toUpperCase() + word.substring(1) : '',
    ).join(' ');
  }
}
