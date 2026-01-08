// lib/features/report_control/presentation/pages/templates/daily_attendance/widgets/manager_quality_section.dart

import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../../../../../shared/themes/index.dart';
import '../../../../../domain/entities/templates/daily_attendance/attendance_report.dart';

/// Manager Quality Flags Section
class ManagerQualitySection extends StatelessWidget {
  final List<ManagerQualityFlag> flags;

  const ManagerQualitySection({
    super.key,
    required this.flags,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(TossSpacing.paddingLG),
      decoration: BoxDecoration(
        color: TossColors.white,
        borderRadius: BorderRadius.circular(TossBorderRadius.xl),
        border: Border.all(color: TossColors.gray100),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(TossSpacing.space2),
                decoration: BoxDecoration(
                  color: TossColors.warning.withValues(alpha: TossOpacity.light),
                  borderRadius: BorderRadius.circular(TossBorderRadius.md),
                ),
                child: Icon(
                  LucideIcons.flag,
                  size: TossSpacing.iconSM,
                  color: TossColors.warning,
                ),
              ),
              SizedBox(width: TossSpacing.gapMD),
              Text(
                'Manager Quality Flags',
                style: TossTextStyles.h4.copyWith(
                  color: TossColors.gray900,
                ),
              ),
            ],
          ),

          SizedBox(height: TossSpacing.gapLG),

          // Flags
          ...flags.map((flag) => _buildFlagItem(flag)),
        ],
      ),
    );
  }

  Widget _buildFlagItem(ManagerQualityFlag flag) {
    return Container(
      margin: EdgeInsets.only(bottom: TossSpacing.space2),
      padding: EdgeInsets.all(TossSpacing.paddingSM),
      decoration: BoxDecoration(
        color: TossColors.warning.withValues(alpha: TossOpacity.subtle),
        borderRadius: BorderRadius.circular(TossBorderRadius.md),
        border: Border.all(
          color: TossColors.warning.withValues(alpha: TossOpacity.strong),
          width: 1,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            LucideIcons.alertTriangle,
            size: TossSpacing.iconXS,
            color: TossColors.warning,
          ),
          SizedBox(width: TossSpacing.space2),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  flag.description,
                  style: TossTextStyles.bodySmall.copyWith(
                    color: TossColors.gray800,
                    fontWeight: TossFontWeight.medium,
                  ),
                ),
                if (flag.affectedEmployee != null) ...[
                  SizedBox(height: TossSpacing.space1),
                  Text(
                    'Employee: ${flag.affectedEmployee}',
                    style: TossTextStyles.caption.copyWith(
                      color: TossColors.gray600,
                    ),
                  ),
                ],
                if (flag.manager != null) ...[
                  SizedBox(height: TossSpacing.space1),
                  Text(
                    'Manager: ${flag.manager}',
                    style: TossTextStyles.caption.copyWith(
                      color: TossColors.gray600,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
