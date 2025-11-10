import '../entities/shift_request.dart';
import '../repositories/time_table_repository.dart';
import 'base_usecase.dart';

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
class UpdateShiftParams {
  final String shiftRequestId;
  final String? startTime;
  final String? endTime;
  final bool? isProblemSolved;

  const UpdateShiftParams({
    required this.shiftRequestId,
    this.startTime,
    this.endTime,
    this.isProblemSolved,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is UpdateShiftParams &&
        other.shiftRequestId == shiftRequestId &&
        other.startTime == startTime &&
        other.endTime == endTime &&
        other.isProblemSolved == isProblemSolved;
  }

  @override
  int get hashCode =>
      shiftRequestId.hashCode ^
      startTime.hashCode ^
      endTime.hashCode ^
      isProblemSolved.hashCode;
}
