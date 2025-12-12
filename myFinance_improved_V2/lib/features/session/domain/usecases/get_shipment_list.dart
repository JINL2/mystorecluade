import '../entities/shipment.dart';
import '../repositories/session_repository.dart';

/// Get shipment list for receiving session creation
///
/// For receiving session creation - select a shipment to receive
/// Matches RPC: inventory_get_shipment_list
class GetShipmentList {
  final SessionRepository _repository;

  GetShipmentList(this._repository);

  Future<ShipmentListResponse> call({
    required String companyId,
    String? search,
    String? status,
    String? supplierId,
    DateTime? startDate,
    DateTime? endDate,
    int limit = 50,
    int offset = 0,
  }) {
    return _repository.getShipmentList(
      companyId: companyId,
      search: search,
      status: status,
      supplierId: supplierId,
      startDate: startDate,
      endDate: endDate,
      limit: limit,
      offset: offset,
    );
  }
}
