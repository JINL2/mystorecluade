/// Step Indicator - Visual progress indicator for wizard navigation
///
/// Purpose: Shows current progress through a multi-step wizard process:
/// - Visual representation of current step vs total steps
/// - Clear indication of completed, current, and pending steps
/// - Consistent styling with Toss design system
/// - Supports any number of steps with responsive design
///
/// Usage: StepIndicator(currentStep: 2, totalSteps: 3)
import 'package:flutter/material.dart';
import 'package:myfinance_improved/core/themes/toss_colors.dart';
import 'package:myfinance_improved/core/themes/toss_spacing.dart';
import 'package:myfinance_improved/core/themes/toss_border_radius.dart';

class StepIndicator extends StatelessWidget {
  final int currentStep;
  final int totalSteps;
  final Color activeColor;
  final Color inactiveColor;
  final double? indicatorHeight;
  final double? indicatorSpacing;
  
  const StepIndicator({
    super.key,
    required this.currentStep,
    required this.totalSteps,
    this.activeColor = TossColors.primary,
    this.inactiveColor = TossColors.gray300,
    this.indicatorHeight = 8.0,
    this.indicatorSpacing,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(totalSteps, (index) {
        final isActive = index < currentStep;
        final isCurrent = index == currentStep - 1;
        final spacing = indicatorSpacing ?? TossSpacing.space1;
        
        return Container(
          margin: EdgeInsets.symmetric(horizontal: spacing),
          width: isCurrent ? 24 : 8,
          height: indicatorHeight,
          decoration: BoxDecoration(
            color: isActive ? activeColor : inactiveColor,
            borderRadius: BorderRadius.circular(TossBorderRadius.xs),
          ),
        );
      }),
    );
  }
  
  /// Get progress percentage (0.0 to 1.0)
  double get progress => currentStep / totalSteps;
  
  /// Check if wizard is complete
  bool get isComplete => currentStep >= totalSteps;
  
  /// Get step description for accessibility
  String get stepDescription => 'Step $currentStep of $totalSteps';
}