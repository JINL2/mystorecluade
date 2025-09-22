import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../../core/constants/app_icons_fa.dart';
import '../../../../core/themes/index.dart';
import '../../../widgets/common/toss_scaffold.dart';
import '../../../widgets/common/toss_app_bar.dart';
import '../../../widgets/toss/toss_bottom_sheet.dart';
import '../../../widgets/toss/toss_text_field.dart';
import '../../../widgets/toss/toss_chip.dart';
import '../../../widgets/toss/toss_primary_button.dart';
import '../../../widgets/toss/toss_secondary_button.dart';
import '../../../widgets/toss/toss_badge.dart';
import '../../../widgets/toss/toss_list_tile.dart';
import '../../../helpers/navigation_helper.dart';
import '../models/product_model.dart';
import '../../../../data/models/inventory_models.dart';
import 'package:myfinance_improved/core/themes/toss_border_radius.dart';
class ProductDetailPage extends ConsumerStatefulWidget {
  final Product product;
  final Currency? currency;

  const ProductDetailPage({Key? key, required this.product, this.currency}) : super(key: key);

  @override
  ConsumerState<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends ConsumerState<ProductDetailPage> {
  late Product _product;
  int _selectedImageIndex = 0;

  @override
  void initState() {
    super.initState();
    _product = widget.product;
  }

  Future<void> _editProduct() async {
    final result = await NavigationHelper.navigateTo(
      context,
      '/inventoryManagement/editProduct',
      extra: {'product': _product},
    );
    
    if (result != null && result is Product) {
      setState(() {
        _product = result;
      });
    }
  }

  Future<void> _deleteProduct() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: TossColors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(TossBorderRadius.lg),
        ),
        title: Text(
          'Delete Product',
          style: TossTextStyles.h3.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        content: Text(
          'Are you sure you want to delete "${_product.name}"?',
          style: TossTextStyles.body,
        ),
        actions: [
          TossSecondaryButton(
            text: 'Cancel',
            onPressed: () => Navigator.pop(context, false),
          ),
          SizedBox(width: TossSpacing.space2),
          TossPrimaryButton(
            text: 'Delete',
            onPressed: () => Navigator.pop(context, true),
          ),
        ],
      ),
    );
    
    if (confirmed == true) {
      NavigationHelper.safeGoBack(context);
    }
  }

  void _adjustStock() {
    TossBottomSheet.show(
      context: context,
      content: _StockAdjustmentSheet(
        product: _product,
        onAdjust: (newQuantity, reason) {
          setState(() {
            _product = _product.copyWith(onHand: newQuantity);
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  Icon(Icons.check_circle, color: TossColors.white),
                  SizedBox(width: TossSpacing.space2),
                  Text('Stock adjusted to $newQuantity units'),
                ],
              ),
              backgroundColor: TossColors.success,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(TossBorderRadius.md),
              ),
            ),
          );
        },
      ),
    );
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
              title: 'Duplicate Product',
              leading: Icon(
                Icons.copy,
                color: TossColors.gray700,
                size: TossSpacing.iconSM,
              ),
              onTap: () {
                Navigator.pop(context);
                // TODO: Implement duplicate functionality
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Duplicate feature coming soon'),
                    backgroundColor: TossColors.info,
                  ),
                );
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
                
            // Analytics Section
            _buildAnalyticsSection(),
            
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
        child: Column(
          children: [
            // Image Display
            Container(
              height: 200,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(TossBorderRadius.lg),
                  topRight: Radius.circular(TossBorderRadius.lg),
                ),
                color: TossColors.gray100,
              ),
              child: _product.images.isNotEmpty
                  ? PageView.builder(
                      onPageChanged: (index) {
                        setState(() {
                          _selectedImageIndex = index;
                        });
                      },
                      itemCount: _product.images.length,
                      itemBuilder: (context, index) {
                        return ClipRRect(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(TossBorderRadius.lg),
                            topRight: Radius.circular(TossBorderRadius.lg),
                          ),
                          child: Image.network(
                            _product.images[index],
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                _buildImagePlaceholder(),
                          ),
                        );
                      },
                    )
                  : _buildImagePlaceholder(),
            ),
            
            // Image indicators
            if (_product.images.length > 1)
              Container(
                padding: EdgeInsets.symmetric(vertical: TossSpacing.space2),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    _product.images.length,
                    (index) => Container(
                      margin: EdgeInsets.symmetric(horizontal: TossSpacing.space1),
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _selectedImageIndex == index
                            ? TossColors.primary
                            : TossColors.gray300,
                      ),
                    ),
                  ),
                ),
              ),
          ],
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
              
              if (_product.description != null) ...[
                SizedBox(height: TossSpacing.space3),
                Text(
                  _product.description!,
                  style: TossTextStyles.body.copyWith(
                    color: TossColors.gray700,
                    height: 1.5,
                  ),
                ),
              ],
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
              _buildInfoRow(
                'Margin',
                '${_formatCurrency(_product.margin)} (${_product.marginPercentage.toStringAsFixed(1)}%)',
                valueStyle: TossPageStyles.valueStyle.copyWith(
                  color: _product.marginPercentage >= 30 
                      ? TossColors.success 
                      : TossColors.warning,
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
              if (_product.reorderPoint != null)
                _buildInfoRow(
                  'Reorder Point',
                  '${_product.reorderPoint} units',
                ),
              if (_product.location != null)
                _buildInfoRow(
                  'Location',
                  _product.location!,
                ),
              
              SizedBox(height: TossSpacing.space4),
              
              TossSecondaryButton(
                text: 'Adjust Stock',
                onPressed: _adjustStock,
                leadingIcon: Icon(Icons.edit),
                fullWidth: true,
              ),
            ],
          ),
        ),
      );
  }
  
  Widget _buildAnalyticsSection() {
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
                    AppIcons.analytics,
                    color: TossColors.primary,
                    size: TossSpacing.iconSM,
                  ),
                  SizedBox(width: TossSpacing.space2),
                  Text(
                    'Analytics',
                    style: TossPageStyles.sectionTitleStyle,
                  ),
                ],
              ),
              SizedBox(height: TossSpacing.space4),
              
              if (_product.averageDailySales != null)
                _buildInfoRow(
                  'Avg. Daily Sales',
                  '${_product.averageDailySales!.toStringAsFixed(1)} units',
                ),
              if (_product.daysOnHand != null)
                _buildInfoRow(
                  'Days on Hand',
                  '${_product.daysOnHand} days',
                ),
              _buildInfoRow(
                'Days Until Stockout',
                _product.daysUntilStockout == 999 
                    ? 'N/A' 
                    : '${_product.daysUntilStockout} days',
                valueStyle: TossPageStyles.valueStyle.copyWith(
                  color: _product.daysUntilStockout < 7 
                      ? TossColors.error 
                      : TossColors.gray700,
                ),
              ),
              if (_product.turnoverRate != null)
                _buildInfoRow(
                  'Turnover Rate',
                  '${_product.turnoverRate!.toStringAsFixed(1)}x per year',
                ),
              if (_product.lastSold != null)
                _buildInfoRow(
                  'Last Sold',
                  _formatDate(_product.lastSold!),
                ),
              if (_product.lastCounted != null)
                _buildInfoRow(
                  'Last Counted',
                  _formatDate(_product.lastCounted!),
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
                'Category',
                _product.category.displayName,
              ),
              if (_product.brand != null)
                _buildInfoRow(
                  'Brand',
                  _product.brand!,
                ),
              if (_product.tags.isNotEmpty)
                _buildInfoRow(
                  'Tags',
                  _product.tags.join(', '),
                ),
              _buildInfoRow(
                'Sell in Store',
                _product.sellInStore ? 'Yes' : 'No',
              ),
              _buildInfoRow(
                'Sell Online',
                _product.sellOnline ? 'Yes' : 'No',
              ),
              _buildInfoRow(
                'Created',
                _formatDate(_product.createdAt),
              ),
              _buildInfoRow(
                'Last Updated',
                _formatDate(_product.updatedAt),
              ),
            ],
          ),
        ),
      );
  }
  
  Widget _buildSectionHeader(String title, IconData icon) {
    return Row(
      children: [
        Text(
          title,
          style: TossPageStyles.sectionTitleStyle,
        ),
      ],
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

  String _formatCurrency(double value) {
    final currencySymbol = widget.currency?.symbol ?? '₩';
    return '$currencySymbol${value.toStringAsFixed(0).replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]},',
    )}';
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);
    
    if (difference.inDays == 0) {
      return 'Today ${DateFormat.Hm().format(date)}';
    } else if (difference.inDays == 1) {
      return 'Yesterday ${DateFormat.Hm().format(date)}';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else {
      return DateFormat('dd/MM/yyyy').format(date);
    }
  }
}

