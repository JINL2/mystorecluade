import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myfinance_improved/shared/widgets/toss/toss_dropdown.dart';
import '../../../../../app/providers/app_state_provider.dart';

/// Store selector widget for TimesheetsTab
/// Displays a dropdown to select store from user's accessible stores
class StoreSelector extends ConsumerWidget {
  final String? selectedStoreId;
  final ValueChanged<String>? onStoreChanged;

  const StoreSelector({
    super.key,
    this.selectedStoreId,
    this.onStoreChanged,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appState = ref.watch(appStateProvider);
    final userData = appState.user;
    final companies = (userData['companies'] as List<dynamic>?) ?? [];

    // Get stores from selected company only
    List<dynamic> stores = [];
    if (companies.isNotEmpty && appState.companyChoosen.isNotEmpty) {
      for (final company in companies) {
        final companyMap = company as Map<String, dynamic>;
        if (companyMap['company_id']?.toString() == appState.companyChoosen) {
          stores = (companyMap['stores'] as List<dynamic>?) ?? [];
          break;
        }
      }
    }

    final storeItems = stores.map((store) {
      final storeMap = store as Map<String, dynamic>;
      return TossDropdownItem<String>(
        value: storeMap['store_id']?.toString() ?? '',
        label: storeMap['store_name']?.toString() ?? 'Unknown',
      );
    }).toList();

    return TossDropdown<String>(
      label: 'Store',
      value: selectedStoreId,
      items: storeItems,
      onChanged: (newValue) {
        if (newValue != null && newValue != selectedStoreId) {
          onStoreChanged?.call(newValue);
        }
      },
    );
  }
}
