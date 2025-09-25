import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/themes/index.dart';
import '../../../core/helpers/widget_migration_helper.dart';
import '../../widgets/common/toss_scaffold.dart';
import '../../widgets/common/toss_white_card.dart';
import '../../widgets/toss/toss_list_tile.dart';
import '../../widgets/toss/toss_search_field.dart';
import '../../helpers/navigation_helper.dart';
import 'models/product_model.dart';
import 'package:myfinance_improved/core/themes/toss_border_radius.dart';
import 'providers/inventory_providers.dart';
import '../../../data/models/inventory_models.dart';
import '../../providers/app_state_provider.dart';
import 'dart:async';

/// V2 of Inventory Management Page with safe widget migration
/// 
/// This version uses WidgetMigrationHelper for clean conditional widget usage.
/// Enable feature flags in widget_migration_config.dart to activate new widgets.
class InventoryManagementPageV2 extends ConsumerStatefulWidget {
  const InventoryManagementPageV2({Key? key}) : super(key: key);

  @override
  ConsumerState<InventoryManagementPageV2> createState() => _InventoryManagementPageV2State();
}

class _InventoryManagementPageV2State extends ConsumerState<InventoryManagementPageV2> {
  static const String _pageName = 'inventory_management';
  
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  final ScrollController _scrollController = ScrollController();
  
  // Filters
  String? _selectedStockStatus;
  String? _selectedCategory;
  String? _selectedBrand;
  
  // Sorting
  String _sortBy = 'name';
  String _sortDirection = 'asc';

  @override
  void initState() {
    super.initState();
    
    // Log migration status in debug mode
    WidgetMigrationHelper.logStatus(_pageName);
    
    // Setup scroll listener for pagination
    _scrollController.addListener(_onScroll);
    
    // Search is handled directly by TossSearchField's onChanged callback
    // No need for controller listener to avoid double debouncing
  }
  
