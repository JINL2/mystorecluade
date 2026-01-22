import 'package:flutter/material.dart';

import '../../../../../shared/themes/toss_border_radius.dart';
import '../../../../../shared/themes/toss_colors.dart';
import '../../../../../shared/themes/toss_spacing.dart';
import '../../../../../shared/themes/toss_text_styles.dart';
import 'package:myfinance_improved/shared/widgets/organisms/sheets/selection_bottom_sheet_common.dart';

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
    SelectionBottomSheetCommon.show(
      context: context,
      title: 'Select Store',
      showDividers: true,
      itemCount: stores.length,
      itemBuilder: (ctx, index) {
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
    );
  }

  @override
  Widget build(BuildContext context) {
    // This widget is no longer used directly; the static show method handles everything
    return const SizedBox.shrink();
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
