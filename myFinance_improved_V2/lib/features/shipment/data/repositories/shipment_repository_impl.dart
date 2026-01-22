import '../../domain/entities/create_shipment_params.dart';
import '../../domain/entities/shipment.dart';
import '../../domain/repositories/shipment_repository.dart';
import '../datasources/shipment_remote_datasource.dart';
import '../models/shipment_model.dart';

/// Shipment Repository Implementation - Data Layer
///
/// Implements the domain repository interface using remote datasource.
class ShipmentRepositoryImpl implements ShipmentRepository {
  final ShipmentRemoteDatasource _remoteDatasource;

  ShipmentRepositoryImpl(this._remoteDatasource);

  @override
  Future<PaginatedShipmentResponse> getShipments({
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
  }) async {
    final response = await _remoteDatasource.getShipments(
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
    return response.toEntity();
  }

  @override
  Future<Shipment?> getShipmentById(String shipmentId) async {
    final model = await _remoteDatasource.getShipmentById(shipmentId);
    return model?.toEntity();
  }

  @override
  Future<List<ShipmentListItem>> getShipmentsByOrderId(String orderId) async {
    final models = await _remoteDatasource.getShipmentsByOrderId(orderId);
    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Future<Shipment> createShipment(Shipment shipment) async {
    final model = ShipmentModel.fromEntity(shipment);
    final createdModel = await _remoteDatasource.createShipment(model);
    return createdModel.toEntity();
  }

  @override
  Future<Shipment> updateShipment(Shipment shipment) async {
    final model = ShipmentModel.fromEntity(shipment);
    final updatedModel = await _remoteDatasource.updateShipment(model);
    return updatedModel.toEntity();
  }

  @override
  Future<void> deleteShipment(String shipmentId) async {
    await _remoteDatasource.deleteShipment(shipmentId);
  }

  @override
  Future<void> updateShipmentStatus(
    String shipmentId,
    ShipmentStatus status,
  ) async {
    await _remoteDatasource.updateShipmentStatus(shipmentId, status.name);
  }

  @override
  Future<List<ShipmentItem>> getShipmentItems(String shipmentId) async {
    final models = await _remoteDatasource.getShipmentItems(shipmentId);
    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Future<ShipmentItem> addShipmentItem(ShipmentItem item) async {
    final model = ShipmentItemModel.fromEntity(item);
    final createdModel = await _remoteDatasource.addShipmentItem(model);
    return createdModel.toEntity();
  }

  @override
  Future<ShipmentItem> updateShipmentItem(ShipmentItem item) async {
    final model = ShipmentItemModel.fromEntity(item);
    final updatedModel = await _remoteDatasource.updateShipmentItem(model);
    return updatedModel.toEntity();
  }

  @override
  Future<void> deleteShipmentItem(String itemId) async {
    await _remoteDatasource.deleteShipmentItem(itemId);
  }

  @override
  Future<PaginatedShipmentResponse> searchShipments({
    required String companyId,
    required String query,
    int limit = 50,
    int offset = 0,
  }) async {
    final response = await _remoteDatasource.searchShipments(
      companyId: companyId,
      query: query,
      limit: limit,
      offset: offset,
    );
    return response.toEntity();
  }

  @override
  Future<Map<String, int>> getShipmentCountByStatus({
    required String companyId,
  }) async {
    return await _remoteDatasource.getShipmentCountByStatus(
      companyId: companyId,
    );
  }

  @override
  Future<ShipmentDetail?> getShipmentDetail({
    required String shipmentId,
    required String companyId,
    String timezone = 'Asia/Ho_Chi_Minh',
  }) async {
    final model = await _remoteDatasource.getShipmentDetail(
      shipmentId: shipmentId,
      companyId: companyId,
      timezone: timezone,
    );
    return model?.toEntity();
  }

  @override
  Future<Map<String, dynamic>> closeShipment({
    required String shipmentId,
    required String userId,
    required String companyId,
    String timezone = 'Asia/Ho_Chi_Minh',
  }) async {
    return await _remoteDatasource.closeShipment(
      shipmentId: shipmentId,
      userId: userId,
      companyId: companyId,
      timezone: timezone,
    );
  }

  @override
  Future<CreateShipmentResponse> createShipmentV3(
    CreateShipmentParams params,
  ) async {
    return await _remoteDatasource.createShipmentV3(params);
  }

  @override
  Future<List<CounterpartyInfo>> getCounterparties({
    required String companyId,
  }) async {
    return await _remoteDatasource.getCounterparties(companyId: companyId);
  }

  @override
  Future<List<LinkableOrder>> getLinkableOrders({
    required String companyId,
    String? search,
  }) async {
    return await _remoteDatasource.getLinkableOrders(
      companyId: companyId,
      search: search,
    );
  }
}
