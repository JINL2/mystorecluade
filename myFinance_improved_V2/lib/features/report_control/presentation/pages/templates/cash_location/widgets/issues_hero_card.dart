// lib/features/report_control/presentation/pages/templates/cash_location/widgets/issues_hero_card.dart

import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../../../../../shared/themes/index.dart';
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
      padding: EdgeInsets.all(TossSpacing.space5),
      decoration: BoxDecoration(
        color: TossColors.white,
        borderRadius: BorderRadius.circular(TossBorderRadius.xl),
        border: Border.all(color: TossColors.gray100),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title row
          Row(
            children: [
              Container(
                width: TossDimensions.avatarLG,
                height: TossDimensions.avatarLG,
                decoration: BoxDecoration(
                  color: _getStatusColor().withValues(alpha: TossOpacity.light),
                  borderRadius: BorderRadius.circular(TossBorderRadius.buttonLarge),
                ),
                child: Icon(
                  _getStatusIcon(),
                  size: TossSpacing.iconMD,
                  color: _getStatusColor(),
                ),
              ),
              SizedBox(width: TossSpacing.space3),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Cash Reconciliation',
                      style: TossTextStyles.bodySmall.copyWith(
                        color: TossColors.gray500,
                        fontWeight: TossFontWeight.medium,
                      ),
                    ),
                    SizedBox(height: TossSpacing.space0_5),
                    Text(
                      '${stats.issuesCount} locations need attention',
                      style: TossTextStyles.body.copyWith(
                        fontWeight: TossFontWeight.semibold,
                        color: TossColors.gray900,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          SizedBox(height: TossSpacing.space5),

          // Net difference (hero number)
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(TossSpacing.space4),
            decoration: BoxDecoration(
              color: TossColors.gray50,
              borderRadius: BorderRadius.circular(TossBorderRadius.lg),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Total Discrepancy',
                  style: TossTextStyles.bodySmall.copyWith(
                    color: TossColors.gray500,
                    fontWeight: TossFontWeight.medium,
                  ),
                ),
                SizedBox(height: TossSpacing.space2),
                Text(
                  stats.netDifferenceFormatted,
                  style: TossTextStyles.h2.copyWith(
                    fontWeight: TossFontWeight.bold,
                    color: stats.netDifference < 0
                        ? TossColors.red
                        : TossColors.amber,
                    height: 1.1,
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: TossSpacing.space4),

          // Filter hint
          if (onFilterChanged != null)
            Padding(
              padding: EdgeInsets.only(bottom: TossSpacing.space2),
              child: Text(
                activeFilter == CashLocationFilter.all
                    ? 'Tap to filter by type'
                    : 'Tap again to clear filter',
                style: TossTextStyles.labelSmall.copyWith(
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
                color: TossColors.red,
                filter: CashLocationFilter.shortage,
                isActive: activeFilter == CashLocationFilter.shortage,
              ),
              SizedBox(width: TossSpacing.space2),
              _buildFilterChip(
                icon: LucideIcons.trendingUp,
                value: '${stats.surplusCount}',
                color: TossColors.amber,
                filter: CashLocationFilter.surplus,
                isActive: activeFilter == CashLocationFilter.surplus,
              ),
              SizedBox(width: TossSpacing.space2),
              _buildFilterChip(
                icon: LucideIcons.checkCircle,
                value: '${stats.balancedCount}',
                color: TossColors.emerald,
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
          duration: TossAnimations.normal,
          padding: EdgeInsets.symmetric(horizontal: TossSpacing.space2_5, vertical: TossSpacing.space2_5),
          decoration: BoxDecoration(
            color: isActive ? color.withValues(alpha: TossOpacity.medium) : color.withValues(alpha: TossOpacity.subtle),
            borderRadius: BorderRadius.circular(TossBorderRadius.md),
            border: Border.all(
              color: isActive ? color : color.withValues(alpha: TossOpacity.strong),
              width: isActive ? 2 : 1,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: TossSpacing.iconXS, color: color),
              SizedBox(width: TossSpacing.space1_5),
              Text(
                value,
                style: TossTextStyles.body.copyWith(
                  fontWeight: TossFontWeight.bold,
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
        return TossColors.emerald;
      case 'minor_issues':
        return TossColors.amber;
      case 'major_issues':
      default:
        return TossColors.red;
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
