import '../entities/store_shift.dart';
import '../repositories/store_shift_repository.dart';
import '../value_objects/shift_params.dart';
import 'base_usecase.dart';

class CreateShift implements UseCase<StoreShift, CreateShiftParams> {
  final StoreShiftRepository _repository;

  CreateShift(this._repository);

  @override
  Future<StoreShift> call(CreateShiftParams params) async {
    return await _repository.createShift(
      storeId: params.storeId,
      shiftName: params.shiftName,
      startTime: params.startTime,
      endTime: params.endTime,
      numberShift: params.numberShift,
      isCanOvertime: params.isCanOvertime,
      shiftBonus: params.shiftBonus,
    );
  }
}
