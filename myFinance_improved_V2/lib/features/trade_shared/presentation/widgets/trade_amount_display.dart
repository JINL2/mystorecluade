import 'package:flutter/material.dart';
import '../../../../shared/themes/toss_colors.dart';
import '../../../../shared/themes/toss_border_radius.dart';
import '../../../../shared/themes/toss_spacing.dart';
import '../../../../shared/themes/toss_text_styles.dart';
import '../../domain/entities/trade_amount.dart';

/// Large amount display for headers
class TradeAmountDisplay extends StatelessWidget {
  final String currency;
  final String amount;
  final String? label;
  final Color? color;
  final TextStyle? amountStyle;
  final bool showCurrencySymbol;

  const TradeAmountDisplay({
    super.key,
    required this.currency,
    required this.amount,
    this.label,
    this.color,
    this.amountStyle,
    this.showCurrencySymbol = true,
  });

  @override
  Widget build(BuildContext context) {
    final displayColor = color ?? TossColors.gray900;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (label != null)
          Padding(
            padding: const EdgeInsets.only(bottom: TossSpacing.space1),
            child: Text(
              label!,
              style: TossTextStyles.caption.copyWith(
                color: TossColors.gray500,
              ),
            ),
          ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (showCurrencySymbol)
              Padding(
                padding: const EdgeInsets.only(right: 4),
                child: Text(
                  currency,
                  style: TossTextStyles.bodyMedium.copyWith(
                    color: displayColor.withOpacity(0.7),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            Text(
              amount,
              style: amountStyle ??
                  TossTextStyles.h1.copyWith(
                    color: displayColor,
                    fontWeight: FontWeight.w700,
                  ),
            ),
          ],
        ),
      ],
    );
  }
}

/// Amount with comparison (e.g., used vs total)
class TradeAmountComparison extends StatelessWidget {
  final String currency;
  final String currentAmount;
  final String totalAmount;
  final String? label;
  final double? progress;

  const TradeAmountComparison({
    super.key,
    required this.currency,
    required this.currentAmount,
    required this.totalAmount,
    this.label,
    this.progress,
  });

