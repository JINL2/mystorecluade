// lib/features/cash_ending/presentation/pages/cash_ending_completion_page.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../core/monitoring/sentry_config.dart';
import '../../../../shared/themes/toss_colors.dart';
import '../../../../shared/themes/toss_spacing.dart';
import '../../../../shared/themes/toss_text_styles.dart';
import '../../../../shared/widgets/toss/toss_button_1.dart';
import '../../domain/entities/currency.dart';
import '../../domain/entities/balance_summary.dart';
import '../../domain/usecases/create_error_adjustment_usecase.dart';
import '../../domain/usecases/create_foreign_currency_translation_usecase.dart';
import '../../di/injection.dart';
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
  final BalanceSummary? balanceSummary; // Balance summary from RPC

  // Auto-balance required parameters
  final String companyId;
  final String userId;
  final String cashLocationId;
  final String? storeId;

  const CashEndingCompletionPage({
    super.key,
    required this.tabType,
    required this.grandTotal,
    required this.currencies,
    required this.storeName,
    required this.locationName,
    this.denominationQuantities,
    this.transactionType,
    this.balanceSummary,
    required this.companyId,
    required this.userId,
    required this.cashLocationId,
    this.storeId,
  });

  @override
  ConsumerState<CashEndingCompletionPage> createState() => _CashEndingCompletionPageState();
}

class _CashEndingCompletionPageState extends ConsumerState<CashEndingCompletionPage> {
  String? _expandedCurrencyId;
  BalanceSummary? _currentBalanceSummary; // Local state for updated balance summary
  BalanceSummary? _previousBalanceSummary; // Store original balance before auto-balance
  bool _isRefreshing = false; // Loading state for refresh
  String? _appliedAdjustmentType; // Track which adjustment was applied

  @override
  void initState() {
    super.initState();
    // Initialize with widget's balance summary
    _currentBalanceSummary = widget.balanceSummary;
    _previousBalanceSummary = widget.balanceSummary; // Keep original for comparison
  }

  void _toggleExpansion(String currencyId) {
    setState(() {
      _expandedCurrencyId = _expandedCurrencyId == currencyId ? null : currencyId;
    });
  }

  void _handleClose() {
    // Reset error messages and clear location selections
    ref.read(cashEndingProvider.notifier).resetAfterSubmit();

    // ✅ Clear all input fields in all tabs (Cash, Bank, Vault)
    ref.read(cashEndingProvider.notifier).resetAllInputs();

    // Close the page
    Navigator.of(context).pop();
  }

  /// Refresh balance summary from server after auto-balance
  /// This ensures we show the updated balance with the new journal entry
  Future<void> _refreshBalanceSummary() async {
    if (!mounted) return;

    setState(() {
      _isRefreshing = true;
    });

    try {
      // ✅ Get fresh data from server (journal entry is already committed at this point)
      final repository = ref.read(cashEndingRepositoryProvider);
      final updatedSummary = await repository.getBalanceSummary(
        locationId: widget.cashLocationId,
      );

      if (!mounted) return;

      setState(() {
        _currentBalanceSummary = updatedSummary;
        _isRefreshing = false;
      });
    } catch (e, stackTrace) {
      SentryConfig.captureException(
        e,
        stackTrace,
        hint: 'CashEndingCompletionPage refresh balance failed',
        extra: {'locationId': widget.cashLocationId},
      );
      if (!mounted) return;

      setState(() {
        _isRefreshing = false;
      });

      _showMessage('Failed to refresh balance: $e', isError: true);
    }
  }

