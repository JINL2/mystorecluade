import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../shared/themes/toss_border_radius.dart';
import '../../../../../../shared/themes/toss_colors.dart';
import '../../../../../../shared/themes/toss_spacing.dart';
import '../../../../../../shared/themes/toss_text_styles.dart';
import '../../../../../../shared/widgets/common/toss_white_card.dart';
import '../../../extensions/cash_location_extension.dart';
import '../../../providers/payment_providers.dart';
import '../../../providers/states/payment_method_state.dart';
import '../bottom_sheets/cash_location_bottom_sheet.dart';
import '../helpers/payment_helpers.dart';

/// Cash location selection section widget
class CashLocationSection extends ConsumerWidget {
  const CashLocationSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final paymentState = ref.watch(paymentMethodNotifierProvider);

    return TossWhiteCard(
      padding: const EdgeInsets.all(TossSpacing.space4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          const SizedBox(height: TossSpacing.space3),
          _buildContent(context, ref, paymentState),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        const Icon(
          Icons.location_on,
          color: TossColors.primary,
          size: TossSpacing.iconSM,
        ),
        const SizedBox(width: TossSpacing.space2),
        Text(
          'Cash Location',
          style: TossTextStyles.bodyLarge.copyWith(
            fontWeight: FontWeight.w600,
            color: TossColors.gray900,
          ),
        ),
        Text(
          ' *',
          style: TossTextStyles.bodyLarge.copyWith(
            color: TossColors.error,
          ),
        ),
      ],
    );
  }

  Widget _buildContent(
    BuildContext context,
    WidgetRef ref,
    PaymentMethodState paymentState,
  ) {
    if (paymentState.isLoading) {
      return _buildLoadingState();
    }

    if (paymentState.error != null) {
      return _buildErrorState(ref, paymentState.error!);
    }

    if (paymentState.cashLocations.isEmpty) {
      return _buildEmptyState();
    }

    return _buildLocationSelector(context, ref, paymentState);
  }

  Widget _buildLoadingState() {
    return Container(
      padding: const EdgeInsets.all(TossSpacing.space4),
      child: Row(
        children: [
          const SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: TossColors.primary,
            ),
          ),
          const SizedBox(width: TossSpacing.space3),
          Text(
            'Loading cash locations...',
            style: TossTextStyles.body.copyWith(
              color: TossColors.gray600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(WidgetRef ref, String error) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(TossSpacing.space3),
          decoration: BoxDecoration(
            color: TossColors.error.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(TossBorderRadius.sm),
            border: Border.all(
              color: TossColors.error.withValues(alpha: 0.3),
              width: 1,
            ),
          ),
          child: Row(
            children: [
              const Icon(
                Icons.error_outline,
                color: TossColors.error,
                size: TossSpacing.iconSM,
              ),
              const SizedBox(width: TossSpacing.space2),
              Expanded(
                child: Text(
                  error,
                  style: TossTextStyles.body.copyWith(
                    color: TossColors.error,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: TossSpacing.space2),
        TextButton(
          onPressed: () =>
              ref.read(paymentMethodNotifierProvider.notifier).loadCurrencyData(),
          child: const Text('Retry'),
        ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Container(
      padding: const EdgeInsets.all(TossSpacing.space4),
      child: Column(
        children: [
          const Icon(
            Icons.location_off,
            size: 48,
            color: TossColors.gray400,
          ),
          const SizedBox(height: TossSpacing.space2),
          Text(
            'No cash locations available',
            style: TossTextStyles.body.copyWith(
              color: TossColors.gray600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLocationSelector(
    BuildContext context,
    WidgetRef ref,
    PaymentMethodState paymentState,
  ) {
    return InkWell(
      onTap: () => CashLocationBottomSheet.show(
        context,
        ref,
        paymentState.cashLocations,
      ),
      child: Container(
        padding: const EdgeInsets.all(TossSpacing.space3),
        decoration: BoxDecoration(
          border: Border.all(
            color: paymentState.selectedCashLocation != null
                ? TossColors.primary
                : TossColors.gray300,
            width: 1,
          ),
          borderRadius: BorderRadius.circular(TossBorderRadius.md),
        ),
        child: Row(
          children: [
            if (paymentState.selectedCashLocation != null) ...[
              PaymentHelpers.getCashLocationIcon(
                paymentState.selectedCashLocation!.type,
              ),
              const SizedBox(width: TossSpacing.space2),
            ],
            Expanded(
              child: Text(
                paymentState.selectedCashLocation?.displayName ??
                    'Select cash location...',
                style: TossTextStyles.body.copyWith(
                  color: paymentState.selectedCashLocation != null
                      ? TossColors.gray900
                      : TossColors.gray500,
                ),
              ),
            ),
            const Icon(
              Icons.keyboard_arrow_down,
              color: TossColors.gray500,
              size: TossSpacing.iconMD,
            ),
          ],
        ),
      ),
    );
  }
}
