import '../entities/shipment.dart';
import '../repositories/shipment_repository.dart';

/// Get Shipments UseCase - Domain Layer
///
/// Retrieves paginated list of shipments using RPC with optional filtering.
class GetShipmentsUseCase {
  final ShipmentRepository _repository;

  GetShipmentsUseCase(this._repository);

  Future<PaginatedShipmentResponse> call({
    required String companyId,
    String? search,
    String? status,
    String? supplierId,
    String? orderId,
    bool? hasOrder,
    DateTime? startDate,
    DateTime? endDate,
    String timezone = 'Asia/Ho_Chi_Minh',
    int limit = 50,
    int offset = 0,
  }) {
    return _repository.getShipments(
      companyId: companyId,
      search: search,
      status: status,
      supplierId: supplierId,
      orderId: orderId,
      hasOrder: hasOrder,
      startDate: startDate,
      endDate: endDate,
      timezone: timezone,
      limit: limit,
      offset: offset,
    );
  }
}

/// Get Shipment Detail UseCase (using inventory_get_shipment_detail_v2 RPC)
///
/// Retrieves detailed shipment information including:
/// - Shipment header info
/// - Supplier info
/// - Items with variant support and receiving progress
/// - Receiving summary
/// - Linked orders
/// - Available actions
class GetShipmentDetailUseCase {
  final ShipmentRepository _repository;

  GetShipmentDetailUseCase(this._repository);

  Future<ShipmentDetail?> call({
    required String shipmentId,
    required String companyId,
    String timezone = 'Asia/Ho_Chi_Minh',
  }) {
    return _repository.getShipmentDetail(
      shipmentId: shipmentId,
      companyId: companyId,
      timezone: timezone,
    );
  }
}

/// Close Shipment UseCase (using inventory_close_shipment RPC)
///
/// Cancels a shipment and all linked sessions.
/// Only shipments with status 'pending' or 'process' can be closed.
class CloseShipmentUseCase {
  final ShipmentRepository _repository;

  CloseShipmentUseCase(this._repository);

  Future<Map<String, dynamic>> call({
    required String shipmentId,
    required String userId,
    required String companyId,
    String timezone = 'Asia/Ho_Chi_Minh',
  }) {
    return _repository.closeShipment(
      shipmentId: shipmentId,
      userId: userId,
      companyId: companyId,
      timezone: timezone,
    );
  }
}
