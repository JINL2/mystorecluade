import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/providers/app_state_provider.dart';
import '../../../../shared/themes/toss_colors.dart';
import '../../../../shared/themes/toss_spacing.dart';
import '../../../../shared/themes/toss_text_styles.dart';
import '../../../../shared/widgets/common/cached_product_image.dart';
import '../../../../shared/widgets/common/toss_success_error_dialog.dart';
import '../../../../shared/widgets/toss/toss_primary_button.dart';
import '../../../../shared/widgets/toss/toss_quantity_stepper.dart';
import '../../../../shared/widgets/toss/toss_search_field.dart';
import '../dialogs/save_confirm_dialog.dart';
import '../providers/session_detail_provider.dart';
import '../providers/session_list_provider.dart';
import '../providers/states/session_detail_state.dart';

/// Session detail page - view and manage session items
/// Redesigned to match BoxHero's StockInTaskSheetPage
class SessionDetailPage extends ConsumerStatefulWidget {
  final String sessionId;
  final String sessionType;
  final String storeId;
  final String? sessionName;
  final bool isOwner;

  const SessionDetailPage({
    super.key,
    required this.sessionId,
    required this.sessionType,
    required this.storeId,
    this.sessionName,
    this.isOwner = false,
  });

  @override
  ConsumerState<SessionDetailPage> createState() => _SessionDetailPageState();
}

