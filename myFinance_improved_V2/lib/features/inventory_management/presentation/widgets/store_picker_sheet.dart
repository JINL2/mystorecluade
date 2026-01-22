import 'package:flutter/material.dart';

import '../../../../shared/themes/toss_border_radius.dart';
import '../../../../shared/themes/toss_colors.dart';
import '../../../../shared/themes/toss_font_weight.dart';
import '../../../../shared/themes/toss_spacing.dart';
import '../../../../shared/themes/toss_text_styles.dart';
import '../../../../shared/widgets/organisms/sheets/selection_bottom_sheet_common.dart';
import 'move_stock_dialog.dart';

/// Reusable bottom sheet for selecting a store from a list
class StorePickerSheet extends StatelessWidget {
  const StorePickerSheet({
    super.key,
    required this.title,
    required this.stores,
    required this.onSelect,
  });

  final String title;
  final List<StoreLocation> stores;
  final void Function(StoreLocation store) onSelect;

  /// Show the store picker sheet
  static Future<void> show({
    required BuildContext context,
    required String title,
    required List<StoreLocation> stores,
    required void Function(StoreLocation store) onSelect,
  }) {
    return SelectionBottomSheetCommon.show(
      context: context,
      title: title,
      maxHeightRatio: 0.6,
      itemCount: stores.length,
      itemBuilder: (context, index) {
        final store = stores[index];
        return ListTile(
          leading: const Icon(
            Icons.store_outlined,
            color: TossColors.gray600,
          ),
          title: Text(
            store.name,
            style: TossTextStyles.body.copyWith(
              fontWeight: TossFontWeight.medium,
              color: TossColors.gray900,
            ),
          ),
          trailing: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: TossSpacing.badgePaddingHorizontalLG,
              vertical: TossSpacing.space1,
            ),
            decoration: BoxDecoration(
              color: TossColors.primarySurface,
              borderRadius: BorderRadius.circular(TossBorderRadius.sm),
            ),
            child: Text(
              '${store.stock}',
              style: TossTextStyles.bodySmall.copyWith(
                fontWeight: TossFontWeight.semibold,
                color: TossColors.primary,
              ),
            ),
          ),
          onTap: () {
            Navigator.pop(context);
            onSelect(store);
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.6,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: TossSpacing.space2),
            Container(
              width: TossSpacing.space9,
              height: TossSpacing.space1,
              decoration: BoxDecoration(
                color: TossColors.gray300,
                borderRadius: BorderRadius.circular(TossBorderRadius.dragHandle),
              ),
            ),
            const SizedBox(height: TossSpacing.space4),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: TossSpacing.space4),
              child: Text(
                title,
                style: TossTextStyles.titleLarge.copyWith(
                  color: TossColors.gray900,
                ),
              ),
            ),
            const SizedBox(height: TossSpacing.space3),
            Flexible(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: stores.length,
                itemBuilder: (context, index) {
                  final store = stores[index];
                  return ListTile(
                    leading: const Icon(
                      Icons.store_outlined,
                      color: TossColors.gray600,
                    ),
                    title: Text(
                      store.name,
                      style: TossTextStyles.body.copyWith(
                        fontWeight: TossFontWeight.medium,
                        color: TossColors.gray900,
                      ),
                    ),
                    trailing: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: TossSpacing.badgePaddingHorizontalLG,
                        vertical: TossSpacing.space1,
                      ),
                      decoration: BoxDecoration(
                        color: TossColors.primarySurface,
                        borderRadius: BorderRadius.circular(TossBorderRadius.sm),
                      ),
                      child: Text(
                        '${store.stock}',
                        style: TossTextStyles.bodySmall.copyWith(
                          fontWeight: TossFontWeight.semibold,
                          color: TossColors.primary,
                        ),
                      ),
                    ),
                    onTap: () {
                      Navigator.pop(context);
                      onSelect(store);
                    },
                  );
                },
              ),
            ),
            const SizedBox(height: TossSpacing.space4),
          ],
        ),
      ),
    );
  }
}
