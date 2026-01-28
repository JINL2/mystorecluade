import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:myfinance_improved/app/providers/app_state_provider.dart';
import 'package:myfinance_improved/shared/themes/toss_spacing.dart';

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
      // Use RPC via provider to get base currency info
      final currencyInfo = await ref.read(currencyInfoProvider.future);

      if (currencyInfo.baseCurrencyId != null) {
        setState(() {
          baseCurrencyId = currencyInfo.baseCurrencyId;
          baseCurrencySymbol = currencyInfo.baseCurrencySymbol;
          baseCurrencyCode = currencyInfo.baseCurrencyCode;
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

      if (companyId.isEmpty) return;

      // Use RPC to get current exchange rate
      final currencyRepository = ref.read(currencyRepositoryProvider);
      final result = await currencyRepository.getCurrentExchangeRate(
        companyId,
        widget.currency.id,
      );

      if (result.success && result.currentRate != null) {
        setState(() {
          currentExchangeRate = result.currentRate;
          exchangeRateController.text = currentExchangeRate!.toStringAsFixed(8);
          // Also update base currency info if available from RPC
          if (result.baseCurrencyId != null) {
            baseCurrencyId = result.baseCurrencyId;
          }
          if (result.baseCurrencyCode != null) {
            baseCurrencyCode = result.baseCurrencyCode;
          }
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
        final displayRate = rate.toStringAsFixed(8);
        setState(() {
          exchangeRateController.text = displayRate;
          isFetchingRate = false;
        });

        HapticFeedback.lightImpact();
        await showDialog<bool>(
          context: context,
          barrierDismissible: true,
          builder: (context) => TossDialog.success(
            title: 'Success',
            message: 'Latest exchange rate fetched: $displayRate',
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

      // Use RPC to insert exchange rate
      final currencyRepository = ref.read(currencyRepositoryProvider);
      final result = await currencyRepository.insertExchangeRate(
        companyId: companyId,
        currencyId: widget.currency.id,
        rate: exchangeRate,
        userId: userId,
        rateDate: DateTime.now(),
      );

      if (!result.success) {
        throw Exception(result.error ?? 'Failed to update exchange rate');
      }

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
