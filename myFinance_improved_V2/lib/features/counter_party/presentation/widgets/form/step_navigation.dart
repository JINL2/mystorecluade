import 'package:flutter/material.dart';
import 'package:myfinance_improved/shared/themes/toss_colors.dart';
import 'package:myfinance_improved/shared/themes/toss_spacing.dart';
import 'package:myfinance_improved/shared/widgets/index.dart';

/// Step navigation buttons for multi-step counter party form
///
/// Displays back/cancel and next/submit buttons with appropriate labels
/// and icons based on current step position.
class StepNavigation extends StatelessWidget {
  final int currentStep;
  final int totalSteps;
  final bool isLoading;
  final bool isCurrentStepValid;
  final bool isEditMode;
  final VoidCallback onPrevious;
  final VoidCallback onNext;
  final VoidCallback onCancel;

  const StepNavigation({
    super.key,
    required this.currentStep,
    required this.totalSteps,
    required this.isLoading,
    required this.isCurrentStepValid,
    required this.isEditMode,
    required this.onPrevious,
    required this.onNext,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(TossSpacing.space5),
      decoration: const BoxDecoration(
        color: TossColors.white,
        border: Border(
          top: BorderSide(color: TossColors.gray100),
        ),
      ),
      child: SafeArea(
        child: Row(
          children: [
            // Back/Cancel button
            if (currentStep > 0)
              Expanded(
                child: TossButton.secondary(
                  text: 'Back',
                  onPressed: isLoading ? null : onPrevious,
                  leadingIcon: Icon(Icons.arrow_back, size: TossSpacing.iconSM),
                  fullWidth: true,
                ),
              )
            else
              Expanded(
                child: TossButton.secondary(
                  text: 'Cancel',
                  onPressed: isLoading ? null : onCancel,
                  fullWidth: true,
                ),
              ),

            const SizedBox(width: TossSpacing.space3),

            // Next/Create/Update button
            Expanded(
              flex: 2,
              child: TossButton.primary(
                text: _getNextButtonText(),
                onPressed: !isCurrentStepValid ? null : onNext,
                isEnabled: isCurrentStepValid && !isLoading,
                isLoading: isLoading,
                leadingIcon: Icon(
                  _getNextButtonIcon(),
                  size: TossSpacing.iconSM,
                ),
                fullWidth: true,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getNextButtonText() {
    if (currentStep < totalSteps - 1) {
      return 'Next';
    }
    return isEditMode ? 'Update' : 'Create';
  }

  IconData _getNextButtonIcon() {
    if (currentStep < totalSteps - 1) {
      return Icons.arrow_forward;
    }
    return Icons.check;
  }
}
