import '../entities/cash_location_detail.dart';
import '../repositories/cash_location_repository.dart';
import 'use_case.dart';

/// UseCase for getting a specific cash location by ID
///
/// Returns detailed information about a cash location including:
/// - Location details (name, type, bank info)
/// - Current balances
/// - Transaction history
class GetCashLocationByIdUseCase
    implements UseCase<CashLocationDetail?, String> {
  final CashLocationRepository repository;

  GetCashLocationByIdUseCase(this.repository);

  @override
  Future<CashLocationDetail?> call(String locationId) async {
    return repository.getCashLocationById(locationId: locationId);
  }
}
