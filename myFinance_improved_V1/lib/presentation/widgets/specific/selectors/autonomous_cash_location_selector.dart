// =====================================================
// AUTONOMOUS CASH LOCATION SELECTOR
// Truly reusable cash location selector using entity providers
// =====================================================

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../data/models/selector_entities.dart';
import '../../../../data/models/transaction_history_model.dart';
import '../../../providers/entities/cash_location_provider.dart';
import '../../../providers/app_state_provider.dart';
import '../../toss/toss_bottom_sheet.dart';
import '../../toss/toss_search_field.dart';
import 'toss_base_selector.dart';
import '../../../../core/themes/toss_colors.dart';
import '../../../../core/themes/toss_text_styles.dart';
import '../../../../core/themes/toss_spacing.dart';
import '../../../../core/themes/toss_border_radius.dart';

/// Autonomous cash location selector with scope awareness
/// Uses dedicated RPC function and entity providers
class AutonomousCashLocationSelector extends ConsumerStatefulWidget {
  final String? selectedLocationId;
  final SingleSelectionCallback? onChanged;
  final String? label;
  final String? hint;
  final String? errorText;
  final bool showSearch;
  final bool showTransactionCount;
  final bool showScopeTabs; // Show Company/Store tabs
  final TransactionScope? initialScope; // Current scope context (for reference)
  final String? locationType; // Filter by specific location type

  const AutonomousCashLocationSelector({
    super.key,
    this.selectedLocationId,
    this.onChanged,
    this.label,
    this.hint,
    this.errorText,
    this.showSearch = true,
    this.showTransactionCount = true,
    this.showScopeTabs = true,
    this.initialScope,
    this.locationType,
  });

  @override
  ConsumerState<AutonomousCashLocationSelector> createState() => _AutonomousCashLocationSelectorState();
}