  void _onScroll() {
    if (_isBottom) {
      ref.read(inventoryPageProvider.notifier).loadNextPage();
    }
  }
  
  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }
  
  void _onSearchChanged(String value) {
    // Directly call provider without additional debouncing
    // TossSearchField already handles debouncing internally
    ref.read(inventoryPageProvider.notifier).setSearchQuery(value.isEmpty ? null : value);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _applyFilter(String filterType, String? value) {
    final notifier = ref.read(inventoryPageProvider.notifier);
    
    switch (filterType) {
      case 'category':
        _selectedCategory = value;
        notifier.setCategory(value);
        break;
      case 'brand':
        _selectedBrand = value;
        notifier.setBrand(value);
        break;
      case 'stockStatus':
        _selectedStockStatus = value;
        notifier.setStockStatus(value);
        break;
    }
  }
  
  void _applySorting(String sortBy, String sortDirection) {
    setState(() {
      _sortBy = sortBy;
      _sortDirection = sortDirection;
    });
    ref.read(inventoryPageProvider.notifier).setSorting(sortBy, sortDirection);
  }
  
  bool _hasActiveFilters() {
    return _selectedCategory != null || 
           _selectedBrand != null || 
           _selectedStockStatus != null;
  }
  
  int _getActiveFilterCount() {
    int count = 0;
    if (_selectedCategory != null) count++;
    if (_selectedBrand != null) count++;
    if (_selectedStockStatus != null) count++;
    return count;
  }

  @override
  Widget build(BuildContext context) {
    // Only watch metadata for filters, NOT inventory state to prevent search bar rebuilds
    final metadataAsync = ref.watch(inventoryMetadataProvider);
    
    return TossScaffold(
      backgroundColor: TossColors.gray100,
      // Use helper for AppBar with IconButton
      appBar: WidgetMigrationHelper.appBar(
        title: 'Product',
        leading: WidgetMigrationHelper.iconButton(
          icon: TossIcons.back,
          onPressed: () => NavigationHelper.safeGoBack(context),
          pageName: _pageName,
        ),
        pageName: _pageName,
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await ref.read(inventoryPageProvider.notifier).refresh();
        },
        child: _buildStableBody(metadataAsync),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // Get inventory metadata before navigating
          final metadata = await ref.read(inventoryMetadataProvider.future);
          
          final result = await NavigationHelper.navigateTo(
            context,
            '/inventoryManagement/addProduct',
            extra: {'metadata': metadata},
          );
          if (result != null) {
            // Refresh the list after adding a new product
            ref.read(inventoryPageProvider.notifier).refresh();
          }
        },
        backgroundColor: TossColors.primary,
        child: const Icon(TossIcons.add, color: TossColors.white),
      ),
    );
  }
  
  // New stable body that doesn't rebuild search bar
  Widget _buildStableBody(AsyncValue<InventoryMetadata?> metadataAsync) {
    return ListView(
      controller: _scrollController,
      children: [
        // Search and Filter Section (stable - doesn't rebuild with inventory state)
        _buildSearchFilterSection(metadataAsync.value),
        
        // Only the product results watch inventory state and rebuild
        Consumer(
          builder: (context, ref, child) {
            final inventoryState = ref.watch(inventoryPageProvider);
            return _buildProductResults(inventoryState);
          },
        ),
        
        // Bottom padding to prevent FAB overlap
        SizedBox(height: 80),
      ],
    );
  }
  
  // Separated product results that can rebuild independently
  Widget _buildProductResults(InventoryPageState state) {
    if (state.isLoading && state.products.isEmpty) {
      return Container(
        height: MediaQuery.of(context).size.height * 0.5,
        child: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
    
    if (state.error != null && state.products.isEmpty) {
      return Container(
        height: MediaQuery.of(context).size.height * 0.5,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: 64, color: TossColors.gray400),
              SizedBox(height: TossSpacing.space3),
              Text(
                'Error loading products',
                style: TossTextStyles.bodyLarge,
              ),
              SizedBox(height: TossSpacing.space2),
              Text(
                state.error!,
                style: TossTextStyles.body.copyWith(color: TossColors.gray600),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: TossSpacing.space4),
              ElevatedButton(
                onPressed: () => ref.read(inventoryPageProvider.notifier).refresh(),
                child: const Text('Retry'),
              ),
              SizedBox(height: TossSpacing.space2),
              // Debug button to help with setup
              _buildDebugButtons(state),
            ],
          ),
        ),
      );
    }
    
    // Products list content
    if (state.products.isEmpty && !state.isLoading) {
      return Container(
        height: MediaQuery.of(context).size.height * 0.5,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.inventory_2,
                size: 64,
                color: TossColors.gray400,
              ),
              const SizedBox(height: TossSpacing.space3),
              Text(
                'No products found',
                style: TossTextStyles.bodyLarge.copyWith(
                  color: TossColors.gray600,
                ),
              ),
            ],
          ),
        ),
      );
    }
    
    return Container(
      margin: EdgeInsets.all(TossSpacing.space4),
      child: TossWhiteCard(
        padding: EdgeInsets.zero,
        child: Column(
          children: [
            // Section Header
            Container(
              padding: EdgeInsets.all(TossSpacing.space4),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: TossColors.gray100,
                    width: 1,
                  ),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.inventory_2_rounded,
                    color: TossColors.primary,
                    size: 20,
                  ),
                  SizedBox(width: TossSpacing.space2),
                  Text(
                    'Products',
                    style: TossTextStyles.bodyLarge.copyWith(
                      fontWeight: FontWeight.w700,
                      color: TossColors.gray900,
                    ),
                  ),
                  Spacer(),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: TossSpacing.space2,
                      vertical: TossSpacing.space1,
                    ),
                    decoration: BoxDecoration(
                      color: TossColors.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(TossBorderRadius.sm),
                    ),
                    child: Text(
                      '${state.totalProducts} items',
                      style: TossTextStyles.caption.copyWith(
                        color: TossColors.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            // Product List
            ...state.products.asMap().entries.map((entry) {
              final index = entry.key;
              final product = entry.value;
              
              return Column(
                children: [
                  _buildInventoryProductTile(product, state.currency),
                  if (index < state.products.length - 1)
                    Divider(
                      height: 1,
                      color: TossColors.gray100,
                      indent: TossSpacing.space4,
                      endIndent: TossSpacing.space4,
                    ),
                ],
              );
            }).toList(),
            
            // Loading indicator for pagination
            if (state.isLoadingMore)
              Container(
                padding: EdgeInsets.all(TossSpacing.space4),
                child: Center(
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildDebugButtons(InventoryPageState state) {
    final appState = ref.watch(appStateProvider);
    
    return Container(
      padding: EdgeInsets.all(TossSpacing.space3),
      margin: EdgeInsets.symmetric(horizontal: TossSpacing.space4),
      decoration: BoxDecoration(
        color: TossColors.gray100,
        borderRadius: BorderRadius.circular(TossBorderRadius.md),
        border: Border.all(color: TossColors.gray300),
      ),
      child: Column(
        children: [
          Text(
            'Debug Info:',
            style: TossTextStyles.labelLarge.copyWith(fontWeight: FontWeight.bold),
          ),
          SizedBox(height: TossSpacing.space2),
          Container(
            padding: EdgeInsets.all(TossSpacing.space2),
            decoration: BoxDecoration(
              color: TossColors.white,
              borderRadius: BorderRadius.circular(TossBorderRadius.sm),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      appState.companyChoosen.isEmpty ? Icons.warning : Icons.check_circle,
                      size: 16,
                      color: appState.companyChoosen.isEmpty ? TossColors.warning : TossColors.success,
                    ),
                    SizedBox(width: TossSpacing.space1),
                    Text(
                      'Company: ',
                      style: TossTextStyles.caption.copyWith(fontWeight: FontWeight.w600),
                    ),
                    Expanded(
                      child: Text(
                        appState.companyChoosen.isEmpty ? 'NOT SELECTED' : appState.companyChoosen,
                        style: TossTextStyles.caption.copyWith(
                          color: appState.companyChoosen.isEmpty ? TossColors.error : TossColors.gray700,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: TossSpacing.space1),
                Row(
                  children: [
                    Icon(
                      appState.storeChoosen.isEmpty ? Icons.warning : Icons.check_circle,
                      size: 16,
                      color: appState.storeChoosen.isEmpty ? TossColors.warning : TossColors.success,
                    ),
                    SizedBox(width: TossSpacing.space1),
                    Text(
                      'Store: ',
                      style: TossTextStyles.caption.copyWith(fontWeight: FontWeight.w600),
                    ),
                    Expanded(
                      child: Text(
                        appState.storeChoosen.isEmpty ? 'NOT SELECTED' : appState.storeChoosen,
                        style: TossTextStyles.caption.copyWith(
                          color: appState.storeChoosen.isEmpty ? TossColors.error : TossColors.gray700,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                if (state.error != null) ...[
                  SizedBox(height: TossSpacing.space2),
                  Divider(height: 1, color: TossColors.gray200),
                  SizedBox(height: TossSpacing.space2),
                  Text(
                    'Error Details:',
                    style: TossTextStyles.caption.copyWith(fontWeight: FontWeight.w600, color: TossColors.error),
                  ),
                  SizedBox(height: TossSpacing.space1),
                  Text(
                    state.error!,
                    style: TossTextStyles.caption.copyWith(color: TossColors.error),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ],
            ),
          ),
          SizedBox(height: TossSpacing.space3),
          if (appState.companyChoosen.isEmpty || appState.storeChoosen.isEmpty)
            ElevatedButton.icon(
              onPressed: () async {
                // Auto-select first company and store
                final user = appState.user;
                if (user != null && user is Map) {
                  final companies = user['companies'] as List?;
                  if (companies != null && companies.isNotEmpty) {
                    final firstCompany = companies.first;
                    final companyId = firstCompany['company_id']?.toString() ?? '';
                    
                    if (companyId.isNotEmpty) {
                      await ref.read(appStateProvider.notifier).setCompanyChoosen(companyId);
                      
                      final stores = firstCompany['stores'] as List?;
                      if (stores != null && stores.isNotEmpty) {
                        final firstStore = stores.first;
                        final storeId = firstStore['store_id']?.toString() ?? '';
                        if (storeId.isNotEmpty) {
                          await ref.read(appStateProvider.notifier).setStoreChoosen(storeId);
                          
                          // Show success message
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Selected: ${firstCompany['name']} - ${firstStore['name']}'),
                              backgroundColor: TossColors.success,
                            ),
                          );
                          
                          // Refresh the inventory data
                          ref.read(inventoryPageProvider.notifier).refresh();
                        }
                      }
                    }
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('No companies found in user data'),
                        backgroundColor: TossColors.error,
                      ),
                    );
                  }
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('User data not available'),
                      backgroundColor: TossColors.error,
                    ),
                  );
                }
              },
              icon: Icon(Icons.auto_fix_high),
              label: Text('Auto-Select Company & Store'),
              style: ElevatedButton.styleFrom(
                backgroundColor: TossColors.primary,
              ),
            ),
        ],
      ),
    );
  }

  // Helper method for auto-selecting company and store
  Future<void> _autoSelectCompanyStore() async {
    final appState = ref.read(appStateProvider);
    final appStateNotifier = ref.read(appStateProvider.notifier);
    
    print('🎯 [AUTO_SELECT] Starting auto-selection process...');
    print('🔍 [AUTO_SELECT] User data type: ${appState.user.runtimeType}');
    print('🔍 [AUTO_SELECT] User data: ${appState.user}');
    
    if (appState.user is Map) {
      final userMap = appState.user as Map;
      print('🔑 [AUTO_SELECT] User map keys: ${userMap.keys.toList()}');
      
      if (userMap.containsKey('companies')) {
        final companies = userMap['companies'] as List?;
        print('🏢 [AUTO_SELECT] Companies found: ${companies?.length ?? 0}');
        
        if (companies != null && companies.isNotEmpty) {
          final firstCompany = companies.first;
          final companyId = firstCompany['company_id']?.toString() ?? '';
          final companyName = firstCompany['name']?.toString() ?? 'Unknown';
          
          print('🏢 [AUTO_SELECT] First company: $companyName ($companyId)');
          
          if (companyId.isNotEmpty) {
            await appStateNotifier.setCompanyChoosen(companyId);
            print('✅ [AUTO_SELECT] Company set: $companyId');
            
            if (firstCompany['stores'] != null) {
              final stores = firstCompany['stores'] as List?;
              print('🏬 [AUTO_SELECT] Stores found: ${stores?.length ?? 0}');
              
              if (stores != null && stores.isNotEmpty) {
                final firstStore = stores.first;
                final storeId = firstStore['store_id']?.toString() ?? '';
                final storeName = firstStore['name']?.toString() ?? 'Unknown';
                
                print('🏬 [AUTO_SELECT] First store: $storeName ($storeId)');
                
                if (storeId.isNotEmpty) {
                  await appStateNotifier.setStoreChoosen(storeId);
                  print('✅ [AUTO_SELECT] Store set: $storeId');
                  
                  // Show success message
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Auto-selected: $companyName - $storeName'),
                        backgroundColor: TossColors.success,
                        duration: const Duration(seconds: 3),
                      ),
                    );
                  }
                }
              }
            }
            
            // Refresh the inventory page
            print('🔄 [AUTO_SELECT] Refreshing inventory data...');
            ref.read(inventoryPageProvider.notifier).refresh();
          }
        } else {
          print('⚠️ [AUTO_SELECT] No companies found in user data');
        }
      } else {
        print('⚠️ [AUTO_SELECT] No companies key in user data');
      }
    } else {
      print('❌ [AUTO_SELECT] User data is not a Map');
    }
  }

  Widget _buildSearchFilterSection(InventoryMetadata? metadata) {
    return Column(
      children: [
        // Use helper for Card replacement
        WidgetMigrationHelper.card(
          margin: EdgeInsets.fromLTRB(
            TossSpacing.space4,
            TossSpacing.space3,
            TossSpacing.space4,
            TossSpacing.space2,
          ),
          padding: EdgeInsets.symmetric(
            horizontal: TossSpacing.space3,
            vertical: TossSpacing.space2,
          ),
          pageName: _pageName,
          child: Row(
            children: [
              // Filter Section - 50% space
              Expanded(
                flex: 50,
                child: InkWell(
                  onTap: () {
                    HapticFeedback.lightImpact();
                    final metadata = ref.read(inventoryMetadataProvider).value;
                    _showFilterOptionsSheet(metadata);
                  },
                  borderRadius: BorderRadius.circular(TossBorderRadius.sm),
                  child: Container(
                    padding: EdgeInsets.symmetric(
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
                              color: _hasActiveFilters() ? TossColors.primary : TossColors.gray600,
                            ),
                            if (_hasActiveFilters())
                              Positioned(
                                right: -4,
                                top: -4,
                                child: Container(
                                  width: 16,
                                  height: 16,
                                  decoration: BoxDecoration(
                                    color: TossColors.primary,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Center(
                                    child: Text(
                                      '${_getActiveFilterCount()}',
                                      style: TossTextStyles.caption.copyWith(
                                        color: TossColors.white,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                        SizedBox(width: TossSpacing.space2),
                        Expanded(
                          child: Text(
                            _hasActiveFilters() ? '${_getActiveFilterCount()} filters active' : 'Filters',
                            style: TossTextStyles.labelLarge.copyWith(
                              color: TossColors.gray700,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Icon(
                          Icons.keyboard_arrow_down_rounded,
                          size: 20,
                          color: TossColors.gray500,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              
              Container(
                width: 1,
                height: 20,
                color: TossColors.gray200,
              ),
              
              // Sort Section - 50% space
              Expanded(
                flex: 50,
                child: InkWell(
                  onTap: () {
                    HapticFeedback.lightImpact();
                    _showSortOptionsSheet();
                  },
                  borderRadius: BorderRadius.circular(TossBorderRadius.sm),
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: TossSpacing.space3,
                      vertical: TossSpacing.space2,
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.sort_rounded,
                          size: 22,
                          color: (_sortBy != 'name' || _sortDirection != 'asc') ? TossColors.primary : TossColors.gray600,
                        ),
                        SizedBox(width: TossSpacing.space2),
                        Expanded(
                          child: Text(
                            _getSortLabel(),
                            style: TossTextStyles.labelLarge.copyWith(
                              color: TossColors.gray700,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        // Show sort direction indicator
                        if (_sortBy != 'name' || _sortDirection != 'asc')
                          Icon(
                            _sortDirection == 'asc'
                              ? Icons.arrow_upward_rounded 
                              : Icons.arrow_downward_rounded,
                            size: 16,
                            color: TossColors.primary,
                          ),
                        SizedBox(width: TossSpacing.space1),
                        Icon(
                          Icons.keyboard_arrow_down_rounded,
                          size: 20,
                          color: TossColors.gray500,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        
        // Search Field
        Container(
          margin: EdgeInsets.fromLTRB(
            TossSpacing.space4,
            TossSpacing.space2,
            TossSpacing.space4,
            TossSpacing.space3,
          ),
          child: TossSearchField(
            controller: _searchController,
            focusNode: _searchFocusNode,
            hintText: 'Search products...',
            onChanged: _onSearchChanged,
          ),
        ),
      ],
    );
  }

  // This method is no longer needed - replaced by _buildStableBody and _buildProductResults

  Widget _buildInventoryProductTile(InventoryProduct product, Currency? currency) {
    return TossListTile(
      title: product.name,
      subtitle: product.sku ?? product.barcode ?? '',
      showDivider: false,
      leading: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: TossColors.gray100,
          borderRadius: BorderRadius.circular(TossBorderRadius.md),
        ),
        child: product.imageUrl != null
            ? ClipRRect(
                borderRadius: BorderRadius.circular(TossBorderRadius.md),
                child: Image.network(
                  product.imageUrl!,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                      Icon(Icons.inventory_2, color: TossColors.gray400, size: 24),
                ),
              )
            : Icon(Icons.inventory_2, color: TossColors.gray400, size: 24),
      ),
      trailing: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '${currency?.symbol ?? '₩'}${_formatCurrency(product.price)}',
            style: TossTextStyles.bodyLarge.copyWith(
              fontWeight: FontWeight.w600,
              color: TossColors.gray900,
            ),
          ),
          SizedBox(height: 2),
          Text(
            product.stock.toString(),
            style: TossTextStyles.body.copyWith(
              color: _getInventoryStockColor(product),
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
      onTap: () {
        NavigationHelper.navigateTo(
          context,
          '/inventoryManagement/product/${product.id}',
          extra: {
            'product': product.toProduct(), // Convert to Product with proper product type
            'currency': currency,
          },
        );
      },
    );
  }
  
  Color _getInventoryStockColor(InventoryProduct product) {
    final statusColor = product.getStockStatusColor();
    switch (statusColor) {
      case '#FF0000':
        return TossColors.error;
      case '#FFA500':
        return TossColors.warning;
      case '#0000FF':
        return TossColors.info;
      default:
        return TossColors.success;
    }
  }

  String _getSortLabel() {
    String label = '';
    switch (_sortBy) {
      case 'name':
        label = 'Name';
        break;
      case 'price':
        label = 'Price';
        break;
      case 'stock':
        label = 'Stock';
        break;
      case 'created_at':
        label = 'Date';
        break;
      default:
        label = 'Name';
    }
    
    if (_sortDirection == 'asc') {
      label += _sortBy == 'name' ? ' (A-Z)' : ' (Low to High)';
    } else {
      label += _sortBy == 'name' ? ' (Z-A)' : ' (High to Low)';
    }
    
    return label;
  }

  // Modal sheets remain the same but with helper usage where applicable
  void _showFilterOptionsSheet(InventoryMetadata? metadata) {
    showModalBottomSheet(
      context: context,
      backgroundColor: TossColors.transparent,
      isScrollControlled: true,
      isDismissible: true,
      enableDrag: true,
      builder: (context) => _buildFilterSheet(metadata),
    );
  }

  void _showSortOptionsSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: TossColors.transparent,
      isDismissible: true,
      enableDrag: true,
      builder: (context) => _buildSortSheet(),
    );
  }

  Widget _buildFilterSheet(InventoryMetadata? metadata) {
    return StatefulBuilder(
      builder: (context, setModalState) {
        return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.8,
      ),
      decoration: BoxDecoration(
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
            margin: EdgeInsets.only(top: TossSpacing.space3),
            decoration: BoxDecoration(
              color: TossColors.gray300,
              borderRadius: BorderRadius.circular(TossBorderRadius.xs),
            ),
          ),
          
          // Title
          Container(
            padding: EdgeInsets.all(TossSpacing.space4),
            child: Row(
              children: [
                Text(
                  'Filter Products',
                  style: TossTextStyles.h3.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Spacer(),
                TextButton(
                  onPressed: () {
                    setModalState(() {
                      _selectedCategory = null;
                      _selectedBrand = null;
                      _selectedStockStatus = null;
                    });
                    ref.read(inventoryPageProvider.notifier).clearFilters();
                  },
                  child: Text('Clear All'),
                ),
              ],
            ),
          ),
          
          Expanded(
            child: ListView(
              padding: EdgeInsets.symmetric(horizontal: TossSpacing.space4),
              children: [
                // Category Filter
                if (metadata?.categories != null && metadata!.categories.isNotEmpty)
                  _buildFilterSection(
                    'Category',
                    metadata.categories.map((c) => {'id': c.id, 'name': c.name}).toList(),
                    _selectedCategory,
                    (value) {
                      setModalState(() {
                        _selectedCategory = value;
                      });
                      _applyFilter('category', value);
                    },
                  ),
                
                // Brand Filter
                if (metadata?.brands != null && metadata!.brands.isNotEmpty)
                  _buildFilterSection(
                    'Brand',
                    metadata.brands.map((b) => {'id': b.id, 'name': b.name}).toList(),
                    _selectedBrand,
                    (value) {
                      setModalState(() {
                        _selectedBrand = value;
                      });
                      _applyFilter('brand', value);
                    },
                  ),
                
                // Stock Status Filter
                if (metadata?.stockStatusLevels != null && metadata!.stockStatusLevels.isNotEmpty)
                  _buildFilterSection(
                    'Stock Status',
                    metadata.stockStatusLevels.map((s) => {'id': s.level, 'name': s.label}).toList(),
                    _selectedStockStatus,
                    (value) {
                      setModalState(() {
                        _selectedStockStatus = value;
                      });
                      _applyFilter('stockStatus', value);
                    },
                  ),
                
                SizedBox(height: TossSpacing.space4),
              ],
            ),
          ),
          
          // Apply Button
          Container(
            padding: EdgeInsets.all(TossSpacing.space4),
            child: ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: TossColors.primary,
                minimumSize: Size(double.infinity, 48),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(TossBorderRadius.md),
                ),
              ),
              child: Text(
                'Apply Filters',
                style: TossTextStyles.bodyLarge.copyWith(
                  color: TossColors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
      },
    );
  }

  Widget _buildFilterSection(
    String title,
    List<Map<String, String>> options,
    String? selectedValue,
    ValueChanged<String?> onChanged,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(vertical: TossSpacing.space3),
          child: Text(
            title,
            style: TossTextStyles.labelLarge.copyWith(
              fontWeight: FontWeight.w600,
              color: TossColors.gray900,
            ),
          ),
        ),
        Wrap(
          spacing: TossSpacing.space2,
          runSpacing: TossSpacing.space2,
          children: [
            _buildFilterChip(
              'All',
              null,
              selectedValue,
              onChanged,
            ),
            ...options.map((option) => _buildFilterChip(
              option['name']!,
              option['id'],
              selectedValue,
              onChanged,
            )),
          ],
        ),
      ],
    );
  }

  Widget _buildFilterChip(
    String label,
    String? value,
    String? selectedValue,
    ValueChanged<String?> onChanged,
  ) {
    final isSelected = value == selectedValue;
    return InkWell(
      onTap: () {
        onChanged(value);
      },
      borderRadius: BorderRadius.circular(TossBorderRadius.full),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: TossSpacing.space3,
          vertical: TossSpacing.space2,
        ),
        decoration: BoxDecoration(
          color: isSelected ? TossColors.primary : TossColors.white,
          borderRadius: BorderRadius.circular(TossBorderRadius.full),
          border: Border.all(
            color: isSelected ? TossColors.primary : TossColors.gray300,
          ),
        ),
        child: Text(
          label,
          style: TossTextStyles.body.copyWith(
            color: isSelected ? TossColors.white : TossColors.gray700,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Widget _buildSortSheet() {
    return StatefulBuilder(
      builder: (context, setModalState) {
        return Container(
          decoration: BoxDecoration(
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
                margin: EdgeInsets.only(top: TossSpacing.space3),
                decoration: BoxDecoration(
                  color: TossColors.gray300,
                  borderRadius: BorderRadius.circular(TossBorderRadius.xs),
                ),
              ),
              
              // Title
              Container(
                padding: EdgeInsets.all(TossSpacing.space4),
                child: Row(
                  children: [
                    Text(
                      'Sort Products',
                      style: TossTextStyles.h3.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
              
              // Sort Options
              ListView(
                shrinkWrap: true,
                padding: EdgeInsets.symmetric(horizontal: TossSpacing.space4),
                children: [
                  _buildSortOption('Name', 'name', setModalState),
                  _buildSortOption('Price', 'price', setModalState),
                  _buildSortOption('Stock', 'stock', setModalState),
                  _buildSortOption('Date Added', 'created_at', setModalState),
                ],
              ),
              
              SizedBox(height: TossSpacing.space4),
            ],
          ),
        );
      },
    );
  }
  
  Widget _buildSortOption(String label, String sortBy, StateSetter setModalState) {
    final isSelected = _sortBy == sortBy;
    return ListTile(
      title: Text(
        label,
        style: TossTextStyles.body.copyWith(
          color: isSelected ? TossColors.primary : TossColors.gray700,
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
        ),
      ),
      trailing: isSelected
          ? Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(
                    Icons.arrow_upward,
                    color: _sortDirection == 'asc' ? TossColors.primary : TossColors.gray400,
                  ),
                  onPressed: () {
                    setModalState(() {
                      _sortDirection = 'asc';
                    });
                    _applySorting(sortBy, 'asc');
                  },
                ),
                IconButton(
                  icon: Icon(
                    Icons.arrow_downward,
                    color: _sortDirection == 'desc' ? TossColors.primary : TossColors.gray400,
                  ),
                  onPressed: () {
                    setModalState(() {
                      _sortDirection = 'desc';
                    });
                    _applySorting(sortBy, 'desc');
                  },
                ),
              ],
            )
          : null,
      onTap: () {
        setModalState(() {
          _sortBy = sortBy;
        });
        _applySorting(sortBy, _sortDirection);
        Navigator.pop(context);
      },
    );
  }

  String _formatCurrency(double value) {
    return value.toStringAsFixed(0).replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]},',
    );
  }

}