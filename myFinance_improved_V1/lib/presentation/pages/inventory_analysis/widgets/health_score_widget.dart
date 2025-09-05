import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../../core/themes/toss_colors.dart';
import '../../../../core/themes/toss_text_styles.dart';
import '../../../../core/themes/toss_spacing.dart';
import '../models/supply_chain_models.dart';
import 'package:myfinance_improved/core/themes/index.dart';
import 'package:myfinance_improved/core/themes/toss_border_radius.dart';
class HealthScoreWidget extends StatelessWidget {
  final SupplyChainHealth health;
  final bool isMobile;
  final VoidCallback? onTap;

  const HealthScoreWidget({
    super.key,
    required this.health,
    this.isMobile = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    if (isMobile) {
      return _buildMobileLayout(context);
    }
    return _buildDesktopLayout(context);
  }

  Widget _buildDesktopLayout(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(TossBorderRadius.xl),
      child: Container(
        padding: EdgeInsets.all(TossSpacing.space4),
        decoration: BoxDecoration(
          color: TossColors.surface,
          borderRadius: BorderRadius.circular(TossBorderRadius.xl),
          border: Border.all(
            color: health.scoreColor.withValues(alpha: 0.3),
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: TossColors.black.withValues(alpha: 0.05),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            // Health Score Circle
            Expanded(
              flex: 2,
              child: _buildHealthScoreCircle(context),
            ),
            
            SizedBox(width: TossSpacing.space4),
            
            // Metrics and Trend
            Expanded(
              flex: 3,
              child: _buildHealthMetrics(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMobileLayout(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(TossBorderRadius.lg),
      child: Container(
        padding: EdgeInsets.all(TossSpacing.space3),
        decoration: BoxDecoration(
          color: TossColors.surface,
          borderRadius: BorderRadius.circular(TossBorderRadius.lg),
          border: Border.all(
            color: health.scoreColor.withValues(alpha: 0.3),
            width: 1,
          ),
        ),
        child: Column(
          children: [
            // Mobile Health Score
            Row(
              children: [
                _buildCompactHealthScore(context),
                SizedBox(width: TossSpacing.space3),
                Expanded(child: _buildCompactMetrics(context)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHealthScoreCircle(BuildContext context) {
    return SizedBox(
      width: 120,
      height: 120,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Background circle
          SizedBox(
            width: 120,
            height: 120,
            child: CircularProgressIndicator(
              value: 1.0,
              strokeWidth: 8,
              backgroundColor: TossColors.gray200,
              valueColor: AlwaysStoppedAnimation<Color>(
                health.scoreColor.withValues(alpha: 0.2),
              ),
            ),
          ),
          
          // Progress circle
          SizedBox(
            width: 120,
            height: 120,
            child: CircularProgressIndicator(
              value: health.currentScore / 100,
              strokeWidth: 8,
              backgroundColor: TossColors.transparent,
              valueColor: AlwaysStoppedAnimation<Color>(health.scoreColor),
            ),
          ),
          
          // Score text
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '${health.currentScore.toInt()}',
                style: TossTextStyles.h1.copyWith(
                  color: health.scoreColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'pts',
                style: TossTextStyles.caption.copyWith(
                  color: TossColors.gray600,
                ),
              ),
              Text(
                health.scoreLabel,
                style: TossTextStyles.caption.copyWith(
                  color: health.scoreColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCompactHealthScore(BuildContext context) {
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        color: health.scoreColor.withValues(alpha: 0.1),
        shape: BoxShape.circle,
        border: Border.all(
          color: health.scoreColor,
          width: 2,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '${health.currentScore.toInt()}',
            style: TossTextStyles.h4.copyWith(
              color: health.scoreColor,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            'pts',
            style: TossTextStyles.small.copyWith(
              color: health.scoreColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHealthMetrics(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title
        Row(
          children: [
            Icon(
              Icons.health_and_safety,
              color: health.scoreColor,
              size: 24,
            ),
            SizedBox(width: TossSpacing.space2),
            Text(
              'Supply Chain Health',
              style: TossTextStyles.h4.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        
        SizedBox(height: TossSpacing.space3),
        
        // Trend indicator
        Row(
          children: [
            Icon(
              health.trend.icon,
              color: health.trend.color,
              size: 20,
            ),
            SizedBox(width: TossSpacing.space1),
            Text(
              _getTrendEnglishLabel(health.trend),
              style: TossTextStyles.bodyLarge.copyWith(
                color: health.trend.color,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(width: TossSpacing.space2),
            Text(
              '${health.changePercent > 0 ? '+' : ''}${health.changePercent.toStringAsFixed(1)}%',
              style: TossTextStyles.bodyLarge.copyWith(
                color: health.trend.color,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        
        SizedBox(height: TossSpacing.space2),
        
        // Benchmark comparison
        Row(
          children: [
            Text(
              'vs Benchmark: ',
              style: TossTextStyles.body.copyWith(
                color: TossColors.gray600,
              ),
            ),
            Text(
              health.currentScore >= health.benchmarkScore ? 'Above Standard' : 'Needs Improvement',
              style: TossTextStyles.body.copyWith(
                color: health.currentScore >= health.benchmarkScore 
                    ? TossColors.success 
                    : TossColors.warning,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        
        SizedBox(height: TossSpacing.space3),
        
        // Mini sparkline (simplified trend)
        Container(
          height: 40,
          child: _buildSparkline(),
        ),
        
        SizedBox(height: TossSpacing.space2),
        
        // Last updated
        Text(
          'Last updated: ${_formatUpdateTime(health.lastUpdated)}',
          style: TossTextStyles.caption.copyWith(
            color: TossColors.gray500,
          ),
        ),
      ],
    );
  }

  Widget _buildCompactMetrics(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Supply Chain Health',
          style: TossTextStyles.labelLarge.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        
        SizedBox(height: TossSpacing.space1),
        
        Row(
          children: [
            Icon(
              health.trend.icon,
              color: health.trend.color,
              size: 16,
            ),
            SizedBox(width: TossSpacing.space1),
            Text(
              '${health.changePercent > 0 ? '+' : ''}${health.changePercent.toStringAsFixed(1)}%',
              style: TossTextStyles.body.copyWith(
                color: health.trend.color,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        
        SizedBox(height: TossSpacing.space1),
        
        Text(
          health.scoreLabel,
          style: TossTextStyles.caption.copyWith(
            color: health.scoreColor,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildSparkline() {
    // Simplified sparkline showing 30-day trend
    final sparklineData = _generateSparklineData();
    
    return LineChart(
      LineChartData(
        gridData: FlGridData(show: false),
        titlesData: FlTitlesData(show: false),
        borderData: FlBorderData(show: false),
        minX: 0,
        maxX: sparklineData.length - 1.0,
        minY: 0,
        maxY: 100,
        lineBarsData: [
          LineChartBarData(
            spots: sparklineData.asMap().entries.map((entry) {
              return FlSpot(entry.key.toDouble(), entry.value);
            }).toList(),
            isCurved: true,
            color: health.scoreColor,
            barWidth: 2,
            dotData: FlDotData(show: false),
            belowBarData: BarAreaData(
              show: true,
              color: health.scoreColor.withValues(alpha: 0.1),
            ),
          ),
        ],
      ),
    );
  }

  List<double> _generateSparklineData() {
    // TODO: Replace with actual historical health data from backend
    // For now, return empty to avoid fake data generation
    return [];
  }

  String _getTrendEnglishLabel(HealthTrend trend) {
    switch (trend) {
      case HealthTrend.improving:
        return 'Improving';
      case HealthTrend.stable:
        return 'Stable';
      case HealthTrend.declining:
        return 'Declining';
    }
  }

  String _formatUpdateTime(DateTime lastUpdated) {
    final now = DateTime.now();
    final difference = now.difference(lastUpdated);
    
    if (difference.inMinutes < 1) {
      return 'just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else {
      return '${difference.inDays}d ago';
    }
  }
}