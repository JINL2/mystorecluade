import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:myfinance_improved/shared/themes/toss_colors.dart';
import 'package:myfinance_improved/shared/themes/toss_spacing.dart';
import 'package:myfinance_improved/shared/themes/toss_text_styles.dart';

import '../../../domain/entities/counter_party.dart';
import '../counter_party_list_item.dart';
import 'package:myfinance_improved/shared/widgets/index.dart';

/// List section widget for displaying counter parties
class CounterPartyListSection extends StatelessWidget {
  final AsyncValue<List<CounterParty>> counterPartiesAsync;
  final void Function(CounterParty counterParty) onEdit;
  final void Function(CounterParty counterParty) onDelete;
  final VoidCallback onRetry;

  const CounterPartyListSection({
    super.key,
    required this.counterPartiesAsync,
    required this.onEdit,
    required this.onDelete,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return counterPartiesAsync.when(
      data: (counterParties) => _buildDataState(context, counterParties),
      loading: () => _buildLoadingState(),
      error: (error, _) => _buildErrorState(error),
    );
  }

  Widget _buildDataState(BuildContext context, List<CounterParty> counterParties) {
    if (counterParties.isEmpty) {
      return SliverFillRemaining(
        hasScrollBody: false,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.people_outline,
                size: TossSpacing.iconXL + 24,
                color: TossColors.textTertiary,
              ),
              const SizedBox(height: TossSpacing.space4),
              Text(
                'No counterparties yet',
                style: TossTextStyles.h3.copyWith(
                  color: TossColors.textSecondary,
                ),
              ),
              const SizedBox(height: TossSpacing.space2),
              Text(
                'Tap the + button to add your first counterparty',
                style: TossTextStyles.body.copyWith(
                  color: TossColors.textTertiary,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return SliverPadding(
      padding: const EdgeInsets.all(TossSpacing.space4),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            final counterParty = counterParties[index];
            return Padding(
              key: ValueKey('counter_party_${counterParty.counterpartyId}'),
              padding: const EdgeInsets.only(bottom: TossSpacing.space3),
              child: CounterPartyListItem(
                key: ValueKey('list_item_${counterParty.counterpartyId}'),
                counterParty: counterParty,
                onEdit: () => onEdit(counterParty),
                onAccountSettings: () => _handleAccountSettings(context, counterParty),
                onDelete: () => onDelete(counterParty),
              ),
            );
          },
          childCount: counterParties.length,
        ),
      ),
    );
  }

  void _handleAccountSettings(BuildContext context, CounterParty counterParty) {
    if (counterParty.isInternal) {
      context.push<void>(
        '/debtAccountSettings/${counterParty.counterpartyId}/${Uri.encodeComponent(counterParty.name)}',
      );
    } else {
      showDialog(
        context: context,
        barrierDismissible: true,
        builder: (context) => TossDialog.error(
          title: 'Not Available',
          message: 'Account settings are only available for internal companies',
          primaryButtonText: 'OK',
          onPrimaryPressed: () => context.pop(),
        ),
      );
    }
  }

  Widget _buildLoadingState() {
    return const SliverFillRemaining(
      child: Center(
        child: TossLoadingView(),
      ),
    );
  }

  Widget _buildErrorState(Object error) {
    return SliverFillRemaining(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              size: TossSpacing.inputHeightLG,
              color: TossColors.error,
            ),
            const SizedBox(height: TossSpacing.space4),
            Text(
              'Failed to load counterparties',
              style: TossTextStyles.h3.copyWith(
                color: TossColors.textPrimary,
              ),
            ),
            const SizedBox(height: TossSpacing.space2),
            Text(
              error.toString(),
              style: TossTextStyles.body.copyWith(
                color: TossColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: TossSpacing.space4),
            TextButton(
              onPressed: onRetry,
              child: Text(
                'Retry',
                style: TossTextStyles.body.copyWith(
                  color: TossColors.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
