/// Cash Location Selector List
///
/// List widget that displays available cash locations.
library;

import 'package:flutter/material.dart';
import 'package:myfinance_improved/core/domain/entities/selector_entities.dart';
import 'package:myfinance_improved/shared/themes/index.dart';

import 'cash_location_selector_item.dart';

/// Cash location list widget
class CashLocationSelectorList extends StatelessWidget {
  final List<CashLocationData> locations;
  final String? selectedLocationId;
  final Set<String>? blockedLocationIds;
  final void Function(CashLocationData location) onLocationSelected;
  final bool showTransactionCount;
  final String searchQuery;

  const CashLocationSelectorList({
    super.key,
    required this.locations,
    required this.selectedLocationId,
    this.blockedLocationIds,
    required this.onLocationSelected,
    this.showTransactionCount = true,
    this.searchQuery = '',
  });

  @override
  Widget build(BuildContext context) {
    if (locations.isEmpty) {
      return _buildEmptyState();
    }

    // Filter by search query
    final displayItems = searchQuery.isEmpty
        ? locations
        : locations.where((item) {
            final nameLower = item.name.toLowerCase();
            final typeLower = item.type.toLowerCase();
            final queryLower = searchQuery.toLowerCase();
            return nameLower.contains(queryLower) || typeLower.contains(queryLower);
          }).toList();

    if (displayItems.isEmpty) {
      return _buildNoResultsState();
    }

    return ListView.separated(
      shrinkWrap: true,
      itemCount: displayItems.length,
      separatorBuilder: (context, index) => Container(
        height: 1,
        color: TossColors.gray100,
      ),
      itemBuilder: (context, index) {
        final item = displayItems[index];
        final isSelected = item.id == selectedLocationId;
        final isBlocked = blockedLocationIds?.contains(item.id) ?? false;

        return CashLocationSelectorItem(
          location: item,
          isSelected: isSelected,
          isBlocked: isBlocked,
          onTap: () => onLocationSelected(item),
          showTransactionCount: showTransactionCount,
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return Padding(
      padding: const EdgeInsets.all(TossSpacing.space6),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'There is no Cash Location.',
              style: TossTextStyles.body.copyWith(color: TossColors.gray500),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: TossSpacing.space2),
            Text(
              'Go to Cash and create Cash Location',
              style: TossTextStyles.caption.copyWith(
                color: TossColors.primary,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNoResultsState() {
    return Padding(
      padding: const EdgeInsets.all(TossSpacing.space6),
      child: Center(
        child: Text(
          'No results found',
          style: TossTextStyles.body.copyWith(color: TossColors.gray500),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
