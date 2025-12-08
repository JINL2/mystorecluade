// lib/features/report_control/presentation/pages/templates/monthly_salary/widgets/salary_notices_card.dart

import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../../../../../shared/themes/toss_colors.dart';
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
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: TossColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: TossColors.gray200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: const Color(0xFFFEF3C7),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  LucideIcons.bell,
                  size: 16,
                  color: Color(0xFFD97706),
                ),
              ),
              const SizedBox(width: 10),
              const Text(
                'Notices',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: TossColors.gray900,
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: TossColors.gray200,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  '${notices.length}',
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: TossColors.gray600,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Notice list
          ...notices.map((notice) => _buildNoticeItem(notice)),
        ],
      ),
    );
  }

  Widget _buildNoticeItem(SalaryNotice notice) {
    final colors = _getNoticeColors(notice.type);

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colors.background,
        borderRadius: BorderRadius.circular(8),
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
                size: 14,
                color: colors.iconColor,
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  notice.title,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: colors.textColor,
                  ),
                ),
              ),
              if (notice.amountFormatted != null)
                Text(
                  notice.amountFormatted!,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: colors.textColor,
                  ),
                ),
            ],
          ),

          if (notice.message.isNotEmpty) ...[
            const SizedBox(height: 6),
            Text(
              notice.message,
              style: const TextStyle(
                fontSize: 12,
                color: TossColors.gray700,
                height: 1.4,
              ),
            ),
          ],

          if (notice.employeeName != null) ...[
            const SizedBox(height: 6),
            Row(
              children: [
                const Icon(
                  LucideIcons.user,
                  size: 12,
                  color: TossColors.gray500,
                ),
                const SizedBox(width: 4),
                Text(
                  notice.employeeName!,
                  style: const TextStyle(
                    fontSize: 11,
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
          background: const Color(0xFFFEF2F2),
          border: const Color(0xFFFECACA),
          icon: LucideIcons.alertTriangle,
          iconColor: const Color(0xFFDC2626),
          textColor: const Color(0xFFDC2626),
        );
      case 'warning':
        return _NoticeColors(
          background: const Color(0xFFFEFCE8),
          border: const Color(0xFFFEF08A),
          icon: LucideIcons.alertCircle,
          iconColor: const Color(0xFFD97706),
          textColor: const Color(0xFFD97706),
        );
      case 'info':
      default:
        return _NoticeColors(
          background: const Color(0xFFF0F9FF),
          border: const Color(0xFFBAE6FD),
          icon: LucideIcons.info,
          iconColor: const Color(0xFF0284C7),
          textColor: const Color(0xFF0284C7),
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
