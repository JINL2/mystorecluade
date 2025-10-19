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
                Icons.info_outline,
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
                color: selectedStoreId != null ? TossColors.primary : TossColors.gray200,
                width: selectedStoreId != null ? 1.5 : 1,
              ),
            ),
            child: Row(
              children: [
                Icon(
                  TossIcons.store,
                  color: selectedStoreId != null ? TossColors.primary : TossColors.gray500,
                  size: 24,
                ),
                const SizedBox(width: TossSpacing.space3),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        storeName,
                        style: TossTextStyles.bodyLarge.copyWith(
                          fontWeight: FontWeight.w600,
                          color: selectedStoreId != null
                              ? TossColors.textPrimary
                              : TossColors.gray500,
                        ),
                      ),
                      if (selectedStoreId != null)
                        Text(
                          'Tap to change',
                          style: TossTextStyles.caption.copyWith(
                            color: TossColors.gray500,
                          ),
                        ),
                    ],
                  ),
                ),
                Icon(
                  Icons.chevron_right,
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
