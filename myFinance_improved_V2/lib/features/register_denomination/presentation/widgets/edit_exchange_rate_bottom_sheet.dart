import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:myfinance_improved/app/providers/app_state_provider.dart';
import 'package:myfinance_improved/shared/themes/toss_border_radius.dart';
import 'package:myfinance_improved/shared/themes/toss_colors.dart';
import 'package:myfinance_improved/shared/themes/toss_spacing.dart';
import 'package:myfinance_improved/shared/themes/toss_text_styles.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/utils/datetime_utils.dart';
import '../../di/providers.dart';
import '../../domain/entities/currency.dart';
import '../providers/currency_providers.dart';
import 'edit_exchange_rate/currency_info_header.dart';
import 'edit_exchange_rate/current_rate_info.dart';
import 'edit_exchange_rate/exchange_rate_input_field.dart';
import 'package:myfinance_improved/shared/widgets/index.dart';

/// Bottom sheet for editing exchange rates
class EditExchangeRateBottomSheet extends ConsumerStatefulWidget {
  final Currency currency;

  const EditExchangeRateBottomSheet({
    super.key,
    required this.currency,
  });

  @override
  ConsumerState<EditExchangeRateBottomSheet> createState() => _EditExchangeRateBottomSheetState();
}

class _EditExchangeRateBottomSheetState extends ConsumerState<EditExchangeRateBottomSheet> {
  final TextEditingController exchangeRateController = TextEditingController();
  String? baseCurrencyId;
  String? baseCurrencySymbol;
  String? baseCurrencyCode;
  double? currentExchangeRate;
  bool isLoading = false;
  bool isFetchingRate = false;

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  @override
  void dispose() {
    exchangeRateController.dispose();
    super.dispose();
  }

  Future<void> _initializeData() async {
    await _fetchBaseCurrency();
    await _fetchCurrentExchangeRate();
  }

  Future<void> _fetchBaseCurrency() async {
    try {
      final appState = ref.read(appStateProvider);
      final companyId = appState.companyChoosen;

      if (companyId.isEmpty) return;

      final supabase = Supabase.instance.client;

      final companyResult = await supabase
          .from('companies')
          .select('base_currency_id')
          .eq('company_id', companyId)
          .single();

      if (companyResult['base_currency_id'] != null) {
        baseCurrencyId = companyResult['base_currency_id'] as String;

        final currencyResult = await supabase
            .from('currency_types')
            .select('symbol, currency_code')
            .eq('currency_id', baseCurrencyId!)
            .single();

        setState(() {
          baseCurrencySymbol = currencyResult['symbol'] as String;
          baseCurrencyCode = currencyResult['currency_code'] as String;
        });
      }
    } catch (e) {
      debugPrint('Error fetching base currency: $e');
    }
  }

  Future<void> _fetchCurrentExchangeRate() async {
    try {
      final appState = ref.read(appStateProvider);
      final companyId = appState.companyChoosen;

      if (companyId.isEmpty || baseCurrencyId == null) return;

      final supabase = Supabase.instance.client;

      final rateResult = await supabase
          .from('book_exchange_rates')
          .select('rate')
          .eq('company_id', companyId)
          .eq('from_currency_id', widget.currency.id)
          .eq('to_currency_id', baseCurrencyId!)
          .order('created_at', ascending: false)
          .limit(1)
          .maybeSingle();

      if (rateResult != null) {
        setState(() {
          currentExchangeRate = (rateResult['rate'] as num).toDouble();
          exchangeRateController.text = currentExchangeRate!.toStringAsFixed(4);
        });
      }
    } catch (e) {
      debugPrint('Error fetching current exchange rate: $e');
    }
  }

