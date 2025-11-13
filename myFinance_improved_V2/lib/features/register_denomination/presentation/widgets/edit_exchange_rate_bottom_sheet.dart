import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:myfinance_improved/app/providers/app_state_provider.dart';
import 'package:myfinance_improved/shared/themes/index.dart';
import 'package:myfinance_improved/shared/widgets/common/toss_loading_view.dart';
import 'package:myfinance_improved/shared/widgets/common/toss_success_error_dialog.dart';
import 'package:myfinance_improved/shared/widgets/toss/toss_bottom_sheet.dart';
import 'package:myfinance_improved/shared/widgets/toss/toss_primary_button.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/utils/datetime_utils.dart';
import '../../di/providers.dart';
import '../../domain/entities/currency.dart';
import '../providers/exchange_rate_provider.dart';

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
      
      // Query companies table to get base_currency_id
      final companyResult = await supabase
          .from('companies')
          .select('base_currency_id')
          .eq('company_id', companyId)
          .single();
          
      if (companyResult['base_currency_id'] != null) {
        baseCurrencyId = companyResult['base_currency_id'] as String;
        
        // Query currency_types to get base currency symbol and code
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
      
      // Get the current exchange rate from book_exchange_rates table
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

    setState(() {
      isFetchingRate = true;
    });

    try {
      // Note: API gives rate from base to target, so we need to get rate from selected currency to base currency
      final rate = await ref
          .read(exchangeRateServiceProvider)
          .getExchangeRate(widget.currency.code, baseCurrencyCode!);

      if (mounted && rate != null) {
        setState(() {
          exchangeRateController.text = rate.toStringAsFixed(4);
          isFetchingRate = false;
        });
        
        // Show success feedback
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
        setState(() {
          isFetchingRate = false;
        });
        
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
      await showDialog<bool>(
        context: context,
        barrierDismissible: true,
        builder: (context) => TossDialog.error(
          title: 'Invalid Input',
          message: 'Please enter an exchange rate',
          primaryButtonText: 'OK',
        ),
      );
      return;
    }

    final exchangeRate = double.tryParse(exchangeRateText);
    if (exchangeRate == null || exchangeRate <= 0) {
      await showDialog<bool>(
        context: context,
        barrierDismissible: true,
        builder: (context) => TossDialog.error(
          title: 'Invalid Input',
          message: 'Please enter a valid exchange rate',
          primaryButtonText: 'OK',
        ),
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

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

      // Insert new exchange rate record
      await supabase.from('book_exchange_rates').insert({
        'company_id': companyId,
        'from_currency_id': widget.currency.id,
        'to_currency_id': baseCurrencyId!,
        'rate': exchangeRate,
        'rate_date': today,
        'created_by': userId,
        'created_at': now,
      });

      // Show success message
      if (mounted) {
        await showDialog<bool>(
          context: context,
          barrierDismissible: true,
          builder: (context) => TossDialog.success(
            title: 'Success',
            message: 'Exchange rate updated successfully for ${widget.currency.code}!',
            primaryButtonText: 'OK',
          ),
        );

        // Close the bottom sheet
        context.pop();
      }

      // Success haptic feedback
      HapticFeedback.selectionClick();

    } catch (e) {
      setState(() {
        isLoading = false;
      });
      
      // Error haptic feedback
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

  @override
  Widget build(BuildContext context) {
    return TossBottomSheet(
      title: 'Exchange Rate',
      content: LayoutBuilder(
        builder: (context, constraints) {
          final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
          final isKeyboardVisible = keyboardHeight > 0;
          
          return GestureDetector(
            onTap: () {
              // Dismiss keyboard when tapping anywhere outside the text field
              FocusScope.of(context).unfocus();
            },
            behavior: HitTestBehavior.opaque, // Ensure taps on empty areas are detected
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
          Container(
            padding: const EdgeInsets.all(TossSpacing.space4),
            decoration: BoxDecoration(
              color: TossColors.gray50,
              borderRadius: BorderRadius.circular(TossBorderRadius.lg),
              border: Border.all(color: TossColors.gray200),
            ),
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: TossColors.white,
                    borderRadius: BorderRadius.circular(TossBorderRadius.md),
                    border: Border.all(color: TossColors.gray200),
                  ),
                  child: Center(
                    child: Text(
                      widget.currency.flagEmoji,
                      style: TossTextStyles.h3,
                    ),
                  ),
                ),
                const SizedBox(width: TossSpacing.space3),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${widget.currency.code} - ${widget.currency.name}',
                        style: TossTextStyles.body.copyWith(
                          fontWeight: FontWeight.w600,
                          color: TossColors.gray900,
                        ),
                      ),
                      const SizedBox(height: TossSpacing.space1),
                      if (baseCurrencySymbol != null) ...[
                        Text(
                          'Base Currency: $baseCurrencySymbol ($baseCurrencyCode)',
                          style: TossTextStyles.bodySmall.copyWith(
                            color: TossColors.gray500,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: TossSpacing.space5),

          // Current exchange rate info
          if (currentExchangeRate != null) ...[
            Container(
              padding: const EdgeInsets.all(TossSpacing.space3),
              decoration: BoxDecoration(
                color: TossColors.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(TossBorderRadius.md),
                border: Border.all(color: TossColors.primary.withValues(alpha: 0.2)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.info_outline, color: TossColors.primary, size: 20),
                  const SizedBox(width: TossSpacing.space2),
                  Expanded(
                    child: Text(
                      'Current Rate: 1 ${widget.currency.code} = ${currentExchangeRate!.toStringAsFixed(4)} ${baseCurrencySymbol ?? ''}',
                      style: TossTextStyles.bodySmall.copyWith(
                        color: TossColors.primary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: TossSpacing.space4),
          ],

          // Exchange rate input
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Exchange Rate',
                style: TossTextStyles.label.copyWith(
                  color: TossColors.gray700,
                ),
              ),
              const SizedBox(height: TossSpacing.space2),
              TextFormField(
                controller: exchangeRateController,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                  signed: false, // No negative numbers
                ),
                inputFormatters: [
                  // Only allow digits and one decimal point with up to 4 decimal places
                  FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,4}')),
                ],
                textInputAction: TextInputAction.done, // Shows "Done" button on keyboard
                enabled: !isFetchingRate,
                autofocus: false,
                style: TossTextStyles.body.copyWith(
                  color: !isFetchingRate ? TossColors.gray900 : TossColors.gray500,
                  fontSize: 16,
                ),
                cursorColor: TossColors.primary,
                onTapOutside: (event) {
                  // Additional way to dismiss keyboard when tapping outside
                  FocusScope.of(context).unfocus();
                },
                onEditingComplete: () {
                  // Dismiss keyboard when user presses "Done" button
                  FocusScope.of(context).unfocus();
                },
                decoration: InputDecoration(
                  hintText: 'Enter exchange rate',
                  hintStyle: TossTextStyles.body.copyWith(
                    color: TossColors.gray400,
                  ),
                  filled: true,
                  fillColor: !isFetchingRate ? TossColors.gray50 : TossColors.gray100,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(TossBorderRadius.lg),
                    borderSide: BorderSide.none,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(TossBorderRadius.lg),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(TossBorderRadius.lg),
                    borderSide: const BorderSide(
                      color: TossColors.primary,
                      width: 1.5,
                    ),
                  ),
                  disabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(TossBorderRadius.lg),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: TossSpacing.space4,
                    vertical: TossSpacing.space4,
                  ),
                  prefixIcon: const Icon(Icons.swap_horiz, color: TossColors.gray500),
                  suffixText: baseCurrencySymbol,
                  suffixStyle: TossTextStyles.body.copyWith(
                    color: TossColors.gray600,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: TossSpacing.space4),

          // Fetch latest rate button - SMALLER WIDTH, CENTERED, outlined style
          Center(
            child: SizedBox(
              width: 250, // Smaller width like a regular button
              height: 56,
              child: OutlinedButton(
                onPressed: isFetchingRate ? null : _fetchLatestExchangeRate,
                style: OutlinedButton.styleFrom(
                  backgroundColor: TossColors.white,
                  foregroundColor: TossColors.primary,
                  side: const BorderSide(
                    color: TossColors.primary,
                    width: 1.5,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(TossBorderRadius.xl),
                  ),
                  elevation: 0,
                ),
                child: isFetchingRate
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: TossLoadingView(),
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.refresh, size: 20),
                          const SizedBox(width: TossSpacing.space2),
                          Text(
                            'Fetch Latest Rate',
                            style: TossTextStyles.button.copyWith(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: TossColors.primary,
                            ),
                          ),
                        ],
                      ),
              ),
            ),
          ),

          const SizedBox(height: TossSpacing.space4),

          // Update button - FULL WIDTH, primary filled button
          SizedBox(
            width: double.infinity, // Ensure full width
            child: TossPrimaryButton(
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
}