import '../entities/operation_result.dart';
import '../repositories/time_table_repository.dart';
import 'base_usecase.dart';

/// Delete Shift UseCase
///
/// Deletes a shift by its ID.
class DeleteShift implements UseCase<OperationResult, DeleteShiftParams> {
  final TimeTableRepository _repository;

  DeleteShift(this._repository);

  @override
  Future<OperationResult> call(DeleteShiftParams params) async {
    if (params.shiftId.isEmpty) {
      throw ArgumentError('Shift ID cannot be empty');
    }

    return await _repository.deleteShift(shiftId: params.shiftId);
  }
}

/// Parameters for DeleteShift UseCase
class DeleteShiftParams {
  final String shiftId;

  const DeleteShiftParams({
    required this.shiftId,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is DeleteShiftParams && other.shiftId == shiftId;
  }

  @override
  int get hashCode => shiftId.hashCode;
}
