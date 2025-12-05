import 'package:flutter/material.dart';
import '../../../../../shared/themes/toss_border_radius.dart';
import '../../../../../shared/themes/toss_colors.dart';
import '../../../../../shared/themes/toss_spacing.dart';
import '../../../../../shared/themes/toss_text_styles.dart';
import '../../extensions/sort_option_extension.dart';

/// Sort options bottom sheet
///
/// Displays sorting options in a modal bottom sheet.
/// Allows users to select sort criteria and direction (ascending/descending).
class SortOptionsBottomSheet extends StatelessWidget {
  final SortOption currentSort;
  final ValueChanged<SortOption> onSortChanged;

  const SortOptionsBottomSheet({
    super.key,
    required this.currentSort,
    required this.onSortChanged,
  });

  /// Show the bottom sheet
  static Future<void> show({
    required BuildContext context,
    required SortOption currentSort,
    required ValueChanged<SortOption> onSortChanged,
  }) {
    return showModalBottomSheet<void>(
      context: context,
      backgroundColor: TossColors.transparent,
      builder: (context) => SortOptionsBottomSheet(
        currentSort: currentSort,
        onSortChanged: onSortChanged,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: TossColors.surface,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(TossBorderRadius.xl),
          topRight: Radius.circular(TossBorderRadius.xl),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle
          Container(
            width: 48,
            height: 4,
            margin: const EdgeInsets.only(top: TossSpacing.space3),
            decoration: BoxDecoration(
              color: TossColors.gray300,
              borderRadius: BorderRadius.circular(TossBorderRadius.xs),
            ),
          ),

          // Title
          Container(
            padding: const EdgeInsets.all(TossSpacing.space4),
            child: Text(
              'Sort Products',
              style: TossTextStyles.h3.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
          ),

          // Sort options
          ..._buildSortOptions(context),

          SizedBox(
            height: MediaQuery.of(context).padding.bottom + TossSpacing.space4,
          ),
        ],
      ),
    );
  }

  List<Widget> _buildSortOptions(BuildContext context) {
    final options = [
      (SortOption.nameAsc, Icons.sort_by_alpha_rounded),
      (SortOption.priceAsc, Icons.attach_money_rounded),
      (SortOption.stockAsc, Icons.inventory_2_outlined),
    ];

    return options.map((entry) {
      final option = entry.$1;
      final icon = entry.$2;
      final isSelected = _isOptionSelected(option);

      return _SortOptionItem(
        title: option.displayName,
        icon: icon,
        isSelected: isSelected,
        sortAscending: currentSort.isAscending,
        onTap: () {
          final newSort = isSelected ? option.toggled : option;
          onSortChanged(newSort);
          Navigator.pop(context);
        },
      );
    }).toList();
  }

  bool _isOptionSelected(SortOption option) {
    return currentSort == option ||
        (currentSort == SortOption.nameDesc && option == SortOption.nameAsc) ||
        (currentSort == SortOption.priceDesc && option == SortOption.priceAsc) ||
        (currentSort == SortOption.stockDesc && option == SortOption.stockAsc);
  }
}

class _SortOptionItem extends StatelessWidget {
  final String title;
  final IconData icon;
  final bool isSelected;
  final bool sortAscending;
  final VoidCallback onTap;

  const _SortOptionItem({
    required this.title,
    required this.icon,
    required this.isSelected,
    required this.sortAscending,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: TossColors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: TossSpacing.space4,
            vertical: TossSpacing.space3,
          ),
          child: Row(
            children: [
              Icon(
                icon,
                size: 20,
                color: isSelected ? TossColors.primary : TossColors.gray600,
              ),
              const SizedBox(width: TossSpacing.space3),
              Expanded(
                child: Text(
                  title,
                  style: TossTextStyles.body.copyWith(
                    color: isSelected ? TossColors.primary : TossColors.gray900,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                  ),
                ),
              ),
              if (isSelected) ...[
                Icon(
                  sortAscending
                      ? Icons.arrow_upward_rounded
                      : Icons.arrow_downward_rounded,
                  size: 16,
                  color: TossColors.primary,
                ),
                const SizedBox(width: TossSpacing.space2),
                const Icon(
                  Icons.check_rounded,
                  color: TossColors.primary,
                  size: 20,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
