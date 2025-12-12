// Presentation Page: Task Sheet Detail
// Page for counting inventory items in a task sheet

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../shared/themes/toss_colors.dart';
import '../../../../shared/themes/toss_spacing.dart';
import '../../../../shared/themes/toss_text_styles.dart';
import '../../../../shared/widgets/toss/toss_primary_button.dart';
import '../../../../shared/widgets/toss/toss_quantity_stepper.dart';
import '../../../../shared/widgets/toss/toss_search_field.dart';
import '../../domain/entities/product.dart';
import '../providers/inventory_providers.dart';

/// Result returned when exiting the task sheet detail page
class TaskSheetResult {
  final bool isCompleted;
  final bool isDraft;
  final int itemsCount;
  final int totalQuantity;
  final Map<String, int> countedQuantities;

  const TaskSheetResult({
    this.isCompleted = false,
    this.isDraft = false,
    this.itemsCount = 0,
    this.totalQuantity = 0,
    this.countedQuantities = const {},
  });
}

/// Task Sheet Detail Page for counting inventory items
class TaskSheetDetailPage extends ConsumerStatefulWidget {
  final String taskSheetId;
  final String taskSheetName;
  final Map<String, int> initialCountedQuantities;

  const TaskSheetDetailPage({
    super.key,
    required this.taskSheetId,
    required this.taskSheetName,
    this.initialCountedQuantities = const {},
  });

  @override
  ConsumerState<TaskSheetDetailPage> createState() =>
      _TaskSheetDetailPageState();
}

