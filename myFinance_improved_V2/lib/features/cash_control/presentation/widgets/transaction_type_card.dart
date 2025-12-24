import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:myfinance_improved/shared/themes/index.dart';
import '../../domain/entities/cash_control_enums.dart';

/// Transaction Type Selection Card (Expense/Debt/Transfer)
/// Minimal design - simple list item style
class TransactionTypeCard extends StatelessWidget {
  final TransactionType type;
  final bool isSelected;
  final VoidCallback onTap;

  const TransactionTypeCard({
    super.key,
    required this.type,
    required this.isSelected,
    required this.onTap,
  });

  IconData get _icon {
    switch (type) {
      case TransactionType.expense:
        return Icons.receipt_long_outlined;
      case TransactionType.debt:
        return Icons.swap_horiz;
      case TransactionType.transfer:
        return Icons.compare_arrows;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.selectionClick();
        onTap();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: TossSpacing.space4,
          vertical: TossSpacing.space3,
        ),
        decoration: BoxDecoration(
          color: TossColors.white,
          borderRadius: BorderRadius.circular(TossBorderRadius.md),
          border: Border.all(
            color: isSelected ? TossColors.gray900 : TossColors.gray200,
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            // Icon
            Icon(
              _icon,
              size: 22,
              color: isSelected ? TossColors.gray900 : TossColors.gray500,
            ),

            const SizedBox(width: TossSpacing.space3),

            // Text content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    type.label,
                    style: TossTextStyles.body.copyWith(
                      color: TossColors.gray900,
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    type.description,
                    style: TossTextStyles.caption.copyWith(
                      color: TossColors.gray500,
                    ),
                  ),
                ],
              ),
            ),

            // Check or arrow
            Icon(
              isSelected ? Icons.check : Icons.chevron_right,
              color: isSelected ? TossColors.gray900 : TossColors.gray300,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}