class _AutonomousCashLocationSelectorState extends ConsumerState<AutonomousCashLocationSelector> 
    with SingleTickerProviderStateMixin {
  List<CashLocationData> _companyItems = [];
  List<CashLocationData> _storeItems = [];
  List<CashLocationData> _filteredItems = [];
  String _searchQuery = '';
  late TabController _tabController;
  int _selectedTabIndex = 1; // Default to Store tab

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.index = _selectedTabIndex;
    _tabController.addListener(() {
      if (_tabController.index != _selectedTabIndex) {
        setState(() {
          _selectedTabIndex = _tabController.index;
          _updateFilteredItems();
        });
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _updateFilteredItems() {
    final currentItems = _selectedTabIndex == 0 ? _companyItems : _storeItems;
    
    if (_searchQuery.isEmpty) {
      _filteredItems = currentItems;
    } else {
      _filteredItems = currentItems.where((item) {
        final nameLower = item.name.toLowerCase();
        final typeLower = item.type.toLowerCase();
        final queryLower = _searchQuery.toLowerCase();
        return nameLower.contains(queryLower) || typeLower.contains(queryLower);
      }).toList();
    }
  }

  void _filterItems(String query) {
    setState(() {
      _searchQuery = query;
      _updateFilteredItems();
    });
  }

  @override
  Widget build(BuildContext context) {
    // Get current store ID from app state
    final appStateNotifier = ref.read(appStateProvider.notifier);
    final currentStoreId = appStateNotifier.selectedStore?['store_id'] as String?;
    
    // Always fetch ALL company locations (no store filtering at RPC level)
    final allLocationsAsync = ref.watch(companyCashLocationsProvider);

    // Find selected location
    CashLocationData? selectedLocation;
    if (widget.selectedLocationId != null) {
      allLocationsAsync.whenData((locations) {
        try {
          selectedLocation = locations.firstWhere((location) => location.id == widget.selectedLocationId);
        } catch (e) {
          selectedLocation = null;
        }
      });
    }

    // Organize locations by scope when data is available
    allLocationsAsync.whenData((allLocations) {
      // Company tab: Show ALL locations
      _companyItems = allLocations;
      
      // Store tab: Filter to show only current store's locations (exclude company-wide)
      if (currentStoreId != null) {
        _storeItems = allLocations.where((location) => 
          location.storeId == currentStoreId // Only locations for current store
        ).toList();
      } else {
        // If no store selected, show empty list
        _storeItems = [];
      }
      
      _updateFilteredItems();
    });

    // If scope tabs are disabled, use simple selector
    if (!widget.showScopeTabs) {
      return TossSingleSelector<CashLocationData>(
        items: allLocationsAsync.maybeWhen(
          data: (locations) => locations,
          orElse: () => [],
        ),
        selectedItem: selectedLocation,
        onChanged: widget.onChanged,
        isLoading: allLocationsAsync.isLoading,
        config: SelectorConfig(
          label: widget.label ?? 'Cash Location',
          hint: widget.hint ?? 'All Locations',
          errorText: widget.errorText,
          showSearch: widget.showSearch,
          showTransactionCount: widget.showTransactionCount,
          icon: Icons.location_on,
          emptyMessage: 'There is no Cash Location.\nGo to Cash and create Cash Location',
          searchHint: 'Search cash locations',
        ),
        itemTitleBuilder: (location) => location.displayName,
        itemSubtitleBuilder: widget.showTransactionCount 
            ? (location) => location.subtitle
            : null,
        itemIdBuilder: (location) => location.id,
        itemFilterBuilder: (location, query) {
          final queryLower = query.toLowerCase();
          return location.name.toLowerCase().contains(queryLower) ||
                 location.type.toLowerCase().contains(queryLower);
        },
      );
    }

    // Custom selector with scope tabs
    return _buildScopedSelector(context, allLocationsAsync.isLoading, selectedLocation);
  }

  Widget _buildScopedSelector(
    BuildContext context, 
    bool isLoading,
    CashLocationData? selectedLocation,
  ) {
    final hasError = widget.errorText != null && widget.errorText!.isNotEmpty;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label
        Text(
          widget.label ?? 'Cash Location',
          style: TossTextStyles.caption.copyWith(
            color: hasError ? TossColors.error : TossColors.gray700,
            fontWeight: FontWeight.w600,
          ),
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: TossSpacing.space2),
        
        // Selector Field
        GestureDetector(
          onTap: isLoading || widget.onChanged == null 
            ? null 
            : () => _showScopedSelectionBottomSheet(context),
          behavior: HitTestBehavior.opaque,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(TossBorderRadius.lg),
              color: TossColors.white,
              border: Border.all(
                color: hasError
                  ? TossColors.error
                  : widget.selectedLocationId != null 
                    ? TossColors.primary
                    : TossColors.gray200,
                width: 1,
              ),
              boxShadow: null, // Remove shadow for consistency
            ),
            padding: const EdgeInsets.all(TossSpacing.space3),
            child: Row(
                  children: [
                    // Icon
                    Icon(
                      Icons.location_on,
                      size: 20,
                      color: widget.selectedLocationId != null
                        ? TossColors.primary
                        : TossColors.gray400,
                    ),
                    const SizedBox(width: TossSpacing.space2),
                    
                    // Selected value or hint
                    Expanded(
                      child: isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: TossColors.primary,
                            ),
                          )
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                selectedLocation?.displayName ?? widget.hint ?? 'Select Location',
                                style: TossTextStyles.body.copyWith(
                                  color: widget.selectedLocationId != null
                                    ? TossColors.gray900
                                    : TossColors.gray400,
                                  fontWeight: widget.selectedLocationId != null 
                                    ? FontWeight.w600 
                                    : FontWeight.w400,
                                  fontSize: 16,
                                ),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                              if (selectedLocation != null && widget.showTransactionCount) ...[ 
                                const SizedBox(height: 2),
                                Text(
                                  selectedLocation.subtitle,
                                  style: TossTextStyles.caption.copyWith(
                                    color: TossColors.gray500,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                ),
                              ],
                            ],
                          ),
                    ),
                    
                    // Dropdown icon
                    Icon(
                      Icons.arrow_drop_down,
                      color: widget.selectedLocationId != null
                        ? TossColors.primary
                        : TossColors.gray400,
                    ),
                  ],
            ),
          ),
        ),
        
        // Error text
        if (hasError) ...[ 
          const SizedBox(height: TossSpacing.space2),
          Text(
            widget.errorText!,
            style: TossTextStyles.caption.copyWith(
              color: TossColors.error,
            ),
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
          ),
        ],
      ],
    );
  }

  void _showScopedSelectionBottomSheet(BuildContext context) {
    // Get current store ID from app state
    final appStateNotifier = ref.read(appStateProvider.notifier);
    final currentStoreId = appStateNotifier.selectedStore?['store_id'] as String?;
    
    // Always fetch ALL company locations (no store filtering at RPC level)
    final allLocationsAsync = ref.watch(companyCashLocationsProvider);
    
    // Update data organization when locations change
    allLocationsAsync.whenData((allLocations) {
      // Company tab: Show ALL locations
      _companyItems = allLocations;
      
      // Store tab: Filter to show only current store's locations
      if (currentStoreId != null) {
        _storeItems = allLocations.where((location) => 
          location.storeId == currentStoreId
        ).toList();
      } else {
        _storeItems = [];
      }
      
      _updateFilteredItems();
    });
    
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => TossBottomSheet(
        content: StatefulBuilder(
          builder: (context, setModalState) {
            final screenHeight = MediaQuery.of(context).size.height;
            
            return Container(
              constraints: BoxConstraints(
                maxHeight: screenHeight * 0.7, // Limit to 70% of screen height
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Text(
                          'Select ${widget.label ?? 'Cash Location'}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close, color: TossColors.gray500),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Tab Bar
                  Container(
                    decoration: BoxDecoration(
                      color: TossColors.gray50,
                      borderRadius: BorderRadius.circular(TossBorderRadius.lg),
                      border: Border.all(color: TossColors.gray200),
                    ),
                    child: Row(
                      children: [
                        _buildTabButton(setModalState, 0, 'Company', Icons.business),
                        Container(width: 1, height: 24, color: TossColors.gray200),
                        _buildTabButton(setModalState, 1, 'Store', Icons.store),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Search field
                  if (widget.showSearch) ...[ 
                    TossSearchField(
                      hintText: 'Search ${_selectedTabIndex == 0 ? 'company' : 'store'} locations',
                      onChanged: (value) {
                        setModalState(() {
                          _filterItems(value);
                        });
                      },
                    ),
                    const SizedBox(height: 16),
                  ],
                  
                  // Clear selection option
                  if (widget.selectedLocationId != null)
                    _buildClearOption(context),
                  
                  // Items list - use Flexible to prevent overflow
                  Flexible(
                child: allLocationsAsync.when(
                  data: (locations) {
                    final currentItems = _selectedTabIndex == 0 ? _companyItems : _storeItems;
                    if (currentItems.isEmpty) {
                      return Padding(
                        padding: const EdgeInsets.all(24),
                        child: Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'There is no Cash Location.',
                                style: TextStyle(color: TossColors.gray500),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Go to Cash and create Cash Location',
                                style: TextStyle(
                                  color: TossColors.primary,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      );
                    }
                    return _filteredItems.isEmpty
                    ? Padding(
                        padding: const EdgeInsets.all(24),
                        child: Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                _searchQuery.isEmpty
                                  ? 'There is no Cash Location.'
                                  : 'No results found',
                                style: TextStyle(color: TossColors.gray500),
                                textAlign: TextAlign.center,
                              ),
                              if (_searchQuery.isEmpty) ...[ 
                                const SizedBox(height: 8),
                                Text(
                                  'Go to Cash and create Cash Location',
                                  style: TextStyle(
                                    color: TossColors.primary,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ],
                          ),
                        ),
                      )
                    : ListView.separated(
                        shrinkWrap: true,
                        itemCount: _filteredItems.length,
                        separatorBuilder: (context, index) => Container(
                          height: 1,
                          color: TossColors.gray100,
                        ),
                        itemBuilder: (context, index) {
                          final item = _filteredItems[index];
                          final isSelected = item.id == widget.selectedLocationId;
                          
                          return InkWell(
                            onTap: () {
                              widget.onChanged?.call(item.id);
                              Navigator.pop(context);
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 12,
                              ),
                              color: isSelected ? TossColors.primary.withValues(alpha: 0.05) : null,
                              child: Row(
                                children: [
                                  // Icon
                                  Icon(
                                    Icons.location_on,
                                    size: 20,
                                    color: isSelected ? TossColors.primary : TossColors.gray500,
                                  ),
                                  const SizedBox(width: 12),
                                  
                                  // Content
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          item.displayName,
                                          style: TextStyle(
                                            color: isSelected ? TossColors.primary : TossColors.gray900,
                                            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 2,
                                        ),
                                        if (widget.showTransactionCount && item.subtitle.isNotEmpty) ...[ 
                                          const SizedBox(height: 2),
                                          Text(
                                            item.subtitle,
                                            style: const TextStyle(
                                              color: TossColors.gray500,
                                              fontSize: 12,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 1,
                                          ),
                                        ],
                                      ],
                                    ),
                                  ),
                                  
                                  // Check mark for selected
                                  if (isSelected)
                                    const Icon(
                                      Icons.check,
                                      size: 20,
                                      color: TossColors.primary,
                                    ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                  },
                  loading: () => const Center(
                    child: Padding(
                      padding: EdgeInsets.all(24),
                      child: CircularProgressIndicator(color: TossColors.primary),
                    ),
                  ),
                  error: (error, stack) => Padding(
                    padding: const EdgeInsets.all(24),
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Failed to load cash locations',
                            style: TextStyle(color: TossColors.error),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Please try again',
                            style: TextStyle(
                              color: TossColors.gray500,
                              fontSize: 14,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                )),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildTabButton(StateSetter setModalState, int index, String label, IconData icon) {
    final isSelected = _selectedTabIndex == index;
    return Expanded(
      child: InkWell(
        onTap: () => setModalState(() {
          _selectedTabIndex = index;
          _updateFilteredItems();
        }),
        borderRadius: BorderRadius.horizontal(
          left: index == 0 ? const Radius.circular(11) : Radius.zero,
          right: index == 1 ? const Radius.circular(11) : Radius.zero,
        ),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? TossColors.white : TossColors.transparent,
            borderRadius: BorderRadius.horizontal(
              left: index == 0 ? const Radius.circular(11) : Radius.zero,
              right: index == 1 ? const Radius.circular(11) : Radius.zero,
            ),
            border: isSelected ? Border.all(color: TossColors.primary) : null,
          ),
          child: Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  icon,
                  size: 16,
                  color: isSelected ? TossColors.primary : TossColors.gray500,
                ),
                const SizedBox(width: 4),
                Text(
                  label,
                  style: TextStyle(
                    color: isSelected ? TossColors.primary : TossColors.gray600,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildClearOption(BuildContext context) {
    return InkWell(
      onTap: () {
        widget.onChanged?.call(null);
        Navigator.pop(context);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
        child: const Row(
          children: [
            Icon(
              Icons.clear,
              size: 20,
              color: TossColors.gray500,
            ),
            SizedBox(width: 12),
            Text(
              'Clear selection',
              style: TextStyle(color: TossColors.gray500),
            ),
          ],
        ),
      ),
    );
  }

  // Remove this method as we're now handling data separately for each tab
}