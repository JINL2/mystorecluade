import 'package:flutter/material.dart';
import '../../../../core/themes/toss_colors.dart';
import '../../../../core/themes/toss_text_styles.dart';
import '../../../../core/themes/toss_animations.dart';
import '../../../../core/utils/number_formatter.dart';
import '../models/debt_control_models.dart';

/// Analytics Preview widget showing aging buckets and collection trends
/// 
/// Provides quick insights into debt portfolio health with
/// visual indicators and tap-to-expand functionality.
class AnalyticsPreview extends StatefulWidget {
  final AgingAnalysis agingData;
  final VoidCallback onViewFullAnalytics;

  const AnalyticsPreview({
    super.key,
    required this.agingData,
    required this.onViewFullAnalytics,
  });

  @override
  State<AnalyticsPreview> createState() => _AnalyticsPreviewState();
}

class _AnalyticsPreviewState extends State<AnalyticsPreview>
    with SingleTickerProviderStateMixin {
  
  late AnimationController _animationController;
  late List<Animation<double>> _barAnimations;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
  }

  void _setupAnimations() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    // Create staggered animations for aging bars
    _barAnimations = List.generate(4, (index) {
      return Tween<double>(
        begin: 0.0,
        end: 1.0,
      ).animate(CurvedAnimation(
        parent: _animationController,
        curve: Interval(
          index * 0.1,
          0.6 + (index * 0.1),
          curve: Curves.easeOutCubic,
        ),
      ));
    });

    // Start animation after widget is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _animationController.forward();
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Padding(
            padding: EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Aging Analysis',
                      style: TossTextStyles.h4.copyWith(
                        color: TossColors.textPrimary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Debt distribution by age',
                      style: TossTextStyles.caption.copyWith(
                        color: TossColors.textSecondary,
                      ),
                    ),
                  ],
                ),
                TextButton.icon(
                  onPressed: widget.onViewFullAnalytics,
                  icon: Icon(
                    Icons.analytics_outlined,
                    size: 18,
                    color: TossColors.primary,
                  ),
                  label: Text(
                    'View All',
                    style: TossTextStyles.caption.copyWith(
                      color: TossColors.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Aging Buckets Visualization
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: _buildAgingBuckets(),
          ),

          SizedBox(height: 16),

          // Summary Stats
          Padding(
            padding: EdgeInsets.all(16),
            child: _buildSummaryStats(),
          ),
        ],
      ),
    );
  }

  Widget _buildAgingBuckets() {
    final total = widget.agingData.current + 
                 widget.agingData.overdue30 + 
                 widget.agingData.overdue60 + 
                 widget.agingData.overdue90;

    if (total == 0) {
      return _buildEmptyState();
    }

    final buckets = [
      AgingBucket(
        label: 'Current',
        sublabel: '0-30 days',
        amount: widget.agingData.current,
        percentage: widget.agingData.current / total,
        color: TossColors.success,
      ),
      AgingBucket(
        label: '30 Days',
        sublabel: '31-60 days',
        amount: widget.agingData.overdue30,
        percentage: widget.agingData.overdue30 / total,
        color: TossColors.info,
      ),
      AgingBucket(
        label: '60 Days',
        sublabel: '61-90 days',
        amount: widget.agingData.overdue60,
        percentage: widget.agingData.overdue60 / total,
        color: TossColors.warning,
      ),
      AgingBucket(
        label: '90+ Days',
        sublabel: 'Over 90 days',
        amount: widget.agingData.overdue90,
        percentage: widget.agingData.overdue90 / total,
        color: TossColors.error,
      ),
    ];

    return Column(
      children: [
        // Horizontal Bar Chart
        Container(
          height: 12,
          decoration: BoxDecoration(
            color: TossColors.gray50,
            borderRadius: BorderRadius.circular(6),
          ),
          child: AnimatedBuilder(
            animation: _animationController,
            builder: (context, child) {
              return Row(
                children: buckets.asMap().entries.map((entry) {
                  final bucket = entry.value;
                  final index = entry.key;
                  
                  if (bucket.percentage == 0) return const SizedBox.shrink();
                  
                  return Flexible(
                    flex: (bucket.percentage * 100).round(),
                    child: Container(
                      height: 12,
                      decoration: BoxDecoration(
                        color: bucket.color,
                        borderRadius: BorderRadius.horizontal(
                          left: Radius.circular(index == 0 ? 6 : 0),
                          right: Radius.circular(
                            index == buckets.length - 1 ||
                            buckets.skip(index + 1).every((b) => b.percentage == 0)
                                ? 6 : 0
                          ),
                        ),
                      ),
                      width: _barAnimations[index].value * 
                             MediaQuery.of(context).size.width * bucket.percentage,
                    ),
                  );
                }).toList(),
              );
            },
          ),
        ),

        SizedBox(height: 16),

        // Legend
        Column(
          children: buckets
              .where((bucket) => bucket.percentage > 0)
              .map((bucket) => _buildLegendItem(bucket))
              .toList(),
        ),
      ],
    );
  }

  Widget _buildLegendItem(AgingBucket bucket) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          // Color indicator
          Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(
              color: bucket.color,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          
          SizedBox(width: 12),
          
          // Label and sublabel
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  bucket.label,
                  style: TossTextStyles.caption.copyWith(
                    color: TossColors.textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  bucket.sublabel,
                  style: TossTextStyles.caption.copyWith(
                    color: TossColors.textTertiary,
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          ),
          
          // Amount and percentage
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                NumberFormatter.formatCurrency(bucket.amount, '₫'),
                style: TossTextStyles.caption.copyWith(
                  color: TossColors.textPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                '${(bucket.percentage * 100).toStringAsFixed(1)}%',
                style: TossTextStyles.caption.copyWith(
                  color: TossColors.textTertiary,
                  fontSize: 10,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryStats() {
    final total = widget.agingData.current + 
                 widget.agingData.overdue30 + 
                 widget.agingData.overdue60 + 
                 widget.agingData.overdue90;

    final overdueTotal = widget.agingData.overdue30 + 
                        widget.agingData.overdue60 + 
                        widget.agingData.overdue90;

    final healthScore = total > 0 
        ? ((widget.agingData.current / total) * 100).round()
        : 100;

    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: TossColors.gray50,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem(
            'Total Portfolio',
            NumberFormatter.formatCurrency(total, '₫'),
            Icons.account_balance_wallet,
            TossColors.primary,
          ),
          _buildDivider(),
          _buildStatItem(
            'Overdue Amount',
            NumberFormatter.formatCurrency(overdueTotal, '₫'),
            Icons.schedule,
            TossColors.warning,
          ),
          _buildDivider(),
          _buildStatItem(
            'Health Score',
            '$healthScore%',
            Icons.favorite,
            _getHealthColor(healthScore),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon, Color color) {
    return Column(
      children: [
        Icon(
          icon,
          color: color,
          size: 20,
        ),
        SizedBox(height: 8),
        Text(
          value,
          style: TossTextStyles.bodySmall.copyWith(
            color: TossColors.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: TossTextStyles.caption.copyWith(
            color: TossColors.textSecondary,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildDivider() {
    return Container(
      height: 40,
      width: 1,
      color: TossColors.borderLight,
    );
  }

  Widget _buildEmptyState() {
    return Container(
      padding: EdgeInsets.all(20),
      child: Column(
        children: [
          Icon(
            Icons.pie_chart_outline,
            size: 48,
            color: TossColors.textTertiary,
          ),
          SizedBox(height: 12),
          Text(
            'No Data Available',
            style: TossTextStyles.bodySmall.copyWith(
              color: TossColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Color _getHealthColor(int healthScore) {
    if (healthScore >= 80) return TossColors.success;
    if (healthScore >= 60) return TossColors.warning;
    return TossColors.error;
  }
}

class AgingBucket {
  final String label;
  final String sublabel;
  final double amount;
  final double percentage;
  final Color color;

  const AgingBucket({
    required this.label,
    required this.sublabel,
    required this.amount,
    required this.percentage,
    required this.color,
  });
}