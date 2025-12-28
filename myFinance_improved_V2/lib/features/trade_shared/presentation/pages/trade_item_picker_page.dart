import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../shared/themes/toss_border_radius.dart';
import '../../../../shared/themes/toss_colors.dart';
import '../../../../shared/themes/toss_spacing.dart';
import '../../../../shared/themes/toss_text_styles.dart';
import '../../../sale_product/domain/entities/sales_product.dart';
import '../../../sale_product/presentation/providers/filtered_products_provider.dart';
import '../../../sale_product/presentation/providers/inventory_metadata_provider.dart';
import '../../../sale_product/presentation/providers/sales_product_provider.dart';
import '../../../sale_product/presentation/providers/states/sales_product_state.dart';
import '../../domain/entities/trade_item.dart';
import '../widgets/item_picker/trade_item_summary_bar.dart';
import '../widgets/item_picker/trade_item_tile.dart';

/// A reusable page for selecting products and returning them as TradeItems.
/// Used by PI, PO, CI forms to select items from inventory.
class TradeItemPickerPage extends ConsumerStatefulWidget {
  final String title;
  final String currencySymbol;
  final String confirmButtonText;
  final List<TradeItem>? initialItems; // Pre-selected items (for edit mode)

  const TradeItemPickerPage({
    super.key,
    this.title = 'Select Items',
    this.currencySymbol = '\$',
    this.confirmButtonText = 'Confirm Selection',
    this.initialItems,
  });

  /// Show picker and return selected items
  static Future<List<TradeItem>?> show(
    BuildContext context, {
    String title = 'Select Items',
    String currencySymbol = '\$',
    String confirmButtonText = 'Confirm Selection',
    List<TradeItem>? initialItems,
  }) async {
    return Navigator.of(context).push<List<TradeItem>>(
      MaterialPageRoute(
        builder: (context) => TradeItemPickerPage(
          title: title,
          currencySymbol: currencySymbol,
          confirmButtonText: confirmButtonText,
          initialItems: initialItems,
        ),
      ),
    );
  }

  @override
  ConsumerState<TradeItemPickerPage> createState() => _TradeItemPickerPageState();
}

