import 'package:freezed_annotation/freezed_annotation.dart';
import 'shift_card_dto.dart';

part 'card_input_result_dto.freezed.dart';
// Note: .g.dart not generated due to custom fromJson implementation

/// Card Input Result DTO
///
/// Maps to RPC: manager_shift_input_card
///
/// Returns the result of comprehensive shift update operation including:
/// - Confirmed start/end times
/// - Late status
/// - Problem resolution status
/// - Optional new tag creation
/// - Updated shift request data
@freezed
class CardInputResultDto with _$CardInputResultDto {
  const factory CardInputResultDto({
    /// Shift request ID that was updated
    @JsonKey(name: 'shift_request_id') @Default('') String shiftRequestId,

    /// Confirmed start time (HH:mm format in UTC)
    @JsonKey(name: 'confirm_start_time') @Default('') String confirmStartTime,

    /// Confirmed end time (HH:mm format in UTC)
    @JsonKey(name: 'confirm_end_time') @Default('') String confirmEndTime,

    /// Whether employee was late
    @JsonKey(name: 'is_late') @Default(false) bool isLate,

    /// Whether any problem was resolved
    @JsonKey(name: 'is_problem_solved') @Default(false) bool isProblemSolved,

    /// Newly created tag (if any)
    @JsonKey(name: 'new_tag') TagDto? newTag,

    /// Full updated shift card data
    /// Note: RPC returns all shift fields at root level, not nested
    @JsonKey(name: 'shift_data') ShiftCardDto? shiftData,

    /// Optional success/error message
    @JsonKey(name: 'message') String? message,

    /// Request date for time conversion (YYYY-MM-DD)
    @JsonKey(name: 'request_date') @Default('') String requestDate,
  }) = _CardInputResultDto;

  /// Custom fromJson to handle RPC's flat structure
  factory CardInputResultDto.fromJson(Map<String, dynamic> json) {
    // RPC returns shift data at root level, not nested
    // Extract the card input specific fields first
    final shiftRequestId = json['shift_request_id'] as String? ?? '';
    final confirmStartTime = json['confirm_start_time'] as String? ??
                            json['confirmed_start_time'] as String? ?? '';
    final confirmEndTime = json['confirm_end_time'] as String? ??
                          json['confirmed_end_time'] as String? ?? '';
    final isLate = json['is_late'] as bool? ?? false;
    final isProblemSolved = json['is_problem_solved'] as bool? ?? false;
    final message = json['message'] as String?;
    final requestDate = json['request_date'] as String? ?? '';

    // Parse new tag if present
    final TagDto? newTag = json['new_tag'] != null
        ? TagDto.fromJson(json['new_tag'] as Map<String, dynamic>)
        : null;

    // The entire JSON represents the shift data
    // Pass it to ShiftCardDto which knows how to parse it
    final ShiftCardDto shiftData = ShiftCardDto.fromJson(json);

    return CardInputResultDto(
      shiftRequestId: shiftRequestId,
      confirmStartTime: confirmStartTime,
      confirmEndTime: confirmEndTime,
      isLate: isLate,
      isProblemSolved: isProblemSolved,
      newTag: newTag,
      shiftData: shiftData,
      message: message,
      requestDate: requestDate,
    );
  }
}
