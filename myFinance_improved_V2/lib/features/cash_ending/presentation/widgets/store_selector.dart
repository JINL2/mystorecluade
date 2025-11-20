// lib/features/cash_ending/presentation/widgets/store_selector.dart

import 'package:flutter/material.dart';

import '../../../../shared/themes/toss_colors.dart';
import '../../../../shared/themes/toss_icons.dart';
import '../../../../shared/themes/toss_spacing.dart';
import '../../../../shared/themes/toss_text_styles.dart';
import '../../../../shared/widgets/toss/toss_dropdown.dart';
import '../../domain/entities/store.dart';

/// Store selector widget using TossDropdown
///
/// Displays a dropdown to select store from a list
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
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                TossIcons.info,
                color: TossColors.gray500,
                size: 24,
              ),
              const SizedBox(height: TossSpacing.space2),
              Text(
                'No stores available',
                style: TossTextStyles.body.copyWith(
                  color: TossColors.gray500,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    // Build dropdown items from stores
    final List<TossDropdownItem<String>> dropdownItems = stores.map((store) => TossDropdownItem<String>(
        value: store.storeId,
        label: store.storeName,
        subtitle: store.storeCode,
        icon: TossIcons.store,
      )).toList();

    return TossDropdown<String>(
      label: label,
      value: selectedStoreId,
      items: dropdownItems,
      onChanged: onChanged,
      hint: 'Select a store',
      isLoading: isLoading,
    );
  }
}
