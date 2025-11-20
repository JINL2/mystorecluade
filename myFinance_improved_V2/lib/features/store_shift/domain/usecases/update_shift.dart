import '../entities/store_shift.dart';
import '../repositories/store_shift_repository.dart';
import '../value_objects/shift_params.dart';
import 'base_usecase.dart';

class UpdateShift implements UseCase<StoreShift, UpdateShiftParams> {
  final StoreShiftRepository _repository;

  UpdateShift(this._repository);

  @override
  Future<StoreShift> call(UpdateShiftParams params) async {
    return await _repository.updateShift(
      shiftId: params.shiftId,
      shiftName: params.shiftName,
      startTime: params.startTime,
      endTime: params.endTime,
      shiftBonus: params.shiftBonus,
    );
  }
}
