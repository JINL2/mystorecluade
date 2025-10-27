import 'package:flutter/material.dart';
import '../../../../../shared/themes/toss_border_radius.dart';
import '../../../../../shared/themes/toss_colors.dart';
import '../../../../../shared/themes/toss_spacing.dart';
import '../../../../../shared/themes/toss_text_styles.dart';
import '../../../domain/value_objects/sort_option.dart';

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
      backgroundColor: Colors.transparent,
      builder: (context) => SortOptionsBottomSheet(
        currentSort: currentSort,
        onSortChanged: onSortChanged,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: TossColors.surface,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(TossBorderRadius.lg),
        ),
      ),
      padding: EdgeInsets.all(TossSpacing.space4),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Sort Products',
            style: TossTextStyles.h4.copyWith(fontWeight: FontWeight.bold),
          ),
          SizedBox(height: TossSpacing.space4),
          ..._buildSortOptions(context),
        ],
      ),
    );
  }

  List<Widget> _buildSortOptions(BuildContext context) {
    final options = [
      SortOption.nameAsc,
      SortOption.priceAsc,
      SortOption.stockAsc,
    ];

    return options.map((option) {
      final isSelected = _isOptionSelected(option);

      return ListTile(
        title: Text(option.displayName),
        selected: isSelected,
        trailing: isSelected
            ? Icon(
                currentSort.isAscending
                    ? Icons.arrow_upward
                    : Icons.arrow_downward,
                size: 20,
              )
            : null,
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
