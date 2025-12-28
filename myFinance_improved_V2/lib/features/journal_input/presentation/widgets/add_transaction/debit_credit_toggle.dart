import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../../shared/themes/toss_border_radius.dart';
import '../../../../../shared/themes/toss_colors.dart';
import '../../../../../shared/themes/toss_text_styles.dart';

/// Animated toggle widget for selecting Debit or Credit transaction type
///
/// Used in AddTransactionDialog to toggle between debit and credit modes.
/// Features smooth animation with color transition and haptic feedback.
class DebitCreditToggle extends StatelessWidget {
  final bool isDebit;
  final ValueChanged<bool> onChanged;

  const DebitCreditToggle({
    super.key,
    required this.isDebit,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      decoration: BoxDecoration(
        color: TossColors.gray50,
        borderRadius: BorderRadius.circular(TossBorderRadius.lg),
      ),
      padding: const EdgeInsets.all(4),
      child: Stack(
        children: [
          // Animated selection indicator
          AnimatedAlign(
            alignment: isDebit ? Alignment.centerLeft : Alignment.centerRight,
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeInOut,
            child: FractionallySizedBox(
              widthFactor: 0.5,
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 2),
                decoration: BoxDecoration(
                  color: isDebit ? TossColors.primary : TossColors.success,
                  borderRadius: BorderRadius.circular(TossBorderRadius.md),
                  boxShadow: [
                    BoxShadow(
                      color: (isDebit ? TossColors.primary : TossColors.success)
                          .withValues(alpha: 0.3),
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
                child: _TypeButton(
                  label: 'Debit',
                  isSelected: isDebit,
                  onTap: () => _handleTap(true),
                ),
              ),
              Expanded(
                child: _TypeButton(
                  label: 'Credit',
                  isSelected: !isDebit,
                  onTap: () => _handleTap(false),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _handleTap(bool debit) {
    if (isDebit != debit) {
      onChanged(debit);
      HapticFeedback.lightImpact();
    }
  }
}

class _TypeButton extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _TypeButton({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        color: TossColors.transparent,
        child: Center(
          child: AnimatedDefaultTextStyle(
            duration: const Duration(milliseconds: 200),
            style: TossTextStyles.body.copyWith(
              color: isSelected ? TossColors.white : TossColors.gray600,
              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
            ),
            child: Text(label),
          ),
        ),
      ),
    );
  }
}
