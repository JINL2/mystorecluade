import 'package:flutter/material.dart';

import '../../../../../shared/themes/toss_border_radius.dart';
import '../../../../../shared/themes/toss_colors.dart';
import '../../../../../shared/themes/toss_text_styles.dart';
import '../../../../../shared/themes/toss_spacing.dart';
import '../move_stock_dialog.dart';

/// Individual store row item for the locations section
class StoreRowItem extends StatelessWidget {
  final StoreLocation store;
  final VoidCallback onTap;

  const StoreRowItem({
    super.key,
    required this.store,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        constraints: const BoxConstraints(minHeight: 48),
        padding: const EdgeInsets.symmetric(vertical: TossSpacing.space2),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Left side - store icon and name
            Expanded(
              child: Row(
                children: [
                  const Icon(
                    Icons.store_outlined,
                    size: 18,
                    color: TossColors.gray900,
                  ),
                  const SizedBox(width: TossSpacing.space2),
                  // Store name with "This store" badge
                  Flexible(
                    child: RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: store.name,
                            style: TossTextStyles.body.copyWith(
                              fontWeight: FontWeight.w500,
                              color: TossColors.gray900,
                            ),
                          ),
                          if (store.isCurrentStore)
                            TextSpan(
                              text: ' · This store',
                              style: TossTextStyles.bodySmall.copyWith(
                                fontWeight: FontWeight.w400,
                                color: TossColors.gray600,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Right side - stock badge and chevron
            Row(
              children: [
                Container(
                  height: 28,
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                    color: store.stock > 0
                        ? TossColors.primarySurface
                        : TossColors.gray100,
                    borderRadius: BorderRadius.circular(TossBorderRadius.sm),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    '${store.stock}',
                    style: TossTextStyles.body.copyWith(
                      fontWeight: FontWeight.w600,
                      color: store.stock > 0
                          ? TossColors.primary
                          : TossColors.gray400,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                const Icon(
                  Icons.chevron_right,
                  size: 18,
                  color: TossColors.gray500,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
