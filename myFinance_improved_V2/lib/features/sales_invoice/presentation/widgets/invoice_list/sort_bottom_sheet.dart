import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../shared/themes/toss_colors.dart';
import '../../../../../shared/themes/toss_text_styles.dart';
import '../../providers/invoice_list_provider.dart';
import 'invoice_sort_options.dart';
import 'package:myfinance_improved/shared/widgets/index.dart';

/// Sort bottom sheet helper class
class InvoiceSortBottomSheet {
  /// Show sort options bottom sheet
  static void show(
    BuildContext context,
    WidgetRef ref, {
    required InvoiceSortOption? currentSort,
    required void Function(InvoiceSortOption?) onSortChanged,
  }) {
    TossBottomSheet.show<void>(
      context: context,
      title: 'Sort By',
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildSortOption(
              context,
              ref,
              label: 'Date (Newest)',
              option: InvoiceSortOption.dateDesc,
              currentSort: currentSort,
              onSortChanged: onSortChanged,
            ),
            _buildSortOption(
              context,
              ref,
              label: 'Date (Oldest)',
              option: InvoiceSortOption.dateAsc,
              currentSort: currentSort,
              onSortChanged: onSortChanged,
            ),
            _buildSortOption(
              context,
              ref,
              label: 'Amount (High to Low)',
              option: InvoiceSortOption.amountDesc,
              currentSort: currentSort,
              onSortChanged: onSortChanged,
            ),
            _buildSortOption(
              context,
              ref,
              label: 'Amount (Low to High)',
              option: InvoiceSortOption.amountAsc,
              currentSort: currentSort,
              onSortChanged: onSortChanged,
            ),
          ],
        ),
      ),
    );
  }

  static Widget _buildSortOption(
    BuildContext context,
    WidgetRef ref, {
    required String label,
    required InvoiceSortOption option,
    required InvoiceSortOption? currentSort,
    required void Function(InvoiceSortOption?) onSortChanged,
  }) {
    final isSelected = currentSort == option;
    return ListTile(
      dense: true,
      visualDensity: VisualDensity.compact,
      contentPadding: EdgeInsets.zero,
      title: Text(
        label,
        style: TossTextStyles.body.copyWith(
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
          color: isSelected ? TossColors.primary : TossColors.gray900,
        ),
      ),
      trailing: isSelected
          ? const Icon(Icons.check, color: TossColors.primary, size: 20)
          : null,
      onTap: () {
        Navigator.pop(context);

        if (currentSort == option) {
          // Deselect - clear server sort
          onSortChanged(null);
          ref.read(invoiceListNotifierProvider.notifier).clearServerSort();
        } else {
          // Select new sort option
          onSortChanged(option);
          _applyServerSort(ref, option);
        }
      },
    );
  }

  /// Apply server-side sorting via RPC
  static void _applyServerSort(WidgetRef ref, InvoiceSortOption option) {
    final notifier = ref.read(invoiceListNotifierProvider.notifier);

    if (option == InvoiceSortOption.dateDesc) {
      notifier.updateServerSort(dateFilter: 'newest', amountFilter: null);
    } else if (option == InvoiceSortOption.dateAsc) {
      notifier.updateServerSort(dateFilter: 'oldest', amountFilter: null);
    } else if (option == InvoiceSortOption.amountDesc) {
      notifier.updateServerSort(amountFilter: 'high');
    } else if (option == InvoiceSortOption.amountAsc) {
      notifier.updateServerSort(amountFilter: 'low');
    }
  }
}
