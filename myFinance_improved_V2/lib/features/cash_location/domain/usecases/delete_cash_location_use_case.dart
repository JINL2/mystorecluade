import 'use_case.dart';
import '../repositories/cash_location_repository.dart';

/// UseCase for deleting a cash location
///
/// This will:
/// - Mark the location as deleted (soft delete)
/// - Or permanently remove it (hard delete) based on repository implementation
/// - Ensure referential integrity with related transactions
class DeleteCashLocationUseCase implements UseCase<void, String> {
  final CashLocationRepository repository;

  DeleteCashLocationUseCase(this.repository);

  @override
  Future<void> call(String locationId) async {
    return repository.deleteCashLocation(locationId);
  }
}
