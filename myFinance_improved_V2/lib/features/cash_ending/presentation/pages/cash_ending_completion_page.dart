// lib/features/cash_ending/presentation/pages/cash_ending_completion_page.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../shared/themes/toss_colors.dart';
import '../../../../shared/themes/toss_spacing.dart';
import '../../../../shared/themes/toss_text_styles.dart';
import '../../../../shared/widgets/toss/toss_button_1.dart';
import '../../domain/entities/currency.dart';
import '../providers/cash_ending_provider.dart';

/// Cash Ending Completion Page
///
/// Shows detailed summary after successful cash ending submission
class CashEndingCompletionPage extends ConsumerStatefulWidget {
  final String tabType; // 'cash', 'bank', 'vault'
  final double grandTotal;
  final List<Currency> currencies; // Support multiple currencies
  final String storeName;
  final String locationName;
  final Map<String, Map<String, int>>? denominationQuantities; // For cash/vault
  final String? transactionType; // For vault: 'debit' or 'credit'

  const CashEndingCompletionPage({
    super.key,
    required this.tabType,
    required this.grandTotal,
    required this.currencies,
    required this.storeName,
    required this.locationName,
    this.denominationQuantities,
    this.transactionType,
  });

  @override
  ConsumerState<CashEndingCompletionPage> createState() => _CashEndingCompletionPageState();
}

class _CashEndingCompletionPageState extends ConsumerState<CashEndingCompletionPage> {
  String? _expandedCurrencyId;

  void _toggleExpansion(String currencyId) {
    setState(() {
      _expandedCurrencyId = _expandedCurrencyId == currencyId ? null : currencyId;
    });
  }

  void _handleClose() {
    // Only reset error messages, keep store and location selections
    // so user can quickly do another cash ending for the same location
    ref.read(cashEndingProvider.notifier).resetAfterSubmit();

    // Close the page
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TossColors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.all(TossSpacing.space4),
              child: Row(
                children: [
                  const Spacer(),
                  Text(
                    'Ending Completed!',
                    style: TossTextStyles.body.copyWith(
                      color: TossColors.gray900,
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                    ),
                  ),
                  const Spacer(),
                ],
              ),
            ),

