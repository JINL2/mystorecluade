import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/themes/index.dart';
import '../../../widgets/common/toss_scaffold.dart';
import '../../../helpers/navigation_helper.dart';
import '../models/product_model.dart';
import '../models/sale_model.dart';
import '../widgets/barcode_scanner_sheet.dart';

class CreateSalePage extends ConsumerStatefulWidget {
  final Product? initialProduct;
  
  const CreateSalePage({
    Key? key,
    this.initialProduct,
  }) : super(key: key);

  @override
  ConsumerState<CreateSalePage> createState() => _CreateSalePageState();
}

class _CreateSalePageState extends ConsumerState<CreateSalePage> {
  final _formKey = GlobalKey<FormState>();
  final List<SaleItem> _saleItems = [];
  final _customerNameController = TextEditingController(text: 'Guest');
  final _customerPhoneController = TextEditingController();
  final _notesController = TextEditingController();
  final _discountController = TextEditingController(text: '0');
  final _taxController = TextEditingController(text: '10'); // 10% default tax
  
  PaymentMethod _selectedPaymentMethod = PaymentMethod.cash;
  bool _isProcessing = false;
  
  // Quick add product
  final _searchController = TextEditingController();
  final _barcodeController = TextEditingController();
  List<Product> _searchResults = [];
  bool _isSearching = false;
  
  @override
  void initState() {
    super.initState();
    if (widget.initialProduct != null) {
      _addProductToSale(widget.initialProduct!);
    }
  }

  @override
  void dispose() {
    _customerNameController.dispose();
    _customerPhoneController.dispose();
    _notesController.dispose();
    _discountController.dispose();
    _taxController.dispose();
    _searchController.dispose();
    _barcodeController.dispose();
    super.dispose();
  }

  void _addProductToSale(Product product, {int quantity = 1}) {
    setState(() {
      final existingIndex = _saleItems.indexWhere((item) => item.product.id == product.id);
      
      if (existingIndex != -1) {
        // Update quantity if product already exists
        _saleItems[existingIndex] = _saleItems[existingIndex].copyWith(
          quantity: _saleItems[existingIndex].quantity + quantity,
        );
      } else {
        // Add new item
        _saleItems.add(SaleItem(
          product: product,
          quantity: quantity,
          unitPrice: product.salePrice,
          discount: 0,
          totalPrice: product.salePrice * quantity,
        ));
      }
    });
  }

  void _removeItem(int index) {
    setState(() {
      _saleItems.removeAt(index);
    });
  }

  void _updateItemQuantity(int index, int quantity) {
    if (quantity <= 0) {
      _removeItem(index);
    } else {
      setState(() {
        _saleItems[index] = _saleItems[index].copyWith(quantity: quantity);
      });
    }
  }

  void _updateItemPrice(int index, double price) {
    setState(() {
      _saleItems[index] = _saleItems[index].copyWith(unitPrice: price);
    });
  }


  double get _subtotal {
    return _saleItems.fold(0.0, (sum, item) => sum + item.subtotal);
  }

  double get _discountAmount {
    final discount = double.tryParse(_discountController.text) ?? 0;
    return _subtotal * (discount / 100);
  }

  double get _taxAmount {
    final tax = double.tryParse(_taxController.text) ?? 0;
    return (_subtotal - _discountAmount) * (tax / 100);
  }

  double get _total {
    return _subtotal - _discountAmount + _taxAmount;
  }

  Future<void> _scanBarcode() async {
    final result = await showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      builder: (context) => const BarcodeScannerSheet(),
    );
    
