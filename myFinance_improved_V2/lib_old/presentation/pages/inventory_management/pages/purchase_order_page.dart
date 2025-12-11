import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/themes/index.dart';
import '../../../widgets/common/toss_scaffold.dart';
import '../../../helpers/navigation_helper.dart';
import '../models/product_model.dart';
import '../models/purchase_order_model.dart';
import 'package:intl/intl.dart';
import 'package:myfinance_improved/core/themes/toss_border_radius.dart';
class PurchaseOrderPage extends ConsumerStatefulWidget {
  final PurchaseOrder? existingOrder;
  
  const PurchaseOrderPage({
    Key? key,
    this.existingOrder,
  }) : super(key: key);

  @override
  ConsumerState<PurchaseOrderPage> createState() => _PurchaseOrderPageState();
}

class _PurchaseOrderPageState extends ConsumerState<PurchaseOrderPage> 
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _formKey = GlobalKey<FormState>();
  
  // Controllers
  final _supplierNameController = TextEditingController();
  final _supplierContactController = TextEditingController();
  final _supplierEmailController = TextEditingController();
  final _notesController = TextEditingController();
  final _searchController = TextEditingController();
  
  // Order Items
  final List<PurchaseOrderItem> _orderItems = [];
  Supplier? _selectedSupplier;
  OrderStatus _orderStatus = OrderStatus.draft;
  DateTime _expectedDelivery = DateTime.now().add(Duration(days: 7));
  PaymentTerms _paymentTerms = PaymentTerms.net30;
  
  bool _isProcessing = false;
  String _orderNumber = '';
  
  // Calculations
  double get _subtotal => _orderItems.fold(0.0, (sum, item) => sum + item.subtotal);
  double get _taxAmount => _subtotal * 0.1; // 10% tax
  double get _shippingCost => _orderItems.isNotEmpty ? 50000 : 0; // Fixed shipping
  double get _totalAmount => _subtotal + _taxAmount + _shippingCost;
  int get _totalItems => _orderItems.fold(0, (sum, item) => sum + item.quantity);
  
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _generateOrderNumber();
    
    if (widget.existingOrder != null) {
      _loadExistingOrder();
    }
  }
  
  @override
  void dispose() {
    _tabController.dispose();
    _supplierNameController.dispose();
    _supplierContactController.dispose();
    _supplierEmailController.dispose();
    _notesController.dispose();
    _searchController.dispose();
    super.dispose();
  }
  
  void _generateOrderNumber() {
    final now = DateTime.now();
    _orderNumber = 'PO${now.year}${now.month.toString().padLeft(2, '0')}${now.day.toString().padLeft(2, '0')}-${now.millisecondsSinceEpoch.toString().substring(8)}';
  }
  
  void _loadExistingOrder() {
    final order = widget.existingOrder!;
    _orderNumber = order.orderNumber;
    _selectedSupplier = order.supplier;
    _supplierNameController.text = order.supplier.name;
    _supplierContactController.text = order.supplier.contact ?? '';
    _supplierEmailController.text = order.supplier.email ?? '';
    _orderItems.addAll(order.items);
    _orderStatus = order.status;
    _expectedDelivery = order.expectedDelivery;
    _paymentTerms = order.paymentTerms;
    _notesController.text = order.notes ?? '';
  }
  
  Future<void> _selectSupplier() async {
    // TODO: Show supplier selection dialog
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => _SupplierSelectionSheet(
        onSelected: (supplier) {
          setState(() {
            _selectedSupplier = supplier;
            _supplierNameController.text = supplier.name;
            _supplierContactController.text = supplier.contact ?? '';
            _supplierEmailController.text = supplier.email ?? '';
          });
          Navigator.pop(context);
        },
      ),
    );
  }
  
  Future<void> _addProductToOrder() async {
    // TODO: Show product selection dialog
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => _ProductSelectionSheet(
        onSelected: (product, quantity, unitCost) {
          setState(() {
            final existingIndex = _orderItems.indexWhere((item) => item.product.id == product.id);
            
            if (existingIndex != -1) {
              // Update existing item
              _orderItems[existingIndex] = PurchaseOrderItem(
                product: product,
                quantity: _orderItems[existingIndex].quantity + quantity,
                unitCost: unitCost,
              );
            } else {
              // Add new item
              _orderItems.add(PurchaseOrderItem(
                product: product,
                quantity: quantity,
                unitCost: unitCost,
              ));
            }
          });
          Navigator.pop(context);
        },
      ),
    );
  }
  
  void _removeOrderItem(int index) {
    setState(() {
      _orderItems.removeAt(index);
    });
  }
  
  void _updateItemQuantity(int index, int quantity) {
    if (quantity <= 0) {
      _removeOrderItem(index);
    } else {
      setState(() {
        _orderItems[index] = PurchaseOrderItem(
          product: _orderItems[index].product,
          quantity: quantity,
          unitCost: _orderItems[index].unitCost,
        );
      });
    }
  }
  
  void _updateItemCost(int index, double cost) {
    setState(() {
      _orderItems[index] = PurchaseOrderItem(
        product: _orderItems[index].product,
        quantity: _orderItems[index].quantity,
        unitCost: cost,
      );
    });
  }
  
  Future<void> _selectExpectedDelivery() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _expectedDelivery,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: TossColors.primary,
            ),
          ),
          child: child!,
        );
      },
    );
    
    if (picked != null) {
      setState(() {
        _expectedDelivery = picked;
      });
    }
  }
  
  Future<void> _submitOrder() async {
    if (!_formKey.currentState!.validate()) return;
    if (_orderItems.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please add at least one product'),
          backgroundColor: TossColors.warning,
        ),
      );
      return;
    }
    
    setState(() => _isProcessing = true);
    
    try {
      // Create purchase order
      PurchaseOrder(
        id: DateTime.now().toString(),
        orderNumber: _orderNumber,
        supplier: Supplier(
          id: _selectedSupplier?.id ?? '',
          name: _supplierNameController.text,
          contact: _supplierContactController.text,
          email: _supplierEmailController.text,
        ),
        items: _orderItems,
        subtotal: _subtotal,
        taxAmount: _taxAmount,
        shippingCost: _shippingCost,
        totalAmount: _totalAmount,
        status: _orderStatus,
        orderDate: DateTime.now(),
        expectedDelivery: _expectedDelivery,
        paymentTerms: _paymentTerms,
        notes: _notesController.text.isEmpty ? null : _notesController.text,
      );
      
      // TODO: Save to database
      await Future.delayed(Duration(seconds: 1));
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Purchase order created successfully'),
            backgroundColor: TossColors.success,
            action: SnackBarAction(
              label: 'View',
              textColor: TossColors.white,
              onPressed: () {
                // TODO: Navigate to order details
              },
            ),
          ),
        );
        
        NavigationHelper.safeGoBack(context);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error creating order: $e'),
          backgroundColor: TossColors.error,
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _isProcessing = false);
      }
    }
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
        title: Text(widget.existingOrder != null ? 'Edit Order' : 'New Purchase Order'),
        centerTitle: true,
        backgroundColor: TossColors.gray100,
        foregroundColor: TossColors.black,
        elevation: 0,
        actions: [
          if (_orderStatus == OrderStatus.draft)
            TextButton(
              onPressed: _isProcessing ? null : _submitOrder,
              child: Text(
                'Submit',
                style: TossTextStyles.body.copyWith(
                  color: TossColors.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
        ],
        bottom: TabBar(
          controller: _tabController,
          labelColor: TossColors.primary,
          unselectedLabelColor: TossColors.gray600,
          indicatorColor: TossColors.primary,
          tabs: [
            Tab(text: 'Supplier'),
            Tab(text: 'Products'),
            Tab(text: 'Summary'),
          ],
        ),
      ),
      body: Form(
        key: _formKey,
        child: TabBarView(
          controller: _tabController,
          children: [
            _buildSupplierTab(),
            _buildProductsTab(),
            _buildSummaryTab(),
          ],
        ),
      ),
    );
  }
  
  Widget _buildSupplierTab() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(TossSpacing.space4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Order Info Card
          Container(
            padding: EdgeInsets.all(TossSpacing.space3),
            decoration: BoxDecoration(
              color: TossColors.primary.withOpacity(0.05),
              borderRadius: BorderRadius.circular(TossBorderRadius.lg),
              border: Border.all(color: TossColors.primary.withOpacity(0.2)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Order Number',
                          style: TossTextStyles.caption.copyWith(
                            color: TossColors.gray600,
                          ),
                        ),
                        Text(
                          _orderNumber,
                          style: TossTextStyles.body.copyWith(
                            fontWeight: FontWeight.w700,
                            fontFamily: 'monospace',
                          ),
                        ),
                      ],
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: TossSpacing.space2,
                        vertical: TossSpacing.space1,
                      ),
                      decoration: BoxDecoration(
                        color: _getStatusColor(_orderStatus).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(TossBorderRadius.md),
                      ),
                      child: Text(
                        _orderStatus.displayName,
                        style: TossTextStyles.caption.copyWith(
                          color: _getStatusColor(_orderStatus),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          SizedBox(height: TossSpacing.space4),
          
          // Supplier Selection
          Text(
            'Supplier Information',
            style: TossTextStyles.bodyLarge.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: TossSpacing.space3),
          
          // Quick Select Button
          OutlinedButton.icon(
            onPressed: _selectSupplier,
            icon: Icon(TossIcons.business),
            label: Text('Select from Existing Suppliers'),
            style: OutlinedButton.styleFrom(
              minimumSize: Size(double.infinity, TossSpacing.buttonHeightLG),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(TossBorderRadius.lg),
              ),
            ),
          ),
          
          SizedBox(height: TossSpacing.space3),
          
          // Supplier Name
          TextFormField(
            controller: _supplierNameController,
            decoration: InputDecoration(
              labelText: 'Supplier Name *',
              hintText: 'Enter supplier company name',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(TossBorderRadius.lg),
              ),
              prefixIcon: Icon(TossIcons.store),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Supplier name is required';
              }
              return null;
            },
          ),
          
          SizedBox(height: TossSpacing.space3),
          
          // Contact Person
          TextFormField(
            controller: _supplierContactController,
            decoration: InputDecoration(
              labelText: 'Contact Person',
              hintText: 'Enter contact person name',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(TossBorderRadius.lg),
              ),
              prefixIcon: Icon(TossIcons.person),
            ),
          ),
          
          SizedBox(height: TossSpacing.space3),
          
          // Email
          TextFormField(
            controller: _supplierEmailController,
            decoration: InputDecoration(
              labelText: 'Email',
              hintText: 'supplier@example.com',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(TossBorderRadius.lg),
              ),
              prefixIcon: Icon(Icons.email),
            ),
            keyboardType: TextInputType.emailAddress,
            validator: (value) {
              if (value != null && value.isNotEmpty) {
                if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                  return 'Please enter a valid email';
                }
              }
              return null;
            },
          ),
          
          SizedBox(height: TossSpacing.space4),
          
          // Delivery & Payment
          Text(
            'Delivery & Payment',
            style: TossTextStyles.bodyLarge.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: TossSpacing.space3),
          
          // Expected Delivery
          InkWell(
            onTap: _selectExpectedDelivery,
            borderRadius: BorderRadius.circular(TossBorderRadius.lg),
            child: InputDecorator(
              decoration: InputDecoration(
                labelText: 'Expected Delivery Date',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(TossBorderRadius.lg),
                ),
                prefixIcon: Icon(TossIcons.calendar),
              ),
              child: Text(
                DateFormat('MMM dd, yyyy').format(_expectedDelivery),
                style: TossTextStyles.body,
              ),
            ),
          ),
          
          SizedBox(height: TossSpacing.space3),
          
          // Payment Terms
          DropdownButtonFormField<PaymentTerms>(
            value: _paymentTerms,
            decoration: InputDecoration(
              labelText: 'Payment Terms',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(TossBorderRadius.lg),
              ),
              prefixIcon: Icon(Icons.payment),
            ),
            items: PaymentTerms.values.map((terms) {
              return DropdownMenuItem(
                value: terms,
                child: Text(terms.displayName),
              );
            }).toList(),
            onChanged: (value) {
              if (value != null) {
                setState(() {
                  _paymentTerms = value;
                });
              }
            },
          ),
          
          SizedBox(height: TossSpacing.space3),
          
          // Notes
          TextFormField(
            controller: _notesController,
            decoration: InputDecoration(
              labelText: 'Notes (Optional)',
              hintText: 'Add any special instructions or notes',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(TossBorderRadius.lg),
              ),
              prefixIcon: Icon(Icons.note),
              alignLabelWithHint: true,
            ),
            maxLines: 3,
          ),
        ],
      ),
    );
  }
  
  Widget _buildProductsTab() {
    return Column(
      children: [
        // Add Product Button
        Container(
          padding: EdgeInsets.all(TossSpacing.space4),
          child: ElevatedButton.icon(
            onPressed: _addProductToOrder,
            icon: Icon(TossIcons.add),
            label: Text('Add Product'),
            style: ElevatedButton.styleFrom(
              backgroundColor: TossColors.primary,
              minimumSize: Size(double.infinity, TossSpacing.buttonHeightLG),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(TossBorderRadius.lg),
              ),
            ),
          ),
        ),
        
        // Products List
        Expanded(
          child: _orderItems.isEmpty
              ? _buildEmptyProductsState()
              : ListView.builder(
                  padding: EdgeInsets.symmetric(horizontal: TossSpacing.space4),
                  itemCount: _orderItems.length,
                  itemBuilder: (context, index) {
                    return _buildOrderItemCard(index);
                  },
                ),
        ),
        
        // Bottom Summary Bar
        if (_orderItems.isNotEmpty)
          Container(
            padding: EdgeInsets.all(TossSpacing.space4),
            decoration: BoxDecoration(
              color: TossColors.white,
              boxShadow: TossShadows.elevation2,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '$_totalItems items',
                      style: TossTextStyles.caption.copyWith(
                        color: TossColors.gray600,
                      ),
                    ),
                    Text(
                      'Subtotal',
                      style: TossTextStyles.bodySmall,
                    ),
                  ],
                ),
                Text(
                  _formatCurrency(_subtotal),
                  style: TossTextStyles.bodyLarge.copyWith(
                    fontWeight: FontWeight.w700,
                    color: TossColors.primary,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
  
  Widget _buildEmptyProductsState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.inventory_2_outlined,
            size: TossSpacing.iconXL + TossSpacing.space6,
            color: TossColors.gray300,
          ),
          SizedBox(height: TossSpacing.space3),
          Text(
            'No products added',
            style: TossTextStyles.bodyLarge.copyWith(
              color: TossColors.gray600,
            ),
          ),
          SizedBox(height: TossSpacing.space2),
          Text(
            'Add products to create your order',
            style: TossTextStyles.caption.copyWith(
              color: TossColors.gray500,
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildOrderItemCard(int index) {
    final item = _orderItems[index];
    
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
                width: TossSpacing.iconXL + TossSpacing.space5,
                height: TossSpacing.iconXL + TossSpacing.space5,
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
                    Text(
                      'Current Stock: ${item.product.onHand}',
                      style: TossTextStyles.caption.copyWith(
                        color: item.product.onHand < 10 
                            ? TossColors.error 
                            : TossColors.gray500,
                      ),
                    ),
                  ],
                ),
              ),
              
              // Remove Button
              IconButton(
                onPressed: () => _removeOrderItem(index),
                icon: Icon(TossIcons.close),
                iconSize: TossSpacing.iconSM,
                color: TossColors.gray400,
              ),
            ],
          ),
          
          SizedBox(height: TossSpacing.space3),
          
          // Quantity and Cost Row
          Row(
            children: [
              // Quantity Controls
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Quantity',
                      style: TossTextStyles.caption.copyWith(
                        color: TossColors.gray600,
                      ),
                    ),
                    SizedBox(height: TossSpacing.space1),
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
                            iconSize: TossSpacing.iconSM,
                            constraints: BoxConstraints(
                              minWidth: TossSpacing.space9,
                              minHeight: TossSpacing.space9,
                            ),
                          ),
                          Expanded(
                            child: Text(
                              item.quantity.toString(),
                              textAlign: TextAlign.center,
                              style: TossTextStyles.body.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          IconButton(
                            onPressed: () => _updateItemQuantity(index, item.quantity + 1),
                            icon: Icon(TossIcons.add),
                            iconSize: TossSpacing.iconSM,
                            constraints: BoxConstraints(
                              minWidth: TossSpacing.space9,
                              minHeight: TossSpacing.space9,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              
              SizedBox(width: TossSpacing.space3),
              
              // Unit Cost
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Unit Cost',
                      style: TossTextStyles.caption.copyWith(
                        color: TossColors.gray600,
                      ),
                    ),
                    SizedBox(height: TossSpacing.space1),
                    TextFormField(
                      initialValue: item.unitCost.toStringAsFixed(0),
                      decoration: InputDecoration(
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
                        final cost = double.tryParse(value) ?? 0;
                        _updateItemCost(index, cost);
                      },
                    ),
                  ],
                ),
              ),
              
              SizedBox(width: TossSpacing.space3),
              
              // Subtotal
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'Subtotal',
                      style: TossTextStyles.caption.copyWith(
                        color: TossColors.gray600,
                      ),
                    ),
                    SizedBox(height: TossSpacing.space1),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: TossSpacing.space2,
                        vertical: TossSpacing.space2,
                      ),
                      decoration: BoxDecoration(
                        color: TossColors.primary.withOpacity(0.05),
                        borderRadius: BorderRadius.circular(TossBorderRadius.md),
                      ),
                      child: Text(
                        _formatCurrency(item.subtotal),
                        style: TossTextStyles.body.copyWith(
                          fontWeight: FontWeight.w700,
                          color: TossColors.primary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
  
  Widget _buildSummaryTab() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(TossSpacing.space4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Order Summary Card
          Container(
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
                  'Order Summary',
                  style: TossTextStyles.bodyLarge.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: TossSpacing.space3),
                
                _buildSummaryRow('Order Number', _orderNumber),
                _buildSummaryRow('Supplier', _supplierNameController.text.isEmpty 
                    ? 'Not specified' 
                    : _supplierNameController.text),
                _buildSummaryRow('Expected Delivery', 
                    DateFormat('MMM dd, yyyy').format(_expectedDelivery)),
                _buildSummaryRow('Payment Terms', _paymentTerms.displayName),
                _buildSummaryRow('Total Items', '$_totalItems'),
              ],
            ),
          ),
          
          SizedBox(height: TossSpacing.space3),
          
          // Cost Breakdown
          Container(
            padding: EdgeInsets.all(TossSpacing.space3),
            decoration: BoxDecoration(
              color: TossColors.primary.withOpacity(0.05),
              borderRadius: BorderRadius.circular(TossBorderRadius.lg),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Cost Breakdown',
                  style: TossTextStyles.bodyLarge.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: TossSpacing.space3),
                
                _buildCostRow('Subtotal', _subtotal),
                _buildCostRow('Tax (10%)', _taxAmount),
                _buildCostRow('Shipping', _shippingCost),
                
                Padding(
                  padding: EdgeInsets.symmetric(vertical: TossSpacing.space2),
                  child: Divider(),
                ),
                
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Total Amount',
                      style: TossTextStyles.bodyLarge.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      _formatCurrency(_totalAmount),
                      style: TossTextStyles.h4.copyWith(
                        fontWeight: FontWeight.w700,
                        color: TossColors.primary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          SizedBox(height: TossSpacing.space3),
          
          // Products List
          if (_orderItems.isNotEmpty) ...[
            Text(
              'Products (${_orderItems.length})',
              style: TossTextStyles.bodyLarge.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(height: TossSpacing.space2),
            
            ..._orderItems.map((item) => Container(
              margin: EdgeInsets.only(bottom: TossSpacing.space2),
              padding: EdgeInsets.all(TossSpacing.space2),
              decoration: BoxDecoration(
                color: TossColors.gray50,
                borderRadius: BorderRadius.circular(TossBorderRadius.md),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.product.name,
                          style: TossTextStyles.bodySmall.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          '${item.quantity} × ${_formatCurrency(item.unitCost)}',
                          style: TossTextStyles.caption.copyWith(
                            color: TossColors.gray600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    _formatCurrency(item.subtotal),
                    style: TossTextStyles.body.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            )).toList(),
          ],
          
          if (_notesController.text.isNotEmpty) ...[
            SizedBox(height: TossSpacing.space3),
            Container(
              padding: EdgeInsets.all(TossSpacing.space3),
              decoration: BoxDecoration(
                color: TossColors.gray50,
                borderRadius: BorderRadius.circular(TossBorderRadius.lg),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.note,
                        size: TossSpacing.iconXS,
                        color: TossColors.gray600,
                      ),
                      SizedBox(width: TossSpacing.space1),
                      Text(
                        'Notes',
                        style: TossTextStyles.bodySmall.copyWith(
                          fontWeight: FontWeight.w600,
                          color: TossColors.gray600,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: TossSpacing.space1),
                  Text(
                    _notesController.text,
                    style: TossTextStyles.caption.copyWith(
                      color: TossColors.gray700,
                    ),
                  ),
                ],
              ),
            ),
          ],
          
          SizedBox(height: TossSpacing.space4),
          
          // Action Buttons
          if (_orderStatus == OrderStatus.draft) ...[
            ElevatedButton.icon(
              onPressed: _isProcessing ? null : _submitOrder,
              icon: Icon(Icons.send),
              label: Text('Submit Order'),
              style: ElevatedButton.styleFrom(
                backgroundColor: TossColors.primary,
                minimumSize: Size(double.infinity, TossSpacing.buttonHeightLG),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(TossBorderRadius.lg),
                ),
              ),
            ),
            SizedBox(height: TossSpacing.space2),
            OutlinedButton.icon(
              onPressed: () {
                // TODO: Save as draft
              },
              icon: Icon(Icons.save),
              label: Text('Save as Draft'),
              style: OutlinedButton.styleFrom(
                minimumSize: Size(double.infinity, TossSpacing.buttonHeightLG),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(TossBorderRadius.lg),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
  
  Widget _buildSummaryRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: TossSpacing.space1),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TossTextStyles.caption.copyWith(
              color: TossColors.gray600,
            ),
          ),
          Text(
            value,
            style: TossTextStyles.bodySmall.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildCostRow(String label, double value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: TossSpacing.space1),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TossTextStyles.bodySmall.copyWith(
              color: TossColors.gray600,
            ),
          ),
          Text(
            _formatCurrency(value),
            style: TossTextStyles.body.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
  
  Color _getStatusColor(OrderStatus status) {
    switch (status) {
      case OrderStatus.draft:
        return TossColors.gray600;
      case OrderStatus.submitted:
        return TossColors.info;
      case OrderStatus.approved:
        return TossColors.primary;
      case OrderStatus.shipped:
        return TossColors.warning;
      case OrderStatus.received:
        return TossColors.success;
      case OrderStatus.cancelled:
        return TossColors.error;
    }
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

// Supplier Selection Sheet
class _SupplierSelectionSheet extends StatelessWidget {
  final Function(Supplier) onSelected;
  
  const _SupplierSelectionSheet({required this.onSelected});
  
  @override
  Widget build(BuildContext context) {
    // Mock suppliers
    final suppliers = [
      Supplier(id: '1', name: 'ABC Trading Co.', contact: 'John Doe', email: 'john@abc.com'),
      Supplier(id: '2', name: 'XYZ Supplies', contact: 'Jane Smith', email: 'jane@xyz.com'),
      Supplier(id: '3', name: 'Global Imports', contact: 'Mike Johnson', email: 'mike@global.com'),
    ];
    
    return Container(
      height: MediaQuery.of(context).size.height * 0.7,
      padding: EdgeInsets.all(TossSpacing.space4),
      child: Column(
        children: [
          Text(
            'Select Supplier',
            style: TossTextStyles.h4.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: TossSpacing.space3),
          Expanded(
            child: ListView.builder(
              itemCount: suppliers.length,
              itemBuilder: (context, index) {
                final supplier = suppliers[index];
                return ListTile(
                  leading: CircleAvatar(
                    backgroundColor: TossColors.primary.withOpacity(0.1),
                    child: Icon(TossIcons.business, color: TossColors.primary),
                  ),
                  title: Text(supplier.name),
                  subtitle: Text('${supplier.contact} • ${supplier.email}'),
                  onTap: () => onSelected(supplier),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// Product Selection Sheet
class _ProductSelectionSheet extends StatefulWidget {
  final Function(Product, int, double) onSelected;
  
  const _ProductSelectionSheet({required this.onSelected});
  
  @override
  State<_ProductSelectionSheet> createState() => _ProductSelectionSheetState();
}

class _ProductSelectionSheetState extends State<_ProductSelectionSheet> {
  final _quantityController = TextEditingController(text: '1');
  final _costController = TextEditingController();
  Product? _selectedProduct;
  
  @override
  Widget build(BuildContext context) {
    // Mock products
    final products = [
      Product(
        id: '1',
        sku: 'PRD001',
        name: 'Premium Handbag',
        category: ProductCategory.bags,
        productType: ProductType.simple,
        costPrice: 500000,
        salePrice: 750000,
        onHand: 5,
      ),
      Product(
        id: '2',
        sku: 'PRD002',
        name: 'Designer Wallet',
        category: ProductCategory.accessories,
        productType: ProductType.simple,
        costPrice: 200000,
        salePrice: 350000,
        onHand: 15,
      ),
    ];
    
    return Container(
      height: MediaQuery.of(context).size.height * 0.8,
      padding: EdgeInsets.all(TossSpacing.space4),
      child: Column(
        children: [
          Text(
            'Add Product to Order',
            style: TossTextStyles.h4.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: TossSpacing.space3),
          
          if (_selectedProduct == null) ...[
            Expanded(
              child: ListView.builder(
                itemCount: products.length,
                itemBuilder: (context, index) {
                  final product = products[index];
                  return ListTile(
                    leading: Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: TossColors.gray100,
                        borderRadius: BorderRadius.circular(TossBorderRadius.md),
                      ),
                      child: Icon(Icons.inventory_2, color: TossColors.gray400),
                    ),
                    title: Text(product.name),
                    subtitle: Text('${product.sku} • Stock: ${product.onHand}'),
                    trailing: Text(
                      '₩${product.costPrice.toStringAsFixed(0)}',
                      style: TossTextStyles.body.copyWith(fontWeight: FontWeight.w700),
                    ),
                    onTap: () {
                      setState(() {
                        _selectedProduct = product;
                        _costController.text = product.costPrice.toStringAsFixed(0);
                      });
                    },
                  );
                },
              ),
            ),
          ] else ...[
            Container(
              padding: EdgeInsets.all(TossSpacing.space3),
              decoration: BoxDecoration(
                color: TossColors.gray50,
                borderRadius: BorderRadius.circular(TossBorderRadius.lg),
              ),
              child: Row(
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: TossColors.gray200,
                      borderRadius: BorderRadius.circular(TossBorderRadius.md),
                    ),
                    child: Icon(Icons.inventory_2, color: TossColors.gray400),
                  ),
                  SizedBox(width: TossSpacing.space3),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _selectedProduct!.name,
                          style: TossTextStyles.body.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Text(
                          '${_selectedProduct!.sku} • Stock: ${_selectedProduct!.onHand}',
                          style: TossTextStyles.caption.copyWith(
                            color: TossColors.gray600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        _selectedProduct = null;
                      });
                    },
                    child: Text('Change'),
                  ),
                ],
              ),
            ),
            
            SizedBox(height: TossSpacing.space3),
            
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _quantityController,
                    decoration: InputDecoration(
                      labelText: 'Quantity',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(TossBorderRadius.lg),
                      ),
                    ),
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  ),
                ),
                SizedBox(width: TossSpacing.space2),
                Expanded(
                  child: TextField(
                    controller: _costController,
                    decoration: InputDecoration(
                      labelText: 'Unit Cost',
                      prefixText: '₩',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(TossBorderRadius.lg),
                      ),
                    ),
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  ),
                ),
              ],
            ),
            
            Spacer(),
            
            ElevatedButton(
              onPressed: () {
                final quantity = int.tryParse(_quantityController.text) ?? 1;
                final cost = double.tryParse(_costController.text) ?? 0;
                
                if (quantity > 0 && cost > 0) {
                  widget.onSelected(_selectedProduct!, quantity, cost);
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: TossColors.primary,
                minimumSize: Size(double.infinity, TossSpacing.buttonHeightLG),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(TossBorderRadius.lg),
                ),
              ),
              child: Text('Add to Order'),
            ),
          ],
        ],
      ),
    );
  }
}