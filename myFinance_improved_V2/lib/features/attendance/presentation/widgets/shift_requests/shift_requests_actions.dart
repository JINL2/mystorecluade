import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../app/providers/app_state_provider.dart';
import '../../../../../core/utils/datetime_utils.dart';
import '../../../../../shared/widgets/toss/toss_selection_bottom_sheet.dart';
import '../../../domain/entities/monthly_shift_status.dart';
import '../../../domain/entities/shift_metadata.dart';
import '../../providers/attendance_providers.dart';

/// Callback type for updating monthly shift status
typedef UpdateMonthlyShiftStatusCallback = void Function(List<MonthlyShiftStatus> status);

/// Action handlers for shift requests
class ShiftRequestsActions {
  final WidgetRef ref;
  final DateTime selectedDate;
  final List<MonthlyShiftStatus>? monthlyShiftStatus;
  final List<ShiftMetadata>? shiftMetadata;
  final UpdateMonthlyShiftStatusCallback onStatusUpdate;

  ShiftRequestsActions({
    required this.ref,
    required this.selectedDate,
    required this.monthlyShiftStatus,
    required this.shiftMetadata,
    required this.onStatusUpdate,
  });

  /// Handle apply to shift
  Future<void> handleApply(ShiftMetadata shift) async {
    final appState = ref.read(appStateProvider);
    final userId = appState.userId;
    final storeId = appState.storeChoosen;

    if (userId.isEmpty || storeId.isEmpty) return;

    final timezone = DateTimeUtils.getLocalTimezone();

    // Build start time: selectedDate + shift.startTime (HH:mm format)
    final startTimeParts = shift.startTime.split(':');
    final startDateTime = DateTime(
      selectedDate.year,
      selectedDate.month,
      selectedDate.day,
      int.parse(startTimeParts[0]),
      int.parse(startTimeParts[1]),
    );
    final startTime = DateTimeUtils.formatLocalTimestamp(startDateTime);

    // Build end time: selectedDate + shift.endTime (HH:mm format)
    final endTimeParts = shift.endTime.split(':');
    final endDateTime = DateTime(
      selectedDate.year,
      selectedDate.month,
      selectedDate.day,
      int.parse(endTimeParts[0]),
      int.parse(endTimeParts[1]),
    );
    final endTime = DateTimeUtils.formatLocalTimestamp(endDateTime);

    try {
      final registerShiftRequest = ref.read(registerShiftRequestProvider);
      await registerShiftRequest(
        userId: userId,
        shiftId: shift.shiftId,
        storeId: storeId,
        startTime: startTime,
        endTime: endTime,
        timezone: timezone,
      );

      _addCurrentUserToPending(shift.shiftId);
    } catch (e) {
      rethrow;
    }
  }

  /// Handle join waitlist
  Future<void> handleWaitlist(ShiftMetadata shift) async {
    final appState = ref.read(appStateProvider);
    final userId = appState.userId;
    final storeId = appState.storeChoosen;

    if (userId.isEmpty || storeId.isEmpty) return;

    final timezone = DateTimeUtils.getLocalTimezone();

    // Build start time: selectedDate + shift.startTime (HH:mm format)
    final startTimeParts = shift.startTime.split(':');
    final startDateTime = DateTime(
      selectedDate.year,
      selectedDate.month,
      selectedDate.day,
      int.parse(startTimeParts[0]),
      int.parse(startTimeParts[1]),
    );
    final startTime = DateTimeUtils.formatLocalTimestamp(startDateTime);

    // Build end time: selectedDate + shift.endTime (HH:mm format)
    final endTimeParts = shift.endTime.split(':');
    final endDateTime = DateTime(
      selectedDate.year,
      selectedDate.month,
      selectedDate.day,
      int.parse(endTimeParts[0]),
      int.parse(endTimeParts[1]),
    );
    final endTime = DateTimeUtils.formatLocalTimestamp(endDateTime);

    try {
      final registerShiftRequest = ref.read(registerShiftRequestProvider);
      await registerShiftRequest(
        userId: userId,
        shiftId: shift.shiftId,
        storeId: storeId,
        startTime: startTime,
        endTime: endTime,
        timezone: timezone,
      );

      _addCurrentUserToPending(shift.shiftId);
    } catch (e) {
      rethrow;
    }
  }

