import 'package:flutter/material.dart';
import 'package:myfinance_improved/shared/models/index.dart';
import 'package:myfinance_improved/shared/widgets/organisms/sheets/modal_bottom_sheet.dart';
import 'package:myfinance_improved/core/constants/icon_mapper.dart';

/// Simple account selection bottom sheet with search
///
/// Note: This is a simpler version that works with raw data.
/// For autonomous state-managed account selection, use `AccountSelector`
/// from `selectors/account/`.
class SimpleAccountSelector {
  /// Show account selection bottom sheet
  static Future<Map<String, dynamic>?> show({
    required BuildContext context,
    required List<dynamic> accounts,
    String? selectedAccountId,
    String title = 'Select Account',
  }) async {
    final items = accounts.map((account) {
      final map = account as Map<String, dynamic>;
      final categoryTag = map['category_tag']?.toString();

      return SelectionItem(
        id: map['account_id']?.toString() ?? '',
        title: map['account_name']?.toString() ?? 'Unnamed Account',
        subtitle: categoryTag != null
            ? '${_getAccountType(categoryTag)} • $categoryTag'
            : null,
        icon: IconMapper.getIcon('wallet'),
        data: map,
      );
    }).toList();

    final result = await ModalBottomSheet.show(
      context: context,
      title: title,
      items: items,
      selectedId: selectedAccountId,
      config: ModalSheetConfig.searchable,
    );

    return result?.data;
  }

  static String _getAccountType(String categoryTag) {
    switch (categoryTag.toLowerCase()) {
      case 'cash':
      case 'receivable':
      case 'fixedasset':
        return 'Asset';
      case 'payable':
      case 'note':
        return 'Liability';
      case 'equity':
      case 'retained':
        return 'Equity';
      case 'revenue':
        return 'Income';
      default:
        return 'Expense';
    }
  }
}
