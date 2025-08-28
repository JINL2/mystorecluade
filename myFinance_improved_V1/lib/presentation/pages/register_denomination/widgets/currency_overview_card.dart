import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../widgets/toss/toss_card.dart';
import '../../../../core/themes/toss_colors.dart';
import '../../../../core/themes/toss_text_styles.dart';
import '../../../../core/themes/toss_spacing.dart';
import '../../../../core/themes/toss_border_radius.dart';
import '../../../../core/themes/toss_animations.dart';
import '../../../../domain/entities/currency.dart';
import '../providers/currency_providers.dart';
import '../providers/denomination_providers.dart';
import '../../../providers/app_state_provider.dart';
import 'denomination_grid.dart';
import 'add_denomination_bottom_sheet.dart';
import 'edit_exchange_rate_bottom_sheet.dart';

class CurrencyOverviewCard extends ConsumerWidget {
  final Currency currency;

  const CurrencyOverviewCard({
    super.key,
    required this.currency,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final expandedCurrencies = ref.watch(expandedCurrenciesProvider);
    final isExpanded = expandedCurrencies.contains(currency.id);
    final denominationsAsync = ref.watch(effectiveDenominationListProvider(currency.id));

    return TossCard(
      onTap: () => _toggleExpansion(ref),
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header section
          Padding(
            padding: const EdgeInsets.all(TossSpacing.space5),
            child: _buildHeader(isExpanded),
          ),
          
          // Expandable content
          AnimatedCrossFade(
            firstChild: const SizedBox.shrink(),
            secondChild: denominationsAsync.when(
              data: (denominations) => Column(
                children: [
                  Container(
                    height: 1,
                    color: TossColors.gray200,
                    margin: const EdgeInsets.symmetric(horizontal: TossSpacing.space5),
                  ),
                  const SizedBox(height: TossSpacing.space4),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: TossSpacing.space5),
                    child: DenominationGrid(denominations: denominations),
                  ),
                  const SizedBox(height: TossSpacing.space4),
                  _buildActionButtons(context),
                  const SizedBox(height: TossSpacing.space5),
                ],
              ),
              loading: () => const Padding(
                padding: EdgeInsets.all(TossSpacing.space5),
                child: Center(
                  child: CircularProgressIndicator(color: TossColors.primary),
                ),
              ),
              error: (error, _) => Padding(
                padding: const EdgeInsets.all(TossSpacing.space5),
                child: Center(
                  child: const Column(
                    children: [
                      Icon(Icons.error_outline, color: TossColors.error, size: 32),
                      SizedBox(height: TossSpacing.space2),
                      Text(
                        'Failed to load denominations',
                        style: TextStyle(color: TossColors.error),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            crossFadeState: isExpanded 
                ? CrossFadeState.showSecond 
                : CrossFadeState.showFirst,
            duration: TossAnimations.slow,
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(bool isExpanded) {
    // Use Consumer to get denomination count dynamically
    return Consumer(
      builder: (context, ref, _) {
        final denominationsAsync = ref.watch(effectiveDenominationListProvider(currency.id));
        
        return denominationsAsync.when(
          data: (denominations) => _buildHeaderWithDenominations(isExpanded, denominations),
          loading: () => _buildHeaderWithDenominations(isExpanded, []),
          error: (_, __) => _buildHeaderWithDenominations(isExpanded, []),
        );
      },
    );
  }
  
  Widget _buildHeaderWithDenominations(bool isExpanded, List<dynamic> denominations) {
    String rangeText = '';
    if (denominations.isNotEmpty) {
      final values = denominations.map((d) => d.value as double).toList()..sort();
      final minValue = values.first;
      final maxValue = values.last;
      
      if (currency.code == 'USD' || currency.code == 'CAD' || currency.code == 'AUD') {
        if (minValue < 1.0) {
          rangeText = '${(minValue * 100).toInt()}¢ - ${currency.symbol}${maxValue.toInt()}';
        } else {
          rangeText = '${currency.symbol}${minValue.toInt()} - ${currency.symbol}${maxValue.toInt()}';
        }
      } else if (currency.code == 'EUR' || currency.code == 'GBP') {
        if (minValue < 1.0) {
          rangeText = '${(minValue * 100).toInt()}¢ - ${currency.symbol}${maxValue.toInt()}';
        } else {
          rangeText = '${currency.symbol}${minValue.toInt()} - ${currency.symbol}${maxValue.toInt()}';
        }
      } else {
        // For currencies like KRW, JPY that don't have smaller denominations
        rangeText = '${currency.symbol}${minValue.toInt()} - ${currency.symbol}${maxValue.toInt()}';
      }
    }

    return Row(
      children: [
        // Currency flag and info
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: TossColors.gray100,
            borderRadius: BorderRadius.circular(TossBorderRadius.lg),
          ),
          child: Center(
            child: Text(
              currency.flagEmoji,
              style: TossTextStyles.h3,
            ),
          ),
        ),
        const SizedBox(width: TossSpacing.space4),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    currency.code,
                    style: TossTextStyles.body.copyWith(
                      fontWeight: FontWeight.w600,
                      color: TossColors.gray900,
                    ),
                  ),
                  const SizedBox(width: TossSpacing.space2),
                  Text(
                    '- ${currency.name}',
                    style: TossTextStyles.body.copyWith(
                      color: TossColors.gray900,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: TossSpacing.space1),
              Text(
                currency.fullName,
                style: TossTextStyles.bodySmall.copyWith(
                  color: TossColors.gray500,
                ),
              ),
              const SizedBox(height: TossSpacing.space2),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: TossSpacing.space2,
                      vertical: TossSpacing.space1,
                    ),
                    decoration: BoxDecoration(
                      color: TossColors.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(TossBorderRadius.sm),
                    ),
                    child: Text(
                      '${denominations.length} denominations',
                      style: TossTextStyles.caption.copyWith(
                        color: TossColors.primary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const SizedBox(width: TossSpacing.space3),
                  Text(
                    rangeText,
                    style: TossTextStyles.caption.copyWith(
                      color: TossColors.gray400,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        // Expand/collapse icon
        AnimatedRotation(
          turns: isExpanded ? 0.5 : 0,
          duration: TossAnimations.slow,
          child: const Icon(
            Icons.keyboard_arrow_down,
            color: TossColors.gray400,
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Consumer(
      builder: (context, ref, _) {
        return FutureBuilder<bool>(
          future: _isBaseCurrency(ref),
          builder: (context, snapshot) {
            final isBaseCurrency = snapshot.data ?? true; // Default to true to hide Rate button if unsure
            
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: TossSpacing.space5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // Add denomination button
                  Flexible(
                    child: OutlinedButton(
                      onPressed: () => _showAddDenominationSheet(context),
                      style: OutlinedButton.styleFrom(
                        minimumSize: const Size(50, 44),
                        maximumSize: const Size(80, 44),
                        side: const BorderSide(color: TossColors.primary),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(TossBorderRadius.md),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                      ),
                      child: const Icon(
                        Icons.add,
                        size: 20,
                        color: TossColors.primary,
                      ),
                    ),
                  ),
                  
                  // Rate button (only for non-base currencies)
                  if (!isBaseCurrency) ...[
                    const SizedBox(width: TossSpacing.space4),
                    Flexible(
                      child: OutlinedButton(
                        onPressed: () => _showEditExchangeRateSheet(context),
                        style: OutlinedButton.styleFrom(
                          minimumSize: const Size(50, 44),
                          maximumSize: const Size(80, 44),
                          side: const BorderSide(color: TossColors.warning),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(TossBorderRadius.md),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                        ),
                        child: const Icon(
                          Icons.swap_horiz,
                          size: 20,
                          color: TossColors.warning,
                        ),
                      ),
                    ),
                  ],
                  
                  const SizedBox(width: TossSpacing.space4),
                  
                  // Delete currency button
                  Flexible(
                    child: OutlinedButton(
                      onPressed: () => _showDeleteCurrencyDialog(context),
                      style: OutlinedButton.styleFrom(
                        minimumSize: const Size(50, 44),
                        maximumSize: const Size(80, 44),
                        side: const BorderSide(color: TossColors.error),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(TossBorderRadius.md),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                      ),
                      child: const Icon(
                        Icons.delete_outline,
                        size: 20,
                        color: TossColors.error,
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _toggleExpansion(WidgetRef ref) {
    final expandedCurrencies = ref.read(expandedCurrenciesProvider);
    final newSet = Set<String>.from(expandedCurrencies);
    
    if (newSet.contains(currency.id)) {
      newSet.remove(currency.id);
    } else {
      newSet.add(currency.id);
    }
    
    ref.read(expandedCurrenciesProvider.notifier).state = newSet;
  }

  void _showAddDenominationSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => AddDenominationBottomSheet(currency: currency),
    );
  }

  void _showDeleteCurrencyDialog(BuildContext context) async {
    // First check if currency has denominations
    final ref = ProviderScope.containerOf(context);
    final appState = ref.read(appStateProvider);
    final companyId = appState.companyChoosen;
    
    if (companyId.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No company selected'),
          backgroundColor: TossColors.error,
        ),
      );
      return;
    }

    // Check if currency has denominations using the repository
    try {
      final repository = ref.read(currencyRepositoryProvider);
      final hasDenominations = await repository.hasDenominations(companyId, currency.id);
      
      if (hasDenominations) {
        // Show error dialog if denominations exist
        HapticFeedback.heavyImpact();
        
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Row(
              children: [
                const Icon(Icons.error_outline, color: TossColors.error, size: 24),
                const SizedBox(width: TossSpacing.space2),
                Text(
                  'Cannot Remove Currency',
                  style: TossTextStyles.h3.copyWith(
                    fontWeight: FontWeight.w600,
                    color: TossColors.gray900,
                  ),
                ),
              ],
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Cannot remove ${currency.code} - ${currency.name} because it has denominations.',
                  style: TossTextStyles.body.copyWith(
                    color: TossColors.gray700,
                  ),
                ),
                const SizedBox(height: TossSpacing.space3),
                Container(
                  padding: const EdgeInsets.all(TossSpacing.space3),
                  decoration: BoxDecoration(
                    color: TossColors.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(TossBorderRadius.md),
                    border: Border.all(color: TossColors.primary.withValues(alpha: 0.2)),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.info_outline, 
                           color: TossColors.primary, size: 20),
                      const SizedBox(width: TossSpacing.space2),
                      Expanded(
                        child: Text(
                          'Please delete all denominations first by expanding the currency card and removing each denomination.',
                          style: TossTextStyles.bodySmall.copyWith(
                            color: TossColors.primary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text(
                  'Understood',
                  style: TextStyle(
                    color: TossColors.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        );
        return;
      }
      
      // Show confirmation dialog only if no denominations exist
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(
            'Remove Currency',
            style: TossTextStyles.h3.copyWith(
              fontWeight: FontWeight.w600,
              color: TossColors.gray900,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Are you sure you want to remove ${currency.code} - ${currency.name} from your company?',
                style: TossTextStyles.body.copyWith(
                  color: TossColors.gray700,
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text(
                'Cancel',
                style: TextStyle(
                  color: TossColors.gray600,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Consumer(
              builder: (context, ref, _) {
                final currencyOperations = ref.watch(currencyOperationsProvider);
                
                return currencyOperations.maybeWhen(
                  loading: () => TextButton(
                    onPressed: null,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const SizedBox(
                          width: 16,
                          height: 16,
                          child: const CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation(TossColors.error),
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Text('Removing...'),
                      ],
                    ),
                  ),
                  orElse: () => TextButton(
                    onPressed: () {
                      // Check if not already loading before allowing delete
                      final operationState = ref.read(currencyOperationsProvider);
                      if (!operationState.isLoading) {
                        _deleteCurrency(context, ref);
                      }
                    },
                    style: TextButton.styleFrom(
                      foregroundColor: TossColors.error,
                    ),
                    child: const Text(
                      'Remove',
                      style: TextStyle(
                        color: TossColors.error,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      );
      
    } catch (e) {
      // Show error if check fails
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to check currency status: $e'),
          backgroundColor: TossColors.error,
        ),
      );
    }
  }

  /// Check if the current currency is the company's base currency
  Future<bool> _isBaseCurrency(WidgetRef ref) async {
    try {
      final appState = ref.read(appStateProvider);
      final companyId = appState.companyChoosen;
      
      if (companyId.isEmpty) return true; // Default to true if no company selected
      
      final supabase = ref.read(supabaseClientProvider);
      
      // Query companies table to get base_currency_id
      final companyResult = await supabase
          .from('companies')
          .select('base_currency_id')
          .eq('company_id', companyId)
          .single();
      
      final baseCurrencyId = companyResult['base_currency_id'] as String?;
      
      // Return true if current currency is the base currency
      return baseCurrencyId == currency.id;
    } catch (e) {
      debugPrint('Error checking base currency: $e');
      return true; // Default to true (hide Rate button) if there's an error
    }
  }

  /// Show bottom sheet for editing exchange rate
  void _showEditExchangeRateSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => EditExchangeRateBottomSheet(currency: currency),
    );
  }

  void _deleteCurrency(BuildContext context, WidgetRef ref) async {
    // Haptic feedback for delete action
    HapticFeedback.lightImpact();
    
    // Close dialog immediately for better UX
    if (context.mounted) {
      Navigator.of(context).pop();
    }
    
    try {
      final appState = ref.read(appStateProvider);
      final companyId = appState.companyChoosen;
      
      if (companyId.isEmpty) {
        throw Exception('No company selected');
      }
      
      // Remove the currency from company
      await ref.read(currencyOperationsProvider.notifier)
          .removeCompanyCurrency(currency.id);
      
      // Show success message only after successful removal
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${currency.code} currency removed successfully!'),
            backgroundColor: TossColors.success,
            duration: const Duration(seconds: 2),
          ),
        );
      }
      
      // Success haptic feedback
      HapticFeedback.selectionClick();
      
      // Refresh available currencies to add provider
      if (ref.exists(availableCurrenciesToAddProvider)) {
        ref.invalidate(availableCurrenciesToAddProvider);
      }
      
    } catch (e) {
      // Error haptic feedback
      HapticFeedback.heavyImpact();
      
      // Extract error message
      String errorMessage = e.toString();
      if (errorMessage.startsWith('Exception: ')) {
        errorMessage = errorMessage.substring(11);
      }
      
      if (context.mounted) {
        // Show snackbar for errors
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMessage),
            backgroundColor: TossColors.error,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }
  }

}