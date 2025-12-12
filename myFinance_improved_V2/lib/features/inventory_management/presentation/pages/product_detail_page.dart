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
import '../../../../shared/widgets/toss/toss_quantity_stepper.dart';
import '../../domain/entities/product.dart';
import '../extensions/stock_status_extension.dart';
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
  String? _expandedLocationId;

  @override
  Widget build(BuildContext context) {
    final productsState = ref.watch(inventoryPageProvider);
    final currencySymbol = productsState.currency?.symbol ?? '';

    // Find product in the list
    final product = productsState.products.firstWhere(
      (p) => p.id == widget.productId,
      orElse: () => throw Exception('Product not found'),
    );

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
          // Right side - edit and more buttons
          Row(
            children: [
              TossIconButton.edit(
                onPressed: () {
                  context.push('/inventoryManagement/editProduct/${widget.productId}');
                },
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
    return GestureDetector(
      onTap: () {
        context.push('/inventoryManagement/editProduct/${widget.productId}');
      },
      child: Container(
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
            // Chevron
            Icon(
              Icons.chevron_right,
              size: 18,
              color: TossColors.gray500,
            ),
          ],
        ),
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
    final stores = _getCompanyStores(appState, product);

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: TossSpacing.space4),
          child: Column(
            children: [
              // Section header
              Padding(
                padding: const EdgeInsets.only(
                    top: TossSpacing.space6, bottom: TossSpacing.space3),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${stores.length} locations',
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
              // Location rows
              ...(_hasStockFilter
                      ? stores.where((l) => l.stock > 0)
                      : stores)
                  .map((location) => _buildLocationRow(location, product)),
            ],
          ),
        ),
        // Recent transactions button - full width dividers
        _buildRecentTransactionsButton(product),
        const SizedBox(height: TossSpacing.space4),
      ],
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

  Widget _buildLocationRow(StoreLocation location, Product product) {
    final isExpanded = _expandedLocationId == location.id;
    final appState = ref.watch(appStateProvider);
    final allStores = _getCompanyStores(appState, product);

    return Column(
      children: [
        // Main row - store info
        GestureDetector(
          onTap: () {
            setState(() {
              _expandedLocationId = isExpanded ? null : location.id;
            });
          },
          behavior: HitTestBehavior.opaque,
          child: Container(
            constraints: const BoxConstraints(minHeight: 48),
            padding: const EdgeInsets.symmetric(vertical: TossSpacing.space2),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Left side - store icon (animated) and name
                Expanded(
                  child: Row(
                    children: [
                      // Animated store icon - slides out when expanded
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        curve: Curves.easeInOut,
                        width: isExpanded ? 0 : 18,
                        child: AnimatedOpacity(
                          duration: const Duration(milliseconds: 150),
                          opacity: isExpanded ? 0 : 1,
                          child: Icon(
                            Icons.store_outlined,
                            size: 18,
                            color: TossColors.gray900,
                          ),
                        ),
                      ),
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        width: isExpanded ? 0 : TossSpacing.space2,
                      ),
                      // Store name with "This store" badge
                      Flexible(
                        child: RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: location.name,
                                style: TossTextStyles.body.copyWith(
                                  fontWeight: FontWeight.w500,
                                  color: TossColors.gray900,
                                ),
                              ),
                              if (location.isCurrentStore)
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
                        color: TossColors.primarySurface,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        '${location.stock}',
                        style: TossTextStyles.body.copyWith(
                          fontWeight: FontWeight.w600,
                          color: TossColors.primary,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    // Animated chevron - rotates when expanded
                    AnimatedRotation(
                      duration: const Duration(milliseconds: 200),
                      turns: isExpanded ? 0.25 : 0,
                      child: Icon(
                        Icons.chevron_right,
                        size: 18,
                        color: TossColors.gray500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        // Expandable action items
        AnimatedCrossFade(
          duration: const Duration(milliseconds: 200),
          crossFadeState: isExpanded ? CrossFadeState.showSecond : CrossFadeState.showFirst,
          firstChild: const SizedBox.shrink(),
          secondChild: Column(
            children: [
              _buildActionRow(
                icon: Icons.download_outlined,
                label: 'Record Stock In',
                onTap: () {
                  setState(() {
                    _expandedLocationId = null;
                  });
                  _showStockInDialog(context, product, location);
                },
              ),
              _buildActionRow(
                icon: Icons.swap_horiz,
                label: 'Move Stock',
                onTap: () {
                  setState(() {
                    _expandedLocationId = null;
                  });
                  _showMoveStockDialog(context, product, location, allStores);
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildActionRow({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        constraints: const BoxConstraints(minHeight: 48),
        padding: const EdgeInsets.symmetric(vertical: TossSpacing.space2),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(
                  icon,
                  size: 18,
                  color: TossColors.gray600,
                ),
                const SizedBox(width: TossSpacing.space2),
                Text(
                  label,
                  style: TossTextStyles.body.copyWith(
                    fontWeight: FontWeight.w500,
                    color: TossColors.gray900,
                  ),
                ),
              ],
            ),
            Icon(
              Icons.chevron_right,
              size: 18,
              color: TossColors.gray500,
            ),
          ],
        ),
      ),
    );
  }

  void _showStockInDialog(BuildContext context, Product product, StoreLocation location) {
    showDialog(
      context: context,
      builder: (context) => _StockInDialog(
        productName: product.name,
        currentStock: location.stock,
        onSubmit: (quantity) {
          // TODO: Implement stock in API call
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Added $quantity units to ${location.name}'),
              duration: const Duration(seconds: 2),
            ),
          );
        },
      ),
    );
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
      fromLocation: fromLocation,
      allStores: allStores,
      onSubmit: (fromStore, toStore, quantity) {
        // TODO: Implement move stock API call
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Moved $quantity units from ${fromStore.name} to ${toStore.name}'),
            duration: const Duration(seconds: 2),
          ),
        );
      },
    );
  }

  Widget _buildRecentTransactionsButton(Product product) {
    return Column(
      children: [
        // Top divider
        Container(
          height: 1,
          color: TossColors.gray200,
          margin: const EdgeInsets.only(bottom: 10),
        ),
        // Button
        GestureDetector(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => ProductTransactionsPage(product: product),
              ),
            );
          },
          behavior: HitTestBehavior.opaque,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: TossSpacing.space2),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.history,
                  size: 20,
                  color: TossColors.gray600,
                ),
                const SizedBox(width: TossSpacing.space2),
                Text(
                  'Recent transactions',
                  style: TossTextStyles.body.copyWith(
                    fontWeight: FontWeight.w500,
                    color: TossColors.gray600,
                  ),
                ),
              ],
            ),
          ),
        ),
        // Bottom divider
        Container(
          height: 1,
          color: TossColors.gray200,
          margin: const EdgeInsets.only(top: 10),
        ),
      ],
    );
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
                _showDeleteConfirmation(context, ref, product);
              },
            ),
            const SizedBox(height: TossSpacing.space2),
          ],
        ),
      ),
    );
  }

  Future<void> _showDeleteConfirmation(
    BuildContext context,
    WidgetRef ref,
    Product product,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Product'),
        content: Text(
          'Are you sure you want to delete "${product.name}"?\n\nThis action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(
              foregroundColor: TossColors.error,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      try {
        // Get company ID
        final appState = ref.read(appStateProvider);
        final companyId = appState.companyChoosen as String?;

        if (companyId == null) {
          if (context.mounted) {
            await showDialog<void>(
              context: context,
              builder: (context) => TossDialog.error(
                title: 'Company Not Selected',
                message: 'Please select a company to delete products.',
                primaryButtonText: 'OK',
              ),
            );
          }
          return;
        }

        // Show loading indicator
        if (context.mounted) {
          showDialog<void>(
            context: context,
            barrierDismissible: false,
            builder: (context) => const Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        // Delete product
        final repository = ref.read(inventoryRepositoryProvider);
        final success = await repository.deleteProducts(
          productIds: [product.id],
          companyId: companyId,
        );

        // Close loading indicator
        if (context.mounted) {
          Navigator.pop(context);
        }

        if (success) {
          // Refresh inventory list
          ref.read(inventoryPageProvider.notifier).refresh();

          if (context.mounted) {
            // Navigate back to inventory list first
            context.pop();

            // Show success dialog
            if (context.mounted) {
              await showDialog<void>(
                context: context,
                barrierDismissible: false,
                builder: (context) => TossDialog.success(
                  title: 'Product Deleted',
                  message: '${product.name} has been successfully deleted.',
                  primaryButtonText: 'OK',
                  onPrimaryPressed: () => Navigator.pop(context),
                ),
              );
            }
          }
        } else {
          if (context.mounted) {
            await showDialog<void>(
              context: context,
              builder: (context) => TossDialog.error(
                title: 'Delete Failed',
                message: 'Failed to delete product. Please try again.',
                primaryButtonText: 'OK',
              ),
            );
          }
        }
      } catch (e) {
        // Close loading indicator if still showing
        if (context.mounted && Navigator.canPop(context)) {
          Navigator.pop(context);
        }

        if (context.mounted) {
          await showDialog<void>(
            context: context,
            builder: (context) => TossDialog.error(
              title: 'Error',
              message: e.toString().replaceAll('Exception:', '').trim(),
              primaryButtonText: 'OK',
            ),
          );
        }
      }
    }
  }
}

/// Stock In Dialog Widget
class _StockInDialog extends StatefulWidget {
  final String productName;
  final int currentStock;
  final void Function(int quantity) onSubmit;

  const _StockInDialog({
    required this.productName,
    required this.currentStock,
    required this.onSubmit,
  });

  @override
  State<_StockInDialog> createState() => _StockInDialogState();
}

class _StockInDialogState extends State<_StockInDialog> {
  int _quantity = 0;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: TossColors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Title
            Text(
              'Enter Stock In Quantity',
              style: TossTextStyles.titleLarge.copyWith(
                color: TossColors.gray900,
              ),
            ),
            const SizedBox(height: 8),
            // Product name
            Text(
              widget.productName,
              style: TossTextStyles.body.copyWith(
                color: TossColors.gray600,
              ),
            ),
            const SizedBox(height: 24),
            // Quantity stepper
            TossQuantityStepper(
              initialValue: 0,
              previousValue: widget.currentStock,
              onChanged: (value) {
                setState(() {
                  _quantity = value;
                });
              },
            ),
            const SizedBox(height: 24),
            // Action buttons
            Row(
              children: [
                // Cancel button
                Expanded(
                  child: GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      height: 48,
                      decoration: BoxDecoration(
                        color: TossColors.gray100,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        'Cancel',
                        style: TossTextStyles.body.copyWith(
                          fontWeight: FontWeight.w600,
                          color: TossColors.gray700,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                // Submit button
                Expanded(
                  child: GestureDetector(
                    onTap: _quantity > 0 ? () => widget.onSubmit(_quantity) : null,
                    child: Container(
                      height: 48,
                      decoration: BoxDecoration(
                        color: _quantity > 0 ? TossColors.primary : TossColors.gray300,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        'Submit',
                        style: TossTextStyles.body.copyWith(
                          fontWeight: FontWeight.w600,
                          color: TossColors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
