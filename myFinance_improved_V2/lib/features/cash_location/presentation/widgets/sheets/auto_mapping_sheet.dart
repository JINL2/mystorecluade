import 'package:flutter/material.dart';
import 'package:myfinance_improved/shared/widgets/organisms/sheets/toss_selection_bottom_sheet.dart';

/// Bottom sheet for selecting auto mapping reason
/// Uses TossSelectionBottomSheet for consistent styling
class AutoMappingSheet {
  AutoMappingSheet._();

  /// Show auto mapping selection bottom sheet
  static Future<void> show({
    required BuildContext context,
    required Function(String) onMappingSelected,
  }) {
    final items = [
      TossSelectionItem(
        id: 'Error',
        title: 'Error',
        icon: Icons.error_outline,
      ),
      TossSelectionItem(
        id: 'Exchange Rate Differences',
        title: 'Exchange Rate Differences',
        icon: Icons.currency_exchange,
      ),
    ];

    return TossSelectionBottomSheet.show(
      context: context,
      title: 'Select Mapping Reason',
      items: items,
      showSubtitle: false,
      onItemSelected: (item) {
        onMappingSelected(item.id);
      },
    );
  }
}
