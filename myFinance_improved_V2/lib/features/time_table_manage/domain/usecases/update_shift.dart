import 'package:freezed_annotation/freezed_annotation.dart';

import '../entities/shift_request.dart';
import '../repositories/time_table_repository.dart';
import 'base_usecase.dart';

part 'update_shift.freezed.dart';

/// Update Shift UseCase
///
/// Updates shift details (start time, end time, problem status).
class UpdateShift implements UseCase<ShiftRequest, UpdateShiftParams> {
  final TimeTableRepository _repository;

  UpdateShift(this._repository);

  @override
  Future<ShiftRequest> call(UpdateShiftParams params) async {
    if (params.shiftRequestId.isEmpty) {
      throw ArgumentError('Shift request ID cannot be empty');
    }

    // At least one field should be provided for update
    if (params.startTime == null &&
        params.endTime == null &&
        params.isProblemSolved == null) {
      throw ArgumentError('At least one field must be provided for update');
    }

    return await _repository.updateShift(
      shiftRequestId: params.shiftRequestId,
      startTime: params.startTime,
      endTime: params.endTime,
      isProblemSolved: params.isProblemSolved,
    );
  }
}

/// Parameters for UpdateShift UseCase
@freezed
class UpdateShiftParams with _$UpdateShiftParams {
  const factory UpdateShiftParams({
    required String shiftRequestId,
    String? startTime,
    String? endTime,
    bool? isProblemSolved,
  }) = _UpdateShiftParams;
}