  /// Handle leave waitlist
  Future<void> handleLeaveWaitlist(ShiftMetadata shift) async {
    await handleWithdraw(shift);
  }

  /// Handle withdraw from shift
  Future<void> handleWithdraw(ShiftMetadata shift) async {
    final appState = ref.read(appStateProvider);
    final userId = appState.userId;

    if (userId.isEmpty) return;

    final timezone = DateTimeUtils.getLocalTimezone();

    // Build start time: selectedDate + shift.startTime (HH:mm format)
    final startTimeParts = shift.startTime.split(':');
    final startDateTime = DateTime(
      selectedDate.year,
      selectedDate.month,
      selectedDate.day,
      int.parse(startTimeParts[0]),
      int.parse(startTimeParts[1]),
    );
    final startTime = DateTimeUtils.formatLocalTimestamp(startDateTime);

    // Build end time: selectedDate + shift.endTime (HH:mm format)
    final endTimeParts = shift.endTime.split(':');
    final endDateTime = DateTime(
      selectedDate.year,
      selectedDate.month,
      selectedDate.day,
      int.parse(endTimeParts[0]),
      int.parse(endTimeParts[1]),
    );
    final endTime = DateTimeUtils.formatLocalTimestamp(endDateTime);

    try {
      final deleteShiftRequest = ref.read(deleteShiftRequestProvider);
      await deleteShiftRequest(
        userId: userId,
        shiftId: shift.shiftId,
        startTime: startTime,
        endTime: endTime,
        timezone: timezone,
      );

      _removeCurrentUserFromPending(shift.shiftId);
    } catch (e) {
      rethrow;
    }
  }

  /// Handle shift card tap
  void handleShiftTap(ShiftMetadata shift) {
    // TODO: Navigate to shift detail page
  }

  /// Show applied users bottom sheet
  void handleViewAppliedUsers(BuildContext context, ShiftMetadata shift, DailyShift? dailyShift) {
    final approvedEmployees = dailyShift?.approvedEmployees ?? [];
    final pendingEmployees = dailyShift?.pendingEmployees ?? [];

    // Combine approved and pending employees with status subtitle
    final items = <TossSelectionItem>[
      ...approvedEmployees.map((employee) {
        return TossSelectionItem.fromGeneric(
          id: employee.userId,
          title: employee.userName,
          subtitle: 'Assigned',
          avatarUrl: (employee.profileImage?.isNotEmpty ?? false) ? employee.profileImage : null,
        );
      }),
      ...pendingEmployees.map((employee) {
        return TossSelectionItem.fromGeneric(
          id: employee.userId,
          title: employee.userName,
          subtitle: 'Applied',
          avatarUrl: (employee.profileImage?.isNotEmpty ?? false) ? employee.profileImage : null,
        );
      }),
    ];

    TossSelectionBottomSheet.show<void>(
      context: context,
      title: 'Applied Users',
      items: items,
      showSubtitle: true,
      subtitlePosition: 'right',
      borderBottomWidth: 0,
      onItemSelected: (item) {
        // Optional: Navigate to user profile or show more details
      },
    );
  }

