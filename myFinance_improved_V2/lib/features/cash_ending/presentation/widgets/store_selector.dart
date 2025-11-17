// lib/features/cash_ending/presentation/widgets/store_selector.dart

import 'package:flutter/material.dart';

import '../../../../shared/themes/toss_border_radius.dart';
import '../../../../shared/themes/toss_colors.dart';
import '../../../../shared/themes/toss_icons.dart';
import '../../../../shared/themes/toss_spacing.dart';
import '../../../../shared/themes/toss_text_styles.dart';
import '../../domain/entities/store.dart';

/// Store selector widget
///
/// Displays a button to select store from a list
class StoreSelector extends StatelessWidget {
  final List<Store> stores;
  final String? selectedStoreId;
  final VoidCallback onTap;
  final String label;

  const StoreSelector({
    super.key,
    required this.stores,
    required this.selectedStoreId,
    required this.onTap,
    this.label = 'Store',
  });

  @override
  Widget build(BuildContext context) {
    if (stores.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(TossSpacing.space4),
        decoration: BoxDecoration(
          color: TossColors.gray50,
          borderRadius: BorderRadius.circular(TossBorderRadius.lg),
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

    // Get selected store name
    String storeName = 'Select Store';
    if (selectedStoreId == 'headquarter') {
      storeName = 'Headquarter';
    } else if (selectedStoreId != null) {
      try {
        final store = stores.firstWhere(
          (s) => s.storeId == selectedStoreId,
        );
        storeName = store.storeName;
      } catch (e) {
        storeName = 'Select Store';
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TossTextStyles.caption.copyWith(
            color: TossColors.gray500,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: TossSpacing.space2),
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(TossBorderRadius.xl),
          child: Container(
            padding: const EdgeInsets.all(TossSpacing.space4),
            decoration: BoxDecoration(
              color: TossColors.background,
              borderRadius: BorderRadius.circular(TossBorderRadius.xl),
              border: Border.all(
                color: TossColors.gray200,
                width: 1,
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    storeName,
                    style: TossTextStyles.labelLarge.copyWith(
                      color: TossColors.gray900,
                    ),
                  ),
                ),
                const Icon(
                  TossIcons.forward,
                  color: TossColors.gray400,
                  size: 24,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
