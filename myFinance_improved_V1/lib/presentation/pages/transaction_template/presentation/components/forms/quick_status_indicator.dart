/// Quick Status Indicator - Visual status display for template complexity
///
/// Purpose: Shows template completion status with color-coded indicators:
/// - Complete: Green with flash icon (ready for instant creation)
/// - Amount Only: Blue with speed icon (just enter amount)
/// - Essential: Orange with tune icon (quick selections needed)
/// - Complex: Gray with settings icon (complex setup required)
///
/// Usage: QuickStatusIndicator(analysis: templateAnalysis)
import 'package:flutter/material.dart';
import '../../../../../../core/themes/toss_colors.dart';
import '../../../../../../core/themes/toss_text_styles.dart';
import '../../../../../../core/themes/toss_spacing.dart';
import '../../../../../../core/themes/toss_border_radius.dart';
import '../../../shared/utils/quick_template_analyzer.dart';

class QuickStatusIndicator extends StatelessWidget {
  final TemplateAnalysisResult analysis;
  final bool showEstimatedTime;
  
  const QuickStatusIndicator({
    super.key,
    required this.analysis,
    this.showEstimatedTime = true,
  });

  @override
  Widget build(BuildContext context) {
    final statusInfo = _getStatusInfo();
    
    return Container(
      padding: EdgeInsets.all(TossSpacing.space3),
      decoration: BoxDecoration(
        color: statusInfo.color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(TossBorderRadius.md),
        border: Border.all(color: statusInfo.color.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: statusInfo.color,
              shape: BoxShape.circle,
            ),
            child: Icon(
              statusInfo.icon,
              color: TossColors.white,
              size: 18,
            ),
          ),
          SizedBox(width: TossSpacing.space3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  statusInfo.title,
                  style: TossTextStyles.bodyLarge.copyWith(
                    fontWeight: FontWeight.w600,
                    color: statusInfo.color,
                  ),
                ),
                if (showEstimatedTime) ...[
                  Text(
                    'Estimated: ${analysis.estimatedTime}',
                    style: TossTextStyles.caption.copyWith(
                      color: TossColors.gray600,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  _StatusInfo _getStatusInfo() {
    switch (analysis.completeness) {
      case TemplateCompleteness.complete:
        return _StatusInfo(
          color: TossColors.success,
          icon: Icons.flash_on,
          title: 'Ready for instant creation',
        );
      case TemplateCompleteness.amountOnly:
        return _StatusInfo(
          color: TossColors.primary,
          icon: Icons.speed,
          title: 'Just enter amount',
        );
      case TemplateCompleteness.essential:
        return _StatusInfo(
          color: TossColors.warning,
          icon: Icons.tune,
          title: '${analysis.missingFields} quick selections needed',
        );
      case TemplateCompleteness.complex:
        return _StatusInfo(
          color: TossColors.gray600,
          icon: Icons.settings,
          title: 'Complex setup required',
        );
    }
  }
}

class _StatusInfo {
  final Color color;
  final IconData icon;
  final String title;
  
  const _StatusInfo({
    required this.color,
    required this.icon,
    required this.title,
  });
}