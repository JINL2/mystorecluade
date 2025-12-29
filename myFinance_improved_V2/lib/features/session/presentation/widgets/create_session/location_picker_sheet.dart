import 'package:flutter/material.dart';

import '../../../../../shared/themes/toss_border_radius.dart';
import '../../../../../shared/themes/toss_colors.dart';
import '../../../../../shared/themes/toss_spacing.dart';
import '../../../../../shared/themes/toss_text_styles.dart';
import '../../../../auth/domain/entities/store_entity.dart';

/// Bottom sheet picker for selecting store location
class LocationPickerSheet extends StatelessWidget {
  final List<Store> stores;
  final Store? selectedStore;
  final void Function(Store store) onSelected;

  const LocationPickerSheet({
    super.key,
    required this.stores,
    required this.selectedStore,
    required this.onSelected,
  });

  /// Shows the location picker bottom sheet
  static Future<void> show({
    required BuildContext context,
    required List<Store> stores,
    required Store? selectedStore,
    required void Function(Store store) onSelected,
  }) {
    if (stores.isEmpty) return Future.value();

    return showModalBottomSheet<void>(
      context: context,
      backgroundColor: TossColors.white,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(TossBorderRadius.bottomSheet),
        ),
      ),
      builder: (context) => LocationPickerSheet(
        stores: stores,
        selectedStore: selectedStore,
        onSelected: (store) {
          Navigator.pop(context);
          onSelected(store);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.6,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: TossSpacing.space2),
            Container(
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: TossColors.gray300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: TossSpacing.space4),
            Text(
              'Select Store Location',
              style: TossTextStyles.titleLarge.copyWith(
                color: TossColors.gray900,
              ),
            ),
            const SizedBox(height: TossSpacing.space3),
            Flexible(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: stores.length,
                itemBuilder: (context, index) {
                  final store = stores[index];
                  final isSelected = store.id == selectedStore?.id;
                  return ListTile(
                    leading: Icon(
                      Icons.store_outlined,
                      color:
                          isSelected ? TossColors.primary : TossColors.gray600,
                    ),
                    title: Text(
                      store.name,
                      style: TossTextStyles.body.copyWith(
                        fontWeight: FontWeight.w500,
                        color: isSelected
                            ? TossColors.primary
                            : TossColors.gray900,
                      ),
                    ),
                    trailing: isSelected
                        ? const Icon(
                            Icons.check,
                            color: TossColors.primary,
                          )
                        : null,
                    onTap: () => onSelected(store),
                  );
                },
              ),
            ),
            const SizedBox(height: TossSpacing.space4),
          ],
        ),
      ),
    );
  }
}
