import 'package:freezed_annotation/freezed_annotation.dart';

import '../entities/operation_result.dart';
import '../repositories/time_table_repository.dart';
import 'base_usecase.dart';

part 'delete_shift.freezed.dart';

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
@freezed
class DeleteShiftParams with _$DeleteShiftParams {
  const factory DeleteShiftParams({
    required String shiftId,
  }) = _DeleteShiftParams;
}
