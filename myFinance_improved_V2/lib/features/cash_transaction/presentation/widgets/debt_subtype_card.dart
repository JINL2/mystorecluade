import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:myfinance_improved/shared/themes/index.dart';
import '../../domain/entities/cash_transaction_enums.dart';

/// Debt Subtype Selection Card
/// Minimal design - simple list item style
class DebtSubtypeCard extends StatelessWidget {
  final DebtSubType subType;
  final bool isSelected;
  final VoidCallback onTap;

  const DebtSubtypeCard({
    super.key,
    required this.subType,
    required this.isSelected,
    required this.onTap,
  });

  IconData get _icon {
    switch (subType) {
      case DebtSubType.lendMoney:
        return Icons.arrow_forward;
      case DebtSubType.collectDebt:
        return Icons.arrow_back;
      case DebtSubType.borrowMoney:
        return Icons.arrow_back;
      case DebtSubType.repayDebt:
        return Icons.arrow_forward;
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
            // Direction icon
            Container(
              width: 36,
              height: 36,
              decoration: const BoxDecoration(
                color: TossColors.gray50,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Icon(
                  _icon,
                  color: TossColors.gray600,
                  size: 18,
                ),
              ),
            ),

            const SizedBox(width: TossSpacing.space3),

            // Text content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    subType.label,
                    style: TossTextStyles.body.copyWith(
                      color: TossColors.gray900,
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: TossSpacing.space1 / 2),
                  Text(
                    subType.description,
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
