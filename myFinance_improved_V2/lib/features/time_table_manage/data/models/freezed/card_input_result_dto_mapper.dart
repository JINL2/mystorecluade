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
  /// - RPC returns times in HH:mm format (UTC)
  /// - Combine with request_date to create full timestamp
  /// - Convert from UTC to local time
  CardInputResult toEntity() {
    // Parse time strings (HH:mm) combining with request date
    DateTime parseTimeWithDate(String timeStr) {
      if (timeStr.isEmpty || requestDate.isEmpty) {
        return DateTime.now();
      }

      try {
        // timeStr is in HH:mm format from RPC (UTC time)
        // Combine with request date and mark as UTC
        final utcDateTime = DateTime.parse('${requestDate}T$timeStr:00Z');
        return utcDateTime.toLocal();
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
      employee: EmployeeInfo(
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
