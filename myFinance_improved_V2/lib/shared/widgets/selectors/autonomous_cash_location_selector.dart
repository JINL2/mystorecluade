// =====================================================
// AUTONOMOUS CASH LOCATION SELECTOR
// Truly reusable cash location selector using entity providers
// =====================================================

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myfinance_improved/app/providers/app_state_provider.dart';
import 'package:myfinance_improved/app/providers/cash_location_provider.dart';
import 'package:myfinance_improved/core/data/models/transaction_history_model.dart';
import 'package:myfinance_improved/core/domain/entities/selector_entities.dart';
import 'package:myfinance_improved/shared/themes/index.dart';
import 'package:myfinance_improved/shared/widgets/toss/toss_bottom_sheet.dart';
import 'package:myfinance_improved/shared/widgets/toss/toss_search_field.dart';

/// Autonomous cash location selector with scope awareness
/// Uses dedicated RPC function and entity providers
/// Can fetch from current app state OR from provided company/store IDs
class AutonomousCashLocationSelector extends ConsumerStatefulWidget {
  final String? companyId; // Optional: Use specific company (e.g., for counterparty)
  final String? storeId; // Optional: Use specific store (e.g., for counterparty)
  final String? selectedLocationId;

  // Legacy callbacks (deprecated but maintained for backward compatibility)
  final SingleSelectionCallback? onChanged;
  final SingleSelectionWithNameCallback? onChangedWithName; // Partial: Returns ID and name

  // ✅ NEW: Type-safe callback
  final OnCashLocationSelectedCallback? onCashLocationSelected;

  final String? label;
  final String? hint;
  final String? errorText;
  final bool showSearch;
  final bool showTransactionCount;
  final bool showScopeTabs; // Show Company/Store tabs
  final TransactionScope? initialScope; // Current scope context (for reference)
  final String? locationType; // Filter by specific location type
  final Set<String>? blockedLocationIds; // IDs of locations that cannot be selected

