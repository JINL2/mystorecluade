import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../../../shared/themes/toss_colors.dart';
import '../../../../../shared/themes/toss_text_styles.dart';
import '../../../../../shared/themes/toss_spacing.dart';
import '../../../../../shared/widgets/toss/toss_bottom_sheet.dart';
import '../../../../../shared/widgets/common/toss_white_card.dart';
import 'reliability_radar_chart.dart';
import 'ranking_bar_widget.dart';

/// Bottom sheet showing reliability score breakdown
/// Matches app's design system - clean, minimal, professional
class ReliabilityScoreBottomSheet extends StatefulWidget {
  final double finalScore;
  final Map<String, dynamic>? scoreBreakdown;

  const ReliabilityScoreBottomSheet({
    super.key,
    required this.finalScore,
    this.scoreBreakdown,
  });

  static Future<void> show({
    required BuildContext context,
    required double finalScore,
    Map<String, dynamic>? scoreBreakdown,
  }) {
    return TossBottomSheet.show(
      context: context,
      content: ReliabilityScoreBottomSheet(
        finalScore: finalScore,
        scoreBreakdown: scoreBreakdown,
      ),
    );
  }

  @override
  State<ReliabilityScoreBottomSheet> createState() => _ReliabilityScoreBottomSheetState();
}

class _ReliabilityScoreBottomSheetState extends State<ReliabilityScoreBottomSheet> {
  bool _isScoreRangeExpanded = false;
  bool _showRadarExplanation = false;