            // Scrollable content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(TossSpacing.space4),
                child: Column(
                  children: [
                    const SizedBox(height: TossSpacing.space4),

                    // Grand Total
                    _buildGrandTotal(),

                    const SizedBox(height: TossSpacing.space2),

                    // Location info
                    _buildLocationInfo(),

                    const SizedBox(height: TossSpacing.space6),

                    // Currency breakdown sections (for cash and vault tabs)
                    if (widget.tabType == 'cash' || widget.tabType == 'vault')
                      ...widget.currencies.map((currency) => Padding(
                        padding: const EdgeInsets.only(bottom: TossSpacing.space4),
                        child: _buildCurrencyBreakdown(currency),
                      )),

                    if (widget.tabType == 'cash' || widget.tabType == 'vault')
                      const SizedBox(height: TossSpacing.space6),

                    // Summary section
                    if (widget.transactionType == 'recount')
                      _buildRecountSummary()
                    else
                      _buildSummary(),
                  ],
                ),
              ),
            ),

            // Bottom button
            Padding(
              padding: const EdgeInsets.all(TossSpacing.space4),
              child: TossButton1.primary(
                text: 'Close',
                fullWidth: true,
                textStyle: TossTextStyles.titleLarge.copyWith(
                  color: TossColors.white,
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: TossSpacing.space4,
                  vertical: TossSpacing.space4,
                ),
                borderRadius: 12,
                onPressed: () => _handleClose(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showAutoBalanceConfirmation() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          insetPadding: const EdgeInsets.symmetric(horizontal: TossSpacing.space4),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Container(
            padding: const EdgeInsets.all(TossSpacing.space4),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: TossSpacing.space2),
                // Title
                Text(
                  'Confirm Auto-Balance',
                  style: TossTextStyles.titleLarge.copyWith(
                    color: TossColors.gray900,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: TossSpacing.space5),

                // Description
                Text(
                  'Review the details below before applying Auto-Balance',
                  style: TossTextStyles.body.copyWith(
                    color: TossColors.gray600,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: TossSpacing.space6),

                // Details container
                Container(
                  padding: const EdgeInsets.all(TossSpacing.space4),
                  decoration: BoxDecoration(
                    color: TossColors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: TossColors.gray200,
                      width: 1.0,
                    ),
                  ),
                  child: Column(
                    children: [
                      _buildConfirmationRow('Location', '${widget.storeName} · ${widget.locationName}'),
                      const SizedBox(height: TossSpacing.space3),
                      _buildConfirmationRow('Total Real', _formatAmount(0)),
                      const SizedBox(height: TossSpacing.space3),
                      _buildConfirmationRow('Total Journal', _formatAmount(widget.grandTotal)),
                      const SizedBox(height: TossSpacing.space4),

                      // Difference (highlighted)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Difference',
                            style: TossTextStyles.bodyMedium.copyWith(
                              color: TossColors.gray900,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            _formatAmount(0),
                            style: TossTextStyles.bodyMedium.copyWith(
                              color: TossColors.success,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: TossSpacing.space5),

                // Explanation text
                Text(
                  'This action will add a Journal entry to match the Real amount.',
                  style: TossTextStyles.caption.copyWith(
                    color: TossColors.gray500,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: TossSpacing.space6),

                // Buttons
                Row(
                  children: [
                    // Cancel button
                    Expanded(
                      child: TossButton1.secondary(
                        text: 'Cancel',
                        fullWidth: true,
                        textStyle: TossTextStyles.body.copyWith(
                          color: TossColors.gray600,
                          fontWeight: FontWeight.w600,
                        ),
                        padding: const EdgeInsets.symmetric(
                          vertical: TossSpacing.space3,
                        ),
                        borderRadius: 12,
                        onPressed: () => Navigator.of(context).pop(),
                        leadingIcon: const Icon(
                          Icons.arrow_back,
                          size: 18,
                          color: TossColors.gray600,
                        ),
                      ),
                    ),
                    const SizedBox(width: TossSpacing.space3),

                    // Confirm button
                    Expanded(
                      child: TossButton1.primary(
                        text: 'Confirm & Apply',
                        fullWidth: true,
                        textStyle: TossTextStyles.body.copyWith(
                          color: TossColors.white,
                          fontWeight: FontWeight.w600,
                        ),
                        padding: const EdgeInsets.symmetric(
                          vertical: TossSpacing.space3,
                        ),
                        borderRadius: 12,
                        onPressed: () {
                          // Backend will implement this later
                          Navigator.of(context).pop();
                        },
                        leadingIcon: const Icon(
                          Icons.check,
                          size: 18,
                          color: TossColors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildConfirmationRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TossTextStyles.body.copyWith(
            color: TossColors.gray600,
          ),
        ),
        const SizedBox(width: TossSpacing.space2),
        Flexible(
          child: Text(
            value,
            style: TossTextStyles.body.copyWith(
              color: TossColors.gray900,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.right,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildGrandTotal() {
    final formattedAmount = NumberFormat.currency(
      symbol: widget.currencies.isNotEmpty ? widget.currencies.first.symbol : '',
      decimalDigits: 0,
    ).format(widget.grandTotal);

    return Text(
      formattedAmount,
      style: TossTextStyles.display.copyWith(
        color: TossColors.primary,
        fontFeatures: const [FontFeature.slashedZero()],
      ),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildLocationInfo() {
    final typeLabel = _getTypeLabel();
    return Text(
      '$typeLabel · ${widget.storeName} · ${widget.locationName}',
      style: TossTextStyles.body.copyWith(
        color: TossColors.gray600,
      ),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildCurrencyBreakdown(Currency currency) {
    return _ExpandableCurrencyBreakdown(
      currency: currency,
      denominationQuantities: widget.denominationQuantities,
      isExpanded: _expandedCurrencyId == currency.currencyId,
      onToggle: () => _toggleExpansion(currency.currencyId),
    );
  }

  Widget _buildRecountSummary() {
    return Container(
      padding: const EdgeInsets.all(TossSpacing.space4),
      decoration: BoxDecoration(
        color: TossColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: TossColors.gray200,
          width: 1.0,
        ),
      ),
      child: _buildSummaryRow('Total Real', _formatAmount(widget.grandTotal)),
    );
  }

  Widget _buildSummary() {
    return Container(
      padding: const EdgeInsets.all(TossSpacing.space4),
      decoration: BoxDecoration(
        color: TossColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: TossColors.gray200,
          width: 1.0,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildSummaryRow('Total Journal', _formatAmount(widget.grandTotal)),
          const SizedBox(height: TossSpacing.space3),
          _buildSummaryRow('Total Real', _formatAmount(0)),
          const SizedBox(height: TossSpacing.space3),
          _buildSummaryRow(
            'Difference',
            _formatAmount(0),
            valueColor: TossColors.gray900,
            isLarge: true,
          ),

          const SizedBox(height: TossSpacing.space4),

          // Auto-Balance to Match text button
          Align(
            alignment: Alignment.centerLeft,
            child: TextButton.icon(
              onPressed: () {
                _showAutoBalanceConfirmation();
              },
              icon: const Icon(
                Icons.sync,
                size: 18,
                color: TossColors.primary,
              ),
              label: Text(
                'Auto-Balance to Match',
                style: TossTextStyles.body.copyWith(
                  color: TossColors.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
            ),
          ),

          const SizedBox(height: TossSpacing.space2),

          // Helper text
          Text(
            'Make sure today\'s Journal entries are complete before using Auto-Balance - missing entries often cause differences.',
            style: TossTextStyles.caption.copyWith(
              color: TossColors.gray500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(
    String label,
    String value, {
    Color? valueColor,
    bool isLarge = false,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: (isLarge ? TossTextStyles.bodyMedium : TossTextStyles.body).copyWith(
            color: TossColors.gray600,
          ),
        ),
        Text(
          value,
          style: (isLarge ? TossTextStyles.bodyMedium : TossTextStyles.body).copyWith(
            color: valueColor ?? TossColors.gray900,
            fontWeight: isLarge ? FontWeight.w600 : FontWeight.w400,
          ),
        ),
      ],
    );
  }

  String _formatAmount(double amount) {
    return NumberFormat.currency(
      symbol: widget.currencies.isNotEmpty ? widget.currencies.first.symbol : '',
      decimalDigits: 2,
    ).format(amount);
  }

  String _getTypeLabel() {
    switch (widget.tabType) {
      case 'cash':
        // Check if this is a vault recount
        if (widget.transactionType == 'recount') {
          return 'Vault Recount';
        }
        return 'Cash';
      case 'bank':
        return 'Bank';
      case 'vault':
        if (widget.transactionType == 'recount') {
          return 'Vault Recount';
        }
        return widget.transactionType == 'debit' ? 'Vault In' : 'Vault Out';
      default:
        return widget.tabType;
    }
  }
}

/// Expandable Currency Breakdown Widget
class _ExpandableCurrencyBreakdown extends StatelessWidget {
  final Currency currency;
  final Map<String, Map<String, int>>? denominationQuantities;
  final bool isExpanded;
  final VoidCallback onToggle;

  const _ExpandableCurrencyBreakdown({
    required this.currency,
    this.denominationQuantities,
    required this.isExpanded,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    // Calculate subtotal for this currency from denominationQuantities
    double subtotal = 0.0;
    final Map<String, int> currencyDenominations = {};

    if (denominationQuantities != null &&
        denominationQuantities!.containsKey(currency.currencyId)) {
      final denominations = denominationQuantities![currency.currencyId]!;
      currencyDenominations.addAll(denominations);
      denominations.forEach((denomination, quantity) {
        final denominationValue = double.tryParse(denomination) ?? 0.0;
        subtotal += denominationValue * quantity;
      });
    }

    return Container(
      decoration: BoxDecoration(
        color: TossColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: TossColors.gray200,
          width: 1.0,
        ),
      ),
      child: Column(
        children: [
          // Currency header (clickable to expand/collapse)
          InkWell(
            onTap: currencyDenominations.isNotEmpty ? onToggle : null,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: TossSpacing.space4,
                vertical: TossSpacing.space3,
              ),
              child: Row(
                children: [
                  Text(
                    '${currency.currencyCode} • ${currency.currencyName}',
                    style: TossTextStyles.body.copyWith(
                      color: TossColors.gray900,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const Spacer(),
                  if (currencyDenominations.isNotEmpty)
                    Icon(
                      isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                      size: 20,
                      color: TossColors.gray400,
                    ),
                ],
              ),
            ),
          ),

          // Divider
          Container(
            height: 1,
            color: TossColors.gray200,
          ),

          // Denomination details (expandable)
          if (isExpanded && currencyDenominations.isNotEmpty) ...[
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: TossSpacing.space4,
                vertical: TossSpacing.space2,
              ),
              child: Column(
                children: currencyDenominations.entries.map((entry) {
                  final denomination = double.parse(entry.key);
                  final quantity = entry.value;
                  final lineTotal = denomination * quantity;

                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: TossSpacing.space1),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${currency.symbol}${NumberFormat('#,##0').format(denomination)} × $quantity',
                          style: TossTextStyles.caption.copyWith(
                            color: TossColors.gray600,
                          ),
                        ),
                        Text(
                          NumberFormat.currency(
                            symbol: currency.symbol,
                            decimalDigits: 0,
                          ).format(lineTotal),
                          style: TossTextStyles.caption.copyWith(
                            color: TossColors.gray600,
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
            Container(
              height: 1,
              color: TossColors.gray200,
            ),
          ],

          // Subtotal
          Padding(
            padding: const EdgeInsets.all(TossSpacing.space4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Subtotal (${currency.currencyCode})',
                  style: TossTextStyles.body.copyWith(
                    color: TossColors.gray900,
                  ),
                ),
                Text(
                  NumberFormat.currency(
                    symbol: currency.symbol,
                    decimalDigits: 0,
                  ).format(subtotal),
                  style: TossTextStyles.body.copyWith(
                    color: TossColors.gray900,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
