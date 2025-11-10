import '../../../../core/utils/datetime_utils.dart';
import '../../domain/entities/card_input_result.dart';
import 'shift_request_model.dart';
import 'tag_model.dart';

/// Card Input Result Model (DTO + Mapper)
class CardInputResultModel {
  final String shiftRequestId;
  final String confirmedStartTime;
  final String confirmedEndTime;
  final bool isLate;
  final bool isProblemSolved;
  final TagModel? newTag;
  final ShiftRequestModel updatedRequest;
  final String? message;
  final String requestDate; // Added to support UTC conversion

  const CardInputResultModel({
    required this.shiftRequestId,
    required this.confirmedStartTime,
    required this.confirmedEndTime,
    required this.isLate,
    required this.isProblemSolved,
    this.newTag,
    required this.updatedRequest,
    this.message,
    required this.requestDate,
  });

  factory CardInputResultModel.fromJson(Map<String, dynamic> json) {
    // RPC returns shift data directly, not nested in 'updated_request'
    return CardInputResultModel(
      shiftRequestId: json['shift_request_id'] as String? ?? '',
      confirmedStartTime: json['confirm_start_time'] as String? ?? json['confirmed_start_time'] as String? ?? '',
      confirmedEndTime: json['confirm_end_time'] as String? ?? json['confirmed_end_time'] as String? ?? '',
      isLate: json['is_late'] as bool? ?? false,
      isProblemSolved: json['is_problem_solved'] as bool? ?? false,
      newTag: json['new_tag'] != null
          ? TagModel.fromJson(json['new_tag'] as Map<String, dynamic>)
          : null,
      updatedRequest: ShiftRequestModel.fromJson(json),  // Use entire JSON as shift data
      message: json['message'] as String?,
      requestDate: json['request_date'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'shift_request_id': shiftRequestId,
      'confirmed_start_time': confirmedStartTime,
      'confirmed_end_time': confirmedEndTime,
      'is_late': isLate,
      'is_problem_solved': isProblemSolved,
      if (newTag != null) 'new_tag': newTag!.toJson(),
      'updated_request': updatedRequest.toJson(),
      if (message != null) 'message': message,
      'request_date': requestDate,
    };
  }

  CardInputResult toEntity() {
    // Convert time-only strings (HH:mm) to DateTime using request date
    // IMPORTANT: RPC returns UTC time in HH:mm format, so we need to:
    // 1. Combine with request_date to create full timestamp
    // 2. Mark it as UTC
    // 3. Convert to local time

    DateTime parseTimeWithDate(String timeStr) {
      // timeStr is in HH:mm format from RPC (UTC time)
      // Combine with request date and mark as UTC, then convert to local
      final utcDateTime = DateTime.parse('${requestDate}T$timeStr:00Z');
      final localDateTime = utcDateTime.toLocal();
      return localDateTime;
    }

    return CardInputResult(
      shiftRequestId: shiftRequestId,
      confirmedStartTime: parseTimeWithDate(confirmedStartTime),
      confirmedEndTime: parseTimeWithDate(confirmedEndTime),
      isLate: isLate,
      isProblemSolved: isProblemSolved,
      newTag: newTag?.toEntity(),
      updatedRequest: updatedRequest.toEntity(),
      message: message,
    );
  }

  factory CardInputResultModel.fromEntity(CardInputResult entity) {
    // Extract request date from confirmedStartTime
    final requestDate = '${entity.confirmedStartTime.year.toString().padLeft(4, '0')}-${entity.confirmedStartTime.month.toString().padLeft(2, '0')}-${entity.confirmedStartTime.day.toString().padLeft(2, '0')}';

    return CardInputResultModel(
      shiftRequestId: entity.shiftRequestId,
      confirmedStartTime: DateTimeUtils.toUtc(entity.confirmedStartTime),
      confirmedEndTime: DateTimeUtils.toUtc(entity.confirmedEndTime),
      isLate: entity.isLate,
      isProblemSolved: entity.isProblemSolved,
      newTag: entity.newTag != null ? TagModel.fromEntity(entity.newTag!) : null,
      updatedRequest: ShiftRequestModel.fromEntity(entity.updatedRequest),
      message: entity.message,
      requestDate: requestDate,
    );
  }
}
