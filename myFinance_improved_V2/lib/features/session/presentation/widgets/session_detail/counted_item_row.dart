import 'package:flutter/material.dart';

import '../../../../../shared/themes/toss_colors.dart';
import '../../../../../shared/themes/toss_spacing.dart';
import '../../../../../shared/themes/toss_text_styles.dart';
import '../../providers/states/session_detail_state.dart';
import 'package:myfinance_improved/shared/widgets/index.dart';

/// Row widget for displaying a counted item in the bottom bar
class CountedItemRow extends StatelessWidget {
  final SelectedProduct item;
  final VoidCallback onTap;

  const CountedItemRow({
    super.key,
    required this.item,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: TossSpacing.space2),
        child: Row(
          children: [
            // Product image
            CachedProductImage(
              imageUrl: item.imageUrl,
              size: 40,
              borderRadius: 6,
            ),
            const SizedBox(width: TossSpacing.space3),
            // Product info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.productName,
                    style: TossTextStyles.caption.copyWith(
                      fontWeight: FontWeight.w600,
                      color: TossColors.gray900,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (item.sku != null)
                    Text(
                      item.sku!,
                      style: TossTextStyles.small.copyWith(
                        color: TossColors.gray500,
                      ),
                    ),
                ],
              ),
            ),
            // Quantity only
            Text(
              '${item.quantity}',
              style: TossTextStyles.body.copyWith(
                fontWeight: FontWeight.w600,
                color: TossColors.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
