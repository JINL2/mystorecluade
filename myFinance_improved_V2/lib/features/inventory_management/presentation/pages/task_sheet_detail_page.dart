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
  final int totalRejected;
  final Map<String, int> countedQuantities;
  final Map<String, int> rejectedQuantities;

  const TaskSheetResult({
    this.isCompleted = false,
    this.isDraft = false,
    this.itemsCount = 0,
    this.totalQuantity = 0,
    this.totalRejected = 0,
    this.countedQuantities = const {},
    this.rejectedQuantities = const {},
  });
}

/// Task Sheet Detail Page for counting inventory items
class TaskSheetDetailPage extends ConsumerStatefulWidget {
  final String taskSheetId;
  final String taskSheetName;
  final Map<String, int> initialCountedQuantities;
  final Map<String, int> initialRejectedQuantities;

  const TaskSheetDetailPage({
    super.key,
    required this.taskSheetId,
    required this.taskSheetName,
    this.initialCountedQuantities = const {},
    this.initialRejectedQuantities = const {},
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

  // Map of product ID to rejected quantity
  late Map<String, int> _rejectedQuantities;

  // Filtered products based on search
  List<Product> _filteredProducts = [];

  // Whether the bottom summary is expanded
  bool _isBottomExpanded = false;

  @override
  void initState() {
    super.initState();
    // Initialize counted quantities from passed data
    _countedQuantities = Map<String, int>.from(widget.initialCountedQuantities);
    _rejectedQuantities = Map<String, int>.from(widget.initialRejectedQuantities);
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

  int get _totalRejected =>
      _rejectedQuantities.values.fold(0, (sum, qty) => sum + qty);

  /// Get list of products that have been counted (quantity > 0)
  List<Product> get _countedProducts {
    final pageState = ref.read(inventoryPageProvider);
    return pageState.products.where((product) {
      final qty = _countedQuantities[product.id] ?? 0;
      return qty > 0;
    }).toList();
  }

  void _setQuantity(String productId, int quantity, {int rejected = 0}) {
    setState(() {
      _countedQuantities[productId] = quantity;
      _rejectedQuantities[productId] = rejected;
    });
  }

  void _showQuantityInputDialog(Product product) {
    final currentQty = _countedQuantities[product.id] ?? 0;
    final currentRejected = _rejectedQuantities[product.id] ?? 0;

    showDialog<void>(
      context: context,
      builder: (dialogContext) => _StockInQuantityDialog(
        product: product,
        initialQuantity: currentQty,
        initialRejected: currentRejected,
        onSubmit: (quantity, rejected) {
          _setQuantity(product.id, quantity, rejected: rejected);
        },
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
        totalRejected: _totalRejected,
        countedQuantities: Map<String, int>.from(_countedQuantities),
        rejectedQuantities: Map<String, int>.from(_rejectedQuantities),
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
        totalRejected: _totalRejected,
        countedQuantities: Map<String, int>.from(_countedQuantities),
        rejectedQuantities: Map<String, int>.from(_rejectedQuantities),
      ),
    );
  }

  void _editTaskSheet() {
    // TODO: Implement edit task sheet
  }

  void _deleteTaskSheet() {
    // TODO: Implement delete task sheet
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
          onPressed: _editTaskSheet,
          icon: const Icon(
            Icons.edit_outlined,
            color: TossColors.gray900,
            size: 24,
          ),
        ),
        IconButton(
          onPressed: _deleteTaskSheet,
          icon: const Icon(
            Icons.delete_outline,
            color: TossColors.loss,
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
    final rejectedQty = _rejectedQuantities[product.id] ?? 0;
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
            // Quantity with rejected
            GestureDetector(
              onTap: () => _showQuantityInputDialog(product),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: TossSpacing.space3,
                  vertical: TossSpacing.space2,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '$countedQty',
                      style: TossTextStyles.body.copyWith(
                        fontWeight: FontWeight.w600,
                        color: hasCount ? TossColors.primary : TossColors.gray400,
                        fontSize: 18,
                      ),
                    ),
                    if (rejectedQty > 0)
                      Text(
                        '-$rejectedQty',
                        style: TossTextStyles.body.copyWith(
                          fontWeight: FontWeight.w600,
                          color: TossColors.error,
                          fontSize: 18,
                        ),
                      ),
                  ],
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
                    final rejected = _rejectedQuantities[product.id] ?? 0;
                    return _buildCountedItemRow(product, qty, rejected);
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
                    'Item Counted: $_itemsCounted | Total Quantity: $_totalQuantity | Rejected: $_totalRejected',
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

  Widget _buildCountedItemRow(Product product, int quantity, int rejected) {
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
            // Quantity with rejected
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '$quantity',
                  style: TossTextStyles.body.copyWith(
                    fontWeight: FontWeight.w600,
                    color: TossColors.primary,
                  ),
                ),
                if (rejected > 0)
                  Text(
                    '-$rejected',
                    style: TossTextStyles.body.copyWith(
                      fontWeight: FontWeight.w600,
                      color: TossColors.error,
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// Dialog for entering stock in quantity with optional rejected quantity
class _StockInQuantityDialog extends StatefulWidget {
  final Product product;
  final int initialQuantity;
  final int initialRejected;
  final void Function(int quantity, int rejected) onSubmit;

  const _StockInQuantityDialog({
    required this.product,
    required this.initialQuantity,
    required this.initialRejected,
    required this.onSubmit,
  });

  @override
  State<_StockInQuantityDialog> createState() => _StockInQuantityDialogState();
}

class _StockInQuantityDialogState extends State<_StockInQuantityDialog> {
  late int _quantity;
  late int _rejected;
  bool _showRejected = false;

  @override
  void initState() {
    super.initState();
    _quantity = widget.initialQuantity;
    _rejected = widget.initialRejected;
    _showRejected = widget.initialRejected > 0;
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
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
              widget.product.name,
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
              widget.product.sku,
              style: TossTextStyles.caption.copyWith(
                color: TossColors.gray500,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            // Main quantity input using TossQuantityStepper
            TossQuantityStepper(
              initialValue: _quantity,
              minValue: 0,
              previousValue: widget.product.onHand,
              stockChangeMode: StockChangeMode.add,
              onChanged: (value) {
                setState(() {
                  _quantity = value;
                });
              },
            ),
            const SizedBox(height: 16),
            // Rejected quantity toggle
            GestureDetector(
              onTap: () {
                setState(() {
                  _showRejected = !_showRejected;
                  if (!_showRejected) {
                    _rejected = 0;
                  }
                });
              },
              behavior: HitTestBehavior.opaque,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Rejected Quantity (Optional)',
                    style: TossTextStyles.body.copyWith(
                      color: TossColors.gray500,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Icon(
                    _showRejected
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    size: 20,
                    color: TossColors.gray500,
                  ),
                ],
              ),
            ),
            // Rejected quantity input (expandable)
            if (_showRejected) ...[
              const SizedBox(height: 12),
              _RejectedQuantityStepper(
                initialValue: _rejected,
                minValue: 0,
                onChanged: (value) {
                  setState(() {
                    _rejected = value;
                  });
                },
              ),
            ],
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () => Navigator.pop(context),
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
                      widget.onSubmit(_quantity, _rejected);
                      Navigator.pop(context);
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
    );
  }
}

/// Custom red-styled quantity stepper for rejected items (same size as TossQuantityStepper)
class _RejectedQuantityStepper extends StatefulWidget {
  final int initialValue;
  final int minValue;
  final ValueChanged<int> onChanged;

  const _RejectedQuantityStepper({
    this.initialValue = 0,
    this.minValue = 0,
    required this.onChanged,
  });

  @override
  State<_RejectedQuantityStepper> createState() => _RejectedQuantityStepperState();
}

class _RejectedQuantityStepperState extends State<_RejectedQuantityStepper> {
  late TextEditingController _controller;
  late int _quantity;

  @override
  void initState() {
    super.initState();
    _quantity = widget.initialValue;
    _controller = TextEditingController(text: '$_quantity');
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _increment() {
    setState(() {
      _quantity++;
      _controller.text = '$_quantity';
    });
    widget.onChanged(_quantity);
  }

  void _decrement() {
    if (_quantity > widget.minValue) {
      setState(() {
        _quantity--;
        _controller.text = '$_quantity';
      });
      widget.onChanged(_quantity);
    }
  }

  void _onTextChanged(String value) {
    if (value.isEmpty) {
      setState(() {
        _quantity = 0;
      });
      widget.onChanged(_quantity);
    } else {
      final parsed = int.tryParse(value);
      if (parsed != null && parsed >= widget.minValue) {
        setState(() {
          _quantity = parsed;
        });
        widget.onChanged(_quantity);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Minus button (red) - same size as TossQuantityStepper
        GestureDetector(
          onTap: _decrement,
          child: Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: TossColors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: TossColors.error,
                width: 2,
              ),
            ),
            alignment: Alignment.center,
            child: Icon(
              Icons.remove,
              size: 24,
              color: TossColors.error,
            ),
          ),
        ),
        // Quantity input - same style as TossQuantityStepper
        Expanded(
          child: TextField(
            controller: _controller,
            keyboardType: TextInputType.number,
            textAlign: TextAlign.center,
            style: TossTextStyles.h2.copyWith(
              color: TossColors.error,
            ),
            decoration: const InputDecoration(
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
              contentPadding: EdgeInsets.zero,
            ),
            onChanged: _onTextChanged,
          ),
        ),
        // Plus button (red) - same size as TossQuantityStepper
        GestureDetector(
          onTap: _increment,
          child: Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: TossColors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: TossColors.error,
                width: 2,
              ),
            ),
            alignment: Alignment.center,
            child: Icon(
              Icons.add,
              size: 24,
              color: TossColors.error,
            ),
          ),
        ),
      ],
    );
  }
}
