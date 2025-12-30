import 'package:flutter/material.dart';

import '../../../../../shared/themes/index.dart';

/// Progress Indicator Widget for multi-step forms
///
/// Shows 3 step progress dots with active/completed states.
class ProgressIndicatorWidget extends StatelessWidget {
  final int currentStep;
  final int totalSteps;

  const ProgressIndicatorWidget({
    super.key,
    required this.currentStep,
    this.totalSteps = 3,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(totalSteps, (index) {
        final stepNumber = index + 1;
        final isActive = stepNumber == currentStep;
        final isCompleted = stepNumber < currentStep;

        return Row(
          children: [
            Container(
              width: isActive ? 32 : 8,
              height: 8,
              decoration: BoxDecoration(
                color: isActive || isCompleted
                    ? TossColors.primary
                    : TossColors.gray300,
                borderRadius: BorderRadius.circular(TossBorderRadius.xs),
              ),
            ),
            if (index < totalSteps - 1) const SizedBox(width: 8),
          ],
        );
      }),
    );
  }
}
