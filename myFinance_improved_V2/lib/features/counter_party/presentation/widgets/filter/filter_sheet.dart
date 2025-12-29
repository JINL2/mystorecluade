import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myfinance_improved/shared/themes/toss_border_radius.dart';
import 'package:myfinance_improved/shared/themes/toss_colors.dart';
import 'package:myfinance_improved/shared/themes/toss_spacing.dart';
import 'package:myfinance_improved/shared/themes/toss_text_styles.dart';
import 'package:myfinance_improved/shared/widgets/toss/toss_selection_bottom_sheet.dart';

import '../../../domain/value_objects/counter_party_filter.dart';
import '../../../domain/value_objects/counter_party_type.dart';
import '../../providers/counter_party_providers.dart';

/// Filter sheet widget for counter party filtering
class CounterPartyFilterSheet extends ConsumerWidget {
  const CounterPartyFilterSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filter = ref.watch(counterPartyFilterNotifierProvider);

    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.8,
      ),
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
              'Filter Counter Parties',
              style: TossTextStyles.h3.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
          ),

          // Scrollable Filter options
          Flexible(
            child: SingleChildScrollView(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).padding.bottom + TossSpacing.space4,
              ),
              child: _buildFilterOptions(context, ref, filter),
            ),
          ),

          const SizedBox(height: TossSpacing.space4),
        ],
      ),
    );
  }

  Widget _buildFilterOptions(
    BuildContext context,
    WidgetRef ref,
    CounterPartyFilter filter,
  ) {
    final allOptions = [
      // Type options
      {'type': 'all', 'label': 'All Types', 'icon': Icons.clear_all_rounded, 'category': 'type'},
      {'type': CounterPartyType.myCompany, 'label': 'My Company', 'icon': Icons.business, 'category': 'type'},
      {'type': CounterPartyType.teamMember, 'label': 'Team Member', 'icon': Icons.group, 'category': 'type'},
      {'type': CounterPartyType.supplier, 'label': 'Suppliers', 'icon': Icons.local_shipping, 'category': 'type'},
      {'type': CounterPartyType.employee, 'label': 'Employees', 'icon': Icons.badge, 'category': 'type'},
      {'type': CounterPartyType.customer, 'label': 'Customers', 'icon': Icons.people, 'category': 'type'},
      {'type': CounterPartyType.other, 'label': 'Others', 'icon': Icons.category, 'category': 'type'},

      // Internal/External options
      {'value': null, 'label': 'All Locations', 'icon': Icons.all_inclusive, 'category': 'internal'},
      {'value': true, 'label': 'Internal Only', 'icon': Icons.home_work, 'category': 'internal'},
      {'value': false, 'label': 'External Only', 'icon': Icons.public, 'category': 'internal'},
    ];

    return Column(
      children: allOptions.map((option) {
        final bool isSelected;
        final VoidCallback onTap;

        if (option['category'] == 'type') {
          // Handle type filters
          final isAll = option['type'] == 'all';
          isSelected = isAll
              ? (filter.types?.isEmpty ?? true)
              : (filter.types?.contains(option['type']) ?? false);

          onTap = () {
            final currentFilter = ref.read(counterPartyFilterNotifierProvider);
            List<CounterPartyType>? newTypes;

            if (isAll) {
              newTypes = null;
            } else {
              final type = option['type']! as CounterPartyType;
              final currentTypes = List<CounterPartyType>.from(currentFilter.types ?? []);

              if (currentTypes.contains(type)) {
                currentTypes.remove(type);
              } else {
                currentTypes.add(type);
              }

              newTypes = currentTypes.isEmpty ? null : currentTypes;
            }

            ref.read(counterPartyFilterNotifierProvider.notifier).setFilter(
                currentFilter.copyWith(types: newTypes));

            Navigator.pop(context);
          };
        } else {
          // Handle internal/external filters
          isSelected = filter.isInternal == option['value'];

          onTap = () {
            final currentFilter = ref.read(counterPartyFilterNotifierProvider);
            ref.read(counterPartyFilterNotifierProvider.notifier).setFilter(
              currentFilter.copyWith(isInternal: option['value'] as bool?));
            Navigator.pop(context);
          };
        }

        return Material(
          color: TossColors.transparent,
          child: InkWell(
            onTap: onTap,
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: TossSpacing.space4,
                vertical: TossSpacing.space4,
              ),
              child: Row(
                children: [
                  Icon(
                    option['icon']! as IconData,
                    size: 20,
                    color: TossColors.gray600,
                  ),
                  const SizedBox(width: TossSpacing.space3),
                  Text(
                    option['label']! as String,
                    style: TossTextStyles.body.copyWith(
                      color: TossColors.gray900,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const Spacer(),
                  if (isSelected)
                    const Icon(
                      Icons.check_rounded,
                      color: TossColors.primary,
                      size: 20,
                    ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}

/// Helper class for showing sort options bottom sheet
class SortOptionsHelper {
  static void showSortSheet(BuildContext context, WidgetRef ref) {
    final filter = ref.read(counterPartyFilterNotifierProvider);

    final sortOptions = [
      TossSelectionItem(
        id: 'name',
        title: 'Name',
        subtitle: filter.sortBy == CounterPartySortOption.name
            ? '(${filter.ascending ? 'A-Z' : 'Z-A'})'
            : null,
        icon: Icons.sort_by_alpha,
      ),
      TossSelectionItem(
        id: 'type',
        title: 'Type',
        subtitle: filter.sortBy == CounterPartySortOption.type
            ? '(${filter.ascending ? 'A-Z' : 'Z-A'})'
            : null,
        icon: Icons.category,
      ),
      TossSelectionItem(
        id: 'created',
        title: 'Created Date',
        subtitle: filter.sortBy == CounterPartySortOption.createdAt
            ? '(${filter.ascending ? 'Old-New' : 'New-Old'})'
            : null,
        icon: Icons.calendar_today,
      ),
      TossSelectionItem(
        id: 'internal',
        title: 'Internal/External',
        subtitle: filter.sortBy == CounterPartySortOption.isInternal
            ? '(${filter.ascending ? 'External First' : 'Internal First'})'
            : null,
        icon: Icons.home_work,
      ),
    ];

    String? currentSelectedId;
    switch (filter.sortBy) {
      case CounterPartySortOption.name:
        currentSelectedId = 'name';
        break;
      case CounterPartySortOption.type:
        currentSelectedId = 'type';
        break;
      case CounterPartySortOption.createdAt:
        currentSelectedId = 'created';
        break;
      case CounterPartySortOption.isInternal:
        currentSelectedId = 'internal';
        break;
    }

    TossSelectionBottomSheet.show<void>(
      context: context,
      title: 'Sort by',
      items: sortOptions,
      selectedId: currentSelectedId,
      onItemSelected: (item) {
        final currentFilter = ref.read(counterPartyFilterNotifierProvider);
        CounterPartySortOption sortBy;

        switch (item.id) {
          case 'name':
            sortBy = CounterPartySortOption.name;
            break;
          case 'type':
            sortBy = CounterPartySortOption.type;
            break;
          case 'created':
            sortBy = CounterPartySortOption.createdAt;
            break;
          case 'internal':
            sortBy = CounterPartySortOption.isInternal;
            break;
          default:
            return;
        }

        // Toggle direction if same sort option is selected
        final ascending = currentFilter.sortBy == sortBy ? !currentFilter.ascending : true;

        ref.read(counterPartyFilterNotifierProvider.notifier).setFilter(
            currentFilter.copyWith(sortBy: sortBy, ascending: ascending));
      },
    );
  }
}
