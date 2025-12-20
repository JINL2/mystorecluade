import '../entities/business_hours.dart';
import '../repositories/store_shift_repository.dart';
import '../value_objects/shift_params.dart';
import 'base_usecase.dart';

/// Update Business Hours UseCase
///
/// Updates business hours for a specific store.
/// Converts [BusinessHoursParam] to [BusinessHours] entities and persists them.
class UpdateBusinessHours implements UseCase<bool, UpdateBusinessHoursParams> {
  final StoreShiftRepository _repository;

  UpdateBusinessHours(this._repository);

  @override
  Future<bool> call(UpdateBusinessHoursParams params) async {
    // Convert params to entities
    final hours = params.hours
        .map(
          (p) => BusinessHours(
            dayOfWeek: p.dayOfWeek,
            dayName: p.dayName,
            isOpen: p.isOpen,
            openTime: p.openTime,
            closeTime: p.closeTime,
            closesNextDay: p.closesNextDay,
          ),
        )
        .toList();

    return _repository.updateBusinessHours(
      storeId: params.storeId,
      hours: hours,
    );
  }
}
