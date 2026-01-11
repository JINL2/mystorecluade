import 'package:flutter/material.dart';
import 'package:myfinance_improved/shared/themes/index.dart';

/// Store Selector Widget
/// Dropdown for selecting individual store or company-wide view
class StoreSelector extends StatelessWidget {
  final String? selectedStoreId;
  final List<Map<String, dynamic>> stores;
  final ValueChanged<String?> onChanged;

  const StoreSelector({
    super.key,
    required this.selectedStoreId,
    required this.stores,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: TossSpacing.space4,
        vertical: TossSpacing.space2,
      ),
      decoration: const BoxDecoration(
        color: TossColors.white,
        border: Border(
          bottom: BorderSide(color: TossColors.gray200, width: 1),
        ),
      ),
      child: Row(
        children: [
          // Label
          Text(
            'View:',
            style: TossTextStyles.bodySmall.copyWith(
              color: TossColors.gray600,
            ),
          ),
          const SizedBox(width: TossSpacing.space2),
          // Dropdown
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: TossSpacing.space3,
                vertical: TossSpacing.space2,
              ),
              decoration: BoxDecoration(
                color: TossColors.gray50,
                borderRadius: BorderRadius.circular(TossBorderRadius.md),
                border: Border.all(color: TossColors.gray200),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String?>(
                  value: selectedStoreId,
                  isExpanded: true,
                  isDense: true,
                  icon: const Icon(
                    Icons.keyboard_arrow_down,
                    color: TossColors.gray600,
                    size: 20,
                  ),
                  style: TossTextStyles.body.copyWith(
                    color: TossColors.gray900,
                  ),
                  items: [
                    // "All Stores" option (company-wide)
                    DropdownMenuItem<String?>(
                      value: null,
                      child: Row(
                        children: [
                          const Icon(
                            Icons.business,
                            size: 16,
                            color: TossColors.primary,
                          ),
                          const SizedBox(width: TossSpacing.space2),
                          Text(
                            'All Stores (Company-wide)',
                            style: TossTextStyles.body.copyWith(
                              fontWeight: FontWeight.w600,
                              color: TossColors.primary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Individual stores
                    ...stores.map((store) {
                      final storeId = store['store_id'] as String;
                      final storeName =
                          store['store_name'] as String? ?? 'Store';
                      return DropdownMenuItem<String?>(
                        value: storeId,
                        child: Row(
                          children: [
                            const Icon(
                              Icons.storefront,
                              size: 16,
                              color: TossColors.gray500,
                            ),
                            const SizedBox(width: TossSpacing.space2),
                            Expanded(
                              child: Text(
                                storeName,
                                style: TossTextStyles.body,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                  ],
                  onChanged: onChanged,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
