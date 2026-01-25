import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/providers/app_state_provider.dart';
import '../../di/shipment_providers.dart';
import '../../domain/entities/shipment.dart';

/// Shipment Presentation Layer Providers
///
/// Provides state management for the shipment feature UI.

// =============================================================================
// Query Parameters
// =============================================================================

/// Parameters for fetching shipments using RPC
class ShipmentQueryParams {
  final String companyId;
  final String? search;
  final String? status;
  final String? supplierId;
  final String? orderId;
  final bool? hasOrder;
  final DateTime? startDate;
  final DateTime? endDate;
  final String timezone;
  final int limit;
  final int offset;

  const ShipmentQueryParams({
    required this.companyId,
    this.search,
    this.status,
    this.supplierId,
    this.orderId,
    this.hasOrder,
    this.startDate,
    this.endDate,
    this.timezone = 'Asia/Ho_Chi_Minh',
    this.limit = 50,
    this.offset = 0,
  });

  ShipmentQueryParams copyWith({
    String? companyId,
    String? search,
    String? status,
    String? supplierId,
    String? orderId,
    bool? hasOrder,
    DateTime? startDate,
    DateTime? endDate,
    String? timezone,
    int? limit,
    int? offset,
  }) {
    return ShipmentQueryParams(
      companyId: companyId ?? this.companyId,
      search: search ?? this.search,
      status: status ?? this.status,
      supplierId: supplierId ?? this.supplierId,
      orderId: orderId ?? this.orderId,
      hasOrder: hasOrder ?? this.hasOrder,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      timezone: timezone ?? this.timezone,
      limit: limit ?? this.limit,
      offset: offset ?? this.offset,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ShipmentQueryParams &&
        other.companyId == companyId &&
        other.search == search &&
        other.status == status &&
        other.supplierId == supplierId &&
        other.orderId == orderId &&
        other.hasOrder == hasOrder &&
        other.startDate == startDate &&
        other.endDate == endDate &&
        other.timezone == timezone &&
        other.limit == limit &&
        other.offset == offset;
  }

  @override
  int get hashCode => Object.hash(
        companyId,
        search,
        status,
        supplierId,
        orderId,
        hasOrder,
        startDate,
        endDate,
        timezone,
        limit,
        offset,
      );
}

// =============================================================================
// Shipment List Provider (Paginated)
// =============================================================================

/// Provider for fetching paginated shipments list using RPC
final shipmentsProvider = FutureProvider.autoDispose
    .family<PaginatedShipmentResponse, ShipmentQueryParams>((ref, params) async {
  final useCase = ref.watch(getShipmentsUseCaseProvider);
  return useCase(
    companyId: params.companyId,
    search: params.search,
    status: params.status,
    supplierId: params.supplierId,
    orderId: params.orderId,
    hasOrder: params.hasOrder,
    startDate: params.startDate,
    endDate: params.endDate,
    timezone: params.timezone,
    limit: params.limit,
    offset: params.offset,
  );
});

/// Provider for fetching shipments with app state context
final shipmentsWithContextProvider =
    FutureProvider.autoDispose<PaginatedShipmentResponse>((ref) async {
  final appState = ref.watch(appStateProvider);
  final companyId = appState.companyChoosen;
  final statusFilter = ref.watch(shipmentStatusFilterProvider);
  final searchQuery = ref.watch(shipmentSearchQueryProvider);
  final dateRange = ref.watch(shipmentDateRangeProvider);
  final paginationState = ref.watch(shipmentPaginationProvider);

  if (companyId.isEmpty) {
    return const PaginatedShipmentResponse(
      data: [],
      totalCount: 0,
      limit: 50,
      offset: 0,
    );
  }

  final useCase = ref.watch(getShipmentsUseCaseProvider);
  return useCase(
    companyId: companyId,
    search: searchQuery.isNotEmpty ? searchQuery : null,
    status: statusFilter,
    startDate: dateRange?.start,
    endDate: dateRange?.end,
    limit: paginationState.limit,
    offset: paginationState.offset,
  );
});


// =============================================================================
// Search Provider
// =============================================================================

/// Provider for search query state
final shipmentSearchQueryProvider = StateProvider<String>((ref) => '');


// =============================================================================
// Filter Providers
// =============================================================================

/// Provider for selected status filter
final shipmentStatusFilterProvider = StateProvider<String?>((ref) => null);

/// Provider for date range filter
final shipmentDateRangeProvider = StateProvider<DateTimeRange?>((ref) => null);


/// Date range class for filtering
class DateTimeRange {
  final DateTime start;
  final DateTime end;

  const DateTimeRange({required this.start, required this.end});
}

// =============================================================================
// Pagination Provider
// =============================================================================

/// Pagination state class
class ShipmentPaginationState {
  final int limit;
  final int offset;
  final int totalCount;

