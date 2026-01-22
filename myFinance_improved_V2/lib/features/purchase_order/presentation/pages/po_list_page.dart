import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:myfinance_improved/shared/widgets/index.dart';

import '../../../../shared/themes/toss_colors.dart';
import '../../../../shared/themes/toss_spacing.dart';
import '../../../../shared/themes/toss_text_styles.dart';
import '../providers/po_providers.dart';
import '../widgets/po_filter_section.dart';
import '../widgets/po_list_item.dart';

class POListPage extends ConsumerStatefulWidget {
  const POListPage({super.key});

  @override
  ConsumerState<POListPage> createState() => _POListPageState();
}

class _POListPageState extends ConsumerState<POListPage> {
  final _scrollController = ScrollController();
  POFilterState _filterState = const POFilterState();
  String? _searchQuery;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    // Load initial data with default date filter (this month)
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Pre-fetch base currency data
      ref.read(poBaseCurrencyProvider);
      _applyFilters();
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      ref.read(poListProvider.notifier).loadMore();
    }
  }

  void _onFilterChanged(POFilterState newFilterState) {
    setState(() => _filterState = newFilterState);
    _applyFilters();
  }

  void _applyFilters() {
    final dateRange = _filterState.getDateRange();
    ref.read(poListProvider.notifier).loadList(
          orderStatuses: _filterState.orderStatuses.isEmpty
              ? null
              : _filterState.orderStatuses,
          receivingStatuses: _filterState.receivingStatuses.isEmpty
              ? null
              : _filterState.receivingStatuses,
          supplierId: _filterState.supplierId,
          dateFrom: dateRange.$1,
          dateTo: dateRange.$2,
          searchQuery: _searchQuery,
        );
  }

  void _onSearch(String query) {
    setState(() => _searchQuery = query.isEmpty ? null : query);
    _applyFilters();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(poListProvider);

    // 초기 로딩 중일 때 전체 화면 로딩 뷰 표시
    if (state.isLoading && state.items.isEmpty) {
      return TossScaffold(
        appBar: TossAppBar(
          title: 'Purchase Orders',
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              if (context.canPop()) {
                context.pop();
              } else {
                context.go('/');
              }
            },
          ),
        ),
        body: const TossLoadingView(message: 'Loading...'),
      );
    }

    return TossScaffold(
      appBar: TossAppBar(
        title: 'Purchase Orders',
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go('/');
            }
          },
        ),
        primaryActionIcon: Icons.add,
        primaryActionText: 'New',
        onPrimaryAction: () => context.push('/purchase-order/new'),
      ),
      body: Column(
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.all(TossSpacing.space4),
            child: TossTextField.filled(
              hintText: 'Search by PO number or buyer...',
              prefixIcon: const Icon(Icons.search, size: TossSpacing.iconMD),
              onChanged: _onSearch,
            ),
          ),

          // Filter section
          POFilterSection(
            filterState: _filterState,
            onFilterChanged: _onFilterChanged,
          ),

          const SizedBox(height: TossSpacing.space3),

          // List
          Expanded(
            child: _buildContent(state),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(POListState state) {
    // 초기 로딩은 build()에서 처리하므로 여기서는 에러만 처리
    if (state.error != null && state.items.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: TossSpacing.iconXXL, color: TossColors.gray400),
            const SizedBox(height: TossSpacing.space3),
            Text(
              'Failed to load',
              style:
                  TossTextStyles.bodyLarge.copyWith(color: TossColors.gray600),
            ),
            const SizedBox(height: TossSpacing.space2),
            TossButton.textButton(
              text: 'Retry',
              onPressed: () => ref.read(poListProvider.notifier).refresh(),
            ),
          ],
        ),
      );
    }

    if (state.items.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.shopping_cart_outlined,
                size: TossSpacing.icon4XL, color: TossColors.gray400),
            const SizedBox(height: TossSpacing.space4),
            Text(
              'No Purchase Orders',
              style: TossTextStyles.h3.copyWith(color: TossColors.gray600),
            ),
            const SizedBox(height: TossSpacing.space2),
            Text(
              'Create your first PO to get started',
              style:
                  TossTextStyles.bodyMedium.copyWith(color: TossColors.gray500),
            ),
            const SizedBox(height: TossSpacing.space4),
            TossButton.primary(
              text: 'Create PO',
              leadingIcon: const Icon(Icons.add, size: TossSpacing.iconMD, color: TossColors.white),
              onPressed: () => context.push('/purchase-order/new'),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () async {
        ref.read(poListProvider.notifier).refresh();
      },
      child: ListView.builder(
        controller: _scrollController,
        padding: const EdgeInsets.symmetric(horizontal: TossSpacing.space4),
        itemCount: state.items.length + (state.isLoadingMore ? 1 : 0),
        itemBuilder: (context, index) {
          if (index == state.items.length) {
            return const Padding(
              padding: EdgeInsets.all(TossSpacing.space4),
              child: TossLoadingView(),
            );
          }

          final item = state.items[index];
          final baseCurrencyAsync = ref.watch(poBaseCurrencyProvider);
          final baseCurrencyCode = baseCurrencyAsync.valueOrNull?.baseCurrency.currencyCode;
          return POListItemWidget(
            item: item,
            baseCurrencyCode: baseCurrencyCode,
            onTap: () => context.push('/purchase-order/${item.poId}'),
          );
        },
      ),
    );
  }
}

