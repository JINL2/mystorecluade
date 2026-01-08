// lib/features/report_control/presentation/pages/templates/monthly_salary/widgets/salary_notices_card.dart

import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../../../../../shared/themes/index.dart';
import '../domain/entities/monthly_salary_report.dart';

/// Notices Card for Salary Report
///
/// Displays important notices with type-based styling:
/// - critical: Red alert style
/// - warning: Yellow/orange style
/// - info: Blue/gray style
class SalaryNoticesCard extends StatelessWidget {
  final List<SalaryNotice> notices;

  const SalaryNoticesCard({
    super.key,
    required this.notices,
  });

  @override
  Widget build(BuildContext context) {
    if (notices.isEmpty) return const SizedBox.shrink();

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(TossSpacing.space4),
      decoration: BoxDecoration(
        color: TossColors.white,
        borderRadius: BorderRadius.circular(TossBorderRadius.lg),
        border: Border.all(color: TossColors.gray200),
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
                  color: TossColors.amberLight,
                  borderRadius: BorderRadius.circular(TossBorderRadius.md),
                ),
                child: const Icon(
                  LucideIcons.bell,
                  size: TossSpacing.iconSM2,
                  color: TossColors.amberDark,
                ),
              ),
              SizedBox(width: TossSpacing.space2_5),
              Text(
                'Notices',
                style: TossTextStyles.body.copyWith(
                  fontWeight: TossFontWeight.semibold,
                  color: TossColors.gray900,
                ),
              ),
              SizedBox(width: TossSpacing.space2),
              Container(
                padding: EdgeInsets.symmetric(horizontal: TossSpacing.badgePaddingHorizontalXS, vertical: TossSpacing.badgePaddingVerticalXS),
                decoration: BoxDecoration(
                  color: TossColors.gray200,
                  borderRadius: BorderRadius.circular(TossBorderRadius.buttonLarge),
                ),
                child: Text(
                  '${notices.length}',
                  style: TossTextStyles.labelSmall.copyWith(
                    fontWeight: TossFontWeight.semibold,
                    color: TossColors.gray600,
                  ),
                ),
              ),
            ],
          ),

          SizedBox(height: TossSpacing.space4),

          // Notice list
          ...notices.map((notice) => _buildNoticeItem(notice)),
        ],
      ),
    );
  }

  Widget _buildNoticeItem(SalaryNotice notice) {
    final colors = _getNoticeColors(notice.type);

    return Container(
      margin: const EdgeInsets.only(bottom: TossSpacing.space2 + TossSpacing.space1 / 2),
      padding: EdgeInsets.all(TossSpacing.space3),
      decoration: BoxDecoration(
        color: colors.background,
        borderRadius: BorderRadius.circular(TossBorderRadius.md),
        border: Border.all(color: colors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title row with icon
          Row(
            children: [
              Icon(
                colors.icon,
                size: TossSpacing.iconXS,
                color: colors.iconColor,
              ),
              SizedBox(width: TossSpacing.space1_5),
              Expanded(
                child: Text(
                  notice.title,
                  style: TossTextStyles.bodySmall.copyWith(
                    fontWeight: TossFontWeight.semibold,
                    color: colors.textColor,
                  ),
                ),
              ),
              if (notice.amountFormatted != null)
                Text(
                  notice.amountFormatted!,
                  style: TossTextStyles.bodySmall.copyWith(
                    fontWeight: TossFontWeight.semibold,
                    color: colors.textColor,
                  ),
                ),
            ],
          ),

          if (notice.message.isNotEmpty) ...[
            SizedBox(height: TossSpacing.space1_5),
            Text(
              notice.message,
              style: TossTextStyles.bodySmall.copyWith(
                color: TossColors.gray700,
                height: 1.4,
              ),
            ),
          ],

          if (notice.employeeName != null) ...[
            SizedBox(height: TossSpacing.space1_5),
            Row(
              children: [
                const Icon(
                  LucideIcons.user,
                  size: TossSpacing.iconXS2,
                  color: TossColors.gray500,
                ),
                SizedBox(width: TossSpacing.space1),
                Text(
                  notice.employeeName!,
                  style: TossTextStyles.labelSmall.copyWith(
                    color: TossColors.gray500,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  _NoticeColors _getNoticeColors(String type) {
    switch (type) {
      case 'critical':
        return _NoticeColors(
          background: TossColors.redSurface,
          border: TossColors.redLighter,
          icon: LucideIcons.alertTriangle,
          iconColor: TossColors.red,
          textColor: TossColors.red,
        );
      case 'warning':
        return _NoticeColors(
          background: TossColors.yellowSurface,
          border: TossColors.yellowBorder,
          icon: LucideIcons.alertCircle,
          iconColor: TossColors.amberDark,
          textColor: TossColors.amberDark,
        );
      case 'info':
      default:
        return _NoticeColors(
          background: TossColors.blueSurface,
          border: TossColors.blueBorder,
          icon: LucideIcons.info,
          iconColor: TossColors.blueText,
          textColor: TossColors.blueText,
        );
    }
  }
}

class _NoticeColors {
  final Color background;
  final Color border;
  final IconData icon;
  final Color iconColor;
  final Color textColor;

  _NoticeColors({
    required this.background,
    required this.border,
    required this.icon,
    required this.iconColor,
    required this.textColor,
  });
}
