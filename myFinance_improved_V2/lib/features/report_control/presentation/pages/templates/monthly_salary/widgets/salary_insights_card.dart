// lib/features/report_control/presentation/pages/templates/monthly_salary/widgets/salary_insights_card.dart

import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../../../../../shared/themes/toss_colors.dart';
import '../domain/entities/monthly_salary_report.dart';

/// AI Insights Card for Salary Report
class SalaryInsightsCard extends StatelessWidget {
  final SalaryInsights insights;

  const SalaryInsightsCard({
    super.key,
    required this.insights,
  });

  @override
  Widget build(BuildContext context) {
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
                  color: const Color(0xFFEDE9FE),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  LucideIcons.sparkles,
                  size: 16,
                  color: Color(0xFF7C3AED),
                ),
              ),
              const SizedBox(width: 10),
              const Text(
                'AI Insights',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: TossColors.gray900,
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Summary
          if (insights.summary.isNotEmpty) ...[
            Text(
              insights.summary,
              style: const TextStyle(
                fontSize: 13,
                color: TossColors.gray700,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 14),
          ],

          // Attention Required
          if (insights.attentionRequired.isNotEmpty) ...[
            _buildSection(
              title: 'Attention Required',
              icon: LucideIcons.alertTriangle,
              color: const Color(0xFFDC2626),
              items: insights.attentionRequired,
            ),
            const SizedBox(height: 12),
          ],

          // Recommendations
          if (insights.recommendations.isNotEmpty)
            _buildSection(
              title: 'Recommendations',
              icon: LucideIcons.lightbulb,
              color: const Color(0xFFF59E0B),
              items: insights.recommendations,
            ),
        ],
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required IconData icon,
    required Color color,
    required List<String> items,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 14, color: color),
            const SizedBox(width: 6),
            Text(
              title,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: color,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ...items.map((item) => Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 4,
                    height: 4,
                    margin: const EdgeInsets.only(top: 6, right: 8),
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: 0.5),
                      shape: BoxShape.circle,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      item,
                      style: const TextStyle(
                        fontSize: 12,
                        color: TossColors.gray600,
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
            )),
      ],
    );
  }
}