class _StockAdjustmentSheet extends StatefulWidget {
  final Product product;
  final Function(int, String) onAdjust;

  const _StockAdjustmentSheet({
    Key? key,
    required this.product,
    required this.onAdjust,
  }) : super(key: key);

  @override
  State<_StockAdjustmentSheet> createState() => _StockAdjustmentSheetState();
}

class _StockAdjustmentSheetState extends State<_StockAdjustmentSheet> {
  final _quantityController = TextEditingController();
  String _selectedReason = 'Manual Count';
  final _reasons = [
    'Manual Count',
    'Damage',
    'Loss',
    'Theft',
    'Return',
    'Found',
    'Other',
  ];

  @override
  void initState() {
    super.initState();
    _quantityController.text = widget.product.onHand.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.8,
      ),
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
          
          // Header
          Padding(
            padding: EdgeInsets.all(TossSpacing.space4),
            child: Row(
              children: [
                Icon(
                  Icons.inventory,
                  color: TossColors.primary,
                  size: TossSpacing.iconSM,
                ),
                SizedBox(width: TossSpacing.space2),
                Text(
                  'Adjust Stock',
                  style: TossTextStyles.h3.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
          
          Flexible(
            child: SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(
                TossSpacing.space4,
                0,
                TossSpacing.space4,
                MediaQuery.of(context).padding.bottom + TossSpacing.space4,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Current Stock Info
                  Container(
                    padding: EdgeInsets.all(TossSpacing.space3),
                    decoration: BoxDecoration(
                      color: TossColors.gray50,
                      borderRadius: BorderRadius.circular(TossBorderRadius.md),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.info_outline,
                          color: TossColors.primary,
                          size: TossSpacing.iconSM,
                        ),
                        SizedBox(width: TossSpacing.space2),
                        Text(
                          'Current Stock: ${widget.product.onHand} units',
                          style: TossTextStyles.body.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  SizedBox(height: TossSpacing.space4),
                  
                  // New Quantity Input
                  TossTextField(
                    label: 'New Quantity',
                    hintText: 'Enter new stock quantity',
                    controller: _quantityController,
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  ),
                  
                  SizedBox(height: TossSpacing.space4),
                  
                  // Reason Label
                  Text(
                    'Reason for Adjustment',
                    style: TossTextStyles.body.copyWith(
                      fontWeight: FontWeight.w600,
                      color: TossColors.gray700,
                    ),
                  ),
                  
                  SizedBox(height: TossSpacing.space2),
                  
                  // Reason Dropdown
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(
                      horizontal: TossSpacing.space4,
                      vertical: TossSpacing.space3,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(color: TossColors.gray300),
                      borderRadius: BorderRadius.circular(TossBorderRadius.md),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: _selectedReason,
                        hint: Text(
                          'Select reason',
                          style: TossTextStyles.body.copyWith(
                            color: TossColors.gray500,
                          ),
                        ),
                        icon: Icon(
                          Icons.keyboard_arrow_down,
                          color: TossColors.gray500,
                        ),
                        items: _reasons.map((reason) {
                          return DropdownMenuItem(
                            value: reason,
                            child: Text(
                              reason,
                              style: TossTextStyles.body,
                            ),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedReason = value!;
                          });
                        },
                      ),
                    ),
                  ),
                  
                  SizedBox(height: TossSpacing.space6),
                  
                  // Action Buttons
                  Row(
                    children: [
                      Expanded(
                        child: TossSecondaryButton(
                          text: 'Cancel',
                          onPressed: () => Navigator.pop(context),
                        ),
                      ),
                      SizedBox(width: TossSpacing.space3),
                      Expanded(
                        flex: 2,
                        child: TossPrimaryButton(
                          text: 'Adjust Stock',
                          onPressed: () {
                            final quantity = int.tryParse(_quantityController.text);
                            if (quantity != null) {
                              widget.onAdjust(quantity, _selectedReason);
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _quantityController.dispose();
    super.dispose();
  }
}