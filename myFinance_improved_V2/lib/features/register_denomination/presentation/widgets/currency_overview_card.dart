import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myfinance_improved/shared/themes/toss_animations.dart';
import 'package:myfinance_improved/shared/themes/toss_colors.dart';
import 'package:myfinance_improved/shared/themes/toss_spacing.dart';
import 'package:myfinance_improved/shared/themes/toss_text_styles.dart';

import '../../domain/entities/currency.dart';
import '../../domain/entities/denomination.dart';
import '../providers/currency_providers.dart';
import '../providers/denomination_providers.dart';
import 'add_denomination_bottom_sheet.dart';
import 'currency_overview_card/currency_action_buttons.dart';
import 'currency_overview_card/currency_header.dart';
import 'currency_overview_card/delete_currency_dialog.dart';
import 'denomination_grid.dart';
import 'edit_exchange_rate_bottom_sheet.dart';
import 'package:myfinance_improved/shared/widgets/index.dart';

/// Currency overview card displaying currency info and expandable denominations
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

    return GestureDetector(
      onTap: () => _toggleExpansion(ref),
      child: TossWhiteCard(
        padding: EdgeInsets.zero,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header section
            Padding(
              padding: const EdgeInsets.all(TossSpacing.space5),
              child: CurrencyHeader(
                currency: currency,
                isExpanded: isExpanded,
              ),
            ),

            // Expandable content
            AnimatedCrossFade(
              firstChild: const SizedBox.shrink(),
              secondChild: denominationsAsync.when(
                data: (denominations) => _buildExpandedContent(context, denominations),
                loading: () => const Padding(
                  padding: EdgeInsets.all(TossSpacing.space5),
                  child: Center(child: TossLoadingView()),
                ),
                error: (error, _) => _buildErrorState(),
              ),
              crossFadeState: isExpanded
                  ? CrossFadeState.showSecond
                  : CrossFadeState.showFirst,
              duration: TossAnimations.slow,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExpandedContent(BuildContext context, List<Denomination> denominations) {
    return Column(
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
        CurrencyActionButtons(
          currency: currency,
          onAddDenomination: () => _showAddDenominationSheet(context),
          onEditExchangeRate: () => _showEditExchangeRateSheet(context),
          onDeleteCurrency: () => _showDeleteCurrencyDialog(context),
        ),
        const SizedBox(height: TossSpacing.space5),
      ],
    );
  }

  Widget _buildErrorState() {
    return Padding(
      padding: const EdgeInsets.all(TossSpacing.space5),
      child: Center(
        child: Column(
          children: [
            const Icon(Icons.error_outline, color: TossColors.error, size: 32),
            const SizedBox(height: TossSpacing.space2),
            Text(
              'Failed to load denominations',
              style: TossTextStyles.body.copyWith(color: TossColors.error),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  void _toggleExpansion(WidgetRef ref) {
    ref.read(expandedCurrenciesProvider.notifier).toggle(currency.id);
  }

  void _showAddDenominationSheet(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: TossColors.transparent,
      isScrollControlled: true,
      builder: (context) => AddDenominationBottomSheet(currency: currency),
    );
  }

  void _showEditExchangeRateSheet(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: TossColors.transparent,
      isScrollControlled: true,
      builder: (context) => EditExchangeRateBottomSheet(currency: currency),
    );
  }

  void _showDeleteCurrencyDialog(BuildContext context) {
    DeleteCurrencyDialog(
      currency: currency,
      context: context,
    ).show();
  }
}
