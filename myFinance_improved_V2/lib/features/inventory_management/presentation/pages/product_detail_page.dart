import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/providers/app_state_provider.dart';
import '../../../../app/providers/app_state.dart';
import '../../di/inventory_providers.dart';
import '../../../../shared/themes/toss_colors.dart';
import '../../../../shared/themes/toss_text_styles.dart';
import '../../../../shared/themes/toss_spacing.dart';
import '../../../../shared/themes/toss_border_radius.dart';
import '../../../../shared/widgets/common/toss_scaffold.dart';
import '../../../../shared/widgets/common/toss_success_error_dialog.dart';
import '../../../../shared/widgets/common/gray_divider_space.dart';
import '../../../../shared/widgets/toss/toss_icon_button.dart';
import '../../domain/entities/product.dart';
import '../../domain/repositories/inventory_repository.dart';
import '../providers/inventory_providers.dart';
import '../widgets/move_stock_dialog.dart';
import 'product_transactions_page.dart';

/// Product Detail Page - New design with compact header and location list
class ProductDetailPage extends ConsumerStatefulWidget {
  final String productId;

  const ProductDetailPage({
    super.key,
    required this.productId,
  });

  @override
  ConsumerState<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends ConsumerState<ProductDetailPage> {
  bool _hasStockFilter = true;
  List<StoreStock>? _storeStocks;
  bool _isLoadingStocks = true;

  @override
  void initState() {
    super.initState();
    _loadStoreStocks();
  }

  Future<void> _loadStoreStocks() async {
    final appState = ref.read(appStateProvider);
    final companyId = appState.companyChoosen;

    if (companyId.isEmpty) {
      setState(() {
        _isLoadingStocks = false;
      });
      return;
    }

    try {
      final repository = ref.read(inventoryRepositoryProvider);
      final result = await repository.getProductStockByStores(
        companyId: companyId,
        productIds: [widget.productId],
      );

      if (mounted) {
        if (result != null && result.products.isNotEmpty) {
          setState(() {
            _storeStocks = result.products.first.stores;
            _isLoadingStocks = false;
          });
        } else {
          setState(() {
            _storeStocks = [];
            _isLoadingStocks = false;
          });
        }
      }
    } catch (e) {
      // ignore: avoid_print
      print('[ProductDetailPage] Error loading store stocks: $e');
      if (mounted) {
        setState(() {
          _isLoadingStocks = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // ignore: avoid_print
    print('🔴 [ProductDetailPage] build called - productId: ${widget.productId}');
    final productsState = ref.watch(inventoryPageProvider);
    final currencySymbol = productsState.currency?.symbol ?? '';

    // Find product in the list (return null if not found during refresh)
    final product = productsState.products.cast<Product?>().firstWhere(
      (p) => p?.id == widget.productId,
      orElse: () => null,
    );

    // Show loading state if product not found (during refresh)
    if (product == null) {
      return const TossScaffold(
        backgroundColor: TossColors.white,
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return TossScaffold(
      backgroundColor: TossColors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Top bar
            _buildTopBar(context, ref, product),
            // Content
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // Product header
                    _buildProductHeader(context, product),
                    // Hero stats
                    _buildHeroStats(product, currencySymbol),
                    // Section divider
                    _buildSectionDivider(),
                    // Locations section
                    _buildLocationsSection(product),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopBar(BuildContext context, WidgetRef ref, Product product) {
    return Container(
      height: 56,
      padding: const EdgeInsets.symmetric(horizontal: TossSpacing.space4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Left side - back button and SKU
          Row(
            children: [
              GestureDetector(
                onTap: () => Navigator.of(context).maybePop(),
                child: Container(
                  width: 32,
                  height: 32,
                  alignment: Alignment.center,
                  child: const Icon(
                    Icons.arrow_back,
                    size: 22,
                    color: TossColors.gray900,
                  ),
                ),
              ),
              const SizedBox(width: TossSpacing.space2),
              Text(
                product.sku,
                style: TossTextStyles.titleLarge.copyWith(
                  color: TossColors.gray900,
                ),
              ),
            ],
          ),
          // Right side - edit, history, and more buttons
          Row(
            children: [
              TossIconButton.edit(
                size: 26,
                padding: const EdgeInsets.all(12),
                onPressed: () {
                  context.push('/inventoryManagement/editProduct/${widget.productId}');
                },
              ),
              // Transaction history button
              GestureDetector(
                onTap: () {
                  Navigator.of(context).push<void>(
                    MaterialPageRoute<void>(
                      builder: (context) => ProductTransactionsPage(product: product),
                    ),
                  );
                },
                child: Container(
                  width: 44,
                  height: 44,
                  alignment: Alignment.center,
                  child: const Icon(
                    Icons.history,
                    size: 26,
                    color: TossColors.gray900,
                  ),
                ),
              ),
              TossIconButton.more(
                onPressed: () => _showMoreOptions(context, ref, product),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProductHeader(BuildContext context, Product product) {
    return Container(
      padding: const EdgeInsets.fromLTRB(
        TossSpacing.space4,
        TossSpacing.space6,
        TossSpacing.space4,
        TossSpacing.space5,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Product image
          _buildProductImage(product),
          const SizedBox(width: TossSpacing.space4),
          // Product info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // SKU with copy button
                Row(
                  children: [
                    Text(
                      product.sku,
                      style: TossTextStyles.body.copyWith(
                        fontWeight: FontWeight.w500,
                        color: TossColors.gray600,
                      ),
                    ),
                    const SizedBox(width: 6),
                    GestureDetector(
                      onTap: () {
                        Clipboard.setData(ClipboardData(text: product.sku));
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('SKU copied to clipboard'),
                            duration: Duration(seconds: 1),
                          ),
                        );
                      },
                      child: Icon(
                        Icons.copy_outlined,
                        size: 18,
                        color: TossColors.gray500,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                // Product name
                Text(
                  product.name,
                  style: TossTextStyles.bodyMedium.copyWith(
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                    color: TossColors.gray900,
                  ),
                ),
                const SizedBox(height: TossSpacing.space4),
                // Quantity badge
                Row(
                  children: [
                    Container(
                      height: 32,
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        color: TossColors.primary,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        '${product.onHand}',
                        style: TossTextStyles.bodyMedium.copyWith(
                          fontWeight: FontWeight.w600,
                          color: TossColors.white,
                        ),
                      ),
                    ),
                    const SizedBox(width: TossSpacing.space2),
                    Text(
                      'On-hand qty',
                      style: TossTextStyles.caption.copyWith(
                        color: TossColors.gray600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductImage(Product product) {
    if (product.images.isEmpty) {
      return Container(
        width: 128,
        height: 128,
        decoration: BoxDecoration(
          color: TossColors.gray100,
          borderRadius: BorderRadius.circular(TossBorderRadius.xxxl),
        ),
        child: Icon(
          Icons.camera_alt_outlined,
          size: 26,
          color: TossColors.gray500,
        ),
      );
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(TossBorderRadius.xxxl),
      child: Image.network(
        product.images.first,
        width: 128,
        height: 128,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => Container(
          width: 128,
          height: 128,
          decoration: BoxDecoration(
            color: TossColors.gray100,
            borderRadius: BorderRadius.circular(TossBorderRadius.xxxl),
          ),
          child: Icon(
            Icons.camera_alt_outlined,
            size: 26,
            color: TossColors.gray500,
          ),
        ),
      ),
    );
  }

  Widget _buildHeroStats(Product product, String currencySymbol) {
    return Container(
      margin: const EdgeInsets.only(top: TossSpacing.space2, bottom: TossSpacing.space4),
      padding: const EdgeInsets.symmetric(horizontal: TossSpacing.space4, vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Attributes column
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Attributes',
                  style: TossTextStyles.labelSmall.copyWith(
                    fontWeight: FontWeight.w500,
                    color: TossColors.gray600,
                  ),
                ),
                const SizedBox(height: 2),
                if (product.brandName != null)
                  Text(
                    '· ${product.brandName}',
                    style: TossTextStyles.body.copyWith(
                      fontWeight: FontWeight.w500,
                      color: TossColors.gray900,
                      height: 1.2,
                    ),
                  ),
                const SizedBox(height: 2),
                Text(
                  '· ${product.categoryName ?? 'Uncategorized'}',
                  style: TossTextStyles.body.copyWith(
                    fontWeight: FontWeight.w500,
                    color: TossColors.gray900,
                    height: 1.2,
                  ),
                ),
              ],
            ),
          ),
          // Divider
          const GrayVerticalDivider(height: 50, horizontalMargin: 12),
          // Cost column
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Cost',
                  style: TossTextStyles.labelSmall.copyWith(
                    fontWeight: FontWeight.w500,
                    color: TossColors.gray600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '$currencySymbol${_formatCurrency(product.costPrice)}',
                  style: TossTextStyles.body.copyWith(
                    fontWeight: FontWeight.w500,
                    color: TossColors.gray900,
                    height: 1.2,
                  ),
                ),
              ],
            ),
          ),
          // Divider
          Container(
            width: 1,
            height: 50,
            color: TossColors.gray200,
            margin: const EdgeInsets.only(left: 12, right: 8),
          ),
          // Price column
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Price',
                  style: TossTextStyles.labelSmall.copyWith(
                    fontWeight: FontWeight.w500,
                    color: TossColors.gray600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '$currencySymbol${_formatCurrency(product.salePrice)}',
                  style: TossTextStyles.body.copyWith(
                    fontWeight: FontWeight.w500,
                    color: TossColors.primary,
                    height: 1.2,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionDivider() {
    return Container(
      height: 15,
      color: TossColors.gray100,
    );
  }

  Widget _buildLocationsSection(Product product) {
    final appState = ref.watch(appStateProvider);
    final currentStoreId = appState.storeChoosen;

    // Use RPC data if available, otherwise fallback to AppState
    final stores = _buildStoreLocations(appState, product, currentStoreId);

    // Find current store for Move Stock dialog
    final currentStore = stores.firstWhere(
      (s) => s.isCurrentStore,
      orElse: () => stores.first,
    );

    // Filter stores based on toggle
    final filteredStores = _hasStockFilter
        ? stores.where((s) => s.stock > 0).toList()
        : stores;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: TossSpacing.space4),
          child: Column(
            children: [
              // Section header - "Move Stock" with toggle
              Padding(
                padding: const EdgeInsets.only(
                  top: TossSpacing.space6,
                  bottom: TossSpacing.space3,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Move Stock',
                      style: TossTextStyles.titleLarge.copyWith(
                        color: TossColors.gray900,
                      ),
                    ),
                    // Has stock toggle
                    Row(
                      children: [
                        Text(
                          'Has stock',
                          style: TossTextStyles.bodySmall.copyWith(
                            fontWeight: FontWeight.w500,
                            color: TossColors.gray600,
                          ),
                        ),
                        const SizedBox(width: TossSpacing.space2),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              _hasStockFilter = !_hasStockFilter;
                            });
                          },
                          child: _buildToggle(_hasStockFilter),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // Loading indicator or store rows
              if (_isLoadingStocks)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: TossSpacing.space4),
                  child: Center(
                    child: SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  ),
                )
              else
                ...filteredStores.map((store) => _buildStoreRow(store, product, stores)),
            ],
          ),
        ),
        const SizedBox(height: TossSpacing.space4),
      ],
    );
  }

  /// Build store locations from RPC data or fallback to AppState
  List<StoreLocation> _buildStoreLocations(AppState appState, Product product, String currentStoreId) {
    // If we have RPC data, use it
    if (_storeStocks != null && _storeStocks!.isNotEmpty) {
      return _storeStocks!.map((stock) {
        return StoreLocation(
          id: stock.storeId,
          name: stock.storeName,
          stock: stock.quantityOnHand,
          isCurrentStore: stock.storeId == currentStoreId,
        );
      }).toList();
    }

    // Fallback to AppState-based method
    return _getCompanyStores(appState, product);
  }

  Widget _buildToggle(bool isOn) {
    return Container(
      width: 34,
      height: 20,
      decoration: BoxDecoration(
        color: isOn ? TossColors.primary : TossColors.gray200,
        borderRadius: BorderRadius.circular(28),
      ),
      padding: const EdgeInsets.all(2),
      alignment: isOn ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        width: 14,
        height: 14,
        decoration: const BoxDecoration(
          color: TossColors.white,
          shape: BoxShape.circle,
        ),
      ),
    );
  }

  Widget _buildStoreRow(StoreLocation store, Product product, List<StoreLocation> allStores) {
    return GestureDetector(
      onTap: () => _showMoveStockDialog(context, product, store, allStores),
      behavior: HitTestBehavior.opaque,
      child: Container(
        constraints: const BoxConstraints(minHeight: 48),
        padding: const EdgeInsets.symmetric(vertical: TossSpacing.space2),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Left side - store icon and name
            Expanded(
              child: Row(
                children: [
                  const Icon(
                    Icons.store_outlined,
                    size: 18,
                    color: TossColors.gray900,
                  ),
                  const SizedBox(width: TossSpacing.space2),
                  // Store name with "This store" badge
                  Flexible(
                    child: RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: store.name,
                            style: TossTextStyles.body.copyWith(
                              fontWeight: FontWeight.w500,
                              color: TossColors.gray900,
                            ),
                          ),
                          if (store.isCurrentStore)
                            TextSpan(
                              text: ' · This store',
                              style: TossTextStyles.bodySmall.copyWith(
                                fontWeight: FontWeight.w400,
                                color: TossColors.gray600,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Right side - stock badge and chevron
            Row(
              children: [
                Container(
                  height: 28,
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                    color: store.stock > 0
                        ? TossColors.primarySurface
                        : TossColors.gray100,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    '${store.stock}',
                    style: TossTextStyles.body.copyWith(
                      fontWeight: FontWeight.w600,
                      color: store.stock > 0
                          ? TossColors.primary
                          : TossColors.gray400,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                const Icon(
                  Icons.chevron_right,
                  size: 18,
                  color: TossColors.gray500,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// Get all stores for the current company from AppState
  List<StoreLocation> _getCompanyStores(AppState appState, Product product) {
    final currentCompanyId = appState.companyChoosen;
    final currentStoreId = appState.storeChoosen;
    final companies = appState.user['companies'] as List<dynamic>? ?? [];

    // Find current company using safe lookup
    Map<String, dynamic>? company;
    for (final c in companies) {
      if (c is Map<String, dynamic> && c['company_id'] == currentCompanyId) {
        company = c;
        break;
      }
    }

    if (company == null) {
      // Fallback: return single location with product's on-hand quantity
      return [
        StoreLocation(
          id: currentStoreId,
          name: appState.storeName.isNotEmpty ? appState.storeName : 'Main Store',
          stock: product.onHand,
          isCurrentStore: true,
        ),
      ];
    }

    final storesList = company['stores'] as List<dynamic>? ?? [];

    if (storesList.isEmpty) {
      // No stores found, return single location
      return [
        StoreLocation(
          id: currentStoreId,
          name: appState.storeName.isNotEmpty ? appState.storeName : 'Main Store',
          stock: product.onHand,
          isCurrentStore: true,
        ),
      ];
    }

    // Convert stores to StoreLocation
    // Note: Currently we don't have per-store stock data from API,
    // so we show total on-hand for current store and 0 for others
    // This should be updated when multi-location inventory is implemented
    return storesList.map((store) {
      final storeMap = store as Map<String, dynamic>;
      final storeId = storeMap['store_id'] as String? ?? '';
      final storeName = storeMap['store_name'] as String? ?? 'Unknown Store';
      final isCurrentStore = storeId == currentStoreId;

      return StoreLocation(
        id: storeId,
        name: storeName,
        // For now, show on-hand qty for current store, 0 for others
        // TODO: Replace with actual per-store stock when API supports it
        stock: isCurrentStore ? product.onHand : 0,
        isCurrentStore: isCurrentStore,
      );
    }).toList();
  }

  void _showMoveStockDialog(
    BuildContext context,
    Product product,
    StoreLocation fromLocation,
    List<StoreLocation> allStores,
  ) {
    MoveStockDialog.show(
      context: context,
      productName: product.name,
      productId: product.id,
      fromLocation: fromLocation,
      allStores: allStores,
      onSubmit: (fromStore, toStore, quantity) async {
        // Close dialog first
        Navigator.pop(context);

        // Call move stock RPC
        await _executeMoveStock(
          context: context,
          product: product,
          fromStore: fromStore,
          toStore: toStore,
          quantity: quantity,
        );
      },
    );
  }

  Future<void> _executeMoveStock({
    required BuildContext context,
    required Product product,
    required StoreLocation fromStore,
    required StoreLocation toStore,
    required int quantity,
  }) async {
    try {
      final appState = ref.read(appStateProvider);
      final repository = ref.read(inventoryRepositoryProvider);

      final result = await repository.moveProduct(
        companyId: appState.companyChoosen,
        fromStoreId: fromStore.id,
        toStoreId: toStore.id,
        productId: product.id,
        quantity: quantity,
        updatedBy: appState.userId,
        notes: 'Transfer from ${fromStore.name} to ${toStore.name}',
      );

      if (result != null && mounted) {
        // Show success message first
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Moved $quantity units from ${fromStore.name} to ${toStore.name}'),
              backgroundColor: TossColors.primary,
              duration: const Duration(seconds: 2),
            ),
          );
        }

        // Refresh store stocks
        await _loadStoreStocks();

        // Refresh inventory list (use refresh instead of invalidate to avoid losing current product)
        ref.read(inventoryPageProvider.notifier).refresh();
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Move failed: ${e.toString()}'),
            backgroundColor: TossColors.error,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }
  }

  String _formatCurrency(double value) {
    return value.toStringAsFixed(0).replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]},',
    );
  }

  void _showMoreOptions(BuildContext context, WidgetRef ref, Product product) {
    showModalBottomSheet(
      context: context,
      backgroundColor: TossColors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(TossBorderRadius.bottomSheet)),
      ),
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: TossSpacing.space2),
            Container(
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: TossColors.gray300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: TossSpacing.space4),
            ListTile(
              leading: const Icon(Icons.delete_outline, color: TossColors.error),
              title: Text(
                'Delete Product',
                style: TossTextStyles.body.copyWith(color: TossColors.error),
              ),
              onTap: () {
                Navigator.pop(context);
                _showDeleteConfirmation(product);
              },
            ),
            const SizedBox(height: TossSpacing.space2),
          ],
        ),
      ),
    );
  }

  Future<void> _showDeleteConfirmation(Product product) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Product'),
        content: Text(
          'Are you sure you want to delete "${product.name}"?\n\nThis action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: TextButton.styleFrom(
              foregroundColor: TossColors.error,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed != true || !mounted) return;

    try {
      // Get company ID
      final appState = ref.read(appStateProvider);
      final companyId = appState.companyChoosen as String?;

      if (companyId == null) {
        if (!mounted) return;
        await showDialog<void>(
          context: context,
          builder: (ctx) => TossDialog.error(
            title: 'Company Not Selected',
            message: 'Please select a company to delete products.',
            primaryButtonText: 'OK',
          ),
        );
        return;
      }

      // Show loading indicator
      if (!mounted) return;
      showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (ctx) => const Center(
          child: CircularProgressIndicator(),
        ),
      );

      // Delete product
      final repository = ref.read(inventoryRepositoryProvider);
      final success = await repository.deleteProducts(
        productIds: [product.id],
        companyId: companyId,
      );

      // Close loading indicator
      if (!mounted) return;
      Navigator.of(context).pop();

      if (success) {
        // Refresh inventory list
        ref.read(inventoryPageProvider.notifier).refresh();

        if (!mounted) return;
        // Navigate back to inventory list first
        context.pop();

        // Show success dialog
        if (!mounted) return;
        await showDialog<void>(
          context: context,
          barrierDismissible: false,
          builder: (ctx) => TossDialog.success(
            title: 'Product Deleted',
            message: '${product.name} has been successfully deleted.',
            primaryButtonText: 'OK',
            onPrimaryPressed: () => Navigator.pop(ctx),
          ),
        );
      } else {
        if (!mounted) return;
        await showDialog<void>(
          context: context,
          builder: (ctx) => TossDialog.error(
            title: 'Delete Failed',
            message: 'Failed to delete product. Please try again.',
            primaryButtonText: 'OK',
          ),
        );
      }
    } catch (e) {
      // Close loading indicator if still showing
      if (mounted && Navigator.canPop(context)) {
        Navigator.of(context).pop();
      }

      if (!mounted) return;
      await showDialog<void>(
        context: context,
        builder: (ctx) => TossDialog.error(
          title: 'Error',
          message: e.toString().replaceAll('Exception:', '').trim(),
          primaryButtonText: 'OK',
        ),
      );
    }
  }
}
