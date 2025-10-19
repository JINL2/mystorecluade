// lib/features/cash_ending/presentation/widgets/sheets/store_selector_sheet.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../shared/themes/toss_border_radius.dart';
import '../../../../../shared/themes/toss_colors.dart';
import '../../../../../shared/themes/toss_spacing.dart';
import '../../../../../shared/themes/toss_text_styles.dart';
import '../../../domain/entities/store.dart';
import '../../providers/cash_ending_provider.dart';

/// Store selector bottom sheet
///
/// Displays a list of stores to select from, including Headquarter option
class StoreSelectorSheet extends ConsumerWidget {
  final List<Store> stores;
  final String? selectedStoreId;
  final String companyId;

  const StoreSelectorSheet({
    super.key,
    required this.stores,
    required this.selectedStoreId,
    required this.companyId,
  });

  /// Show store selector bottom sheet
  static void show({
    required BuildContext context,
    required WidgetRef ref,
    required List<Store> stores,
    required String? selectedStoreId,
    required String companyId,
  }) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => StoreSelectorSheet(
        stores: stores,
        selectedStoreId: selectedStoreId,
        companyId: companyId,
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      decoration: const BoxDecoration(
        color: TossColors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
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
              borderRadius: BorderRadius.circular(TossBorderRadius.full),
            ),
          ),

          // Title
          Padding(
            padding: const EdgeInsets.all(TossSpacing.space5),
            child: Row(
              children: [
                Text(
                  'Select Store',
                  style: TossTextStyles.h3.copyWith(
                    color: TossColors.gray900,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),

          // Store list
          Container(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.5,
            ),
            child: ListView.builder(
              shrinkWrap: true,
              padding: EdgeInsets.zero,
              itemCount: stores.length + 1, // +1 for Headquarter
              itemBuilder: (context, index) {
                // First item is Headquarter
                if (index == 0) {
                  return _buildHeadquarterItem(context, ref);
                }

                // Store items
                final store = stores[index - 1];
                final isSelected = selectedStoreId == store.storeId;

                return _buildStoreItem(
                  context,
                  ref,
                  store: store,
                  isSelected: isSelected,
                );
              },
            ),
          ),

          // Bottom padding
          const SizedBox(height: TossSpacing.space5),
        ],
      ),
    );
  }

  Widget _buildHeadquarterItem(BuildContext context, WidgetRef ref) {
    final isSelected = selectedStoreId == 'headquarter';

    return InkWell(
      onTap: () async {
        HapticFeedback.selectionClick();
        Navigator.pop(context);

        // Update selected store
        ref.read(cashEndingProvider.notifier).setSelectedStore('headquarter');

        // Load locations for all tabs
        await ref.read(cashEndingProvider.notifier).loadLocations(
              companyId: companyId,
              locationType: 'cash',
              storeId: 'headquarter',
            );
        await ref.read(cashEndingProvider.notifier).loadLocations(
              companyId: companyId,
              locationType: 'bank',
              storeId: 'headquarter',
            );
        await ref.read(cashEndingProvider.notifier).loadLocations(
              companyId: companyId,
              locationType: 'vault',
              storeId: 'headquarter',
            );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: TossSpacing.space5,
          vertical: TossSpacing.space4,
        ),
        decoration: const BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: TossColors.gray100,
              width: 0.5,
            ),
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: isSelected
                    ? TossColors.primarySurface
                    : TossColors.gray50,
                borderRadius: BorderRadius.circular(TossBorderRadius.md),
              ),
              child: Icon(
                Icons.business,
                size: 20,
                color: isSelected ? TossColors.primary : TossColors.gray500,
              ),
            ),
            const SizedBox(width: TossSpacing.space3),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Headquarter',
                    style: TossTextStyles.body.copyWith(
                      color: TossColors.gray900,
                      fontWeight:
                          isSelected ? FontWeight.w700 : FontWeight.w500,
                    ),
                  ),
                  Text(
                    'Company Level',
                    style: TossTextStyles.caption.copyWith(
                      color: TossColors.gray500,
                    ),
                  ),
                ],
              ),
            ),
            if (isSelected)
              const Icon(
                Icons.check,
                size: 20,
                color: TossColors.primary,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildStoreItem(
    BuildContext context,
    WidgetRef ref, {
    required Store store,
    required bool isSelected,
  }) {
    return InkWell(
      onTap: () async {
        HapticFeedback.selectionClick();
        Navigator.pop(context);

        // Update selected store
        ref.read(cashEndingProvider.notifier).setSelectedStore(store.storeId);

        // Load locations for all tabs
        await ref.read(cashEndingProvider.notifier).loadLocations(
              companyId: companyId,
              locationType: 'cash',
              storeId: store.storeId,
            );
        await ref.read(cashEndingProvider.notifier).loadLocations(
              companyId: companyId,
              locationType: 'bank',
              storeId: store.storeId,
            );
        await ref.read(cashEndingProvider.notifier).loadLocations(
              companyId: companyId,
              locationType: 'vault',
              storeId: store.storeId,
            );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: TossSpacing.space5,
          vertical: TossSpacing.space4,
        ),
        decoration: const BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: TossColors.gray100,
              width: 0.5,
            ),
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: isSelected
                    ? TossColors.primarySurface
                    : TossColors.gray50,
                borderRadius: BorderRadius.circular(TossBorderRadius.md),
              ),
              child: Icon(
                Icons.store,
                size: 20,
                color: isSelected ? TossColors.primary : TossColors.gray500,
              ),
            ),
            const SizedBox(width: TossSpacing.space3),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    store.storeName,
                    style: TossTextStyles.body.copyWith(
                      color: TossColors.gray900,
                      fontWeight:
                          isSelected ? FontWeight.w700 : FontWeight.w500,
                    ),
                  ),
                  if (store.storeCode?.isNotEmpty ?? false)
                    Text(
                      store.storeCode!,
                      style: TossTextStyles.caption.copyWith(
                        color: TossColors.gray500,
                      ),
                    ),
                ],
              ),
            ),
            if (isSelected)
              const Icon(
                Icons.check,
                size: 20,
                color: TossColors.primary,
              ),
          ],
        ),
      ),
    );
  }
}
