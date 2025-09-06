import 'package:flutter/material.dart';
import '../../../../core/themes/toss_colors.dart';
import '../../../../core/themes/toss_text_styles.dart';
import '../../../../core/themes/toss_spacing.dart';
import '../../../../core/themes/toss_border_radius.dart';
import '../models/supply_chain_models.dart';
import 'package:myfinance_improved/core/themes/index.dart';

class StageBottleneckWidget extends StatelessWidget {
  final List<StagePerformance> stagePerformance;
  final bool isMobile;
  final Function(SupplyChainStage)? onStageTap;
  final Function(SupplyChainStage)? onViewProblems;

  const StageBottleneckWidget({
    super.key,
    required this.stagePerformance,
    this.isMobile = false,
    this.onStageTap,
    this.onViewProblems,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: TossColors.surface,
        borderRadius: BorderRadius.circular(TossBorderRadius.xl),
        boxShadow: [
          BoxShadow(
            color: TossColors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(context),
          if (isMobile)
            _buildMobileStageList(context)
          else
            _buildDesktopStageGrid(context),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final totalProblems = stagePerformance.fold<int>(
      0,
      (sum, stage) => sum + stage.totalProblems,
    );
    
    final avgResolutionTime = stagePerformance.isNotEmpty
        ? stagePerformance.map((s) => s.avgResolutionTime).reduce((a, b) => a + b) / stagePerformance.length
        : 0.0;

    return Container(
      padding: EdgeInsets.all(TossSpacing.space4),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: TossColors.gray100,
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: TossColors.warning.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(TossBorderRadius.md),
            ),
            child: Icon(
              Icons.timeline,
              color: TossColors.warning,
              size: 20,
            ),
          ),
          SizedBox(width: TossSpacing.space3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Stage Analysis',
                  style: TossTextStyles.h4.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '$totalProblems issues • ${avgResolutionTime.toStringAsFixed(1)}h avg resolution',
                  style: TossTextStyles.caption.copyWith(
                    color: TossColors.gray600,
                  ),
                ),
              ],
            ),
          ),
          _buildOverallTrendIndicator(context),
        ],
      ),
    );
  }

  Widget _buildOverallTrendIndicator(BuildContext context) {
    final improvingCount = stagePerformance.where((s) => s.trend == HealthTrend.improving).length;
    final decliningCount = stagePerformance.where((s) => s.trend == HealthTrend.declining).length;
    
    Color trendColor;
    IconData trendIcon;
    String trendText;
    
    if (improvingCount > decliningCount) {
      trendColor = TossColors.success;
      trendIcon = Icons.trending_up;
      trendText = 'Improving';
    } else if (decliningCount > improvingCount) {
      trendColor = TossColors.error;
      trendIcon = Icons.trending_down;
      trendText = 'Declining';
    } else {
      trendColor = TossColors.info;
      trendIcon = Icons.trending_flat;
      trendText = 'Stable';
    }
    
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: TossSpacing.space2,
        vertical: TossSpacing.space1,
      ),
      decoration: BoxDecoration(
        color: trendColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(TossBorderRadius.sm),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            trendIcon,
            color: trendColor,
            size: 16,
          ),
          SizedBox(width: TossSpacing.space1),
          Text(
            trendText,
            style: TossTextStyles.caption.copyWith(
              color: trendColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDesktopStageGrid(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(TossSpacing.space4),
      child: Row(
        children: stagePerformance.asMap().entries.map((entry) {
          final index = entry.key;
          final stage = entry.value;
          
          return Expanded(
            child: Container(
              margin: EdgeInsets.only(
                right: index < stagePerformance.length - 1 ? TossSpacing.space3 : 0,
              ),
              child: _buildStageCard(context, stage),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildMobileStageList(BuildContext context) {
    return Column(
      children: stagePerformance.map((stage) {
        return Container(
          margin: EdgeInsets.symmetric(horizontal: TossSpacing.space4),
          child: _buildMobileStageCard(context, stage),
        );
      }).toList(),
    );
  }

  Widget _buildStageCard(BuildContext context, StagePerformance stage) {
    return InkWell(
      onTap: () => onStageTap?.call(stage.stage),
      borderRadius: BorderRadius.circular(TossBorderRadius.md),
      child: Container(
        padding: EdgeInsets.all(TossSpacing.space3),
        decoration: BoxDecoration(
          color: TossColors.gray50,
          borderRadius: BorderRadius.circular(TossBorderRadius.md),
          border: Border.all(
            color: _getStageColor(stage.stage).withValues(alpha: 0.3),
            width: 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Stage title with arrow
            Row(
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: _getStageColor(stage.stage),
                    shape: BoxShape.circle,
                  ),
                ),
                SizedBox(width: TossSpacing.space2),
                Expanded(
                  child: Text(
                    _getStageEnglishLabel(stage.stage),
                    style: TossTextStyles.bodyLarge.copyWith(
                      fontWeight: FontWeight.w600,
                      color: TossColors.gray900,
                    ),
                  ),
                ),
                Icon(
                  stage.trend.icon,
                  color: stage.trend.color,
                  size: 16,
                ),
              ],
            ),
            
            SizedBox(height: TossSpacing.space3),
            
            // Problems count
            Row(
              children: [
                Icon(
                  Icons.error_outline,
                  color: TossColors.error,
                  size: 16,
                ),
                SizedBox(width: TossSpacing.space1),
                Text(
                  '${stage.totalProblems}',
                  style: TossTextStyles.h4.copyWith(
                    fontWeight: FontWeight.bold,
                    color: TossColors.error,
                  ),
                ),
                SizedBox(width: TossSpacing.space1),
                Text(
                  'issues',
                  style: TossTextStyles.caption.copyWith(
                    color: TossColors.gray600,
                  ),
                ),
              ],
            ),
            
            SizedBox(height: TossSpacing.space2),
            
            // Average resolution time
            Row(
              children: [
                Icon(
                  Icons.timer_outlined,
                  color: TossColors.info,
                  size: 16,
                ),
                SizedBox(width: TossSpacing.space1),
                Text(
                  '${stage.avgResolutionTime.toStringAsFixed(1)}h',
                  style: TossTextStyles.body.copyWith(
                    fontWeight: FontWeight.w600,
                    color: TossColors.gray900,
                  ),
                ),
                SizedBox(width: TossSpacing.space1),
                Text(
                  'avg resolution',
                  style: TossTextStyles.caption.copyWith(
                    color: TossColors.gray600,
                  ),
                ),
              ],
            ),
            
            SizedBox(height: TossSpacing.space2),
            
            // Financial impact
            Row(
              children: [
                Icon(
                  Icons.attach_money,
                  color: TossColors.warning,
                  size: 16,
                ),
                SizedBox(width: TossSpacing.space1),
                Text(
                  _formatCurrency(stage.financialImpact),
                  style: TossTextStyles.body.copyWith(
                    fontWeight: FontWeight.w600,
                    color: TossColors.warning,
                  ),
                ),
                SizedBox(width: TossSpacing.space1),
                Text(
                  'impact',
                  style: TossTextStyles.caption.copyWith(
                    color: TossColors.gray600,
                  ),
                ),
              ],
            ),
            
            SizedBox(height: TossSpacing.space3),
            
            // View problems button
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () => onViewProblems?.call(stage.stage),
                style: OutlinedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: TossSpacing.space2),
                  side: BorderSide(
                    color: _getStageColor(stage.stage),
                    width: 1,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(TossBorderRadius.sm),
                  ),
                ),
                child: Text(
                  'View Issues',
                  style: TossTextStyles.caption.copyWith(
                    color: _getStageColor(stage.stage),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMobileStageCard(BuildContext context, StagePerformance stage) {
    return Container(
      margin: EdgeInsets.only(bottom: TossSpacing.space3),
      child: InkWell(
        onTap: () => onStageTap?.call(stage.stage),
        borderRadius: BorderRadius.circular(TossBorderRadius.md),
        child: Container(
          padding: EdgeInsets.all(TossSpacing.space3),
          decoration: BoxDecoration(
            color: TossColors.gray50,
            borderRadius: BorderRadius.circular(TossBorderRadius.md),
            border: Border.all(
              color: _getStageColor(stage.stage).withValues(alpha: 0.3),
              width: 1,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header row
              Row(
                children: [
                  Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      color: _getStageColor(stage.stage),
                      shape: BoxShape.circle,
                    ),
                  ),
                  SizedBox(width: TossSpacing.space2),
                  Expanded(
                    child: Text(
                      _getStageEnglishLabel(stage.stage),
                      style: TossTextStyles.bodyLarge.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Icon(
                    stage.trend.icon,
                    color: stage.trend.color,
                    size: 20,
                  ),
                ],
              ),
              
              SizedBox(height: TossSpacing.space2),
              
              // Metrics row
              Row(
                children: [
                  Expanded(
                    child: _buildMobileMetric(
                      context,
                      Icons.error_outline,
                      '${stage.totalProblems}',
                      'Issues',
                      TossColors.error,
                    ),
                  ),
                  SizedBox(width: TossSpacing.space2),
                  Expanded(
                    child: _buildMobileMetric(
                      context,
                      Icons.timer_outlined,
                      '${stage.avgResolutionTime.toStringAsFixed(1)}h',
                      'Avg Time',
                      TossColors.info,
                    ),
                  ),
                  SizedBox(width: TossSpacing.space2),
                  Expanded(
                    child: _buildMobileMetric(
                      context,
                      Icons.attach_money,
                      _formatCurrency(stage.financialImpact),
                      'Impact',
                      TossColors.warning,
                    ),
                  ),
                ],
              ),
              
              SizedBox(height: TossSpacing.space3),
              
              // Action button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => onViewProblems?.call(stage.stage),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _getStageColor(stage.stage),
                    padding: EdgeInsets.symmetric(vertical: TossSpacing.space2),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(TossBorderRadius.sm),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    'View ${stage.totalProblems} Issues',
                    style: TossTextStyles.caption.copyWith(
                      color: TossColors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMobileMetric(
    BuildContext context,
    IconData icon,
    String value,
    String label,
    Color color,
  ) {
    return Column(
      children: [
        Icon(
          icon,
          color: color,
          size: 20,
        ),
        SizedBox(height: TossSpacing.space1),
        Text(
          value,
          style: TossTextStyles.bodyLarge.copyWith(
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          label,
          style: TossTextStyles.small.copyWith(
            color: TossColors.gray600,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Color _getStageColor(SupplyChainStage stage) {
    switch (stage) {
      case SupplyChainStage.order:
        return TossColors.primary;
      case SupplyChainStage.send:
        return TossColors.warning;
      case SupplyChainStage.receive:
        return TossColors.success;
      case SupplyChainStage.sell:
        return TossColors.info;
    }
  }

  String _getStageEnglishLabel(SupplyChainStage stage) {
    switch (stage) {
      case SupplyChainStage.order:
        return 'Order';
      case SupplyChainStage.send:
        return 'Send';
      case SupplyChainStage.receive:
        return 'Receive';
      case SupplyChainStage.sell:
        return 'Sell';
    }
  }

  String _formatCurrency(double value) {
    if (value >= 1000000000) {
      return '\$${(value / 1000000000).toStringAsFixed(1)}B';
    } else if (value >= 1000000) {
      return '\$${(value / 1000000).toStringAsFixed(1)}M';
    } else if (value >= 1000) {
      return '\$${(value / 1000).toStringAsFixed(0)}K';
    }
    return '\$${value.toStringAsFixed(0)}';
  }
}