// lib/features/cash_ending/presentation/widgets/store_selector.dart

import 'package:flutter/material.dart';

import '../../../../shared/themes/toss_border_radius.dart';
import '../../../../shared/themes/toss_colors.dart';
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
          borderRadius: BorderRadius.circular(TossBorderRadius.lg),
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

    return TossDropdown<String>(
      label: label,
      hint: 'Select a store',
      value: selectedStoreId,
      isLoading: isLoading,
      items: stores
          .map((store) => TossDropdownItem(
                value: store.storeId,
                label: store.storeName,
              ))
          .toList(),
      onChanged: onChanged,
    );
  }
}
