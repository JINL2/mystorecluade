import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../core/themes/toss_colors.dart';
import '../../../core/themes/toss_text_styles.dart';
import '../../../core/themes/toss_spacing.dart';
import '../../../core/themes/toss_border_radius.dart';
import '../../widgets/common/toss_scaffold.dart';
import '../../widgets/common/toss_white_card.dart';
import '../../widgets/common/enhanced_quantity_selector.dart';
import '../../widgets/toss/toss_list_tile.dart';
import '../../widgets/toss/toss_search_field.dart';
import '../../helpers/navigation_helper.dart';
import 'sale_product_page.dart';
import 'models/sale_product_models.dart';
import '../sales_invoice/models/invoice_models.dart'; // Import SalesProduct
import 'package:myfinance_improved/core/themes/index.dart';

class SaleInvoicePage extends ConsumerStatefulWidget {
  const SaleInvoicePage({super.key});

  @override
  ConsumerState<SaleInvoicePage> createState() => _SaleInvoicePageState();
}

class _SaleInvoicePageState extends ConsumerState<SaleInvoicePage> {
  String customerName = 'Guest';
  String priceBookName = 'General price book';
  
  // Modern color palette for product avatars
  final List<Color> _avatarColors = [
    TossColors.error, // Red
    TossColors.warning, // Orange
    TossColors.success, // Green
    TossColors.primary, // Blue
    TossColors.info, // Purple
    TossColors.warning, // Yellow
    TossColors.success, // Teal
    TossColors.error, // Pink
  ];

