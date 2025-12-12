import 'package:flutter/material.dart';
import '../../../../core/themes/toss_colors.dart';
import '../../../../core/themes/toss_text_styles.dart';
import 'package:myfinance_improved/core/themes/index.dart';
import 'package:myfinance_improved/core/themes/toss_border_radius.dart';
class CustomerSelectionTile extends StatelessWidget {
  final String customerName;
  final VoidCallback onTap;

  const CustomerSelectionTile({
    super.key,
    required this.customerName,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(TossBorderRadius.lg),
        child: Container(
          padding: const EdgeInsets.all(TossSpacing.space4),
          decoration: BoxDecoration(
            color: TossColors.white,
            borderRadius: BorderRadius.circular(TossBorderRadius.lg),
            border: Border.all(color: TossColors.gray100),
          ),
          child: Row(
            children: [
              Icon(
                Icons.person_outline,
                color: TossColors.gray600,
                size: 24,
              ),
              const SizedBox(width: TossSpacing.space4),
              Expanded(
                child: Text(
                  customerName,
                  style: TossTextStyles.body.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Icon(
                Icons.chevron_right,
                color: TossColors.gray400,
                size: 24,
              ),
            ],
          ),
        ),
      ),
    );
  }
}