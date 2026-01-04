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
  }) async {
    String? selectedId;

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

    await TossSelectionBottomSheet.show(
      context: context,
      title: 'Select Mapping Reason',
      items: items,
      showSubtitle: false,
      onItemSelected: (item) {
        selectedId = item.id;
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
