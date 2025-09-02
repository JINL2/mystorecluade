import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
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
import '../inventory_management/models/product_model.dart';

class CreateInvoicePage extends ConsumerStatefulWidget {
  const CreateInvoicePage({Key? key}) : super(key: key);

  @override
  ConsumerState<CreateInvoicePage> createState() => _CreateInvoicePageState();
}

class _CreateInvoicePageState extends ConsumerState<CreateInvoicePage> {
  final _formKey = GlobalKey<FormState>();
  final _searchController = TextEditingController();
  final _notesController = TextEditingController();
  
  // Selected products with actual count
  final Map<Product, int> _selectedProducts = {};
  
  // Sample products list (replace with actual data source)
  final List<Product> _allProducts = _generateSampleProducts();
  List<Product> _filteredProducts = [];
  
  bool _isLoading = false;
  DateTime _selectedDate = DateTime.now();
  
  @override
  void initState() {
    super.initState();
    _filteredProducts = _allProducts;
  }
  
  @override
  void dispose() {
    _searchController.dispose();
    _notesController.dispose();
    super.dispose();
  }
  
  void _filterProducts(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredProducts = _allProducts;
      } else {
        _filteredProducts = _allProducts.where((product) {
          final searchLower = query.toLowerCase();
          return product.name.toLowerCase().contains(searchLower) ||
                 product.sku.toLowerCase().contains(searchLower) ||
                 (product.barcode?.toLowerCase().contains(searchLower) ?? false);
        }).toList();
      }
    });
  }
  
  void _updateProductCount(Product product, int count) {
    setState(() {
      if (count > 0) {
        _selectedProducts[product] = count;
      } else {
        _selectedProducts.remove(product);
      }
    });
  }
  
  Future<void> _saveInvoice() async {
    if (_selectedProducts.isEmpty) {
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
      await Future.delayed(const Duration(seconds: 1));
      
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
        primaryActionText: _isLoading ? null : 'Save',
        onPrimaryAction: _isLoading ? null : _saveInvoice,
        leading: IconButton(
          icon: const Icon(Icons.close, size: TossSpacing.iconMD),
          onPressed: () => NavigationHelper.safeGoBack(context),
        ),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            // Invoice Info Section
            _buildInvoiceInfoSection(),
            
            // Search Field
            _buildSearchSection(),
            
            // Selected Products Summary
            if (_selectedProducts.isNotEmpty) _buildSelectedProductsSummary(),
            
            // Product List
            Expanded(
              child: _buildProductList(),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildInvoiceInfoSection() {
    final now = DateTime.now();
    final invoiceId = 'IV${now.year}${now.month.toString().padLeft(2, '0')}${now.day.toString().padLeft(2, '0')}-${(_allProducts.length + 1).toString().padLeft(3, '0')}';
    
    return Container(
      margin: EdgeInsets.all(TossSpacing.space4),
      child: TossWhiteCard(
        padding: EdgeInsets.all(TossSpacing.space4),
        child: Column(
          children: [
            // Invoice ID and Date
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Invoice ID',
                        style: TossTextStyles.caption.copyWith(
                          color: TossColors.gray600,
                        ),
                      ),
                      SizedBox(height: TossSpacing.space1),
                      Text(
                        invoiceId,
                        style: TossTextStyles.body.copyWith(
                          fontWeight: FontWeight.w600,
                          color: TossColors.gray900,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: 1,
                  height: 40,
                  color: TossColors.gray200,
                  margin: EdgeInsets.symmetric(horizontal: TossSpacing.space4),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Date',
                        style: TossTextStyles.caption.copyWith(
                          color: TossColors.gray600,
                        ),
                      ),
                      SizedBox(height: TossSpacing.space1),
                      Text(
                        '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
                        style: TossTextStyles.body.copyWith(
                          fontWeight: FontWeight.w600,
                          color: TossColors.gray900,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            
            SizedBox(height: TossSpacing.space4),
            
            // Notes Field
            TossTextField(
              label: 'Notes (Optional)',
              hintText: 'Add any notes about this inventory count',
              controller: _notesController,
              maxLines: 2,
            ),
          ],
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
  
  Widget _buildSelectedProductsSummary() {
    final totalProducts = _selectedProducts.length;
    final totalItems = _selectedProducts.values.fold(0, (sum, count) => sum + count);
    
    return Container(
      margin: EdgeInsets.all(TossSpacing.space4),
      padding: EdgeInsets.all(TossSpacing.space3),
      decoration: BoxDecoration(
        color: TossColors.primary.withOpacity(0.05),
        borderRadius: BorderRadius.circular(TossBorderRadius.md),
        border: Border.all(
          color: TossColors.primary.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          FaIcon(
            AppIcons.inventory,
            color: TossColors.primary,
            size: TossSpacing.iconSM,
          ),
          SizedBox(width: TossSpacing.space2),
          Text(
            '$totalProducts products',
            style: TossTextStyles.body.copyWith(
              color: TossColors.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(
            ' • ',
            style: TossTextStyles.body.copyWith(
              color: TossColors.primary.withOpacity(0.5),
            ),
          ),
          Text(
            '$totalItems total items',
            style: TossTextStyles.body.copyWith(
              color: TossColors.primary,
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildProductList() {
    if (_filteredProducts.isEmpty) {
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
              'No products found',
              style: TossTextStyles.bodyLarge.copyWith(
                color: TossColors.gray600,
              ),
            ),
          ],
        ),
      );
    }
    
    return ListView.builder(
      padding: EdgeInsets.all(TossSpacing.space4),
      itemCount: _filteredProducts.length,
      itemBuilder: (context, index) {
        final product = _filteredProducts[index];
        final currentCount = _selectedProducts[product] ?? 0;
        
        return Container(
          margin: EdgeInsets.only(bottom: TossSpacing.space3),
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
                  child: product.images.isNotEmpty
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(TossBorderRadius.md),
                          child: Image.network(
                            product.images.first,
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
                        product.name,
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
                          if (product.location != null) ...[
                            Text(
                              ' • ',
                              style: TossTextStyles.caption.copyWith(
                                color: TossColors.gray400,
                              ),
                            ),
                            Text(
                              product.location!,
                              style: TossTextStyles.caption.copyWith(
                                color: TossColors.gray600,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),
                
                // Count Input
                Container(
                  decoration: BoxDecoration(
                    color: currentCount > 0 ? TossColors.primary.withOpacity(0.05) : TossColors.gray50,
                    borderRadius: BorderRadius.circular(TossBorderRadius.md),
                    border: Border.all(
                      color: currentCount > 0 ? TossColors.primary.withOpacity(0.3) : TossColors.gray200,
                      width: 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      // Decrease Button
                      InkWell(
                        onTap: currentCount > 0
                            ? () => _updateProductCount(product, currentCount - 1)
                            : null,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(TossBorderRadius.md),
                          bottomLeft: Radius.circular(TossBorderRadius.md),
                        ),
                        child: Container(
                          padding: EdgeInsets.all(TossSpacing.space2),
                          child: Icon(
                            Icons.remove,
                            size: TossSpacing.iconSM,
                            color: currentCount > 0 ? TossColors.primary : TossColors.gray400,
                          ),
                        ),
                      ),
                      
                      // Count Display
                      Container(
                        width: 50,
                        padding: EdgeInsets.symmetric(vertical: TossSpacing.space2),
                        decoration: BoxDecoration(
                          border: Border(
                            left: BorderSide(
                              color: currentCount > 0 
                                  ? TossColors.primary.withOpacity(0.3) 
                                  : TossColors.gray200,
                              width: 1,
                            ),
                            right: BorderSide(
                              color: currentCount > 0 
                                  ? TossColors.primary.withOpacity(0.3) 
                                  : TossColors.gray200,
                              width: 1,
                            ),
                          ),
                        ),
                        child: Text(
                          currentCount.toString(),
                          style: TossTextStyles.body.copyWith(
                            fontWeight: FontWeight.w600,
                            color: currentCount > 0 ? TossColors.primary : TossColors.gray600,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      
                      // Increase Button
                      InkWell(
                        onTap: () => _updateProductCount(product, currentCount + 1),
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(TossBorderRadius.md),
                          bottomRight: Radius.circular(TossBorderRadius.md),
                        ),
                        child: Container(
                          padding: EdgeInsets.all(TossSpacing.space2),
                          child: Icon(
                            Icons.add,
                            size: TossSpacing.iconSM,
                            color: TossColors.primary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
  
  static List<Product> _generateSampleProducts() {
    return [
      Product(
        id: '1',
        sku: '1194GZ2BA745',
        name: '고야드 가방 - GOYARD Bag',
        category: ProductCategory.accessories,
        productType: ProductType.simple,
        brand: 'GOYARD',
        costPrice: 3500000,
        salePrice: 5100000,
        onHand: 5,
        reorderPoint: 2,
        location: 'A-1-3',
        images: [],
      ),
      Product(
        id: '2',
        sku: '1193GZ2BA744',
        name: '고야드 가방 - GOYARD Bag',
        category: ProductCategory.accessories,
        productType: ProductType.simple,
        brand: 'GOYARD',
        costPrice: 3200000,
        salePrice: 4900000,
        onHand: 0,
        reorderPoint: 3,
        location: 'A-1-4',
        images: [],
      ),
      Product(
        id: '3',
        sku: 'EL001',
        name: 'iPhone 15 Pro Max',
        category: ProductCategory.electronics,
        productType: ProductType.simple,
        brand: 'Apple',
        costPrice: 1200000,
        salePrice: 1590000,
        onHand: 15,
        reorderPoint: 5,
        location: 'B-1-1',
        images: [],
      ),
      Product(
        id: '4',
        sku: 'CL001',
        name: '에르메스 실크 스카프',
        category: ProductCategory.clothing,
        productType: ProductType.simple,
        brand: 'Hermes',
        costPrice: 380000,
        salePrice: 520000,
        onHand: 3,
        reorderPoint: 2,
        location: 'C-1-1',
        images: [],
      ),
      Product(
        id: '5',
        sku: 'SH001',
        name: '로이스 레더 구두',
        category: ProductCategory.shoes,
        productType: ProductType.simple,
        brand: 'Loyce',
        costPrice: 250000,
        salePrice: 380000,
        onHand: 7,
        reorderPoint: 3,
        location: 'D-1-1',
        images: [],
      ),
    ];
  }
}