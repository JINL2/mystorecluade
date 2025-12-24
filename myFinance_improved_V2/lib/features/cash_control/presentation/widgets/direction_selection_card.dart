import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:myfinance_improved/shared/themes/index.dart';
import '../../domain/entities/cash_control_enums.dart';

/// Direction Selection Card (Cash In / Cash Out)
/// Minimal design - white background, gray borders, minimal colors
class DirectionSelectionCard extends StatelessWidget {
  final CashDirection direction;
  final bool isSelected;
  final VoidCallback onTap;

  const DirectionSelectionCard({
    super.key,
    required this.direction,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.selectionClick();
        onTap();
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.all(TossSpacing.space4),
        decoration: BoxDecoration(
          color: TossColors.white,
          borderRadius: BorderRadius.circular(TossBorderRadius.lg),
          border: Border.all(
            color: isSelected ? TossColors.gray900 : TossColors.gray200,
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Icon
            Icon(
              direction == CashDirection.cashIn
                  ? Icons.south_west
                  : Icons.north_east,
              size: 28,
              color: isSelected ? TossColors.gray900 : TossColors.gray400,
            ),

            const SizedBox(height: TossSpacing.space2),

            // Label
            Text(
              direction.label,
              style: TossTextStyles.body.copyWith(
                color: isSelected ? TossColors.gray900 : TossColors.gray600,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
              ),
            ),

            // Check indicator
            if (isSelected) ...[
              const SizedBox(height: TossSpacing.space2),
              const Icon(
                Icons.check,
                size: 18,
                color: TossColors.gray900,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
