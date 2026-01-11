import 'package:flutter/material.dart';
import 'package:myfinance_improved/shared/models/index.dart';
import 'package:myfinance_improved/shared/widgets/organisms/sheets/modal_bottom_sheet.dart';
import 'package:myfinance_improved/core/constants/icon_mapper.dart';

/// Simple company selection bottom sheet (works with raw data)
class SimpleCompanySelector {
  /// Show company selection bottom sheet
  static Future<Map<String, dynamic>?> show({
    required BuildContext context,
    required List<dynamic> companies,
    String? selectedCompanyId,
    String title = 'Select Company',
  }) async {
    final items = companies.map((company) {
      final map = company as Map<String, dynamic>;
      return SelectionItem(
        id: map['company_id']?.toString() ?? '',
        title: map['company_name']?.toString() ?? 'Unnamed Company',
        subtitle: map['company_code']?.toString(),
        icon: IconMapper.getIcon('building'),
        data: map,
      );
    }).toList();

    final result = await ModalBottomSheet.show(
      context: context,
      title: title,
      items: items,
      selectedId: selectedCompanyId,
      config: ModalSheetConfig.standard,
    );

    return result?.data;
  }
}
