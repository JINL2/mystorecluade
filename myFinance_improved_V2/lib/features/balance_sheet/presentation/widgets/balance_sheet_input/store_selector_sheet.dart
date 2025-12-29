import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../app/providers/app_state_provider.dart';
import '../../../../../core/domain/entities/store.dart';
import '../../../../../shared/themes/toss_border_radius.dart';
import '../../../../../shared/themes/toss_colors.dart';
import '../../../../../shared/themes/toss_spacing.dart';
import '../../../../../shared/themes/toss_text_styles.dart';

/// Show store selector bottom sheet
void showStoreSelectorSheet(
  BuildContext context,
  WidgetRef ref,
  List<Store> stores,
  String selectedStoreId,
) {
  showModalBottomSheet<void>(
    context: context,
    backgroundColor: TossColors.background,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(TossBorderRadius.xl),
      ),
    ),
    builder: (context) {
      return SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle bar
            Container(
              margin: const EdgeInsets.only(top: TossSpacing.space3),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: TossColors.gray300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),

            // Title
            Padding(
              padding: const EdgeInsets.all(TossSpacing.space4),
              child: Text(
                'Select Store',
                style: TossTextStyles.h4.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),

            const Divider(height: 1, color: TossColors.gray200),

            // Store list
            Flexible(
              child: ListView(
                shrinkWrap: true,
                children: [
                  // All Stores (Headquarters) option
                  _StoreOptionItem(
                    storeId: '',
                    storeName: 'All Stores (Headquarters)',
                    isSelected: selectedStoreId.isEmpty,
                  ),

                  // Individual stores
                  ...stores.map(
                    (store) => _StoreOptionItem(
                      storeId: store.id,
                      storeName: store.storeName,
                      isSelected: selectedStoreId == store.id,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: TossSpacing.space4),
          ],
        ),
      );
    },
  );
}

/// Store option item widget
class _StoreOptionItem extends ConsumerWidget {
  final String storeId;
  final String storeName;
  final bool isSelected;

  const _StoreOptionItem({
    required this.storeId,
    required this.storeName,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return InkWell(
      onTap: () {
        // Update app state with selected store
        ref.read(appStateProvider.notifier).selectStore(
              storeId,
              storeName: storeName,
            );
        Navigator.pop(context);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: TossSpacing.space4,
          vertical: TossSpacing.space3,
        ),
        child: Row(
          children: [
            // Store icon
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: isSelected
                    ? TossColors.primary.withValues(alpha: 0.1)
                    : TossColors.gray100,
                borderRadius: BorderRadius.circular(TossBorderRadius.md),
              ),
              child: Icon(
                storeId.isEmpty ? Icons.business_outlined : Icons.store_outlined,
                color: isSelected ? TossColors.primary : TossColors.gray500,
                size: 20,
              ),
            ),
            const SizedBox(width: TossSpacing.space3),

            // Store name
            Expanded(
              child: Text(
                storeName,
                style: TossTextStyles.body.copyWith(
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                  color: isSelected ? TossColors.primary : TossColors.gray900,
                ),
              ),
            ),

            // Selected indicator
            if (isSelected)
              const Icon(
                Icons.check_circle,
                color: TossColors.primary,
                size: 20,
              ),
          ],
        ),
      ),
    );
  }
}
