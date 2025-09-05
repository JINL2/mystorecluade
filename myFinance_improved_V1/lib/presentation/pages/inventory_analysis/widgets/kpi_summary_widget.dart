import 'package:flutter/material.dart';
import '../../../../core/themes/toss_colors.dart';
import '../../../../core/themes/toss_text_styles.dart';
import '../../../../core/themes/toss_spacing.dart';
import '../../../../core/themes/toss_border_radius.dart';
import '../models/supply_chain_models.dart';
import 'package:myfinance_improved/core/themes/index.dart';

class KPISummaryWidget extends StatelessWidget {
  final List<SupplyChainKPI> kpis;
  final bool isMobile;
  final Function(SupplyChainKPI)? onKPITap;

  const KPISummaryWidget({
    super.key,
    required this.kpis,
    this.isMobile = false,
    this.onKPITap,
  });

  @override
  Widget build(BuildContext context) {
    if (kpis.isEmpty) {
      return _buildEmptyState(context);
    }

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
            _buildMobileKPIList(context)
          else
            _buildDesktopKPIGrid(context),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final criticalCount = kpis.where((kpi) => kpi.type == KPIType.critical).length;
    final warningCount = kpis.where((kpi) => kpi.type == KPIType.warning).length;
    
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
              color: TossColors.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(TossBorderRadius.md),
            ),
            child: Icon(
              Icons.dashboard_outlined,
              color: TossColors.primary,
              size: 20,
            ),
          ),
          SizedBox(width: TossSpacing.space3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Key Performance Indicators',
                  style: TossTextStyles.h4.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '$criticalCount critical, $warningCount warnings',
                  style: TossTextStyles.caption.copyWith(
                    color: TossColors.gray600,
                  ),
                ),
              ],
            ),
          ),
          _buildKPIStatusBadge(context, criticalCount, warningCount),
        ],
      ),
    );
  }

  Widget _buildKPIStatusBadge(BuildContext context, int critical, int warning) {
    Color badgeColor;
    String statusText;
    
    if (critical > 0) {
      badgeColor = TossColors.error;
      statusText = 'Action Needed';
    } else if (warning > 0) {
      badgeColor = TossColors.warning;
      statusText = 'Monitor';
    } else {
      badgeColor = TossColors.success;
      statusText = 'Good';
    }
    
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: TossSpacing.space2,
        vertical: TossSpacing.space1,
      ),
      decoration: BoxDecoration(
        color: badgeColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(TossBorderRadius.sm),
      ),
      child: Text(
        statusText,
        style: TossTextStyles.caption.copyWith(
          color: badgeColor,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildDesktopKPIGrid(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(TossSpacing.space4),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: kpis.length > 4 ? 3 : 2,
          crossAxisSpacing: TossSpacing.space3,
          mainAxisSpacing: TossSpacing.space3,
          childAspectRatio: 1.5,
        ),
        itemCount: kpis.length,
        itemBuilder: (context, index) {
          return _buildKPICard(context, kpis[index]);
        },
      ),
    );
  }

  Widget _buildMobileKPIList(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(TossSpacing.space4),
      child: Column(
        children: kpis.asMap().entries.map((entry) {
          final index = entry.key;
          final kpi = entry.value;
          
          return Column(
            children: [
              _buildMobileKPICard(context, kpi),
              if (index < kpis.length - 1)
                SizedBox(height: TossSpacing.space3),
            ],
          );
        }).toList(),
      ),
    );
  }

  Widget _buildKPICard(BuildContext context, SupplyChainKPI kpi) {
    return InkWell(
      onTap: () => onKPITap?.call(kpi),
      borderRadius: BorderRadius.circular(TossBorderRadius.md),
      child: Container(
        padding: EdgeInsets.all(TossSpacing.space3),
        decoration: BoxDecoration(
          color: kpi.color.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(TossBorderRadius.md),
          border: Border.all(
            color: kpi.color.withValues(alpha: 0.2),
            width: 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Header
            Row(
              children: [
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: kpi.color.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(TossBorderRadius.sm),
                  ),
                  child: Icon(
                    kpi.icon,
                    color: kpi.color,
                    size: 16,
                  ),
                ),
                SizedBox(width: TossSpacing.space2),
                Expanded(
                  child: Text(
                    _getKPIEnglishLabel(kpi.type),
                    style: TossTextStyles.caption.copyWith(
                      color: TossColors.gray600,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            
            Spacer(),
            
            // Value
            Text(
              kpi.value,
              style: TossTextStyles.h3.copyWith(
                fontWeight: FontWeight.bold,
                color: kpi.color,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            
            // Trend
            if (kpi.previousValue != null)
              Row(
                children: [
                  Icon(
                    _getTrendIcon(kpi.trend),
                    color: _getTrendColor(kpi.trend),
                    size: 14,
                  ),
                  SizedBox(width: TossSpacing.space1),
                  Text(
                    'vs ${kpi.previousValue}',
                    style: TossTextStyles.small.copyWith(
                      color: TossColors.gray500,
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildMobileKPICard(BuildContext context, SupplyChainKPI kpi) {
    return InkWell(
      onTap: () => onKPITap?.call(kpi),
      borderRadius: BorderRadius.circular(TossBorderRadius.md),
      child: Container(
        padding: EdgeInsets.all(TossSpacing.space3),
        decoration: BoxDecoration(
          color: kpi.color.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(TossBorderRadius.md),
          border: Border.all(
            color: kpi.color.withValues(alpha: 0.2),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            // Icon
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: kpi.color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(TossBorderRadius.md),
              ),
              child: Icon(
                kpi.icon,
                color: kpi.color,
                size: 24,
              ),
            ),
            
            SizedBox(width: TossSpacing.space3),
            
            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _getKPIEnglishLabel(kpi.type),
                    style: TossTextStyles.body.copyWith(
                      fontWeight: FontWeight.w600,
                      color: TossColors.gray900,
                    ),
                  ),
                  SizedBox(height: TossSpacing.space1),
                  Text(
                    kpi.value,
                    style: TossTextStyles.h3.copyWith(
                      fontWeight: FontWeight.bold,
                      color: kpi.color,
                    ),
                  ),
                  if (kpi.previousValue != null) ...[
                    SizedBox(height: TossSpacing.space1),
                    Row(
                      children: [
                        Icon(
                          _getTrendIcon(kpi.trend),
                          color: _getTrendColor(kpi.trend),
                          size: 16,
                        ),
                        SizedBox(width: TossSpacing.space1),
                        Text(
                          'vs ${kpi.previousValue}',
                          style: TossTextStyles.caption.copyWith(
                            color: TossColors.gray500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
            
            // Chevron
            Icon(
              Icons.chevron_right,
              color: TossColors.gray400,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(TossSpacing.space6),
      decoration: BoxDecoration(
        color: TossColors.surface,
        borderRadius: BorderRadius.circular(TossBorderRadius.xl),
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
              color: TossColors.gray300.withValues(alpha: 0.5),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.dashboard_outlined,
              color: TossColors.gray600,
              size: 32,
            ),
          ),
          
          SizedBox(height: TossSpacing.space3),
          
          Text(
            'No KPI Data',
            style: TossTextStyles.h4.copyWith(
              fontWeight: FontWeight.bold,
              color: TossColors.gray600,
            ),
          ),
          
          SizedBox(height: TossSpacing.space1),
          
          Text(
            'KPI metrics will appear here once data is available.',
            style: TossTextStyles.body.copyWith(
              color: TossColors.gray500,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  String _getKPIEnglishLabel(KPIType type) {
    switch (type) {
      case KPIType.critical:
        return 'Critical Issues';
      case KPIType.warning:
        return 'Warning Items';
      case KPIType.normal:
        return 'Normal Operations';
      case KPIType.valueAtRisk:
        return 'Value at Risk';
    }
  }

  IconData _getTrendIcon(KPITrend trend) {
    switch (trend) {
      case KPITrend.up:
        return Icons.trending_up;
      case KPITrend.down:
        return Icons.trending_down;
      case KPITrend.stable:
        return Icons.trending_flat;
    }
  }

  Color _getTrendColor(KPITrend trend) {
    switch (trend) {
      case KPITrend.up:
        return TossColors.success;
      case KPITrend.down:
        return TossColors.error;
      case KPITrend.stable:
        return TossColors.info;
    }
  }
}