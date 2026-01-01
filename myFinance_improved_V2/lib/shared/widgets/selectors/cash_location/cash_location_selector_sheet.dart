/// Cash Location Selector Sheet
///
/// Bottom sheet container for cash location selection.
/// Supports both scoped (Company/Store tabs) and simple modes.
library;

import 'package:flutter/material.dart';
import 'package:myfinance_improved/core/domain/entities/selector_entities.dart';
import 'package:myfinance_improved/shared/themes/index.dart';
import 'package:myfinance_improved/shared/widgets/organisms/sheets/toss_bottom_sheet.dart';
import 'package:myfinance_improved/shared/widgets/atoms/inputs/toss_search_field.dart';

import 'cash_location_selector_list.dart';
import 'cash_location_tabs.dart';

/// Bottom sheet with scope tabs (Company/Store)
class CashLocationScopedSheet extends StatefulWidget {
  final List<CashLocationData> companyLocations;
  final List<CashLocationData> storeLocations;
  final String? selectedLocationId;
  final Set<String>? blockedLocationIds;
  final void Function(CashLocationData location) onLocationSelected;
  final VoidCallback? onClear;
  final String? label;
  final bool showSearch;
  final bool showTransactionCount;
  final int initialTabIndex;

  const CashLocationScopedSheet({
    super.key,
    required this.companyLocations,
    required this.storeLocations,
    required this.selectedLocationId,
    this.blockedLocationIds,
    required this.onLocationSelected,
    this.onClear,
    this.label,
    this.showSearch = true,
    this.showTransactionCount = true,
    this.initialTabIndex = 1,
  });

  @override
  State<CashLocationScopedSheet> createState() => _CashLocationScopedSheetState();
}

class _CashLocationScopedSheetState extends State<CashLocationScopedSheet> {
  late int _selectedTabIndex;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _selectedTabIndex = widget.initialTabIndex;
  }

  List<CashLocationData> get _currentLocations {
    return _selectedTabIndex == 0 ? widget.companyLocations : widget.storeLocations;
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return TossBottomSheet(
      content: Container(
        constraints: BoxConstraints(maxHeight: screenHeight * 0.7),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            const SizedBox(height: TossSpacing.space4),
            CashLocationScopeTabs(
              selectedIndex: _selectedTabIndex,
              onTabChanged: (index) {
                setState(() {
                  _selectedTabIndex = index;
                });
              },
            ),
            const SizedBox(height: TossSpacing.space4),
            if (widget.showSearch) ...[
              TossSearchField(
                hintText: 'Search ${_selectedTabIndex == 0 ? 'company' : 'store'} locations',
                onChanged: (value) {
                  setState(() {
                    _searchQuery = value;
                  });
                },
              ),
              const SizedBox(height: TossSpacing.space4),
            ],
            if (widget.selectedLocationId != null) _buildClearOption(),
            Flexible(
              child: CashLocationSelectorList(
                locations: _currentLocations,
                selectedLocationId: widget.selectedLocationId,
                blockedLocationIds: widget.blockedLocationIds,
                onLocationSelected: (location) {
                  widget.onLocationSelected(location);
                  Navigator.pop(context);
                },
                showTransactionCount: widget.showTransactionCount,
                searchQuery: _searchQuery,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: Text(
            'Select ${widget.label ?? 'Cash Location'}',
            style: TossTextStyles.h3.copyWith(fontWeight: FontWeight.bold),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        IconButton(
          icon: const Icon(Icons.close, color: TossColors.gray500),
          onPressed: () => Navigator.pop(context),
        ),
      ],
    );
  }

  Widget _buildClearOption() {
    return InkWell(
      onTap: () {
        widget.onClear?.call();
        Navigator.pop(context);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            const Icon(Icons.clear, size: 20, color: TossColors.gray500),
            const SizedBox(width: TossSpacing.space3),
            Text(
              'Clear selection',
              style: TossTextStyles.body.copyWith(color: TossColors.gray500),
            ),
          ],
        ),
      ),
    );
  }
}

/// Simple bottom sheet without scope tabs
class CashLocationSimpleSheet extends StatelessWidget {
  final List<CashLocationData> locations;
  final String? selectedLocationId;
  final Set<String>? blockedLocationIds;
  final void Function(CashLocationData location) onLocationSelected;
  final VoidCallback? onClear;
  final String? label;
  final bool showTransactionCount;

  const CashLocationSimpleSheet({
    super.key,
    required this.locations,
    required this.selectedLocationId,
    this.blockedLocationIds,
    required this.onLocationSelected,
    this.onClear,
    this.label,
    this.showTransactionCount = true,
  });

  @override
  Widget build(BuildContext context) {
    return TossBottomSheet(
      content: Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.7,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(context),
            const SizedBox(height: TossSpacing.space4),
            if (selectedLocationId != null) _buildClearOption(context),
            Flexible(
              child: CashLocationSelectorList(
                locations: locations,
                selectedLocationId: selectedLocationId,
                blockedLocationIds: blockedLocationIds,
                onLocationSelected: (location) {
                  onLocationSelected(location);
                  Navigator.pop(context);
                },
                showTransactionCount: showTransactionCount,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: Text(
            'Select ${label ?? 'Cash Location'}',
            style: TossTextStyles.h3.copyWith(fontWeight: FontWeight.bold),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        IconButton(
          icon: const Icon(Icons.close, color: TossColors.gray500),
          onPressed: () => Navigator.pop(context),
        ),
      ],
    );
  }

  Widget _buildClearOption(BuildContext context) {
    return InkWell(
      onTap: () {
        onClear?.call();
        Navigator.pop(context);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            const Icon(Icons.clear, size: 20, color: TossColors.gray500),
            const SizedBox(width: TossSpacing.space3),
            Text(
              'Clear selection',
              style: TossTextStyles.body.copyWith(color: TossColors.gray500),
            ),
          ],
        ),
      ),
    );
  }
}
