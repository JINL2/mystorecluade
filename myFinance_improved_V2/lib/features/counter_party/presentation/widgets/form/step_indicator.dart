import 'package:flutter/material.dart';
import 'package:myfinance_improved/shared/themes/toss_border_radius.dart';
import 'package:myfinance_improved/shared/themes/toss_colors.dart';
import 'package:myfinance_improved/shared/themes/toss_spacing.dart';

/// Step indicator for multi-step counter party form
///
/// Displays current progress through form steps with animated transitions.
class StepIndicator extends StatelessWidget {
  final int currentStep;
  final int totalSteps;

  const StepIndicator({
    super.key,
    required this.currentStep,
    required this.totalSteps,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: TossSpacing.space3),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(totalSteps, (index) {
          return Row(
            children: [
              // Step dot indicator
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                width: index == currentStep ? 32 : 8,
                height: 8,
                decoration: BoxDecoration(
                  color: index <= currentStep ? TossColors.primary : TossColors.gray300,
                  borderRadius: BorderRadius.circular(TossBorderRadius.xs),
                ),
              ),

              // Connector line between steps
              if (index < totalSteps - 1)
                Container(
                  width: 16,
                  height: 1,
                  color: index < currentStep ? TossColors.primary : TossColors.gray200,
                  margin: const EdgeInsets.symmetric(horizontal: 6),
                ),
            ],
          );
        }),
      ),
    );
  }
}
