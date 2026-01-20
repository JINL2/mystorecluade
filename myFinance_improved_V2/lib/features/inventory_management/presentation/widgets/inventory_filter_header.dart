import 'package:flutter/material.dart';

import '../../../../shared/themes/toss_border_radius.dart';
import '../../../../shared/themes/toss_colors.dart';
import '../../../../shared/themes/toss_dimensions.dart';
import '../../../../shared/themes/toss_font_weight.dart';
import '../../../../shared/themes/toss_spacing.dart';
import '../../../../shared/themes/toss_text_styles.dart';
import '../providers/states/inventory_page_state.dart';

/// Sticky filter header delegate for inventory list
class InventoryFilterHeaderDelegate extends SliverPersistentHeaderDelegate {
  final InventoryPageState pageState;
  final String selectedAvailability;
  final String selectedLocation;
  final String selectedBrand;
  final String selectedCategory;
  final Function(String) onFilterTap;

  const InventoryFilterHeaderDelegate({
    required this.pageState,
    required this.selectedAvailability,
    required this.selectedLocation,
    required this.selectedBrand,
    required this.selectedCategory,
    required this.onFilterTap,
  });

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: TossColors.white,
      padding: const EdgeInsets.fromLTRB(TossSpacing.space3, TossSpacing.space2, TossSpacing.space3, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Filter pills row
          SizedBox(
            height: TossSpacing.space14,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                InventoryFilterPill(
                  title: 'Availability',
                  subtitle: selectedAvailability,
                  onTap: () => onFilterTap('Availability'),
                ),
                const SizedBox(width: TossSpacing.space2),
                InventoryFilterPill(
                  title: 'Location',
                  subtitle: selectedLocation,
                  onTap: () => onFilterTap('Location'),
                ),
                const SizedBox(width: TossSpacing.space2),
                InventoryFilterPill(
                  title: 'Brand',
                  subtitle: selectedBrand,
                  onTap: () => onFilterTap('Brand'),
                ),
                const SizedBox(width: TossSpacing.space2),
                InventoryFilterPill(
                  title: 'Categories',
                  subtitle: selectedCategory,
                  onTap: () => onFilterTap('Categories'),
                ),
              ],
            ),
          ),
          const SizedBox(height: TossSpacing.space3),
          // Summary text - v6.1: uses store-wide totals (not affected by filters)
          Text(
            'Total on hand: ${pageState.totalInventoryQuantity} items · Total value: ${pageState.currency?.symbol ?? '\$'}${_formatCurrency(pageState.totalInventoryCost)}',
            style: TossTextStyles.caption.copyWith(
              fontWeight: TossFontWeight.medium,
              color: TossColors.gray600,
            ),
          ),
          const SizedBox(height: TossSpacing.space2),
          // Divider
          Container(
            height: TossDimensions.dividerThickness,
            color: TossColors.gray100,
          ),
        ],
      ),
    );
  }

  String _formatCurrency(double value) {
    return value.toStringAsFixed(0).replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]},',
    );
  }

  @override
  double get maxExtent => 120;

  @override
  double get minExtent => 120;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }
}

/// Filter pill widget for inventory filters
class InventoryFilterPill extends StatelessWidget {
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const InventoryFilterPill({
    super.key,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: TossColors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(TossBorderRadius.sm),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: TossSpacing.space3, vertical: TossSpacing.space2),
          decoration: BoxDecoration(
            color: TossColors.gray50,
            borderRadius: BorderRadius.circular(TossBorderRadius.sm),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    title,
                    style: TossTextStyles.bodySmall.copyWith(
                      fontWeight: TossFontWeight.semibold,
                      color: TossColors.gray900,
                    ),
                  ),
                  const SizedBox(height: TossSpacing.space0_5),
                  Text(
                    subtitle,
                    style: TossTextStyles.caption.copyWith(
                      fontWeight: TossFontWeight.regular,
                      color: TossColors.gray600,
                    ),
                  ),
                ],
              ),
              const SizedBox(width: TossSpacing.space4),
              const Icon(
                Icons.keyboard_arrow_down,
                size: TossSpacing.iconSM2,
                color: TossColors.gray600,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Filter section widget (non-sliver version)
class InventoryFilterSection extends StatelessWidget {
  final InventoryPageState pageState;
  final String selectedAvailability;
  final String selectedLocation;
  final String selectedBrand;
  final String selectedCategory;
  final Function(String) onFilterTap;

  const InventoryFilterSection({
    super.key,
    required this.pageState,
    required this.selectedAvailability,
    required this.selectedLocation,
    required this.selectedBrand,
    required this.selectedCategory,
    required this.onFilterTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: TossColors.white,
      padding: const EdgeInsets.fromLTRB(TossSpacing.space3, TossSpacing.space2, TossSpacing.space3, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Filter pills row
          SizedBox(
            height: TossSpacing.space14,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                InventoryFilterPill(
                  title: 'Availability',
                  subtitle: selectedAvailability,
                  onTap: () => onFilterTap('Availability'),
                ),
                const SizedBox(width: TossSpacing.space2),
                InventoryFilterPill(
                  title: 'Location',
                  subtitle: selectedLocation,
                  onTap: () => onFilterTap('Location'),
                ),
                const SizedBox(width: TossSpacing.space2),
                InventoryFilterPill(
                  title: 'Brand',
                  subtitle: selectedBrand,
                  onTap: () => onFilterTap('Brand'),
                ),
                const SizedBox(width: TossSpacing.space2),
                InventoryFilterPill(
                  title: 'Categories',
                  subtitle: selectedCategory,
                  onTap: () => onFilterTap('Categories'),
                ),
              ],
            ),
          ),
          const SizedBox(height: TossSpacing.space3),
          // Summary text - v6.1: uses store-wide totals (not affected by filters)
          Text(
            'Total on hand: ${pageState.totalInventoryQuantity} items · Total value: ${pageState.currency?.symbol ?? '\$'}${_formatCurrency(pageState.totalInventoryCost)}',
            style: TossTextStyles.caption.copyWith(
              fontWeight: TossFontWeight.medium,
              color: TossColors.gray600,
            ),
          ),
          const SizedBox(height: TossSpacing.space2),
          // Divider
          Container(
            height: TossDimensions.dividerThickness,
            color: TossColors.gray100,
          ),
        ],
      ),
    );
  }

  String _formatCurrency(double value) {
    return value.toStringAsFixed(0).replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]},',
    );
  }
}
