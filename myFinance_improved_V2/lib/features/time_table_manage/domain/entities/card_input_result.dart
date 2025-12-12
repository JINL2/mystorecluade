import 'shift_request.dart';
import 'tag.dart';

/// Card Input Result Entity
///
/// Represents the result of inputting/updating shift card data,
/// including confirmed times, problem status, and tags.
class CardInputResult {
  /// The shift request ID that was updated
  final String shiftRequestId;

  /// Confirmed start time (actual start time)
  final DateTime confirmedStartTime;

  /// Confirmed end time (actual end time)
  final DateTime confirmedEndTime;

  /// Whether the employee was late
  final bool isLate;

  /// Whether any problem was solved
  final bool isProblemSolved;

  /// The new tag that was created (if any)
  final Tag? newTag;

  /// The updated shift request entity after input
  final ShiftRequest updatedRequest;

  /// Optional message about the result
  final String? message;

  const CardInputResult({
    required this.shiftRequestId,
    required this.confirmedStartTime,
    required this.confirmedEndTime,
    required this.isLate,
    required this.isProblemSolved,
    this.newTag,
    required this.updatedRequest,
    this.message,
  });

  /// Check if a new tag was added
  bool get hasNewTag => newTag != null;

  /// Check if employee was on time
  bool get wasOnTime => !isLate;

  /// Copy with method for immutability
  CardInputResult copyWith({
    String? shiftRequestId,
    DateTime? confirmedStartTime,
    DateTime? confirmedEndTime,
    bool? isLate,
    bool? isProblemSolved,
    Tag? newTag,
    ShiftRequest? updatedRequest,
    String? message,
  }) {
    return CardInputResult(
      shiftRequestId: shiftRequestId ?? this.shiftRequestId,
      confirmedStartTime: confirmedStartTime ?? this.confirmedStartTime,
      confirmedEndTime: confirmedEndTime ?? this.confirmedEndTime,
      isLate: isLate ?? this.isLate,
      isProblemSolved: isProblemSolved ?? this.isProblemSolved,
      newTag: newTag ?? this.newTag,
      updatedRequest: updatedRequest ?? this.updatedRequest,
      message: message ?? this.message,
    );
  }

  @override
  String toString() {
    return 'CardInputResult(id: $shiftRequestId, start: $confirmedStartTime, end: $confirmedEndTime, late: $isLate)';
  }
}