  /// Helper: Add current user to pending employees in local state
  void _addCurrentUserToPending(String shiftId) {
    var status = monthlyShiftStatus ?? [];

    final appState = ref.read(appStateProvider);
    final userId = appState.userId;
    final userDisplayData = ref.read(userDisplayDataProvider);
    final userName = '${userDisplayData['user_first_name'] ?? ''} ${userDisplayData['user_last_name'] ?? ''}'.trim();
    final profileImage = userDisplayData['profile_image'] as String? ?? '';

    // Create new EmployeeStatus for current user
    final currentUserEmployee = EmployeeStatus(
      userId: userId,
      userName: userName.isEmpty ? 'You' : userName,
      profileImage: profileImage.isNotEmpty ? profileImage : null,
    );

    // Find the date string for selected date
    final dateString = DateTimeUtils.toDateOnly(selectedDate);

    // Find shift metadata for this shift
    final shiftMeta = shiftMetadata?.firstWhere(
      (s) => s.shiftId == shiftId,
      orElse: () => shiftMetadata!.first,
    );

    // Check if date already exists in status
    final existingDayIndex = status.indexWhere(
      (s) => s.requestDate == dateString,
    );

    if (existingDayIndex >= 0) {
      // Date exists - check if shift exists
      final dayStatus = status[existingDayIndex];
      final existingShiftIndex = dayStatus.shifts.indexWhere(
        (s) => s.shiftId == shiftId,
      );

      List<DailyShift> updatedShifts;

      if (existingShiftIndex >= 0) {
        // Shift exists - add user to pending
        updatedShifts = dayStatus.shifts.map((dailyShift) {
          if (dailyShift.shiftId == shiftId) {
            final updatedPendingEmployees = [...dailyShift.pendingEmployees, currentUserEmployee];
            return dailyShift.copyWith(
              pendingEmployees: updatedPendingEmployees,
              pendingCount: dailyShift.pendingCount + 1,
            );
          }
          return dailyShift;
        }).toList();
      } else {
        // Shift doesn't exist in this date - create new DailyShift
        updatedShifts = [
          ...dayStatus.shifts,
          DailyShift(
            shiftId: shiftId,
            shiftName: shiftMeta?.shiftName,
            requiredEmployees: shiftMeta?.numberShift ?? 1,
            pendingCount: 1,
            approvedCount: 0,
            pendingEmployees: [currentUserEmployee],
            approvedEmployees: [],
          ),
        ];
      }

      final updatedDayStatus = dayStatus.copyWith(
        shifts: updatedShifts,
        totalPending: dayStatus.totalPending + 1,
      );

      final updatedStatus = [...status];
      updatedStatus[existingDayIndex] = updatedDayStatus;

      onStatusUpdate(updatedStatus);
    } else {
      // Date doesn't exist - create new MonthlyShiftStatus
      final newDayStatus = MonthlyShiftStatus(
        requestDate: dateString,
        totalPending: 1,
        totalApproved: 0,
        shifts: [
          DailyShift(
            shiftId: shiftId,
            shiftName: shiftMeta?.shiftName,
            requiredEmployees: shiftMeta?.numberShift ?? 1,
            pendingCount: 1,
            approvedCount: 0,
            pendingEmployees: [currentUserEmployee],
            approvedEmployees: [],
          ),
        ],
      );

      onStatusUpdate([...status, newDayStatus]);
    }
  }

  /// Helper: Remove current user from pending employees in local state
  /// Note: Approved/Assigned users cannot withdraw - only pending users can
  void _removeCurrentUserFromPending(String shiftId) {
    if (monthlyShiftStatus == null) return;

    final appState = ref.read(appStateProvider);
    final userId = appState.userId;

    // Find the date string for selected date
    final dateString = DateTimeUtils.toDateOnly(selectedDate);

    // Update monthlyShiftStatus
    final updatedStatus = monthlyShiftStatus!.map((dayStatus) {
      if (dayStatus.requestDate == dateString) {
        int totalPendingRemoved = 0;

        // Update the specific shift
        final updatedShifts = dayStatus.shifts.map((dailyShift) {
          if (dailyShift.shiftId == shiftId) {
            // Remove user from pending employees only
            // Approved/Assigned users cannot withdraw
            final updatedPendingEmployees = dailyShift.pendingEmployees
                .where((e) => e.userId != userId)
                .toList();
            final pendingRemovedCount = dailyShift.pendingEmployees.length - updatedPendingEmployees.length;
            totalPendingRemoved += pendingRemovedCount;

            return dailyShift.copyWith(
              pendingEmployees: updatedPendingEmployees,
              pendingCount: dailyShift.pendingCount - pendingRemovedCount,
            );
          }
          return dailyShift;
        }).toList();

        return dayStatus.copyWith(
          shifts: updatedShifts,
          totalPending: dayStatus.totalPending - totalPendingRemoved,
        );
      }
      return dayStatus;
    }).toList();

    onStatusUpdate(updatedStatus);
  }
}
