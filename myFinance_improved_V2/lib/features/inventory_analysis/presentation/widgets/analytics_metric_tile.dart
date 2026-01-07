import 'package:flutter/material.dart';
import 'package:myfinance_improved/shared/themes/index.dart';

/// 단일 지표를 표시하는 타일 위젯
/// Hub 페이지의 Grid나 상세 페이지에서 사용
class AnalyticsMetricTile extends StatelessWidget {
  final String label;
  final String value;
  final String? subValue;
  final String? trend; // '+5.2%', '-3.1%'
  final IconData? icon;
  final Color? valueColor;
  final bool compact;

  const AnalyticsMetricTile({
    super.key,
    required this.label,
    required this.value,
    this.subValue,
    this.trend,
    this.icon,
    this.valueColor,
    this.compact = false,
  });

  Color? get _trendColor {
    if (trend == null) return null;
    if (trend!.startsWith('+')) return TossColors.success;
    if (trend!.startsWith('-')) return TossColors.error;
    return TossColors.gray600;
  }

  @override
  Widget build(BuildContext context) {
    if (compact) {
      return _buildCompact();
    }
    return _buildDefault();
  }

  Widget _buildDefault() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label
        Row(
          children: [
            if (icon != null) ...[
              Icon(icon, size: 16, color: TossColors.gray500),
              const SizedBox(width: 4),
            ],
            Text(
              label,
              style: TossTextStyles.caption.copyWith(
                color: TossColors.gray600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),

        // Value
        Row(
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            Text(
              value,
              style: TossTextStyles.h3.copyWith(
                color: valueColor ?? TossColors.gray900,
                fontWeight: FontWeight.bold,
              ),
            ),
            if (trend != null) ...[
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 6,
                  vertical: 2,
                ),
                decoration: BoxDecoration(
                  color: _trendColor?.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  trend!,
                  style: TossTextStyles.caption.copyWith(
                    color: _trendColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ],
        ),

        // Sub Value
        if (subValue != null) ...[
          const SizedBox(height: 2),
          Text(
            subValue!,
            style: TossTextStyles.caption.copyWith(
              color: TossColors.gray500,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildCompact() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            if (icon != null) ...[
              Icon(icon, size: 16, color: TossColors.gray500),
              const SizedBox(width: 4),
            ],
            Text(
              label,
              style: TossTextStyles.bodySmall.copyWith(
                color: TossColors.gray600,
              ),
            ),
          ],
        ),
        Row(
          children: [
            Text(
              value,
              style: TossTextStyles.body.copyWith(
                color: valueColor ?? TossColors.gray900,
                fontWeight: FontWeight.w600,
              ),
            ),
            if (trend != null) ...[
              const SizedBox(width: 6),
              Text(
                trend!,
                style: TossTextStyles.caption.copyWith(
                  color: _trendColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ],
        ),
      ],
    );
  }
}
