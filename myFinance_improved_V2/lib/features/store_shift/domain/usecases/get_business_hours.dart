import '../entities/business_hours.dart';
import '../repositories/store_shift_repository.dart';
import '../value_objects/shift_params.dart';
import 'base_usecase.dart';

/// Get Business Hours UseCase
///
/// Retrieves business hours for a specific store.
/// Returns a list of [BusinessHours] for each day of the week.
class GetBusinessHours implements UseCase<List<BusinessHours>, GetBusinessHoursParams> {
  final StoreShiftRepository _repository;

  GetBusinessHours(this._repository);

  @override
  Future<List<BusinessHours>> call(GetBusinessHoursParams params) async {
    return await _repository.getBusinessHours(params.storeId);
  }
}
