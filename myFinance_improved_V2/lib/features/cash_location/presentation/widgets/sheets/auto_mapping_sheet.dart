import 'package:flutter/material.dart';
import 'package:myfinance_improved/shared/models/selection_item.dart';
import 'package:myfinance_improved/shared/widgets/organisms/sheets/selection_bottom_sheet_common.dart';
import 'package:myfinance_improved/shared/widgets/molecules/sheets/selection_list_item.dart';

/// Bottom sheet for selecting auto mapping reason
/// Uses SelectionBottomSheetCommon for consistent styling
class AutoMappingSheet {
  AutoMappingSheet._();

  /// Show auto mapping selection bottom sheet
  static Future<void> show({
    required BuildContext context,
    required Function(String) onMappingSelected,
  }) async {
    String? selectedId;

    final items = [
      SelectionItem(
        id: 'Error',
        title: 'Error',
        icon: Icons.error_outline,
      ),
      SelectionItem(
        id: 'Exchange Rate Differences',
        title: 'Exchange Rate Differences',
        icon: Icons.currency_exchange,
      ),
    ];

    await SelectionBottomSheetCommon.show(
      context: context,
      title: 'Select Mapping Reason',
      itemCount: items.length,
      itemBuilder: (ctx, index) {
        final item = items[index];
        return SelectionListItem(
          item: item,
          isSelected: false,
          variant: SelectionItemVariant.standard,
          onTap: () {
            selectedId = item.id;
            Navigator.pop(ctx);
          },
        );
      },
    );

    // Call the callback after the bottom sheet is fully closed
    // to avoid Navigator lock issues
    if (selectedId != null) {
      // Use addPostFrameCallback to ensure Navigator is unlocked
      WidgetsBinding.instance.addPostFrameCallback((_) {
        onMappingSelected(selectedId!);
      });
    }
  }
}
