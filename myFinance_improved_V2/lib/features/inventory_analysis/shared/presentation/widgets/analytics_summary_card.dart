import 'package:flutter/material.dart';
import 'package:myfinance_improved/shared/themes/index.dart';
import 'package:myfinance_improved/shared/widgets/molecules/cards/toss_card.dart';

/// Analytics Hub용 요약 카드
/// 4개의 주요 지표를 보여주는 카드 위젯
class AnalyticsSummaryCardWidget extends StatelessWidget {
  final String title;
  final String subtitle;
  final String status; // 'good', 'warning', 'critical'
  final IconData icon;
  final VoidCallback? onTap;
  final Widget? trailing;

  const AnalyticsSummaryCardWidget({
    super.key,
    required this.title,
    required this.subtitle,
    required this.status,
    required this.icon,
    this.onTap,
    this.trailing,
  });

  Color get _statusColor {
    return switch (status) {
      'good' => TossColors.success,
      'warning' => TossColors.warning,
      'critical' => TossColors.error,
      _ => TossColors.gray500,
    };
  }

  Color get _statusBgColor {
    return switch (status) {
      'good' => TossColors.successLight,
      'warning' => TossColors.warningLight,
      'critical' => TossColors.errorLight,
      _ => TossColors.gray100,
    };
  }

  @override
  Widget build(BuildContext context) {
    return TossCard(
      onTap: onTap,
      padding: const EdgeInsets.all(TossSpacing.space4),
      child: Row(
        children: [
          // Status Icon
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: _statusBgColor,
              borderRadius: BorderRadius.circular(TossBorderRadius.md),
            ),
            child: Icon(
              icon,
              color: _statusColor,
              size: 24,
            ),
          ),
          const SizedBox(width: TossSpacing.space3),

          // Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TossTextStyles.body.copyWith(
                    fontWeight: FontWeight.w600,
                    color: TossColors.gray900,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: TossTextStyles.bodySmall.copyWith(
                    color: _statusColor,
                  ),
                ),
              ],
            ),
          ),

          // Trailing
          if (trailing != null) trailing!,
          if (onTap != null)
            const Icon(
              Icons.chevron_right,
              color: TossColors.gray400,
              size: 20,
            ),
        ],
      ),
    );
  }
}
