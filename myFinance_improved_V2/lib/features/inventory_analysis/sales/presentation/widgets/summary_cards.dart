import 'package:flutter/material.dart';
import 'package:myfinance_improved/shared/themes/index.dart';
import 'package:myfinance_improved/shared/widgets/atoms/display/toss_badge.dart';
import 'package:myfinance_improved/shared/widgets/molecules/cards/toss_card.dart';

import '../../domain/entities/sales_analytics.dart';

/// Summary Cards Widget
/// Horizontal scrollable cards showing Revenue, Margin, Quantity
class SummaryCards extends StatelessWidget {
  final AnalyticsSummary? summary;
  final double? revenueGrowth;
  final double? marginGrowth;
  final double? quantityGrowth;
  final bool isLoading;

  const SummaryCards({
    super.key,
    this.summary,
    this.revenueGrowth,
    this.marginGrowth,
    this.quantityGrowth,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: TossSpacing.space4),
      child: Row(
        children: [
          _SummaryCard(
            title: 'Revenue',
            value: summary?.totalRevenue ?? 0,
            growth: revenueGrowth,
            isLoading: isLoading,
            isCurrency: true,
          ),
          const SizedBox(width: TossSpacing.space3),
          _SummaryCard(
            title: 'Margin',
            value: summary?.totalMargin ?? 0,
            growth: marginGrowth,
            isLoading: isLoading,
            isCurrency: true,
            subtitle: summary != null
                ? '${summary!.avgMarginRate.toStringAsFixed(1)}%'
                : null,
          ),
          const SizedBox(width: TossSpacing.space3),
          _SummaryCard(
            title: 'Quantity',
            value: summary?.totalQuantity ?? 0,
            growth: quantityGrowth,
            isLoading: isLoading,
            isCurrency: false,
          ),
        ],
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  final String title;
  final double value;
  final double? growth;
  final bool isLoading;
  final bool isCurrency;
  final String? subtitle;

  const _SummaryCard({
    required this.title,
    required this.value,
    this.growth,
    this.isLoading = false,
    this.isCurrency = true,
    this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 140,
      child: TossCard(
        padding: const EdgeInsets.all(TossSpacing.space4),
        child: isLoading
            ? _buildShimmer()
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    title,
                    style: TossTextStyles.caption.copyWith(
                      color: TossColors.gray500,
                    ),
                  ),
                  const SizedBox(height: TossSpacing.space1),
                  Text(
                    isCurrency ? _formatCurrency(value) : _formatNumber(value),
                    style: TossTextStyles.h4.copyWith(
                      fontWeight: FontWeight.bold,
                      color: TossColors.gray900,
                    ),
                  ),
                  const SizedBox(height: TossSpacing.space1),
                  if (growth != null) TossGrowthBadge(growthValue: growth!),
                  if (subtitle != null && growth == null)
                    Text(
                      subtitle!,
                      style: TossTextStyles.caption.copyWith(
                        color: TossColors.gray500,
                      ),
                    ),
                ],
              ),
      ),
    );
  }

  Widget _buildShimmer() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 50,
          height: 12,
          decoration: BoxDecoration(
            color: TossColors.gray200,
            borderRadius: BorderRadius.circular(TossBorderRadius.xs),
          ),
        ),
        const SizedBox(height: TossSpacing.space2),
        Container(
          width: 80,
          height: 20,
          decoration: BoxDecoration(
            color: TossColors.gray200,
            borderRadius: BorderRadius.circular(TossBorderRadius.xs),
          ),
        ),
        const SizedBox(height: TossSpacing.space2),
        Container(
          width: 60,
          height: 14,
          decoration: BoxDecoration(
            color: TossColors.gray200,
            borderRadius: BorderRadius.circular(TossBorderRadius.xs),
          ),
        ),
      ],
    );
  }

  String _formatCurrency(double value) {
    if (value.abs() >= 1000000000) {
      return '${(value / 1000000000).toStringAsFixed(1)}B';
    } else if (value.abs() >= 1000000) {
      return '${(value / 1000000).toStringAsFixed(1)}M';
    } else if (value.abs() >= 1000) {
      return '${(value / 1000).toStringAsFixed(1)}K';
    }
    return value.toStringAsFixed(0);
  }

  String _formatNumber(double value) {
    if (value.abs() >= 1000000) {
      return '${(value / 1000000).toStringAsFixed(1)}M';
    } else if (value.abs() >= 1000) {
      return '${(value / 1000).toStringAsFixed(1)}K';
    }
    return value.toStringAsFixed(0);
  }
}