  @override
  Widget build(BuildContext context) {
    if (widget.scoreBreakdown == null) {
      return _buildNoData();
    }

    final criteria = widget.scoreBreakdown!['criteria'] as List<dynamic>? ?? [];
    final reliability = widget.scoreBreakdown!['reliability'] as Map<String, dynamic>?;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title
          Text(
            'Reliability Score',
            style: TossTextStyles.h2.copyWith(
              fontSize: 20,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'How we calculate your reliability',
            style: TossTextStyles.body.copyWith(
              color: TossColors.gray600,
              fontSize: 13,
            ),
          ),

          const SizedBox(height: 20),

          // Score Display Card
          _buildScoreCard(),

          const SizedBox(height: 16),

          // Explanation
          _buildExplanationCard(),

          const SizedBox(height: 20),

          // Radar Chart - Visual Overview
          if (criteria.isNotEmpty) ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Performance Overview',
                  style: TossTextStyles.bodyMedium.copyWith(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: TossColors.gray900,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _showRadarExplanation = !_showRadarExplanation;
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: TossColors.gray100,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          LucideIcons.helpCircle,
                          size: 14,
                          color: TossColors.gray600,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'How to read',
                          style: TossTextStyles.caption.copyWith(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: TossColors.gray700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            if (_showRadarExplanation) ...[
              Container(
                padding: const EdgeInsets.all(12),
                margin: const EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(
                  color: TossColors.infoLight,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'Larger shape = better performance. Each corner represents a different metric.',
                  style: TossTextStyles.caption.copyWith(
                    fontSize: 12,
                    color: TossColors.gray700,
                    height: 1.4,
                  ),
                ),
              ),
            ],
            TossWhiteCard(
              padding: const EdgeInsets.all(20),
              child: ReliabilityRadarChart(
                criteria: criteria.cast<Map<String, dynamic>>(),
              ),
            ),
            const SizedBox(height: 20),
          ],

          // Components
          Text(
            'Detailed Breakdown',
            style: TossTextStyles.bodyMedium.copyWith(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: TossColors.gray900,
            ),
          ),
          const SizedBox(height: 12),

          ...criteria.map((criterion) => _buildCriterionRow(criterion as Map<String, dynamic>)),

          if (reliability != null) ...[
            const SizedBox(height: 16),
            _buildReliabilityNote(reliability),
          ],

          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildNoData() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              LucideIcons.clock,
              size: 48,
              color: TossColors.gray400,
            ),
            const SizedBox(height: 16),
            Text(
              'Not Enough Data',
              style: TossTextStyles.h3.copyWith(
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Complete more shifts to see your score',
              style: TossTextStyles.body.copyWith(
                color: TossColors.gray600,
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildScoreCard() {
    final color = _getScoreColor(widget.finalScore);
    final label = _getScoreLabel(widget.finalScore);

    return TossWhiteCard(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Your Score',
                  style: TossTextStyles.caption.copyWith(
                    fontSize: 12,
                    color: TossColors.gray600,
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      widget.finalScore.toStringAsFixed(1),
                      style: TossTextStyles.display.copyWith(
                        fontSize: 36,
                        fontWeight: FontWeight.w700,
                        color: color,
                        height: 1.0,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: Text(
                        label,
                        style: TossTextStyles.bodyMedium.copyWith(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: color,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              _getScoreIcon(widget.finalScore),
              size: 32,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExplanationCard() {
    return GestureDetector(
      onTap: () {
        setState(() {
          _isScoreRangeExpanded = !_isScoreRangeExpanded;
        });
      },
      child: TossWhiteCard(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              LucideIcons.info,
              size: 20,
              color: TossColors.primary,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Score Range',
                        style: TossTextStyles.bodyMedium.copyWith(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Icon(
                        _isScoreRangeExpanded
                            ? LucideIcons.chevronUp
                            : LucideIcons.chevronDown,
                        size: 18,
                        color: TossColors.gray600,
                      ),
                    ],
                  ),
                  if (_isScoreRangeExpanded) ...[
                    const SizedBox(height: 8),
                    Text(
                      '50 is average\n60+ is above average\n70+ is excellent',
                      style: TossTextStyles.caption.copyWith(
                        fontSize: 12,
                        color: TossColors.gray600,
                        height: 1.5,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCriterionRow(Map<String, dynamic> criterion) {
    final name = criterion['name'] as String? ?? '';
    final value = criterion['value'];
    final unit = criterion['unit'] as String? ?? '';
    final weight = (criterion['weight'] as num?)?.toInt() ?? 0;
    final score = (criterion['score'] as num?)?.toDouble() ?? 0.0;

    final displayValue = value is num ? value.toStringAsFixed(1) : value.toString();

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: RankingBarWidget(
        name: name,
        value: displayValue,
        unit: unit,
        score: score,
        weight: weight,
      ),
    );
  }

  Widget _buildReliabilityNote(Map<String, dynamic> reliability) {
    final reliabilityValue = (reliability['value'] as num?)?.toDouble() ?? 0.0;

    return TossWhiteCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                LucideIcons.shieldCheck,
                size: 18,
                color: TossColors.primary,
              ),
              const SizedBox(width: 8),
              Text(
                'Data Confidence',
                style: TossTextStyles.bodyMedium.copyWith(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Score is adjusted based on your work history. More shifts = higher confidence.',
            style: TossTextStyles.caption.copyWith(
              fontSize: 12,
              color: TossColors.gray600,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Confidence: ${(reliabilityValue * 100).toStringAsFixed(0)}%',
            style: TossTextStyles.body.copyWith(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: TossColors.primary,
            ),
          ),
        ],
      ),
    );
  }

  // Helper methods
  Color _getScoreColor(double score) {
    if (score >= 60) return TossColors.success;
    if (score >= 50) return TossColors.primary;
    if (score >= 40) return TossColors.warning;
    return TossColors.error;
  }

  String _getScoreLabel(double score) {
    if (score >= 60) return 'Excellent';
    if (score >= 50) return 'Good';
    if (score >= 40) return 'Fair';
    return 'Poor';
  }

  IconData _getScoreIcon(double score) {
    if (score >= 60) return LucideIcons.trendingUp;
    if (score >= 50) return LucideIcons.thumbsUp;
    if (score >= 40) return LucideIcons.minus;
    return LucideIcons.trendingDown;
  }
}