class _TaskSheetDetailPageState extends ConsumerState<TaskSheetDetailPage> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  Timer? _searchDebounceTimer;
  String _searchQuery = '';

  // Map of product ID to counted quantity
  late Map<String, int> _countedQuantities;

  // Filtered products based on search
  List<Product> _filteredProducts = [];

  // Whether the bottom summary is expanded
  bool _isBottomExpanded = false;

  @override
  void initState() {
    super.initState();
    // Initialize counted quantities from passed data
    _countedQuantities = Map<String, int>.from(widget.initialCountedQuantities);
    // Initialize with all products
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final pageState = ref.read(inventoryPageProvider);
      setState(() {
        _filteredProducts = pageState.products;
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    _searchDebounceTimer?.cancel();
    super.dispose();
  }

  void _onSearchChanged(String value) {
    setState(() {
      _searchQuery = value;
    });

    _searchDebounceTimer?.cancel();
    _searchDebounceTimer = Timer(const Duration(milliseconds: 200), () {
      _performSearch(value);
    });
  }

  void _performSearch(String query) {
    final pageState = ref.read(inventoryPageProvider);
    final allProducts = pageState.products;

    if (query.isEmpty) {
      setState(() {
        _filteredProducts = allProducts;
      });
      return;
    }

    final queryLower = query.toLowerCase();
    final results = allProducts.where((product) {
      final nameLower = product.name.toLowerCase();
      final skuLower = product.sku.toLowerCase();
      final categoryLower = product.categoryName?.toLowerCase() ?? '';
      final brandLower = product.brandName?.toLowerCase() ?? '';

      return nameLower.contains(queryLower) ||
          skuLower.contains(queryLower) ||
          categoryLower.contains(queryLower) ||
          brandLower.contains(queryLower);
    }).toList();

    setState(() {
      _filteredProducts = results;
    });
  }

  int get _itemsCounted =>
      _countedQuantities.values.where((qty) => qty > 0).length;

  int get _totalQuantity =>
      _countedQuantities.values.fold(0, (sum, qty) => sum + qty);

  /// Get list of products that have been counted (quantity > 0)
  List<Product> get _countedProducts {
    final pageState = ref.read(inventoryPageProvider);
    return pageState.products.where((product) {
      final qty = _countedQuantities[product.id] ?? 0;
      return qty > 0;
    }).toList();
  }

  void _incrementQuantity(String productId) {
    setState(() {
      _countedQuantities[productId] = (_countedQuantities[productId] ?? 0) + 1;
    });
  }

  void _decrementQuantity(String productId) {
    setState(() {
      final currentQty = _countedQuantities[productId] ?? 0;
      if (currentQty > 0) {
        _countedQuantities[productId] = currentQty - 1;
      }
    });
  }

  void _setQuantity(String productId, int quantity) {
    setState(() {
      _countedQuantities[productId] = quantity;
    });
  }

  void _showQuantityInputDialog(Product product) {
    final currentQty = _countedQuantities[product.id] ?? 0;
    int selectedQty = currentQty;

    showDialog<void>(
      context: context,
      builder: (dialogContext) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        insetPadding: const EdgeInsets.symmetric(horizontal: 40),
        child: Container(
          width: double.maxFinite,
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Enter Count Quantity',
                style: TossTextStyles.h3.copyWith(
                  fontWeight: FontWeight.w700,
                  color: TossColors.gray900,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                product.name,
                style: TossTextStyles.body.copyWith(
                  color: TossColors.gray900,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Text(
                product.sku,
                style: TossTextStyles.caption.copyWith(
                  color: TossColors.gray500,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              TossQuantityStepper(
                initialValue: currentQty,
                minValue: 0,
                onChanged: (value) {
                  selectedQty = value;
                },
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () => Navigator.pop(dialogContext),
                      child: Text(
                        'Cancel',
                        style: TossTextStyles.body.copyWith(
                          color: TossColors.gray600,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        _setQuantity(product.id, selectedQty);
                        Navigator.pop(dialogContext);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: TossColors.primary,
                        foregroundColor: TossColors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      child: const Text('Submit'),
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

  void _saveDraft() {
    // Return result with draft status
    Navigator.pop(
      context,
      TaskSheetResult(
        isDraft: true,
        itemsCount: _itemsCounted,
        totalQuantity: _totalQuantity,
        countedQuantities: Map<String, int>.from(_countedQuantities),
      ),
    );
  }

  void _completeCounting() {
    // Return result with completed status - user can go back and continue counting if needed
    Navigator.pop(
      context,
      TaskSheetResult(
        isCompleted: true,
        itemsCount: _itemsCounted,
        totalQuantity: _totalQuantity,
        countedQuantities: Map<String, int>.from(_countedQuantities),
      ),
    );
  }

  void _showMoreOptions() {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: TossColors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle bar
            Center(
              child: Container(
                margin: const EdgeInsets.only(top: 12),
                width: 36,
                height: 4,
                decoration: BoxDecoration(
                  color: TossColors.gray300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.edit_outlined),
              title: const Text('Edit Task Sheet'),
              onTap: () {
                Navigator.pop(context);
                // TODO: Implement edit
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete_outline, color: TossColors.loss),
              title: Text(
                'Delete Task Sheet',
                style: TossTextStyles.body.copyWith(color: TossColors.loss),
              ),
              onTap: () {
                Navigator.pop(context);
                // TODO: Implement delete
              },
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final pageState = ref.watch(inventoryPageProvider);

    // Update filtered products when inventory changes
    if (_searchQuery.isEmpty && _filteredProducts.isEmpty) {
      _filteredProducts = pageState.products;
    }

    return Scaffold(
      backgroundColor: TossColors.white,
      appBar: _buildAppBar(),
      body: Column(
        children: [
          // Search bar
          _buildSearchBar(),
          // Product list
          Expanded(
            child: _buildProductList(),
          ),
          // Bottom summary and actions
          _buildBottomBar(),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: TossColors.white,
      elevation: 0,
      scrolledUnderElevation: 0,
      leading: IconButton(
        onPressed: () => Navigator.of(context).maybePop(),
        icon: const Icon(
          Icons.arrow_back,
          color: TossColors.gray900,
          size: 24,
        ),
      ),
      title: Text(
        widget.taskSheetName,
        style: TossTextStyles.titleMedium.copyWith(
          fontWeight: FontWeight.w700,
          color: TossColors.gray900,
        ),
      ),
      centerTitle: true,
      actions: [
        IconButton(
          onPressed: _showMoreOptions,
          icon: const Icon(
            Icons.more_horiz,
            color: TossColors.gray900,
            size: 24,
          ),
        ),
      ],
    );
  }

  Widget _buildSearchBar() {
    return Container(
      padding: const EdgeInsets.all(TossSpacing.space4),
      child: TossSearchField(
        controller: _searchController,
        focusNode: _searchFocusNode,
        hintText: 'You can search by name, product code, product type,...',
        onChanged: _onSearchChanged,
        onClear: () {
          setState(() {
            _searchQuery = '';
            final pageState = ref.read(inventoryPageProvider);
            _filteredProducts = pageState.products;
          });
        },
      ),
    );
  }

  Widget _buildProductList() {
    if (_filteredProducts.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.inventory_2_outlined,
              size: 64,
              color: TossColors.gray400,
            ),
            const SizedBox(height: TossSpacing.space3),
            Text(
              'No products found',
              style: TossTextStyles.body.copyWith(
                color: TossColors.gray500,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: TossSpacing.space4),
      itemCount: _filteredProducts.length,
      itemBuilder: (context, index) {
        final product = _filteredProducts[index];
        return _buildProductItem(product);
      },
    );
  }

  Widget _buildProductItem(Product product) {
    final countedQty = _countedQuantities[product.id] ?? 0;
    final hasCount = countedQty > 0;

    return GestureDetector(
      onTap: () => _showQuantityInputDialog(product),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: TossSpacing.space3),
        child: Row(
          children: [
            // Product image
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: TossColors.gray100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: product.images.isNotEmpty
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        product.images.first,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            const Icon(
                          Icons.image_outlined,
                          color: TossColors.gray400,
                          size: 24,
                        ),
                      ),
                    )
                  : const Icon(
                      Icons.image_outlined,
                      color: TossColors.gray400,
                      size: 24,
                    ),
            ),
            const SizedBox(width: TossSpacing.space3),
            // Product info
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
                  const SizedBox(height: 2),
                  Text(
                    product.sku,
                    style: TossTextStyles.caption.copyWith(
                      color: TossColors.gray500,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${product.brandName ?? 'No brand'} | ${product.categoryName ?? 'No category'}',
                    style: TossTextStyles.caption.copyWith(
                      color: TossColors.gray500,
                    ),
                  ),
                ],
              ),
            ),
            // Quantity
            GestureDetector(
              onTap: () => _showQuantityInputDialog(product),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: TossSpacing.space3,
                  vertical: TossSpacing.space2,
                ),
                child: Text(
                  '$countedQty',
                  style: TossTextStyles.body.copyWith(
                    fontWeight: FontWeight.w600,
                    color: hasCount ? TossColors.primary : TossColors.gray400,
                    fontSize: 18,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomBar() {
    final countedProducts = _countedProducts;
    final hasCountedItems = countedProducts.isNotEmpty;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      decoration: BoxDecoration(
        color: TossColors.white,
        boxShadow: [
          BoxShadow(
            color: TossColors.gray900.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Expandable handle
            GestureDetector(
              onTap: hasCountedItems
                  ? () {
                      setState(() {
                        _isBottomExpanded = !_isBottomExpanded;
                      });
                    }
                  : null,
              child: Container(
                padding: const EdgeInsets.only(top: TossSpacing.space2),
                child: Icon(
                  _isBottomExpanded
                      ? Icons.keyboard_arrow_down
                      : Icons.keyboard_arrow_up,
                  color: hasCountedItems
                      ? TossColors.gray600
                      : TossColors.gray300,
                  size: 24,
                ),
              ),
            ),
            // Expanded items list
            if (_isBottomExpanded && hasCountedItems) ...[
              const SizedBox(height: TossSpacing.space2),
              Container(
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height * 0.35,
                ),
                child: ListView.builder(
                  shrinkWrap: true,
                  padding: const EdgeInsets.symmetric(
                    horizontal: TossSpacing.space4,
                  ),
                  itemCount: countedProducts.length,
                  itemBuilder: (context, index) {
                    final product = countedProducts[index];
                    final qty = _countedQuantities[product.id] ?? 0;
                    return _buildCountedItemRow(product, qty);
                  },
                ),
              ),
              const Divider(height: 1, color: TossColors.gray200),
            ],
            Padding(
              padding: const EdgeInsets.all(TossSpacing.space4),
              child: Column(
                children: [
                  // Summary
                  Text(
                    'Item Counted: $_itemsCounted | Total Quantity: $_totalQuantity',
                    style: TossTextStyles.body.copyWith(
                      color: TossColors.gray900,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: TossSpacing.space3),
                  // Action buttons
                  Row(
                    children: [
                      // Save Draft button
                      Expanded(
                        child: GestureDetector(
                          onTap: _saveDraft,
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            decoration: BoxDecoration(
                              color: TossColors.white,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: TossColors.primary,
                                width: 1,
                              ),
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              'Save Draft',
                              style: TossTextStyles.body.copyWith(
                                fontWeight: FontWeight.w600,
                                color: TossColors.primary,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: TossSpacing.space3),
                      // Complete Counting button
                      Expanded(
                        flex: 2,
                        child: TossPrimaryButton(
                          text: 'Complete Counting',
                          onPressed: _completeCounting,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCountedItemRow(Product product, int quantity) {
    return GestureDetector(
      onTap: () => _showQuantityInputDialog(product),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: TossSpacing.space2),
        child: Row(
          children: [
            // Product image
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: TossColors.gray100,
                borderRadius: BorderRadius.circular(6),
              ),
              child: product.images.isNotEmpty
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: Image.network(
                        product.images.first,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => const Icon(
                          Icons.image_outlined,
                          color: TossColors.gray400,
                          size: 18,
                        ),
                      ),
                    )
                  : const Icon(
                      Icons.image_outlined,
                      color: TossColors.gray400,
                      size: 18,
                    ),
            ),
            const SizedBox(width: TossSpacing.space3),
            // Product info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    style: TossTextStyles.caption.copyWith(
                      fontWeight: FontWeight.w600,
                      color: TossColors.gray900,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    product.sku,
                    style: TossTextStyles.small.copyWith(
                      color: TossColors.gray500,
                    ),
                  ),
                ],
              ),
            ),
            // Quantity only (no edit icon)
            Text(
              '$quantity',
              style: TossTextStyles.body.copyWith(
                fontWeight: FontWeight.w600,
                color: TossColors.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
