import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../../../shared/themes/toss_colors.dart';
import '../../../../../shared/themes/toss_text_styles.dart';
import '../../../../../shared/widgets/common/toss_white_card.dart';

/// Ranking bar showing percentile position with clear labels
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

    return TossWhiteCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header: Name + Weight
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  name,
                  style: TossTextStyles.bodyMedium.copyWith(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: TossColors.primarySurface,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  '${weight}%',
                  style: TossTextStyles.caption.copyWith(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: TossColors.primary,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Value
          Text(
            '$value$unit',
            style: TossTextStyles.body.copyWith(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: TossColors.gray800,
            ),
          ),

          const SizedBox(height: 10),

          // Ranking Bar
          Stack(
            children: [
              // Background
              Container(
                height: 8,
                decoration: BoxDecoration(
                  color: TossColors.gray100,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              // Fill
              FractionallySizedBox(
                widthFactor: (score / 100).clamp(0.0, 1.0),
                child: Container(
                  height: 8,
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),

          // Ranking Label
          Row(
            children: [
              Icon(
                icon,
                size: 14,
                color: color,
              ),
              const SizedBox(width: 6),
              Text(
                rankingLabel,
                style: TossTextStyles.caption.copyWith(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: color,
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
    if (score >= 50) return 'Average (Top 50%)';
    if (score >= 25) return 'Below Average';
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
