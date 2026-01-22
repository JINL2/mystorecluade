import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../../../shared/themes/index.dart';
import 'reliability_radar_chart.dart';
import 'ranking_bar_widget.dart';
import 'package:myfinance_improved/shared/widgets/index.dart';

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
            style: TossTextStyles.h3,
          ),
          SizedBox(height: TossSpacing.space1),
          Text(
            'How we calculate your reliability',
            style: TossTextStyles.captionGray600,
          ),

          SizedBox(height: TossSpacing.space5),

          // Score Display Card
          _buildScoreCard(),

          SizedBox(height: TossSpacing.space5),

          // Radar Chart - Visual Overview
          if (criteria.isNotEmpty) ...[
            Text(
              'Performance Overview',
              style: TossTextStyles.bodyMedium,
            ),
            SizedBox(height: TossSpacing.gapMD),
            TossCard(
              padding: EdgeInsets.symmetric(vertical: TossSpacing.space4),
              showBorder: false,
              child: Column(
                children: [
                  SizedBox(height: TossSpacing.space4),
                  ReliabilityRadarChart(
                    criteria: criteria.cast<Map<String, dynamic>>(),
                  ),
                  SizedBox(height: TossSpacing.space4),
                ],
              ),
            ),
            SizedBox(height: TossSpacing.space5),
          ],

          // Components - 2x2 Grid
          Text(
            'Detailed Breakdown',
            style: TossTextStyles.bodyMedium,
          ),
          SizedBox(height: TossSpacing.gapMD),

          _buildCriteriaGrid(criteria.cast<Map<String, dynamic>>()),

          if (reliability != null) ...[
            SizedBox(height: TossSpacing.paddingMD),
            _buildReliabilityNote(reliability),
          ],

          SizedBox(height: TossSpacing.paddingMD),
        ],
      ),
    );
  }

  Widget _buildNoData() {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(TossSpacing.space10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              LucideIcons.clock,
              size: TossSpacing.iconXXL,
              color: TossColors.gray400,
            ),
            SizedBox(height: TossSpacing.space4),
            Text(
              'Not Enough Data',
              style: TossTextStyles.h4,
            ),
            SizedBox(height: TossSpacing.space2),
            Text(
              'Complete more shifts to see your score',
              style: TossTextStyles.bodyGray600,
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

    return TossCard(
      padding: EdgeInsets.zero,
      showBorder: false,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Your Score',
            style: TossTextStyles.captionGray600,
          ),
          SizedBox(height: TossSpacing.space1 + TossSpacing.space1 / 2), // 6px
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                widget.finalScore.toStringAsFixed(1),
                style: TossTextStyles.h1.copyWith(
                  color: color,
                ),
              ),
              SizedBox(width: TossSpacing.space2),
              Padding(
                padding: EdgeInsets.only(bottom: TossSpacing.space1),
                child: Text(
                  label,
                  style: TossTextStyles.bodyMedium.copyWith(
                    color: color,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCriteriaGrid(List<Map<String, dynamic>> criteria) {
    // Build grid items
    final gridItems = criteria.map((criterion) {
      final name = criterion['name'] as String? ?? '';
      final value = criterion['value'];
      final unit = criterion['unit'] as String? ?? '';
      final weight = (criterion['weight'] as num?)?.toInt() ?? 0;
      final score = (criterion['score'] as num?)?.toDouble() ?? 0.0;

      final displayValue = value is num ? value.toStringAsFixed(1) : value.toString();

      return RankingBarWidget(
        name: name,
        value: displayValue,
        unit: unit,
        score: score,
        weight: weight,
      );
    }).toList();

    // Create 2x2 grid
    final List<Widget> rows = [];
    for (int i = 0; i < gridItems.length; i += 2) {
      final firstItem = gridItems[i];
      final secondItem = i + 1 < gridItems.length ? gridItems[i + 1] : null;

      rows.add(
        Row(
          children: [
            Expanded(child: firstItem),
            SizedBox(width: TossSpacing.gapMD),
            Expanded(
              child: secondItem ?? const SizedBox.shrink(),
            ),
          ],
        ),
      );

      if (i + 2 < gridItems.length) {
        rows.add(SizedBox(height: TossSpacing.gapMD));
      }
    }

    return Column(children: rows);
  }

  Widget _buildReliabilityNote(Map<String, dynamic> reliability) {
    final reliabilityValue = (reliability['value'] as num?)?.toDouble() ?? 0.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              LucideIcons.shieldCheck,
              size: TossSpacing.iconSM,
              color: TossColors.primary,
            ),
            SizedBox(width: TossSpacing.space2),
            Text(
              'Data Confidence',
              style: TossTextStyles.captionBold,
            ),
          ],
        ),
        SizedBox(height: TossSpacing.space2),
        Text(
          'Score is adjusted based on your work history. More shifts = higher confidence.',
          style: TossTextStyles.captionGray600,
        ),
        SizedBox(height: TossSpacing.space2),
        Text(
          'Confidence: ${(reliabilityValue * 100).toStringAsFixed(0)}%',
          style: TossTextStyles.captionPrimary,
        ),
      ],
    );
  }

  // Helper methods
  Color _getScoreColor(double score) {
    if (score < 20) return TossColors.error;
    return TossColors.primary;
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
