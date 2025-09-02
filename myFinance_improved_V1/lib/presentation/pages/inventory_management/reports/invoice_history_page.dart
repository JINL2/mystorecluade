import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/themes/index.dart';
import '../../../widgets/common/toss_scaffold.dart';
import '../../../helpers/navigation_helper.dart';
import '../models/sale_model.dart';
import 'package:intl/intl.dart';

class InvoiceHistoryPage extends ConsumerStatefulWidget {
  const InvoiceHistoryPage({Key? key}) : super(key: key);

  @override
  ConsumerState<InvoiceHistoryPage> createState() => _InvoiceHistoryPageState();
}

class _InvoiceHistoryPageState extends ConsumerState<InvoiceHistoryPage> 
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _searchController = TextEditingController();
  
  String _selectedStatus = 'All';
  String _selectedPaymentMethod = 'All';
  DateTimeRange? _dateRange;
  
  // Mock data - will be replaced with database
  final List<Sale> _sales = [];
  
  // Statistics
  double get _todayTotal => _getTotalForDate(DateTime.now());
  double get _weekTotal => _getTotalForDateRange(
    DateTime.now().subtract(Duration(days: 7)),
    DateTime.now(),
  );
  double get _monthTotal => _getTotalForDateRange(
    DateTime(DateTime.now().year, DateTime.now().month, 1),
    DateTime.now(),
  );
  int get _todayCount => _getCountForDate(DateTime.now());
  
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadSales();
  }
  
  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }
  
  Future<void> _loadSales() async {
    // TODO: Load sales from database
    // For now, generate mock data
    setState(() {
      _sales.addAll(_generateMockSales());
    });
  }
  
  List<Sale> _generateMockSales() {
    final now = DateTime.now();
    return List.generate(50, (index) {
      final date = now.subtract(Duration(days: index ~/ 5, hours: index * 2));
      return Sale(
        id: 'SALE${1000 + index}',
        invoiceNumber: 'HD${date.year}${date.month.toString().padLeft(2, '0')}${date.day.toString().padLeft(2, '0')}${(index + 1).toString().padLeft(3, '0')}',
        saleDate: date,
        customerName: index % 3 == 0 ? 'VIP Customer ${index ~/ 3}' : 'Guest',
        customerPhone: index % 3 == 0 ? '010-${1000 + index}-${2000 + index}' : null,
        items: [],
        subtotal: 100000.0 + (index * 50000),
        discountAmount: index % 4 == 0 ? 10000.0 : 0,
        taxAmount: 10000.0 + (index * 5000),
        totalAmount: 110000.0 + (index * 55000),
        paymentMethod: PaymentMethod.values[index % 3],
        status: index % 10 == 0 ? SaleStatus.refunded : SaleStatus.completed,
        notes: index % 5 == 0 ? 'Special order' : null,
      );
    });
  }
  
  double _getTotalForDate(DateTime date) {
    return _sales
        .where((sale) => _isSameDay(sale.saleDate, date))
        .fold(0.0, (sum, sale) => sum + sale.totalAmount);
  }
  
  double _getTotalForDateRange(DateTime start, DateTime end) {
    return _sales
        .where((sale) => sale.saleDate.isAfter(start) && sale.saleDate.isBefore(end.add(Duration(days: 1))))
        .fold(0.0, (sum, sale) => sum + sale.totalAmount);
  }
  
  int _getCountForDate(DateTime date) {
    return _sales.where((sale) => _isSameDay(sale.saleDate, date)).length;
  }
  
  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }
  
  List<Sale> get _filteredSales {
    var filtered = _sales;
    
    // Search filter
    if (_searchController.text.isNotEmpty) {
      final query = _searchController.text.toLowerCase();
      filtered = filtered.where((sale) =>
          sale.invoiceNumber.toLowerCase().contains(query) ||
          sale.customerName.toLowerCase().contains(query) ||
          (sale.customerPhone?.contains(query) ?? false)
      ).toList();
    }
    
    // Date range filter
    if (_dateRange != null) {
      filtered = filtered.where((sale) =>
          sale.saleDate.isAfter(_dateRange!.start) &&
          sale.saleDate.isBefore(_dateRange!.end.add(Duration(days: 1)))
      ).toList();
    }
    
    // Status filter
    if (_selectedStatus != 'All') {
      filtered = filtered.where((sale) =>
          sale.status.displayName == _selectedStatus
      ).toList();
    }
    
    // Payment method filter
    if (_selectedPaymentMethod != 'All') {
      filtered = filtered.where((sale) =>
          sale.paymentMethod.displayName == _selectedPaymentMethod
      ).toList();
    }
    
    return filtered;
  }
  
  Future<void> _selectDateRange() async {
    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime.now().subtract(Duration(days: 365)),
      lastDate: DateTime.now(),
      initialDateRange: _dateRange,
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
        _dateRange = picked;
      });
    }
  }
  
  void _viewInvoiceDetails(Sale sale) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => _InvoiceDetailSheet(sale: sale),
    );
  }
  
  Future<void> _refundSale(Sale sale) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Refund Sale?'),
        content: Text('Are you sure you want to refund ${_formatCurrency(sale.totalAmount)}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: TossColors.error,
            ),
            child: Text('Refund'),
          ),
        ],
      ),
    );
    
    if (confirmed == true) {
      // TODO: Process refund
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Refund processed successfully'),
          backgroundColor: TossColors.success,
        ),
      );
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return TossScaffold(
      backgroundColor: TossColors.gray100,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(TossIcons.back),
          onPressed: () => NavigationHelper.safeGoBack(context),
        ),
        title: const Text('Sales History'),
        centerTitle: true,
        backgroundColor: TossColors.gray100,
        foregroundColor: TossColors.black,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.download),
            onPressed: () {
              // TODO: Export sales data
            },
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          labelColor: TossColors.primary,
          unselectedLabelColor: TossColors.gray600,
          indicatorColor: TossColors.primary,
          tabs: [
            Tab(text: 'Today'),
            Tab(text: 'This Week'),
            Tab(text: 'All Sales'),
          ],
        ),
      ),
      body: Column(
        children: [
          // Statistics Cards
          Container(
            height: 120,
            padding: EdgeInsets.all(TossSpacing.space4),
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                _buildStatCard(
                  'Today\'s Sales',
                  _formatCurrency(_todayTotal),
                  '$_todayCount orders',
                  TossColors.primary,
                  Icons.today,
                ),
                SizedBox(width: TossSpacing.space3),
                _buildStatCard(
                  'This Week',
                  _formatCurrency(_weekTotal),
                  '${_sales.where((s) => s.saleDate.isAfter(DateTime.now().subtract(Duration(days: 7)))).length} orders',
                  TossColors.info,
                  Icons.calendar_view_week,
                ),
                SizedBox(width: TossSpacing.space3),
                _buildStatCard(
                  'This Month',
                  _formatCurrency(_monthTotal),
                  '${_sales.where((s) => s.saleDate.month == DateTime.now().month).length} orders',
                  TossColors.success,
                  Icons.calendar_month,
                ),
              ],
            ),
          ),
          
          // Search and Filters
          Container(
            padding: EdgeInsets.symmetric(horizontal: TossSpacing.space4),
            child: Column(
              children: [
                // Search Bar
                TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Search by invoice, customer...',
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(TossBorderRadius.lg),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: TossColors.gray50,
                  ),
                  onChanged: (_) => setState(() {}),
                ),
                
                SizedBox(height: TossSpacing.space2),
                
                // Filter Chips
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _buildFilterChip(
                        label: _dateRange != null
                            ? '${DateFormat('MM/dd').format(_dateRange!.start)} - ${DateFormat('MM/dd').format(_dateRange!.end)}'
                            : 'Date Range',
                        icon: Icons.date_range,
                        onTap: _selectDateRange,
                        isActive: _dateRange != null,
                      ),
                      SizedBox(width: TossSpacing.space2),
                      _buildFilterChip(
                        label: _selectedStatus,
                        icon: Icons.label,
                        onTap: () => _showStatusFilter(),
                        isActive: _selectedStatus != 'All',
                      ),
                      SizedBox(width: TossSpacing.space2),
                      _buildFilterChip(
                        label: _selectedPaymentMethod,
                        icon: Icons.payment,
                        onTap: () => _showPaymentMethodFilter(),
                        isActive: _selectedPaymentMethod != 'All',
                      ),
                      if (_dateRange != null || _selectedStatus != 'All' || _selectedPaymentMethod != 'All')
                        Padding(
                          padding: EdgeInsets.only(left: TossSpacing.space2),
                          child: TextButton(
                            onPressed: () {
                              setState(() {
                                _dateRange = null;
                                _selectedStatus = 'All';
                                _selectedPaymentMethod = 'All';
                              });
                            },
                            child: Text('Clear Filters'),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          
          SizedBox(height: TossSpacing.space3),
          
          // Sales List
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildSalesList(_filteredSales.where((s) => _isSameDay(s.saleDate, DateTime.now())).toList()),
                _buildSalesList(_filteredSales.where((s) => s.saleDate.isAfter(DateTime.now().subtract(Duration(days: 7)))).toList()),
                _buildSalesList(_filteredSales),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          NavigationHelper.navigateTo(
            context,
            '/inventoryManagement/sale/new',
          );
        },
        icon: Icon(TossIcons.add),
        label: Text('New Sale'),
        backgroundColor: TossColors.primary,
      ),
    );
  }
  
  Widget _buildStatCard(String title, String value, String subtitle, Color color, IconData icon) {
    return Container(
      width: 160,
      padding: EdgeInsets.all(TossSpacing.space3),
      decoration: BoxDecoration(
        color: color.withOpacity(0.05),
        borderRadius: BorderRadius.circular(TossBorderRadius.lg),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: TossSpacing.iconSM),
              SizedBox(width: TossSpacing.space1),
              Expanded(
                child: Text(
                  title,
                  style: TossTextStyles.caption.copyWith(
                    color: TossColors.gray600,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          SizedBox(height: TossSpacing.space2),
          Text(
            value,
            style: TossTextStyles.bodyLarge.copyWith(
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
          Text(
            subtitle,
            style: TossTextStyles.caption.copyWith(
              color: TossColors.gray500,
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildFilterChip({
    required String label,
    required IconData icon,
    required VoidCallback onTap,
    bool isActive = false,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(TossBorderRadius.xxl),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: TossSpacing.space3,
          vertical: TossSpacing.space2,
        ),
        decoration: BoxDecoration(
          color: isActive ? TossColors.primary.withOpacity(0.1) : TossColors.gray50,
          borderRadius: BorderRadius.circular(TossBorderRadius.xxl),
          border: Border.all(
            color: isActive ? TossColors.primary : TossColors.gray300,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: TossSpacing.iconXS,
              color: isActive ? TossColors.primary : TossColors.gray600,
            ),
            SizedBox(width: TossSpacing.space1),
            Text(
              label,
              style: TossTextStyles.caption.copyWith(
                color: isActive ? TossColors.primary : TossColors.gray600,
                fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildSalesList(List<Sale> sales) {
    if (sales.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.receipt_long,
              size: TossSpacing.iconXL,
              color: TossColors.gray300,
            ),
            SizedBox(height: TossSpacing.space3),
            Text(
              'No sales found',
              style: TossTextStyles.bodyLarge.copyWith(
                color: TossColors.gray600,
              ),
            ),
            SizedBox(height: TossSpacing.space2),
            Text(
              'Sales will appear here once recorded',
              style: TossTextStyles.caption.copyWith(
                color: TossColors.gray500,
              ),
            ),
          ],
        ),
      );
    }
    
    return ListView.builder(
      padding: EdgeInsets.all(TossSpacing.space4),
      itemCount: sales.length,
      itemBuilder: (context, index) {
        final sale = sales[index];
        return _buildSaleCard(sale);
      },
    );
  }
  
  Widget _buildSaleCard(Sale sale) {
    return Container(
      margin: EdgeInsets.only(bottom: TossSpacing.space3),
      decoration: BoxDecoration(
        color: TossColors.white,
        borderRadius: BorderRadius.circular(TossBorderRadius.lg),
        border: Border.all(color: TossColors.gray200),
        boxShadow: [
          BoxShadow(
            color: TossColors.black.withOpacity(0.02),
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: InkWell(
        onTap: () => _viewInvoiceDetails(sale),
        borderRadius: BorderRadius.circular(TossBorderRadius.lg),
        child: Padding(
          padding: EdgeInsets.all(TossSpacing.space3),
          child: Column(
            children: [
              // Header Row
              Row(
                children: [
                  // Invoice Number and Date
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              sale.invoiceNumber,
                              style: TossTextStyles.body.copyWith(
                                fontWeight: FontWeight.w700,
                                fontFamily: 'monospace',
                              ),
                            ),
                            SizedBox(width: TossSpacing.space2),
                            _buildStatusBadge(sale.status),
                          ],
                        ),
                        SizedBox(height: 4),
                        Text(
                          DateFormat('MMM dd, yyyy HH:mm').format(sale.saleDate),
                          style: TossTextStyles.caption.copyWith(
                            color: TossColors.gray600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Total Amount
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        _formatCurrency(sale.totalAmount),
                        style: TossTextStyles.bodyLarge.copyWith(
                          fontWeight: FontWeight.w700,
                          color: sale.status == SaleStatus.refunded 
                              ? TossColors.error 
                              : TossColors.primary,
                        ),
                      ),
                      Row(
                        children: [
                          Icon(
                            sale.paymentMethod.icon,
                            size: TossSpacing.iconXS,
                            color: TossColors.gray500,
                          ),
                          SizedBox(width: 4),
                          Text(
                            sale.paymentMethod.displayName,
                            style: TossTextStyles.caption.copyWith(
                              color: TossColors.gray500,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
              
              SizedBox(height: TossSpacing.space2),
              Divider(height: 1),
              SizedBox(height: TossSpacing.space2),
              
              // Customer Info
              Row(
                children: [
                  Icon(
                    TossIcons.person,
                    size: TossSpacing.iconXS,
                    color: TossColors.gray400,
                  ),
                  SizedBox(width: TossSpacing.space1),
                  Text(
                    sale.customerName,
                    style: TossTextStyles.bodySmall,
                  ),
                  if (sale.customerPhone != null) ...[
                    SizedBox(width: TossSpacing.space2),
                    Icon(
                      Icons.phone,
                      size: TossSpacing.iconXS,
                      color: TossColors.gray400,
                    ),
                    SizedBox(width: 4),
                    Text(
                      sale.customerPhone!,
                      style: TossTextStyles.caption.copyWith(
                        color: TossColors.gray600,
                      ),
                    ),
                  ],
                  Spacer(),
                  // Action Buttons
                  if (sale.status == SaleStatus.completed)
                    IconButton(
                      icon: Icon(Icons.undo, size: TossSpacing.iconSM),
                      color: TossColors.error,
                      onPressed: () => _refundSale(sale),
                      constraints: BoxConstraints(
                        minWidth: 32,
                        minHeight: 32,
                      ),
                    ),
                  IconButton(
                    icon: Icon(Icons.print, size: TossSpacing.iconSM),
                    color: TossColors.gray600,
                    onPressed: () {
                      // TODO: Print invoice
                    },
                    constraints: BoxConstraints(
                      minWidth: 32,
                      minHeight: 32,
                    ),
                  ),
                ],
              ),
              
              if (sale.notes != null) ...[
                SizedBox(height: TossSpacing.space2),
                Container(
                  padding: EdgeInsets.all(TossSpacing.space2),
                  decoration: BoxDecoration(
                    color: TossColors.gray50,
                    borderRadius: BorderRadius.circular(TossBorderRadius.md),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.note,
                        size: TossSpacing.iconXS,
                        color: TossColors.gray500,
                      ),
                      SizedBox(width: TossSpacing.space1),
                      Expanded(
                        child: Text(
                          sale.notes!,
                          style: TossTextStyles.caption.copyWith(
                            color: TossColors.gray600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildStatusBadge(SaleStatus status) {
    Color color;
    switch (status) {
      case SaleStatus.pending:
        color = TossColors.warning;
        break;
      case SaleStatus.completed:
        color = TossColors.success;
        break;
      case SaleStatus.refunded:
        color = TossColors.error;
        break;
      case SaleStatus.cancelled:
        color = TossColors.gray600;
        break;
    }
    
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: TossSpacing.space2,
        vertical: 2,
      ),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(TossBorderRadius.lg),
      ),
      child: Text(
        status.displayName,
        style: TossTextStyles.caption.copyWith(
          color: color,
          fontWeight: FontWeight.w600,
          fontSize: 10,
        ),
      ),
    );
  }
  
  void _showStatusFilter() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: EdgeInsets.all(TossSpacing.space4),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Filter by Status',
              style: TossTextStyles.h4.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(height: TossSpacing.space3),
            ...['All', ...SaleStatus.values.map((s) => s.displayName)].map((status) {
              return ListTile(
                title: Text(status),
                trailing: _selectedStatus == status
                    ? Icon(Icons.check, color: TossColors.primary)
                    : null,
                onTap: () {
                  setState(() {
                    _selectedStatus = status;
                  });
                  Navigator.pop(context);
                },
              );
            }).toList(),
          ],
        ),
      ),
    );
  }
  
  void _showPaymentMethodFilter() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: EdgeInsets.all(TossSpacing.space4),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Filter by Payment Method',
              style: TossTextStyles.h4.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(height: TossSpacing.space3),
            ...['All', ...PaymentMethod.values.map((p) => p.displayName)].map((method) {
              return ListTile(
                title: Text(method),
                trailing: _selectedPaymentMethod == method
                    ? Icon(Icons.check, color: TossColors.primary)
                    : null,
                onTap: () {
                  setState(() {
                    _selectedPaymentMethod = method;
                  });
                  Navigator.pop(context);
                },
              );
            }).toList(),
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
}

// Invoice Detail Sheet
class _InvoiceDetailSheet extends StatelessWidget {
  final Sale sale;
  
  const _InvoiceDetailSheet({required this.sale});
  
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.9,
      padding: EdgeInsets.all(TossSpacing.space4),
      child: Column(
        children: [
          // Handle
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: TossColors.gray300,
              borderRadius: BorderRadius.circular(TossBorderRadius.xs),
            ),
          ),
          
          SizedBox(height: TossSpacing.space3),
          
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Invoice Details',
                style: TossTextStyles.h4.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.share),
                    onPressed: () {
                      // TODO: Share invoice
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.print),
                    onPressed: () {
                      // TODO: Print invoice
                    },
                  ),
                ],
              ),
            ],
          ),
          
          SizedBox(height: TossSpacing.space3),
          
          // Invoice Content
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Invoice Info
                  Container(
                    padding: EdgeInsets.all(TossSpacing.space3),
                    decoration: BoxDecoration(
                      color: TossColors.gray50,
                      borderRadius: BorderRadius.circular(TossBorderRadius.lg),
                    ),
                    child: Column(
                      children: [
                        _buildInfoRow('Invoice No', sale.invoiceNumber),
                        _buildInfoRow('Date', DateFormat('MMM dd, yyyy HH:mm').format(sale.saleDate)),
                        _buildInfoRow('Customer', sale.customerName),
                        if (sale.customerPhone != null)
                          _buildInfoRow('Phone', sale.customerPhone!),
                        _buildInfoRow('Payment', sale.paymentMethod.displayName),
                        _buildInfoRow('Status', sale.status.displayName),
                      ],
                    ),
                  ),
                  
                  SizedBox(height: TossSpacing.space3),
                  
                  // Items
                  Text(
                    'Items',
                    style: TossTextStyles.body.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(height: TossSpacing.space2),
                  
                  // TODO: Add items list
                  Container(
                    padding: EdgeInsets.all(TossSpacing.space3),
                    decoration: BoxDecoration(
                      border: Border.all(color: TossColors.gray200),
                      borderRadius: BorderRadius.circular(TossBorderRadius.lg),
                    ),
                    child: Text('Items will be displayed here'),
                  ),
                  
                  SizedBox(height: TossSpacing.space3),
                  
                  // Summary
                  Container(
                    padding: EdgeInsets.all(TossSpacing.space3),
                    decoration: BoxDecoration(
                      color: TossColors.primary.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(TossBorderRadius.lg),
                    ),
                    child: Column(
                      children: [
                        _buildSummaryRow('Subtotal', sale.subtotal),
                        if (sale.discountAmount > 0)
                          _buildSummaryRow('Discount', -sale.discountAmount, color: TossColors.success),
                        _buildSummaryRow('Tax', sale.taxAmount),
                        Divider(),
                        _buildSummaryRow('Total', sale.totalAmount, isTotal: true),
                      ],
                    ),
                  ),
                  
                  if (sale.notes != null) ...[
                    SizedBox(height: TossSpacing.space3),
                    Text(
                      'Notes',
                      style: TossTextStyles.body.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: TossSpacing.space2),
                    Container(
                      padding: EdgeInsets.all(TossSpacing.space3),
                      decoration: BoxDecoration(
                        color: TossColors.gray50,
                        borderRadius: BorderRadius.circular(TossBorderRadius.lg),
                      ),
                      child: Text(sale.notes!),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildInfoRow(String label, String value) {
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
  
  Widget _buildSummaryRow(String label, double value, {bool isTotal = false, Color? color}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: TossSpacing.space1),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: isTotal
                ? TossTextStyles.body.copyWith(fontWeight: FontWeight.w700)
                : TossTextStyles.caption.copyWith(color: TossColors.gray600),
          ),
          Text(
            _formatCurrency(value.abs()),
            style: isTotal
                ? TossTextStyles.bodyLarge.copyWith(
                    fontWeight: FontWeight.w700,
                    color: TossColors.primary,
                  )
                : TossTextStyles.bodySmall.copyWith(
                    fontWeight: FontWeight.w500,
                    color: color,
                  ),
          ),
        ],
      ),
    );
  }
  
  String _formatCurrency(double value) {
    final formatter = NumberFormat.currency(
      locale: 'ko_KR',
      symbol: '₩',
      decimalDigits: 0,
    );
    return formatter.format(value);
  }
}