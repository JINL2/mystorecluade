import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../../core/constants/app_icons_fa.dart';
import '../../../../core/themes/index.dart';
import '../../../widgets/common/toss_scaffold.dart';
import '../../../widgets/common/toss_app_bar.dart';
import '../../../widgets/toss/toss_bottom_sheet.dart';
import '../../../widgets/toss/toss_chip.dart';
import '../../../widgets/toss/toss_primary_button.dart';
import '../../../widgets/toss/toss_secondary_button.dart';
import '../../../widgets/toss/toss_badge.dart';
import '../../../widgets/toss/toss_list_tile.dart';
import '../../../helpers/navigation_helper.dart';
import '../models/product_model.dart';
import '../../../../data/models/inventory_models.dart' as inv_models;
import 'package:myfinance_improved/core/themes/toss_border_radius.dart';
import '../../../providers/app_state_provider.dart';
import '../providers/inventory_providers.dart';
class ProductDetailPage extends ConsumerStatefulWidget {
  final Product product;
  final inv_models.Currency? currency;

  const ProductDetailPage({Key? key, required this.product, this.currency}) : super(key: key);

  @override
  ConsumerState<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends ConsumerState<ProductDetailPage> {
  late Product _product;

  @override
  void initState() {
    super.initState();
    _product = widget.product;
  }

  Future<void> _editProduct() async {
    final result = await NavigationHelper.navigateTo(
      context,
      '/inventoryManagement/editProduct',
      extra: {
        'product': _product,
        'currency': widget.currency,
      },
    );
    
    if (result != null && result is Product) {
      setState(() {
        _product = result;
      });
    }
  }

  Future<void> _deleteProduct() async {
    // Show confirmation dialog
    final confirmed = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(TossBorderRadius.dialog),
        ),
        child: Container(
          padding: EdgeInsets.all(TossSpacing.space6),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Warning Icon
              Container(
                width: TossSpacing.space20,
                height: TossSpacing.space20,
                decoration: BoxDecoration(
                  color: TossColors.error.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.warning_amber_rounded,
                  color: TossColors.error,
                  size: TossSpacing.space12,
                ),
              ),
              
              SizedBox(height: TossSpacing.space4),
              
              Text(
                'Delete Product',
                style: TossTextStyles.h4.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              
              SizedBox(height: TossSpacing.space2),
              
              Text(
                'Are you sure you want to delete "${_product.name}"?\n\nThis action cannot be undone.',
                style: TossTextStyles.body.copyWith(
                  color: TossColors.gray700,
                ),
                textAlign: TextAlign.center,
              ),
              
              SizedBox(height: TossSpacing.space6),
              
              // Action Buttons
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.pop(context, false);
                      },
                      style: OutlinedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: TossSpacing.space3),
                        side: BorderSide(color: TossColors.gray300),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(TossBorderRadius.button),
                        ),
                      ),
                      child: Text(
                        'Cancel',
                        style: TossTextStyles.body.copyWith(
                          color: TossColors.gray700,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: TossSpacing.space3),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context, true);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: TossColors.error,
                        padding: EdgeInsets.symmetric(vertical: TossSpacing.space3),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(TossBorderRadius.button),
                        ),
                        elevation: 0,
                      ),
                      child: Text(
                        'Delete',
                        style: TossTextStyles.body.copyWith(
                          color: TossColors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
    
    if (confirmed == true) {
      // Show loading indicator
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => Center(
          child: Container(
            padding: EdgeInsets.all(TossSpacing.space4),
            decoration: BoxDecoration(
              color: TossColors.white,
              borderRadius: BorderRadius.circular(TossBorderRadius.lg),
            ),
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(TossColors.primary),
            ),
          ),
        ),
      );
      
      try {
        // Get company ID from app state
        final appState = ref.read(appStateProvider);
        final companyId = appState.companyChoosen as String?;
        
        if (companyId == null) {
          throw Exception('Company not selected');
        }
        
        // Call delete RPC
        final service = ref.read(inventoryServiceProvider);
        final result = await service.deleteProducts(
          productIds: [_product.id],  // Pass as list with single product ID
          companyId: companyId,
        );
        
        // Close loading dialog
        Navigator.pop(context);
        
        if (result != null) {
          // Show success message
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  Icon(Icons.check_circle, color: TossColors.white),
                  SizedBox(width: TossSpacing.space2),
                  Text('Product deleted successfully'),
                ],
              ),
              backgroundColor: TossColors.success,
              duration: Duration(seconds: 2),
            ),
          );
          
          // Refresh inventory list
          ref.invalidate(inventoryPageProvider);
          
          // Navigate back to product list
          NavigationHelper.safeGoBack(context);
        } else {
          throw Exception('Failed to delete product');
        }
      } catch (e) {
        // Close loading dialog if still open
        if (Navigator.canPop(context)) {
          Navigator.pop(context);
        }
        
        // Show error message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error deleting product: ${e.toString()}'),
            backgroundColor: TossColors.error,
          ),
        );
      }
    }
  }


  void _showMoreOptionsSheet() {
    TossBottomSheet.showCompact(
      context: context,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: TossColors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(TossBorderRadius.xl),
            topRight: Radius.circular(TossBorderRadius.xl),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle bar
            Container(
              width: 36,
              height: 4,
              margin: EdgeInsets.only(
                top: TossSpacing.space3,
                bottom: TossSpacing.space2,
              ),
              decoration: BoxDecoration(
                color: TossColors.gray300,
                borderRadius: BorderRadius.circular(TossBorderRadius.xs),
              ),
            ),
            
            // Menu options
            TossListTile(
              title: 'Edit Product',
              leading: Icon(
                Icons.edit,
                color: TossColors.primary,
                size: TossSpacing.iconSM,
              ),
              onTap: () {
                Navigator.pop(context);
                _editProduct();
              },
              showDivider: true,
            ),
            
            TossListTile(
              title: 'Delete Product',
              leading: Icon(
                Icons.delete_outline,
                color: TossColors.error,
                size: TossSpacing.iconSM,
              ),
              onTap: () {
                Navigator.pop(context);
                _deleteProduct();
              },
              showDivider: false,
            ),
            
            // Bottom padding for safe area
            SizedBox(height: MediaQuery.of(context).padding.bottom + TossSpacing.space4),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return TossScaffold(
      backgroundColor: TossColors.gray100,
      appBar: TossAppBar(
        title: 'Product Details',
        backgroundColor: TossColors.gray100,
        actions: [
          IconButton(
            icon: Icon(Icons.more_vert, size: TossSpacing.iconMD),
            onPressed: _showMoreOptionsSheet,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Product Image Section
            _buildImageSection(),
          
            
            // Product Info Section
            _buildProductInfoSection(),
            
            SizedBox(height: TossSpacing.space2),
                
            // Pricing Section
            _buildPricingSection(),
            
            SizedBox(height: TossSpacing.space2),
                
            // Inventory Section
            _buildInventorySection(),
            
            SizedBox(height: TossSpacing.space2),
                
                
            // Details Section
            _buildDetailsSection(),
            
            // Bottom padding
            SizedBox(height: TossSpacing.space6),
          ],
        ),
      ),
    );
  }

  Widget _buildImageSection() {
    return Container(
      margin: EdgeInsets.all(TossSpacing.space4),
      child: TossPageStyles.card(
        padding: EdgeInsets.zero,
        child: Container(
          height: 200,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(TossBorderRadius.lg),
            color: TossColors.gray100,
          ),
          child: _buildImagePlaceholder(),
        ),
      ),
    );
  }
  
  Widget _buildImagePlaceholder() {
    return Container(
      decoration: BoxDecoration(
        color: TossColors.gray100,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(TossBorderRadius.lg),
          topRight: Radius.circular(TossBorderRadius.lg),
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.inventory_2,
              size: TossSpacing.iconLG,
              color: TossColors.gray400,
            ),
            SizedBox(height: TossSpacing.space2),
            Text(
              'No Image',
              style: TossTextStyles.caption.copyWith(
                color: TossColors.gray500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductInfoSection() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: TossSpacing.space4),
      child: TossPageStyles.card(
        padding: EdgeInsets.all(TossSpacing.space4),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Product Name and Status
              Row(
                children: [
                  Expanded(
                    child: Text(
                      _product.name,
                      style: TossPageStyles.sectionTitleStyle.copyWith(
                        fontSize: 18,
                      ),
                    ),
                  ),
                  _buildStockBadge(),
                ],
              ),
              
              SizedBox(height: TossSpacing.space3),
              
              // SKU and Barcode Chips
              Row(
                children: [
                  TossChip(
                    label: _product.sku,
                    icon: Icons.qr_code,
                  ),
                  if (_product.barcode != null) ...[
                    SizedBox(width: TossSpacing.space2),
                    TossChip(
                      label: _product.barcode!,
                      icon: Icons.qr_code_scanner,
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
      );
  }
  
  Widget _buildStockBadge() {
    final status = _product.stockStatus;
    Color color;
    String text;
    
    if (_product.onHand == 0) {
      color = TossColors.error;
      text = 'Out of Stock';
    } else {
      switch (status) {
        case StockStatus.critical:
          color = TossColors.error;
          text = 'Critical';
          break;
        case StockStatus.low:
          color = TossColors.warning;
          text = 'Low Stock';
          break;
        case StockStatus.optimal:
          color = TossColors.success;
          text = 'In Stock';
          break;
        case StockStatus.excess:
          color = TossColors.info;
          text = 'Excess';
          break;
      }
    }
    
    return TossBadge(
      label: text,
      backgroundColor: color,
      textColor: TossColors.white,
    );
  }

  Widget _buildPricingSection() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: TossSpacing.space4),
      child: TossPageStyles.card(
        padding: EdgeInsets.all(TossSpacing.space4),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  FaIcon(
                    AppIcons.money,
                    color: TossColors.primary,
                    size: TossSpacing.iconSM,
                  ),
                  SizedBox(width: TossSpacing.space2),
                  Text(
                    'Pricing',
                    style: TossPageStyles.sectionTitleStyle,
                  ),
                ],
              ),
              SizedBox(height: TossSpacing.space4),
              
              _buildInfoRow(
                'Sale Price',
                _formatCurrency(_product.salePrice),
                valueStyle: TossPageStyles.valueStyle.copyWith(
                  fontWeight: FontWeight.w700,
                  color: TossColors.primary,
                ),
              ),
              _buildInfoRow(
                'Cost Price',
                _formatCurrency(_product.costPrice),
              ),
              if (_product.salePrice > 0 && !_product.marginPercentage.isNaN)
                _buildInfoRow(
                  'Margin',
                  '${_formatCurrency(_product.margin)} (${_product.marginPercentage.toStringAsFixed(1)}%)',
                  valueStyle: TossPageStyles.valueStyle.copyWith(
                    color: _product.marginPercentage >= 30 
                        ? TossColors.success 
                        : TossColors.warning,
                  ),
                )
              else if (_product.salePrice > 0 || _product.costPrice > 0)
                _buildInfoRow(
                  'Margin',
                  _formatCurrency(_product.margin),
                  valueStyle: TossPageStyles.valueStyle.copyWith(
                    color: _product.margin > 0 
                        ? TossColors.success 
                        : TossColors.gray500,
                  ),
                ),
              if (_product.compareAtPrice != null)
                _buildInfoRow(
                  'Compare at',
                  _formatCurrency(_product.compareAtPrice!),
                  valueStyle: TossPageStyles.valueStyle.copyWith(
                    decoration: TextDecoration.lineThrough,
                    color: TossColors.gray500,
                  ),
                ),
            ],
          ),
        ),
      );
  }

  Widget _buildInventorySection() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: TossSpacing.space4),
      child: TossPageStyles.card(
        padding: EdgeInsets.all(TossSpacing.space4),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  FaIcon(
                    AppIcons.inventory,
                    color: TossColors.primary,
                    size: TossSpacing.iconSM,
                  ),
                  SizedBox(width: TossSpacing.space2),
                  Text(
                    'Inventory',
                    style: TossPageStyles.sectionTitleStyle,
                  ),
                ],
              ),
              SizedBox(height: TossSpacing.space4),
              
              _buildInfoRow(
                'On Hand',
                '${_product.onHand} units',
                valueStyle: TossPageStyles.valueStyle.copyWith(
                  fontWeight: FontWeight.w700,
                  color: _getStockColor(),
                ),
              ),
              _buildInfoRow(
                'Available',
                '${_product.available} units',
              ),
              if (_product.reserved > 0)
                _buildInfoRow(
                  'Reserved',
                  '${_product.reserved} units',
                ),
              _buildInfoRow(
                'Inventory Value',
                _formatCurrency(_product.inventoryValue),
              ),
            ],
          ),
        ),
      );
  }
  
  Widget _buildDetailsSection() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: TossSpacing.space4),
      child: TossPageStyles.card(
        padding: EdgeInsets.all(TossSpacing.space4),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  FaIcon(
                    AppIcons.info,
                    color: TossColors.primary,
                    size: TossSpacing.iconSM,
                  ),
                  SizedBox(width: TossSpacing.space2),
                  Text(
                    'Details',
                    style: TossPageStyles.sectionTitleStyle,
                  ),
                ],
              ),
              SizedBox(height: TossSpacing.space4),
              
              _buildInfoRow(
                'Product Type',
                _getProductTypeDisplay(),
              ),
              if (_product.description != null && _product.description!.isNotEmpty)
                _buildInfoRow(
                  'Category',
                  _product.description!,
                ),
              if (_product.brand != null && _product.brand!.isNotEmpty)
                _buildInfoRow(
                  'Brand',
                  _product.brand!,
                ),
              _buildInfoRow(
                'Unit',
                _product.unit,
              ),
              _buildInfoRow(
                'Status',
                _product.isActive ? 'Active' : 'Inactive',
                valueStyle: TossPageStyles.valueStyle.copyWith(
                  color: _product.isActive ? TossColors.success : TossColors.gray500,
                ),
              ),
            ],
          ),
        ),
      );
  }

  Widget _buildInfoRow(String label, String value, {TextStyle? valueStyle}) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: TossSpacing.space4,
        vertical: TossSpacing.space4,
      ),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: TossColors.gray100,
            width: 0.5,
          ),
        ),
      ),
      child: Row(
        children: [
          Text(
            label,
            style: TossPageStyles.labelStyle.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
          Spacer(),
          Text(
            value,
            style: valueStyle ?? TossPageStyles.valueStyle.copyWith(
              color: TossColors.gray900,
            ),
          ),
        ],
      ),
    );
  }

  Color _getStockColor() {
    if (_product.onHand == 0) return TossColors.error;
    switch (_product.stockStatus) {
      case StockStatus.critical:
        return TossColors.error;
      case StockStatus.low:
        return TossColors.warning;
      case StockStatus.optimal:
        return TossColors.success;
      case StockStatus.excess:
        return TossColors.info;
    }
  }

  String _getProductTypeDisplay() {
    switch (_product.productType) {
      case ProductType.simple:
        return 'Simple';
      case ProductType.variant:
        return 'Variant';
      case ProductType.bundle:
        return 'Bundle';
      case ProductType.digital:
        return 'Digital';
      default:
        return 'Simple';
    }
  }

  String _formatCurrency(double value) {
    final currencySymbol = widget.currency?.symbol ?? '₩';
    return '$currencySymbol${value.toStringAsFixed(0).replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]},',
    )}';
  }
}