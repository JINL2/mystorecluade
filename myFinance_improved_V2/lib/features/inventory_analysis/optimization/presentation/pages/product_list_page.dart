import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../shared/index.dart';
import '../../domain/entities/inventory_status.dart';
import '../providers/inventory_optimization_providers.dart';
import '../widgets/product_list_tile.dart';

/// 상품 목록 페이지 (무한 스크롤)
class ProductListPage extends ConsumerStatefulWidget {
  final String companyId;
  final String? categoryId;
  final String? statusFilter;
  final String title;

  const ProductListPage({
    super.key,
    required this.companyId,
    this.categoryId,
    this.statusFilter,
    required this.title,
  });

  @override
  ConsumerState<ProductListPage> createState() => _ProductListPageState();
}

class _ProductListPageState extends ConsumerState<ProductListPage> {
  final ScrollController _scrollController = ScrollController();
  String? _selectedFilter;

  @override
  void initState() {
    super.initState();
    _selectedFilter = widget.statusFilter;
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      final filter = _buildFilter();
      ref.read(productListNotifierProvider(filter).notifier).loadMore();
    }
  }

  ProductListFilter _buildFilter() {
    return ProductListFilter(
      companyId: widget.companyId,
      categoryId: widget.categoryId,
      statusFilter: _selectedFilter,
    );
  }

  @override
  Widget build(BuildContext context) {
    final filter = _buildFilter();
    final state = ref.watch(productListNotifierProvider(filter));

    return TossScaffold(
      appBar: TossAppBar(
        title: widget.title,
        primaryActionIcon: Icons.filter_list,
        onPrimaryAction: _showFilterSheet,
      ),
      body: _buildBody(state, filter),
    );
  }

  Widget _buildBody(ProductListState state, ProductListFilter filter) {
    if (state.isLoading) {
      return const TossLoadingView();
    }

    if (state.hasError && !state.hasData) {
      return TossErrorView(
        error: Exception(state.errorMessage),
        onRetry: () {
          ref.read(productListNotifierProvider(filter).notifier).refresh();
        },
      );
    }

    if (state.isEmpty) {
      return TossEmptyView(
        icon: const Icon(Icons.inventory_2_outlined, size: 48),
        title: 'No Products Found',
        description: 'No products match the current filter',
        action: TossButton.primary(
          text: 'Clear Filters',
          onPressed: () {
            setState(() => _selectedFilter = null);
          },
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () async {
        ref.read(productListNotifierProvider(filter).notifier).refresh();
      },
      color: TossColors.primary,
      child: Column(
        children: [
          // 필터 칩
          _buildFilterChips(),

          // 상품 목록 (컴팩트 뷰 - 한 화면에 8-10개)
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.symmetric(
                horizontal: TossSpacing.paddingMD,
                vertical: TossSpacing.paddingSM,
              ),
              itemCount: state.products.length + (state.isLoadingMore ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == state.products.length) {
                  return const Padding(
                    padding: EdgeInsets.all(TossSpacing.paddingSM),
                    child: Center(child: CircularProgressIndicator()),
                  );
                }

                final product = state.products[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: TossSpacing.gapSM),
                  child: ProductListTile(
                    product: product,
                    onTap: () => _showProductDetail(product.productId),
                    onOrderTap: () => _showOrderDialog(product.productId),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChips() {
    final filters = [
      null, // All
      InventoryStatus.abnormal,
      InventoryStatus.critical,
      InventoryStatus.warning,
      InventoryStatus.stockout,
      InventoryStatus.reorderNeeded,
      InventoryStatus.deadStock,
    ];

    return SizedBox(
      height: 50,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(
          horizontal: TossSpacing.paddingXL,
          vertical: TossSpacing.gapSM,
        ),
        itemCount: filters.length,
        itemBuilder: (context, index) {
          final status = filters[index];
          final isSelected = status?.filterValue == _selectedFilter ||
              (status == null && _selectedFilter == null);

          return Padding(
            padding: const EdgeInsets.only(right: TossSpacing.gapSM),
            child: FilterChip(
              label: Text(
                status == null ? 'All' : '${status.emoji} ${status.labelEn}',
              ),
              selected: isSelected,
              onSelected: (_) {
                setState(() {
                  _selectedFilter = status?.filterValue;
                });
              },
              selectedColor: TossColors.primarySurface,
              checkmarkColor: TossColors.primary,
              labelStyle: TextStyle(
                color: isSelected
                    ? TossColors.primary
                    : TossColors.textSecondary,
                fontWeight:
                    isSelected ? TossFontWeight.semibold : TossFontWeight.regular,
              ),
            ),
          );
        },
      ),
    );
  }

  void _showFilterSheet() {
    showModalBottomSheet<void>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(TossBorderRadius.bottomSheet),
        ),
      ),
      builder: (context) => _FilterBottomSheet(
        selectedFilter: _selectedFilter,
        onFilterSelected: (filter) {
          setState(() => _selectedFilter = filter);
          Navigator.pop(context);
        },
      ),
    );
  }

  void _showProductDetail(String productId) {
    // TODO: 상품 상세 페이지로 이동
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Product detail: $productId')),
    );
  }

  void _showOrderDialog(String productId) {
    // TODO: 주문 다이얼로그 표시
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Order product: $productId')),
    );
  }
}

class _FilterBottomSheet extends StatelessWidget {
  final String? selectedFilter;
  final void Function(String?) onFilterSelected;

  const _FilterBottomSheet({
    required this.selectedFilter,
    required this.onFilterSelected,
  });

  @override
  Widget build(BuildContext context) {
    final filters = [
      (null, 'All', Icons.all_inclusive),
      (InventoryStatus.abnormal, 'Abnormal', Icons.warning_rounded),
      (InventoryStatus.stockout, 'Stockout', Icons.inventory_2_outlined),
      (InventoryStatus.critical, 'Critical', Icons.local_fire_department_rounded),
      (InventoryStatus.warning, 'Warning', Icons.warning_amber_rounded),
      (InventoryStatus.reorderNeeded, 'Reorder Needed', Icons.shopping_cart_outlined),
      (InventoryStatus.deadStock, 'Dead Stock', Icons.hourglass_empty_rounded),
      (InventoryStatus.overstock, 'Overstock', Icons.trending_up_rounded),
    ];

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(TossSpacing.paddingXL),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Filter by Status',
              style: TossTextStyles.h4.copyWith(
                fontWeight: TossFontWeight.bold,
              ),
            ),
            const SizedBox(height: TossSpacing.gapLG),
            ...filters.map((filter) {
              final status = filter.$1;
              final label = filter.$2;
              final icon = filter.$3;
              final isSelected = status?.filterValue == selectedFilter ||
                  (status == null && selectedFilter == null);

              return ListTile(
                leading: Icon(
                  icon,
                  color: isSelected
                      ? TossColors.primary
                      : TossColors.textSecondary,
                ),
                title: Text(
                  status != null ? '${status.emoji} $label' : label,
                  style: TextStyle(
                    color: isSelected
                        ? TossColors.primary
                        : TossColors.textPrimary,
                    fontWeight: isSelected
                        ? TossFontWeight.semibold
                        : TossFontWeight.regular,
                  ),
                ),
                trailing: isSelected
                    ? const Icon(Icons.check, color: TossColors.primary)
                    : null,
                onTap: () => onFilterSelected(status?.filterValue),
              );
            }),
          ],
        ),
      ),
    );
  }
}
