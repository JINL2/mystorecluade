import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/providers/app_state_provider.dart';
import '../../di/inventory_providers.dart';
import '../../../../shared/themes/toss_colors.dart';
import '../../../../shared/themes/toss_text_styles.dart';
import '../../../../shared/widgets/common/toss_scaffold.dart';
import '../../../../shared/widgets/common/toss_success_error_dialog.dart';
import '../../domain/entities/product.dart';
import '../extensions/stock_status_extension.dart';
import '../providers/inventory_providers.dart';

/// Product Detail Page - Shows detailed product information
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
  Future<void> _navigateToEdit() async {
    final result = await context.push<bool>(
      '/inventoryManagement/editProduct/${widget.productId}',
    );

    // If edit was successful, refresh the list
    if (result == true && mounted) {
      await ref.read(inventoryPageProvider.notifier).refresh();
    }
  }

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
      backgroundColor: TossColors.gray100,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            // Refresh inventory list when going back
            ref.read(inventoryPageProvider.notifier).refresh();
            context.pop();
          },
        ),
        title: Text(
          'Product Details',
          style: TossTextStyles.h3.copyWith(fontWeight: FontWeight.w700),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: TossColors.gray100,
        foregroundColor: TossColors.black,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: _navigateToEdit,
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: () => _showDeleteConfirmation(product),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Images
            _buildImageSection(product),

            const SizedBox(height: 8),

            // Product Basic Info
            _buildBasicInfoSection(product),

            const SizedBox(height: 8),

            // Classification
            _buildClassificationSection(product),

            const SizedBox(height: 8),

            // Pricing
            _buildPricingSection(product, currencySymbol),

            const SizedBox(height: 8),

            // Inventory
            _buildInventorySection(product, currencySymbol),

            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }

  Widget _buildImageSection(Product product) {
    if (product.images.isEmpty) {
      return Container(
        width: double.infinity,
        height: 200,
        color: TossColors.gray100,
        child: const Icon(
          Icons.inventory_2,
          size: 100,
          color: TossColors.gray400,
        ),
      );
    }

    final imageCount = product.images.length.clamp(1, 3);

    return Container(
      height: 200,
      color: TossColors.gray100,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(imageCount, (index) {
          return Expanded(
            child: Padding(
              padding: EdgeInsets.only(
                left: index == 0 ? 0 : 4,
                right: index == imageCount - 1 ? 0 : 4,
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  product.images[index],
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) => Container(
                    color: TossColors.gray200,
                    child: const Icon(
                      Icons.inventory_2,
                      size: 50,
                      color: TossColors.gray400,
                    ),
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildBasicInfoSection(Product product) {
    return Container(
      color: TossColors.surface,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  product.name,
                  style: TossTextStyles.h2.copyWith(fontWeight: FontWeight.w700),
                ),
              ),
              if (!product.isActive)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: TossColors.error.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    'Inactive',
                    style: TossTextStyles.caption.copyWith(
                      color: TossColors.error,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
            ],
          ),
          if (product.description != null) ...[
            const SizedBox(height: 8),
            Text(
              product.description!,
              style: TossTextStyles.body.copyWith(color: TossColors.gray600),
            ),
          ],
          const SizedBox(height: 16),
          _buildInfoRow('SKU', product.sku),
          if (product.barcode != null) ...[
            const SizedBox(height: 8),
            _buildInfoRow('Barcode', product.barcode!),
          ],
          const SizedBox(height: 8),
          _buildInfoRow('Product Type', product.productType),
        ],
      ),
    );
  }

  Widget _buildClassificationSection(Product product) {
    return Container(
      color: TossColors.surface,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.folder_outlined, color: TossColors.primary, size: 20),
              const SizedBox(width: 8),
              Text(
                'Classification',
                style: TossTextStyles.bodyLarge.copyWith(fontWeight: FontWeight.w600),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildInfoRow('Category', product.categoryName ?? 'N/A'),
          const SizedBox(height: 8),
          _buildInfoRow('Brand', product.brandName ?? 'N/A'),
          const SizedBox(height: 8),
          _buildInfoRow('Unit', product.unit),
        ],
      ),
    );
  }

  Widget _buildPricingSection(Product product, String currencySymbol) {
    return Container(
      color: TossColors.surface,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.attach_money, color: TossColors.primary, size: 20),
              const SizedBox(width: 8),
              Text(
                'Pricing',
                style: TossTextStyles.bodyLarge.copyWith(fontWeight: FontWeight.w600),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildInfoRow('Sale Price', '$currencySymbol${_formatCurrency(product.salePrice)}'),
          const SizedBox(height: 8),
          _buildInfoRow('Cost Price', '$currencySymbol${_formatCurrency(product.costPrice)}'),
          const SizedBox(height: 8),
          _buildInfoRow('Margin', '$currencySymbol${_formatCurrency(product.margin)} (${product.marginPercentage.toStringAsFixed(1)}%)'),
        ],
      ),
    );
  }

  Widget _buildInventorySection(Product product, String currencySymbol) {
    final stockStatus = product.getStockStatus();
    Color statusColor;
    switch (stockStatus) {
      case StockStatus.outOfStock:
        statusColor = TossColors.error;
        break;
      case StockStatus.critical:
        statusColor = TossColors.error;
        break;
      case StockStatus.low:
        statusColor = Colors.orange;
        break;
      case StockStatus.normal:
        statusColor = TossColors.success;
        break;
      case StockStatus.excess:
        statusColor = Colors.blue;
        break;
    }

    return Container(
      color: TossColors.surface,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.inventory, color: TossColors.primary, size: 20),
              const SizedBox(width: 8),
              Text(
                'Inventory',
                style: TossTextStyles.bodyLarge.copyWith(fontWeight: FontWeight.w600),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  stockStatus.displayName,
                  style: TossTextStyles.caption.copyWith(
                    color: statusColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildInfoRow('On Hand', '${product.onHand} ${product.unit}'),
          const SizedBox(height: 8),
          _buildInfoRow('Available', '${product.available} ${product.unit}'),
          const SizedBox(height: 8),
          _buildInfoRow('Reserved', '${product.reserved} ${product.unit}'),
          if (product.reorderPoint != null) ...[
            const SizedBox(height: 8),
            _buildInfoRow('Reorder Point', '${product.reorderPoint} ${product.unit}'),
          ],
          if (product.minStock != null) ...[
            const SizedBox(height: 8),
            _buildInfoRow('Min Stock', '${product.minStock} ${product.unit}'),
          ],
          if (product.maxStock != null) ...[
            const SizedBox(height: 8),
            _buildInfoRow('Max Stock', '${product.maxStock} ${product.unit}'),
          ],
          if (product.location != null) ...[
            const SizedBox(height: 8),
            _buildInfoRow('Location', product.location!),
          ],
          const SizedBox(height: 16),
          const Divider(),
          const SizedBox(height: 16),
          Text(
            'Financial Summary',
            style: TossTextStyles.bodyLarge.copyWith(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 12),
          _buildInfoRow('Inventory Value', '$currencySymbol${_formatCurrency(product.inventoryValue)}'),
          const SizedBox(height: 8),
          _buildInfoRow('Potential Revenue', '$currencySymbol${_formatCurrency(product.potentialRevenue)}'),
        ],
      ),
    );
  }

  String _formatCurrency(double value) {
    return value.toStringAsFixed(0).replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]},',
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: Text(
            label,
            style: TossTextStyles.body.copyWith(
              color: TossColors.gray600,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Expanded(
          flex: 3,
          child: Text(
            value,
            style: TossTextStyles.body.copyWith(
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.right,
          ),
        ),
      ],
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
