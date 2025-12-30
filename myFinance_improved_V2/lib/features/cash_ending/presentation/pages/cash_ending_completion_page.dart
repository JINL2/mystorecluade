// lib/features/cash_ending/presentation/pages/cash_ending_completion_page.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../core/monitoring/sentry_config.dart';
import '../../../../shared/themes/toss_colors.dart';
import '../../../../shared/themes/toss_spacing.dart';
import '../../../../shared/themes/toss_text_styles.dart';
import '../../../../shared/widgets/toss/toss_button.dart';
import '../../domain/entities/currency.dart';
import '../../domain/entities/balance_summary.dart';
import '../../domain/usecases/create_error_adjustment_usecase.dart';
import '../../domain/usecases/create_foreign_currency_translation_usecase.dart';
import '../../di/injection.dart';
import '../providers/cash_ending_provider.dart';

// Extracted components
import 'cash_ending_completion/auto_balance_type.dart';
import 'cash_ending_completion/auto_balance_dialogs.dart';
import 'cash_ending_completion/expandable_currency_breakdown.dart';
import 'cash_ending_completion/completion_summary_section.dart';

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
  BalanceSummary? _currentBalanceSummary;
  BalanceSummary? _previousBalanceSummary;
  String? _appliedAdjustmentType;

  @override
  void initState() {
    super.initState();
    _currentBalanceSummary = widget.balanceSummary;
    _previousBalanceSummary = widget.balanceSummary;
  }

  void _toggleExpansion(String currencyId) {
    setState(() {
      _expandedCurrencyId = _expandedCurrencyId == currencyId ? null : currencyId;
    });
  }

  void _handleClose() {
    ref.read(cashEndingProvider.notifier).resetAfterSubmit();
    ref.read(cashEndingProvider.notifier).resetAllInputs();
    Navigator.of(context).pop();
  }

  Future<void> _refreshBalanceSummary() async {
    if (!mounted) return;

    try {
      final repository = ref.read(cashEndingRepositoryProvider);
      final updatedSummary = await repository.getBalanceSummary(
        locationId: widget.cashLocationId,
      );

      if (!mounted) return;

      setState(() {
        _currentBalanceSummary = updatedSummary;
      });
    } catch (e, stackTrace) {
      SentryConfig.captureException(
        e,
        stackTrace,
        hint: 'CashEndingCompletionPage refresh balance failed',
        extra: {'locationId': widget.cashLocationId},
      );
      if (!mounted) return;

      _showMessage('Failed to refresh balance: $e', isError: true);
    }
  }

  Future<void> _applyAutoBalance(AutoBalanceType type) async {
    final difference = _currentBalanceSummary?.difference ?? 0.0;

    if (difference.abs() < 0.01) {
      _showMessage('Already balanced', isError: false);
      return;
    }

    try {
      if (!mounted) return;
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(
          child: CircularProgressIndicator(),
        ),
      );

      if (type == AutoBalanceType.error) {
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

      if (!mounted) return;
      Navigator.of(context).pop();

      _showMessage('Auto-balance applied successfully!', isError: false);
      Navigator.of(context).pop();

      setState(() {
        _appliedAdjustmentType = type == AutoBalanceType.error
            ? 'Error Adjustment'
            : 'Foreign Currency Translation';
      });

      await _refreshBalanceSummary();
    } catch (e) {
      if (mounted) {
        Navigator.of(context).pop();
      }
      _showMessage('Failed to apply auto-balance: $e', isError: true);
    }
  }

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

  void _showAutoBalanceTypeSelection() {
    showAutoBalanceTypeSelection(
      context: context,
      onTypeSelected: (type) {
        showAutoBalanceConfirmation(
          context: context,
          type: type,
          balanceSummary: _currentBalanceSummary,
          grandTotal: widget.grandTotal,
          storeName: widget.storeName,
          locationName: widget.locationName,
          formatAmount: _formatAmount,
          getPercentageColor: _getPercentageColor,
          onConfirm: _applyAutoBalance,
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
            _buildHeader(),

            // Scrollable content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(TossSpacing.space4),
                child: Column(
                  children: [
                    const SizedBox(height: TossSpacing.space4),
                    _buildGrandTotal(),
                    const SizedBox(height: TossSpacing.space2),
                    _buildLocationInfo(),
                    const SizedBox(height: TossSpacing.space6),

                    // Currency breakdown sections (for cash and vault tabs)
                    if (widget.tabType == 'cash' || widget.tabType == 'vault')
                      ...widget.currencies.map((currency) => Padding(
                        padding: const EdgeInsets.only(bottom: TossSpacing.space4),
                        child: ExpandableCurrencyBreakdown(
                          currency: currency,
                          denominationQuantities: widget.denominationQuantities,
                          isExpanded: _expandedCurrencyId == currency.currencyId,
                          onToggle: () => _toggleExpansion(currency.currencyId),
                        ),
                      )),

                    if (widget.tabType == 'cash' || widget.tabType == 'vault')
                      const SizedBox(height: TossSpacing.space6),

                    // Summary section
                    CompletionSummarySection(
                      currentBalanceSummary: _currentBalanceSummary,
                      previousBalanceSummary: _previousBalanceSummary,
                      appliedAdjustmentType: _appliedAdjustmentType,
                      grandTotal: widget.grandTotal,
                      currencies: widget.currencies,
                      onAutoBalancePressed: _showAutoBalanceTypeSelection,
                    ),
                  ],
                ),
              ),
            ),

            // Bottom button
            Padding(
              padding: const EdgeInsets.all(TossSpacing.space4),
              child: TossButton.primary(
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
                onPressed: _handleClose,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
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

  String _formatAmount(double amount) {
    return NumberFormat.currency(
      symbol: widget.currencies.isNotEmpty ? widget.currencies.first.symbol : '',
      decimalDigits: 2,
    ).format(amount);
  }

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

  String _getTypeLabel() {
    switch (widget.tabType) {
      case 'cash':
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
