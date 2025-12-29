import 'package:flutter/material.dart';

import '../../../../../shared/themes/toss_colors.dart';
import '../../../../../shared/themes/toss_text_styles.dart';
import '../../../../../shared/themes/toss_spacing.dart';
import '../../../domain/entities/product.dart';
import '../move_stock_dialog.dart';
import 'store_row_item.dart';

/// Locations section showing store list with stock information
class ProductLocationsSection extends StatelessWidget {
  final Product product;
  final List<StoreLocation> stores;
  final bool hasStockFilter;
  final bool isLoading;
  final ValueChanged<bool> onFilterChanged;
  final void Function(StoreLocation store) onStoreTap;

  const ProductLocationsSection({
    super.key,
    required this.product,
    required this.stores,
    required this.hasStockFilter,
    required this.isLoading,
    required this.onFilterChanged,
    required this.onStoreTap,
  });

  @override
  Widget build(BuildContext context) {
    // Filter stores based on toggle
    final filteredStores = hasStockFilter
        ? stores.where((s) => s.stock > 0).toList()
        : stores;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: TossSpacing.space4),
          child: Column(
            children: [
              // Section header - "Move Stock" with toggle
              _buildSectionHeader(),
              // Loading indicator or store rows
              if (isLoading)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: TossSpacing.space4),
                  child: Center(
                    child: SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  ),
                )
              else
                ...filteredStores.map((store) => StoreRowItem(
                  store: store,
                  onTap: () => onStoreTap(store),
                )),
            ],
          ),
        ),
        const SizedBox(height: TossSpacing.space4),
      ],
    );
  }

  Widget _buildSectionHeader() {
    return Padding(
      padding: const EdgeInsets.only(
        top: TossSpacing.space6,
        bottom: TossSpacing.space3,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Move Stock',
            style: TossTextStyles.titleLarge.copyWith(
              color: TossColors.gray900,
            ),
          ),
          // Has stock toggle
          Row(
            children: [
              Text(
                'Has stock',
                style: TossTextStyles.bodySmall.copyWith(
                  fontWeight: FontWeight.w500,
                  color: TossColors.gray600,
                ),
              ),
              const SizedBox(width: TossSpacing.space2),
              GestureDetector(
                onTap: () => onFilterChanged(!hasStockFilter),
                child: _buildToggle(hasStockFilter),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildToggle(bool isOn) {
    return Container(
      width: 34,
      height: 20,
      decoration: BoxDecoration(
        color: isOn ? TossColors.primary : TossColors.gray200,
        borderRadius: BorderRadius.circular(28),
      ),
      padding: const EdgeInsets.all(2),
      alignment: isOn ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        width: 14,
        height: 14,
        decoration: const BoxDecoration(
          color: TossColors.white,
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}
