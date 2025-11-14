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

    if (params.confirmStartTime.isEmpty) {
      throw ArgumentError('Confirm start time cannot be empty');
    }

    if (params.confirmEndTime.isEmpty) {
      throw ArgumentError('Confirm end time cannot be empty');
    }

    // Validate time format (HH:mm)
    final timeRegex = RegExp(r'^\d{2}:\d{2}$');
    if (!timeRegex.hasMatch(params.confirmStartTime)) {
      throw ArgumentError('Invalid start time format. Expected HH:mm');
    }

    if (!timeRegex.hasMatch(params.confirmEndTime)) {
      throw ArgumentError('Invalid end time format. Expected HH:mm');
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
    );
  }
}

/// Parameters for InputCard UseCase
class InputCardParams {
  final String managerId;
  final String shiftRequestId;
  final String confirmStartTime;
  final String confirmEndTime;
  final String? newTagContent;
  final String? newTagType;
  final bool isLate;
  final bool isProblemSolved;

  const InputCardParams({
    required this.managerId,
    required this.shiftRequestId,
    required this.confirmStartTime,
    required this.confirmEndTime,
    this.newTagContent,
    this.newTagType,
    required this.isLate,
    required this.isProblemSolved,
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
        other.isProblemSolved == isProblemSolved;
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
      isProblemSolved.hashCode;
}