  @override
  Widget build(BuildContext context) {
    final progressValue = progress ?? 0.0;
    final progressColor = progressValue >= 0.9
        ? TossColors.error
        : progressValue >= 0.7
            ? TossColors.warning
            : TossColors.success;

    return Container(
      padding: const EdgeInsets.all(TossSpacing.space4),
      decoration: BoxDecoration(
        color: TossColors.white,
        borderRadius: BorderRadius.circular(TossBorderRadius.lg),
        border: Border.all(
          color: TossColors.gray200,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (label != null)
            Text(
              label!,
              style: TossTextStyles.caption.copyWith(
                color: TossColors.gray500,
              ),
            ),
          const SizedBox(height: TossSpacing.space2),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              TradeAmountDisplay(
                currency: currency,
                amount: currentAmount,
                amountStyle: TossTextStyles.h2.copyWith(
                  color: progressColor,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(width: TossSpacing.space2),
              Text(
                '/',
                style: TossTextStyles.h3.copyWith(
                  color: TossColors.gray300,
                ),
              ),
              const SizedBox(width: TossSpacing.space2),
              Text(
                '$currency $totalAmount',
                style: TossTextStyles.bodyMedium.copyWith(
                  color: TossColors.gray500,
                ),
              ),
            ],
          ),
          const SizedBox(height: TossSpacing.space3),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: progressValue.clamp(0.0, 1.0),
              backgroundColor: TossColors.gray200,
              valueColor: AlwaysStoppedAnimation<Color>(progressColor),
              minHeight: 6,
            ),
          ),
          const SizedBox(height: TossSpacing.space1),
          Text(
            '${(progressValue * 100).toStringAsFixed(1)}% used',
            style: TossTextStyles.caption.copyWith(
              color: progressColor,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

/// L/C Amount with tolerance display
class TradeLCAmountDisplay extends StatelessWidget {
  final LCAmount lcAmount;
  final String? label;
  final bool showDetails;

  const TradeLCAmountDisplay({
    super.key,
    required this.lcAmount,
    this.label,
    this.showDetails = true,
  });

  bool get _hasTolerance =>
      lcAmount.tolerancePlusPercent > 0 || lcAmount.toleranceMinusPercent > 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(TossSpacing.space4),
      decoration: BoxDecoration(
        color: TossColors.white,
        borderRadius: BorderRadius.circular(TossBorderRadius.lg),
        border: Border.all(
          color: TossColors.gray200,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (label != null)
            Text(
              label!,
              style: TossTextStyles.caption.copyWith(
                color: TossColors.gray500,
              ),
            ),
          const SizedBox(height: TossSpacing.space2),
          TradeAmountDisplay(
            currency: lcAmount.currencyCode,
            amount: _formatNumber(lcAmount.amount),
            amountStyle: TossTextStyles.h2.copyWith(
              color: TossColors.gray900,
              fontWeight: FontWeight.w700,
            ),
          ),
          if (_hasTolerance && showDetails) ...[
            const SizedBox(height: TossSpacing.space3),
            _buildToleranceInfo(),
          ],
          if (lcAmount.amountUtilized > 0 && showDetails) ...[
            const SizedBox(height: TossSpacing.space3),
            _buildDrawnProgress(),
          ],
        ],
      ),
    );
  }

  Widget _buildToleranceInfo() {
    return Container(
      padding: const EdgeInsets.all(TossSpacing.space3),
      decoration: BoxDecoration(
        color: TossColors.gray50,
        borderRadius: BorderRadius.circular(TossBorderRadius.sm),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Tolerance',
                style: TossTextStyles.caption.copyWith(
                  color: TossColors.gray500,
                ),
              ),
              Text(
                '+${lcAmount.tolerancePlusPercent}% / -${lcAmount.toleranceMinusPercent}%',
                style: TossTextStyles.bodySmall.copyWith(
                  fontWeight: FontWeight.w600,
                  color: TossColors.gray700,
                ),
              ),
            ],
          ),
          const SizedBox(height: TossSpacing.space2),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildRangeItem('Min', lcAmount.minAcceptable, TossColors.error),
              _buildRangeItem('Max', lcAmount.maxDrawable, TossColors.success),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRangeItem(String label, double amount, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TossTextStyles.caption.copyWith(
            color: TossColors.gray500,
          ),
        ),
        Text(
          '${lcAmount.currencyCode} ${_formatNumber(amount)}',
          style: TossTextStyles.bodySmall.copyWith(
            color: color,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildDrawnProgress() {
    final progressPercent = lcAmount.amountUtilized / lcAmount.amount;
    final statusColor = _getStatusColor(progressPercent);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Utilized Amount',
              style: TossTextStyles.caption.copyWith(
                color: TossColors.gray500,
              ),
            ),
            Text(
              '${lcAmount.currencyCode} ${_formatNumber(lcAmount.amountUtilized)}',
              style: TossTextStyles.bodySmall.copyWith(
                fontWeight: FontWeight.w600,
                color: statusColor,
              ),
            ),
          ],
        ),
        const SizedBox(height: TossSpacing.space2),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: progressPercent.clamp(0.0, 1.0),
            backgroundColor: TossColors.gray200,
            valueColor: AlwaysStoppedAnimation<Color>(statusColor),
            minHeight: 6,
          ),
        ),
        const SizedBox(height: TossSpacing.space2),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Remaining',
              style: TossTextStyles.caption.copyWith(
                color: TossColors.gray500,
              ),
            ),
            Text(
              '${lcAmount.currencyCode} ${_formatNumber(lcAmount.remainingDrawable)}',
              style: TossTextStyles.caption.copyWith(
                fontWeight: FontWeight.w600,
                color: TossColors.gray700,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Color _getStatusColor(double progressPercent) {
    if (progressPercent >= 1.0) {
      return TossColors.error;
    } else if (progressPercent >= 0.8) {
      return TossColors.warning;
    } else {
      return TossColors.success;
    }
  }

  String _formatNumber(double number) {
    if (number >= 1000000) {
      return '${(number / 1000000).toStringAsFixed(2)}M';
    } else if (number >= 1000) {
      return '${(number / 1000).toStringAsFixed(2)}K';
    }
    return number.toStringAsFixed(2);
  }
}

/// Inline currency tag
class TradeCurrencyTag extends StatelessWidget {
  final String currency;
  final bool isActive;

  const TradeCurrencyTag({
    super.key,
    required this.currency,
    this.isActive = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: TossSpacing.space2,
        vertical: 4,
      ),
      decoration: BoxDecoration(
        color: isActive
            ? TossColors.primary.withOpacity(0.1)
            : TossColors.gray100,
        borderRadius: BorderRadius.circular(TossBorderRadius.xs),
        border: isActive
            ? Border.all(
                color: TossColors.primary.withOpacity(0.3),
                width: 1,
              )
            : null,
      ),
      child: Text(
        currency,
        style: TossTextStyles.caption.copyWith(
          color: isActive ? TossColors.primary : TossColors.gray600,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

/// Amount change indicator
class TradeAmountChange extends StatelessWidget {
  final double changePercent;
  final String? label;

  const TradeAmountChange({
    super.key,
    required this.changePercent,
    this.label,
  });

  @override
  Widget build(BuildContext context) {
    final isPositive = changePercent >= 0;
    final color = isPositive ? TossColors.success : TossColors.error;
    final icon = isPositive ? Icons.trending_up : Icons.trending_down;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          size: 16,
          color: color,
        ),
        const SizedBox(width: 4),
        Text(
          '${isPositive ? '+' : ''}${changePercent.toStringAsFixed(1)}%',
          style: TossTextStyles.caption.copyWith(
            color: color,
            fontWeight: FontWeight.w600,
          ),
        ),
        if (label != null) ...[
          const SizedBox(width: 4),
          Text(
            label!,
            style: TossTextStyles.caption.copyWith(
              color: TossColors.gray500,
            ),
          ),
        ],
      ],
    );
  }
}
