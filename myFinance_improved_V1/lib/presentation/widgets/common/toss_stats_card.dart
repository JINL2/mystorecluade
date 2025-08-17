import 'package:flutter/material.dart';
import '../../../core/themes/toss_colors.dart';
import '../../../core/themes/toss_text_styles.dart';
import '../../../core/themes/toss_spacing.dart';
import '../../../core/themes/toss_border_radius.dart';
import '../../../core/themes/toss_shadows.dart';

/// Reusable statistics card component following Toss design system
/// Displays a total count with breakdown items in a grid layout
class TossStatsCard extends StatelessWidget {
  final String title;
  final int totalCount;
  final List<TossStatItem> items;
  final bool isLoading;
  final String? errorMessage;
  final VoidCallback? onRetry;

  const TossStatsCard({
    super.key,
    required this.title,
    required this.totalCount,
    required this.items,
    this.isLoading = false,
    this.errorMessage,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return _buildLoadingState();
    }

    if (errorMessage != null) {
      return _buildErrorState();
    }

    return Container(
      padding: EdgeInsets.all(TossSpacing.space4),
      decoration: BoxDecoration(
        color: TossColors.surface,
        borderRadius: BorderRadius.circular(TossBorderRadius.lg),
        boxShadow: TossShadows.card,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with title and total count
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: TossTextStyles.body.copyWith(
                  color: TossColors.textSecondary,
                ),
              ),
              Text(
                totalCount.toString(),
                style: TossTextStyles.h2.copyWith(
                  color: TossColors.textPrimary,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          
          SizedBox(height: TossSpacing.space3),
          
          // Divider
          Container(
            height: TossSpacing.space0 + 1,
            color: TossColors.borderLight,
          ),
          
          SizedBox(height: TossSpacing.space3),
          
          // Grid of stat items
          _buildStatsGrid(),
        ],
      ),
    );
  }

  Widget _buildStatsGrid() {
    // Split items into rows of 3
    final rows = <List<TossStatItem>>[];
    for (int i = 0; i < items.length; i += 3) {
      final endIndex = (i + 3 > items.length) ? items.length : i + 3;
      rows.add(items.sublist(i, endIndex));
    }

    return Column(
      children: rows.map((row) {
        return Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: row.map((item) => _buildStatItem(item)).toList(),
            ),
            if (row != rows.last) SizedBox(height: TossSpacing.space3),
          ],
        );
      }).toList(),
    );
  }

  Widget _buildStatItem(TossStatItem item) {
    return Column(
      children: [
        Container(
          width: TossSpacing.space10,
          height: TossSpacing.space10,
          decoration: BoxDecoration(
            color: TossColors.gray100,  // Consistent background for all items
            borderRadius: BorderRadius.circular(TossBorderRadius.sm),
          ),
          child: Icon(
            item.icon,
            color: item.color,
            size: TossSpacing.iconSM,
          ),
        ),
        SizedBox(height: TossSpacing.space2),
        Text(
          item.count.toString(),
          style: TossTextStyles.h3.copyWith(
            color: TossColors.textPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
        Text(
          item.label,
          style: TossTextStyles.caption.copyWith(
            color: TossColors.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildLoadingState() {
    return Container(
      height: TossSpacing.space10 * 3.5,
      padding: EdgeInsets.all(TossSpacing.space4),
      decoration: BoxDecoration(
        color: TossColors.surface,
        borderRadius: BorderRadius.circular(TossBorderRadius.lg),
        boxShadow: TossShadows.card,
      ),
      child: Center(
        child: CircularProgressIndicator(
          color: TossColors.primary,
          strokeWidth: TossSpacing.space0 + 2,
        ),
      ),
    );
  }

  Widget _buildErrorState() {
    return Container(
      padding: EdgeInsets.all(TossSpacing.space4),
      decoration: BoxDecoration(
        color: TossColors.surface,
        borderRadius: BorderRadius.circular(TossBorderRadius.lg),
        boxShadow: TossShadows.card,
      ),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              errorMessage ?? 'Failed to load statistics',
              style: TossTextStyles.body.copyWith(
                color: TossColors.error,
              ),
            ),
            if (onRetry != null) ...[
              SizedBox(height: TossSpacing.space3),
              TextButton(
                onPressed: onRetry,
                child: Text(
                  'Retry',
                  style: TossTextStyles.body.copyWith(
                    color: TossColors.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Data class for individual stat items
class TossStatItem {
  final String label;
  final int count;
  final IconData icon;
  final Color color;

  const TossStatItem({
    required this.label,
    required this.count,
    required this.icon,
    required this.color,
  });
}