  const AutonomousCashLocationSelector({
    super.key,
    this.companyId, // Optional company ID
    this.storeId, // Optional store ID
    this.selectedLocationId,
    this.onChanged,
    this.onChangedWithName, // Partial callback (kept for backward compatibility)
    this.onCashLocationSelected, // ✅ NEW: Type-safe callback
    this.label,
    this.hint,
    this.errorText,
    this.showSearch = true,
    this.showTransactionCount = true,
    this.showScopeTabs = true,
    this.initialScope,
    this.locationType,
    this.blockedLocationIds,
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

    // Force refresh the provider to ensure we get fresh data from RPC
    // This is critical to prevent showing deleted cash locations
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Get the effective company ID first
      final appState = ref.read(appStateProvider);
      final effectiveCompanyId = widget.companyId ?? appState.companyChoosen;

      if (effectiveCompanyId.isNotEmpty) {
        // Invalidate the specific provider instance
        ref.invalidate(cashLocationListProvider(effectiveCompanyId, null, widget.locationType));

        // Also try to get the notifier and force refresh if possible
        try {
          final notifier = ref.read(cashLocationListProvider(effectiveCompanyId, null, widget.locationType).notifier);
          notifier.forceRefresh();
        } catch (e) {
          // Could not access notifier, relying on invalidation
        }
      }

      // Also invalidate the company-wide provider if we're using it
      if (widget.companyId == null) {
        ref.invalidate(companyCashLocationsProvider);
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
    // Determine which company/store to use
    String? effectiveCompanyId = widget.companyId;
    String? effectiveStoreId = widget.storeId;

    // If not provided, fall back to app state
    if (effectiveCompanyId == null) {
      final appState = ref.read(appStateProvider);
      final appStateNotifier = ref.read(appStateProvider.notifier);

      // Use companyChoosen directly from app state (this is the source of truth)
      effectiveCompanyId = appState.companyChoosen;

      // Use storeChoosen from app state for consistent store selection
      effectiveStoreId = appState.storeChoosen;
    }

    // Fetch cash locations for the specified or current company (only company_id)
    final allLocationsAsync = widget.companyId != null
        ? ref.watch(cashLocationListProvider(effectiveCompanyId, null, widget.locationType))
        : ref.watch(companyCashLocationsProvider);

    // Listen to data changes and update state accordingly (MUST be in build method)
    ref.listen(
      widget.companyId != null
          ? cashLocationListProvider(effectiveCompanyId, null, widget.locationType)
          : companyCashLocationsProvider,
      (previous, next) {
        next.whenData((allLocations) {
          if (mounted) {
            setState(() {
              // Company tab: Show ALL locations for the company
              _companyItems = allLocations;

              // Store tab: Show company-wide locations AND store-specific locations
              if (effectiveStoreId != null && effectiveStoreId.isNotEmpty) {
                _storeItems = allLocations.where((location) =>
                  location.isCompanyWide || location.storeId == effectiveStoreId,
                ).toList();
              } else {
                _storeItems = allLocations.where((location) =>
                  location.isCompanyWide,
                ).toList();
              }

              _updateFilteredItems();
            });
          }
        });
      },
    );

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

    // If scope tabs are disabled, use custom simple selector with blocked items support
    if (!widget.showScopeTabs) {
      return _buildSimpleSelector(context, allLocationsAsync.isLoading, selectedLocation,
        allLocationsAsync.maybeWhen(
          data: (locations) => locations,
          orElse: () => [],
        ),
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
            color: hasError ? TossColors.error : TossColors.gray600,
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
                      size: TossSpacing.iconSM,
                      color: widget.selectedLocationId != null
                        ? TossColors.primary
                        : TossColors.gray400,
                    ),
                    const SizedBox(width: TossSpacing.space2),
                    
                    // Selected value or hint
                    Expanded(
                      child: isLoading
                        ? const SizedBox(
                            height: TossSpacing.iconSM,
                            width: TossSpacing.iconSM,
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
    // Determine which company/store to use
    String? effectiveCompanyId = widget.companyId;
    String? effectiveStoreId = widget.storeId;
    
    // If not provided, fall back to app state
    if (effectiveCompanyId == null) {
      final appState = ref.read(appStateProvider);
      final appStateNotifier = ref.read(appStateProvider.notifier);
      
      // Use companyChoosen directly from app state (this is the source of truth)
      effectiveCompanyId = appState.companyChoosen;

      // Use storeChoosen from app state for consistent store selection
      effectiveStoreId = appState.storeChoosen;
    }
    
    // CRITICAL FIX: Force refresh the cash location data before showing the bottom sheet
    // This ensures we get fresh data from RPC and don't show deleted locations
    if (widget.companyId != null) {
      ref.invalidate(cashLocationListProvider(effectiveCompanyId, null, widget.locationType));
    } else {
      ref.invalidate(companyCashLocationsProvider);
    }
    
    // Fetch cash locations for the specified or current company (only company_id)
    final allLocationsAsync = widget.companyId != null
        ? ref.watch(cashLocationListProvider(effectiveCompanyId, null, widget.locationType))
        : ref.watch(companyCashLocationsProvider);
    
    // Update data organization when locations change
    allLocationsAsync.whenData((allLocations) {
      // Company tab: Show ALL locations for the company (no additional filtering needed)
      _companyItems = allLocations;
      
      // Store tab: Show company-wide locations AND store-specific locations for selected store
      if (effectiveStoreId != null && effectiveStoreId.isNotEmpty) {
        _storeItems = allLocations.where((location) => 
          location.isCompanyWide || // Include company-wide locations (accessible from any store)
          location.storeId == effectiveStoreId, // Include store-specific locations
        ).toList();
      } else {
        // If no store selected, show only company-wide locations
        _storeItems = allLocations.where((location) => 
          location.isCompanyWide,
        ).toList();
      }
      
      _updateFilteredItems();
    });
    
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: TossColors.transparent,
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
                          style: TossTextStyles.h3.copyWith(
                            fontWeight: FontWeight.bold,
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
                  
                  const SizedBox(height: TossSpacing.space4),
                  
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
                        Container(width: 1, height: TossSpacing.space6, color: TossColors.gray200),
                        _buildTabButton(setModalState, 1, 'Store', Icons.store),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: TossSpacing.space4),
                  
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
                    const SizedBox(height: TossSpacing.space4),
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
                    return _filteredItems.isEmpty
                    ? Padding(
                        padding: const EdgeInsets.all(TossSpacing.space6),
                        child: Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                _searchQuery.isEmpty
                                  ? 'There is no Cash Location.'
                                  : 'No results found',
                                style: TossTextStyles.body.copyWith(color: TossColors.gray500),
                                textAlign: TextAlign.center,
                              ),
                              if (_searchQuery.isEmpty) ...[ 
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
                          final isBlocked = widget.blockedLocationIds?.contains(item.id) ?? false;
                          
                          return InkWell(
                            onTap: isBlocked
                              ? null  // Disable tap if blocked
                              : () {
                                  // ✅ NEW: Type-safe callback (전체 엔티티 전달)
                                  widget.onCashLocationSelected?.call(item);

                                  // ✅ Legacy callbacks (backward compatibility)
                                  widget.onChanged?.call(item.id);
                                  widget.onChangedWithName?.call(item.id, item.name);

                                  Navigator.pop(context);
                                },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 12,
                              ),
                              color: isBlocked 
                                ? TossColors.gray100  // Gray background for blocked items
                                : isSelected 
                                  ? TossColors.primary.withValues(alpha: 0.05) 
                                  : null,
                              child: Row(
                                children: [
                                  // Icon
                                  Icon(
                                    isBlocked ? Icons.block : Icons.location_on,
                                    size: TossSpacing.iconSM,
                                    color: isBlocked 
                                      ? TossColors.gray400
                                      : isSelected 
                                        ? TossColors.primary 
                                        : TossColors.gray500,
                                  ),
                                  const SizedBox(width: TossSpacing.space3),
                                  
                                  // Content
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          item.displayName,
                                          style: TossTextStyles.body.copyWith(
                                            color: isBlocked 
                                              ? TossColors.gray400
                                              : isSelected 
                                                ? TossColors.primary 
                                                : TossColors.gray900,
                                            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                                            decoration: isBlocked ? TextDecoration.lineThrough : null,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 2,
                                        ),
                                        if (widget.showTransactionCount && item.subtitle.isNotEmpty) ...[ 
                                          const SizedBox(height: 2),
                                          Text(
                                            item.subtitle,
                                            style: TossTextStyles.small.copyWith(
                                              color: isBlocked ? TossColors.gray300 : TossColors.gray500,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 1,
                                          ),
                                        ],
                                        if (isBlocked) ...[
                                          const SizedBox(height: 2),
                                          Text(
                                            'Already selected',
                                            style: TossTextStyles.small.copyWith(
                                              color: TossColors.error,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ],
                                      ],
                                    ),
                                  ),
                                  
                                  // Check mark for selected or block icon for blocked
                                  if (isSelected)
                                    const Icon(
                                      Icons.check,
                                      size: TossSpacing.iconSM,
                                      color: TossColors.primary,
                                    )
                                  else if (isBlocked)
                                    const Icon(
                                      Icons.block,
                                      size: TossSpacing.iconSM,
                                      color: TossColors.error,
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
                      padding: EdgeInsets.all(TossSpacing.space6),
                      child: CircularProgressIndicator(color: TossColors.primary),
                    ),
                  ),
                  error: (error, stack) => Padding(
                    padding: const EdgeInsets.all(TossSpacing.space6),
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Failed to load cash locations',
                            style: TossTextStyles.body.copyWith(color: TossColors.error),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: TossSpacing.space2),
                          Text(
                            'Please try again',
                            style: TossTextStyles.body.copyWith(
                              color: TossColors.gray500,
                              fontSize: 14,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),),
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
          padding: const EdgeInsets.symmetric(vertical: TossSpacing.space3),
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
                  size: TossSpacing.iconXS,
                  color: isSelected ? TossColors.primary : TossColors.gray500,
                ),
                const SizedBox(width: TossSpacing.space1),
                Text(
                  label,
                  style: TossTextStyles.body.copyWith(
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

  Widget _buildSimpleSelector(
    BuildContext context,
    bool isLoading,
    CashLocationData? selectedLocation,
    List<CashLocationData> locations,
  ) {
    final hasError = widget.errorText != null && widget.errorText!.isNotEmpty;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label
        Text(
          widget.label ?? 'Cash Location',
          style: TossTextStyles.caption.copyWith(
            color: hasError ? TossColors.error : TossColors.gray600,
            fontWeight: FontWeight.w600,
          ),
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: TossSpacing.space2),
        
        // Selector Field
        GestureDetector(
          onTap: isLoading || widget.onChanged == null 
            ? null 
            : () => _showSimpleSelectionBottomSheet(context, locations),
          behavior: HitTestBehavior.opaque,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(TossBorderRadius.lg),
              color: TossColors.white,
              border: Border.all(
                color: hasError
                  ? TossColors.error
                  : TossColors.gray200,
                width: 1,
              ),
            ),
            padding: const EdgeInsets.all(TossSpacing.space3),
            child: Row(
              children: [
                // Icon
                Icon(
                  Icons.location_on,
                  size: TossSpacing.iconSM,
                  color: widget.selectedLocationId != null
                    ? TossColors.primary
                    : TossColors.gray400,
                ),
                const SizedBox(width: TossSpacing.space2),
                
                // Selected value or hint
                Expanded(
                  child: isLoading
                    ? const SizedBox(
                        height: TossSpacing.iconSM,
                        width: TossSpacing.iconSM,
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
  
  void _showSimpleSelectionBottomSheet(BuildContext context, List<CashLocationData> locations) {
    // CRITICAL FIX: Force refresh before showing simple selector as well
    final appState = ref.read(appStateProvider);
    final effectiveCompanyId = widget.companyId ?? appState.companyChoosen;
    
    if (effectiveCompanyId.isNotEmpty) {
      if (widget.companyId != null) {
        ref.invalidate(cashLocationListProvider(effectiveCompanyId, null, widget.locationType));
      } else {
        ref.invalidate(companyCashLocationsProvider);
      }
    }
    
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: TossColors.transparent,
      builder: (context) => TossBottomSheet(
        content: Container(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.7,
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
                      style: TossTextStyles.h3.copyWith(
                        fontWeight: FontWeight.bold,
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
              
              const SizedBox(height: TossSpacing.space4),
              
              // Clear selection option
              if (widget.selectedLocationId != null)
                _buildClearOption(context),
              
              // Items list
              Flexible(
                child: locations.isEmpty
                  ? Padding(
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
                    )
                  : ListView.separated(
                      shrinkWrap: true,
                      itemCount: locations.length,
                      separatorBuilder: (context, index) => Container(
                        height: 1,
                        color: TossColors.gray100,
                      ),
                      itemBuilder: (context, index) {
                        final item = locations[index];
                        final isSelected = item.id == widget.selectedLocationId;
                        final isBlocked = widget.blockedLocationIds?.contains(item.id) ?? false;
                        
                        return InkWell(
                          onTap: isBlocked
                            ? null  // Disable tap if blocked
                            : () {
                                // ✅ NEW: Type-safe callback (전체 엔티티 전달)
                                widget.onCashLocationSelected?.call(item);

                                // ✅ Legacy callbacks (backward compatibility)
                                widget.onChanged?.call(item.id);
                                widget.onChangedWithName?.call(item.id, item.name);

                                Navigator.pop(context);
                              },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                            color: isBlocked 
                              ? TossColors.gray100  // Gray background for blocked items
                              : isSelected 
                                ? TossColors.primary.withValues(alpha: 0.05) 
                                : null,
                            child: Row(
                              children: [
                                // Icon
                                Icon(
                                  isBlocked ? Icons.block : Icons.location_on,
                                  size: TossSpacing.iconSM,
                                  color: isBlocked 
                                    ? TossColors.gray400
                                    : isSelected 
                                      ? TossColors.primary 
                                      : TossColors.gray500,
                                ),
                                const SizedBox(width: TossSpacing.space3),
                                
                                // Content
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        item.displayName,
                                        style: TossTextStyles.body.copyWith(
                                          color: isBlocked 
                                            ? TossColors.gray400
                                            : isSelected 
                                              ? TossColors.primary 
                                              : TossColors.gray900,
                                          fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                                          decoration: isBlocked ? TextDecoration.lineThrough : null,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 2,
                                      ),
                                      if (widget.showTransactionCount && item.subtitle.isNotEmpty) ...[ 
                                        const SizedBox(height: 2),
                                        Text(
                                          item.subtitle,
                                          style: TossTextStyles.small.copyWith(
                                            color: isBlocked ? TossColors.gray300 : TossColors.gray500,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1,
                                        ),
                                      ],
                                      if (isBlocked) ...[
                                        const SizedBox(height: 2),
                                        Text(
                                          'Already selected',
                                          style: TossTextStyles.small.copyWith(
                                            color: TossColors.error,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ],
                                  ),
                                ),
                                
                                // Check mark for selected or block icon for blocked
                                if (isSelected)
                                  const Icon(
                                    Icons.check,
                                    size: TossSpacing.iconSM,
                                    color: TossColors.primary,
                                  )
                                else if (isBlocked)
                                  const Icon(
                                    Icons.block,
                                    size: TossSpacing.iconSM,
                                    color: TossColors.error,
                                  ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptySelector() {
    final hasError = widget.errorText != null && widget.errorText!.isNotEmpty;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label
        if (widget.label != null) ...[
          Text(
            widget.label!,
            style: TossTextStyles.caption.copyWith(
              color: hasError ? TossColors.error : TossColors.gray600,
              fontWeight: FontWeight.w600,
            ),
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: TossSpacing.space2),
        ],
        
        // Empty state container
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(TossBorderRadius.lg),
            color: TossColors.gray50,
            border: Border.all(
              color: hasError ? TossColors.error : TossColors.gray200,
              width: 1,
            ),
          ),
          padding: const EdgeInsets.all(TossSpacing.space3),
          child: Row(
            children: [
              const Icon(
                Icons.info_outline,
                size: TossSpacing.iconSM,
                color: TossColors.gray400,
              ),
              const SizedBox(width: TossSpacing.space2),
              Expanded(
                child: Text(
                  widget.companyId != null 
                    ? 'No cash locations available'
                    : 'No company selected',
                  style: TossTextStyles.body.copyWith(
                    color: TossColors.gray400,
                  ),
                ),
              ),
            ],
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

  Widget _buildClearOption(BuildContext context) {
    return InkWell(
      onTap: () {
        // Note: Type-safe callback doesn't support null, only use legacy callbacks for clearing
        widget.onChanged?.call(null);
        widget.onChangedWithName?.call(null, null);
        Navigator.pop(context);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
        child: Row(
          children: [
            const Icon(
              Icons.clear,
              size: 20,
              color: TossColors.gray500,
            ),
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

  // Remove this method as we're now handling data separately for each tab
}