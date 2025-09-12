import 'package:flutter/material.dart';
import '../../../../core/themes/index.dart';
import '../models/product_model.dart';
import 'package:myfinance_improved/core/themes/toss_border_radius.dart';
class FilterBottomSheet extends StatefulWidget {
  final StockStatus? selectedStockStatus;
  final ProductCategory? selectedCategory;
  final String? selectedBrand;
  final RangeValues priceRange;
  final Function(
    StockStatus?,
    ProductCategory?,
    String?,
    RangeValues,
  ) onApply;

  const FilterBottomSheet({
    Key? key,
    this.selectedStockStatus,
    this.selectedCategory,
    this.selectedBrand,
    required this.priceRange,
    required this.onApply,
  }) : super(key: key);

  @override
  State<FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<FilterBottomSheet> {
  late StockStatus? _stockStatus;
  late ProductCategory? _category;
  late String? _brand;
  late RangeValues _priceRange;
  
  final List<String> _brands = [
    'GOYARD',
    'HERMES',
    'CHANEL',
    'LOUIS VUITTON',
    'GUCCI',
    'PRADA',
    'DIOR',
    'CELINE',
  ];

  @override
  void initState() {
    super.initState();
    _stockStatus = widget.selectedStockStatus;
    _category = widget.selectedCategory;
    _brand = widget.selectedBrand;
    _priceRange = widget.priceRange;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      decoration: const BoxDecoration(
        color: TossColors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(TossBorderRadius.xxl)),
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle bar
            Container(
              margin: const EdgeInsets.only(top: TossSpacing.space3),
              width: TossSpacing.space10,
              height: TossSpacing.space1,
              decoration: BoxDecoration(
                color: TossColors.gray300,
                borderRadius: BorderRadius.circular(TossBorderRadius.xs),
              ),
            ),
            
            // Title
            Padding(
              padding: const EdgeInsets.all(TossSpacing.paddingMD),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Filters',
                    style: TossTextStyles.h3
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  TextButton(
                    onPressed: _clearAll,
                    child: const Text('Clear All'),
                  ),
                ],
              ),
            ),
            
            const Divider(height: 1),
            
            // Stock Status
            _buildSection(
              'Stock Status',
              Wrap(
                spacing: 8,
                children: StockStatus.values.map((status) {
                  return FilterChip(
                    label: Text(_getStatusLabel(status)),
                    selected: _stockStatus == status,
                    onSelected: (selected) {
                      setState(() {
                        _stockStatus = selected ? status : null;
                      });
                    },
                    selectedColor: _getStatusColor(status).withOpacity(0.2),
                    checkmarkColor: _getStatusColor(status),
                  );
                }).toList(),
              ),
            ),
            
            // Category
            _buildSection(
              'Category',
              Wrap(
                spacing: 8,
                children: ProductCategory.values.map((category) {
                  return FilterChip(
                    label: Text(category.name.toUpperCase()),
                    selected: _category == category,
                    onSelected: (selected) {
                      setState(() {
                        _category = selected ? category : null;
                      });
                    },
                  );
                }).toList(),
              ),
            ),
            
            // Brand
            _buildSection(
              'Brand',
              SizedBox(
                height: 40,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: _brands.length,
                  itemBuilder: (context, index) {
                    final brand = _brands[index];
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: FilterChip(
                        label: Text(brand),
                        selected: _brand == brand,
                        onSelected: (selected) {
                          setState(() {
                            _brand = selected ? brand : null;
                          });
                        },
                      ),
                    );
                  },
                ),
              ),
            ),
            
            // Price Range
            _buildSection(
              'Price Range',
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _formatCurrency(_priceRange.start),
                        style: TossTextStyles.body.copyWith(fontWeight: FontWeight.w500),
                      ),
                      Text(
                        _formatCurrency(_priceRange.end),
                        style: TossTextStyles.body.copyWith(fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                  RangeSlider(
                    values: _priceRange,
                    min: 0,
                    max: 10000000,
                    divisions: 100,
                    labels: RangeLabels(
                      _formatCurrency(_priceRange.start),
                      _formatCurrency(_priceRange.end),
                    ),
                    onChanged: (values) {
                      setState(() {
                        _priceRange = values;
                      });
                    },
                  ),
                ],
              ),
            ),
            
            // Apply button
            Container(
              padding: const EdgeInsets.all(TossSpacing.paddingMD),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: TossSpacing.space4),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(TossBorderRadius.lg),
                        ),
                      ),
                      child: const Text('Cancel'),
                    ),
                  ),
                  const SizedBox(width: TossSpacing.space4),
                  Expanded(
                    flex: 2,
                    child: ElevatedButton(
                      onPressed: () {
                        widget.onApply(
                          _stockStatus,
                          _category,
                          _brand,
                          _priceRange,
                        );
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: TossSpacing.space4),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(TossBorderRadius.lg),
                        ),
                      ),
                      child: const Text('Apply Filters'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, Widget content) {
    return Container(
      padding: const EdgeInsets.all(TossSpacing.paddingMD),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TossTextStyles.bodyLarge
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: TossSpacing.space3),
          content,
        ],
      ),
    );
  }

  void _clearAll() {
    setState(() {
      _stockStatus = null;
      _category = null;
      _brand = null;
      _priceRange = const RangeValues(0, 10000000);
    });
  }

  String _getStatusLabel(StockStatus status) {
    switch (status) {
      case StockStatus.critical:
        return 'Critical';
      case StockStatus.low:
        return 'Low Stock';
      case StockStatus.optimal:
        return 'Optimal';
      case StockStatus.excess:
        return 'Excess';
    }
  }

  Color _getStatusColor(StockStatus status) {
    switch (status) {
      case StockStatus.critical:
        return TossColors.error;
      case StockStatus.low:
        return TossColors.warning;
      case StockStatus.optimal:
        return TossColors.success;
      case StockStatus.excess:
        return TossColors.primary;
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