class _SessionDetailPageState extends ConsumerState<SessionDetailPage> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  final ScrollController _scrollController = ScrollController();
  Timer? _debounceTimer;
  bool _isBottomExpanded = false;

  SessionDetailParams get _params => (
        sessionId: widget.sessionId,
        sessionType: widget.sessionType,
        storeId: widget.storeId,
        sessionName: widget.sessionName,
      );

  @override
  void initState() {
    super.initState();
    // Load inventory and existing items on page init
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final notifier = ref.read(sessionDetailProvider(_params).notifier);
      // Load user's existing session items first
      notifier.loadExistingItems();
      // Load inventory list
      notifier.loadInventory();
    });
    // Setup scroll listener for infinite scroll
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    _scrollController.dispose();
    _debounceTimer?.cancel();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      final state = ref.read(sessionDetailProvider(_params));
      if (state.isSearchModeActive) {
        ref.read(sessionDetailProvider(_params).notifier).loadMoreSearchResults();
      } else {
        ref.read(sessionDetailProvider(_params).notifier).loadMoreInventory();
      }
    }
  }

  bool get _isCounting => widget.sessionType == 'counting';

  int _getTotalRejected(SessionDetailState state) {
    return state.selectedProducts.fold(0, (sum, p) => sum + p.quantityRejected);
  }

  Color get _typeColor =>
      _isCounting ? TossColors.primary : TossColors.success;

  void _onSearchChanged(String query) {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 200), () {
      ref.read(sessionDetailProvider(_params).notifier).searchProducts(query);
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(sessionDetailProvider(_params));

    return Scaffold(
      backgroundColor: TossColors.white,
      appBar: _buildAppBar(),
      body: Column(
        children: [
          _buildSearchBar(state),
          Expanded(child: _buildContent(state)),
          _buildBottomBar(state),
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
        widget.sessionName ?? 'Session Detail',
        style: TossTextStyles.titleMedium.copyWith(
          fontWeight: FontWeight.w700,
          color: TossColors.gray900,
        ),
      ),
      centerTitle: true,
    );
  }

  Widget _buildSearchBar(SessionDetailState state) {
    return Container(
      padding: const EdgeInsets.all(TossSpacing.space4),
      child: GestureDetector(
        onTap: () {
          ref.read(sessionDetailProvider(_params).notifier).enterSearchMode();
          _searchFocusNode.requestFocus();
        },
        child: TossSearchField(
          controller: _searchController,
          focusNode: _searchFocusNode,
          hintText: 'You can search by name, product code, product type,...',
          onChanged: (value) {
            setState(() {});
            _onSearchChanged(value);
          },
          onClear: () {
            _searchController.clear();
            ref
                .read(sessionDetailProvider(_params).notifier)
                .clearSearchResults();
          },
        ),
      ),
    );
  }

  Widget _buildContent(SessionDetailState state) {
    // Show search results if in search mode
    if (state.isSearchModeActive) {
      return _buildSearchResults(state);
    }
    // Show inventory list (default view)
    return _buildInventoryList(state);
  }

  Widget _buildInventoryList(SessionDetailState state) {
    // Show loading indicator for initial load
    if (state.isLoadingInventory && state.inventoryProducts.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    // Show empty state if no products
    if (state.inventoryProducts.isEmpty) {
      return _buildSearchEmptyState(
        icon: Icons.inventory_2_outlined,
        title: 'No products found',
        subtitle: 'Add products to your inventory first',
      );
    }

    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.symmetric(horizontal: TossSpacing.space4),
      itemCount: state.inventoryProducts.length + (state.hasMoreInventory ? 1 : 0),
      itemBuilder: (context, index) {
        // Show loading indicator at the bottom
        if (index == state.inventoryProducts.length) {
          return Padding(
            padding: const EdgeInsets.all(TossSpacing.space4),
            child: Center(
              child: state.isLoadingMoreInventory
                  ? const CircularProgressIndicator()
                  : const SizedBox.shrink(),
            ),
          );
        }

        final product = state.inventoryProducts[index];
        final selectedProduct = state.getSelectedProduct(product.productId);
        final quantity = selectedProduct?.quantity ?? 0;

        return _buildInventoryProductItem(product, quantity);
      },
    );
  }

  Widget _buildInventoryProductItem(SearchProductResult product, int quantity) {
    final hasCount = quantity > 0;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => _showQuantityInputDialogForProduct(product),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: TossSpacing.space3),
        child: Row(
          children: [
            // Product image
            CachedProductImage(
              imageUrl: product.imageUrl,
              size: 60,
              borderRadius: 8,
            ),
            const SizedBox(width: TossSpacing.space3),
            // Product info
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
                  const SizedBox(height: 2),
                  if (product.sku != null)
                    Text(
                      product.sku!,
                      style: TossTextStyles.caption.copyWith(
                        color: TossColors.gray500,
                      ),
                    ),
                  if (product.barcode != null) ...[
                    const SizedBox(height: 2),
                    Text(
                      product.barcode!,
                      style: TossTextStyles.caption.copyWith(
                        color: TossColors.gray500,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            // Quantity
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: TossSpacing.space3,
                vertical: TossSpacing.space2,
              ),
              child: Text(
                hasCount ? '$quantity' : '-',
                style: TossTextStyles.body.copyWith(
                  fontWeight: FontWeight.w600,
                  color: hasCount ? TossColors.primary : TossColors.gray400,
                  fontSize: 18,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showQuantityInputDialogForProduct(SearchProductResult product) {
    // Get existing selected product or create a temporary one
    final state = ref.read(sessionDetailProvider(_params));
    final existingProduct = state.getSelectedProduct(product.productId);

    final item = existingProduct ?? SelectedProduct(
      productId: product.productId,
      productName: product.productName,
      sku: product.sku,
      barcode: product.barcode,
      imageUrl: product.imageUrl,
      quantity: 0,
      quantityRejected: 0,
      unitPrice: product.sellingPrice,
    );

    showDialog<void>(
      context: context,
      builder: (dialogContext) => _SessionQuantityDialog(
        item: item,
        onSubmit: (counted, rejected) {
          final notifier = ref.read(sessionDetailProvider(_params).notifier);
          // If product not yet selected, add it first
          if (existingProduct == null && (counted > 0 || rejected > 0)) {
            notifier.addProduct(product);
          }
          notifier.updateQuantity(product.productId, counted);
          notifier.updateQuantityRejected(product.productId, rejected);
        },
      ),
    );
  }

  Widget _buildSearchResults(SessionDetailState state) {
    if (state.isSearching) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.searchResults.isEmpty && state.searchQuery.isNotEmpty) {
      return _buildSearchEmptyState(
        icon: Icons.search_off,
        title: 'No products found',
        subtitle: 'Try a different search term',
      );
    }

    if (state.searchResults.isEmpty) {
      return _buildSearchEmptyState(
        icon: Icons.search,
        title: 'Search for products',
        subtitle: 'Type to search by name, SKU, or barcode',
      );
    }

    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.symmetric(horizontal: TossSpacing.space4),
      itemCount: state.searchResults.length + (state.hasMoreInventory ? 1 : 0),
      itemBuilder: (context, index) {
        // Show loading indicator at the bottom
        if (index == state.searchResults.length) {
          return Padding(
            padding: const EdgeInsets.all(TossSpacing.space4),
            child: Center(
              child: state.isLoadingMoreInventory
                  ? const CircularProgressIndicator()
                  : const SizedBox.shrink(),
            ),
          );
        }

        final product = state.searchResults[index];
        final selectedProduct = state.getSelectedProduct(product.productId);
        final quantity = selectedProduct?.quantity ?? 0;

        return _buildInventoryProductItem(product, quantity);
      },
    );
  }

  Widget _buildSearchEmptyState({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(TossSpacing.space6),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 64, color: TossColors.gray400),
            const SizedBox(height: TossSpacing.space4),
            Text(
              title,
              style: TossTextStyles.h4.copyWith(color: TossColors.textPrimary),
            ),
            const SizedBox(height: TossSpacing.space2),
            Text(
              subtitle,
              style:
                  TossTextStyles.body.copyWith(color: TossColors.gray500),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomBar(SessionDetailState state) {
    final hasCountedItems = state.selectedProducts
        .where((item) => item.quantity > 0)
        .isNotEmpty;
    final countedProducts = state.selectedProducts
        .where((item) => item.quantity > 0)
        .toList();

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      decoration: const BoxDecoration(
        color: TossColors.white,
        boxShadow: [
          BoxShadow(
            color: Color(0x1A1A1A1A),
            blurRadius: 8,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Expandable section - tap anywhere to toggle
            GestureDetector(
              onTap: hasCountedItems
                  ? () {
                      setState(() {
                        _isBottomExpanded = !_isBottomExpanded;
                      });
                    }
                  : null,
              behavior: HitTestBehavior.opaque,
              child: Column(
                children: [
                  // Arrow icon
                  Container(
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
                          final item = countedProducts[index];
                          return _buildCountedItemRow(item);
                        },
                      ),
                    ),
                    const Divider(height: 1, color: TossColors.gray200),
                  ],
                  // Summary text
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: TossSpacing.space4,
                      vertical: TossSpacing.space3,
                    ),
                    child: Text(
                      'Item Counted: ${countedProducts.length} | Total Quantity: ${state.totalQuantity} | Rejected: ${_getTotalRejected(state)}',
                      style: TossTextStyles.body.copyWith(
                        color: TossColors.gray900,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Save button
            Padding(
              padding: const EdgeInsets.only(
                left: TossSpacing.space4,
                right: TossSpacing.space4,
                bottom: TossSpacing.space4,
              ),
              child: Column(
                children: [
                  // Save button
                  SizedBox(
                    width: double.infinity,
                    child: TossPrimaryButton(
                      text: 'Save',
                      onPressed: _onSavePressed,
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

  void _showQuantityInputDialog(SelectedProduct item) {
    showDialog<void>(
      context: context,
      builder: (dialogContext) => _SessionQuantityDialog(
        item: item,
        onSubmit: (counted, rejected) {
          final notifier = ref.read(sessionDetailProvider(_params).notifier);
          notifier.updateQuantity(item.productId, counted);
          notifier.updateQuantityRejected(item.productId, rejected);
        },
      ),
    );
  }

  Widget _buildCountedItemRow(SelectedProduct item) {
    return GestureDetector(
      onTap: () => _showQuantityInputDialog(item),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: TossSpacing.space2),
        child: Row(
          children: [
            // Product image
            CachedProductImage(
              imageUrl: item.imageUrl,
              size: 40,
              borderRadius: 6,
            ),
            const SizedBox(width: TossSpacing.space3),
            // Product info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.productName,
                    style: TossTextStyles.caption.copyWith(
                      fontWeight: FontWeight.w600,
                      color: TossColors.gray900,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (item.sku != null)
                    Text(
                      item.sku!,
                      style: TossTextStyles.small.copyWith(
                        color: TossColors.gray500,
                      ),
                    ),
                ],
              ),
            ),
            // Quantity only
            Text(
              '${item.quantity}',
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

  void _onSavePressed() {
    final state = ref.read(sessionDetailProvider(_params));

    if (state.selectedProducts.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No items to save')),
      );
      return;
    }

    SaveConfirmDialog.show(
      context: context,
      selectedProducts: state.selectedProducts,
      totalSelectedCount: state.totalSelectedCount,
      typeColor: _typeColor,
      onConfirm: _executeSave,
    );
  }

  Future<void> _executeSave() async {
    final appState = ref.read(appStateProvider);
    final userId = appState.userId;

    if (userId.isEmpty) {
      if (mounted) {
        showDialog<void>(
          context: context,
          builder: (context) => TossDialog.error(
            title: 'Error',
            message: 'User not found',
            primaryButtonText: 'OK',
            onPrimaryPressed: () => Navigator.of(context).pop(),
          ),
        );
      }
      return;
    }

    final result = await ref
        .read(sessionDetailProvider(_params).notifier)
        .saveItems(userId);

    if (mounted) {
      if (result.success) {
        // Invalidate session list to refresh data
        ref.invalidate(sessionListProvider(widget.sessionType));
        // Navigate back to session page with success result for refresh
        context.pop(true);
      } else {
        showDialog<void>(
          context: context,
          builder: (context) => TossDialog.error(
            title: 'Failed to Save',
            message: result.error ?? 'Failed to save items',
            primaryButtonText: 'OK',
            onPrimaryPressed: () => Navigator.of(context).pop(),
          ),
        );
      }
    }
  }
}

/// Dialog for entering session quantity with optional rejected quantity
class _SessionQuantityDialog extends StatefulWidget {
  final SelectedProduct item;
  final void Function(int counted, int rejected) onSubmit;

  const _SessionQuantityDialog({
    required this.item,
    required this.onSubmit,
  });

  @override
  State<_SessionQuantityDialog> createState() => _SessionQuantityDialogState();
}

class _SessionQuantityDialogState extends State<_SessionQuantityDialog> {
  late int _quantity;
  late int _rejected;
  bool _showRejected = false;

  @override
  void initState() {
    super.initState();
    _quantity = widget.item.quantity;
    _rejected = widget.item.quantityRejected;
    _showRejected = widget.item.quantityRejected != 0;
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
            // Title
            Text(
              'Enter Quantity',
              style: TossTextStyles.h3.copyWith(
                fontWeight: FontWeight.w700,
                color: TossColors.gray900,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            // Product name
            Text(
              widget.item.productName,
              style: TossTextStyles.body.copyWith(
                color: TossColors.gray500,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            // Product SKU
            if (widget.item.sku != null)
              Text(
                widget.item.sku!,
                style: TossTextStyles.caption.copyWith(
                  color: TossColors.gray500,
                ),
                textAlign: TextAlign.center,
              ),
            const SizedBox(height: 24),
            // Quantity input using TossQuantityStepper
            TossQuantityStepper(
              initialValue: _quantity,
              minValue: 0,
              previousValue: 0,
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
                        ? Icons.keyboard_arrow_down
                        : Icons.keyboard_arrow_right,
                    color: TossColors.gray400,
                    size: 20,
                  ),
                ],
              ),
            ),
            // Rejected quantity input (expandable)
            if (_showRejected) ...[
              const SizedBox(height: 16),
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
            // Action buttons
            Row(
              children: [
                // Cancel button
                Expanded(
                  child: GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      decoration: BoxDecoration(
                        color: TossColors.gray100,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        'Cancel',
                        style: TossTextStyles.body.copyWith(
                          fontWeight: FontWeight.w600,
                          color: TossColors.gray700,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                // Submit button
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      widget.onSubmit(_quantity, _rejected);
                      Navigator.pop(context);
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      decoration: BoxDecoration(
                        color: TossColors.primary,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        'Save',
                        style: TossTextStyles.body.copyWith(
                          fontWeight: FontWeight.w600,
                          color: TossColors.white,
                        ),
                      ),
                    ),
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

/// Rejected quantity stepper with red styling
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
  late FocusNode _focusNode;
  late int _quantity;

  @override
  void initState() {
    super.initState();
    _quantity = widget.initialValue;
    _controller = TextEditingController(text: '-$_quantity');
    _focusNode = FocusNode();
    _focusNode.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    _focusNode.removeListener(_onFocusChange);
    _focusNode.dispose();
    _controller.dispose();
    super.dispose();
  }

  void _onFocusChange() {
    if (_focusNode.hasFocus && _quantity == 0) {
      _controller.text = '-';
    } else if (!_focusNode.hasFocus) {
      _controller.text = '-$_quantity';
    }
  }

  void _increment() {
    setState(() {
      _quantity++;
      _controller.text = '-$_quantity';
    });
    widget.onChanged(_quantity);
  }

  void _decrement() {
    if (_quantity > widget.minValue) {
      setState(() {
        _quantity--;
        _controller.text = '-$_quantity';
      });
      widget.onChanged(_quantity);
    }
  }

  void _onTextChanged(String value) {
    final cleanValue = value.replaceAll('-', '');
    if (cleanValue.isEmpty) {
      setState(() {
        _quantity = 0;
      });
      widget.onChanged(_quantity);
    } else {
      final parsed = int.tryParse(cleanValue);
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
        // Minus button
        _buildQuantityButton(
          icon: Icons.remove,
          onTap: _decrement,
        ),
        // Quantity input
        Expanded(
          child: TextField(
            controller: _controller,
            focusNode: _focusNode,
            keyboardType: TextInputType.number,
            textAlign: TextAlign.center,
            style: TossTextStyles.h2.copyWith(
              color: TossColors.loss,
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
        // Plus button
        _buildQuantityButton(
          icon: Icons.add,
          onTap: _increment,
        ),
      ],
    );
  }

  Widget _buildQuantityButton({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: TossColors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: TossColors.loss,
            width: 2,
          ),
        ),
        alignment: Alignment.center,
        child: Icon(
          icon,
          size: 24,
          color: TossColors.loss,
        ),
      ),
    );
  }
}
