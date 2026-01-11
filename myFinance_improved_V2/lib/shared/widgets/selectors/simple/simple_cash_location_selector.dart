import 'package:flutter/material.dart';
import 'package:myfinance_improved/shared/models/index.dart';
import 'package:myfinance_improved/shared/widgets/organisms/sheets/modal_bottom_sheet.dart';

/// Simple cash location selection (minimal style)
///
/// Note: This is a simpler version that works with raw data.
/// For autonomous state-managed cash location selection, use `CashLocationSelector`
/// from `selectors/cash_location/`.
class SimpleCashLocationSelector {
  /// Show cash location selection bottom sheet
  static Future<Map<String, dynamic>?> show({
    required BuildContext context,
    required List<dynamic> locations,
    String? selectedId,
    String title = 'Cash Location',
  }) async {
    final items = locations.map((loc) {
      final map = loc as Map<String, dynamic>;
      return SelectionItem(
        id: map['id']?.toString() ??
            map['cash_location_id']?.toString() ??
            '',
        title: map['name']?.toString() ??
            map['cash_location_name']?.toString() ??
            '',
        data: map,
      );
    }).toList();

    final result = await ModalBottomSheet.show(
      context: context,
      title: title,
      items: items,
      selectedId: selectedId,
      config: ModalSheetConfig.minimal,
    );

    return result?.data;
  }
}
