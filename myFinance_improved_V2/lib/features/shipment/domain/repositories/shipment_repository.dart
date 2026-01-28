import '../entities/create_shipment_params.dart';
import '../entities/shipment.dart';

/// Shipment Repository Interface - Domain Layer
///
/// Defines the contract for shipment data operations.
abstract class ShipmentRepository {
  /// Get paginated shipment list using RPC
  ///
  /// [companyId] - Required company ID
  /// [search] - Optional search keyword
  /// [status] - Optional status filter (pending, process, complete, cancelled)
  /// [supplierId] - Optional supplier filter
  /// [orderId] - Optional order ID filter
  /// [hasOrder] - Optional filter by order linkage
  /// [startDate] - Optional start date filter
  /// [endDate] - Optional end date filter
  /// [timezone] - User's timezone (default: Asia/Ho_Chi_Minh)
  /// [limit] - Page size (default: 50)
  /// [offset] - Pagination offset (default: 0)
  Future<PaginatedShipmentResponse> getShipments({
    required String companyId,
    String? search,
    String? status,
    String? supplierId,
    String? orderId,
    bool? hasOrder,
    DateTime? startDate,
    DateTime? endDate,
    String timezone,
    int limit,
    int offset,
  });

  /// Get shipment detail using RPC (inventory_get_shipment_detail_v2)
  ///
  /// Returns detailed shipment info including:
  /// - Shipment header info
  /// - Supplier info
  /// - Items with variant support and receiving progress
  /// - Receiving summary
  /// - Linked orders
  /// - Available actions
  Future<ShipmentDetail?> getShipmentDetail({
    required String shipmentId,
    required String companyId,
    String timezone,
  });

  /// Close (cancel) a shipment using RPC (inventory_close_shipment)
  ///
  /// Cancels the shipment and all linked sessions.
  /// Only shipments with status 'pending' or 'process' can be closed.
  Future<Map<String, dynamic>> closeShipment({
    required String shipmentId,
    required String userId,
    required String companyId,
    String timezone,
  });

  /// Create shipment using RPC v3 (inventory_create_shipment_v3)
  ///
  /// Creates a new shipment with items, optionally linked to orders.
  Future<CreateShipmentResponse> createShipmentV3(CreateShipmentParams params);

  /// Get counterparties for shipment creation (get_counterparty_info RPC)
  ///
  /// Returns list of counterparties (suppliers) for the company.
  Future<List<CounterpartyInfo>> getCounterparties({
    required String companyId,
  });

  /// Get linkable orders for shipment creation (inventory_get_order_info RPC)
  ///
  /// Returns list of orders that can be linked to a shipment.
  Future<List<LinkableOrder>> getLinkableOrders({
    required String companyId,
    String? search,
  });
}
