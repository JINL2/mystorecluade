/// Quick Status Indicator - Visual status display for template complexity
///
/// Purpose: Shows template completion status with color-coded indicators:
/// - Complete: Green with flash icon (ready for instant creation)
/// - Amount Only: Blue with speed icon (just enter amount)
/// - Essential: Orange with tune icon (quick selections needed)
/// - Complex: Gray with settings icon (complex setup required)
///
/// Usage: QuickStatusIndicator(analysis: templateAnalysis)
library;
import 'package:flutter/material.dart';
import 'package:myfinance_improved/shared/themes/toss_border_radius.dart';
import 'package:myfinance_improved/shared/themes/toss_colors.dart';
import 'package:myfinance_improved/shared/themes/toss_spacing.dart';
import 'package:myfinance_improved/shared/themes/toss_text_styles.dart';

import '../../../domain/enums/template_enums.dart';
import '../../../domain/value_objects/template_analysis_result.dart';

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
      padding: const EdgeInsets.all(TossSpacing.space3),
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
          const SizedBox(width: TossSpacing.space3),
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
    switch (analysis.complexity) {
      case FormComplexity.simple:
        return const _StatusInfo(
          color: TossColors.success,
          icon: Icons.flash_on,
          title: 'Ready for instant creation',
        );
      case FormComplexity.withCash:
        return const _StatusInfo(
          color: TossColors.primary,
          icon: Icons.speed,
          title: 'Cash location needed',
        );
      case FormComplexity.withCounterparty:
        return _StatusInfo(
          color: TossColors.warning,
          icon: Icons.tune,
          title: '${analysis.missingFields} quick selections needed',
        );
      case FormComplexity.complex:
        return const _StatusInfo(
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