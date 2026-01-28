import '../../domain/entities/create_shipment_params.dart';
import '../../domain/entities/shipment.dart';
import '../../domain/repositories/shipment_repository.dart';
import '../datasources/shipment_remote_datasource.dart';

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