  @override
  Widget build(BuildContext context) {
    // TODO: Update to use selectedProductsProvider
    final cart = <SalesProduct>[]; // ref.watch(cartProvider);
    final subtotal = 0.0; // ref.read(cartProvider.notifier).subtotal;
    final totalItems = 0; // ref.read(cartProvider.notifier).totalItems;
    final formatter = NumberFormat('#,###');

    if (cart.isEmpty) {
      // If cart is empty, go back to product selection
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.pop();
      });
      return const SizedBox.shrink();
    }

    return TossScaffold(
      backgroundColor: TossColors.gray100,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => NavigationHelper.safeGoBack(context),
        ),
        title: Text(
          'Invoice Review',
          style: TossTextStyles.h3,
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: TossColors.gray100,
        foregroundColor: TossColors.black,
        actions: [
          IconButton(
            icon: Icon(Icons.receipt_long_outlined, color: TossColors.gray600),
            onPressed: () {
              // Receipt/Print action
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Search Section (Disabled)
            Container(
              margin: EdgeInsets.fromLTRB(
                TossSpacing.space4,
                TossSpacing.space3,
                TossSpacing.space4,
                TossSpacing.space3,
              ),
              child: TossSearchField(
                hintText: 'Search disabled in review mode',
                prefixIcon: Icons.search,
                enabled: false,
              ),
            ),

            // Customer & Price Book Section
            Container(
              margin: EdgeInsets.symmetric(horizontal: TossSpacing.space4),
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
                            Icons.settings,
                            color: TossColors.primary,
                            size: TossSpacing.iconSM,
                          ),
                          SizedBox(width: TossSpacing.space2),
                          Text(
                            'Configuration',
                            style: TossTextStyles.bodyLarge.copyWith(
                              fontWeight: FontWeight.w700,
                              color: TossColors.gray900,
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    // Customer Selection
                    TossListTile(
                      title: 'Customer',
                      subtitle: customerName,
                      leading: Container(
                        width: TossSpacing.space10,
                        height: TossSpacing.space10,
                        decoration: BoxDecoration(
                          color: TossColors.primary.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(TossBorderRadius.md),
                        ),
                        child: Icon(
                          Icons.person_outline,
                          color: TossColors.primary,
                          size: TossSpacing.iconSM,
                        ),
                      ),
                      trailing: Icon(
                        Icons.chevron_right,
                        color: TossColors.gray400,
                        size: TossSpacing.iconSM,
                      ),
                      onTap: () {
                        // Show customer selection
                      },
                    ),
                    
                    // Price Book Selection
                    TossListTile(
                      title: 'Price Book',
                      subtitle: priceBookName,
                      showDivider: false,
                      leading: Container(
                        width: TossSpacing.space10,
                        height: TossSpacing.space10,
                        decoration: BoxDecoration(
                          color: TossColors.success.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(TossBorderRadius.md),
                        ),
                        child: Icon(
                          Icons.local_offer_outlined,
                          color: TossColors.success,
                          size: TossSpacing.iconSM,
                        ),
                      ),
                      trailing: Icon(
                        Icons.chevron_right,
                        color: TossColors.gray400,
                        size: TossSpacing.iconSM,
                      ),
                      onTap: () {
                        // Show price book selection
                      },
                    ),
                  ],
                ),
              ),
            ),
            
            SizedBox(height: TossSpacing.space4),

            // Cart Items Section
            Container(
              margin: EdgeInsets.symmetric(horizontal: TossSpacing.space4),
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
                            Icons.shopping_cart_rounded,
                            color: TossColors.primary,
                            size: 20,
                          ),
                          SizedBox(width: TossSpacing.space2),
                          Text(
                            'Cart Items',
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
                              color: TossColors.primary.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(TossBorderRadius.sm),
                            ),
                            child: Text(
                              '$totalItems items',
                              style: TossTextStyles.caption.copyWith(
                                color: TossColors.primary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    // Cart Items List
                    // TODO: Update to work with SalesProduct instead of CartItem
                    // ...cart.asMap().entries.map((entry) {
                    //   final index = entry.key;
                    //   final item = entry.value;
                    //   
                    //   return Column(
                    //     children: [
                    //       _buildInvoiceItem(item, index),
                    //       if (index < cart.length - 1)
                    //         Divider(
                    //           height: 1,
                    //           color: TossColors.gray100,
                    //           indent: TossSpacing.space4 + TossSpacing.space12 + TossSpacing.space2,
                    //           endIndent: TossSpacing.space4,
                    //         ),
                    //     ],
                    //   );
                    // }).toList(),
                  ],
                ),
              ),
            ),
            
            // Bottom padding for floating action area
            SizedBox(height: 140),
          ],
        ),
      ),
      // Fixed Bottom Action Bar
      bottomNavigationBar: Container(
        padding: EdgeInsets.all(TossSpacing.space4),
        decoration: BoxDecoration(
          color: TossColors.surface,
          border: Border(
            top: BorderSide(
              color: TossColors.gray200,
              width: 1,
            ),
          ),
          boxShadow: [
            BoxShadow(
              color: TossColors.black.withValues(alpha: 0.04),
              blurRadius: 8,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: SafeArea(
          top: false,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Subtotal Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Text(
                        'Sub-total',
                        style: TossTextStyles.bodyLarge.copyWith(
                          fontWeight: FontWeight.w600,
                          color: TossColors.gray700,
                        ),
                      ),
                      SizedBox(width: TossSpacing.space2),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: TossSpacing.space2,
                          vertical: TossSpacing.space1,
                        ),
                        decoration: BoxDecoration(
                          color: TossColors.primary.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(TossBorderRadius.full),
                        ),
                        child: Text(
                          '$totalItems',
                          style: TossTextStyles.caption.copyWith(
                            color: TossColors.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Text(
                    '₩${formatter.format(subtotal.round())}',
                    style: TossTextStyles.h4.copyWith(
                      fontWeight: FontWeight.bold,
                      color: TossColors.gray900,
                    ),
                  ),
                ],
              ),
              SizedBox(height: TossSpacing.space3),
              // Action Buttons Row
              Row(
                children: [
                  // Save Draft Button
                  SizedBox(
                    width: 110,
                    child: OutlinedButton(
                      onPressed: () {
                        HapticFeedback.lightImpact();
                        _showSaveConfirmation(context);
                      },
                      style: OutlinedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: TossSpacing.space3),
                        side: BorderSide(
                          color: TossColors.gray300,
                          width: 1,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(TossBorderRadius.button),
                        ),
                      ),
                      child: Text(
                        'Save Draft',
                        style: TossTextStyles.body.copyWith(
                          color: TossColors.gray700,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: TossSpacing.space3),
                  // Continue Button
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        HapticFeedback.lightImpact();
                        context.push('/saleProduct/payment');
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: TossColors.primary,
                        foregroundColor: TossColors.white,
                        padding: EdgeInsets.symmetric(vertical: TossSpacing.space3),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(TossBorderRadius.button),
                        ),
                        elevation: 0,
                      ),
                      child: Text(
                        'Continue to Payment',
                        style: TossTextStyles.body.copyWith(
                          color: TossColors.white,
                          fontWeight: FontWeight.w600,
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
  }

  Widget _buildInvoiceItem(CartItem item, int index) {
    // Keep avatar color for future use
    // final avatarColor = _avatarColors[index % _avatarColors.length];
    
    return InkWell(
      onTap: () {
        // Tap functionality now handled by enhanced quantity selector
      },
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: TossSpacing.space4,
          vertical: TossSpacing.space3,
        ),
        child: Row(
          children: [
            // Product Avatar with quantity badge - matching product page style
            Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  width: TossSpacing.space12,  // 48px
                  height: TossSpacing.space12,  // 48px
                  decoration: BoxDecoration(
                    color: TossColors.gray100,
                    borderRadius: BorderRadius.circular(TossBorderRadius.md),
                  ),
                  child: item.image != null && item.image!.isNotEmpty
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(TossBorderRadius.md),
                          child: _buildProductImage(item.image!),
                        )
                      : Icon(Icons.inventory_2, color: TossColors.gray400, size: TossSpacing.iconMD),
                ),
                // Quantity badge - same as product page
                Positioned(
                  right: -TossSpacing.space2,
                  top: -TossSpacing.space1,
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: item.quantity >= 10 ? TossSpacing.space1 : TossSpacing.space1 + 2,
                      vertical: TossSpacing.space1,
                    ),
                    decoration: BoxDecoration(
                      color: TossColors.primary,
                      borderRadius: BorderRadius.circular(TossBorderRadius.full),
                      border: Border.all(
                        color: TossColors.white,
                        width: 2,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: TossColors.black.withValues(alpha: 0.1),
                          blurRadius: 4,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    constraints: BoxConstraints(
                      minWidth: TossSpacing.space5,
                      minHeight: TossSpacing.space5,
                    ),
                    child: Center(
                      child: Text(
                        '${item.quantity}',
                        style: TossTextStyles.caption.copyWith(
                          color: TossColors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          height: 1,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(width: TossSpacing.space3),
            
            // Product Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.name,
                    style: TossTextStyles.body.copyWith(
                      fontWeight: FontWeight.w600,
                      color: TossColors.gray900,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: TossSpacing.space1),
                  Text(
                    item.sku,
                    style: TossTextStyles.caption.copyWith(
                      color: TossColors.gray500,
                    ),
                  ),
                ],
              ),
            ),
            
            // Price and Controls - matching product page layout
            Container(
              width: 110,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    _formatCurrency(item.subtotal),
                    style: TossTextStyles.bodyLarge.copyWith(
                      fontWeight: FontWeight.w600,
                      color: TossColors.gray900,
                    ),
                  ),
                  SizedBox(height: TossSpacing.space1),
                  // Enhanced quantity selector
                  EnhancedQuantitySelector(
                    quantity: item.quantity,
                    maxQuantity: item.available,
                    compactMode: true,
                    onQuantityChanged: (newQuantity) {
                      if (newQuantity <= 0) {
                        // ref.read(cartProvider.notifier).removeItem(item.id);
                      } else {
                        // ref.read(cartProvider.notifier).updateQuantity(
                        //   item.id,
                        //   newQuantity,
                        // );
                      }
                    },
                    semanticLabel: 'Quantity for ${item.name}',
                    decrementSemanticLabel: 'Decrease ${item.name} quantity',
                    incrementSemanticLabel: 'Increase ${item.name} quantity',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showSaveConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(TossBorderRadius.dialog),
        ),
        title: Text(
          'Save as Draft',
          style: TossTextStyles.h4.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        content: Text(
          'This invoice will be saved as a draft and can be completed later.',
          style: TossTextStyles.body,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: TossTextStyles.body.copyWith(
                color: TossColors.gray600,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
              // Save draft logic here
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: TossColors.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(TossBorderRadius.button),
              ),
            ),
            child: Text(
              'Save',
              style: TossTextStyles.body.copyWith(
                color: TossColors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatCurrency(double value) {
    // Format with commas for exact numbers, no K or M abbreviations
    final formatter = NumberFormat('#,##0', 'en_US');
    
    // For zero values, you can return a dash or just 0
    if (value == 0) {
      return '0';
    }
    
    // Format the value with commas
    String formatted = formatter.format(value.round());
    return formatted;
  }

  String _getProductInitial(String name) {
    if (name.isEmpty) return '?';
    
    // Get first letter of actual product name
    final productName = name.split('-').first.trim();
    
    // Return first non-number character
    for (var char in productName.split('')) {
      if (!RegExp(r'[0-9]').hasMatch(char)) {
        return char.toUpperCase();
      }
    }
    
    return productName[0].toUpperCase();
  }
  
  Widget _buildProductImage(String imageUrl) {
    // Check if it's a valid URL
    if (imageUrl.startsWith('http://') || imageUrl.startsWith('https://')) {
      return Image.network(
        imageUrl,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) =>
            Icon(Icons.inventory_2, color: TossColors.gray400, size: TossSpacing.iconMD),
      );
    }
    // Check if it's an asset path
    else if (imageUrl.startsWith('assets/')) {
      return Image.asset(
        imageUrl,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) =>
            Icon(Icons.inventory_2, color: TossColors.gray400, size: TossSpacing.iconMD),
      );
    }
    // Fallback to icon for invalid paths
    else {
      return Icon(Icons.inventory_2, color: TossColors.gray400, size: TossSpacing.iconMD);
    }
  }
}