import '../entities/card_input_result.dart';
import '../repositories/time_table_repository.dart';
import 'base_usecase.dart';

/// Input Card UseCase
///
/// Inputs comprehensive shift card data with confirmed times and tags.
class InputCard implements UseCase<CardInputResult, InputCardParams> {
  final TimeTableRepository _repository;

  InputCard(this._repository);

  @override
  Future<CardInputResult> call(InputCardParams params) async {
    if (params.managerId.isEmpty) {
      throw ArgumentError('Manager ID cannot be empty');
    }

    if (params.shiftRequestId.isEmpty) {
      throw ArgumentError('Shift request ID cannot be empty');
    }

    // Validate time format (HH:mm) only if times are provided
    final timeRegex = RegExp(r'^\d{2}:\d{2}$');
    if (params.confirmStartTime != null && params.confirmStartTime!.isNotEmpty) {
      if (!timeRegex.hasMatch(params.confirmStartTime!)) {
        throw ArgumentError('Invalid start time format. Expected HH:mm');
      }
    }

    if (params.confirmEndTime != null && params.confirmEndTime!.isNotEmpty) {
      if (!timeRegex.hasMatch(params.confirmEndTime!)) {
        throw ArgumentError('Invalid end time format. Expected HH:mm');
      }
    }

    return await _repository.inputCard(
      managerId: params.managerId,
      shiftRequestId: params.shiftRequestId,
      confirmStartTime: params.confirmStartTime,
      confirmEndTime: params.confirmEndTime,
      newTagContent: params.newTagContent,
      newTagType: params.newTagType,
      isLate: params.isLate,
      isProblemSolved: params.isProblemSolved,
      timezone: params.timezone,
    );
  }
}

/// Parameters for InputCard UseCase
class InputCardParams {
  final String managerId;
  final String shiftRequestId;
  final String? confirmStartTime;  // Nullable - RPC will keep existing value if null
  final String? confirmEndTime;    // Nullable - RPC will keep existing value if null
  final String? newTagContent;
  final String? newTagType;
  final bool isLate;
  final bool isProblemSolved;
  final String timezone;

  const InputCardParams({
    required this.managerId,
    required this.shiftRequestId,
    this.confirmStartTime,  // Now optional
    this.confirmEndTime,    // Now optional
    this.newTagContent,
    this.newTagType,
    required this.isLate,
    required this.isProblemSolved,
    required this.timezone,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is InputCardParams &&
        other.managerId == managerId &&
        other.shiftRequestId == shiftRequestId &&
        other.confirmStartTime == confirmStartTime &&
        other.confirmEndTime == confirmEndTime &&
        other.newTagContent == newTagContent &&
        other.newTagType == newTagType &&
        other.isLate == isLate &&
        other.isProblemSolved == isProblemSolved &&
        other.timezone == timezone;
  }

  @override
  int get hashCode =>
      managerId.hashCode ^
      shiftRequestId.hashCode ^
      confirmStartTime.hashCode ^
      confirmEndTime.hashCode ^
      newTagContent.hashCode ^
      newTagType.hashCode ^
      isLate.hashCode ^
      isProblemSolved.hashCode ^
      timezone.hashCode;
}
