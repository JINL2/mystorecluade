import 'package:flutter/material.dart';
import '../../../../shared/themes/toss_colors.dart';
import '../../../../shared/themes/toss_spacing.dart';
import '../../../../shared/themes/toss_text_styles.dart';
import '../../../../shared/themes/toss_border_radius.dart';
import '../../../trade_shared/domain/entities/dashboard_summary.dart';
import '../../../trade_shared/presentation/widgets/trade_widgets.dart';

/// Dashboard recent activity section
class DashboardActivitySection extends StatelessWidget {
  final List<RecentActivity> activities;
  final bool isLoading;
  final VoidCallback? onViewAll;

  const DashboardActivitySection({
    super.key,
    required this.activities,
    this.isLoading = false,
    this.onViewAll,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: TossColors.white,
        borderRadius: BorderRadius.circular(TossBorderRadius.lg),
        border: Border.all(
          color: TossColors.gray200,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.all(TossSpacing.space4),
            child: Row(
              children: [
                Icon(
                  Icons.history_outlined,
                  size: 20,
                  color: TossColors.gray600,
                ),
                const SizedBox(width: TossSpacing.space2),
                Expanded(
                  child: Text(
                    'Recent Activity',
                    style: TossTextStyles.bodyMedium.copyWith(
                      fontWeight: FontWeight.w600,
                      color: TossColors.gray900,
                    ),
                  ),
                ),
                if (activities.isNotEmpty && onViewAll != null)
                  TextButton(
                    onPressed: onViewAll,
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: TossSpacing.space2,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'View all',
                          style: TossTextStyles.caption.copyWith(
                            color: TossColors.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Icon(
                          Icons.arrow_forward,
                          size: 14,
                          color: TossColors.primary,
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),

          const Divider(height: 1),

          // Content
          if (isLoading)
            _buildLoadingState()
          else if (activities.isEmpty)
            _buildEmptyState()
          else
            _buildActivityList(),
        ],
      ),
    );
  }

  Widget _buildLoadingState() {
    return Padding(
      padding: const EdgeInsets.all(TossSpacing.space4),
      child: Column(
        children: List.generate(3, (index) {
          return Padding(
            padding: const EdgeInsets.only(bottom: TossSpacing.space3),
            child: Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: TossColors.gray100,
                    borderRadius: BorderRadius.circular(TossBorderRadius.sm),
                  ),
                ),
                const SizedBox(width: TossSpacing.space3),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 120,
                        height: 14,
                        decoration: BoxDecoration(
                          color: TossColors.gray100,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Container(
                        width: 200,
                        height: 12,
                        decoration: BoxDecoration(
                          color: TossColors.gray50,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Padding(
      padding: const EdgeInsets.all(TossSpacing.space6),
      child: Center(
        child: Column(
          children: [
            Icon(
              Icons.history_outlined,
              size: 40,
              color: TossColors.gray300,
            ),
            const SizedBox(height: TossSpacing.space3),
            Text(
              'No recent activity',
              style: TossTextStyles.bodyMedium.copyWith(
                color: TossColors.gray500,
              ),
            ),
            const SizedBox(height: TossSpacing.space1),
            Text(
              'Your trade activities will appear here',
              style: TossTextStyles.caption.copyWith(
                color: TossColors.gray400,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActivityList() {
    return Padding(
      padding: const EdgeInsets.all(TossSpacing.space4),
      child: TradeTimelineWidget(
        activities: activities,
        maxItems: 5,
        onViewAll: onViewAll,
      ),
    );
  }
}
