import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/themes/index.dart';
import '../../../widgets/common/toss_scaffold.dart';
import '../../../helpers/navigation_helper.dart';
import '../models/product_model.dart';
import '../models/inventory_count_model.dart';
import '../widgets/barcode_scanner_sheet.dart';
import 'package:intl/intl.dart';
import 'package:myfinance_improved/core/themes/toss_border_radius.dart';
class InventoryCountPage extends ConsumerStatefulWidget {
  final String? countSessionId;
  final List<Product>? products;
  
  const InventoryCountPage({
    Key? key,
    this.countSessionId,
    this.products,
  }) : super(key: key);

  @override
  ConsumerState<InventoryCountPage> createState() => _InventoryCountPageState();
}

class _InventoryCountPageState extends ConsumerState<InventoryCountPage> 
    with TickerProviderStateMixin {
  late TabController _tabController;
  final List<CountedItem> _countedItems = [];
  final List<CountedItem> _discrepancies = [];
  final _searchController = TextEditingController();
  final _barcodeController = TextEditingController();
  
  CountStatus _countStatus = CountStatus.inProgress;
  bool _isProcessing = false;
  String _selectedLocation = 'All Locations';
  String _selectedCategory = 'All Categories';
  String _voucherNumber = '';
  
  // Statistics
  int get _totalProducts => widget.products?.length ?? 4446; // From database
  int get _countedProducts => _countedItems.length;
  int get _uncountedProducts => _totalProducts - _countedProducts;
  double get _progressPercentage => _totalProducts > 0 ? (_countedProducts / _totalProducts) * 100 : 0;
  int get _discrepancyCount => _discrepancies.length;
  double get _totalVariance => _discrepancies.fold(
    0.0, 
    (sum, item) => sum + (item.variance * item.product.costPrice)
  );
  
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _generateVoucherNumber();
    _loadCountSession();
  }
  
  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    _barcodeController.dispose();
    super.dispose();
  }

  void _generateVoucherNumber() {
    final now = DateTime.now();
    _voucherNumber = 'CNT${now.year}${now.month.toString().padLeft(2, '0')}${now.day.toString().padLeft(2, '0')}-${now.millisecondsSinceEpoch.toString().substring(8)}';
  }
  
  Future<void> _loadCountSession() async {
    // TODO: Load existing count session or create new one
    if (widget.countSessionId != null) {
      // Load existing session from database
    } else {
      // Create new count session
    }
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
    // For now, show mock product
    _showQuickCountDialog(
      Product(
        id: '1',
        sku: 'SKU001',
        name: 'Sample Product',
        category: ProductCategory.accessories,
        productType: ProductType.simple,
        costPrice: 100000,
        salePrice: 150000,
        onHand: 10,
        barcode: barcode,
      ),
    );
  }
  
  void _showQuickCountDialog(Product product) {
    final countController = TextEditingController(text: product.onHand.toString());
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Count: ${product.name}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'SKU: ${product.sku}',
              style: TossTextStyles.caption.copyWith(
                color: TossColors.gray600,
              ),
            ),
            if (product.location != null)
              Text(
                'Location: ${product.location}',
                style: TossTextStyles.caption.copyWith(
                  color: TossColors.gray600,
                ),
              ),
            SizedBox(height: TossSpacing.space3),
            Container(
              padding: EdgeInsets.all(TossSpacing.space2),
              decoration: BoxDecoration(
                color: TossColors.gray50,
                borderRadius: BorderRadius.circular(TossBorderRadius.md),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('System Quantity:'),
                  Text(
                    '${product.onHand}',
                    style: TossTextStyles.body.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: TossSpacing.space3),
            TextField(
              controller: countController,
              decoration: InputDecoration(
                labelText: 'Actual Count',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(TossBorderRadius.md),
                ),
                prefixIcon: Icon(Icons.inventory_2),
              ),
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              autofocus: true,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final actualCount = int.tryParse(countController.text) ?? 0;
              _addCountedItem(product, actualCount);
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: TossColors.primary,
            ),
            child: Text('Submit Count'),
          ),
        ],
      ),
    );
  }
  
  void _addCountedItem(Product product, int actualCount) {
    final countedItem = CountedItem(
      product: product,
      systemQuantity: product.onHand,
      actualQuantity: actualCount,
      variance: actualCount - product.onHand,
      countedAt: DateTime.now(),
      countedBy: 'Current User', // TODO: Get from auth
    );
    
    setState(() {
      // Remove if already counted
      _countedItems.removeWhere((item) => item.product.id == product.id);
      _discrepancies.removeWhere((item) => item.product.id == product.id);
      
      // Add to counted items
      _countedItems.add(countedItem);
      
      // Add to discrepancies if variance exists
      if (countedItem.variance != 0) {
        _discrepancies.add(countedItem);
      }
    });
    
    // Show feedback
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              countedItem.variance == 0 
                  ? Icons.check_circle 
                  : Icons.warning,
              color: TossColors.white,
            ),
            SizedBox(width: TossSpacing.space2),
            Text(
              countedItem.variance == 0
                  ? 'Count matches system quantity'
                  : 'Variance of ${countedItem.variance > 0 ? '+' : ''}${countedItem.variance} units',
            ),
          ],
        ),
        backgroundColor: countedItem.variance == 0 
            ? TossColors.success 
            : TossColors.warning,
      ),
    );
  }
  
  Future<void> _finalizeCount() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Finalize Count?'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('This will update inventory quantities based on your count.'),
            SizedBox(height: TossSpacing.space3),
            Container(
              padding: EdgeInsets.all(TossSpacing.space3),
              decoration: BoxDecoration(
                color: TossColors.gray50,
                borderRadius: BorderRadius.circular(TossBorderRadius.md),
              ),
              child: Column(
                children: [
                  _buildSummaryRow('Products Counted', '$_countedProducts / $_totalProducts'),
                  _buildSummaryRow('Discrepancies', '$_discrepancyCount items'),
                  _buildSummaryRow(
                    'Total Variance Value', 
                    _formatCurrency(_totalVariance.abs()),
                    isHighlight: true,
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: TossColors.primary,
            ),
            child: Text('Finalize Count'),
          ),
        ],
      ),
    );
    
    if (confirmed == true) {
      setState(() => _isProcessing = true);
      
      try {
        // TODO: Submit count to database
        await Future.delayed(Duration(seconds: 2));
        
        setState(() => _countStatus = CountStatus.completed);
        
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Inventory count completed successfully'),
              backgroundColor: TossColors.success,
            ),
          );
          
          NavigationHelper.safeGoBack(context);
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error finalizing count: $e'),
            backgroundColor: TossColors.error,
          ),
        );
      } finally {
        if (mounted) {
          setState(() => _isProcessing = false);
        }
      }
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return TossScaffold(
      backgroundColor: TossColors.gray100,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => NavigationHelper.safeGoBack(context),
        ),
        title: const Text('Inventory Count'),
        centerTitle: true,
        backgroundColor: TossColors.gray100,
        foregroundColor: TossColors.black,
        elevation: 0,
        actions: [
          if (_countStatus == CountStatus.inProgress)
            TextButton(
              onPressed: _isProcessing ? null : _finalizeCount,
              child: Text(
                'Finalize',
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
            Tab(text: 'Count'),
            Tab(text: 'Discrepancies'),
            Tab(text: 'Summary'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildCountTab(),
          _buildDiscrepanciesTab(),
          _buildSummaryTab(),
        ],
      ),
      floatingActionButton: _tabController.index == 0
          ? FloatingActionButton.extended(
              onPressed: _scanBarcode,
              icon: Icon(Icons.qr_code_scanner),
              label: Text('Scan'),
              backgroundColor: TossColors.primary,
            )
          : null,
    );
  }
  
  Widget _buildCountTab() {
    return Column(
      children: [
        // Search and Filter Bar
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
              // Progress Bar
              _buildProgressBar(),
              
              SizedBox(height: TossSpacing.space3),
              
              // Search Field
              TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Search product by name or SKU',
                  prefixIcon: Icon(Icons.search),
                  suffixIcon: IconButton(
                    icon: Icon(Icons.qr_code_scanner),
                    onPressed: _scanBarcode,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(TossBorderRadius.lg),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: TossColors.gray50,
                ),
              ),
              
              SizedBox(height: TossSpacing.space2),
              
              // Filters
              Row(
                children: [
                  Expanded(
                    child: _buildFilterChip(
                      label: _selectedLocation,
                      icon: Icons.location_on,
                      onTap: () => _showLocationFilter(),
                    ),
                  ),
                  SizedBox(width: TossSpacing.space2),
                  Expanded(
                    child: _buildFilterChip(
                      label: _selectedCategory,
                      icon: Icons.category,
                      onTap: () => _showCategoryFilter(),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        
        // Product List
        Expanded(
          child: ListView.builder(
            padding: EdgeInsets.all(TossSpacing.space4),
            itemCount: _countedItems.length + 1,
            itemBuilder: (context, index) {
              if (index == _countedItems.length) {
                // Show uncounted products section
                return _buildUncountedSection();
              }
              return _buildCountedItemCard(_countedItems[index]);
            },
          ),
        ),
      ],
    );
  }
  
  Widget _buildDiscrepanciesTab() {
    if (_discrepancies.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.check_circle,
              size: 64,
              color: TossColors.success,
            ),
            SizedBox(height: TossSpacing.space3),
            Text(
              'No Discrepancies Found',
              style: TossTextStyles.bodyLarge.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: TossSpacing.space2),
            Text(
              'All counted items match system quantities',
              style: TossTextStyles.caption.copyWith(
                color: TossColors.gray600,
              ),
            ),
          ],
        ),
      );
    }
    
    return ListView.builder(
      padding: EdgeInsets.all(TossSpacing.space4),
      itemCount: _discrepancies.length,
      itemBuilder: (context, index) {
        return _buildDiscrepancyCard(_discrepancies[index]);
      },
    );
  }
  
  Widget _buildSummaryTab() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(TossSpacing.space4),
      child: Column(
        children: [
          // Voucher Info Card
          Container(
            padding: EdgeInsets.all(TossSpacing.space3),
            decoration: BoxDecoration(
              color: TossColors.primary.withOpacity(0.05),
              borderRadius: BorderRadius.circular(TossBorderRadius.lg),
              border: Border.all(color: TossColors.primary.withOpacity(0.2)),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Voucher Number',
                          style: TossTextStyles.caption.copyWith(
                            color: TossColors.gray600,
                          ),
                        ),
                        Text(
                          _voucherNumber,
                          style: TossTextStyles.body.copyWith(
                            fontWeight: FontWeight.w700,
                            fontFamily: 'monospace',
                          ),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          'Date & Time',
                          style: TossTextStyles.caption.copyWith(
                            color: TossColors.gray600,
                          ),
                        ),
                        Text(
                          _formatDateTime(DateTime.now()),
                          style: TossTextStyles.body.copyWith(
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          SizedBox(height: TossSpacing.space3),
          
          // Count Statistics
          _buildSummaryCard(
            title: 'Count Progress',
            icon: Icons.inventory_2,
            color: TossColors.primary,
            children: [
              _buildStatRow('Total Products', '$_totalProducts'),
              _buildStatRow('Counted', '$_countedProducts', 
                  color: TossColors.success),
              _buildStatRow('Uncounted', '$_uncountedProducts', 
                  color: TossColors.warning),
              _buildStatRow('Progress', '${_progressPercentage.toStringAsFixed(1)}%'),
            ],
          ),
          
          SizedBox(height: TossSpacing.space3),
          
          // Variance Summary
          _buildSummaryCard(
            title: 'Variance Summary',
            icon: Icons.analytics,
            color: TossColors.warning,
            children: [
              _buildStatRow('Total Discrepancies', '$_discrepancyCount items'),
              _buildStatRow('Over Count', 
                  '${_discrepancies.where((d) => d.variance > 0).length} items',
                  color: TossColors.info),
              _buildStatRow('Under Count', 
                  '${_discrepancies.where((d) => d.variance < 0).length} items',
                  color: TossColors.error),
              _buildStatRow('Variance Value', _formatCurrency(_totalVariance.abs()),
                  isBold: true),
            ],
          ),
          
          SizedBox(height: TossSpacing.space3),
          
          // Session Info
          _buildSummaryCard(
            title: 'Session Information',
            icon: Icons.info,
            color: TossColors.gray600,
            children: [
              _buildStatRow('Session ID', widget.countSessionId ?? _voucherNumber),
              _buildStatRow('Started', _formatDateTime(DateTime.now())),
              _buildStatRow('Counter', 'Current User'),
              _buildStatRow('Status', _countStatus.displayName),
            ],
          ),
          
          SizedBox(height: TossSpacing.space4),
          
          // Action Buttons
          if (_countStatus == CountStatus.inProgress) ...[
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _isProcessing ? null : _finalizeCount,
                icon: Icon(Icons.check),
                label: Text('Finalize Count'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: TossColors.primary,
                  padding: EdgeInsets.symmetric(vertical: TossSpacing.space3),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(TossBorderRadius.lg),
                  ),
                ),
              ),
            ),
            SizedBox(height: TossSpacing.space2),
            OutlinedButton.icon(
              onPressed: () {
                // TODO: Save draft
              },
              icon: Icon(Icons.save),
              label: Text('Save as Draft'),
              style: OutlinedButton.styleFrom(
                minimumSize: Size(double.infinity, 48),
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
  
  Widget _buildProgressBar() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Count Progress',
              style: TossTextStyles.bodySmall.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              '$_countedProducts / $_totalProducts',
              style: TossTextStyles.caption.copyWith(
                color: TossColors.gray600,
              ),
            ),
          ],
        ),
        SizedBox(height: TossSpacing.space1),
        LinearProgressIndicator(
          value: _progressPercentage / 100,
          backgroundColor: TossColors.gray200,
          valueColor: AlwaysStoppedAnimation<Color>(
            _progressPercentage >= 80 
                ? TossColors.success 
                : _progressPercentage >= 50
                    ? TossColors.primary
                    : TossColors.warning,
          ),
        ),
      ],
    );
  }
  
  Widget _buildFilterChip({
    required String label,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(TossBorderRadius.md),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: TossSpacing.space2,
          vertical: TossSpacing.space2,
        ),
        decoration: BoxDecoration(
          border: Border.all(color: TossColors.gray300),
          borderRadius: BorderRadius.circular(TossBorderRadius.md),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 16, color: TossColors.gray600),
            SizedBox(width: TossSpacing.space1),
            Flexible(
              child: Text(
                label,
                style: TossTextStyles.caption,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Icon(Icons.arrow_drop_down, size: 16),
          ],
        ),
      ),
    );
  }
  
  Widget _buildCountedItemCard(CountedItem item) {
    final hasVariance = item.variance != 0;
    
    return Container(
      margin: EdgeInsets.only(bottom: TossSpacing.space3),
      padding: EdgeInsets.all(TossSpacing.space3),
      decoration: BoxDecoration(
        color: TossColors.white,
        borderRadius: BorderRadius.circular(TossBorderRadius.lg),
        border: Border.all(
          color: hasVariance ? TossColors.warning : TossColors.gray200,
        ),
      ),
      child: Row(
        children: [
          // Product Image
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: TossColors.gray100,
              borderRadius: BorderRadius.circular(TossBorderRadius.md),
            ),
            child: Icon(
              Icons.inventory_2,
              color: TossColors.gray400,
            ),
          ),
          
          SizedBox(width: TossSpacing.space3),
          
          // Product Info
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
                if (item.product.location != null)
                  Text(
                    item.product.location!,
                    style: TossTextStyles.caption.copyWith(
                      color: TossColors.gray500,
                    ),
                  ),
              ],
            ),
          ),
          
          // Count Info
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Row(
                children: [
                  Text(
                    '${item.systemQuantity}',
                    style: TossTextStyles.bodySmall.copyWith(
                      color: TossColors.gray600,
                      decoration: hasVariance ? TextDecoration.lineThrough : null,
                    ),
                  ),
                  Icon(Icons.arrow_forward, size: 14, color: TossColors.gray400),
                  Text(
                    '${item.actualQuantity}',
                    style: TossTextStyles.body.copyWith(
                      fontWeight: FontWeight.w700,
                      color: hasVariance ? TossColors.warning : TossColors.success,
                    ),
                  ),
                ],
              ),
              if (hasVariance)
                Text(
                  '${item.variance > 0 ? '+' : ''}${item.variance}',
                  style: TossTextStyles.caption.copyWith(
                    color: item.variance > 0 ? TossColors.info : TossColors.error,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              Text(
                _formatTime(item.countedAt),
                style: TossTextStyles.caption.copyWith(
                  color: TossColors.gray500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
  
  Widget _buildDiscrepancyCard(CountedItem item) {
    final varianceValue = item.variance * item.product.costPrice;
    
    return Container(
      margin: EdgeInsets.only(bottom: TossSpacing.space3),
      padding: EdgeInsets.all(TossSpacing.space3),
      decoration: BoxDecoration(
        color: TossColors.white,
        borderRadius: BorderRadius.circular(TossBorderRadius.lg),
        border: Border.all(
          color: item.variance > 0 ? TossColors.info : TossColors.error,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
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
                      '${item.product.sku} • ${item.product.location ?? 'No location'}',
                      style: TossTextStyles.caption.copyWith(
                        color: TossColors.gray600,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: TossSpacing.space2,
                  vertical: TossSpacing.space1,
                ),
                decoration: BoxDecoration(
                  color: (item.variance > 0 ? TossColors.info : TossColors.error)
                      .withOpacity(0.1),
                  borderRadius: BorderRadius.circular(TossBorderRadius.md),
                ),
                child: Text(
                  item.variance > 0 ? 'Over' : 'Under',
                  style: TossTextStyles.caption.copyWith(
                    color: item.variance > 0 ? TossColors.info : TossColors.error,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          
          SizedBox(height: TossSpacing.space3),
          
          Row(
            children: [
              Expanded(
                child: _buildVarianceInfo(
                  'System Qty',
                  '${item.systemQuantity}',
                  TossColors.gray600,
                ),
              ),
              Expanded(
                child: _buildVarianceInfo(
                  'Actual Qty',
                  '${item.actualQuantity}',
                  TossColors.primary,
                ),
              ),
              Expanded(
                child: _buildVarianceInfo(
                  'Variance',
                  '${item.variance > 0 ? '+' : ''}${item.variance}',
                  item.variance > 0 ? TossColors.info : TossColors.error,
                ),
              ),
              Expanded(
                child: _buildVarianceInfo(
                  'Value',
                  _formatCurrency(varianceValue.abs()),
                  TossColors.black,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
  
  Widget _buildVarianceInfo(String label, String value, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
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
            fontWeight: FontWeight.w600,
            color: color,
          ),
        ),
      ],
    );
  }
  
  Widget _buildUncountedSection() {
    if (_uncountedProducts == 0) {
      return Container(
        padding: EdgeInsets.all(TossSpacing.space4),
        decoration: BoxDecoration(
          color: TossColors.success.withOpacity(0.1),
          borderRadius: BorderRadius.circular(TossBorderRadius.lg),
          border: Border.all(color: TossColors.success),
        ),
        child: Column(
          children: [
            Icon(
              Icons.check_circle,
              size: 48,
              color: TossColors.success,
            ),
            SizedBox(height: TossSpacing.space2),
            Text(
              'All Products Counted!',
              style: TossTextStyles.bodyLarge.copyWith(
                fontWeight: FontWeight.w600,
                color: TossColors.success,
              ),
            ),
            SizedBox(height: TossSpacing.space1),
            Text(
              'You can now finalize the count',
              style: TossTextStyles.caption.copyWith(
                color: TossColors.gray600,
              ),
            ),
          ],
        ),
      );
    }
    
    return Container(
      padding: EdgeInsets.all(TossSpacing.space3),
      decoration: BoxDecoration(
        color: TossColors.gray50,
        borderRadius: BorderRadius.circular(TossBorderRadius.lg),
      ),
      child: Column(
        children: [
          Icon(
            Icons.inventory,
            size: 48,
            color: TossColors.gray400,
          ),
          SizedBox(height: TossSpacing.space2),
          Text(
            '$_uncountedProducts Products Remaining',
            style: TossTextStyles.body.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: TossSpacing.space1),
          Text(
            'Search or scan to add products to count',
            style: TossTextStyles.caption.copyWith(
              color: TossColors.gray600,
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildSummaryCard({
    required String title,
    required IconData icon,
    required Color color,
    required List<Widget> children,
  }) {
    return Container(
      padding: EdgeInsets.all(TossSpacing.space3),
      decoration: BoxDecoration(
        color: TossColors.white,
        borderRadius: BorderRadius.circular(TossBorderRadius.lg),
        border: Border.all(color: TossColors.gray200),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(TossSpacing.space2),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(TossBorderRadius.md),
                ),
                child: Icon(icon, color: color, size: 20),
              ),
              SizedBox(width: TossSpacing.space2),
              Text(
                title,
                style: TossTextStyles.body.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          SizedBox(height: TossSpacing.space3),
          ...children,
        ],
      ),
    );
  }
  
  Widget _buildStatRow(String label, String value, {Color? color, bool isBold = false}) {
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
              fontWeight: isBold ? FontWeight.w700 : FontWeight.w500,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildSummaryRow(String label, String value, {bool isHighlight = false}) {
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
              fontWeight: isHighlight ? FontWeight.w700 : FontWeight.w500,
              color: isHighlight ? TossColors.primary : null,
            ),
          ),
        ],
      ),
    );
  }
  
  void _showLocationFilter() {
    // TODO: Show location filter bottom sheet
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: EdgeInsets.all(TossSpacing.space4),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Select Location', style: TossTextStyles.h4),
            // Add location options here
          ],
        ),
      ),
    );
  }
  
  void _showCategoryFilter() {
    // TODO: Show category filter bottom sheet
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: EdgeInsets.all(TossSpacing.space4),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Select Category', style: TossTextStyles.h4),
            // Add category options here
          ],
        ),
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
  
  String _formatDateTime(DateTime date) {
    return DateFormat('dd/MM/yyyy HH:mm').format(date);
  }
  
  String _formatTime(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);
    
    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else {
      return '${difference.inHours}h ago';
    }
  }
}

// Models for Count Session
class CountedItem {
  final Product product;
  final int systemQuantity;
  final int actualQuantity;
  final int variance;
  final DateTime countedAt;
  final String countedBy;
  
  CountedItem({
    required this.product,
    required this.systemQuantity,
    required this.actualQuantity,
    required this.variance,
    required this.countedAt,
    required this.countedBy,
  });
}