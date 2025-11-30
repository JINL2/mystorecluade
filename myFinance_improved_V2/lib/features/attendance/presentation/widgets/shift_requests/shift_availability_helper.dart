import '../../../../../shared/widgets/toss/week_dates_picker.dart';
import '../../../domain/entities/monthly_shift_status.dart';
import '../../../domain/entities/shift_metadata.dart';

/// Helper class for shift availability calculations
class ShiftAvailabilityHelper {
  final List<MonthlyShiftStatus>? monthlyShiftStatus;
  final List<ShiftMetadata>? shiftMetadata;
  final String currentUserId;

  ShiftAvailabilityHelper({
    required this.monthlyShiftStatus,
    required this.shiftMetadata,
    required this.currentUserId,
  });

  /// Get dates where current user has approved shifts (for blue border)
  Set<DateTime> getDatesWithUserApproved(DateTime weekStartDate) {
    if (monthlyShiftStatus == null || monthlyShiftStatus!.isEmpty) {
      return {};
    }

    if (currentUserId.isEmpty) {
      return {};
    }

    final today = DateTime.now();
    final todayNormalized = DateTime(today.year, today.month, today.day);
    final Set<DateTime> datesWithUserApproved = {};

    for (final dayStatus in monthlyShiftStatus!) {
      try {
        final date = DateTime.parse(dayStatus.requestDate);
        final normalizedDate = DateTime(date.year, date.month, date.day);
        final weekEnd = weekStartDate.add(const Duration(days: 6));

        // Only for dates from today onwards within the week
        if (!date.isBefore(weekStartDate) &&
            !date.isAfter(weekEnd) &&
            !normalizedDate.isBefore(todayNormalized)) {
          // Check if current user has any approved shift on this date
          for (final shift in dayStatus.shifts) {
            if (shift.approvedEmployees.any((emp) => emp.userId == currentUserId)) {
              datesWithUserApproved.add(normalizedDate);
              break;
            }
          }
        }
      } catch (_) {
        // Error parsing date
      }
    }

    return datesWithUserApproved;
  }

  /// Get shift availability status for each date (for dots)
  /// Blue dot: has available slots (approvedCount < requiredEmployees)
  /// Gray dot: full (approvedCount >= requiredEmployees)
  /// Only for dates from today onwards
  ///
  /// Logic:
  /// 1. If shiftMetadata exists, all future dates within the week have shifts available
  /// 2. Check monthlyShiftStatus for actual approved counts to determine if full
  Map<DateTime, ShiftAvailabilityStatus> getShiftAvailabilityMap(DateTime weekStartDate) {
    // If no shift metadata, no shifts are defined for this store
    if (shiftMetadata == null || shiftMetadata!.isEmpty) {
      return {};
    }

    final today = DateTime.now();
    final todayNormalized = DateTime(today.year, today.month, today.day);
    final Map<DateTime, ShiftAvailabilityStatus> availabilityMap = {};

    // Build a map of date -> MonthlyShiftStatus for quick lookup
    final Map<String, MonthlyShiftStatus> statusByDate = {};
    if (monthlyShiftStatus != null) {
      for (final dayStatus in monthlyShiftStatus!) {
        statusByDate[dayStatus.requestDate] = dayStatus;
      }
    }

    // Iterate through all dates in the current week
    for (int i = 0; i < 7; i++) {
      final date = weekStartDate.add(Duration(days: i));
      final normalizedDate = DateTime(date.year, date.month, date.day);

      // Only for dates from today onwards
      if (normalizedDate.isBefore(todayNormalized)) {
        continue;
      }

      // Format date to match monthlyShiftStatus format (yyyy-MM-dd)
      final dateString =
          '${normalizedDate.year}-${normalizedDate.month.toString().padLeft(2, '0')}-${normalizedDate.day.toString().padLeft(2, '0')}';

      // Check if we have status data for this date
      final dayStatus = statusByDate[dateString];

      if (dayStatus != null && dayStatus.shifts.isNotEmpty) {
        // We have actual data - check if any shift has available slots
        bool hasAvailableSlots = false;
        for (final shift in dayStatus.shifts) {
          if (shift.hasAvailableSlots) {
            hasAvailableSlots = true;
            break;
          }
        }
        availabilityMap[normalizedDate] = hasAvailableSlots
            ? ShiftAvailabilityStatus.available
            : ShiftAvailabilityStatus.full;
      } else {
        // No status data - shifts exist (from shiftMetadata) but no one has applied yet
        // This means all slots are available (blue dot)
        availabilityMap[normalizedDate] = ShiftAvailabilityStatus.available;
      }
    }

    return availabilityMap;
  }
}
