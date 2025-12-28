import 'package:flutter/material.dart';

import '../../../../../shared/themes/toss_border_radius.dart';
import '../../../../../shared/themes/toss_colors.dart';
import '../../../../../shared/themes/toss_spacing.dart';
import '../../../../../shared/themes/toss_text_styles.dart';

/// Callback type for store selection
typedef OnStoreSelected = void Function(String storeId, String storeName);

/// Bottom sheet for selecting a store from counterparty's stores
///
/// Used in AddTransactionDialog when a counterparty has multiple stores.
/// Displays a list of stores with a clean bottom sheet UI.
class StoreSelectionSheet extends StatelessWidget {
  final List<Map<String, dynamic>> stores;
  final OnStoreSelected onStoreSelected;

  const StoreSelectionSheet({
    super.key,
    required this.stores,
    required this.onStoreSelected,
  });

  /// Shows the store selection bottom sheet
  static void show({
    required BuildContext context,
    required List<Map<String, dynamic>> stores,
    required OnStoreSelected onStoreSelected,
  }) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: TossColors.transparent,
      builder: (context) => StoreSelectionSheet(
        stores: stores,
        onStoreSelected: onStoreSelected,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: TossColors.surface,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(TossBorderRadius.xxl),
          topRight: Radius.circular(TossBorderRadius.xxl),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle bar
          Container(
            margin: const EdgeInsets.only(top: TossSpacing.space3),
            width: 36,
            height: 4,
            decoration: BoxDecoration(
              color: TossColors.gray300,
              borderRadius: BorderRadius.circular(TossBorderRadius.xs),
            ),
          ),
          // Header
          Padding(
            padding: const EdgeInsets.all(TossSpacing.space4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Select Store',
                  style: TossTextStyles.h3.copyWith(fontWeight: FontWeight.w600),
                ),
                IconButton(
                  icon: const Icon(Icons.close, color: TossColors.gray500),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),
          // Store list
          Flexible(
            child: ListView.separated(
              shrinkWrap: true,
              padding: const EdgeInsets.symmetric(horizontal: TossSpacing.space4),
              itemCount: stores.length,
              separatorBuilder: (context, index) => Container(
                height: 1,
                color: TossColors.gray100,
              ),
              itemBuilder: (context, index) {
                final store = stores[index];
                final storeId = store['store_id'] as String?;
                final storeName = store['store_name'] as String? ?? 'Unknown Store';

                return _StoreListItem(
                  storeName: storeName,
                  onTap: () {
                    if (storeId != null) {
                      onStoreSelected(storeId, storeName);
                    }
                    Navigator.pop(context);
                  },
                );
              },
            ),
          ),
          SizedBox(height: MediaQuery.of(context).padding.bottom + TossSpacing.space4),
        ],
      ),
    );
  }
}

class _StoreListItem extends StatelessWidget {
  final String storeName;
  final VoidCallback onTap;

  const _StoreListItem({
    required this.storeName,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: TossSpacing.space4,
          vertical: TossSpacing.space3,
        ),
        child: Row(
          children: [
            const Icon(Icons.store, size: 20, color: TossColors.gray500),
            const SizedBox(width: TossSpacing.space3),
            Expanded(
              child: Text(
                storeName,
                style: TossTextStyles.body.copyWith(fontWeight: FontWeight.w500),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
