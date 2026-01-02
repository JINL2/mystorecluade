import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/providers/app_state_provider.dart';
import '../../../../app/providers/app_state.dart';
import '../../di/inventory_providers.dart';
import '../../../../shared/themes/toss_colors.dart';
import '../../../../shared/themes/toss_text_styles.dart';
import '../../../../shared/themes/toss_spacing.dart';
import '../../../../shared/themes/toss_border_radius.dart';
import '../../domain/entities/product.dart';
import '../../domain/repositories/inventory_repository.dart';
import '../providers/inventory_providers.dart';
import '../widgets/move_stock_dialog.dart';
import '../widgets/product_detail/product_detail_widgets.dart';
import 'package:myfinance_improved/shared/widgets/index.dart';

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
      setState(() => _isLoadingStocks = false);
      return;
    }

    try {
      final repository = ref.read(inventoryRepositoryProvider);
      final result = await repository.getProductStockByStores(
        companyId: companyId,
        productIds: [widget.productId],
      );

      if (mounted) {
        setState(() {
          _storeStocks = result?.products.isNotEmpty == true
              ? result!.products.first.stores
              : [];
          _isLoadingStocks = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoadingStocks = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final productsState = ref.watch(inventoryPageNotifierProvider);
    final currencySymbol = productsState.currency?.symbol ?? '';

    final product = productsState.products.cast<Product?>().firstWhere(
      (p) => p?.id == widget.productId,
      orElse: () => null,
    );

    if (product == null) {
      return const TossScaffold(
        backgroundColor: TossColors.white,
        body: TossLoadingView(),
      );
    }

    final appState = ref.watch(appStateProvider);
    final stores = _buildStoreLocations(appState, product, appState.storeChoosen);

    return TossScaffold(
      backgroundColor: TossColors.white,
      body: SafeArea(
        child: Column(
          children: [
            ProductDetailTopBar(
              product: product,
              onMoreOptions: () => _showMoreOptions(context, ref, product),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    ProductHeaderSection(product: product),
                    ProductHeroStats(
                      product: product,
                      currencySymbol: currencySymbol,
                    ),
                    _buildSectionDivider(),
                    ProductLocationsSection(
                      product: product,
                      stores: stores,
                      hasStockFilter: _hasStockFilter,
                      isLoading: _isLoadingStocks,
                      onFilterChanged: (value) {
                        setState(() => _hasStockFilter = value);
                      },
                      onStoreTap: (store) => _showMoveStockDialog(
                        context, product, store, stores,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionDivider() {
    return Container(height: 15, color: TossColors.gray100);
  }

  List<StoreLocation> _buildStoreLocations(
    AppState appState,
    Product product,
    String currentStoreId,
  ) {
    if (_storeStocks != null && _storeStocks!.isNotEmpty) {
      return _storeStocks!.map((stock) => StoreLocation(
        id: stock.storeId,
        name: stock.storeName,
        stock: stock.quantityOnHand,
        isCurrentStore: stock.storeId == currentStoreId,
      )).toList();
    }
    return _getCompanyStores(appState, product);
  }

  List<StoreLocation> _getCompanyStores(AppState appState, Product product) {
    final currentCompanyId = appState.companyChoosen;
    final currentStoreId = appState.storeChoosen;
    final companies = appState.user['companies'] as List<dynamic>? ?? [];

    Map<String, dynamic>? company;
    for (final c in companies) {
      if (c is Map<String, dynamic> && c['company_id'] == currentCompanyId) {
        company = c;
        break;
      }
    }

    if (company == null) {
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
      return [
        StoreLocation(
          id: currentStoreId,
          name: appState.storeName.isNotEmpty ? appState.storeName : 'Main Store',
          stock: product.onHand,
          isCurrentStore: true,
        ),
      ];
    }

    return storesList.map((store) {
      final storeMap = store as Map<String, dynamic>;
      final storeId = storeMap['store_id'] as String? ?? '';
      final storeName = storeMap['store_name'] as String? ?? 'Unknown Store';
      final isCurrentStore = storeId == currentStoreId;

      return StoreLocation(
        id: storeId,
        name: storeName,
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
        return await _executeMoveStock(
          context: context,
          product: product,
          fromStore: fromStore,
          toStore: toStore,
          quantity: quantity,
        );
      },
    );
  }

  Future<bool> _executeMoveStock({
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
        if (context.mounted) {
          await showDialog<bool>(
            context: context,
            barrierDismissible: false,
            builder: (ctx) => TossDialog.success(
              title: 'Stock Moved',
              message: 'Moved $quantity units from ${fromStore.name} to ${toStore.name}',
              primaryButtonText: 'OK',
            ),
          );
        }
        await _loadStoreStocks();
        ref.read(inventoryPageNotifierProvider.notifier).refresh();
        return true;
      }
      return false;
    } catch (e) {
      if (context.mounted) {
        await showDialog<bool>(
          context: context,
          barrierDismissible: true,
          builder: (ctx) => TossDialog.error(
            title: 'Move Failed',
            message: e.toString().replaceAll('Exception:', '').trim(),
          ),
        );
      }
      return false;
    }
  }

  void _showMoreOptions(BuildContext context, WidgetRef ref, Product product) {
    showModalBottomSheet(
      context: context,
      backgroundColor: TossColors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(TossBorderRadius.bottomSheet),
        ),
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
          TossButton.textButton(
            text: 'Cancel',
            onPressed: () => Navigator.pop(ctx, false),
          ),
          TossButton.textButton(
            text: 'Delete',
            textColor: TossColors.error,
            onPressed: () => Navigator.pop(ctx, true),
          ),
        ],
      ),
    );

    if (confirmed != true || !mounted) return;

    try {
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

      if (!mounted) return;
      showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (ctx) => const TossLoadingView(),
      );

      final repository = ref.read(inventoryRepositoryProvider);
      final success = await repository.deleteProducts(
        productIds: [product.id],
        companyId: companyId,
      );

      if (!mounted) return;
      Navigator.of(context).pop();

      if (success) {
        ref.read(inventoryPageNotifierProvider.notifier).refresh();
        if (!mounted) return;
        context.pop();

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
