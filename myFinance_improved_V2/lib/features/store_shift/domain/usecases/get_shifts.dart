import '../entities/store_shift.dart';
import '../repositories/store_shift_repository.dart';
import '../value_objects/shift_params.dart';
import 'base_usecase.dart';

class GetShifts implements UseCase<List<StoreShift>, GetShiftsParams> {
  final StoreShiftRepository _repository;

  GetShifts(this._repository);

  @override
  Future<List<StoreShift>> call(GetShiftsParams params) async {
    return await _repository.getShiftsByStoreId(params.storeId);
  }
}
