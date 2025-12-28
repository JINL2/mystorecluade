import 'package:flutter/material.dart';

import '../../../../shared/themes/toss_border_radius.dart';
import '../../../../shared/themes/toss_colors.dart';
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
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Filter pills row
          SizedBox(
            height: 56,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                InventoryFilterPill(
                  title: 'Availability',
                  subtitle: selectedAvailability,
                  onTap: () => onFilterTap('Availability'),
                ),
                const SizedBox(width: 8),
                InventoryFilterPill(
                  title: 'Location',
                  subtitle: selectedLocation,
                  onTap: () => onFilterTap('Location'),
                ),
                const SizedBox(width: 8),
                InventoryFilterPill(
                  title: 'Brand',
                  subtitle: selectedBrand,
                  onTap: () => onFilterTap('Brand'),
                ),
                const SizedBox(width: 8),
                InventoryFilterPill(
                  title: 'Categories',
                  subtitle: selectedCategory,
                  onTap: () => onFilterTap('Categories'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          // Summary text - uses server-provided total value from v4 RPC
          Text(
            'Total on hand: ${pageState.pagination.total} items · Total value: ${pageState.currency?.symbol ?? '\$'}${_formatCurrency(pageState.serverTotalValue)}',
            style: TossTextStyles.caption.copyWith(
              fontWeight: FontWeight.w500,
              color: TossColors.gray600,
            ),
          ),
          const SizedBox(height: 8),
          // Divider
          Container(
            height: 1,
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
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
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
                      fontWeight: FontWeight.w600,
                      color: TossColors.gray900,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TossTextStyles.caption.copyWith(
                      fontWeight: FontWeight.w400,
                      color: TossColors.gray600,
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 16),
              const Icon(
                Icons.keyboard_arrow_down,
                size: 16,
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
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Filter pills row
          SizedBox(
            height: 56,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                InventoryFilterPill(
                  title: 'Availability',
                  subtitle: selectedAvailability,
                  onTap: () => onFilterTap('Availability'),
                ),
                const SizedBox(width: 8),
                InventoryFilterPill(
                  title: 'Location',
                  subtitle: selectedLocation,
                  onTap: () => onFilterTap('Location'),
                ),
                const SizedBox(width: 8),
                InventoryFilterPill(
                  title: 'Brand',
                  subtitle: selectedBrand,
                  onTap: () => onFilterTap('Brand'),
                ),
                const SizedBox(width: 8),
                InventoryFilterPill(
                  title: 'Categories',
                  subtitle: selectedCategory,
                  onTap: () => onFilterTap('Categories'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          // Summary text
          Text(
            'Total on hand: ${pageState.pagination.total} items · Total value: ${pageState.currency?.symbol ?? '\$'}${_formatCurrency(pageState.serverTotalValue)}',
            style: TossTextStyles.caption.copyWith(
              fontWeight: FontWeight.w500,
              color: TossColors.gray600,
            ),
          ),
          const SizedBox(height: 8),
          // Divider
          Container(
            height: 1,
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
