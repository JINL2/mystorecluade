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

  // Track ongoing requests to prevent duplicate submissions
  final Set<String> _pendingRequests = {};

  ShiftRequestsActions({
    required this.ref,
    required this.selectedDate,
    required this.monthlyShiftStatus,
    required this.shiftMetadata,
    required this.onStatusUpdate,
  });

  /// Handle apply to shift
  Future<void> handleApply(ShiftMetadata shift) async {
    print('🔵 [handleApply] START - shiftId: ${shift.shiftId}, shiftName: ${shift.shiftName}');

    final appState = ref.read(appStateProvider);
    final userId = appState.userId;
    final storeId = appState.storeChoosen;

    print('🔵 [handleApply] userId: $userId, storeId: $storeId');

    if (userId.isEmpty || storeId.isEmpty) {
      print('❌ [handleApply] ABORT - userId or storeId is empty');
      return;
    }

    // Create unique key for this request
    final dateString = DateTimeUtils.toDateOnly(selectedDate);
    final requestKey = '$userId-$storeId-${shift.shiftId}-$dateString';

    // Check if request is already in progress
    if (_pendingRequests.contains(requestKey)) {
      print('⚠️ [handleApply] Request already in progress - ignoring duplicate click');
      return;
    }

    // Mark request as pending
    _pendingRequests.add(requestKey);
    print('🔵 [handleApply] Request marked as pending: $requestKey');

    // Check if user already applied to this shift (prevent duplicate)
    print('🔵 [handleApply] Checking duplicate for date: $dateString');
    print('🔵 [handleApply] monthlyShiftStatus count: ${monthlyShiftStatus?.length ?? 0}');

    if (monthlyShiftStatus != null) {
      for (var day in monthlyShiftStatus!) {
        if (day.requestDate == dateString) {
          print('🔵 [handleApply] Found matching date: ${day.requestDate}, shifts: ${day.shifts.length}');
          for (var s in day.shifts) {
            if (s.shiftId == shift.shiftId) {
              print('🔵 [handleApply] Found matching shift: ${s.shiftName}');
              print('🔵 [handleApply] Pending employees: ${s.pendingEmployees.length}');
              print('🔵 [handleApply] Approved employees: ${s.approvedEmployees.length}');

              // Print all pending employee IDs for debugging
              for (var emp in s.pendingEmployees) {
                print('🔵 [handleApply] Pending employee: ${emp.userId} (current: $userId)');
                print('🔵 [handleApply] Match: ${emp.userId == userId}');
              }

              for (var emp in s.approvedEmployees) {
                print('🔵 [handleApply] Approved employee: ${emp.userId} (current: $userId)');
                print('🔵 [handleApply] Match: ${emp.userId == userId}');
              }

              final alreadyApplied = s.pendingEmployees.any((e) => e.userId == userId) ||
                                     s.approvedEmployees.any((e) => e.userId == userId);

              print('🔵 [handleApply] alreadyApplied: $alreadyApplied');

              if (alreadyApplied) {
                print('⚠️ [handleApply] User already applied to this shift - skipping API call');
                return;
              }
            }
          }
        }
      }
    }

    print('🔵 [handleApply] No duplicate found - proceeding with API call');

    // Get user's device timezone
    final timezone = DateTimeUtils.getLocalTimezone();

    // Build start time: selectedDate + shift.startTime (HH:mm format)
    // shift.startTime comes from RPC already in user's local time
    final startTimeParts = shift.startTime.split(':');
    final startDateTime = DateTime(
      selectedDate.year,
      selectedDate.month,
      selectedDate.day,
      int.parse(startTimeParts[0]),
      int.parse(startTimeParts[1]),
    );
    final startTime = DateTimeUtils.toLocalWithOffset(startDateTime);

    // Build end time: selectedDate + shift.endTime (HH:mm format)
    // shift.endTime comes from RPC already in user's local time
    final endTimeParts = shift.endTime.split(':');
    final endDateTime = DateTime(
      selectedDate.year,
      selectedDate.month,
      selectedDate.day,
      int.parse(endTimeParts[0]),
      int.parse(endTimeParts[1]),
    );
    final endTime = DateTimeUtils.toLocalWithOffset(endDateTime);

    // Current time for p_time parameter
    final now = DateTime.now();
    final time = DateTimeUtils.toLocalWithOffset(now);

    print('🔵 [handleApply] Calling API with timezone: $timezone');

    try {
      final registerShiftRequest = ref.read(registerShiftRequestProvider);
      await registerShiftRequest(
        userId: userId,
        shiftId: shift.shiftId,
        storeId: storeId,
        startTime: startTime,
        endTime: endTime,
        time: time,
        timezone: timezone,
      );

      print('✅ [handleApply] API call SUCCESS - updating local state');

      // Update local state instead of RPC refresh
      _addCurrentUserToPending(shift.shiftId);

      print('✅ [handleApply] Local state updated - COMPLETE');
    } catch (e) {
      print('❌ [handleApply] ERROR: $e');

      // Show error message to user
      // TODO: Replace with proper error handling UI (SnackBar, Dialog, etc.)
      // For now, just log the error - user will see button remains unchanged

      // Optionally: Re-fetch data from backend to sync local state
      // await _fetchLatestShiftStatus();
    } finally {
      // Remove from pending requests
      _pendingRequests.remove(requestKey);
      print('🔵 [handleApply] Request removed from pending: $requestKey');
    }
  }

  /// Handle join waitlist
  Future<void> handleWaitlist(ShiftMetadata shift) async {
    print('🔵 [handleWaitlist] START - shiftId: ${shift.shiftId}, shiftName: ${shift.shiftName}');

    final appState = ref.read(appStateProvider);
    final userId = appState.userId;
    final storeId = appState.storeChoosen;

    print('🔵 [handleWaitlist] userId: $userId, storeId: $storeId');

    if (userId.isEmpty || storeId.isEmpty) {
      print('❌ [handleWaitlist] ABORT - userId or storeId is empty');
      return;
    }

    // Check if user already applied to this shift (prevent duplicate)
    final dateString = DateTimeUtils.toDateOnly(selectedDate);
    final existingDay = monthlyShiftStatus?.firstWhere(
      (day) => day.requestDate == dateString,
      orElse: () => const MonthlyShiftStatus(requestDate: '', shifts: []),
    );

    if (existingDay != null && existingDay.requestDate.isNotEmpty) {
      final existingShift = existingDay.shifts.firstWhere(
        (s) => s.shiftId == shift.shiftId,
        orElse: () => const DailyShift(shiftId: ''),
      );

      if (existingShift.shiftId.isNotEmpty) {
        // Check if user is already in pending or approved
        final alreadyApplied = existingShift.pendingEmployees.any((e) => e.userId == userId) ||
                               existingShift.approvedEmployees.any((e) => e.userId == userId);

        if (alreadyApplied) {
          print('⚠️ [handleWaitlist] User already applied to this shift - skipping API call');
          return;
        }
      }
    }

    // Get user's device timezone
    final timezone = DateTimeUtils.getLocalTimezone();

    // Build start time: selectedDate + shift.startTime (HH:mm format)
    // shift.startTime comes from RPC already in user's local time
    final startTimeParts = shift.startTime.split(':');
    final startDateTime = DateTime(
      selectedDate.year,
      selectedDate.month,
      selectedDate.day,
      int.parse(startTimeParts[0]),
      int.parse(startTimeParts[1]),
    );
    final startTime = DateTimeUtils.toLocalWithOffset(startDateTime);

    // Build end time: selectedDate + shift.endTime (HH:mm format)
    // shift.endTime comes from RPC already in user's local time
    final endTimeParts = shift.endTime.split(':');
    final endDateTime = DateTime(
      selectedDate.year,
      selectedDate.month,
      selectedDate.day,
      int.parse(endTimeParts[0]),
      int.parse(endTimeParts[1]),
    );
    final endTime = DateTimeUtils.toLocalWithOffset(endDateTime);

    // Current time for p_time parameter
    final now = DateTime.now();
    final time = DateTimeUtils.toLocalWithOffset(now);

    try {
      final registerShiftRequest = ref.read(registerShiftRequestProvider);
      await registerShiftRequest(
        userId: userId,
        shiftId: shift.shiftId,
        storeId: storeId,
        startTime: startTime,
        endTime: endTime,
        time: time,
        timezone: timezone,
      );

      // Update local state instead of RPC refresh
      _addCurrentUserToPending(shift.shiftId);
    } catch (_) {
      // Error joining waitlist
    }
  }

  /// Handle leave waitlist
  void handleLeaveWaitlist(ShiftMetadata shift) {
    // Use same logic as withdraw since it's the same RPC
    handleWithdraw(shift);
  }

  /// Handle withdraw from shift
  Future<void> handleWithdraw(ShiftMetadata shift) async {
    final appState = ref.read(appStateProvider);
    final userId = appState.userId;

    if (userId.isEmpty) {
      return;
    }

    // Use user's device current time with selected date
    final now = DateTime.now();
    final requestDateTime = DateTime(
      selectedDate.year,
      selectedDate.month,
      selectedDate.day,
      now.hour,
      now.minute,
      now.second,
    );
    final requestTime = DateTimeUtils.toLocalWithOffset(requestDateTime);
    final timezone = DateTimeUtils.getLocalTimezone();

    try {
      final deleteShiftRequest = ref.read(deleteShiftRequestProvider);
      await deleteShiftRequest(
        userId: userId,
        shiftId: shift.shiftId,
        requestTime: requestTime,
        timezone: timezone,
      );

      // Update local state instead of RPC refresh
      _removeCurrentUserFromPending(shift.shiftId);
    } catch (_) {
      // Error withdrawing from shift
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
    print('🟢 [_addCurrentUserToPending] START - shiftId: $shiftId');

    var status = monthlyShiftStatus ?? [];
    print('🟢 [_addCurrentUserToPending] Current status count: ${status.length}');

    final appState = ref.read(appStateProvider);
    final userId = appState.userId;
    final userDisplayData = ref.read(userDisplayDataProvider);
    final userName = '${userDisplayData['user_first_name'] ?? ''} ${userDisplayData['user_last_name'] ?? ''}'.trim();
    final profileImage = userDisplayData['profile_image'] as String? ?? '';

    print('🟢 [_addCurrentUserToPending] userId: $userId, userName: $userName');

    // Create new EmployeeStatus for current user
    final currentUserEmployee = EmployeeStatus(
      userId: userId,
      userName: userName.isEmpty ? 'You' : userName,
      profileImage: profileImage.isNotEmpty ? profileImage : null,
    );

    // Find the date string for selected date
    final dateString = DateTimeUtils.toDateOnly(selectedDate);
    print('🟢 [_addCurrentUserToPending] Looking for date: $dateString');

    // Find shift metadata for this shift
    final shiftMeta = shiftMetadata?.firstWhere(
      (s) => s.shiftId == shiftId,
      orElse: () => shiftMetadata!.first,
    );
    print('🟢 [_addCurrentUserToPending] Found shift meta: ${shiftMeta?.shiftName}');

    // Check if date already exists in status
    final existingDayIndex = status.indexWhere(
      (s) => s.requestDate == dateString,
    );

    print('🟢 [_addCurrentUserToPending] existingDayIndex: $existingDayIndex');

    if (existingDayIndex >= 0) {
      // Date exists - check if shift exists
      final dayStatus = status[existingDayIndex];
      final existingShiftIndex = dayStatus.shifts.indexWhere(
        (s) => s.shiftId == shiftId,
      );

      print('🟢 [_addCurrentUserToPending] Date exists - existingShiftIndex: $existingShiftIndex');

      List<DailyShift> updatedShifts;

      if (existingShiftIndex >= 0) {
        // Shift exists - add user to pending
        print('🟢 [_addCurrentUserToPending] Shift exists - adding user to pending');
        updatedShifts = dayStatus.shifts.map((dailyShift) {
          if (dailyShift.shiftId == shiftId) {
            final updatedPendingEmployees = [...dailyShift.pendingEmployees, currentUserEmployee];
            print('🟢 [_addCurrentUserToPending] Updated pending employees count: ${updatedPendingEmployees.length}');
            return dailyShift.copyWith(
              pendingEmployees: updatedPendingEmployees,
              pendingCount: dailyShift.pendingCount + 1,
            );
          }
          return dailyShift;
        }).toList();
      } else {
        // Shift doesn't exist in this date - create new DailyShift
        print('🟢 [_addCurrentUserToPending] Shift does not exist - creating new DailyShift');
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

      print('🟢 [_addCurrentUserToPending] Calling onStatusUpdate() - path: date exists');
      onStatusUpdate(updatedStatus);
      print('✅ [_addCurrentUserToPending] COMPLETE - onStatusUpdate called');
    } else {
      // Date doesn't exist - create new MonthlyShiftStatus
      print('🟢 [_addCurrentUserToPending] Date does not exist - creating new MonthlyShiftStatus');
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

      print('🟢 [_addCurrentUserToPending] Calling onStatusUpdate() - path: new date');
      onStatusUpdate([...status, newDayStatus]);
      print('✅ [_addCurrentUserToPending] COMPLETE - onStatusUpdate called');
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
