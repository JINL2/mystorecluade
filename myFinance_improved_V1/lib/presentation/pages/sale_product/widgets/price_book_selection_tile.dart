import 'package:flutter/material.dart';
import '../../../../core/themes/toss_colors.dart';
import '../../../../core/themes/toss_text_styles.dart';

class PriceBookSelectionTile extends StatelessWidget {
  final String priceBookName;
  final VoidCallback onTap;

  const PriceBookSelectionTile({
    super.key,
    required this.priceBookName,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: TossColors.gray100),
          ),
          child: Row(
            children: [
              Icon(
                Icons.local_offer_outlined,
                color: TossColors.gray600,
                size: 24,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  priceBookName,
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