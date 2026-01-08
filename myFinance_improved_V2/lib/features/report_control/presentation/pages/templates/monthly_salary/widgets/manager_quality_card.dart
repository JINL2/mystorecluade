// lib/features/report_control/presentation/pages/templates/monthly_salary/widgets/manager_quality_card.dart

import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../../../../../shared/themes/index.dart';
import '../domain/entities/monthly_salary_report.dart';

/// Manager Quality Card for Salary Report
///
/// Displays manager quality metrics including:
/// - Quality score
/// - Total managers vs managers with issues
/// - Self-approval count
class ManagerQualityCard extends StatelessWidget {
  final ManagerQuality quality;

  const ManagerQualityCard({
    super.key,
    required this.quality,
  });

  @override
  Widget build(BuildContext context) {
    final colors = _getStatusColors(quality.qualityStatus);

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(TossSpacing.space4),
      decoration: BoxDecoration(
        color: TossColors.white,
        borderRadius: BorderRadius.circular(TossBorderRadius.lg),
        border: Border.all(color: colors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Container(
                width: TossDimensions.avatarMD,
                height: TossDimensions.avatarMD,
                decoration: BoxDecoration(
                  color: colors.background,
                  borderRadius: BorderRadius.circular(TossBorderRadius.md),
                ),
                child: Icon(
                  LucideIcons.shield,
                  size: TossSpacing.iconSM2,
                  color: colors.primary,
                ),
              ),
              SizedBox(width: TossSpacing.space2_5),
              Expanded(
                child: Text(
                  'Manager Quality',
                  style: TossTextStyles.body.copyWith(
                    fontWeight: TossFontWeight.semibold,
                    color: TossColors.gray900,
                  ),
                ),
              ),
              // Quality score badge
              Container(
                padding: EdgeInsets.symmetric(horizontal: TossSpacing.space2, vertical: TossSpacing.space1),
                decoration: BoxDecoration(
                  color: colors.background,
                  borderRadius: BorderRadius.circular(TossBorderRadius.sm),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      _getStatusIcon(quality.qualityStatus),
                      size: TossSpacing.iconXS,
                      color: colors.primary,
                    ),
                    SizedBox(width: TossSpacing.space1),
                    Text(
                      '${quality.qualityScore.toStringAsFixed(0)}%',
                      style: TossTextStyles.bodySmall.copyWith(
                        fontWeight: TossFontWeight.bold,
                        color: colors.primary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          SizedBox(height: TossSpacing.space4),

          // Stats row
          Row(
            children: [
              _buildStat(
                icon: LucideIcons.users,
                label: 'Managers',
                value: '${quality.totalManagers}',
                color: TossColors.gray600,
              ),
              SizedBox(width: TossSpacing.space4),
              _buildStat(
                icon: LucideIcons.alertTriangle,
                label: 'With Issues',
                value: '${quality.managersWithIssues}',
                color: quality.managersWithIssues > 0
                    ? TossColors.red
                    : TossColors.emerald,
              ),
              SizedBox(width: TossSpacing.space4),
              _buildStat(
                icon: LucideIcons.userX,
                label: 'Self-Approved',
                value: '${quality.selfApprovalCount}',
                color: quality.selfApprovalCount > 0
                    ? TossColors.amberDark
                    : TossColors.emerald,
              ),
            ],
          ),

          // Quality message
          if (quality.qualityMessage.isNotEmpty) ...[
            SizedBox(height: TossSpacing.space4),
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(TossSpacing.space3),
              decoration: BoxDecoration(
                color: colors.background,
                borderRadius: BorderRadius.circular(TossBorderRadius.md),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    LucideIcons.info,
                    size: TossSpacing.iconXS,
                    color: colors.primary,
                  ),
                  SizedBox(width: TossSpacing.space2),
                  Expanded(
                    child: Text(
                      quality.qualityMessage,
                      style: TossTextStyles.bodySmall.copyWith(
                        color: colors.text,
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildStat({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: TossSpacing.iconXS2, color: TossColors.gray500),
              SizedBox(width: TossSpacing.space1),
              Text(
                label,
                style: TossTextStyles.labelSmall.copyWith(
                  color: TossColors.gray500,
                ),
              ),
            ],
          ),
          SizedBox(height: TossSpacing.space1),
          Text(
            value,
            style: TossTextStyles.h4.copyWith(
              fontWeight: TossFontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  IconData _getStatusIcon(String status) {
    switch (status) {
      case 'critical':
        return LucideIcons.alertTriangle;
      case 'warning':
        return LucideIcons.alertCircle;
      case 'good':
      default:
        return LucideIcons.checkCircle;
    }
  }

  _StatusColors _getStatusColors(String status) {
    switch (status) {
      case 'critical':
        return _StatusColors(
          background: TossColors.redSurface,
          border: TossColors.redLighter,
          primary: TossColors.red,
          text: TossColors.redDarker,
        );
      case 'warning':
        return _StatusColors(
          background: TossColors.amberSurface,
          border: TossColors.amberBorder,
          primary: TossColors.amberDark,
          text: TossColors.amberText,
        );
      case 'good':
      default:
        return _StatusColors(
          background: TossColors.greenSurface,
          border: TossColors.greenBorder,
          primary: TossColors.emerald,
          text: TossColors.greenDark,
        );
    }
  }
}

class _StatusColors {
  final Color background;
  final Color border;
  final Color primary;
  final Color text;

  _StatusColors({
    required this.background,
    required this.border,
    required this.primary,
    required this.text,
  });
}
