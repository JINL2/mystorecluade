import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'dart:math' as math;
import '../../../../core/themes/index.dart';

class EmptyStateWidget extends StatelessWidget {
  final VoidCallback onGetStarted;
  final VoidCallback onViewSample;
  final VoidCallback onEditMode;
  final bool isMobile;
  
  const EmptyStateWidget({
    super.key,
    required this.onGetStarted,
    required this.onViewSample,
    required this.onEditMode,
    this.isMobile = false,
  });
  
  @override
  Widget build(BuildContext context) {
    if (isMobile) {
      return _buildMobileLayout(context);
    }
    return _buildDesktopLayout(context);
  }
  
  Widget _buildDesktopLayout(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(TossSpacing.paddingXL),
      child: Column(
        children: [
          // Value Proposition
          _buildValueProposition(context),
          SizedBox(height: TossSpacing.space10),
          
          // Quick Start Options
          _buildQuickStartOptions(context),
          SizedBox(height: TossSpacing.space10),
          
          // Sample Dashboard Preview
          _buildSampleDashboardPreview(context),
          SizedBox(height: TossSpacing.space10),
          
          // Benefits
          _buildBenefits(context),
        ],
      ),
    );
  }
  
  Widget _buildMobileLayout(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(TossSpacing.paddingMD),
      child: Column(
        children: [
          // Compact Hero
          _buildMobileHero(context),
          SizedBox(height: TossSpacing.paddingXL),
          
          // Quick Actions
          _buildMobileQuickActions(context),
          SizedBox(height: TossSpacing.paddingXL),
          
          // Sample Preview
          _buildMobileSamplePreview(context),
        ],
      ),
    );
  }
  
  Widget _buildValueProposition(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(TossSpacing.space8),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Theme.of(context).primaryColor,
            Theme.of(context).primaryColor.withOpacity(0.8),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(TossBorderRadius.xl),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).primaryColor.withOpacity(0.3),
            blurRadius: 20,
            offset: Offset(0, TossSpacing.space2),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(
            TossIcons.analytics,
            size: TossSpacing.iconXL + TossSpacing.paddingXL,
            color: TossColors.white,
          ),
          SizedBox(height: TossSpacing.space4),
          Text(
            'Find Supply Chain Problems in Seconds',
            style: TossTextStyles.h1.copyWith(
              color: TossColors.white,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: TossSpacing.space3),
          Text(
            'Identify bottlenecks • Prioritize by impact • Fix issues 90% faster',
            style: TossTextStyles.h4.copyWith(
              color: TossColors.white.withOpacity(0.95),
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: TossSpacing.paddingXL),
          ElevatedButton.icon(
            onPressed: onGetStarted,
            icon: Icon(TossIcons.star),
            label: Text(
              'Get Started',
              style: TossTextStyles.button,
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: TossColors.white,
              foregroundColor: Theme.of(context).primaryColor,
              padding: EdgeInsets.symmetric(horizontal: TossSpacing.space8, vertical: TossSpacing.space4),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(TossBorderRadius.button),
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildQuickStartOptions(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              TossIcons.star,
              color: TossColors.primary,
              size: TossSpacing.iconLG,
            ),
            SizedBox(width: TossSpacing.space2),
            Text(
              'Quick Start - Choose Your Focus',
              style: TossTextStyles.h2,
            ),
          ],
        ),
        SizedBox(height: TossSpacing.space5),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 4,
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          childAspectRatio: 1.2,
          children: [
            _buildQuickStartCard(
              context,
              'Find Problems',
              'See critical issues',
              TossIcons.warning,
              TossColors.error,
              onEditMode,
            ),
            _buildQuickStartCard(
              context,
              'Track KPIs',
              'Monitor performance',
              TossIcons.star,
              TossColors.success,
              onEditMode,
            ),
            _buildQuickStartCard(
              context,
              'Analyze Trends',
              'Historical insights',
              TossIcons.analytics,
              TossColors.primary,
              onEditMode,
            ),
            _buildQuickStartCard(
              context,
              'Custom Build',
              'Start from scratch',
              TossIcons.settings,
              TossColors.info,
              onEditMode,
            ),
          ],
        ),
        SizedBox(height: TossSpacing.space4),
        Container(
          padding: EdgeInsets.all(TossSpacing.space3),
          decoration: BoxDecoration(
            color: TossColors.info.withOpacity(0.1),
            borderRadius: BorderRadius.circular(TossBorderRadius.md),
            border: Border.all(color: TossColors.info.withOpacity(0.3)),
          ),
          child: Row(
            children: [
              Icon(TossIcons.time, size: TossSpacing.iconSM, color: TossColors.info),
              SizedBox(width: TossSpacing.space2),
              Text(
                'Time to first insight: Under 2 minutes',
                style: TossTextStyles.body.copyWith(
                  color: TossColors.info,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
  
  Widget _buildQuickStartCard(
    BuildContext context,
    String title,
    String subtitle,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(TossBorderRadius.lg),
      child: Container(
        padding: EdgeInsets.all(TossSpacing.paddingMD),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(TossBorderRadius.lg),
          border: Border.all(color: TossColors.border),
          boxShadow: [
            BoxShadow(
              color: TossColors.shadow,
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: TossSpacing.iconLG),
            SizedBox(height: TossSpacing.space2),
            Text(
              title,
              style: TossTextStyles.labelLarge,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: TossSpacing.space1),
            Text(
              subtitle,
              style: TossTextStyles.small.copyWith(
                color: TossColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildSampleDashboardPreview(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(
                  TossIcons.visibility,
                  color: TossColors.primary,
                  size: TossSpacing.iconLG,
                ),
                SizedBox(width: TossSpacing.space2),
                Text(
                  'Sample Dashboard Preview',
                  style: TossTextStyles.h2,
                ),
              ],
            ),
            TextButton.icon(
              onPressed: onViewSample,
              icon: Icon(TossIcons.more),
              label: const Text('View Full Sample'),
            ),
          ],
        ),
        SizedBox(height: TossSpacing.space2),
        Text(
          'This shows how your dashboard will look with real data',
          style: TossTextStyles.body.copyWith(
            color: TossColors.textSecondary,
          ),
        ),
        SizedBox(height: TossSpacing.space5),
        
        // Sample KPI Cards
        Row(
          children: [
            Expanded(child: _buildSampleKPICard(context, '🔴 Critical', '3 items', TossColors.error)),
            SizedBox(width: TossSpacing.space3),
            Expanded(child: _buildSampleKPICard(context, '🟡 Warning', '8 items', TossColors.warning)),
            SizedBox(width: TossSpacing.space3),
            Expanded(child: _buildSampleKPICard(context, '🟢 Normal', '45 items', TossColors.success)),
            SizedBox(width: TossSpacing.space3),
            Expanded(child: _buildSampleKPICard(context, '💰 At Risk', '₩15.2M', TossColors.info)),
          ],
        ),
        SizedBox(height: TossSpacing.space4),
        
        // Sample Problem List and Chart
        Row(
          children: [
            // Problem List
            Expanded(
              flex: 2,
              child: Container(
                height: 250,
                padding: EdgeInsets.all(TossSpacing.paddingMD),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(TossBorderRadius.lg),
                  border: Border.all(color: TossColors.border),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '📊 Priority Problems',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _buildSampleProblemItem('#1', 'Wallet-C GOYARD', '15 days delayed', Colors.red),
                    _buildSampleProblemItem('#2', 'Bag-A LV', '8 units short', Colors.orange),
                    _buildSampleProblemItem('#3', 'Belt-G HERMES', 'Low stock', Colors.yellow[700]!),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 16),
            // Chart
            Expanded(
              flex: 3,
              child: Container(
                height: 250,
                padding: EdgeInsets.all(TossSpacing.paddingMD),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(TossBorderRadius.lg),
                  border: Border.all(color: TossColors.border),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '📈 Supply Chain Flow',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Expanded(child: _buildSampleChart()),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
  
  Widget _buildSampleKPICard(BuildContext context, String label, String value, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(TossBorderRadius.lg),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TossTextStyles.caption.copyWith(
              color: color,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: TossSpacing.space1),
          Text(
            value,
            style: TossTextStyles.h3,
          ),
        ],
      ),
    );
  }
  
  Widget _buildSampleProblemItem(String rank, String name, String issue, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Center(
              child: Text(
                rank,
                style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
                Text(
                  issue,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildSampleChart() {
    return LineChart(
      LineChartData(
        gridData: FlGridData(show: false),
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                const labels = ['Order', 'Ship', 'Receive', 'Sale'];
                if (value.toInt() < labels.length) {
                  return Text(
                    labels[value.toInt()],
                    style: const TextStyle(fontSize: 10),
                  );
                }
                return const Text('');
              },
            ),
          ),
        ),
        borderData: FlBorderData(show: false),
        lineBarsData: [
          LineChartBarData(
            spots: [
              const FlSpot(0, 100),
              const FlSpot(1, 85),
              const FlSpot(2, 70),
              const FlSpot(3, 60),
            ],
            isCurved: true,
            color: Colors.blue,
            barWidth: 3,
            dotData: FlDotData(show: true),
            belowBarData: BarAreaData(
              show: true,
              color: Colors.blue.withOpacity(0.1),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildBenefits(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.star,
              color: Theme.of(context).primaryColor,
              size: 28,
            ),
            const SizedBox(width: 8),
            const Text(
              'Why Supply Chain Analytics?',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        Row(
          children: [
            Expanded(child: _buildBenefitCard(context, Icons.speed, '90% Faster', 'Problem identification')),
            const SizedBox(width: 16),
            Expanded(child: _buildBenefitCard(context, Icons.trending_down, '60% Reduction', 'In supply chain delays')),
            const SizedBox(width: 16),
            Expanded(child: _buildBenefitCard(context, Icons.savings, '₩2.3M Saved', 'Annual cost avoidance')),
            const SizedBox(width: 16),
            Expanded(child: _buildBenefitCard(context, Icons.visibility, 'Real-time', 'Supply chain visibility')),
          ],
        ),
      ],
    );
  }
  
  Widget _buildBenefitCard(BuildContext context, IconData icon, String value, String label) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(TossBorderRadius.lg),
        border: Border.all(color: Colors.grey.withOpacity(0.2)),
      ),
      child: Column(
        children: [
          Icon(icon, color: Theme.of(context).primaryColor, size: 32),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
  
  // Mobile-specific widgets
  Widget _buildMobileHero(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Theme.of(context).primaryColor,
            Theme.of(context).primaryColor.withOpacity(0.8),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          const Icon(Icons.insights, size: 48, color: Colors.white),
          const SizedBox(height: 12),
          const Text(
            'Supply Chain\nAnalytics',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Find and fix problems fast',
            style: TextStyle(
              fontSize: 16,
              color: Colors.white.withOpacity(0.95),
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: onGetStarted,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Theme.of(context).primaryColor,
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
              child: const Text(
                'Get Started',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildMobileQuickActions(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Quick Start',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 1.5,
          children: [
            _buildMobileQuickCard(context, 'Problems', Icons.warning, Colors.red),
            _buildMobileQuickCard(context, 'KPIs', Icons.trending_up, Colors.green),
            _buildMobileQuickCard(context, 'Trends', Icons.analytics, Colors.blue),
            _buildMobileQuickCard(context, 'Custom', Icons.build, Colors.purple),
          ],
        ),
      ],
    );
  }
  
  Widget _buildMobileQuickCard(BuildContext context, String title, IconData icon, Color color) {
    return InkWell(
      onTap: onEditMode,
      borderRadius: BorderRadius.circular(TossBorderRadius.lg),
      child: Container(
        padding: EdgeInsets.all(TossSpacing.paddingMD),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(TossBorderRadius.lg),
          border: Border.all(color: TossColors.border),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildMobileSamplePreview(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Sample Preview',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            TextButton(
              onPressed: onViewSample,
              child: const Text('View'),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Container(
          height: 200,
          padding: EdgeInsets.all(TossSpacing.paddingMD),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(TossBorderRadius.lg),
            border: Border.all(color: TossColors.border),
          ),
          child: _buildSampleChart(),
        ),
      ],
    );
  }
}