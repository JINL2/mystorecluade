import 'package:flutter/material.dart';
import 'package:myfinance_improved/shared/themes/index.dart';

/// 상태를 나타내는 뱃지 위젯
/// 'good', 'warning', 'critical' 상태 표시
class AnalyticsStatusBadge extends StatelessWidget {
  final String status;
  final String? label;
  final bool showIcon;
  final bool large;

  const AnalyticsStatusBadge({
    super.key,
    required this.status,
    this.label,
    this.showIcon = true,
    this.large = false,
  });

  Color get _statusColor {
    return switch (status.toLowerCase()) {
      'good' || 'normal' => TossColors.success,
      'warning' => TossColors.warning,
      'critical' || 'error' => TossColors.error,
      _ => TossColors.gray500,
    };
  }

  Color get _statusBgColor {
    return switch (status.toLowerCase()) {
      'good' || 'normal' => TossColors.successLight,
      'warning' => TossColors.warningLight,
      'critical' || 'error' => TossColors.errorLight,
      _ => TossColors.gray100,
    };
  }

  IconData get _statusIcon {
    return switch (status.toLowerCase()) {
      'good' || 'normal' => Icons.check_circle_outline,
      'warning' => Icons.warning_amber_outlined,
      'critical' || 'error' => Icons.error_outline,
      _ => Icons.info_outline,
    };
  }

  String get _defaultLabel {
    return switch (status.toLowerCase()) {
      'good' || 'normal' => '양호',
      'warning' => '주의',
      'critical' || 'error' => '위험',
      _ => '정보',
    };
  }

  @override
  Widget build(BuildContext context) {
    final displayLabel = label ?? _defaultLabel;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: large ? 12 : 8,
        vertical: large ? 6 : 4,
      ),
      decoration: BoxDecoration(
        color: _statusBgColor,
        borderRadius: BorderRadius.circular(large ? 8 : 4),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (showIcon) ...[
            Icon(
              _statusIcon,
              size: large ? 18 : 14,
              color: _statusColor,
            ),
            const SizedBox(width: 4),
          ],
          Text(
            displayLabel,
            style: (large ? TossTextStyles.bodySmall : TossTextStyles.caption).copyWith(
              color: _statusColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

/// Priority 뱃지 (critical, warning, normal)
class PriorityBadge extends StatelessWidget {
  final String priority;

  const PriorityBadge({
    super.key,
    required this.priority,
  });

  @override
  Widget build(BuildContext context) {
    final label = switch (priority.toLowerCase()) {
      'critical' => '긴급',
      'warning' => '주의',
      _ => '보통',
    };

    return AnalyticsStatusBadge(
      status: priority,
      label: label,
      showIcon: false,
    );
  }
}