  const ShipmentPaginationState({
    this.limit = 50,
    this.offset = 0,
    this.totalCount = 0,
  });

  int get currentPage => (offset / limit).floor() + 1;
  int get totalPages => (totalCount / limit).ceil();
  bool get hasNextPage => offset + limit < totalCount;
  bool get hasPreviousPage => offset > 0;

  ShipmentPaginationState copyWith({
    int? limit,
    int? offset,
    int? totalCount,
  }) {
    return ShipmentPaginationState(
      limit: limit ?? this.limit,
      offset: offset ?? this.offset,
      totalCount: totalCount ?? this.totalCount,
    );
  }
}

/// Provider for pagination state
final shipmentPaginationProvider =
    StateProvider<ShipmentPaginationState>((ref) => const ShipmentPaginationState());

/// Provider for fetching shipment detail using RPC (inventory_get_shipment_detail_v2)
/// Returns ShipmentDetail with variant support and receiving progress
final shipmentDetailV2Provider =
    FutureProvider.autoDispose.family<ShipmentDetail?, String>((ref, shipmentId) async {
  final appState = ref.watch(appStateProvider);
  final companyId = appState.companyChoosen;

  if (companyId.isEmpty) {
    return null;
  }

  final useCase = ref.watch(getShipmentDetailUseCaseProvider);
  return useCase(shipmentId: shipmentId, companyId: companyId);
});

// =============================================================================
// Counterparty (Supplier) Provider
// =============================================================================

/// Counterparty item for filter selection
class CounterpartyFilterItem {
  final String counterpartyId;
  final String name;
  final String? type;
  final String? email;
  final String? phone;

  const CounterpartyFilterItem({
    required this.counterpartyId,
    required this.name,
    this.type,
    this.email,
    this.phone,
  });
}

/// Provider for fetching counterparties (suppliers) list
/// Uses GetCounterpartiesUseCase through Clean Architecture
final shipmentCounterpartiesProvider =
    FutureProvider.autoDispose<List<CounterpartyFilterItem>>((ref) async {
  final appState = ref.watch(appStateProvider);
  final companyId = appState.companyChoosen;

  if (companyId.isEmpty) {
    return [];
  }

  final getCounterpartiesUseCase = ref.watch(getCounterpartiesUseCaseProvider);
  final counterparties = await getCounterpartiesUseCase(companyId: companyId);

  // Convert domain entity to presentation model
  return counterparties
      .map((e) => CounterpartyFilterItem(
            counterpartyId: e.counterpartyId,
            name: e.name,
            type: e.type,
            email: e.email,
            phone: e.phone,
          ))
      .toList();
});

// =============================================================================
// Linkable Orders Provider (for Shipment creation)
// =============================================================================

/// Search query state for order selection
final linkableOrderSearchProvider = StateProvider<String>((ref) => '');

/// Linkable order item for selection UI
class LinkableOrderItem {
  final String orderId;
  final String orderNumber;
  final String? orderDate;
  final String? supplierName;
  final double totalAmount;
  final String status;

  const LinkableOrderItem({
    required this.orderId,
    required this.orderNumber,
    this.orderDate,
    this.supplierName,
    required this.totalAmount,
    required this.status,
  });

  /// Display name for selection UI
  String get displayName =>
      '$orderNumber${supplierName != null && supplierName!.isNotEmpty ? ' - $supplierName' : ''}';

  /// Status display label
  String get statusLabel {
    switch (status.toLowerCase()) {
      case 'pending':
        return 'Pending';
      case 'process':
        return 'Processing';
      default:
        return status;
    }
  }
}

/// Provider for fetching linkable orders (pending/process status)
/// Uses GetLinkableOrdersUseCase through Clean Architecture
final linkableOrdersProvider =
    FutureProvider.autoDispose<List<LinkableOrderItem>>((ref) async {
  final appState = ref.watch(appStateProvider);
  final companyId = appState.companyChoosen;
  final searchQuery = ref.watch(linkableOrderSearchProvider);

  if (companyId.isEmpty) {
    return [];
  }

  final getLinkableOrdersUseCase = ref.watch(getLinkableOrdersUseCaseProvider);
  final orders = await getLinkableOrdersUseCase(
    companyId: companyId,
    search: searchQuery.isNotEmpty ? searchQuery : null,
  );

  // Convert domain entity to presentation model
  return orders
      .map((e) => LinkableOrderItem(
            orderId: e.orderId,
            orderNumber: e.orderNumber,
            orderDate: e.orderDate,
            supplierName: e.supplierName,
            totalAmount: e.totalAmount,
            status: e.status,
          ))
      .toList();
});
