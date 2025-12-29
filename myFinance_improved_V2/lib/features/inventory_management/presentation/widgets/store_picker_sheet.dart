import 'package:flutter/material.dart';

import '../../../../shared/themes/toss_border_radius.dart';
import '../../../../shared/themes/toss_colors.dart';
import '../../../../shared/themes/toss_spacing.dart';
import '../../../../shared/themes/toss_text_styles.dart';
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
    return showModalBottomSheet(
      context: context,
      backgroundColor: TossColors.white,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(TossBorderRadius.bottomSheet),
        ),
      ),
      builder: (context) => StorePickerSheet(
        title: title,
        stores: stores,
        onSelect: onSelect,
      ),
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
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: TossColors.gray300,
                borderRadius: BorderRadius.circular(2),
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
                        fontWeight: FontWeight.w500,
                        color: TossColors.gray900,
                      ),
                    ),
                    trailing: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: TossColors.primarySurface,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        '${store.stock}',
                        style: TossTextStyles.bodySmall.copyWith(
                          fontWeight: FontWeight.w600,
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
