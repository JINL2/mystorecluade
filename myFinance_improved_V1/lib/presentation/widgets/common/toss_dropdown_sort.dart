import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/themes/toss_colors.dart';
import '../../../core/themes/toss_text_styles.dart';
import '../../../core/themes/toss_spacing.dart';
import '../../../core/themes/toss_border_radius.dart';
import '../toss/toss_dropdown.dart';

/// Common sort options for consistency across the app
enum TossSortOption {
  nameAsc('name_asc', 'Name (A-Z)'),
  nameDesc('name_desc', 'Name (Z-A)'),
  dateNewest('date_newest', 'Date (Newest)'),
  dateOldest('date_oldest', 'Date (Oldest)'),
  amountHigh('amount_high', 'Amount (High to Low)'),
  amountLow('amount_low', 'Amount (Low to High)'),
  salaryHigh('salary_high', 'Salary (High to Low)'),
  salaryLow('salary_low', 'Salary (Low to High)'),
  roleAsc('role_asc', 'Role (A-Z)'),
  roleDesc('role_desc', 'Role (Z-A)');

  final String value;
  final String label;

  const TossSortOption(this.value, this.label);
}

/// A specialized dropdown component for sorting functionality
/// following the Toss design system
class TossDropdownSort extends StatelessWidget {
  final String? currentSort;
  final ValueChanged<String?> onSortChanged;
  final List<TossSortOption> availableSorts;
  final String hint;
  final bool isLoading;
  final bool isEnabled;

  const TossDropdownSort({
    super.key,
    required this.currentSort,
    required this.onSortChanged,
    required this.availableSorts,
    this.hint = 'Sort by',
    this.isLoading = false,
    this.isEnabled = true,
  });

  @override
  Widget build(BuildContext context) {
    // Convert TossSortOption list to TossDropdownItem list
    final items = availableSorts.map((option) => 
      TossDropdownItem<String>(
        value: option.value,
        label: option.label,
      )
    ).toList();

    return TossDropdown<String>(
      label: '',
      hint: hint,
      value: currentSort,
      items: items,
      onChanged: isEnabled ? onSortChanged : null,
      isLoading: isLoading,
    );
  }

  /// Factory constructor for employee sorting
  factory TossDropdownSort.employee({
    required String? currentSort,
    required ValueChanged<String?> onSortChanged,
    bool isLoading = false,
    bool isEnabled = true,
  }) {
    return TossDropdownSort(
      currentSort: currentSort,
      onSortChanged: onSortChanged,
      availableSorts: const [
        TossSortOption.nameAsc,
        TossSortOption.nameDesc,
        TossSortOption.salaryHigh,
        TossSortOption.salaryLow,
        TossSortOption.roleAsc,
        TossSortOption.roleDesc,
      ],
      hint: 'Sort by',
      isLoading: isLoading,
      isEnabled: isEnabled,
    );
  }

  /// Factory constructor for transaction sorting
  factory TossDropdownSort.transaction({
    required String? currentSort,
    required ValueChanged<String?> onSortChanged,
    bool isLoading = false,
    bool isEnabled = true,
  }) {
    return TossDropdownSort(
      currentSort: currentSort,
      onSortChanged: onSortChanged,
      availableSorts: const [
        TossSortOption.dateNewest,
        TossSortOption.dateOldest,
        TossSortOption.amountHigh,
        TossSortOption.amountLow,
      ],
      hint: 'Sort by',
      isLoading: isLoading,
      isEnabled: isEnabled,
    );
  }

  /// Factory constructor for general date sorting
  factory TossDropdownSort.date({
    required String? currentSort,
    required ValueChanged<String?> onSortChanged,
    bool isLoading = false,
    bool isEnabled = true,
  }) {
    return TossDropdownSort(
      currentSort: currentSort,
      onSortChanged: onSortChanged,
      availableSorts: const [
        TossSortOption.dateNewest,
        TossSortOption.dateOldest,
      ],
      hint: 'Sort by date',
      isLoading: isLoading,
      isEnabled: isEnabled,
    );
  }
}

/// Consumer widget version for use with Riverpod
class TossDropdownSortConsumer extends ConsumerWidget {
  final StateProvider<String?> sortProvider;
  final List<TossSortOption> availableSorts;
  final String hint;
  final bool isLoading;
  final bool isEnabled;

  const TossDropdownSortConsumer({
    super.key,
    required this.sortProvider,
    required this.availableSorts,
    this.hint = 'Sort by',
    this.isLoading = false,
    this.isEnabled = true,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentSort = ref.watch(sortProvider);

    return TossDropdownSort(
      currentSort: currentSort,
      onSortChanged: (value) {
        ref.read(sortProvider.notifier).state = value;
      },
      availableSorts: availableSorts,
      hint: hint,
      isLoading: isLoading,
      isEnabled: isEnabled,
    );
  }
}