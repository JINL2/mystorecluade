import '../repositories/store_shift_repository.dart';
import '../value_objects/shift_params.dart';
import 'base_usecase.dart';

class DeleteShift implements UseCase<void, DeleteShiftParams> {
  final StoreShiftRepository _repository;

  DeleteShift(this._repository);

  @override
  Future<void> call(DeleteShiftParams params) async {
    return await _repository.deleteShift(params.shiftId);
  }
}