    if (result != null) {
      _searchProductByBarcode(result);
    }
  }

  Future<void> _searchProductByBarcode(String barcode) async {
    // TODO: Search product by barcode from database
    // For now, show not found message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Product with barcode $barcode not found'),
        backgroundColor: TossColors.warning,
      ),
    );
  }

  Future<void> _searchProducts(String query) async {
    if (query.isEmpty) {
      setState(() {
        _searchResults = [];
        _isSearching = false;
      });
      return;
    }

    setState(() => _isSearching = true);

    // TODO: Search products from database
    // For now, use mock data
    await Future.delayed(Duration(milliseconds: 500));
    
    setState(() {
      _searchResults = [
        Product(
          id: '1',
          sku: 'SEARCH001',
          name: 'Search Result Product',
          category: ProductCategory.accessories,
          productType: ProductType.simple,
          costPrice: 100000,
          salePrice: 150000,
          onHand: 10,
        ),
      ];
      _isSearching = false;
    });
  }

  Future<void> _processSale() async {
    if (_saleItems.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please add at least one product'),
          backgroundColor: TossColors.warning,
        ),
      );
      return;
    }

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => _PaymentConfirmationDialog(
        total: _total,
        paymentMethod: _selectedPaymentMethod,
      ),
    );

    if (confirmed != true) return;

    setState(() => _isProcessing = true);

    try {
      // Create sale object
      Sale(
        id: '', // Will be generated by database
        invoiceNumber: _generateInvoiceNumber(),
        saleDate: DateTime.now(),
        customerName: _customerNameController.text.isEmpty 
            ? 'Guest' 
            : _customerNameController.text,
        customerPhone: _customerPhoneController.text.isEmpty 
            ? null 
            : _customerPhoneController.text,
        items: _saleItems,
        subtotal: _subtotal,
        discountAmount: _discountAmount,
        taxAmount: _taxAmount,
        totalAmount: _total,
        paymentMethod: _selectedPaymentMethod,
        status: SaleStatus.completed,
        notes: _notesController.text.isEmpty ? null : _notesController.text,
      );

      // TODO: Save sale to database and update inventory
      await Future.delayed(Duration(seconds: 1)); // Simulate API call

      if (mounted) {
        // Show success and navigate back
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Icon(Icons.check_circle, color: TossColors.white),
                SizedBox(width: TossSpacing.space2),
                Text('Sale completed successfully'),
              ],
            ),
            backgroundColor: TossColors.success,
            action: SnackBarAction(
              label: 'Print Receipt',
              textColor: TossColors.white,
              onPressed: () {
                // TODO: Print receipt
              },
            ),
          ),
        );
        
        NavigationHelper.safeGoBack(context);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error processing sale: $e'),
          backgroundColor: TossColors.error,
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _isProcessing = false);
      }
    }
  }

  String _generateInvoiceNumber() {
    // Generate invoice number based on date and sequence
    final now = DateTime.now();
    final dateStr = '${now.year}${now.month.toString().padLeft(2, '0')}${now.day.toString().padLeft(2, '0')}';
    final sequence = '001'; // TODO: Get from database sequence
    return 'HD$dateStr$sequence';
  }

  @override
  Widget build(BuildContext context) {
    return TossScaffold(
      backgroundColor: TossColors.gray100,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(TossIcons.close),
          onPressed: () => NavigationHelper.safeGoBack(context),
        ),
        title: const Text('New Sale'),
        centerTitle: true,
        backgroundColor: TossColors.gray100,
        foregroundColor: TossColors.black,
        elevation: 0,
        actions: [
          if (_saleItems.isNotEmpty)
            TextButton(
              onPressed: _isProcessing ? null : _processSale,
              child: _isProcessing
                  ? SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation(TossColors.primary),
                      ),
                    )
                  : Text(
                      'Complete',
                      style: TossTextStyles.button.copyWith(
                        color: TossColors.primary,
                      ),
                    ),
            ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            // Quick Add Product Bar
            Container(
              padding: EdgeInsets.all(TossSpacing.space4),
              decoration: BoxDecoration(
                color: TossColors.white,
                boxShadow: [
                  BoxShadow(
                    color: TossColors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _searchController,
                          decoration: InputDecoration(
                            hintText: 'Search product by name or SKU',
                            prefixIcon: Icon(Icons.search),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(TossBorderRadius.lg),
                              borderSide: BorderSide.none,
                            ),
                            filled: true,
                            fillColor: TossColors.gray50,
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: TossSpacing.space3,
                              vertical: TossSpacing.space2,
                            ),
                          ),
                          onChanged: (value) => _searchProducts(value),
                        ),
                      ),
                      SizedBox(width: TossSpacing.space2),
                      IconButton(
                        onPressed: _scanBarcode,
                        icon: Icon(Icons.qr_code_scanner),
                        style: IconButton.styleFrom(
                          backgroundColor: TossColors.primary.withOpacity(0.1),
                          foregroundColor: TossColors.primary,
                        ),
                      ),
                    ],
                  ),
                  
                  // Search Results
                  if (_isSearching)
                    Padding(
                      padding: EdgeInsets.only(top: TossSpacing.space2),
                      child: LinearProgressIndicator(),
                    ),
                  
                  if (_searchResults.isNotEmpty)
                    Container(
                      margin: EdgeInsets.only(top: TossSpacing.space2),
                      constraints: BoxConstraints(maxHeight: 200),
                      decoration: BoxDecoration(
                        color: TossColors.white,
                        borderRadius: BorderRadius.circular(TossBorderRadius.lg),
                        border: Border.all(color: TossColors.gray200),
                      ),
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: _searchResults.length,
                        itemBuilder: (context, index) {
                          final product = _searchResults[index];
                          return ListTile(
                            leading: Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: TossColors.gray100,
                                borderRadius: BorderRadius.circular(TossBorderRadius.md),
                              ),
                              child: Icon(
                                Icons.inventory_2,
                                color: TossColors.gray400,
                                size: TossSpacing.iconSM,
                              ),
                            ),
                            title: Text(product.name),
                            subtitle: Text('${product.sku} • Stock: ${product.onHand}'),
                            trailing: Text(
                              _formatCurrency(product.salePrice),
                              style: TossTextStyles.body.copyWith(
                                fontWeight: FontWeight.w600,
                                color: TossColors.primary,
                              ),
                            ),
                            onTap: () {
                              _addProductToSale(product);
                              _searchController.clear();
                              setState(() => _searchResults = []);
                            },
                          );
                        },
                      ),
                    ),
                ],
              ),
            ),
            
            // Sale Items List
            Expanded(
              child: _saleItems.isEmpty
                  ? _buildEmptyState()
                  : ListView.builder(
                      padding: EdgeInsets.all(TossSpacing.space4),
                      itemCount: _saleItems.length + 1,
                      itemBuilder: (context, index) {
                        if (index == _saleItems.length) {
                          // Customer Info Section
                          return _buildCustomerSection();
                        }
                        return _buildSaleItem(index);
                      },
                    ),
            ),
            
            // Bottom Summary
            if (_saleItems.isNotEmpty)
              _buildSummarySection(),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.shopping_cart_outlined,
            size: TossSpacing.iconXL,
            color: TossColors.gray300,
          ),
          SizedBox(height: TossSpacing.space3),
          Text(
            'No items in cart',
            style: TossTextStyles.bodyLarge.copyWith(
              color: TossColors.gray600,
            ),
          ),
          SizedBox(height: TossSpacing.space2),
          Text(
            'Search or scan products to add',
            style: TossTextStyles.caption.copyWith(
              color: TossColors.gray500,
            ),
          ),
          SizedBox(height: TossSpacing.space4),
          OutlinedButton.icon(
            onPressed: () {
              NavigationHelper.navigateTo(
                context,
                '/inventoryManagement/products',
              );
            },
            icon: Icon(Icons.inventory_2),
            label: Text('Browse Products'),
          ),
        ],
      ),
    );
  }

  Widget _buildSaleItem(int index) {
    final item = _saleItems[index];
    
    return Container(
      margin: EdgeInsets.only(bottom: TossSpacing.space3),
      padding: EdgeInsets.all(TossSpacing.space3),
      decoration: BoxDecoration(
        color: TossColors.white,
        borderRadius: BorderRadius.circular(TossBorderRadius.lg),
        border: Border.all(color: TossColors.gray200),
      ),
      child: Column(
        children: [
          // Product Info Row
          Row(
            children: [
              // Product Image
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: TossColors.gray100,
                  borderRadius: BorderRadius.circular(TossBorderRadius.md),
                ),
                child: item.product.images.isNotEmpty
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(TossBorderRadius.md),
                        child: Image.network(
                          item.product.images.first,
                          fit: BoxFit.cover,
                        ),
                      )
                    : Icon(
                        Icons.inventory_2,
                        color: TossColors.gray400,
                      ),
              ),
              SizedBox(width: TossSpacing.space3),
              
              // Product Details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.product.name,
                      style: TossTextStyles.body.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      item.product.sku,
                      style: TossTextStyles.caption.copyWith(
                        color: TossColors.gray600,
                      ),
                    ),
                  ],
                ),
              ),
              
              // Remove Button
              IconButton(
                onPressed: () => _removeItem(index),
                icon: Icon(TossIcons.close),
                iconSize: 20,
                color: TossColors.gray400,
              ),
            ],
          ),
          
          SizedBox(height: TossSpacing.space3),
          
          // Quantity and Price Row
          Row(
            children: [
              // Quantity Controls
              Container(
                decoration: BoxDecoration(
                  color: TossColors.gray50,
                  borderRadius: BorderRadius.circular(TossBorderRadius.md),
                ),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () => _updateItemQuantity(index, item.quantity - 1),
                      icon: Icon(TossIcons.remove),
                      iconSize: 20,
                      constraints: BoxConstraints(
                        minWidth: 32,
                        minHeight: 32,
                      ),
                    ),
                    Container(
                      width: 50,
                      child: Text(
                        item.quantity.toString(),
                        textAlign: TextAlign.center,
                        style: TossTextStyles.body.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        if (item.quantity < item.product.onHand) {
                          _updateItemQuantity(index, item.quantity + 1);
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Not enough stock available'),
                              backgroundColor: TossColors.warning,
                            ),
                          );
                        }
                      },
                      icon: Icon(TossIcons.add),
                      iconSize: 20,
                      constraints: BoxConstraints(
                        minWidth: 32,
                        minHeight: 32,
                      ),
                    ),
                  ],
                ),
              ),
              
              SizedBox(width: TossSpacing.space3),
              
              // Unit Price
              Expanded(
                child: TextFormField(
                  initialValue: item.unitPrice.toStringAsFixed(0),
                  decoration: InputDecoration(
                    labelText: 'Price',
                    prefixText: '₩',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(TossBorderRadius.md),
                    ),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: TossSpacing.space2,
                      vertical: TossSpacing.space2,
                    ),
                  ),
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  onChanged: (value) {
                    final price = double.tryParse(value) ?? 0;
                    _updateItemPrice(index, price);
                  },
                ),
              ),
              
              SizedBox(width: TossSpacing.space2),
              
              // Subtotal
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: TossSpacing.space3,
                  vertical: TossSpacing.space2,
                ),
                decoration: BoxDecoration(
                  color: TossColors.primary.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(TossBorderRadius.md),
                ),
                child: Column(
                  children: [
                    Text(
                      'Subtotal',
                      style: TossTextStyles.caption.copyWith(
                        color: TossColors.gray600,
                      ),
                    ),
                    Text(
                      _formatCurrency(item.subtotal),
                      style: TossTextStyles.body.copyWith(
                        fontWeight: FontWeight.w700,
                        color: TossColors.primary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          
          // Stock Warning
          if (item.quantity > item.product.onHand)
            Container(
              margin: EdgeInsets.only(top: TossSpacing.space2),
              padding: EdgeInsets.all(TossSpacing.space2),
              decoration: BoxDecoration(
                color: TossColors.error.withOpacity(0.1),
                borderRadius: BorderRadius.circular(TossBorderRadius.md),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.warning_amber,
                    size: TossSpacing.iconXS,
                    color: TossColors.error,
                  ),
                  SizedBox(width: TossSpacing.space1),
                  Text(
                    'Only ${item.product.onHand} units available in stock',
                    style: TossTextStyles.caption.copyWith(
                      color: TossColors.error,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildCustomerSection() {
    return Container(
      margin: EdgeInsets.only(top: TossSpacing.space3),
      padding: EdgeInsets.all(TossSpacing.space3),
      decoration: BoxDecoration(
        color: TossColors.white,
        borderRadius: BorderRadius.circular(TossBorderRadius.lg),
        border: Border.all(color: TossColors.gray200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Customer Information',
            style: TossTextStyles.body.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: TossSpacing.space3),
          
          TextFormField(
            controller: _customerNameController,
            decoration: InputDecoration(
              labelText: 'Customer Name',
              hintText: 'Enter customer name or leave as Guest',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(TossBorderRadius.md),
              ),
              prefixIcon: Icon(TossIcons.person),
            ),
          ),
          
          SizedBox(height: TossSpacing.space2),
          
          TextFormField(
            controller: _customerPhoneController,
            decoration: InputDecoration(
              labelText: 'Phone Number (Optional)',
              hintText: 'Enter phone number',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(TossBorderRadius.md),
              ),
              prefixIcon: Icon(Icons.phone),
            ),
            keyboardType: TextInputType.phone,
          ),
          
          SizedBox(height: TossSpacing.space2),
          
          TextFormField(
            controller: _notesController,
            decoration: InputDecoration(
              labelText: 'Notes (Optional)',
              hintText: 'Add any notes for this sale',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(TossBorderRadius.md),
              ),
              prefixIcon: Icon(Icons.note),
            ),
            maxLines: 2,
          ),
        ],
      ),
    );
  }

  Widget _buildSummarySection() {
    return Container(
      padding: EdgeInsets.all(TossSpacing.space4),
      decoration: BoxDecoration(
        color: TossColors.white,
        boxShadow: [
          BoxShadow(
            color: TossColors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Payment Method
          Row(
            children: [
              Text(
                'Payment Method',
                style: TossTextStyles.body.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              Spacer(),
              ...PaymentMethod.values.map((method) {
                return Padding(
                  padding: EdgeInsets.only(left: TossSpacing.space2),
                  child: ChoiceChip(
                    label: Text(method.displayName),
                    selected: _selectedPaymentMethod == method,
                    onSelected: (selected) {
                      if (selected) {
                        setState(() => _selectedPaymentMethod = method);
                      }
                    },
                    selectedColor: TossColors.primary.withOpacity(0.2),
                  ),
                );
              }).toList(),
            ],
          ),
          
          SizedBox(height: TossSpacing.space3),
          
          // Discount and Tax
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: _discountController,
                  decoration: InputDecoration(
                    labelText: 'Discount %',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(TossBorderRadius.md),
                    ),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: TossSpacing.space2,
                      vertical: TossSpacing.space2,
                    ),
                  ),
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(2),
                  ],
                  onChanged: (_) => setState(() {}),
                ),
              ),
              SizedBox(width: TossSpacing.space2),
              Expanded(
                child: TextFormField(
                  controller: _taxController,
                  decoration: InputDecoration(
                    labelText: 'Tax %',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(TossBorderRadius.md),
                    ),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: TossSpacing.space2,
                      vertical: TossSpacing.space2,
                    ),
                  ),
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(2),
                  ],
                  onChanged: (_) => setState(() {}),
                ),
              ),
            ],
          ),
          
          SizedBox(height: TossSpacing.space3),
          
          // Summary
          Container(
            padding: EdgeInsets.all(TossSpacing.space3),
            decoration: BoxDecoration(
              color: TossColors.gray50,
              borderRadius: BorderRadius.circular(TossBorderRadius.md),
            ),
            child: Column(
              children: [
                _buildSummaryRow('Subtotal', _subtotal),
                if (_discountAmount > 0)
                  _buildSummaryRow(
                    'Discount (${_discountController.text}%)', 
                    -_discountAmount,
                    color: TossColors.success,
                  ),
                if (_taxAmount > 0)
                  _buildSummaryRow(
                    'Tax (${_taxController.text}%)', 
                    _taxAmount,
                  ),
                Divider(height: TossSpacing.space4),
                _buildSummaryRow(
                  'Total',
                  _total,
                  isTotal: true,
                ),
              ],
            ),
          ),
          
          SizedBox(height: TossSpacing.space3),
          
          // Complete Sale Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _isProcessing ? null : _processSale,
              style: ElevatedButton.styleFrom(
                backgroundColor: TossColors.primary,
                padding: EdgeInsets.symmetric(vertical: TossSpacing.space3),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(TossBorderRadius.lg),
                ),
              ),
              child: _isProcessing
                  ? SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation(TossColors.white),
                      ),
                    )
                  : Text(
                      'Complete Sale (${_formatCurrency(_total)})',
                      style: TossTextStyles.button.copyWith(
                        color: TossColors.white,
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String label, double value, {bool isTotal = false, Color? color}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: TossSpacing.space1),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: isTotal
                ? TossTextStyles.bodyLarge.copyWith(
                    fontWeight: FontWeight.w700,
                  )
                : TossTextStyles.bodySmall.copyWith(
                    color: TossColors.gray600,
                  ),
          ),
          Text(
            _formatCurrency(value.abs()),
            style: isTotal
                ? TossTextStyles.h4.copyWith(
                    fontWeight: FontWeight.w700,
                    color: TossColors.primary,
                  )
                : TossTextStyles.body.copyWith(
                    fontWeight: FontWeight.w600,
                    color: color,
                  ),
          ),
        ],
      ),
    );
  }

  String _formatCurrency(double value) {
    if (value >= 1000000) {
      return '₩${(value / 1000000).toStringAsFixed(1)}M';
    } else if (value >= 1000) {
      return '₩${(value / 1000).toStringAsFixed(0)}K';
    }
    return '₩${value.toStringAsFixed(0)}';
  }
}

