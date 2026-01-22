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

/// Get Shipment By ID UseCase
class GetShipmentByIdUseCase {
  final ShipmentRepository _repository;

  GetShipmentByIdUseCase(this._repository);

  Future<Shipment?> call(String shipmentId) {
    return _repository.getShipmentById(shipmentId);
  }
}

/// Get Shipments By Order ID UseCase
class GetShipmentsByOrderIdUseCase {
  final ShipmentRepository _repository;

  GetShipmentsByOrderIdUseCase(this._repository);

  Future<List<ShipmentListItem>> call(String orderId) {
    return _repository.getShipmentsByOrderId(orderId);
  }
}

/// Create Shipment UseCase
class CreateShipmentUseCase {
  final ShipmentRepository _repository;

  CreateShipmentUseCase(this._repository);

  Future<Shipment> call(Shipment shipment) {
    return _repository.createShipment(shipment);
  }
}

/// Update Shipment UseCase
class UpdateShipmentUseCase {
  final ShipmentRepository _repository;

  UpdateShipmentUseCase(this._repository);

  Future<Shipment> call(Shipment shipment) {
    return _repository.updateShipment(shipment);
  }
}

/// Delete Shipment UseCase
class DeleteShipmentUseCase {
  final ShipmentRepository _repository;

  DeleteShipmentUseCase(this._repository);

  Future<void> call(String shipmentId) {
    return _repository.deleteShipment(shipmentId);
  }
}

/// Update Shipment Status UseCase
class UpdateShipmentStatusUseCase {
  final ShipmentRepository _repository;

  UpdateShipmentStatusUseCase(this._repository);

  Future<void> call(String shipmentId, ShipmentStatus status) {
    return _repository.updateShipmentStatus(shipmentId, status);
  }
}

/// Search Shipments UseCase
class SearchShipmentsUseCase {
  final ShipmentRepository _repository;

  SearchShipmentsUseCase(this._repository);

  Future<PaginatedShipmentResponse> call({
    required String companyId,
    required String query,
    int limit = 50,
    int offset = 0,
  }) {
    return _repository.searchShipments(
      companyId: companyId,
      query: query,
      limit: limit,
      offset: offset,
    );
  }
}

/// Get Shipment Count By Status UseCase
class GetShipmentCountByStatusUseCase {
  final ShipmentRepository _repository;

  GetShipmentCountByStatusUseCase(this._repository);

  Future<Map<String, int>> call({
    required String companyId,
  }) {
    return _repository.getShipmentCountByStatus(
      companyId: companyId,
    );
  }
}

/// Get Shipment Items UseCase
class GetShipmentItemsUseCase {
  final ShipmentRepository _repository;

  GetShipmentItemsUseCase(this._repository);

  Future<List<ShipmentItem>> call(String shipmentId) {
    return _repository.getShipmentItems(shipmentId);
  }
}

/// Add Shipment Item UseCase
class AddShipmentItemUseCase {
  final ShipmentRepository _repository;

  AddShipmentItemUseCase(this._repository);

  Future<ShipmentItem> call(ShipmentItem item) {
    return _repository.addShipmentItem(item);
  }
}

/// Update Shipment Item UseCase
class UpdateShipmentItemUseCase {
  final ShipmentRepository _repository;

  UpdateShipmentItemUseCase(this._repository);

  Future<ShipmentItem> call(ShipmentItem item) {
    return _repository.updateShipmentItem(item);
  }
}

/// Delete Shipment Item UseCase
class DeleteShipmentItemUseCase {
  final ShipmentRepository _repository;

  DeleteShipmentItemUseCase(this._repository);

  Future<void> call(String itemId) {
    return _repository.deleteShipmentItem(itemId);
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
