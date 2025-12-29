import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../../shared/themes/toss_border_radius.dart';
import '../../../../../shared/themes/toss_colors.dart';
import '../../../../../shared/themes/toss_spacing.dart';
import '../../../../../shared/themes/toss_text_styles.dart';

/// Key metrics summary widget for Income Statement
class KeyMetricsSummary extends StatelessWidget {
  final List<dynamic> data;
  final String currencySymbol;

  const KeyMetricsSummary({
    super.key,
    required this.data,
    required this.currencySymbol,
  });

  @override
  Widget build(BuildContext context) {
    final revenue = _findSectionTotal('Revenue');
    final grossProfit = _findSectionTotal('Gross Profit');
    final operatingIncome = _findSectionTotal('Operating Income');
    final netIncome = _findSectionTotal('Net Income');
    final grossMargin = _findSectionTotal('Gross Margin');
    final netMargin = _findSectionTotal('Net Margin');

    return Container(
      padding: const EdgeInsets.all(TossSpacing.space5),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            TossColors.primary.withValues(alpha: 0.08),
            TossColors.primary.withValues(alpha: 0.03),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(TossBorderRadius.xl),
        border: Border.all(
          color: TossColors.primary.withValues(alpha: 0.1),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Text(
            'Net Income',
            style: TossTextStyles.caption.copyWith(
              color: TossColors.gray600,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: TossSpacing.space2),
          Text(
            _formatCurrency(netIncome),
            style: TossTextStyles.h1.copyWith(
              color:
                  _isPositiveAmount(netIncome) ? TossColors.success : TossColors.error,
              fontSize: 32,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: TossSpacing.space4),
          Row(
            children: [
              Expanded(
                child: _MiniCard(
                  label: 'Revenue',
                  value: _formatCurrency(revenue),
                  color: TossColors.primary,
                ),
              ),
              const SizedBox(width: TossSpacing.space3),
              Expanded(
                child: _MiniCard(
                  label: 'Gross Profit',
                  value: _formatCurrency(grossProfit),
                  color: TossColors.success,
                ),
              ),
              const SizedBox(width: TossSpacing.space3),
              Expanded(
                child: _MiniCard(
                  label: 'Operating',
                  value: _formatCurrency(operatingIncome),
                  color: TossColors.info,
                ),
              ),
            ],
          ),
          const SizedBox(height: TossSpacing.space3),
          Row(
            children: [
              Expanded(
                child: _PercentageCard(
                  label: 'Gross Margin',
                  percentage: grossMargin,
                  color: TossColors.success,
                ),
              ),
              const SizedBox(width: TossSpacing.space3),
              Expanded(
                child: _PercentageCard(
                  label: 'Net Margin',
                  percentage: netMargin,
                  color: TossColors.primary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _findSectionTotal(String sectionName) {
    try {
      final section = data.firstWhere(
        (section) => section['section'] == sectionName,
        orElse: () => {'section_total': '0'},
      );
      return section['section_total']?.toString() ?? '0';
    } catch (e) {
      return '0';
    }
  }

  bool _isPositiveAmount(dynamic amount) {
    if (amount == null) return false;

    try {
      if (amount is num) {
        return amount >= 0;
      } else if (amount is String) {
        final parsed = double.tryParse(amount);
        return parsed != null && parsed >= 0;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  String _formatCurrency(dynamic amount) {
    if (amount == null ||
        amount.toString().isEmpty ||
        amount.toString() == 'null') {
      return '$currencySymbol 0';
    }

    try {
      double numericAmount;
      if (amount is num) {
        numericAmount = amount.toDouble();
      } else {
        numericAmount = double.tryParse(amount.toString()) ?? 0.0;
      }

      final formatter = NumberFormat('#,##0', 'en_US');
      final absAmount = numericAmount.abs();
      final formatted = formatter.format(absAmount);

      if (numericAmount < 0) {
        return '-$currencySymbol$formatted';
      }
      return '$currencySymbol$formatted';
    } catch (e) {
      return '$currencySymbol 0';
    }
  }
}

class _MiniCard extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _MiniCard({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(TossSpacing.space3),
      decoration: BoxDecoration(
        color: TossColors.background,
        borderRadius: BorderRadius.circular(TossBorderRadius.md),
      ),
      child: Column(
        children: [
          Text(
            label,
            style: TossTextStyles.caption.copyWith(
              color: TossColors.gray500,
              fontSize: 11,
            ),
          ),
          const SizedBox(height: TossSpacing.space1),
          Text(
            value,
            style: TossTextStyles.bodySmall.copyWith(
              color: color,
              fontWeight: FontWeight.w700,
              fontSize: 12,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _PercentageCard extends StatelessWidget {
  final String label;
  final String percentage;
  final Color color;

  const _PercentageCard({
    required this.label,
    required this.percentage,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(TossSpacing.space3),
      decoration: BoxDecoration(
        color: TossColors.background,
        borderRadius: BorderRadius.circular(TossBorderRadius.md),
      ),
      child: Column(
        children: [
          Text(
            label,
            style: TossTextStyles.caption.copyWith(
              color: TossColors.gray500,
              fontSize: 11,
            ),
          ),
          const SizedBox(height: TossSpacing.space1),
          Text(
            '$percentage%',
            style: TossTextStyles.body.copyWith(
              color: color,
              fontWeight: FontWeight.w700,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}
