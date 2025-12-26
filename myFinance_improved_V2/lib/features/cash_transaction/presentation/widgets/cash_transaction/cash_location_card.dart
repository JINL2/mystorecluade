import 'package:flutter/material.dart';
import 'package:myfinance_improved/shared/themes/index.dart';

import '../../providers/cash_transaction_providers.dart';

/// Cash Location Card Widget
class CashLocationCard extends StatelessWidget {
  final CashLocation location;
  final bool isSelected;
  final IconData icon;
  final VoidCallback onTap;

  const CashLocationCard({
    super.key,
    required this.location,
    required this.isSelected,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(TossSpacing.space4),
        decoration: BoxDecoration(
          color: TossColors.white,
          borderRadius: BorderRadius.circular(TossBorderRadius.lg),
          border: Border.all(
            color: isSelected ? TossColors.gray900 : TossColors.gray200,
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: TossColors.gray100,
                borderRadius: BorderRadius.circular(TossBorderRadius.md),
              ),
              child: Center(
                child: Icon(
                  icon,
                  color: TossColors.gray600,
                  size: 22,
                ),
              ),
            ),
            const SizedBox(width: TossSpacing.space3),
            Expanded(
              child: Text(
                location.locationName,
                style: TossTextStyles.body.copyWith(
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                  color: TossColors.gray900,
                ),
              ),
            ),
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
