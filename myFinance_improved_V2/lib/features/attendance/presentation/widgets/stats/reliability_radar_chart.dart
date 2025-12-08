import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../../../../../shared/themes/toss_colors.dart';
import '../../../../../shared/themes/toss_text_styles.dart';

/// Radar chart showing reliability score components
/// Clean, minimal design matching app's style
class ReliabilityRadarChart extends StatelessWidget {
  final List<Map<String, dynamic>> criteria;

  const ReliabilityRadarChart({
    super.key,
    required this.criteria,
  });

  @override
  Widget build(BuildContext context) {
    if (criteria.isEmpty) {
      return const SizedBox.shrink();
    }

    // Limit to first 4-6 criteria for readability
    final displayCriteria = criteria.take(6).toList();

    return AspectRatio(
      aspectRatio: 1.3,
      child: RadarChart(
        RadarChartData(
          radarShape: RadarShape.polygon,
          radarBorderData: const BorderSide(
            color: TossColors.gray200,
            width: 1,
          ),
          gridBorderData: const BorderSide(
            color: TossColors.gray200,
            width: 1,
          ),
          tickBorderData: const BorderSide(
            color: TossColors.gray300,
            width: 1,
          ),
          tickCount: 5,
          ticksTextStyle: TossTextStyles.caption.copyWith(
            fontSize: 10,
            color: TossColors.gray500,
          ),
          radarBackgroundColor: Colors.transparent,
          dataSets: [
            RadarDataSet(
              fillColor: TossColors.primary.withOpacity(0.15),
              borderColor: TossColors.primary,
              borderWidth: 2,
              entryRadius: 3,
              dataEntries: _buildDataEntries(displayCriteria),
            ),
          ],
          titleTextStyle: TossTextStyles.caption.copyWith(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: TossColors.gray700,
          ),
          getTitle: (index, angle) {
            if (index >= displayCriteria.length) return const RadarChartTitle(text: '');
            final name = _getShortName(displayCriteria[index]['name'] as String? ?? '');
            final score = (displayCriteria[index]['score'] as num?)?.toInt() ?? 0;
            return RadarChartTitle(
              text: '$name\n$score',
              angle: angle,
            );
          },
        ),
      ),
    );
  }

  List<RadarEntry> _buildDataEntries(List<Map<String, dynamic>> criteria) {
    return criteria.map((criterion) {
      final score = (criterion['score'] as num?)?.toDouble() ?? 0.0;
      return RadarEntry(value: score);
    }).toList();
  }

  String _getShortName(String name) {
    // Shorten names for better display
    if (name.contains('Application')) return 'Applications';
    if (name.contains('Late Rate')) return 'Late Rate';
    if (name.contains('Late Minutes')) return 'Late Time';
    if (name.contains('Fill')) return 'Fill Rate';
    return name.length > 15 ? '${name.substring(0, 12)}...' : name;
  }
}