class _TradeItemPickerPageState extends ConsumerState<TradeItemPickerPage> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final Map<String, TradeItem> _selectedItems = {};
  String? _selectedBrand;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);

    // Initialize with pre-selected items
    if (widget.initialItems != null) {
      for (final item in widget.initialItems!) {
        if (item.productId != null) {
          _selectedItems[item.productId!] = item;
        }
      }
    }

    // Load products
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadProducts();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _loadProducts() {
    ref.read(salesProductProvider.notifier).loadProducts();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200) {
      final state = ref.read(salesProductProvider);
      if (state.canLoadMore) {
        ref.read(salesProductProvider.notifier).loadNextPage();
      }
    }
  }

  void _onSearch(String query) {
    ref.read(salesProductProvider.notifier).loadProducts(search: query);
  }

  void _addItem(SalesProduct product) {
    setState(() {
      if (_selectedItems.containsKey(product.productId)) {
        // Already selected - increase quantity
        final existing = _selectedItems[product.productId]!;
        _selectedItems[product.productId] = existing.copyWith(
          quantity: existing.quantity + 1,
        );
      } else {
        // New selection
        _selectedItems[product.productId] = TradeItem.fromSalesProduct(
          productId: product.productId,
          productName: product.productName,
          sku: product.sku,
          barcode: product.barcode.isNotEmpty ? product.barcode : null,
          imageUrl: product.images.mainImage,
          sellingPrice: product.pricing.sellingPrice,
          stockQuantity: product.totalStockSummary.totalQuantityOnHand,
          unit: product.unit,
        );
      }
    });
  }

  void _updateQuantity(String productId, double quantity) {
    setState(() {
      if (_selectedItems.containsKey(productId)) {
        _selectedItems[productId] = _selectedItems[productId]!.copyWith(quantity: quantity);
      }
    });
  }

  void _removeItem(String productId) {
    setState(() {
      _selectedItems.remove(productId);
    });
  }

  void _confirmSelection() {
    final items = _selectedItems.values.toList();
    // Sort by the order they were added (using sortOrder)
    for (int i = 0; i < items.length; i++) {
      items[i] = items[i].copyWith(sortOrder: i);
    }
    Navigator.of(context).pop(items);
  }

  @override
  Widget build(BuildContext context) {
    final productState = ref.watch(salesProductProvider);
    final filteredProducts = ref.watch(filteredProductsProvider);
    final brandNames = ref.watch(inventoryMetadataProvider).brandNames;

    // Filter by brand
    final displayProducts = _selectedBrand == null || _selectedBrand!.isEmpty
        ? filteredProducts
        : filteredProducts.where((p) => p.brand == _selectedBrand).toList();

    return PopScope(
      canPop: _selectedItems.isEmpty,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop && _selectedItems.isNotEmpty) {
          _showExitConfirmation();
        }
      },
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Scaffold(
        backgroundColor: TossColors.white,
        appBar: AppBar(
          backgroundColor: TossColors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.close, color: TossColors.textPrimary),
            onPressed: () {
              if (_selectedItems.isEmpty) {
                Navigator.of(context).pop();
              } else {
                _showExitConfirmation();
              }
            },
          ),
          title: Text(
            widget.title,
            style: TossTextStyles.titleLarge.copyWith(
              fontWeight: FontWeight.w600,
              color: TossColors.textPrimary,
            ),
          ),
          centerTitle: true,
        ),
        body: Column(
          children: [
            // Search and filters
            _buildSearchAndFilters(brandNames),
            const Divider(height: 1, color: TossColors.gray100),
            // Product list
            Expanded(
              child: _buildProductList(productState, displayProducts),
            ),
            // Summary bar
            TradeItemSummaryBar(
              items: _selectedItems.values.toList(),
              currencySymbol: widget.currencySymbol,
              confirmButtonText: widget.confirmButtonText,
              onConfirm: _confirmSelection,
            ),
          ],
        ),
      ),
      ),
    );
  }

  Widget _buildSearchAndFilters(List<String> brandNames) {
    return Container(
      padding: const EdgeInsets.all(TossSpacing.space4),
      child: Column(
        children: [
          // Search field
          TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Search products...',
              hintStyle: TossTextStyles.bodyMedium.copyWith(color: TossColors.textSecondary),
              prefixIcon: const Icon(Icons.search, color: TossColors.gray400),
              suffixIcon: _searchController.text.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear, color: TossColors.gray400),
                      onPressed: () {
                        _searchController.clear();
                        _onSearch('');
                      },
                    )
                  : null,
              filled: true,
              fillColor: TossColors.gray50,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(TossBorderRadius.md),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: TossSpacing.space4,
                vertical: TossSpacing.space3,
              ),
            ),
            onChanged: (value) {
              setState(() {}); // Update suffix icon visibility
              // Debounce search
              Future.delayed(const Duration(milliseconds: 300), () {
                if (_searchController.text == value) {
                  _onSearch(value);
                }
              });
            },
          ),
          // Brand chips
          if (brandNames.isNotEmpty) ...[
            const SizedBox(height: TossSpacing.space3),
            SizedBox(
              height: 36,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: brandNames.length + 1, // +1 for "All"
                separatorBuilder: (_, __) => const SizedBox(width: TossSpacing.space2),
                itemBuilder: (context, index) {
                  if (index == 0) {
                    return _buildBrandChip('All', null);
                  }
                  final brand = brandNames[index - 1];
                  return _buildBrandChip(brand, brand);
                },
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildBrandChip(String label, String? value) {
    final isSelected = _selectedBrand == value;

    return GestureDetector(
      onTap: () {
        setState(() => _selectedBrand = value);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: TossSpacing.space4,
          vertical: TossSpacing.space2,
        ),
        decoration: BoxDecoration(
          color: isSelected ? TossColors.primary : TossColors.gray50,
          borderRadius: BorderRadius.circular(TossBorderRadius.full),
        ),
        child: Text(
          label,
          style: TossTextStyles.bodySmall.copyWith(
            fontWeight: FontWeight.w500,
            color: isSelected ? TossColors.white : TossColors.textSecondary,
          ),
        ),
      ),
    );
  }

  Widget _buildProductList(SalesProductState state, List<SalesProduct> products) {
    if (state.isLoading && products.isEmpty) {
      return const Center(
        child: CircularProgressIndicator(color: TossColors.primary),
      );
    }

    if (state.errorMessage != null && products.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 48, color: TossColors.gray400),
            const SizedBox(height: TossSpacing.space4),
            Text(
              'Failed to load products',
              style: TossTextStyles.bodyMedium.copyWith(color: TossColors.textSecondary),
            ),
            const SizedBox(height: TossSpacing.space4),
            TextButton(
              onPressed: _loadProducts,
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (products.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.inventory_2_outlined, size: 48, color: TossColors.gray400),
            const SizedBox(height: TossSpacing.space4),
            Text(
              'No products found',
              style: TossTextStyles.bodyMedium.copyWith(color: TossColors.textSecondary),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      controller: _scrollController,
      padding: EdgeInsets.only(
        left: TossSpacing.space4,
        right: TossSpacing.space4,
        top: TossSpacing.space2,
        bottom: _selectedItems.isNotEmpty ? 180 : 60,
      ),
      itemCount: products.length + (state.isLoadingMore ? 1 : 0),
      itemBuilder: (context, index) {
        if (index == products.length) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(TossSpacing.space4),
              child: CircularProgressIndicator(color: TossColors.primary),
            ),
          );
        }

        final product = products[index];
        final selectedItem = _selectedItems[product.productId];
        final displayItem = selectedItem ??
            TradeItem.fromSalesProduct(
              productId: product.productId,
              productName: product.productName,
              sku: product.sku,
              barcode: product.barcode.isNotEmpty ? product.barcode : null,
              imageUrl: product.images.mainImage,
              sellingPrice: product.pricing.sellingPrice,
              stockQuantity: product.totalStockSummary.totalQuantityOnHand,
              unit: product.unit,
            ).copyWith(quantity: 0);

        return TradeItemTile(
          item: displayItem,
          currencySymbol: widget.currencySymbol,
          onTap: () => _addItem(product),
          onQuantityChanged: (qty) => _updateQuantity(product.productId, qty),
          onRemove: () => _removeItem(product.productId),
        );
      },
    );
  }

  void _showExitConfirmation() {
    showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Discard Selection?'),
        content: Text('You have ${_selectedItems.length} item(s) selected. Discard and exit?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(dialogContext).pop(); // Close dialog
              Navigator.of(context).pop(); // Close picker
            },
            child: const Text('Discard'),
          ),
        ],
      ),
    );
  }
}
