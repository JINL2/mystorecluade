import '../repositories/time_table_repository.dart';
import 'base_usecase.dart';

/// Input Card V4 UseCase
///
/// Updates shift card with confirmed times, problem solved status, and bonus amount.
/// Uses manager_shift_input_card_v4 RPC.
///
/// Key differences from v3:
/// - No tag management (tags handled separately)
/// - No isLate parameter (read-only from RPC)
/// - Added bonus_amount parameter
/// - Simplified response (success/error only)
class InputCardV4 implements UseCase<Map<String, dynamic>, InputCardV4Params> {
  final TimeTableRepository _repository;

  InputCardV4(this._repository);

  @override
  Future<Map<String, dynamic>> call(InputCardV4Params params) async {
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

    return await _repository.inputCardV4(
      managerId: params.managerId,
      shiftRequestId: params.shiftRequestId,
      confirmStartTime: params.confirmStartTime,
      confirmEndTime: params.confirmEndTime,
      isProblemSolved: params.isProblemSolved,
      bonusAmount: params.bonusAmount,
      timezone: params.timezone,
    );
  }
}

/// Parameters for InputCardV4 UseCase
class InputCardV4Params {
  final String managerId;
  final String shiftRequestId;
  final String? confirmStartTime;  // HH:mm:ss format, null to keep existing
  final String? confirmEndTime;    // HH:mm:ss format, null to keep existing
  final bool? isProblemSolved;     // null to keep existing
  final double? bonusAmount;       // null to keep existing
  final String timezone;

  const InputCardV4Params({
    required this.managerId,
    required this.shiftRequestId,
    this.confirmStartTime,
    this.confirmEndTime,
    this.isProblemSolved,
    this.bonusAmount,
    required this.timezone,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is InputCardV4Params &&
        other.managerId == managerId &&
        other.shiftRequestId == shiftRequestId &&
        other.confirmStartTime == confirmStartTime &&
        other.confirmEndTime == confirmEndTime &&
        other.isProblemSolved == isProblemSolved &&
        other.bonusAmount == bonusAmount &&
        other.timezone == timezone;
  }

  @override
  int get hashCode =>
      managerId.hashCode ^
      shiftRequestId.hashCode ^
      confirmStartTime.hashCode ^
      confirmEndTime.hashCode ^
      isProblemSolved.hashCode ^
      bonusAmount.hashCode ^
      timezone.hashCode;
}
