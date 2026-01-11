import 'package:flutter/material.dart';
import 'package:myfinance_improved/shared/models/index.dart';
import 'package:myfinance_improved/shared/widgets/organisms/sheets/modal_bottom_sheet.dart';
import 'package:myfinance_improved/core/constants/icon_mapper.dart';

/// Simple store selection bottom sheet (works with raw data)
///
/// Note: This is named with "Simple" prefix to avoid conflicts with
/// feature-specific StoreSelector widgets.
class SimpleStoreSelector {
  /// Show store selection bottom sheet
  static Future<Map<String, dynamic>?> show({
    required BuildContext context,
    required List<dynamic> stores,
    String? selectedStoreId,
    String title = 'Select Store',
  }) async {
    final items = stores.map((store) {
      final map = store as Map<String, dynamic>;
      return SelectionItem(
        id: map['store_id']?.toString() ?? '',
        title: map['store_name']?.toString() ?? 'Unnamed Store',
        subtitle: map['store_code']?.toString(),
        icon: IconMapper.getIcon('building'),
        data: map,
      );
    }).toList();

    final result = await ModalBottomSheet.show(
      context: context,
      title: title,
      items: items,
      selectedId: selectedStoreId,
      config: ModalSheetConfig.standard,
    );

    return result?.data;
  }
}
