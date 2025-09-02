import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../core/themes/toss_colors.dart';
import '../../../../core/themes/toss_text_styles.dart';
import '../../../../core/themes/toss_spacing.dart';
import '../../../../core/themes/toss_border_radius.dart';
import '../models/supply_chain_models.dart';

class PriorityProblemsWidget extends StatelessWidget {
  final List<SupplyChainProblem> problems;
  final bool isMobile;
  final Function(SupplyChainProblem)? onProblemTap;
  final Function(SupplyChainProblem, SmartAction)? onActionTap;
  final VoidCallback? onSeeAll;

  const PriorityProblemsWidget({
    super.key,
    required this.problems,
    this.isMobile = false,
    this.onProblemTap,
    this.onActionTap,
    this.onSeeAll,
  });

  @override
  Widget build(BuildContext context) {
    if (problems.isEmpty) {
      return _buildEmptyState(context);
    }

    return Container(
      decoration: BoxDecoration(
        color: TossColors.surface,
        borderRadius: BorderRadius.circular(16),
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
          _buildProblemsList(context),
          if (problems.length > 3) _buildSeeAllButton(context),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
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
              color: TossColors.error.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(TossBorderRadius.md),
            ),
            child: Icon(
              Icons.priority_high,
              color: TossColors.error,
              size: 20,
            ),
          ),
          SizedBox(width: TossSpacing.space3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Priority Problems',
                  style: TossTextStyles.h4.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '${problems.length} supply chain issues requiring attention',
                  style: TossTextStyles.caption.copyWith(
                    color: TossColors.gray600,
                  ),
                ),
              ],
            ),
          ),
          if (problems.isNotEmpty)
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: TossSpacing.space2,
                vertical: TossSpacing.space1,
              ),
              decoration: BoxDecoration(
                color: _getSeverityColor(problems.first).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(TossBorderRadius.sm),
              ),
              child: Text(
                '${problems.where((p) => p.priorityScore >= 90).length} urgent',
                style: TossTextStyles.caption.copyWith(
                  color: _getSeverityColor(problems.first),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildProblemsList(BuildContext context) {
    final displayProblems = problems.take(3).toList();
    
    return Column(
      children: displayProblems.asMap().entries.map((entry) {
        final index = entry.key;
        final problem = entry.value;
        final isLast = index == displayProblems.length - 1;
        
        return Column(
          children: [
            _buildProblemCard(context, problem, index + 1),
            if (!isLast)
              Divider(
                height: 1,
                color: TossColors.gray100,
                indent: TossSpacing.space4,
                endIndent: TossSpacing.space4,
              ),
          ],
        );
      }).toList(),
    );
  }

  Widget _buildProblemCard(BuildContext context, SupplyChainProblem problem, int displayRank) {
    if (isMobile) {
      return _buildMobileProblemCard(context, problem, displayRank);
    }
    return _buildDesktopProblemCard(context, problem, displayRank);
  }

  Widget _buildDesktopProblemCard(BuildContext context, SupplyChainProblem problem, int displayRank) {
    return InkWell(
      onTap: () => onProblemTap?.call(problem),
      child: Container(
        padding: EdgeInsets.all(TossSpacing.space4),
        child: Row(
          children: [
            // Priority Rank Badge
            _buildPriorityBadge(displayRank, problem.priorityScore),
            
            SizedBox(width: TossSpacing.space3),
            
            // Product Info
            Expanded(
              flex: 3,
              child: _buildProductInfo(context, problem),
            ),
            
            SizedBox(width: TossSpacing.space3),
            
            // Stage & Metrics
            Expanded(
              flex: 2,
              child: _buildStageMetrics(context, problem),
            ),
            
            SizedBox(width: TossSpacing.space3),
            
            // Financial Impact
            Expanded(
              flex: 2,
              child: _buildFinancialImpact(context, problem),
            ),
            
            SizedBox(width: TossSpacing.space3),
            
            // Actions
            _buildQuickActions(context, problem),
          ],
        ),
      ),
    );
  }

  Widget _buildMobileProblemCard(BuildContext context, SupplyChainProblem problem, int displayRank) {
    return InkWell(
      onTap: () => onProblemTap?.call(problem),
      child: Container(
        padding: EdgeInsets.all(TossSpacing.space3),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top row: Priority + Product
            Row(
              children: [
                _buildPriorityBadge(displayRank, problem.priorityScore),
                SizedBox(width: TossSpacing.space2),
                Expanded(child: _buildProductInfo(context, problem)),
              ],
            ),
            
            SizedBox(height: TossSpacing.space2),
            
            // Middle row: Stage + Financial
            Row(
              children: [
                Expanded(child: _buildStageMetrics(context, problem)),
                SizedBox(width: TossSpacing.space2),
                Expanded(child: _buildFinancialImpact(context, problem)),
              ],
            ),
            
            SizedBox(height: TossSpacing.space2),
            
            // Bottom row: Actions
            _buildMobileActions(context, problem),
          ],
        ),
      ),
    );
  }

  Widget _buildPriorityBadge(int rank, double priorityScore) {
    final severityColor = _getPrioritySeverityColor(priorityScore);
    final severityEmoji = _getPrioritySeverityEmoji(priorityScore);
    
    return Container(
      width: 56,
      height: 56,
      decoration: BoxDecoration(
        color: severityColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(TossBorderRadius.lg),
        border: Border.all(
          color: severityColor.withValues(alpha: 0.3),
          width: 2,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '#$rank',
            style: TossTextStyles.label.copyWith(
              color: severityColor,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            '$severityEmoji',
            style: TextStyle(fontSize: 16),
          ),
          Text(
            '${priorityScore.toInt()}pts',
            style: TossTextStyles.small.copyWith(
              color: severityColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductInfo(BuildContext context, SupplyChainProblem problem) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: _getProductColor(problem.product.name),
                borderRadius: BorderRadius.circular(TossBorderRadius.sm),
              ),
              child: Center(
                child: Text(
                  _getProductInitial(problem.product.name),
                  style: TossTextStyles.caption.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            SizedBox(width: TossSpacing.space2),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    problem.product.name,
                    style: TossTextStyles.bodyLarge.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    '${problem.product.brand} • ${problem.product.category}',
                    style: TossTextStyles.caption.copyWith(
                      color: TossColors.gray600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStageMetrics(BuildContext context, SupplyChainProblem problem) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Stage indicator
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: TossSpacing.space2,
            vertical: TossSpacing.space1,
          ),
          decoration: BoxDecoration(
            color: problem.stage.indicatorColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(TossBorderRadius.sm),
          ),
          child: Text(
            _getStageEnglishLabel(problem.stage.stage),
            style: TossTextStyles.caption.copyWith(
              color: problem.stage.indicatorColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        
        SizedBox(height: TossSpacing.space1),
        
        // Metrics
        Text(
          'Backlog: ${problem.metrics.daysAccumulated} days',
          style: TossTextStyles.caption.copyWith(
            color: TossColors.gray700,
          ),
        ),
        Text(
          'Gap: ${problem.metrics.currentGap} units',
          style: TossTextStyles.caption.copyWith(
            color: TossColors.gray700,
          ),
        ),
      ],
    );
  }

  Widget _buildFinancialImpact(BuildContext context, SupplyChainProblem problem) {
    final formatter = NumberFormat.currency(
      locale: 'ko_KR',
      symbol: '₩',
      decimalDigits: 0,
    );
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Financial Impact',
          style: TossTextStyles.caption.copyWith(
            color: TossColors.gray600,
            fontWeight: FontWeight.w600,
          ),
        ),
        
        SizedBox(height: TossSpacing.space1),
        
        // Current loss
        Text(
          'Current Loss',
          style: TossTextStyles.small.copyWith(
            color: TossColors.gray600,
          ),
        ),
        Text(
          _formatCurrency(problem.financialImpact.currentLoss),
          style: TossTextStyles.body.copyWith(
            color: TossColors.error,
            fontWeight: FontWeight.w600,
          ),
        ),
        
        SizedBox(height: TossSpacing.space1),
        
        // Projected loss
        Text(
          'Projected Loss',
          style: TossTextStyles.small.copyWith(
            color: TossColors.gray600,
          ),
        ),
        Text(
          _formatCurrency(problem.financialImpact.projectedLoss),
          style: TossTextStyles.body.copyWith(
            color: TossColors.warning,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildQuickActions(BuildContext context, SupplyChainProblem problem) {
    final primaryActions = problem.actions.take(2).toList();
    
    return Column(
      children: primaryActions.map((action) {
        return Container(
          margin: EdgeInsets.only(bottom: TossSpacing.space1),
          child: SizedBox(
            width: 120,
            height: 32,
            child: ElevatedButton.icon(
              onPressed: () => onActionTap?.call(problem, action),
              icon: Icon(
                action.icon,
                size: 16,
                color: Colors.white,
              ),
              label: Text(
                action.englishLabel,
                style: TossTextStyles.caption.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: action.color,
                padding: EdgeInsets.symmetric(horizontal: TossSpacing.space2),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(TossBorderRadius.sm),
                ),
                elevation: 0,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildMobileActions(BuildContext context, SupplyChainProblem problem) {
    final primaryActions = problem.actions.take(3).toList();
    
    return Row(
      children: [
        ...primaryActions.asMap().entries.map((entry) {
          final index = entry.key;
          final action = entry.value;
          
          return Expanded(
            child: Container(
              margin: EdgeInsets.only(
                right: index < primaryActions.length - 1 ? TossSpacing.space1 : 0,
              ),
              child: ElevatedButton(
                onPressed: () => onActionTap?.call(problem, action),
                style: ElevatedButton.styleFrom(
                  backgroundColor: action.color,
                  padding: EdgeInsets.symmetric(
                    horizontal: TossSpacing.space1,
                    vertical: TossSpacing.space2,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(TossBorderRadius.sm),
                  ),
                  elevation: 0,
                ),
                child: Column(
                  children: [
                    Icon(
                      action.icon,
                      size: 16,
                      color: Colors.white,
                    ),
                    SizedBox(height: 2),
                    Text(
                      action.englishLabel,
                      style: TossTextStyles.small.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
        if (problem.actions.length > 3)
          Container(
            margin: EdgeInsets.only(left: TossSpacing.space1),
            child: IconButton(
              onPressed: () => onProblemTap?.call(problem),
              icon: Icon(
                Icons.more_horiz,
                color: TossColors.gray600,
              ),
              constraints: BoxConstraints(minWidth: 32, minHeight: 32),
              padding: EdgeInsets.zero,
            ),
          ),
      ],
    );
  }

  Widget _buildSeeAllButton(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(TossSpacing.space3),
      child: Center(
        child: TextButton.icon(
          onPressed: onSeeAll,
          icon: Icon(
            Icons.expand_more,
            color: TossColors.primary,
            size: 20,
          ),
          label: Text(
            'View All Problems (${problems.length})',
            style: TossTextStyles.body.copyWith(
              color: TossColors.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
          style: TextButton.styleFrom(
            padding: EdgeInsets.symmetric(
              horizontal: TossSpacing.space3,
              vertical: TossSpacing.space2,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(TossBorderRadius.md),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(TossSpacing.space6),
      decoration: BoxDecoration(
        color: TossColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: TossColors.gray200,
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: TossColors.success.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.check_circle_outline,
              color: TossColors.success,
              size: 32,
            ),
          ),
          
          SizedBox(height: TossSpacing.space3),
          
          Text(
            'No Issues',
            style: TossTextStyles.h4.copyWith(
              fontWeight: FontWeight.bold,
              color: TossColors.success,
            ),
          ),
          
          SizedBox(height: TossSpacing.space1),
          
          Text(
            'No priority problems detected in your supply chain.',
            style: TossTextStyles.body.copyWith(
              color: TossColors.gray600,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Color _getSeverityColor(SupplyChainProblem problem) {
    if (problem.priorityScore >= 90) return TossColors.error;
    if (problem.priorityScore >= 70) return TossColors.warning;
    return TossColors.success;
  }

  Color _getPrioritySeverityColor(double priorityScore) {
    if (priorityScore >= 90) return TossColors.error;
    if (priorityScore >= 70) return TossColors.warning;
    if (priorityScore >= 50) return TossColors.info;
    return TossColors.success;
  }

  String _getPrioritySeverityEmoji(double priorityScore) {
    if (priorityScore >= 90) return '🔴';
    if (priorityScore >= 70) return '🟠';
    if (priorityScore >= 50) return '🟡';
    return '🟢';
  }

  Color _getProductColor(String name) {
    final colors = [
      TossColors.primary,
      TossColors.success,
      TossColors.warning,
      TossColors.info,
      TossColors.error,
      TossColors.gray600,
    ];
    
    final index = name.hashCode % colors.length;
    return colors[index];
  }

  String _getProductInitial(String name) {
    if (name.isEmpty) return '?';
    
    // Check if it starts with a number
    if (RegExp(r'^\d').hasMatch(name)) {
      return '1';
    }
    
    // Return first character
    return name[0].toUpperCase();
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
      return '${(value / 1000000000).toStringAsFixed(1)}B';
    } else if (value >= 1000000) {
      return '${(value / 1000000).toStringAsFixed(1)}M';
    } else if (value >= 1000) {
      return '${(value / 1000).toStringAsFixed(0)}K';
    }
    return '${value.toStringAsFixed(0)}';
  }
}