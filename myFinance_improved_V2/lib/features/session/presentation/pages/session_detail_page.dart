import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/providers/app_state_provider.dart';
import '../../../../shared/themes/toss_animations.dart';
import '../../../../shared/themes/toss_colors.dart';
import '../../../../shared/themes/toss_spacing.dart';
import '../../../../shared/themes/toss_text_styles.dart';
import '../dialogs/save_confirm_dialog.dart';
import '../providers/session_detail_provider.dart';
import '../providers/session_list_provider.dart';
import '../providers/states/session_detail_state.dart';
import '../widgets/session_detail/inventory_product_item.dart';
import '../widgets/session_detail/session_bottom_bar.dart';
import '../widgets/session_detail/session_empty_state.dart';
import '../widgets/session_detail/session_quantity_dialog.dart';
import 'package:myfinance_improved/shared/widgets/index.dart';

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

  SessionDetailParams get _params => (
        sessionId: widget.sessionId,
        sessionType: widget.sessionType,
        storeId: widget.storeId,
        sessionName: widget.sessionName,
      );

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final notifier = ref.read(sessionDetailNotifierProvider(_params).notifier);
      notifier.loadExistingItems();
      notifier.loadInventory();
    });
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
      final state = ref.read(sessionDetailNotifierProvider(_params));
      if (state.isSearchModeActive) {
        ref.read(sessionDetailNotifierProvider(_params).notifier).loadMoreSearchResults();
      } else {
        ref.read(sessionDetailNotifierProvider(_params).notifier).loadMoreInventory();
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
    _debounceTimer = Timer(TossAnimations.normal, () {
      ref.read(sessionDetailNotifierProvider(_params).notifier).searchProducts(query);
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(sessionDetailNotifierProvider(_params));

    return Scaffold(
      backgroundColor: TossColors.white,
      appBar: _buildAppBar(),
      body: Column(
        children: [
          _buildSearchBar(state),
          Expanded(child: _buildContent(state)),
          SessionBottomBar(
            selectedProducts: state.selectedProducts,
            totalQuantity: state.totalQuantity,
            totalRejected: _getTotalRejected(state),
            onSave: _onSavePressed,
            onItemTap: _showQuantityInputDialog,
          ),
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
          ref.read(sessionDetailNotifierProvider(_params).notifier).enterSearchMode();
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
                .read(sessionDetailNotifierProvider(_params).notifier)
                .clearSearchResults();
          },
        ),
      ),
    );
  }

  Widget _buildContent(SessionDetailState state) {
    if (state.isSearchModeActive) {
      return _buildSearchResults(state);
    }
    return _buildInventoryList(state);
  }

  Widget _buildInventoryList(SessionDetailState state) {
    if (state.isLoadingInventory && state.inventoryProducts.isEmpty) {
      return const TossLoadingView();
    }

    if (state.inventoryProducts.isEmpty) {
      return const SessionEmptyState(
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
        if (index == state.inventoryProducts.length) {
          return Padding(
            padding: const EdgeInsets.all(TossSpacing.space4),
            child: Center(
              child: state.isLoadingMoreInventory
                  ? const TossLoadingView()
                  : const SizedBox.shrink(),
            ),
          );
        }

        final product = state.inventoryProducts[index];
        final selectedProduct = state.getSelectedProduct(product.productId);
        final quantity = selectedProduct?.quantity ?? 0;

        return InventoryProductItem(
          product: product,
          quantity: quantity,
          onTap: () => _showQuantityInputDialogForProduct(product),
        );
      },
    );
  }

  Widget _buildSearchResults(SessionDetailState state) {
    if (state.isSearching) {
      return const TossLoadingView();
    }

    if (state.searchResults.isEmpty && state.searchQuery.isNotEmpty) {
      return const SessionEmptyState(
        icon: Icons.search_off,
        title: 'No products found',
        subtitle: 'Try a different search term',
      );
    }

    if (state.searchResults.isEmpty) {
      return const SessionEmptyState(
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
        if (index == state.searchResults.length) {
          return Padding(
            padding: const EdgeInsets.all(TossSpacing.space4),
            child: Center(
              child: state.isLoadingMoreInventory
                  ? const TossLoadingView()
                  : const SizedBox.shrink(),
            ),
          );
        }

        final product = state.searchResults[index];
        final selectedProduct = state.getSelectedProduct(product.productId);
        final quantity = selectedProduct?.quantity ?? 0;

        return InventoryProductItem(
          product: product,
          quantity: quantity,
          onTap: () => _showQuantityInputDialogForProduct(product),
        );
      },
    );
  }

  void _showQuantityInputDialogForProduct(SearchProductResult product) {
    final state = ref.read(sessionDetailNotifierProvider(_params));
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
      builder: (dialogContext) => SessionQuantityDialog(
        item: item,
        onSubmit: (counted, rejected) {
          final notifier = ref.read(sessionDetailNotifierProvider(_params).notifier);
          if (existingProduct == null && (counted > 0 || rejected > 0)) {
            notifier.addProduct(product);
          }
          notifier.updateQuantity(product.productId, counted);
          notifier.updateQuantityRejected(product.productId, rejected);
        },
      ),
    );
  }

  void _showQuantityInputDialog(SelectedProduct item) {
    showDialog<void>(
      context: context,
      builder: (dialogContext) => SessionQuantityDialog(
        item: item,
        onSubmit: (counted, rejected) {
          final notifier = ref.read(sessionDetailNotifierProvider(_params).notifier);
          notifier.updateQuantity(item.productId, counted);
          notifier.updateQuantityRejected(item.productId, rejected);
        },
      ),
    );
  }

  void _onSavePressed() {
    final state = ref.read(sessionDetailNotifierProvider(_params));

    if (state.selectedProducts.isEmpty) {
      TossToast.info(context, 'No items to save');
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
        .read(sessionDetailNotifierProvider(_params).notifier)
        .saveItems(userId);

    if (mounted) {
      if (result.success) {
        ref.invalidate(sessionListNotifierProvider(widget.sessionType));
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
