import '../../../domain/entities/card_input_result.dart';
import '../../../domain/entities/employee_info.dart';
import '../../../domain/entities/shift_request.dart';
import 'card_input_result_dto.dart';
import 'shift_card_dto.dart';
import 'shift_card_dto_mapper.dart';

/// Extension to map CardInputResultDto → Domain Entity
extension CardInputResultDtoMapper on CardInputResultDto {
  /// Convert DTO to Domain Entity
  ///
  /// Time conversion logic:
  /// - RPC returns times in HH:mm format already converted to local timezone
  /// - Combine with shift_date (local date from start_time_utc AT TIMEZONE)
  /// - NO UTC conversion needed - times are already local!
  CardInputResult toEntity() {
    // Parse time strings (HH:mm) combining with shift date
    // NOTE: RPC returns local times via p_timezone parameter
    DateTime parseTimeWithDate(String timeStr) {
      if (timeStr.isEmpty || shiftDate.isEmpty) {
        return DateTime.now();
      }

      try {
        // timeStr is in HH:mm format from RPC (already local time)
        // Combine with shift date (local date) - NO UTC conversion needed
        return DateTime.parse('${shiftDate}T$timeStr:00');
      } catch (e) {
        return DateTime.now();
      }
    }

    // Convert shiftData to ShiftRequest
    final ShiftRequest updatedRequest = shiftData != null
        ? _convertToShiftRequest(shiftData!)
        : _createFallbackShiftRequest();

    return CardInputResult(
      shiftRequestId: shiftRequestId,
      confirmedStartTime: parseTimeWithDate(confirmStartTime),
      confirmedEndTime: parseTimeWithDate(confirmEndTime),
      isLate: isLate,
      isProblemSolved: isProblemSolved,
      newTag: newTag?.toEntity(),
      updatedRequest: updatedRequest,
      message: message,
    );
  }

  /// Convert ShiftCardDto to ShiftRequest entity
  ShiftRequest _convertToShiftRequest(ShiftCardDto dto) {
    final shiftCard = dto.toEntity();

    return ShiftRequest(
      shiftRequestId: shiftCard.shiftRequestId,
      shiftId: shiftCard.shift.shiftId,
      employee: shiftCard.employee,
      isApproved: shiftCard.isApproved,
      createdAt: shiftCard.createdAt,
      approvedAt: shiftCard.approvedAt,
    );
  }

  /// Create fallback ShiftRequest when shiftData is null
  ShiftRequest _createFallbackShiftRequest() {
    return ShiftRequest(
      shiftRequestId: shiftRequestId,
      shiftId: '',
      employee: const EmployeeInfo(
        userId: '',
        userName: 'Unknown',
        profileImage: null,
      ),
      isApproved: false,
      createdAt: DateTime.now(),
      approvedAt: null,
    );
  }
}
