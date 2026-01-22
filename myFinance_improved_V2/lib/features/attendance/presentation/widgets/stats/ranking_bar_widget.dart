import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../../../shared/themes/index.dart';
import 'package:myfinance_improved/shared/widgets/index.dart';

/// Compact ranking card for 2x2 grid layout
class RankingBarWidget extends StatelessWidget {
  final String name;
  final String value;
  final String unit;
  final double score;
  final int weight;

  const RankingBarWidget({
    super.key,
    required this.name,
    required this.value,
    required this.unit,
    required this.score,
    required this.weight,
  });

  @override
  Widget build(BuildContext context) {
    final rankingLabel = _getRankingLabel(score);
    final color = _getRankingColor(score);
    final icon = _getRankingIcon(score);

    return TossCard(
      padding: const EdgeInsets.all(TossSpacing.space4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Name
          Text(
            name,
            style: TossTextStyles.captionBold,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),

          SizedBox(height: TossSpacing.space2),

          // Value
          Text(
            '$value$unit',
            style: TossTextStyles.h3,
          ),

          SizedBox(height: TossSpacing.space2),

          // Ranking Label
          Row(
            children: [
              Icon(
                icon,
                size: TossSpacing.iconXS,
                color: color,
              ),
              SizedBox(width: TossSpacing.space1),
              Expanded(
                child: Text(
                  rankingLabel,
                  style: TossTextStyles.smallBold.copyWith(
                    color: color,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _getRankingLabel(double score) {
    if (score >= 90) return 'Top 10%';
    if (score >= 75) return 'Top 25%';
    if (score >= 50) return 'Average';
    if (score >= 25) return 'Below Avg';
    return 'Bottom 25%';
  }

  Color _getRankingColor(double score) {
    if (score >= 75) return TossColors.success;
    if (score >= 50) return TossColors.primary;
    if (score >= 25) return TossColors.warning;
    return TossColors.error;
  }

  IconData _getRankingIcon(double score) {
    if (score >= 75) return LucideIcons.trendingUp;
    if (score >= 50) return LucideIcons.minus;
    return LucideIcons.trendingDown;
  }
}
