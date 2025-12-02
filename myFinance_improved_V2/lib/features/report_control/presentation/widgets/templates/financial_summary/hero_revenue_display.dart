// lib/features/report_control/presentation/widgets/detail/hero_revenue_display.dart

import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../../../../../shared/themes/toss_colors.dart';

/// Hero Revenue Display
///
/// Large prominent display of total revenue with trend indicator.
/// Follows Attendance Stats hero number design pattern.
class HeroRevenueDisplay extends StatelessWidget {
  final String amount;
  final double changePercent;
  final bool isPositiveChange;

  const HeroRevenueDisplay({
    super.key,
    required this.amount,
    required this.changePercent,
    required this.isPositiveChange,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: TossColors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Label
          const Text(
            'Total Revenue Today',
            style: TextStyle(
              fontSize: 14,
              color: TossColors.gray600,
              fontWeight: FontWeight.w500,
            ),
          ),

          const SizedBox(height: 8),

          // Hero number
          Text(
            amount,
            style: const TextStyle(
              fontSize: 36,
              fontWeight: FontWeight.bold,
              color: TossColors.gray900,
              height: 1.2,
            ),
          ),

          const SizedBox(height: 12),

          // Trend indicator
          Row(
            children: [
              Icon(
                isPositiveChange ? LucideIcons.trendingUp : LucideIcons.trendingDown,
                size: 18,
                color: isPositiveChange ? TossColors.success : TossColors.error,
              ),
              const SizedBox(width: 6),
              Text(
                '${isPositiveChange ? '+' : ''}${changePercent.toStringAsFixed(1)}% vs previous',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: isPositiveChange ? TossColors.success : TossColors.error,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
