// lib/features/cash_ending/presentation/widgets/denomination_grid_header.dart

import 'package:flutter/material.dart';

import '../../../../shared/themes/toss_colors.dart';
import '../../../../shared/themes/toss_spacing.dart';
import '../../../../shared/themes/toss_text_styles.dart';

/// Grid header for denomination table
///
/// 3-column layout: Denomination | Qty | Amount
class DenominationGridHeader extends StatelessWidget {
  final String currencyCode;

  const DenominationGridHeader({
    super.key,
    required this.currencyCode,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: TossSpacing.space2,
      ),
      child: Row(
        children: [
          // Denomination column - left aligned
          Expanded(
            child: Text(
              'Denomination',
              style: TossTextStyles.caption,
            ),
          ),
          // Qty column - center (matches TossQuantityInput width)
          SizedBox(
            width: 154, // 90 (inputWidth) + 32*2 (buttons)
            child: Text(
              'Qty',
              textAlign: TextAlign.center,
              style: TossTextStyles.caption,
            ),
          ),
          // Amount column - right aligned
          Expanded(
            child: Text(
              'Amount ($currencyCode)',
              textAlign: TextAlign.right,
              style: TossTextStyles.caption,
            ),
          ),
        ],
      ),
    );
  }
}