  Future<void> _fetchLatestExchangeRate() async {
    if (baseCurrencyCode == null) return;

    setState(() => isFetchingRate = true);

    try {
      final rate = await ref
          .read(exchangeRateServiceProvider)
          .getExchangeRate(widget.currency.code, baseCurrencyCode!);

      if (mounted && rate != null) {
        setState(() {
          exchangeRateController.text = rate.toStringAsFixed(4);
          isFetchingRate = false;
        });

        HapticFeedback.lightImpact();
        await showDialog<bool>(
          context: context,
          barrierDismissible: true,
          builder: (context) => TossDialog.success(
            title: 'Success',
            message: 'Latest exchange rate fetched: ${rate.toStringAsFixed(4)}',
            primaryButtonText: 'OK',
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() => isFetchingRate = false);

        await showDialog<bool>(
          context: context,
          barrierDismissible: true,
          builder: (context) => TossDialog.error(
            title: 'Error',
            message: 'Failed to fetch exchange rate: $e',
            primaryButtonText: 'OK',
          ),
        );
      }
    }
  }

  Future<void> _updateExchangeRate() async {
    final exchangeRateText = exchangeRateController.text.trim();

    if (exchangeRateText.isEmpty) {
      await _showErrorDialog('Please enter an exchange rate');
      return;
    }

    final exchangeRate = double.tryParse(exchangeRateText);
    if (exchangeRate == null || exchangeRate <= 0) {
      await _showErrorDialog('Please enter a valid exchange rate');
      return;
    }

    setState(() => isLoading = true);

    try {
      final appState = ref.read(appStateProvider);
      final companyId = appState.companyChoosen;
      final userId = appState.user['user_id'] as String;

      if (companyId.isEmpty) {
        throw Exception('No company selected');
      }

      final supabase = Supabase.instance.client;
      final now = DateTimeUtils.nowUtc();
      final today = DateTimeUtils.toDateOnly(DateTime.now());

      await supabase.from('book_exchange_rates').insert({
        'company_id': companyId,
        'from_currency_id': widget.currency.id,
        'to_currency_id': baseCurrencyId!,
        'rate': exchangeRate,
        'rate_date': today,
        'created_by': userId,
        'created_at': now,
      });

      if (mounted) {
        // Invalidate providers first for immediate UI update
        ref.invalidate(companyCurrenciesProvider);
        ref.invalidate(companyCurrenciesStreamProvider);

        await showDialog<bool>(
          context: context,
          barrierDismissible: true,
          builder: (context) => TossDialog.success(
            title: 'Success',
            message: 'Exchange rate updated successfully for ${widget.currency.code}!',
            primaryButtonText: 'OK',
          ),
        );
        context.pop();
      }

      HapticFeedback.selectionClick();
    } catch (e) {
      setState(() => isLoading = false);
      HapticFeedback.heavyImpact();

      if (mounted) {
        await showDialog<bool>(
          context: context,
          barrierDismissible: true,
          builder: (context) => TossDialog.error(
            title: 'Error',
            message: 'Error updating exchange rate: $e',
            primaryButtonText: 'OK',
          ),
        );
      }
    }
  }

  Future<void> _showErrorDialog(String message) async {
    await showDialog<bool>(
      context: context,
      barrierDismissible: true,
      builder: (context) => TossDialog.error(
        title: 'Invalid Input',
        message: message,
        primaryButtonText: 'OK',
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return TossBottomSheet(
      title: 'Exchange Rate',
      content: LayoutBuilder(
        builder: (context, constraints) {
          final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
          final isKeyboardVisible = keyboardHeight > 0;

          return GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            behavior: HitTestBehavior.opaque,
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: isKeyboardVisible
                      ? constraints.maxHeight - keyboardHeight
                      : constraints.maxHeight,
                ),
                child: IntrinsicHeight(
                  child: Padding(
                    padding: EdgeInsets.only(
                      bottom: isKeyboardVisible ? keyboardHeight + 16 : 16,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Currency info header
                        CurrencyInfoHeader(
                          currency: widget.currency,
                          baseCurrencySymbol: baseCurrencySymbol,
                          baseCurrencyCode: baseCurrencyCode,
                        ),

                        const SizedBox(height: TossSpacing.space5),

                        // Current exchange rate info
                        if (currentExchangeRate != null) ...[
                          CurrentRateInfo(
                            currencyCode: widget.currency.code,
                            currentRate: currentExchangeRate!,
                            baseCurrencySymbol: baseCurrencySymbol,
                          ),
                          const SizedBox(height: TossSpacing.space4),
                        ],

                        // Exchange rate input
                        ExchangeRateInputField(
                          controller: exchangeRateController,
                          baseCurrencySymbol: baseCurrencySymbol,
                          isFetchingRate: isFetchingRate,
                        ),

                        const SizedBox(height: TossSpacing.space4),

                        // Fetch latest rate button
                        _buildFetchRateButton(),

                        const SizedBox(height: TossSpacing.space4),

                        // Update button
                        SizedBox(
                          width: double.infinity,
                          child: TossButton.primary(
                            text: 'Update Exchange Rate',
                            onPressed: isLoading ? null : _updateExchangeRate,
                            isLoading: isLoading,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildFetchRateButton() {
    return Center(
      child: TossButton.outlined(
        text: 'Fetch Latest Rate',
        onPressed: isFetchingRate ? null : _fetchLatestExchangeRate,
        leadingIcon: const Icon(Icons.refresh, size: 20),
        isLoading: isFetchingRate,
      ),
    );
  }
}
