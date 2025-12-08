// lib/features/report_control/presentation/pages/templates/monthly_salary/widgets/manager_quality_card.dart

import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../../../../../shared/themes/toss_colors.dart';
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
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: TossColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colors.border),
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
                  color: colors.background,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  LucideIcons.shield,
                  size: 16,
                  color: colors.primary,
                ),
              ),
              const SizedBox(width: 10),
              const Expanded(
                child: Text(
                  'Manager Quality',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: TossColors.gray900,
                  ),
                ),
              ),
              // Quality score badge
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: colors.background,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      _getStatusIcon(quality.qualityStatus),
                      size: 14,
                      color: colors.primary,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${quality.qualityScore.toStringAsFixed(0)}%',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: colors.primary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Stats row
          Row(
            children: [
              _buildStat(
                icon: LucideIcons.users,
                label: 'Managers',
                value: '${quality.totalManagers}',
                color: TossColors.gray600,
              ),
              const SizedBox(width: 16),
              _buildStat(
                icon: LucideIcons.alertTriangle,
                label: 'With Issues',
                value: '${quality.managersWithIssues}',
                color: quality.managersWithIssues > 0
                    ? const Color(0xFFDC2626)
                    : const Color(0xFF10B981),
              ),
              const SizedBox(width: 16),
              _buildStat(
                icon: LucideIcons.userX,
                label: 'Self-Approved',
                value: '${quality.selfApprovalCount}',
                color: quality.selfApprovalCount > 0
                    ? const Color(0xFFD97706)
                    : const Color(0xFF10B981),
              ),
            ],
          ),

          // Quality message
          if (quality.qualityMessage.isNotEmpty) ...[
            const SizedBox(height: 14),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: colors.background,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    LucideIcons.info,
                    size: 14,
                    color: colors.primary,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      quality.qualityMessage,
                      style: TextStyle(
                        fontSize: 12,
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
              Icon(icon, size: 12, color: TossColors.gray500),
              const SizedBox(width: 4),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 11,
                  color: TossColors.gray500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
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
          background: const Color(0xFFFEF2F2),
          border: const Color(0xFFFECACA),
          primary: const Color(0xFFDC2626),
          text: const Color(0xFF991B1B),
        );
      case 'warning':
        return _StatusColors(
          background: const Color(0xFFFEFCE8),
          border: const Color(0xFFFEF08A),
          primary: const Color(0xFFD97706),
          text: const Color(0xFF92400E),
        );
      case 'good':
      default:
        return _StatusColors(
          background: const Color(0xFFF0FDF4),
          border: const Color(0xFFBBF7D0),
          primary: const Color(0xFF10B981),
          text: const Color(0xFF166534),
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
