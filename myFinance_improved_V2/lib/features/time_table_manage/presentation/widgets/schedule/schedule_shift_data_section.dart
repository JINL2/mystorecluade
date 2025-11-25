import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/utils/datetime_utils.dart';
import '../../../../../shared/themes/toss_border_radius.dart';
import '../../../../../shared/themes/toss_colors.dart';
import '../../../../../shared/themes/toss_spacing.dart';
import '../../../../../shared/themes/toss_text_styles.dart';
import '../../../domain/entities/daily_shift_data.dart';
import '../../../domain/entities/shift_metadata.dart';
import '../../providers/time_table_providers.dart';
import 'schedule_shift_card.dart';

/// Schedule Shift Data Section
///
/// Displays shift schedule with assigned employees for a specific date.
/// Shows all store shifts from metadata and their assigned employees.
class ScheduleShiftDataSection extends ConsumerWidget {
  final DateTime selectedDate;
  final String? selectedStoreId;
  final ShiftMetadata? shiftMetadata;
  final bool isLoadingMetadata;

  const ScheduleShiftDataSection({
    super.key,
    required this.selectedDate,
    required this.selectedStoreId,
    required this.shiftMetadata,
    required this.isLoadingMetadata,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Get selected shift requests from provider
    final selectedShiftState = ref.watch(selectedShiftRequestsProvider);
    final selectedShiftRequests = selectedShiftState.selectedIds;

    // Get employee shifts for this date
    final employeeShifts = _getEmployeeShiftsForDate(ref);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: TossSpacing.space5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Show ALL store shifts (from metadata) regardless of employee assignments
          if (shiftMetadata?.hasShifts == true) ...[
            Text(
              'Shift Schedule',
              style: TossTextStyles.bodyLarge.copyWith(
                color: TossColors.gray900,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: TossSpacing.space2),
            ...(shiftMetadata?.activeShifts ?? []).map((shift) {
              final shiftId = shift.shiftId;
              final shiftName = shift.shiftName;

              // Get times from shift metadata
              final startTime = _formatShiftTime(shift.startTime);
              final endTime = _formatShiftTime(shift.endTime);

              // Get assigned employees for this shift
              final assignedEmployees = _getAssignedEmployeesForShift(
                shiftId,
                shiftName,
                employeeShifts,
              );

              // Use ScheduleShiftCard widget
              return ScheduleShiftCard(
                shiftId: shiftId,
                shiftName: shiftName,
                startTime: startTime,
                endTime: endTime,
                assignedEmployees: assignedEmployees,
                selectedShiftRequests: selectedShiftRequests,
                onEmployeeTap: (shiftRequestId, isApproved, actualRequestId) {
                  ref.read(selectedShiftRequestsProvider.notifier).toggleSelection(
                        shiftRequestId,
                        isApproved,
                        actualRequestId,
                      );
                },
              );
            }),
          ] else if (!isLoadingMetadata) ...[
            Container(
              padding: const EdgeInsets.all(TossSpacing.space4),
              decoration: BoxDecoration(
                color: TossColors.gray50,
                borderRadius: BorderRadius.circular(TossBorderRadius.md),
              ),
              child: Center(
                child: Column(
                  children: [
                    const Icon(
                      Icons.info_outline,
                      size: 24,
                      color: TossColors.gray400,
                    ),
                    const SizedBox(height: TossSpacing.space2),
                    Text(
                      'No shift data available',
                      style: TossTextStyles.body.copyWith(
                        color: TossColors.gray500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  /// Get shifts with requests for a specific date using Provider
  List<ShiftWithRequests> _getEmployeeShiftsForDate(WidgetRef ref) {
    if (selectedStoreId == null || selectedStoreId!.isEmpty) {
      return [];
    }

    final dateStr = '${selectedDate.year}-${selectedDate.month.toString().padLeft(2, '0')}-${selectedDate.day.toString().padLeft(2, '0')}';

    final monthlyStatuses = ref.read(monthlyShiftStatusProvider(selectedStoreId!)).allMonthlyStatuses;

    for (var monthlyStatus in monthlyStatuses) {
      final dailyData = monthlyStatus.findByDate(dateStr);
      if (dailyData != null) {
        return dailyData.shifts;
      }
    }

    return [];
  }

  /// Format UTC time string to local time (HH:mm format)
  ///
  /// The database stores times in UTC format. This method converts them
  /// to the user's local timezone for display.
  String _formatShiftTime(String? utcTime) {
    if (utcTime == null || utcTime.isEmpty || utcTime == '--:--') {
      return '--:--';
    }

    try {
      // 1. Full ISO 8601 format with timezone (e.g., "2024-01-01T09:00:00Z")
      if (utcTime.contains('T') || utcTime.contains('Z')) {
        final localTime = DateTimeUtils.toLocal(utcTime);
        final formattedTime = DateTimeUtils.formatTimeOnly(localTime);
        return formattedTime;
      }

      // 2. Time-only format (e.g., "09:00:00", "09:00")
      // Remove any timezone info and normalize format
      final cleanTime = utcTime.split('+')[0].split('Z')[0].trim();

      // Create a dummy UTC datetime for today with this time
      final now = DateTime.now().toUtc();
      final dateStr = DateTimeUtils.toDateOnly(now);

      // Build full UTC datetime string
      final fullUtcString = '${dateStr}T${cleanTime}Z';

      // Convert to local and extract time only
      final localTime = DateTimeUtils.toLocal(fullUtcString);
      final formattedTime = DateTimeUtils.formatTimeOnly(localTime);

      return formattedTime;
    } catch (e) {
      // Try one more fallback: parse as HH:mm format
      try {
        final parts = utcTime.split(':');
        if (parts.length >= 2) {
          final hour = int.parse(parts[0]);
          final minute = int.parse(parts[1]);

          // Create UTC datetime and convert to local
          final now = DateTime.now().toUtc();
          final utcDateTime = DateTime.utc(now.year, now.month, now.day, hour, minute);
          final localDateTime = utcDateTime.toLocal();
          final formattedTime = DateTimeUtils.formatTimeOnly(localDateTime);

          return formattedTime;
        }
      } catch (e2) {
        // Silently handle fallback failure
      }

      // Final fallback: return original
      return utcTime;
    }
  }

  /// Get assigned employees for a specific shift
  List<Map<String, dynamic>> _getAssignedEmployeesForShift(
    String shiftId,
    String shiftName,
    List<ShiftWithRequests> employeeShifts,
  ) {
    final List<Map<String, dynamic>> assignedEmployees = [];

    if (employeeShifts.isEmpty) return assignedEmployees;

    for (var shiftWithReqs in employeeShifts) {
      if (shiftWithReqs.shift.shiftId == shiftId ||
          shiftWithReqs.shift.shiftName == shiftName) {
        // Add pending employees
        for (var request in shiftWithReqs.pendingRequests) {
          assignedEmployees.add({
            'user_name': request.employee.userName,
            'is_approved': false,
            'shift_request_id': request.shiftRequestId,
            'profile_image': request.employee.profileImage,
          });
        }

        // Add approved employees
        for (var request in shiftWithReqs.approvedRequests) {
          assignedEmployees.add({
            'user_name': request.employee.userName,
            'is_approved': true,
            'shift_request_id': request.shiftRequestId,
            'profile_image': request.employee.profileImage,
          });
        }
        break;
      }
    }

    return assignedEmployees;
  }
}