  /// Apply auto-balance using the selected adjustment type
  Future<void> _applyAutoBalance(AutoBalanceType type) async {
    final difference = _currentBalanceSummary?.difference ?? 0.0;

    // If already balanced, do nothing
    if (difference.abs() < 0.01) {
      _showMessage('Already balanced', isError: false);
      return;
    }

    try {
      // Show loading indicator
      if (!mounted) return;
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(
          child: CircularProgressIndicator(),
        ),
      );

      if (type == AutoBalanceType.error) {
        // Apply error adjustment
        final useCase = ref.read(errorAdjustmentUseCaseProvider);
        await useCase(CreateErrorAdjustmentParams(
          differenceAmount: difference,
          companyId: widget.companyId,
          userId: widget.userId,
          locationName: widget.locationName,
          cashLocationId: widget.cashLocationId,
          storeId: widget.storeId,
        ));
      } else {
        // Apply foreign currency translation
        final useCase = ref.read(foreignCurrencyTranslationUseCaseProvider);
        await useCase(CreateForeignCurrencyTranslationParams(
          differenceAmount: difference,
          companyId: widget.companyId,
          userId: widget.userId,
          locationName: widget.locationName,
          cashLocationId: widget.cashLocationId,
          storeId: widget.storeId,
        ));
      }

      // Close loading indicator
      if (!mounted) return;
      Navigator.of(context).pop();

      // Show success message
      _showMessage('Auto-balance applied successfully!', isError: false);

      // Close confirmation dialog
      Navigator.of(context).pop();

      // ✅ Store adjustment type for displaying what was applied
      setState(() {
        _appliedAdjustmentType = type == AutoBalanceType.error
            ? 'Error Adjustment'
            : 'Foreign Currency Translation';
      });

      // ✅ Refresh balance summary from server to show updated values
      await _refreshBalanceSummary();

      // User can now see the updated balance (Difference should be 0 or near 0)
      // and click Close button when ready
    } catch (e) {
      // Close loading indicator
      if (mounted) {
        Navigator.of(context).pop();
      }

      // Show error message
      _showMessage('Failed to apply auto-balance: $e', isError: true);
    }
  }

  /// Show success or error message
  void _showMessage(String message, {required bool isError}) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? TossColors.error : TossColors.success,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  /// Show dialog to select auto-balance type
  void _showAutoBalanceTypeSelection() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          insetPadding: const EdgeInsets.symmetric(horizontal: TossSpacing.space4),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: const EdgeInsets.all(TossSpacing.space4),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: TossSpacing.space2),
                Text(
                  'Select Adjustment Type',
                  style: TossTextStyles.titleLarge.copyWith(
                    color: TossColors.gray900,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: TossSpacing.space5),
                Text(
                  'Choose the type of adjustment to apply',
                  style: TossTextStyles.body.copyWith(
                    color: TossColors.gray600,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: TossSpacing.space6),

                // Error Adjustment Button
                TossButton1.primary(
                  text: 'Error Adjustment',
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
                    Navigator.of(context).pop();
                    _showAutoBalanceConfirmation(AutoBalanceType.error);
                  },
                  leadingIcon: const Icon(
                    Icons.error_outline,
                    size: 18,
                    color: TossColors.white,
                  ),
                ),
                const SizedBox(height: TossSpacing.space3),

                // Foreign Currency Translation Button
                TossButton1.secondary(
                  text: 'Foreign Currency Translation',
                  fullWidth: true,
                  textStyle: TossTextStyles.body.copyWith(
                    color: TossColors.gray600,
                    fontWeight: FontWeight.w600,
                  ),
                  padding: const EdgeInsets.symmetric(
                    vertical: TossSpacing.space3,
                  ),
                  borderRadius: 12,
                  onPressed: () {
                    Navigator.of(context).pop();
                    _showAutoBalanceConfirmation(AutoBalanceType.foreignCurrency);
                  },
                  leadingIcon: const Icon(
                    Icons.currency_exchange,
                    size: 18,
                    color: TossColors.gray600,
                  ),
                ),
                const SizedBox(height: TossSpacing.space3),

                // Cancel button
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text(
                    'Cancel',
                    style: TossTextStyles.body.copyWith(
                      color: TossColors.gray500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
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

  void _showAutoBalanceConfirmation(AutoBalanceType type) {
    // ✅ Get actual values from current balance summary
    final totalJournal = _currentBalanceSummary?.totalJournal ?? 0.0;
    final totalReal = _currentBalanceSummary?.totalReal ?? widget.grandTotal;
    final difference = _currentBalanceSummary?.difference ?? (totalReal - totalJournal);
    final isShortage = difference < 0;
    final isSurplus = difference > 0;

    // Determine difference color based on actual balance status
    final differenceColor = isShortage
        ? TossColors.error
        : isSurplus
            ? TossColors.warning
            : TossColors.success;

    // Get adjustment type name
    final adjustmentTypeName = type == AutoBalanceType.error
        ? 'Error Adjustment'
        : 'Foreign Currency Translation';

    // ✅ Use current balance summary formatted values (with correct currency symbol)
    final formattedTotalReal = _currentBalanceSummary?.formattedTotalReal ?? _formatAmount(totalReal);
    final formattedTotalJournal = _currentBalanceSummary?.formattedTotalJournal ?? _formatAmount(totalJournal);
    final formattedDifference = _currentBalanceSummary?.formattedDifference ?? _formatAmount(difference);

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
                      _buildConfirmationRow('Total Real', formattedTotalReal),
                      const SizedBox(height: TossSpacing.space3),
                      _buildConfirmationRow('Total Journal', formattedTotalJournal),
                      const SizedBox(height: TossSpacing.space4),

                      // Difference (highlighted with actual color)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            'Difference',
                            style: TossTextStyles.bodyMedium.copyWith(
                              color: TossColors.gray900,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                formattedDifference,
                                style: TossTextStyles.bodyMedium.copyWith(
                                  color: differenceColor,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              // ✅ Show percentage below difference in dialog
                              if (_currentBalanceSummary != null) ...[
                                const SizedBox(height: 2),
                                Text(
                                  _currentBalanceSummary!.formattedPercentage,
                                  style: TossTextStyles.caption.copyWith(
                                    color: _getPercentageColor(_currentBalanceSummary),
                                    fontWeight: FontWeight.w500,
                                    fontSize: 11,
                                  ),
                                ),
                              ],
                            ],
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
                        onPressed: () async {
                          // Apply auto-balance
                          await _applyAutoBalance(type);
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
    // ✅ Show full balance summary for RECOUNT (same as regular summary)
    // Use current balance summary data if available, otherwise use defaults
    final totalJournal = _currentBalanceSummary?.totalJournal ?? 0.0;
    final totalReal = _currentBalanceSummary?.totalReal ?? widget.grandTotal;
    final difference = _currentBalanceSummary?.difference ?? (totalReal - totalJournal);
    final isBalanced = _currentBalanceSummary?.isBalanced ?? (difference.abs() < 0.01);

    // Determine difference color
    Color differenceColor = TossColors.gray900;
    if (!isBalanced) {
      if (difference < 0) {
        differenceColor = TossColors.loss; // Shortage (red)
      } else {
        differenceColor = TossColors.warning; // Surplus (orange)
      }
    }

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
          _buildSummaryRow(
            'Total Journal',
            _currentBalanceSummary != null
              ? _currentBalanceSummary!.formattedTotalJournal
              : _formatAmount(totalJournal)
          ),
          const SizedBox(height: TossSpacing.space3),
          _buildSummaryRow(
            'Total Real',
            _currentBalanceSummary != null
              ? _currentBalanceSummary!.formattedTotalReal
              : _formatAmount(totalReal)
          ),
          const SizedBox(height: TossSpacing.space3),
          _buildSummaryRow(
            'Difference',
            _currentBalanceSummary != null
              ? _currentBalanceSummary!.formattedDifference
              : _formatAmount(difference),
            valueColor: differenceColor,
            isLarge: true,
            subtitle: _currentBalanceSummary?.formattedPercentage,
            subtitleColor: _getPercentageColor(_currentBalanceSummary),
          ),

          // Only show Auto-Balance if there's a difference
          if (!isBalanced) ...[
            const SizedBox(height: TossSpacing.space4),

            // Auto-Balance to Match text button
            Align(
              alignment: Alignment.centerLeft,
              child: TossButton1.textButton(
                text: 'Auto-Balance to Match',
                onPressed: () {
                  _showAutoBalanceTypeSelection();
                },
                leadingIcon: const Icon(Icons.sync, size: 18),
                textColor: TossColors.primary,
                fontWeight: FontWeight.w600,
                padding: EdgeInsets.zero,
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
        ],
      ),
    );
  }

  Widget _buildSummary() {
    // Use balance summary data if available, otherwise use defaults
    final totalJournal = _currentBalanceSummary?.totalJournal ?? 0.0;
    final totalReal = _currentBalanceSummary?.totalReal ?? widget.grandTotal;
    final difference = _currentBalanceSummary?.difference ?? (totalReal - totalJournal);
    final isBalanced = _currentBalanceSummary?.isBalanced ?? (difference.abs() < 0.01);

    // Determine difference color
    Color differenceColor = TossColors.gray900;
    if (!isBalanced) {
      if (difference < 0) {
        differenceColor = TossColors.loss; // Shortage (red)
      } else {
        differenceColor = TossColors.warning; // Surplus (orange)
      }
    }

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
          // ✅ Show adjustment details if auto-balance was applied
          if (_appliedAdjustmentType != null && _previousBalanceSummary != null) ...[
            _buildAdjustmentInfo(),
            const SizedBox(height: TossSpacing.space4),
            const Divider(color: TossColors.gray200, height: 1),
            const SizedBox(height: TossSpacing.space4),
          ],

          _buildSummaryRow(
            'Total Journal',
            _currentBalanceSummary != null
              ? _currentBalanceSummary!.formattedTotalJournal
              : _formatAmount(totalJournal)
          ),
          const SizedBox(height: TossSpacing.space3),
          _buildSummaryRow(
            'Total Real',
            _currentBalanceSummary != null
              ? _currentBalanceSummary!.formattedTotalReal
              : _formatAmount(totalReal)
          ),
          const SizedBox(height: TossSpacing.space3),
          _buildSummaryRow(
            'Difference',
            _currentBalanceSummary != null
              ? _currentBalanceSummary!.formattedDifference
              : _formatAmount(difference),
            valueColor: differenceColor,
            isLarge: true,
            subtitle: _currentBalanceSummary?.formattedPercentage,
            subtitleColor: _getPercentageColor(_currentBalanceSummary),
          ),

          // Only show Auto-Balance if there's a difference
          if (!isBalanced) ...[
            const SizedBox(height: TossSpacing.space4),

            // Auto-Balance to Match text button
            Align(
              alignment: Alignment.centerLeft,
              child: TossButton1.textButton(
                text: 'Auto-Balance to Match',
                onPressed: () {
                  _showAutoBalanceTypeSelection();
                },
                leadingIcon: const Icon(Icons.sync, size: 18),
                textColor: TossColors.primary,
                fontWeight: FontWeight.w600,
                padding: EdgeInsets.zero,
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
        ],
      ),
    );
  }

  Widget _buildSummaryRow(
    String label,
    String value, {
    Color? valueColor,
    bool isLarge = false,
    String? subtitle, // ✅ Add subtitle for percentage
    Color? subtitleColor,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          label,
          style: (isLarge ? TossTextStyles.bodyMedium : TossTextStyles.body).copyWith(
            color: TossColors.gray600,
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              value,
              style: (isLarge ? TossTextStyles.bodyMedium : TossTextStyles.body).copyWith(
                color: valueColor ?? TossColors.gray900,
                fontWeight: isLarge ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
            // ✅ Show subtitle (percentage) if provided
            if (subtitle != null) ...[
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: TossTextStyles.caption.copyWith(
                  color: subtitleColor ?? TossColors.gray500,
                  fontWeight: FontWeight.w500,
                  fontSize: 11,
                ),
              ),
            ],
          ],
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

  /// Get color for percentage based on level
  Color _getPercentageColor(BalanceSummary? summary) {
    if (summary == null) return TossColors.gray500;

    switch (summary.percentageLevel) {
      case PercentageLevel.safe:
        return TossColors.success;
      case PercentageLevel.warning:
        return TossColors.warning;
      case PercentageLevel.critical:
        return TossColors.error;
    }
  }

  /// Build adjustment info section showing what changed
  Widget _buildAdjustmentInfo() {
    if (_previousBalanceSummary == null || _appliedAdjustmentType == null) {
      return const SizedBox.shrink();
    }

    final oldTotalJournal = _previousBalanceSummary!.totalJournal;
    final adjustmentAmount = _previousBalanceSummary!.difference;
    final totalReal = _previousBalanceSummary!.totalReal;

    // ✅ Determine color based on adjustment type and direction
    // Error Adjustment + negative = money lost (RED)
    // Error Adjustment + positive = money found (GREEN)
    // After auto-balance, difference is 0, but we show the adjustment that was made
    final bool isNegativeAdjustment = adjustmentAmount < 0;
    final bool isErrorAdjustment = _appliedAdjustmentType == 'Error Adjustment';

    final Color boxColor;
    final IconData boxIcon;

    if (isErrorAdjustment && isNegativeAdjustment) {
      // Money lost - use warning/error color
      boxColor = TossColors.error;
      boxIcon = Icons.warning;
    } else if (isErrorAdjustment && !isNegativeAdjustment) {
      // Money found - use success color
      boxColor = TossColors.success;
      boxIcon = Icons.check_circle;
    } else {
      // Foreign currency translation - use info/primary color
      boxColor = TossColors.primary;
      boxIcon = Icons.currency_exchange;
    }

    return Container(
      padding: const EdgeInsets.all(TossSpacing.space3),
      decoration: BoxDecoration(
        color: boxColor.withOpacity(0.05),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: boxColor.withOpacity(0.2),
          width: 1.0,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title with icon
          Row(
            children: [
              Icon(
                boxIcon,
                size: 18,
                color: boxColor,
              ),
              const SizedBox(width: TossSpacing.space2),
              Text(
                'Auto-Balance Applied',
                style: TossTextStyles.bodySmall.copyWith(
                  color: boxColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: TossSpacing.space3),

          // Old Total Journal
          _buildAdjustmentRow(
            'Old Total Journal',
            _previousBalanceSummary!.formattedTotalJournal,
            TossColors.gray600,
          ),
          const SizedBox(height: TossSpacing.space2),

          // Adjustment Type & Amount
          _buildAdjustmentRow(
            _appliedAdjustmentType!,
            adjustmentAmount >= 0
                ? '+${_formatAmount(adjustmentAmount.abs())}'
                : '-${_formatAmount(adjustmentAmount.abs())}',
            boxColor, // Use same color as box
            isBold: true,
          ),
          const SizedBox(height: TossSpacing.space2),

          // Total Real (target)
          _buildAdjustmentRow(
            'Total Real',
            _previousBalanceSummary!.formattedTotalReal,
            TossColors.primary,
            isBold: true,
          ),
        ],
      ),
    );
  }

  Widget _buildAdjustmentRow(String label, String value, Color color, {bool isBold = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TossTextStyles.bodySmall.copyWith(
            color: color,
            fontWeight: isBold ? FontWeight.w600 : FontWeight.w400,
          ),
        ),
        Text(
          value,
          style: TossTextStyles.bodySmall.copyWith(
            color: color,
            fontWeight: isBold ? FontWeight.w600 : FontWeight.w500,
          ),
        ),
      ],
    );
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

/// Type of auto-balance adjustment
enum AutoBalanceType {
  /// Error adjustment - for counting errors or discrepancies
  error,

  /// Foreign currency translation - for exchange rate differences
  foreignCurrency,
}
