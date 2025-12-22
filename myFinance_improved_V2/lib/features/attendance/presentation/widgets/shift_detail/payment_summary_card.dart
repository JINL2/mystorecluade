import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:myfinance_improved/shared/themes/toss_colors.dart';
import 'package:myfinance_improved/shared/themes/toss_text_styles.dart';

import '../../../domain/entities/shift_card.dart';
import '../../providers/attendance_providers.dart';

/// Payment summary card showing all payment details
class PaymentSummaryCard extends ConsumerWidget {
  final ShiftCard shift;

  const PaymentSummaryCard({
    super.key,
    required this.shift,
  });

  String _formatHours(double hours) {
    final h = hours.floor();
    final m = ((hours - h) * 60).round();
    return '${h}h ${m}m';
  }

  String _formatMoney(double amount, String currencySymbol) {
    final formatter = NumberFormat('#,###', 'en_US');
    return '$currencySymbol${formatter.format(amount.round())}';
  }

  Widget _buildInfoRow({
    required String label,
    required String value,
    TextStyle? labelStyle,
    TextStyle? valueStyle,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: labelStyle ??
              TossTextStyles.bodyLarge.copyWith(
                color: TossColors.gray600,
              ),
        ),
        Text(
          value,
          style: valueStyle ??
              TossTextStyles.bodyLarge.copyWith(
                color: TossColors.gray900,
                fontWeight: FontWeight.w600,
              ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final baseCurrencyAsync = ref.watch(baseCurrencyProvider);
    final currencySymbol = baseCurrencyAsync.when(
      data: (currency) => currency?.symbol ?? '\$',
      loading: () => '\$',
      error: (_, __) => '\$',
    );

    return Column(
      children: [
        _buildInfoRow(
          label: 'Total confirmed time',
          value: _formatHours(shift.paidHours),
        ),
        const SizedBox(height: 12),
        _buildInfoRow(
          label: shift.salaryType == 'monthly' ? 'Monthly salary' : 'Hourly salary',
          value: _formatMoney(shift.salaryAmountValue, currencySymbol),
        ),
        const SizedBox(height: 12),
        Container(
          height: 1,
          color: TossColors.gray100,
        ),
        const SizedBox(height: 12),
        _buildInfoRow(
          label: 'Base pay',
          value: _formatMoney(shift.basePayAmount, currencySymbol),
        ),
        if (shift.bonusAmount != 0) ...[
          const SizedBox(height: 12),
          _buildInfoRow(
            label: 'Bonus pay',
            value: _formatMoney(shift.bonusAmount, currencySymbol),
            valueStyle: shift.bonusAmount < 0
                ? TossTextStyles.bodyLarge.copyWith(
                    color: TossColors.error,
                    fontWeight: FontWeight.w600,
                  )
                : null,
          ),
        ],
        const SizedBox(height: 12),
        _buildInfoRow(
          label: 'Total payment',
          value: _formatMoney(shift.totalPayAmount, currencySymbol),
          labelStyle: TossTextStyles.titleMedium.copyWith(
            color: TossColors.gray900,
            fontWeight: FontWeight.w600,
          ),
          valueStyle: TossTextStyles.titleMedium.copyWith(
            color: TossColors.primary,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}
