import '../repositories/time_table_repository.dart';
import 'base_usecase.dart';

/// Input Card V5 UseCase
///
/// Updates shift card with confirmed times, report solved status, bonus amount, and manager memo.
/// Uses manager_shift_input_card_v5 RPC.
///
/// Key differences from v4:
/// - Renamed is_problem_solved → is_reported_solved (for clarity)
/// - Added manager_memo parameter (text field for manager notes)
/// - Returns same success/error response format
class InputCardV5 implements UseCase<Map<String, dynamic>, InputCardV5Params> {
  final TimeTableRepository _repository;

  InputCardV5(this._repository);

  @override
  Future<Map<String, dynamic>> call(InputCardV5Params params) async {
    if (params.managerId.isEmpty) {
      throw ArgumentError('Manager ID cannot be empty');
    }

    if (params.shiftRequestId.isEmpty) {
      throw ArgumentError('Shift request ID cannot be empty');
    }

    // Validate time format (HH:mm:ss) only if times are provided
    final timeRegex = RegExp(r'^\d{2}:\d{2}:\d{2}$');
    if (params.confirmStartTime != null && params.confirmStartTime!.isNotEmpty) {
      if (!timeRegex.hasMatch(params.confirmStartTime!)) {
        throw ArgumentError('Invalid start time format. Expected HH:mm:ss');
      }
    }

    if (params.confirmEndTime != null && params.confirmEndTime!.isNotEmpty) {
      if (!timeRegex.hasMatch(params.confirmEndTime!)) {
        throw ArgumentError('Invalid end time format. Expected HH:mm:ss');
      }
    }

    // Validate bonus amount if provided
    if (params.bonusAmount != null && params.bonusAmount! < 0) {
      throw ArgumentError('Bonus amount cannot be negative');
    }

    return await _repository.inputCardV5(
      managerId: params.managerId,
      shiftRequestId: params.shiftRequestId,
      confirmStartTime: params.confirmStartTime,
      confirmEndTime: params.confirmEndTime,
      isReportedSolved: params.isReportedSolved,
      bonusAmount: params.bonusAmount,
      managerMemo: params.managerMemo,
      timezone: params.timezone,
    );
  }
}

/// Parameters for InputCardV5 UseCase
class InputCardV5Params {
  final String managerId;
  final String shiftRequestId;
  final String? confirmStartTime;  // HH:mm:ss format, null to keep existing
  final String? confirmEndTime;    // HH:mm:ss format, null to keep existing
  final bool? isReportedSolved;    // null to keep existing (renamed from isProblemSolved)
  final double? bonusAmount;       // null to keep existing
  final String? managerMemo;       // null to keep existing (new in v5)
  final String timezone;

  const InputCardV5Params({
    required this.managerId,
    required this.shiftRequestId,
    this.confirmStartTime,
    this.confirmEndTime,
    this.isReportedSolved,
    this.bonusAmount,
    this.managerMemo,
    required this.timezone,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is InputCardV5Params &&
        other.managerId == managerId &&
        other.shiftRequestId == shiftRequestId &&
        other.confirmStartTime == confirmStartTime &&
        other.confirmEndTime == confirmEndTime &&
        other.isReportedSolved == isReportedSolved &&
        other.bonusAmount == bonusAmount &&
        other.managerMemo == managerMemo &&
        other.timezone == timezone;
  }

  @override
  int get hashCode =>
      managerId.hashCode ^
      shiftRequestId.hashCode ^
      confirmStartTime.hashCode ^
      confirmEndTime.hashCode ^
      isReportedSolved.hashCode ^
      bonusAmount.hashCode ^
      managerMemo.hashCode ^
      timezone.hashCode;
}
