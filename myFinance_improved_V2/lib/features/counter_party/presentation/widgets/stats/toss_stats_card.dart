import 'package:flutter/material.dart';
import 'package:myfinance_improved/shared/themes/toss_colors.dart';
import 'package:myfinance_improved/shared/themes/toss_dimensions.dart';
import 'package:myfinance_improved/shared/themes/toss_font_weight.dart';
import 'package:myfinance_improved/shared/themes/toss_spacing.dart';
import 'package:myfinance_improved/shared/themes/toss_text_styles.dart';
import 'package:myfinance_improved/shared/widgets/index.dart';

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

/// Reusable stats card widget with grid layout
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

    return TossWhiteCard(
      padding: const EdgeInsets.all(TossSpacing.space4),
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
                  fontWeight: TossFontWeight.bold,
                ),
              ),
            ],
          ),

          const SizedBox(height: TossSpacing.space3),

          // Divider
          Container(
            height: TossDimensions.dividerThickness,
            color: TossColors.border,
          ),

          const SizedBox(height: TossSpacing.space3),

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
            if (row != rows.last) const SizedBox(height: TossSpacing.space3),
          ],
        );
      }).toList(),
    );
  }

  Widget _buildStatItem(TossStatItem item) {
    return Column(
      children: [
        Icon(
          item.icon,
          color: item.color,
          size: TossSpacing.iconMD2,
        ),
        const SizedBox(height: TossSpacing.space2),
        Text(
          item.count.toString(),
          style: TossTextStyles.h3.copyWith(
            color: TossColors.textPrimary,
            fontWeight: TossFontWeight.semibold,
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
    return TossWhiteCard(
      padding: const EdgeInsets.all(TossSpacing.space4),
      child: SizedBox(
        height: TossSpacing.space10 * 3.5,
        child: const TossLoadingView(),
      ),
    );
  }

  Widget _buildErrorState() {
    return TossWhiteCard(
      padding: const EdgeInsets.all(TossSpacing.space4),
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
              const SizedBox(height: TossSpacing.space3),
              TossButton.textButton(
                text: 'Retry',
                onPressed: onRetry,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
