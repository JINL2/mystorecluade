// lib/features/cash_ending/presentation/widgets/store_selector.dart

import 'package:flutter/material.dart';

import '../../../../shared/themes/toss_colors.dart';
import '../../../../shared/themes/toss_spacing.dart';
import '../../../../shared/themes/toss_text_styles.dart';
import '../../../../shared/widgets/selectors/toss_base_selector.dart';
import '../../domain/entities/store.dart';

/// Store selector widget using TossSingleSelector (shared component)
///
/// Displays a dropdown to select store from a list
/// Uses same simple style as Time Table Manage (store name only, no subtitle/icon)
class StoreSelector extends StatelessWidget {
  final List<Store> stores;
  final String? selectedStoreId;
  final ValueChanged<String?> onChanged;
  final String label;
  final bool isLoading;

  const StoreSelector({
    super.key,
    required this.stores,
    required this.selectedStoreId,
    required this.onChanged,
    this.label = 'Store',
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    if (stores.isEmpty && !isLoading) {
      return Container(
        padding: const EdgeInsets.all(TossSpacing.space4),
        decoration: BoxDecoration(
          color: TossColors.gray50,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(
          child: Text(
            'No stores available',
            style: TossTextStyles.body.copyWith(
              color: TossColors.gray500,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    return TossSingleSelector<Store>(
      items: stores,
      selectedItem: selectedStoreId != null
          ? stores.firstWhere(
              (s) => s.storeId == selectedStoreId,
              orElse: () => stores.first,
            )
          : null,
      onChanged: onChanged,
      isLoading: isLoading,
      config: SelectorConfig(
        label: label,
        hint: 'Select a store',
        showSearch: false,
      ),
      itemIdBuilder: (store) => store.storeId,
      itemTitleBuilder: (store) => store.storeName,
      itemSubtitleBuilder: (store) => '',
    );
  }
}
