import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import '../../../core/constants/app_icons_fa.dart';
import '../../../core/themes/toss_colors.dart';
import '../../../core/themes/toss_text_styles.dart';
import '../../../core/themes/toss_spacing.dart';
import '../../../core/themes/toss_border_radius.dart';
import '../../widgets/common/toss_scaffold.dart';
import '../../widgets/common/toss_app_bar.dart';
import '../../widgets/common/toss_white_card.dart';
import '../../widgets/toss/toss_text_field.dart';
import '../../widgets/toss/toss_search_field.dart';
import '../../helpers/navigation_helper.dart';
import 'models/invoice_models.dart';
import 'providers/invoice_provider.dart';
import 'payment_method_page.dart';

class CreateInvoicePage extends ConsumerStatefulWidget {
  const CreateInvoicePage({Key? key}) : super(key: key);

  @override
  ConsumerState<CreateInvoicePage> createState() => _CreateInvoicePageState();
}

class _CreateInvoicePageState extends ConsumerState<CreateInvoicePage> {
  final _formKey = GlobalKey<FormState>();
  final _searchController = TextEditingController();
  final currencyFormat = NumberFormat.currency(symbol: '', decimalDigits: 0);
  
  bool _isLoading = false;
  
  @override
  void initState() {
    super.initState();
    // Initialize products load when page loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(createInvoiceProvider.notifier).loadProducts();
    });
  }
  
  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
  
  void _filterProducts(String query) {
    ref.read(createInvoiceProvider.notifier).searchProducts(query);
  }
  
  void _updateProductCount(SalesProduct product, int count) {
    print('🔧 [CREATE_INVOICE] Updating product count: ${product.productName} → $count');
    print('🔧 [CREATE_INVOICE] Product ID: ${product.productId}');
    print('🔧 [CREATE_INVOICE] Available stock: ${product.availableQuantity}');
    ref.read(createInvoiceProvider.notifier).updateProductCount(product, count);
  }
  
  Future<void> _saveInvoice() async {
    final createInvoiceState = ref.read(createInvoiceProvider);
    
    if (createInvoiceState.selectedProducts.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please add at least one product'),
          backgroundColor: TossColors.error,
        ),
      );
      return;
    }
    
    setState(() => _isLoading = true);
    
    try {
      // TODO: Implement actual save logic
      await Future<void>.delayed(const Duration(seconds: 1));
      
      if (mounted) {
        NavigationHelper.safeGoBack(context);
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return TossScaffold(
      backgroundColor: TossColors.gray100,
      appBar: TossAppBar(
        title: 'Create Invoice',
        backgroundColor: TossColors.gray100,
        leading: IconButton(
          icon: const Icon(Icons.close, size: TossSpacing.iconMD),
          onPressed: () => NavigationHelper.safeGoBack(context),
        ),
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Search Field
              _buildSearchSection(),
              
              // Added Items Section
              Consumer(
                builder: (context, ref, child) {
                  final createInvoiceState = ref.watch(createInvoiceProvider);
                  if (createInvoiceState.selectedProducts.isNotEmpty) {
                    return _buildAddedItemsSection();
                  }
                  return const SizedBox.shrink();
                },
              ),
              
              // Product List with bottom padding for button
              Expanded(
                child: Container(
                  padding: EdgeInsets.only(bottom: 80), // Space for bottom button
                  child: _buildProductList(),
                ),
              ),
              
              // Fixed Bottom Button
              _buildBottomButton(),
            ],
          ),
        ),
      ),
    );
  }
  
  
  Widget _buildSearchSection() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: TossSpacing.space4),
      child: TossSearchField(
        controller: _searchController,
        hintText: 'Search products to add...',
        onChanged: _filterProducts,
      ),
    );
  }
  
  Widget _buildAddedItemsSection() {
    final createInvoiceState = ref.watch(createInvoiceProvider);
    final selectedProducts = createInvoiceState.selectedProducts;
    final totalItems = createInvoiceState.totalSelectedItems;
    
    if (selectedProducts.isEmpty) return const SizedBox.shrink();
    
    // Get selected product details
    final selectedProductsList = <SalesProduct>[];
    if (createInvoiceState.productData != null) {
      for (final productId in selectedProducts.keys) {
        try {
          final product = createInvoiceState.productData!.products
              .firstWhere((p) => p.productId == productId);
          selectedProductsList.add(product);
        } catch (e) {
          // Product not found, skip it
          print('Warning: Product with ID $productId not found in product list');
        }
      }
    }
    
    return Container(
      margin: EdgeInsets.all(TossSpacing.space4),
      child: TossWhiteCard(
        padding: EdgeInsets.all(TossSpacing.space4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                FaIcon(
                  AppIcons.cart,
                  color: TossColors.primary,
                  size: TossSpacing.iconSM,
                ),
                SizedBox(width: TossSpacing.space2),
                Text(
                  'Added Items',
                  style: TossTextStyles.bodyLarge.copyWith(
                    color: TossColors.gray900,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Spacer(),
                Text(
                  '$totalItems items',
                  style: TossTextStyles.caption.copyWith(
                    color: TossColors.gray600,
                  ),
                ),
              ],
            ),
            
            SizedBox(height: TossSpacing.space3),
            
            // Selected Products List
            ...selectedProductsList.map((product) {
              final quantity = selectedProducts[product.productId] ?? 0;
              return Container(
                margin: EdgeInsets.only(bottom: TossSpacing.space2),
                padding: EdgeInsets.all(TossSpacing.space3),
                decoration: BoxDecoration(
                  color: TossColors.primary.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(TossBorderRadius.sm),
                  border: Border.all(
                    color: TossColors.primary.withOpacity(0.1),
                    width: 1,
                  ),
                ),
                child: Row(
                  children: [
                    // Product Image
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: TossColors.gray100,
                        borderRadius: BorderRadius.circular(TossBorderRadius.sm),
                      ),
                      child: product.images.mainImage != null
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(TossBorderRadius.sm),
                              child: Image.network(
                                product.images.mainImage!,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) =>
                                    Icon(Icons.inventory_2, color: TossColors.gray400, size: 20),
                              ),
                            )
                          : Icon(Icons.inventory_2, color: TossColors.gray400, size: 20),
                    ),
                    
                    SizedBox(width: TossSpacing.space3),
                    
                    // Product Info
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            product.productName,
                            style: TossTextStyles.body.copyWith(
                              fontWeight: FontWeight.w600,
                              color: TossColors.gray900,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: TossSpacing.space1),
                          Text(
                            product.sku,
                            style: TossTextStyles.caption.copyWith(
                              color: TossColors.gray600,
                            ),
                          ),
                          SizedBox(height: TossSpacing.space1),
                          Row(
                            children: [
                              if (product.sellingPrice != null && product.sellingPrice! > 0) ...[
                                Text(
                                  '${createInvoiceState.productData?.company.currency.symbol ?? ''}${currencyFormat.format(product.sellingPrice!)}',
                                  style: TossTextStyles.caption.copyWith(
                                    color: TossColors.primary,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Text(
                                  ' × $quantity',
                                  style: TossTextStyles.caption.copyWith(
                                    color: TossColors.gray600,
                                  ),
                                ),
                                Text(
                                  ' = ',
                                  style: TossTextStyles.caption.copyWith(
                                    color: TossColors.gray400,
                                  ),
                                ),
                                Text(
                                  '${createInvoiceState.productData?.company.currency.symbol ?? ''}${currencyFormat.format(product.sellingPrice! * quantity)}',
                                  style: TossTextStyles.caption.copyWith(
                                    color: TossColors.gray900,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ] else ...[
                                Text(
                                  'Price not set',
                                  style: TossTextStyles.caption.copyWith(
                                    color: TossColors.gray500,
                                    fontStyle: FontStyle.italic,
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ],
                      ),
                    ),
                    
                    // Quantity Controls
                    Container(
                      decoration: BoxDecoration(
                        color: TossColors.white,
                        borderRadius: BorderRadius.circular(TossBorderRadius.sm),
                        border: Border.all(
                          color: TossColors.primary.withOpacity(0.2),
                          width: 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          // Decrease Button
                          InkWell(
                            onTap: quantity > 0
                                ? () => _updateProductCount(product, quantity - 1)
                                : null,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(TossBorderRadius.sm),
                              bottomLeft: Radius.circular(TossBorderRadius.sm),
                            ),
                            child: Container(
                              padding: EdgeInsets.all(TossSpacing.space2),
                              child: Icon(
                                Icons.remove,
                                size: 16,
                                color: quantity > 0 ? TossColors.primary : TossColors.gray400,
                              ),
                            ),
                          ),
                          
                          // Quantity Display
                          Container(
                            width: 40,
                            padding: EdgeInsets.symmetric(vertical: TossSpacing.space2),
                            decoration: BoxDecoration(
                              border: Border(
                                left: BorderSide(
                                  color: TossColors.primary.withOpacity(0.2),
                                  width: 1,
                                ),
                                right: BorderSide(
                                  color: TossColors.primary.withOpacity(0.2),
                                  width: 1,
                                ),
                              ),
                            ),
                            child: Text(
                              quantity.toString(),
                              style: TossTextStyles.body.copyWith(
                                fontWeight: FontWeight.w600,
                                color: TossColors.primary,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          
                          // Increase Button
                          InkWell(
                            onTap: () {
                              print('🔧 [ADDED_ITEMS] + button clicked for: ${product.productName}');
                              _updateProductCount(product, quantity + 1);
                            },
                            borderRadius: BorderRadius.only(
                              topRight: Radius.circular(TossBorderRadius.sm),
                              bottomRight: Radius.circular(TossBorderRadius.sm),
                            ),
                            child: Container(
                              padding: EdgeInsets.all(TossSpacing.space2),
                              child: Icon(
                                Icons.add,
                                size: 16,
                                color: TossColors.primary,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    SizedBox(width: TossSpacing.space2),
                    
                    // Remove Button
                    InkWell(
                      onTap: () => _updateProductCount(product, 0),
                      child: Container(
                        padding: EdgeInsets.all(TossSpacing.space2),
                        decoration: BoxDecoration(
                          color: TossColors.error.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(TossBorderRadius.sm),
                        ),
                        child: Icon(
                          Icons.close,
                          size: 16,
                          color: TossColors.error,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
            
            // Total Summary
            if (selectedProductsList.isNotEmpty) ...[
              SizedBox(height: TossSpacing.space3),
              Container(
                padding: EdgeInsets.all(TossSpacing.space3),
                decoration: BoxDecoration(
                  color: TossColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(TossBorderRadius.sm),
                  border: Border.all(
                    color: TossColors.primary.withOpacity(0.2),
                    width: 1,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Total',
                      style: TossTextStyles.bodyLarge.copyWith(
                        fontWeight: FontWeight.w600,
                        color: TossColors.gray900,
                      ),
                    ),
                    Text(
                      '${createInvoiceState.productData?.company.currency.symbol ?? ''}${currencyFormat.format(_calculateTotalAmount(selectedProductsList, selectedProducts))}',
                      style: TossTextStyles.h3.copyWith(
                        fontWeight: FontWeight.w700,
                        color: TossColors.primary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
  
  Widget _buildProductList() {
    return Consumer(
      builder: (context, ref, child) {
        final createInvoiceState = ref.watch(createInvoiceProvider);
        
        // Show loading state
        if (createInvoiceState.isLoading) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(color: TossColors.primary),
                SizedBox(height: TossSpacing.space3),
                Text(
                  'Loading products...',
                  style: TossTextStyles.body.copyWith(
                    color: TossColors.gray600,
                  ),
                ),
              ],
            ),
          );
        }
        
        // Show error state
        if (createInvoiceState.error != null) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.error_outline,
                  size: 64,
                  color: TossColors.error,
                ),
                SizedBox(height: TossSpacing.space3),
                Text(
                  createInvoiceState.error!,
                  style: TossTextStyles.bodyLarge.copyWith(
                    color: TossColors.error,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: TossSpacing.space3),
                ElevatedButton(
                  onPressed: () => ref.read(createInvoiceProvider.notifier).refresh(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: TossColors.primary,
                    foregroundColor: TossColors.white,
                  ),
                  child: Text('Retry'),
                ),
              ],
            ),
          );
        }
        
        // Show empty state
        if (createInvoiceState.sortedFilteredProducts.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.search_off,
                  size: 64,
                  color: TossColors.gray400,
                ),
                SizedBox(height: TossSpacing.space3),
                Text(
                  createInvoiceState.searchQuery.isNotEmpty 
                      ? 'No products found for "${createInvoiceState.searchQuery}"'
                      : 'No products available',
                  style: TossTextStyles.bodyLarge.copyWith(
                    color: TossColors.gray600,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        }
        
        return ListView.builder(
          padding: EdgeInsets.all(TossSpacing.space4),
          itemCount: createInvoiceState.sortedFilteredProducts.length,
          itemBuilder: (context, index) {
            final product = createInvoiceState.sortedFilteredProducts[index];
            
            return Container(
              margin: EdgeInsets.only(bottom: TossSpacing.space3),
              child: InkWell(
                onTap: () {
                  print('🔧 [CREATE_INVOICE] Product card clicked: ${product.productName}');
                  final currentCount = ref.read(createInvoiceProvider.notifier).getProductCount(product.productId);
                  _updateProductCount(product, currentCount + 1);
                },
                borderRadius: BorderRadius.circular(TossBorderRadius.md),
                child: TossWhiteCard(
                  padding: EdgeInsets.all(TossSpacing.space3),
                  child: Row(
                    children: [
                      // Product Image
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: TossColors.gray100,
                          borderRadius: BorderRadius.circular(TossBorderRadius.md),
                        ),
                        child: product.images.mainImage != null
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(TossBorderRadius.md),
                                child: Image.network(
                                  product.images.mainImage!,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) =>
                                      Icon(Icons.inventory_2, color: TossColors.gray400, size: 24),
                                ),
                              )
                            : Icon(Icons.inventory_2, color: TossColors.gray400, size: 24),
                      ),
                      
                      SizedBox(width: TossSpacing.space3),
                      
                      // Product Info
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              product.productName,
                              style: TossTextStyles.body.copyWith(
                                fontWeight: FontWeight.w600,
                                color: TossColors.gray900,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            SizedBox(height: TossSpacing.space1),
                            Row(
                              children: [
                                Text(
                                  product.sku,
                                  style: TossTextStyles.caption.copyWith(
                                    color: TossColors.gray600,
                                  ),
                                ),
                                if (product.firstStoreStock?.storeName != null) ...[
                                  Text(
                                    ' • ',
                                    style: TossTextStyles.caption.copyWith(
                                      color: TossColors.gray400,
                                    ),
                                  ),
                                  Text(
                                    '${product.availableQuantity} available',
                                    style: TossTextStyles.caption.copyWith(
                                      color: product.hasAvailableStock 
                                          ? TossColors.success 
                                          : TossColors.error,
                                    ),
                                  ),
                                ],
                              ],
                            ),
                            SizedBox(height: TossSpacing.space1),
                            // Product Price
                            Consumer(
                              builder: (context, ref, child) {
                                final createInvoiceState = ref.watch(createInvoiceProvider);
                                final currency = createInvoiceState.productData?.company.currency;
                                final price = product.sellingPrice;
                                
                                if (price != null && price > 0) {
                                  return Text(
                                    '${currency?.symbol ?? ''}${currencyFormat.format(price)}',
                                    style: TossTextStyles.body.copyWith(
                                      color: TossColors.primary,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  );
                                } else {
                                  return Text(
                                    'Price not set',
                                    style: TossTextStyles.caption.copyWith(
                                      color: TossColors.gray500,
                                      fontStyle: FontStyle.italic,
                                    ),
                                  );
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                      
                      // Add indicator icon for selected items
                      Consumer(
                        builder: (context, ref, child) {
                          final currentCount = ref.watch(createInvoiceProvider.notifier).getProductCount(product.productId);
                          if (currentCount > 0) {
                            return Container(
                              padding: EdgeInsets.all(TossSpacing.space2),
                              decoration: BoxDecoration(
                                color: TossColors.primary,
                                borderRadius: BorderRadius.circular(TossBorderRadius.sm),
                              ),
                              child: Text(
                                currentCount.toString(),
                                style: TossTextStyles.caption.copyWith(
                                  color: TossColors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            );
                          }
                          return Icon(
                            Icons.add_circle_outline,
                            color: TossColors.primary,
                            size: TossSpacing.iconMD,
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
  
  Widget _buildBottomButton() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(TossSpacing.space4),
      decoration: BoxDecoration(
        color: TossColors.white,
        boxShadow: [
          BoxShadow(
            color: TossColors.gray300.withOpacity(0.3),
            offset: Offset(0, -2),
            blurRadius: 8,
            spreadRadius: 0,
          ),
        ],
      ),
      child: Consumer(
        builder: (context, ref, child) {
          final createInvoiceState = ref.watch(createInvoiceProvider);
          final hasSelectedItems = createInvoiceState.selectedProducts.isNotEmpty;
          
          return ElevatedButton(
            onPressed: hasSelectedItems ? _proceedToNext : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: hasSelectedItems ? TossColors.primary : TossColors.gray300,
              foregroundColor: TossColors.white,
              padding: EdgeInsets.symmetric(vertical: TossSpacing.space3),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(TossBorderRadius.md),
              ),
              elevation: 0,
            ),
            child: Text(
              'Next',
              style: TossTextStyles.bodyLarge.copyWith(
                fontWeight: FontWeight.w600,
                color: TossColors.white,
              ),
            ),
          );
        },
      ),
    );
  }
  
  // Calculate total amount for selected products
  double _calculateTotalAmount(List<SalesProduct> selectedProducts, Map<String, int> quantities) {
    double total = 0.0;
    for (final product in selectedProducts) {
      final quantity = quantities[product.productId] ?? 0;
      final price = product.sellingPrice ?? 0.0;
      total += price * quantity;
    }
    return total;
  }

  void _proceedToNext() {
    final createInvoiceState = ref.read(createInvoiceProvider);
    
    if (createInvoiceState.selectedProducts.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please add at least one product'),
          backgroundColor: TossColors.error,
        ),
      );
      return;
    }
    
    print('🚀 [CREATE_INVOICE] Proceeding to next step with ${createInvoiceState.totalSelectedItems} items');
    print('📦 [CREATE_INVOICE] Selected products: ${createInvoiceState.selectedProducts}');
    
    // Get selected products and their quantities
    final selectedProducts = <SalesProduct>[];
    final productQuantities = Map<String, int>.from(createInvoiceState.selectedProducts);
    
    if (createInvoiceState.productData != null) {
      for (final productId in createInvoiceState.selectedProducts.keys) {
        try {
          final product = createInvoiceState.productData!.products
              .firstWhere((p) => p.productId == productId);
          selectedProducts.add(product);
        } catch (e) {
          print('Warning: Product with ID $productId not found in product list');
        }
      }
    }
    
    // Navigate to payment method selection page
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => PaymentMethodPage(
          selectedProducts: selectedProducts,
          productQuantities: productQuantities,
        ),
      ),
    );
  }
  
}