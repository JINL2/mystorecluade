import 'package:freezed_annotation/freezed_annotation.dart';

import 'shift_request.dart';
import 'tag.dart';

part 'card_input_result.freezed.dart';
part 'card_input_result.g.dart';

/// Card Input Result Entity
///
/// Represents the result of inputting/updating shift card data,
/// including confirmed times, problem status, and tags.
@freezed
class CardInputResult with _$CardInputResult {
  const CardInputResult._();

  const factory CardInputResult({
    /// The shift request ID that was updated
    @JsonKey(name: 'shift_request_id')
    required String shiftRequestId,

    /// Confirmed start time (actual start time)
    @JsonKey(name: 'confirmed_start_time')
    required DateTime confirmedStartTime,

    /// Confirmed end time (actual end time)
    @JsonKey(name: 'confirmed_end_time')
    required DateTime confirmedEndTime,

    /// Whether the employee was late
    @JsonKey(name: 'is_late')
    required bool isLate,

    /// Whether any problem was solved
    @JsonKey(name: 'is_problem_solved')
    required bool isProblemSolved,

    /// The new tag that was created (if any)
    @JsonKey(name: 'new_tag')
    Tag? newTag,

    /// The updated shift request entity after input
    @JsonKey(name: 'updated_request')
    required ShiftRequest updatedRequest,

    /// Optional message about the result
    String? message,
  }) = _CardInputResult;

  /// Create from JSON
  factory CardInputResult.fromJson(Map<String, dynamic> json) =>
      _$CardInputResultFromJson(json);

  /// Calculate actual work duration in hours
  double get actualWorkDurationInHours {
    final duration = confirmedEndTime.difference(confirmedStartTime);
    return duration.inMinutes / 60.0;
  }

  /// Check if a new tag was added
  bool get hasNewTag => newTag != null;

  /// Check if employee was on time
  bool get wasOnTime => !isLate;
}
