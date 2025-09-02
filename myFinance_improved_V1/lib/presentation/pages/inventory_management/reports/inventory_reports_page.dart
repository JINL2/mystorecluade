import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/themes/index.dart';
import '../../../widgets/common/toss_scaffold.dart';
import '../../../helpers/navigation_helper.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';

class InventoryReportsPage extends ConsumerStatefulWidget {
  const InventoryReportsPage({Key? key}) : super(key: key);

  @override
  ConsumerState<InventoryReportsPage> createState() => _InventoryReportsPageState();
}

class _InventoryReportsPageState extends ConsumerState<InventoryReportsPage> 
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _selectedPeriod = 'This Month';
  DateTimeRange? _customDateRange;
  
  // Report Data
  final Map<String, double> _salesByCategory = {
    'Bags': 3500000,
    'Accessories': 2100000,
    'Clothing': 1800000,
    'Shoes': 1200000,
    'Jewelry': 900000,
  };
  
  final List<FlSpot> _salesTrend = [
    FlSpot(0, 1.2),
    FlSpot(1, 1.8),
    FlSpot(2, 1.5),
    FlSpot(3, 2.3),
    FlSpot(4, 2.8),
    FlSpot(5, 2.1),
    FlSpot(6, 3.5),
  ];
  
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }
  
  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
  
  Future<void> _selectDateRange() async {
    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime.now().subtract(Duration(days: 365)),
      lastDate: DateTime.now(),
      initialDateRange: _customDateRange,
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
        _customDateRange = picked;
        _selectedPeriod = 'Custom';
      });
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
        title: const Text('Inventory Reports'),
        centerTitle: true,
        backgroundColor: TossColors.gray100,
        foregroundColor: TossColors.black,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(TossIcons.download),
            onPressed: () {
              // TODO: Export reports
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Exporting reports...'),
                  backgroundColor: TossColors.info,
                ),
              );
            },
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          labelColor: TossColors.primary,
          unselectedLabelColor: TossColors.gray600,
          indicatorColor: TossColors.primary,
          isScrollable: true,
          tabs: [
            Tab(text: 'Overview'),
            Tab(text: 'Sales Analysis'),
            Tab(text: 'Stock Status'),
            Tab(text: 'Performance'),
          ],
        ),
      ),
      body: Column(
        children: [
          // Period Selector
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
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  ...['Today', 'This Week', 'This Month', 'This Quarter', 'This Year', 'Custom'].map((period) {
                    final isSelected = _selectedPeriod == period;
                    return Padding(
                      padding: EdgeInsets.only(right: TossSpacing.space2),
                      child: ChoiceChip(
                        label: Text(period),
                        selected: isSelected,
                        onSelected: (selected) {
                          if (selected) {
                            if (period == 'Custom') {
                              _selectDateRange();
                            } else {
                              setState(() {
                                _selectedPeriod = period;
                                _customDateRange = null;
                              });
                            }
                          }
                        },
                        selectedColor: TossColors.primary.withOpacity(0.2),
                        labelStyle: TextStyle(
                          color: isSelected ? TossColors.primary : TossColors.gray600,
                          fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                        ),
                      ),
                    );
                  }).toList(),
                  if (_customDateRange != null)
                    Padding(
                      padding: EdgeInsets.only(left: TossSpacing.space2),
                      child: Text(
                        '${DateFormat('MM/dd').format(_customDateRange!.start)} - ${DateFormat('MM/dd').format(_customDateRange!.end)}',
                        style: TossTextStyles.caption.copyWith(
                          color: TossColors.gray600,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
          
          // Report Content
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildOverviewTab(),
                _buildSalesAnalysisTab(),
                _buildStockStatusTab(),
                _buildPerformanceTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildOverviewTab() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(TossSpacing.space4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Key Metrics Grid
          GridView.count(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            mainAxisSpacing: TossSpacing.space3,
            crossAxisSpacing: TossSpacing.space3,
            childAspectRatio: 1.5,
            children: [
              _buildMetricCard(
                'Total Revenue',
                '₩9.5M',
                '+12.5%',
                Icons.trending_up,
                TossColors.success,
              ),
              _buildMetricCard(
                'Products Sold',
                '342',
                '+8.3%',
                Icons.shopping_cart,
                TossColors.primary,
              ),
              _buildMetricCard(
                'Avg Order Value',
                '₩278K',
                '+5.2%',
                Icons.receipt_long,
                TossColors.info,
              ),
              _buildMetricCard(
                'Stock Value',
                '₩45.2M',
                '-2.1%',
                Icons.inventory_2,
                TossColors.warning,
              ),
            ],
          ),
          
          SizedBox(height: TossSpacing.space4),
          
          // Sales Trend Chart
          Container(
            height: 250,
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
                  'Sales Trend',
                  style: TossTextStyles.bodyLarge.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: TossSpacing.space3),
                Expanded(
                  child: LineChart(
                    LineChartData(
                      gridData: FlGridData(
                        show: true,
                        drawVerticalLine: false,
                        getDrawingHorizontalLine: (value) {
                          return FlLine(
                            color: TossColors.gray200,
                            strokeWidth: 1,
                          );
                        },
                      ),
                      titlesData: FlTitlesData(
                        leftTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 40,
                            getTitlesWidget: (value, meta) {
                              return Text(
                                '${value.toInt()}M',
                                style: TossTextStyles.caption.copyWith(
                                  color: TossColors.gray600,
                                ),
                              );
                            },
                          ),
                        ),
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            getTitlesWidget: (value, meta) {
                              final days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
                              return Text(
                                days[value.toInt()],
                                style: TossTextStyles.caption.copyWith(
                                  color: TossColors.gray600,
                                ),
                              );
                            },
                          ),
                        ),
                        rightTitles: AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        topTitles: AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                      ),
                      borderData: FlBorderData(show: false),
                      lineBarsData: [
                        LineChartBarData(
                          spots: _salesTrend,
                          isCurved: true,
                          color: TossColors.primary,
                          barWidth: 3,
                          dotData: FlDotData(
                            show: true,
                            getDotPainter: (spot, percent, barData, index) {
                              return FlDotCirclePainter(
                                radius: 4,
                                color: TossColors.white,
                                strokeWidth: 2,
                                strokeColor: TossColors.primary,
                              );
                            },
                          ),
                          belowBarData: BarAreaData(
                            show: true,
                            color: TossColors.primary.withOpacity(0.1),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          SizedBox(height: TossSpacing.space4),
          
          // Top Products
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Top Selling Products',
                      style: TossTextStyles.bodyLarge.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        _tabController.animateTo(1);
                      },
                      child: Text('View All'),
                    ),
                  ],
                ),
                SizedBox(height: TossSpacing.space2),
                ...List.generate(5, (index) {
                  return _buildTopProductItem(
                    'Premium Handbag ${index + 1}',
                    'HD-BAG-00${index + 1}',
                    45 - (index * 8),
                    1200000 - (index * 150000),
                  );
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildSalesAnalysisTab() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(TossSpacing.space4),
      child: Column(
        children: [
          // Sales by Category
          Container(
            height: 300,
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
                  'Sales by Category',
                  style: TossTextStyles.bodyLarge.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: TossSpacing.space3),
                Expanded(
                  child: PieChart(
                    PieChartData(
                      sectionsSpace: 2,
                      centerSpaceRadius: 40,
                      sections: _salesByCategory.entries.map((entry) {
                        final index = _salesByCategory.keys.toList().indexOf(entry.key);
                        final colors = [
                          TossColors.primary,
                          TossColors.info,
                          TossColors.success,
                          TossColors.warning,
                          TossColors.error,
                        ];
                        final total = _salesByCategory.values.reduce((a, b) => a + b);
                        final percentage = (entry.value / total * 100).toStringAsFixed(1);
                        
                        return PieChartSectionData(
                          color: colors[index % colors.length],
                          value: entry.value,
                          title: '$percentage%',
                          radius: 80,
                          titleStyle: TossTextStyles.caption.copyWith(
                            color: TossColors.white,
                            fontWeight: FontWeight.w700,
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
                // Legend
                Wrap(
                  spacing: TossSpacing.space3,
                  runSpacing: TossSpacing.space2,
                  children: _salesByCategory.entries.map((entry) {
                    final index = _salesByCategory.keys.toList().indexOf(entry.key);
                    final colors = [
                      TossColors.primary,
                      TossColors.info,
                      TossColors.success,
                      TossColors.warning,
                      TossColors.error,
                    ];
                    
                    return Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 12,
                          height: 12,
                          decoration: BoxDecoration(
                            color: colors[index % colors.length],
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                        SizedBox(width: 4),
                        Text(
                          '${entry.key}: ₩${(entry.value / 1000000).toStringAsFixed(1)}M',
                          style: TossTextStyles.caption,
                        ),
                      ],
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
          
          SizedBox(height: TossSpacing.space3),
          
          // Product Performance Table
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
                  'Product Performance',
                  style: TossTextStyles.bodyLarge.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: TossSpacing.space3),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    columns: [
                      DataColumn(label: Text('Product')),
                      DataColumn(label: Text('Sold')),
                      DataColumn(label: Text('Revenue')),
                      DataColumn(label: Text('Margin')),
                    ],
                    rows: List.generate(10, (index) {
                      return DataRow(
                        cells: [
                          DataCell(Text('Product ${index + 1}')),
                          DataCell(Text('${45 - index * 3}')),
                          DataCell(Text('₩${((2.5 - index * 0.2) * 1000).toInt()}K')),
                          DataCell(
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: TossSpacing.space1,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: TossColors.success.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                '${35 - index}%',
                                style: TossTextStyles.caption.copyWith(
                                  color: TossColors.success,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    }),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildStockStatusTab() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(TossSpacing.space4),
      child: Column(
        children: [
          // Stock Level Summary
          Row(
            children: [
              Expanded(
                child: _buildStockCard(
                  'Optimal Stock',
                  '234',
                  TossColors.success,
                  Icons.check_circle,
                ),
              ),
              SizedBox(width: TossSpacing.space3),
              Expanded(
                child: _buildStockCard(
                  'Low Stock',
                  '45',
                  TossColors.warning,
                  Icons.warning,
                ),
              ),
              SizedBox(width: TossSpacing.space3),
              Expanded(
                child: _buildStockCard(
                  'Out of Stock',
                  '12',
                  TossColors.error,
                  Icons.error,
                ),
              ),
            ],
          ),
          
          SizedBox(height: TossSpacing.space3),
          
          // Stock Turnover
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
                  'Stock Turnover Analysis',
                  style: TossTextStyles.bodyLarge.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: TossSpacing.space3),
                
                _buildTurnoverItem('Fast Moving', 'Less than 30 days', 145, TossColors.success),
                _buildTurnoverItem('Normal', '30-60 days', 89, TossColors.primary),
                _buildTurnoverItem('Slow Moving', '60-90 days', 34, TossColors.warning),
                _buildTurnoverItem('Dead Stock', 'More than 90 days', 23, TossColors.error),
              ],
            ),
          ),
          
          SizedBox(height: TossSpacing.space3),
          
          // Reorder Recommendations
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Reorder Recommendations',
                      style: TossTextStyles.bodyLarge.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: TossSpacing.space2,
                        vertical: TossSpacing.space1,
                      ),
                      decoration: BoxDecoration(
                        color: TossColors.error.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(TossBorderRadius.lg),
                      ),
                      child: Text(
                        '8 items',
                        style: TossTextStyles.caption.copyWith(
                          color: TossColors.error,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: TossSpacing.space3),
                
                ...List.generate(5, (index) {
                  return Container(
                    margin: EdgeInsets.only(bottom: TossSpacing.space2),
                    padding: EdgeInsets.all(TossSpacing.space2),
                    decoration: BoxDecoration(
                      color: TossColors.gray50,
                      borderRadius: BorderRadius.circular(TossBorderRadius.md),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: TossColors.error.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(TossBorderRadius.md),
                          ),
                          child: Icon(
                            Icons.priority_high,
                            color: TossColors.error,
                            size: 20,
                          ),
                        ),
                        SizedBox(width: TossSpacing.space2),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Product Name ${index + 1}',
                                style: TossTextStyles.bodySmall.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Text(
                                'Current: ${5 - index} | Reorder: 20',
                                style: TossTextStyles.caption.copyWith(
                                  color: TossColors.gray600,
                                ),
                              ),
                            ],
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            NavigationHelper.navigateTo(
                              context,
                              '/inventoryManagement/purchaseOrder',
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: TossColors.primary,
                            padding: EdgeInsets.symmetric(
                              horizontal: TossSpacing.space3,
                              vertical: TossSpacing.space1,
                            ),
                          ),
                          child: Text('Order'),
                        ),
                      ],
                    ),
                  );
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildPerformanceTab() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(TossSpacing.space4),
      child: Column(
        children: [
          // KPI Cards
          GridView.count(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            mainAxisSpacing: TossSpacing.space3,
            crossAxisSpacing: TossSpacing.space3,
            childAspectRatio: 1.8,
            children: [
              _buildKPICard('Gross Margin', '42.5%', '+2.3%', true),
              _buildKPICard('Inventory Turnover', '4.2x', '+0.5x', true),
              _buildKPICard('Stock Accuracy', '98.5%', '+1.2%', true),
              _buildKPICard('Shrinkage Rate', '0.8%', '-0.2%', false),
              _buildKPICard('Fill Rate', '95.2%', '+3.1%', true),
              _buildKPICard('Days on Hand', '45', '-5', false),
            ],
          ),
          
          SizedBox(height: TossSpacing.space3),
          
          // Performance Trends
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
                  'Performance Trends',
                  style: TossTextStyles.bodyLarge.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: TossSpacing.space3),
                
                Container(
                  height: 200,
                  child: BarChart(
                    BarChartData(
                      alignment: BarChartAlignment.spaceAround,
                      maxY: 100,
                      barTouchData: BarTouchData(enabled: false),
                      titlesData: FlTitlesData(
                        leftTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 30,
                            getTitlesWidget: (value, meta) {
                              return Text(
                                '${value.toInt()}%',
                                style: TossTextStyles.caption.copyWith(
                                  color: TossColors.gray600,
                                ),
                              );
                            },
                          ),
                        ),
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            getTitlesWidget: (value, meta) {
                              final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun'];
                              return Text(
                                months[value.toInt()],
                                style: TossTextStyles.caption.copyWith(
                                  color: TossColors.gray600,
                                ),
                              );
                            },
                          ),
                        ),
                        rightTitles: AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        topTitles: AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                      ),
                      gridData: FlGridData(
                        show: true,
                        drawVerticalLine: false,
                        getDrawingHorizontalLine: (value) {
                          return FlLine(
                            color: TossColors.gray200,
                            strokeWidth: 1,
                          );
                        },
                      ),
                      borderData: FlBorderData(show: false),
                      barGroups: List.generate(6, (index) {
                        return BarChartGroupData(
                          x: index,
                          barRods: [
                            BarChartRodData(
                              toY: 70 + (index * 5).toDouble(),
                              color: TossColors.primary,
                              width: 20,
                              borderRadius: BorderRadius.vertical(
                                top: Radius.circular(4),
                              ),
                            ),
                          ],
                        );
                      }),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildMetricCard(String title, String value, String change, IconData icon, Color color) {
    final isPositive = change.startsWith('+');
    
    return Container(
      padding: EdgeInsets.all(TossSpacing.space3),
      decoration: BoxDecoration(
        color: TossColors.white,
        borderRadius: BorderRadius.circular(TossBorderRadius.lg),
        border: Border.all(color: TossColors.gray200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(icon, color: color, size: 24),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: TossSpacing.space1,
                  vertical: 2,
                ),
                decoration: BoxDecoration(
                  color: (isPositive ? TossColors.success : TossColors.error).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  change,
                  style: TossTextStyles.caption.copyWith(
                    color: isPositive ? TossColors.success : TossColors.error,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: TossTextStyles.h4.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              Text(
                title,
                style: TossTextStyles.caption.copyWith(
                  color: TossColors.gray600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
  
  Widget _buildTopProductItem(String name, String sku, int sold, double revenue) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: TossSpacing.space2),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: TossColors.gray100),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: TossTextStyles.bodySmall.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  sku,
                  style: TossTextStyles.caption.copyWith(
                    color: TossColors.gray600,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '$sold sold',
                style: TossTextStyles.bodySmall,
              ),
              Text(
                '₩${(revenue / 1000000).toStringAsFixed(1)}M',
                style: TossTextStyles.caption.copyWith(
                  color: TossColors.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
  
  Widget _buildStockCard(String title, String value, Color color, IconData icon) {
    return Container(
      padding: EdgeInsets.all(TossSpacing.space2),
      decoration: BoxDecoration(
        color: color.withOpacity(0.05),
        borderRadius: BorderRadius.circular(TossBorderRadius.lg),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          SizedBox(height: TossSpacing.space1),
          Text(
            value,
            style: TossTextStyles.h4.copyWith(
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
          Text(
            title,
            style: TossTextStyles.caption.copyWith(
              color: TossColors.gray600,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
  
  Widget _buildTurnoverItem(String title, String period, int count, Color color) {
    final total = 291;
    final percentage = (count / total * 100).toStringAsFixed(1);
    
    return Container(
      margin: EdgeInsets.only(bottom: TossSpacing.space2),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: color,
                      shape: BoxShape.circle,
                    ),
                  ),
                  SizedBox(width: TossSpacing.space1),
                  Text(
                    title,
                    style: TossTextStyles.bodySmall.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(width: TossSpacing.space1),
                  Text(
                    '($period)',
                    style: TossTextStyles.caption.copyWith(
                      color: TossColors.gray600,
                    ),
                  ),
                ],
              ),
              Text(
                '$count items ($percentage%)',
                style: TossTextStyles.caption.copyWith(
                  color: TossColors.gray600,
                ),
              ),
            ],
          ),
          SizedBox(height: 4),
          LinearProgressIndicator(
            value: count / total,
            backgroundColor: TossColors.gray200,
            valueColor: AlwaysStoppedAnimation(color),
            minHeight: 4,
          ),
        ],
      ),
    );
  }
  
  Widget _buildKPICard(String title, String value, String change, bool isPositive) {
    return Container(
      padding: EdgeInsets.all(TossSpacing.space2),
      decoration: BoxDecoration(
        color: TossColors.white,
        borderRadius: BorderRadius.circular(TossBorderRadius.lg),
        border: Border.all(color: TossColors.gray200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TossTextStyles.caption.copyWith(
              color: TossColors.gray600,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                value,
                style: TossTextStyles.bodyLarge.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: TossSpacing.space1,
                  vertical: 2,
                ),
                decoration: BoxDecoration(
                  color: (isPositive ? TossColors.success : TossColors.error).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      isPositive ? Icons.arrow_upward : Icons.arrow_downward,
                      size: 12,
                      color: isPositive ? TossColors.success : TossColors.error,
                    ),
                    Text(
                      change,
                      style: TossTextStyles.caption.copyWith(
                        color: isPositive ? TossColors.success : TossColors.error,
                        fontWeight: FontWeight.w600,
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
}