import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../../shared/themes/toss_border_radius.dart';
import '../../../../../shared/themes/toss_colors.dart';
import '../../../../../shared/themes/toss_spacing.dart';
import '../../../../../shared/themes/toss_text_styles.dart';

/// Problem Status Section
///
/// A widget for toggling and displaying problem status in shift details.
class ProblemStatusSection extends StatelessWidget {
  final bool isProblemSolved;
  final ValueChanged<bool> onStatusChanged;

  const ProblemStatusSection({
    super.key,
    required this.isProblemSolved,
    required this.onStatusChanged,
  });

  Widget _buildProblemToggleButton(String label, bool isSolved) {
    final isSelected = isProblemSolved == isSolved;
    return GestureDetector(
      onTap: () {
        if (!isSelected) {
          onStatusChanged(isSolved);
          // Add haptic feedback for better user experience
          HapticFeedback.lightImpact();
        }
      },
      child: Container(
        color: TossColors.transparent,
        child: Center(
          child: AnimatedDefaultTextStyle(
            duration: const Duration(milliseconds: 200),
            style: TossTextStyles.bodySmall.copyWith(
              color: isSelected ? TossColors.white : TossColors.gray700,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
            ),
            child: Text(label),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(TossSpacing.space4),
      decoration: BoxDecoration(
        color: TossColors.gray50,
        borderRadius: BorderRadius.circular(TossBorderRadius.xl),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with problem status
          Row(
            children: [
              Icon(
                Icons.warning_amber_rounded,
                size: 20,
                color: isProblemSolved ? TossColors.success : TossColors.warning,
              ),
              const SizedBox(width: TossSpacing.space2),
              Text(
                'Problem Status',
                style: TossTextStyles.body.copyWith(
                  color: TossColors.gray900,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: TossSpacing.space3),
          // Animated toggle button - Same style as journal input
          Container(
            height: 48,
            decoration: BoxDecoration(
              color: TossColors.gray50,
              borderRadius: BorderRadius.circular(TossBorderRadius.lg),
            ),
            padding: const EdgeInsets.all(TossSpacing.space1),
            child: Stack(
              children: [
                // Animated selection indicator
                AnimatedAlign(
                  alignment: isProblemSolved
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
                  duration: const Duration(milliseconds: 250),
                  curve: Curves.easeInOut,
                  child: FractionallySizedBox(
                    widthFactor: 0.5,
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 2),
                      decoration: BoxDecoration(
                        color: isProblemSolved
                            ? TossColors.success
                            : TossColors.warning,
                        borderRadius: BorderRadius.circular(TossBorderRadius.xxl),
                        boxShadow: [
                          BoxShadow(
                            color: (isProblemSolved
                                ? TossColors.success
                                : TossColors.warning).withValues(alpha: 0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                // Buttons
                Row(
                  children: [
                    Expanded(
                      child: _buildProblemToggleButton('Not solve', false),
                    ),
                    Expanded(
                      child: _buildProblemToggleButton('Solved', true),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: TossSpacing.space2),
          // Status description
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            child: Row(
              children: [
                Icon(
                  isProblemSolved ? Icons.check_circle_outline : Icons.info_outline,
                  size: 16,
                  color: isProblemSolved ? TossColors.success : TossColors.gray600,
                ),
                const SizedBox(width: TossSpacing.space1),
                Expanded(
                  child: Text(
                    isProblemSolved
                        ? 'The shift problem has been resolved'
                        : 'Toggle on when the problem is resolved',
                    style: TossTextStyles.caption.copyWith(
                      color: isProblemSolved ? TossColors.success : TossColors.gray600,
                      fontSize: 13,
                    ),
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
