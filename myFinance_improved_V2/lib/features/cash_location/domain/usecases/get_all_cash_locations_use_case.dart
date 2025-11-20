import '../entities/cash_location.dart';
import '../repositories/cash_location_repository.dart';
import '../value_objects/cash_location_query_params.dart';
import 'use_case.dart';

/// Use case for getting all cash locations
class GetAllCashLocationsUseCase
    implements UseCase<List<CashLocation>, CashLocationQueryParams> {
  final CashLocationRepository repository;

  GetAllCashLocationsUseCase(this.repository);

  @override
  Future<List<CashLocation>> call(CashLocationQueryParams params) async {
    return repository.getAllCashLocations(
      companyId: params.companyId,
      storeId: params.storeId,
    );
  }
}