// Payment Confirmation Dialog
class _PaymentConfirmationDialog extends StatefulWidget {
  final double total;
  final PaymentMethod paymentMethod;

  const _PaymentConfirmationDialog({
    required this.total,
    required this.paymentMethod,
  });

  @override
  State<_PaymentConfirmationDialog> createState() => _PaymentConfirmationDialogState();
}

class _PaymentConfirmationDialogState extends State<_PaymentConfirmationDialog> {
  final _receivedController = TextEditingController();
  
  double get _received {
    return double.tryParse(_receivedController.text) ?? 0;
  }
  
  double get _change {
    return _received - widget.total;
  }

  @override
  void initState() {
    super.initState();
    if (widget.paymentMethod == PaymentMethod.cash) {
      _receivedController.text = widget.total.toStringAsFixed(0);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Payment Confirmation'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: EdgeInsets.all(TossSpacing.space3),
            decoration: BoxDecoration(
              color: TossColors.primary.withOpacity(0.05),
              borderRadius: BorderRadius.circular(TossBorderRadius.lg),
            ),
            child: Column(
              children: [
                Text(
                  'Total Amount',
                  style: TossTextStyles.caption.copyWith(
                    color: TossColors.gray600,
                  ),
                ),
                SizedBox(height: TossSpacing.space1),
                Text(
                  '₩${widget.total.toStringAsFixed(0)}',
                  style: TossTextStyles.h3.copyWith(
                    fontWeight: FontWeight.w700,
                    color: TossColors.primary,
                  ),
                ),
              ],
            ),
          ),
          
          if (widget.paymentMethod == PaymentMethod.cash) ...[
            SizedBox(height: TossSpacing.space3),
            TextField(
              controller: _receivedController,
              decoration: InputDecoration(
                labelText: 'Amount Received',
                prefixText: '₩',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(TossBorderRadius.md),
                ),
              ),
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              onChanged: (_) => setState(() {}),
              autofocus: true,
            ),
            
            if (_change != 0) ...[
              SizedBox(height: TossSpacing.space2),
              Container(
                padding: EdgeInsets.all(TossSpacing.space2),
                decoration: BoxDecoration(
                  color: _change >= 0 ? TossColors.success.withOpacity(0.1) : TossColors.error.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(TossBorderRadius.md),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      _change >= 0 ? 'Change: ' : 'Short: ',
                      style: TossTextStyles.body,
                    ),
                    Text(
                      '₩${_change.abs().toStringAsFixed(0)}',
                      style: TossTextStyles.bodyLarge.copyWith(
                        fontWeight: FontWeight.w700,
                        color: _change >= 0 ? TossColors.success : TossColors.error,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
          
          SizedBox(height: TossSpacing.space3),
          
          Row(
            children: [
              Icon(
                widget.paymentMethod.icon,
                color: TossColors.gray600,
              ),
              SizedBox(width: TossSpacing.space2),
              Text(
                'Payment Method: ${widget.paymentMethod.displayName}',
                style: TossTextStyles.body,
              ),
            ],
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: widget.paymentMethod == PaymentMethod.cash && _change < 0
              ? null
              : () => Navigator.pop(context, true),
          style: ElevatedButton.styleFrom(
            backgroundColor: TossColors.primary,
          ),
          child: Text('Confirm Payment'),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _receivedController.dispose();
    super.dispose();
  }
}