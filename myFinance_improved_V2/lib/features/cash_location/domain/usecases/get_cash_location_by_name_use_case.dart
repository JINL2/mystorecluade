import '../entities/cash_location_detail.dart';
import '../repositories/cash_location_repository.dart';

/// UseCase for getting a cash location by name
///
/// Used for searching and finding locations by their display name
class GetCashLocationByNameUseCase {
  final CashLocationRepository repository;

  GetCashLocationByNameUseCase(this.repository);

  Future<CashLocationDetail?> call({
    required String companyId,
    required String storeId,
    required String locationName,
    String? locationType,
  }) async {
    return repository.getCashLocationByName(
      companyId: companyId,
      storeId: storeId,
      locationName: locationName,
      locationType: locationType ?? '',
    );
  }
}
