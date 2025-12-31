import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import 'package:myfinance_improved/app/providers/app_state_provider.dart';
import 'package:myfinance_improved/features/journal_input/presentation/providers/journal_input_providers.dart';
import 'package:myfinance_improved/shared/themes/index.dart';
import 'package:myfinance_improved/shared/widgets/molecules/keyboard/toss_currency_exchange_modal.dart';
import 'package:myfinance_improved/shared/widgets/atoms/buttons/toss_button.dart';
import 'package:myfinance_improved/shared/widgets/atoms/feedback/toss_loading_view.dart';
/// Exchange Rate Calculator
///
/// UX Flow:
/// 1. User sees foreign currencies they can input (EUR, USD, etc.)
/// 2. Taps on a currency card → numberpad opens
/// 3. Enters amount in foreign currency
/// 4. Result shows converted amount in base currency (VND)
/// 5. Tap "Use Amount" to apply the converted VND amount
class ExchangeRateCalculator extends ConsumerStatefulWidget {
  final String? initialAmount;
  final void Function(String amount) onAmountSelected;
  const ExchangeRateCalculator({
    super.key,
    this.initialAmount,
    required this.onAmountSelected,
  });
  @override
  ConsumerState<ExchangeRateCalculator> createState() => _ExchangeRateCalculatorState();
}
class _ExchangeRateCalculatorState extends ConsumerState<ExchangeRateCalculator> {
  final Map<String, TextEditingController> _currencyControllers = {};
  Map<String, dynamic>? _baseCurrency;
  List<Map<String, dynamic>>? _exchangeRates;
  String? _selectedCurrencyId; // Track which currency is being edited
  void dispose() {
    for (var controller in _currencyControllers.values) {
      try {
        controller.dispose();
      } catch (_) {}
    }
    _currencyControllers.clear();
    super.dispose();
  }
  String _getBaseAmount() {
    if (_baseCurrency == null) return '0';
    final baseCurrencyId = _baseCurrency!['currency_id'] as String?;
    if (baseCurrencyId == null) return '0';
    return _currencyControllers[baseCurrencyId]?.text ?? '0';
  String _getFormattedBaseAmount() {
    final amount = _getBaseAmount().replaceAll(',', '');
    final numericValue = double.tryParse(amount) ?? 0;
    if (numericValue == 0) return '';
    final formatter = NumberFormat('#,##0', 'en_US');
    return formatter.format(numericValue);
  void _updateExchangeRates(String fromCurrencyId, String amount) {
    final cleanAmount = amount.replaceAll(',', '');
    final sourceAmount = double.tryParse(cleanAmount) ?? 0;
    final baseCurrencyId = _baseCurrency?['currency_id'] as String?;
    if (sourceAmount == 0) {
      _currencyControllers.forEach((currencyId, controller) {
        if (currencyId != fromCurrencyId) {
          controller.clear();
        }
      });
      setState(() {});
      return;
    if (fromCurrencyId == baseCurrencyId) {
      _exchangeRates?.forEach((rate) {
        final currencyId = rate['currency_id'] as String?;
        if (currencyId != null && currencyId != fromCurrencyId) {
          final targetRate = (rate['rate'] as num?)?.toDouble() ?? 1.0;
          final targetAmount = sourceAmount / targetRate;
          final formatter = NumberFormat('#,##0.##', 'en_US');
          _currencyControllers[currencyId]?.text = formatter.format(targetAmount);
    } else {
        if (currencyId != fromCurrencyId && currencyId != baseCurrencyId) {
      final sourceRateData = _exchangeRates?.firstWhere(
        (rate) => rate['currency_id'] == fromCurrencyId,
        orElse: () => {'rate': 1.0},
      );
      final sourceRate = (sourceRateData?['rate'] as num?)?.toDouble() ?? 1.0;
      final baseAmount = sourceAmount * sourceRate;
      if (baseCurrencyId != null && _currencyControllers[baseCurrencyId] != null) {
        final formatter = NumberFormat('#,##0', 'en_US');
        _currencyControllers[baseCurrencyId]!.text = formatter.format(baseAmount);
      }
    setState(() {});
  void _confirmAmount() {
    String finalAmount = '0';
    if (_baseCurrency != null && _currencyControllers[_baseCurrency!['currency_id']] != null) {
      final controller = _currencyControllers[_baseCurrency!['currency_id']]!;
      finalAmount = controller.text.replaceAll(',', '');
    widget.onAmountSelected(finalAmount);
    context.pop();
  void _showNumberpad(Map<String, dynamic> rate) {
    final currencyId = rate['currency_id'] as String?;
    if (currencyId == null) return;
    // Clear other fields and set selected
    _currencyControllers.forEach((id, controller) {
      if (id != currencyId) controller.clear();
    });
    setState(() {
      _selectedCurrencyId = currencyId;
    TossCurrencyExchangeModal.show(
      context: context,
      title: rate['currency_code'] as String? ?? '',
      initialValue: _currencyControllers[currencyId]?.text.replaceAll(',', ''),
      currency: rate['symbol'] as String? ?? rate['currency_code'] as String?,
      allowDecimal: true,
      onConfirm: (value) {
        final formatter = NumberFormat('#,##0.##', 'en_US');
        final numericValue = double.tryParse(value) ?? 0;
        _currencyControllers[currencyId]?.text = formatter.format(numericValue);
        _updateExchangeRates(currencyId, value);
      },
    );
  Widget build(BuildContext context) {
    final appState = ref.watch(appStateProvider);
    final exchangeRatesAsync = ref.watch(
      exchangeRatesProvider(
        ExchangeRatesParams(
          companyId: appState.companyChoosen,
          storeId: appState.storeChoosen.isNotEmpty ? appState.storeChoosen : null,
        ),
      ),
    final bottomPadding = MediaQuery.of(context).padding.bottom;
    final screenHeight = MediaQuery.of(context).size.height;
    final maxHeight = screenHeight * 0.8; // 80% of screen height
    return ConstrainedBox(
      constraints: BoxConstraints(maxHeight: maxHeight),
      child: Container(
      decoration: const BoxDecoration(
        color: TossColors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(TossBorderRadius.lg),
          topRight: Radius.circular(TossBorderRadius.lg),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Drag Handle
          Center(
            child: Container(
              margin: const EdgeInsets.only(top: TossSpacing.space2, bottom: TossSpacing.space1),
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: TossColors.gray300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          // Header
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: TossSpacing.paddingMD,
              vertical: TossSpacing.space2,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Currency Converter',
                  style: TossTextStyles.titleMedium.copyWith(
                    color: TossColors.gray900,
                  ),
                ),
                GestureDetector(
                  onTap: () => context.pop(),
                  child: const Icon(Icons.close, color: TossColors.gray500, size: TossSpacing.iconSM),
              ],
          // Content
          exchangeRatesAsync.when(
            data: (data) {
              _baseCurrency = data['base_currency'] as Map<String, dynamic>?;
              _exchangeRates = (data['exchange_rates'] as List<dynamic>?)
                  ?.map((item) => Map<String, dynamic>.from(item as Map))
                  .toList();
              // Initialize controllers
              _exchangeRates?.forEach((rate) {
                final currencyId = rate['currency_id'] as String?;
                if (currencyId != null && !_currencyControllers.containsKey(currencyId)) {
                  _currencyControllers[currencyId] = TextEditingController();
                  if (widget.initialAmount != null &&
                      widget.initialAmount!.isNotEmpty &&
                      currencyId == _baseCurrency!['currency_id']) {
                    _currencyControllers[currencyId]!.text = widget.initialAmount!;
                  }
                }
              });
              // Only non-base currencies for input
              final nonBaseCurrencies = _exchangeRates?.where((rate) {
                return rate['currency_id'] != _baseCurrency?['currency_id'];
              }).toList() ?? [];
              final formattedAmount = _getFormattedBaseAmount();
              final baseCode = _baseCurrency?['currency_code'] ?? '';
              final baseSymbol = _baseCurrency?['symbol'] ?? baseCode;
              return Flexible(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Input section label
                    Padding(
                      padding: const EdgeInsets.fromLTRB(
                        TossSpacing.paddingMD,
                        TossSpacing.space2,
                      ),
                      child: Row(
                        children: [
                          Text(
                            'Enter amount in:',
                            style: TossTextStyles.caption.copyWith(
                              color: TossColors.gray500,
                            ),
                          ),
                        ],
                    ),
                    // Currency input cards - scrollable
                    Flexible(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: TossSpacing.paddingMD),
                        child: ListView.separated(
                          shrinkWrap: true,
                          itemCount: nonBaseCurrencies.length,
                          separatorBuilder: (_, __) => const SizedBox(height: TossSpacing.space2),
                          itemBuilder: (context, index) => _buildCurrencyInputCard(nonBaseCurrencies[index]),
                        ),
                    const SizedBox(height: TossSpacing.space4),
                    // Arrow indicator
                    const Icon(
                      Icons.arrow_downward_rounded,
                      color: TossColors.gray300,
                      size: TossSpacing.iconMD,
                    const SizedBox(height: TossSpacing.space3),
                    // Result section - always visible
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: TossSpacing.paddingMD),
                      padding: const EdgeInsets.all(TossSpacing.paddingMD),
                      decoration: BoxDecoration(
                        color: formattedAmount.isNotEmpty
                            ? TossColors.primarySurface
                            : TossColors.gray50,
                        borderRadius: BorderRadius.circular(TossBorderRadius.md),
                        border: Border.all(
                          color: formattedAmount.isNotEmpty
                              ? TossColors.primary.withValues(alpha: 0.2)
                              : TossColors.gray100,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                            'Converted to $baseCode',
                          const SizedBox(height: TossSpacing.space2),
                            formattedAmount.isNotEmpty
                                ? '$baseSymbol $formattedAmount'
                                : '$baseSymbol 0',
                            style: TossTextStyles.h2.copyWith(
                              color: formattedAmount.isNotEmpty
                                  ? TossColors.primary
                                  : TossColors.gray300,
                    // Footer button
                      padding: EdgeInsets.fromLTRB(
                        TossSpacing.space4,
                        TossSpacing.space3 + bottomPadding,
                      child: TossButton.primary(
                        text: formattedAmount.isEmpty ? 'Enter amount above' : 'Use $baseSymbol $formattedAmount',
                        onPressed: formattedAmount.isEmpty ? null : _confirmAmount,
                        fullWidth: true,
                  ],
              );
            },
            loading: () => const Padding(
              padding: EdgeInsets.all(TossSpacing.space8),
              child: Center(child: TossLoadingView()),
            error: (error, _) => Padding(
              padding: const EdgeInsets.all(TossSpacing.space8),
              child: Center(
                    const Icon(Icons.error_outline, size: TossSpacing.iconLG, color: TossColors.gray400),
                    const SizedBox(height: TossSpacing.space2),
                    Text(
                      'Failed to load',
                      style: TossTextStyles.body.copyWith(color: TossColors.gray600),
        ],
  /// Currency input card - tap to enter amount
  Widget _buildCurrencyInputCard(Map<String, dynamic> rate) {
    if (currencyId == null) return const SizedBox.shrink();
    final controller = _currencyControllers[currencyId];
    final hasValue = controller?.text.isNotEmpty ?? false;
    final currencyCode = rate['currency_code'] as String? ?? '';
    final currencySymbol = rate['symbol'] as String? ?? currencyCode;
    final exchangeRate = rate['rate'];
    final baseCurrencyCode = _baseCurrency?['currency_code'] ?? '';
    final isSelected = _selectedCurrencyId == currencyId;
    return GestureDetector(
      onTap: () => _showNumberpad(rate),
      behavior: HitTestBehavior.opaque,
        padding: const EdgeInsets.symmetric(
          horizontal: TossSpacing.paddingSM,
          vertical: TossSpacing.paddingSM,
        decoration: BoxDecoration(
          color: isSelected && hasValue ? TossColors.gray100 : TossColors.gray50,
          borderRadius: BorderRadius.circular(TossBorderRadius.md),
          border: isSelected && hasValue
              ? Border.all(color: TossColors.gray300)
              : null,
        child: Row(
          children: [
            // Currency code badge
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: TossSpacing.space2,
                vertical: TossSpacing.space1,
                color: TossColors.white,
                borderRadius: BorderRadius.circular(TossBorderRadius.sm),
              child: Text(
                currencyCode,
                style: TossTextStyles.labelMedium.copyWith(
                  color: TossColors.gray700,
            const SizedBox(width: TossSpacing.space2),
            // Exchange rate info
            Expanded(
                '1 = $exchangeRate $baseCurrencyCode',
                style: TossTextStyles.small.copyWith(
                  color: TossColors.gray400,
            // Amount display
            Text(
              hasValue ? '$currencySymbol ${controller!.text}' : 'Tap to enter',
              style: TossTextStyles.bodyMedium.copyWith(
                color: hasValue ? TossColors.gray900 : TossColors.gray400,
            if (!hasValue) ...[
              const SizedBox(width: TossSpacing.space1),
              const Icon(
                Icons.chevron_right,
                size: TossSpacing.iconSM,
            ],
          ],
