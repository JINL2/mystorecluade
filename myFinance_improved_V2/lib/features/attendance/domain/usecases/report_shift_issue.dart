import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../repositories/attendance_repository.dart';

/// Report an issue with a shift
///
/// Uses report_shift_request RPC to update shift_requests table
///
/// Clean Architecture: Returns Either<Failure, bool>
class ReportShiftIssue {
  final AttendanceRepository _repository;

  ReportShiftIssue(this._repository);

  Future<Either<Failure, bool>> call({
    required String shiftRequestId,
    required String reportReason,
    required String time,
    required String timezone,
  }) {
    return _repository.reportShiftIssue(
      shiftRequestId: shiftRequestId,
      reportReason: reportReason,
      time: time,
      timezone: timezone,
    );
  }
}
