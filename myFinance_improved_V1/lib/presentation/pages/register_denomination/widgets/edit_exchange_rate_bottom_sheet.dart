import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../widgets/toss/toss_bottom_sheet.dart';
import '../../../widgets/toss/toss_primary_button.dart';
import '../../../../core/themes/toss_colors.dart';
import '../../../../core/themes/toss_text_styles.dart';
import '../../../../core/themes/toss_spacing.dart';
import '../../../../core/themes/toss_border_radius.dart';
import '../../../../domain/entities/currency.dart';
import '../../../providers/app_state_provider.dart';
import '../../../providers/exchange_rate_provider.dart';
import '../providers/currency_providers.dart';

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
          
      if (companyResult != null && companyResult['base_currency_id'] != null) {
        baseCurrencyId = companyResult['base_currency_id'] as String;
        
        // Query currency_types to get base currency symbol and code
        final currencyResult = await supabase
            .from('currency_types')
            .select('symbol, currency_code')
            .eq('currency_id', baseCurrencyId!)
            .single();
            
        if (currencyResult != null) {
          setState(() {
            baseCurrencySymbol = currencyResult['symbol'] as String;
            baseCurrencyCode = currencyResult['currency_code'] as String;
          });
        }
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
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Latest exchange rate fetched: ${rate.toStringAsFixed(4)}'),
            backgroundColor: TossColors.success,
            duration: const Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          isFetchingRate = false;
        });
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to fetch exchange rate: $e'),
            backgroundColor: TossColors.error,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }
  }

  Future<void> _updateExchangeRate() async {
    final exchangeRateText = exchangeRateController.text.trim();
    
    if (exchangeRateText.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter an exchange rate'),
          backgroundColor: TossColors.error,
        ),
      );
      return;
    }
    
    final exchangeRate = double.tryParse(exchangeRateText);
    if (exchangeRate == null || exchangeRate <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a valid exchange rate'),
          backgroundColor: TossColors.error,
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
      final now = DateTime.now().toIso8601String();
      final today = DateTime.now().toIso8601String().split('T')[0]; // YYYY-MM-DD format

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
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Exchange rate updated successfully for ${widget.currency.code}!'),
            backgroundColor: TossColors.success,
            duration: const Duration(seconds: 2),
          ),
        );
        
        // Close the bottom sheet
        Navigator.of(context).pop();
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
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error updating exchange rate: $e'),
            backgroundColor: TossColors.error,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return TossBottomSheet(
      title: 'Edit Exchange Rate',
      content: Column(
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
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,4}')),
                ],
                enabled: !isFetchingRate,
                style: TossTextStyles.body.copyWith(
                  color: !isFetchingRate ? TossColors.gray900 : TossColors.gray500,
                ),
                cursorColor: TossColors.primary,
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
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation(TossColors.primary),
                        ),
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
    );
  }
}