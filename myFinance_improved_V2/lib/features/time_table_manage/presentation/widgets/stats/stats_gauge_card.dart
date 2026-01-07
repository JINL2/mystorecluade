import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'package:myfinance_improved/shared/themes/index.dart';

/// Store health section with period selector and two semi-circle gauges
class StatsGaugeCard extends StatelessWidget {
  final String selectedPeriod;
  final VoidCallback onPeriodTap;
  final double onTimeRate;
  final String onTimeDisplay;
  final int problemSolved;
  final int totalProblems;
  final VoidCallback? onProblemSolvesTap;

  const StatsGaugeCard({
    super.key,
    required this.selectedPeriod,
    required this.onPeriodTap,
    required this.onTimeRate,
    required this.onTimeDisplay,
    required this.problemSolved,
    required this.totalProblems,
    this.onProblemSolvesTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
          // Header with period selector
          GestureDetector(
            onTap: onPeriodTap,
            child: Row(
              children: [
                Text(
                  'Store Health',
                  style: TossTextStyles.titleMedium,
                ),
                const SizedBox(width: TossSpacing.space2),
                Text(
                  selectedPeriod,
                  style: TossTextStyles.titleMedium,
                ),
                const SizedBox(width: TossSpacing.space0_5),
                Icon(
                  Icons.keyboard_arrow_down,
                  size: TossSpacing.iconSM,
                  color: TossColors.gray600,
                ),
              ],
            ),
          ),
          const SizedBox(height: TossSpacing.space4),

          // Two gauges
          Row(
            children: [
              Expanded(
                child: _GaugeWidget(
                  value: onTimeRate,
                  displayValue: onTimeDisplay,
                  label: 'On-time rate',
                  color: TossColors.primary,
                  showArrow: false,
                ),
              ),
              const SizedBox(width: TossSpacing.space3),
              Expanded(
                child: _GaugeWidget(
                  value: problemSolved / totalProblems,
                  displayValue: '$problemSolved/$totalProblems',
                  label: 'Problem solves',
                  color: TossColors.error,
                  onTap: onProblemSolvesTap ?? () {},
                ),
              ),
            ],
          ),
      ],
    );
  }
}

/// Individual gauge widget with semi-circle indicator
class _GaugeWidget extends StatelessWidget {
  final double value;
  final String displayValue;
  final String label;
  final Color color;
  final VoidCallback? onTap;
  final bool showArrow;

  const _GaugeWidget({
    required this.value,
    required this.displayValue,
    required this.label,
    required this.color,
    this.onTap,
    this.showArrow = true,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: TossDimensions.statsGaugeCardHeight,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CustomPaint(
            size: const Size(160, 90),
            painter: _SemiCircleGaugePainter(
              value: value,
              backgroundColor: TossColors.gray200,
              foregroundColor: color,
              strokeWidth: 6,
            ),
          ),
          Positioned(
            bottom: TossSpacing.space2,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: TossSpacing.space4),
                Text(
                  displayValue,
                  style: TossTextStyles.h4.copyWith(
                    fontWeight: TossFontWeight.bold,
                  ),
                ),
                const SizedBox(height: TossSpacing.space1),
                GestureDetector(
                  onTap: onTap,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        label,
                        style: TossTextStyles.label.copyWith(
                          fontWeight: TossFontWeight.medium,
                          color: TossColors.gray600,
                        ),
                      ),
                      if (showArrow) ...[
                        const SizedBox(width: TossSpacing.space0_5),
                        Icon(
                          Icons.chevron_right,
                          size: TossSpacing.iconXS,
                          color: TossColors.gray600,
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Custom painter for semi-circle gauge
class _SemiCircleGaugePainter extends CustomPainter {
  final double value; // 0.0 to 1.0
  final Color backgroundColor;
  final Color foregroundColor;
  final double strokeWidth;

  _SemiCircleGaugePainter({
    required this.value,
    required this.backgroundColor,
    required this.foregroundColor,
    required this.strokeWidth,
  });

  // Clamp value to 0.0-1.0 range to prevent overflow
  double get clampedValue => value.clamp(0.0, 1.0);

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height);
    final radius = size.width / 2 - strokeWidth;

    // Background arc
    final bgPaint = Paint()
      ..color = backgroundColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      math.pi, // Start angle (180 degrees)
      math.pi, // Sweep angle (180 degrees for semi-circle)
      false,
      bgPaint,
    );

    // Foreground arc
    final fgPaint = Paint()
      ..color = foregroundColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      math.pi, // Start angle
      math.pi * clampedValue, // Sweep angle based on clamped value (0.0-1.0)
      false,
      fgPaint,
    );
  }

  @override
  bool shouldRepaint(covariant _SemiCircleGaugePainter oldDelegate) {
    return oldDelegate.value != value ||
        oldDelegate.foregroundColor != foregroundColor;
  }
}
