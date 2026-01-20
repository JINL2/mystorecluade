import 'package:flutter/material.dart';

import '../../../../../shared/index.dart';
import '../../domain/entities/threshold_info.dart';

/// 임계값 정보 카드 위젯
/// P10/P25 통계 임계값 표시
class ThresholdInfoCard extends StatelessWidget {
  final ThresholdInfo thresholds;

  const ThresholdInfoCard({
    super.key,
    required this.thresholds,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(TossSpacing.paddingMD),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [TossColors.primary, TossColors.primary.withOpacity(0.8)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(TossBorderRadius.card),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 헤더
          Row(
            children: [
              const Icon(
                Icons.settings_outlined,
                color: TossColors.white,
                size: TossSpacing.iconSM,
              ),
              const SizedBox(width: TossSpacing.gapSM),
              Text(
                'Threshold Settings',
                style: TossTextStyles.subtitle.copyWith(
                  color: TossColors.white,
                  fontWeight: TossFontWeight.semibold,
                ),
              ),
            ],
          ),
          const SizedBox(height: TossSpacing.gapLG),

          // 임계값 정보
          Row(
            children: [
              Expanded(
                child: _ThresholdItem(
                  label: 'Critical (P10)',
                  value: '${thresholds.criticalDays.toStringAsFixed(1)} days',
                  icon: Icons.local_fire_department_rounded,
                ),
              ),
              Expanded(
                child: _ThresholdItem(
                  label: 'Warning (P25)',
                  value: '${thresholds.warningDays.toStringAsFixed(1)} days',
                  icon: Icons.warning_amber_rounded,
                ),
              ),
            ],
          ),
          const SizedBox(height: TossSpacing.gapMD),

          // 소스 정보
          Row(
            children: [
              Icon(
                thresholds.isCalculated
                    ? Icons.auto_graph_rounded
                    : Icons.tune_rounded,
                color: TossColors.white.withOpacity(0.9),
                size: TossSpacing.iconXS,
              ),
              const SizedBox(width: TossSpacing.gapXS),
              Text(
                'Sample: ${thresholds.sampleSize} products (${thresholds.sourceTextEn})',
                style: TossTextStyles.caption.copyWith(
                  color: TossColors.white.withOpacity(0.9),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ThresholdItem extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const _ThresholdItem({
    required this.label,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              icon,
              color: TossColors.white.withOpacity(0.9),
              size: TossSpacing.iconXS,
            ),
            const SizedBox(width: TossSpacing.marginXS),
            Text(
              label,
              style: TossTextStyles.caption.copyWith(
                color: TossColors.white.withOpacity(0.9),
              ),
            ),
          ],
        ),
        const SizedBox(height: TossSpacing.marginXS),
        Text(
          value,
          style: TossTextStyles.h4.copyWith(
            color: TossColors.white,
            fontWeight: TossFontWeight.bold,
          ),
        ),
      ],
    );
  }
}
