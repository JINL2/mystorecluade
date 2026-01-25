import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:myfinance_improved/shared/widgets/index.dart';

import '../../../../app/providers/app_state_provider.dart';
import '../../../../app/providers/currency_provider.dart';
import '../../../../shared/themes/toss_colors.dart';
import '../../../../shared/themes/toss_spacing.dart';
import '../../domain/entities/shipment.dart';
import '../providers/shipment_providers.dart';
import '../widgets/shipment_filter_section.dart';
import '../widgets/shipment_list_item.dart';

class ShipmentListPage extends ConsumerStatefulWidget {
  const ShipmentListPage({super.key});

  @override
  ConsumerState<ShipmentListPage> createState() => _ShipmentListPageState();
}

class _ShipmentListPageState extends ConsumerState<ShipmentListPage> {
  final _scrollController = ScrollController();
  ShipmentFilterState _filterState = const ShipmentFilterState();
  String? _searchQuery;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      // Load more when near bottom (pagination support)
      final paginationState = ref.read(shipmentPaginationProvider);
      if (paginationState.hasNextPage) {
        ref.read(shipmentPaginationProvider.notifier).state =
            paginationState.copyWith(
          offset: paginationState.offset + paginationState.limit,
        );
      }
    }
  }

  void _onFilterChanged(ShipmentFilterState newFilterState) {
    setState(() => _filterState = newFilterState);
    // Reset pagination when filter changes
    ref.read(shipmentPaginationProvider.notifier).state =
        const ShipmentPaginationState();
  }

  void _onSearch(String query) {
    setState(() => _searchQuery = query.isEmpty ? null : query);
    ref.read(shipmentSearchQueryProvider.notifier).state = query;
    // Reset pagination when search changes
    ref.read(shipmentPaginationProvider.notifier).state =
        const ShipmentPaginationState();
  }

  @override
  Widget build(BuildContext context) {
    final appState = ref.watch(appStateProvider);
    final companyId = appState.companyChoosen;

    if (companyId.isEmpty) {
      return TossScaffold(
        appBar: TossAppBar(
          title: 'Shipments',
          leading: TossIconButton.ghost(
            icon: LucideIcons.arrowLeft,
            onPressed: () => _navigateBack(context),
          ),
        ),
        body: const Center(child: Text('Please select a company')),
      );
    }

    // Build query params from filter state
    final dateRange = _filterState.getDateRange();
    final params = ShipmentQueryParams(
      companyId: companyId,
      search: _searchQuery,
      status: _filterState.statuses.isNotEmpty
          ? _filterState.statuses.first.name
          : null,
      supplierId: _filterState.supplierId,
      hasOrder: _filterState.hasOrder,
      startDate: dateRange.$1,
      endDate: dateRange.$2,
    );

    final shipmentsAsync = ref.watch(shipmentsProvider(params));

    // Initial loading state
    if (shipmentsAsync.isLoading && !shipmentsAsync.hasValue) {
      return TossScaffold(
        appBar: TossAppBar(
          title: 'Shipments',
          leading: TossIconButton.ghost(
            icon: LucideIcons.arrowLeft,
            onPressed: () => _navigateBack(context),
          ),
        ),
        body: const TossLoadingView(message: 'Loading...'),
      );
    }

    return TossScaffold(
      appBar: TossAppBar(
        title: 'Shipments',
        leading: TossIconButton.ghost(
          icon: LucideIcons.arrowLeft,
          onPressed: () => _navigateBack(context),
        ),
        primaryActionIcon: LucideIcons.plus,
        primaryActionText: 'New',
        onPrimaryAction: () => context.push('/shipment/new'),
      ),
      body: Column(
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.all(TossSpacing.space4),
            child: TossTextField.filled(
              hintText: 'Search by shipment number...',
              prefixIcon: const Icon(LucideIcons.search, size: TossSpacing.iconMD),
              onChanged: _onSearch,
            ),
          ),

          // Filter section
          ShipmentFilterSection(
            filterState: _filterState,
            onFilterChanged: _onFilterChanged,
          ),

          const SizedBox(height: TossSpacing.space3),

          // List
          Expanded(
            child: shipmentsAsync.when(
              loading: () => const TossLoadingView(message: 'Loading...'),
              error: (error, _) => _buildErrorView(error.toString()),
              data: (response) => _buildContent(response),
            ),
          ),
        ],
      ),
    );
  }

  void _navigateBack(BuildContext context) {
    if (context.canPop()) {
      context.pop();
    } else {
      context.go('/');
    }
  }

  Widget _buildErrorView(String error) {
    return TossErrorView(
      error: error,
      onRetry: () => ref.invalidate(shipmentsProvider),
    );
  }

  Widget _buildContent(PaginatedShipmentResponse response) {
    final items = response.data;
    final baseCurrencyAsync = ref.watch(baseCurrencyProvider);
    final baseCurrencyCode = baseCurrencyAsync.valueOrNull?.symbol;

    if (items.isEmpty) {
      return TossEmptyView(
        icon: const Icon(
          LucideIcons.truck,
          size: TossSpacing.icon4XL,
          color: TossColors.gray400,
        ),
        title: 'No Shipments',
        description: 'Create your first shipment to get started',
        action: TossButton.primary(
          text: 'Create Shipment',
          leadingIcon: const Icon(
            LucideIcons.plus,
            size: TossSpacing.iconMD,
            color: TossColors.white,
          ),
          onPressed: () => context.push('/shipment/new'),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () async {
        ref.invalidate(shipmentsProvider);
      },
      child: ListView.builder(
        controller: _scrollController,
        padding: const EdgeInsets.symmetric(horizontal: TossSpacing.space4),
        itemCount: items.length,
        itemBuilder: (context, index) {
          final item = items[index];
          return ShipmentListItemWidget(
            item: item,
            baseCurrencyCode: baseCurrencyCode,
            onTap: () => context.push('/shipment/${item.shipmentId}'),
          );
        },
      ),
    );
  }
}
