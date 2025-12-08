// lib/features/report_control/presentation/pages/templates/cash_location/widgets/issues_hero_card.dart

import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../../../../../shared/themes/toss_colors.dart';
import '../domain/entities/cash_location_report.dart';

/// Filter type for cash location issues
enum CashLocationFilter {
  all,      // Show all issues (shortages + surpluses)
  shortage, // Show only shortages
  surplus,  // Show only surpluses
  balanced, // Show balanced (no issues)
}

/// Simplified hero card with clickable filter chips
///
/// Clean design with interactive filters
class IssuesHeroCard extends StatelessWidget {
  final CashLocationHeroStats stats;
  final CashLocationFilter activeFilter;
  final ValueChanged<CashLocationFilter>? onFilterChanged;

  const IssuesHeroCard({
    super.key,
    required this.stats,
    this.activeFilter = CashLocationFilter.all,
    this.onFilterChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: TossColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: TossColors.gray200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title row
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: _getStatusColor().withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  _getStatusIcon(),
                  size: 20,
                  color: _getStatusColor(),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Cash Reconciliation',
                      style: TextStyle(
                        fontSize: 12,
                        color: TossColors.gray500,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${stats.issuesCount} locations need attention',
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: TossColors.gray900,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Net difference (hero number)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: TossColors.gray50,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  'Total Discrepancy',
                  style: TextStyle(
                    fontSize: 12,
                    color: TossColors.gray500,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  stats.netDifferenceFormatted,
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: stats.netDifference < 0
                        ? const Color(0xFFDC2626)
                        : const Color(0xFFF59E0B),
                    height: 1.1,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Filter hint
          if (onFilterChanged != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Text(
                activeFilter == CashLocationFilter.all
                    ? 'Tap to filter by type'
                    : 'Tap again to clear filter',
                style: const TextStyle(
                  fontSize: 11,
                  color: TossColors.gray400,
                ),
              ),
            ),

          // Clickable stat chips
          Row(
            children: [
              _buildFilterChip(
                icon: LucideIcons.trendingDown,
                value: '${stats.shortageCount}',
                color: const Color(0xFFDC2626),
                filter: CashLocationFilter.shortage,
                isActive: activeFilter == CashLocationFilter.shortage,
              ),
              const SizedBox(width: 8),
              _buildFilterChip(
                icon: LucideIcons.trendingUp,
                value: '${stats.surplusCount}',
                color: const Color(0xFFF59E0B),
                filter: CashLocationFilter.surplus,
                isActive: activeFilter == CashLocationFilter.surplus,
              ),
              const SizedBox(width: 8),
              _buildFilterChip(
                icon: LucideIcons.checkCircle,
                value: '${stats.balancedCount}',
                color: const Color(0xFF10B981),
                filter: CashLocationFilter.balanced,
                isActive: activeFilter == CashLocationFilter.balanced,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip({
    required IconData icon,
    required String value,
    required Color color,
    required CashLocationFilter filter,
    required bool isActive,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onFilterChanged != null
            ? () {
                // Toggle: if already active, clear filter; otherwise set filter
                if (isActive) {
                  onFilterChanged!(CashLocationFilter.all);
                } else {
                  onFilterChanged!(filter);
                }
              }
            : null,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          decoration: BoxDecoration(
            color: isActive ? color.withValues(alpha: 0.15) : color.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isActive ? color : color.withValues(alpha: 0.2),
              width: isActive ? 2 : 1,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 14, color: color),
              const SizedBox(width: 6),
              Text(
                value,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getStatusColor() {
    switch (stats.overallStatus) {
      case 'all_balanced':
        return const Color(0xFF10B981);
      case 'minor_issues':
        return const Color(0xFFF59E0B);
      case 'major_issues':
      default:
        return const Color(0xFFDC2626);
    }
  }

  IconData _getStatusIcon() {
    switch (stats.overallStatus) {
      case 'all_balanced':
        return LucideIcons.checkCircle;
      case 'minor_issues':
        return LucideIcons.alertTriangle;
      case 'major_issues':
      default:
        return LucideIcons.alertOctagon;
    }
  }
}
