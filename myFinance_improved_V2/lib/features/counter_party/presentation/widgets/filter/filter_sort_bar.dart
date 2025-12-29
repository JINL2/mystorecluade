import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myfinance_improved/shared/themes/toss_border_radius.dart';
import 'package:myfinance_improved/shared/themes/toss_colors.dart';
import 'package:myfinance_improved/shared/themes/toss_spacing.dart';
import 'package:myfinance_improved/shared/themes/toss_text_styles.dart';

import '../../../domain/value_objects/counter_party_filter.dart';
import '../../providers/counter_party_providers.dart';

/// Filter and sort bar widget for counter party page
class FilterSortBar extends ConsumerWidget {
  final VoidCallback onFilterTap;
  final VoidCallback onSortTap;

  const FilterSortBar({
    super.key,
    required this.onFilterTap,
    required this.onSortTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filter = ref.watch(counterPartyFilterNotifierProvider);

    return SliverToBoxAdapter(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: TossSpacing.space4),
        padding: const EdgeInsets.symmetric(
          horizontal: TossSpacing.space3,
          vertical: TossSpacing.space2,
        ),
        decoration: BoxDecoration(
          color: TossColors.surface,
          borderRadius: BorderRadius.circular(TossBorderRadius.md),
          boxShadow: [
            BoxShadow(
              color: TossColors.black.withValues(alpha: 0.02),
              blurRadius: 2,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Row(
          children: [
            // Filter Section - 50% space
            Expanded(
              flex: 50,
              child: _buildFilterButton(ref),
            ),

            Container(
              width: 1,
              height: 20,
              color: TossColors.gray200,
            ),

            // Sort Section - 50% space
            Expanded(
              flex: 50,
              child: _buildSortButton(filter),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterButton(WidgetRef ref) {
    final hasActiveFilters = _hasActiveFilters(ref);

    return InkWell(
      onTap: onFilterTap,
      borderRadius: BorderRadius.circular(TossBorderRadius.sm),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: TossSpacing.space3,
          vertical: TossSpacing.space2,
        ),
        child: Row(
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                Icon(
                  Icons.filter_list_rounded,
                  size: 22,
                  color: hasActiveFilters ? TossColors.primary : TossColors.gray600,
                ),
                if (hasActiveFilters)
                  Positioned(
                    right: -4,
                    top: -4,
                    child: Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: TossColors.primary,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(width: TossSpacing.space2),
            Expanded(
              child: Text(
                _getFilterLabel(ref),
                style: TossTextStyles.labelLarge.copyWith(
                  color: TossColors.gray700,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const Icon(
              Icons.keyboard_arrow_down_rounded,
              size: 20,
              color: TossColors.gray500,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSortButton(CounterPartyFilter filter) {
    return InkWell(
      onTap: onSortTap,
      borderRadius: BorderRadius.circular(TossBorderRadius.sm),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: TossSpacing.space3,
          vertical: TossSpacing.space2,
        ),
        child: Row(
          children: [
            const Icon(
              Icons.sort_rounded,
              size: 22,
              color: TossColors.primary,
            ),
            const SizedBox(width: TossSpacing.space2),
            Expanded(
              child: Text(
                _getSortLabel(filter),
                style: TossTextStyles.labelLarge.copyWith(
                  color: TossColors.gray700,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const Icon(
              Icons.keyboard_arrow_down_rounded,
              size: 20,
              color: TossColors.gray500,
            ),
          ],
        ),
      ),
    );
  }

  String _getFilterLabel(WidgetRef ref) {
    final filter = ref.watch(counterPartyFilterNotifierProvider);
    final activeFilters = <String>[];

    if (filter.types != null && filter.types!.isNotEmpty) {
      if (filter.types!.length == 1) {
        activeFilters.add(filter.types!.first.displayName);
      } else {
        activeFilters.add('${filter.types!.length} types');
      }
    }

    if (filter.isInternal != null) {
      activeFilters.add(filter.isInternal! ? 'Internal' : 'External');
    }

    if (activeFilters.isEmpty) {
      return 'Filter';
    }

    return activeFilters.join(' • ');
  }

  String _getSortLabel(CounterPartyFilter filter) {
    switch (filter.sortBy) {
      case CounterPartySortOption.name:
        return 'Name (${filter.ascending ? 'A-Z' : 'Z-A'})';
      case CounterPartySortOption.type:
        return 'Type (${filter.ascending ? 'A-Z' : 'Z-A'})';
      case CounterPartySortOption.createdAt:
        return 'Created (${filter.ascending ? 'Old-New' : 'New-Old'})';
      case CounterPartySortOption.isInternal:
        return 'Internal (${filter.ascending ? 'External First' : 'Internal First'})';
    }
  }

  bool _hasActiveFilters(WidgetRef ref) {
    final filter = ref.watch(counterPartyFilterNotifierProvider);
    return (filter.types?.isNotEmpty ?? false) || filter.isInternal != null;
  }
}
