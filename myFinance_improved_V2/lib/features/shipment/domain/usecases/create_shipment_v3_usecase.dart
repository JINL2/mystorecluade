import '../entities/create_shipment_params.dart';
import '../repositories/shipment_repository.dart';

/// Create Shipment V3 UseCase - Domain Layer
///
/// Creates a new shipment using inventory_create_shipment_v3 RPC.
class CreateShipmentV3UseCase {
  final ShipmentRepository _repository;

  CreateShipmentV3UseCase(this._repository);

  Future<CreateShipmentResponse> call(CreateShipmentParams params) {
    return _repository.createShipmentV3(params);
  }
}

/// Get Counterparties UseCase - Domain Layer
///
/// Retrieves list of counterparties (suppliers) for shipment creation.
class GetCounterpartiesUseCase {
  final ShipmentRepository _repository;

  GetCounterpartiesUseCase(this._repository);

  Future<List<CounterpartyInfo>> call({required String companyId}) {
    return _repository.getCounterparties(companyId: companyId);
  }
}

/// Get Linkable Orders UseCase - Domain Layer
///
/// Retrieves list of orders that can be linked to a shipment.
class GetLinkableOrdersUseCase {
  final ShipmentRepository _repository;

  GetLinkableOrdersUseCase(this._repository);

  Future<List<LinkableOrder>> call({
    required String companyId,
    String? search,
  }) {
    return _repository.getLinkableOrders(
      companyId: companyId,
      search: search,
    );
  }
}
