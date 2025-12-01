import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../app/providers/app_state_provider.dart';
import '../../../../../../app/providers/auth_providers.dart';
import '../../../../../../core/utils/datetime_utils.dart';
import '../../../../domain/entities/monthly_shift_status.dart';
import '../../../../domain/entities/shift_metadata.dart';
import '../../../providers/attendance_providers.dart';

/// Controller for shift register tab state and business logic
class ShiftRegisterController {
  final WidgetRef ref;
  final void Function(VoidCallback) setState;

  ShiftRegisterController({
    required this.ref,
    required this.setState,
  });

  // State variables
  DateTime selectedDate = DateTime.now();
  DateTime focusedMonth = DateTime.now();
  String? selectedStoreId;
  List<ShiftMetadata>? shiftMetadata;
  bool isLoadingMetadata = false;
  List<MonthlyShiftStatus>? monthlyShiftStatus;
  bool isLoadingShiftStatus = false;

  // Selection state
  String? selectedShift;
  String? selectionMode;

  /// Fetch shift metadata from Supabase RPC
  Future<void> fetchShiftMetadata(String storeId) async {
    if (storeId.isEmpty) return;

    setState(() {
      isLoadingMetadata = true;
    });

    try {
      final getShiftMetadata = ref.read(getShiftMetadataProvider);
      final timezone = DateTimeUtils.getLocalTimezone();
      final response = await getShiftMetadata(
        storeId: storeId,
        timezone: timezone,
      );

      setState(() {
        shiftMetadata = response;
        isLoadingMetadata = false;
      });
    } catch (_) {
      setState(() {
        isLoadingMetadata = false;
        shiftMetadata = [];
      });
    }
  }

  /// Fetch monthly shift status from Supabase RPC
  Future<void> fetchMonthlyShiftStatus() async {
    if (selectedStoreId == null || selectedStoreId!.isEmpty) return;

    setState(() {
      isLoadingShiftStatus = true;
    });

    try {
      final requestTime = '${focusedMonth.year}-${focusedMonth.month.toString().padLeft(2, '0')}-01 00:00:00';
      final getMonthlyShiftStatus = ref.read(getMonthlyShiftStatusProvider);
      final appState = ref.read(appStateProvider);
      final companyId = appState.companyChoosen;
      final timezone = DateTimeUtils.getLocalTimezone();

      final response = await getMonthlyShiftStatus(
        storeId: selectedStoreId!,
        companyId: companyId,
        requestTime: requestTime,
        timezone: timezone,
      );

      setState(() {
        monthlyShiftStatus = response;
        isLoadingShiftStatus = false;
      });
    } catch (e) {
      setState(() {
        isLoadingShiftStatus = false;
        monthlyShiftStatus = [];
      });
    }
  }

  /// Initialize controller with app state
  void initialize() {
    final appState = ref.read(appStateProvider);
    selectedStoreId = appState.storeChoosen.isNotEmpty ? appState.storeChoosen : null;

    if (selectedStoreId != null) {
      fetchShiftMetadata(selectedStoreId!);
      fetchMonthlyShiftStatus();
    }
  }

  /// Reset selections when date or context changes
  void resetSelections() {
    setState(() {
      selectedShift = null;
      selectionMode = null;
    });
  }

  /// Handle shift card click
  void handleShiftClick(String shiftId, bool isRegistered) {
    setState(() {
      if (selectedShift == shiftId) {
        selectedShift = null;
        selectionMode = null;
      } else {
        selectedShift = shiftId;
        selectionMode = isRegistered ? 'registered' : 'unregistered';
      }
    });
  }

  /// Change selected date
  void selectDate(DateTime date) {
    setState(() {
      selectedDate = date;
    });
    resetSelections();
  }

  /// Navigate to previous date
  void goToPreviousDate() {
    setState(() {
      selectedDate = selectedDate.subtract(const Duration(days: 1));
    });
    resetSelections();
  }

  /// Navigate to next date
  void goToNextDate() {
    setState(() {
      selectedDate = selectedDate.add(const Duration(days: 1));
    });
    resetSelections();
  }

  /// Change focused month
  Future<void> changeFocusedMonth(int monthDelta) async {
    setState(() {
      focusedMonth = DateTime(
        focusedMonth.year,
        focusedMonth.month + monthDelta,
      );
    });
    resetSelections();
    await fetchMonthlyShiftStatus();
  }

  /// Update selected store
  Future<void> updateSelectedStore(String storeId, String? storeName) async {
    setState(() {
      selectedStoreId = storeId;
    });
    resetSelections();

    ref.read(appStateProvider.notifier).selectStore(storeId, storeName: storeName);
    await fetchShiftMetadata(storeId);
    await fetchMonthlyShiftStatus();
  }

  /// Get all active store shifts as Entity list
  /// ✅ Clean Architecture: Returns Entity instead of Map
  List<ShiftMetadata> getActiveShifts() {
    if (shiftMetadata == null || shiftMetadata!.isEmpty) {
      return [];
    }

    return shiftMetadata!.where((shift) => shift.isActive).toList();
  }

  /// Find shift metadata by ID
  /// ✅ Clean Architecture: Returns Entity instead of Map
  ShiftMetadata? findShiftById(String shiftId) {
    final activeShifts = getActiveShifts();
    for (final shift in activeShifts) {
      if (shift.shiftId == shiftId) return shift;
    }
    return null;
  }

  /// Optimistically update local shift status after registration
  void updateLocalShiftStatusOptimistically({
    required String shiftId,
    required String userId,
    required String userName,
    required String profileImage,
    required String requestDate,
  }) {
    if (monthlyShiftStatus == null) return;

    // Find existing day or create new one
    final existingDayIndex = monthlyShiftStatus!.indexWhere(
      (day) => day.requestDate == requestDate,
    );

    if (existingDayIndex != -1) {
      // Update existing day
      final existingDay = monthlyShiftStatus![existingDayIndex];
      final updatedDay = _addEmployeeToDay(
        existingDay,
        shiftId,
        userId,
        userName,
        profileImage,
      );

      setState(() {
        monthlyShiftStatus![existingDayIndex] = updatedDay;
      });
    } else {
      // Create new day
      final newDay = _createNewDay(
        requestDate,
        shiftId,
        userId,
        userName,
        profileImage,
      );

      setState(() {
        monthlyShiftStatus = [...monthlyShiftStatus!, newDay];
      });
    }
  }

  MonthlyShiftStatus _addEmployeeToDay(
    MonthlyShiftStatus day,
    String shiftId,
    String userId,
    String userName,
    String profileImage,
  ) {
    final newEmployee = EmployeeStatus(
      userId: userId,
      userName: userName,
      profileImage: profileImage,
      isApproved: false,
    );

    // Find shift in day
    final shiftIndex = day.shifts.indexWhere((s) => s.shiftId == shiftId);

    if (shiftIndex != -1) {
      // Update existing shift
      final existingShift = day.shifts[shiftIndex];

      // Check if user already registered
      final alreadyRegistered = existingShift.pendingEmployees.any((e) => e.userId == userId) ||
          existingShift.approvedEmployees.any((e) => e.userId == userId);

      if (alreadyRegistered) return day;

      final updatedShift = existingShift.copyWith(
        pendingEmployees: [...existingShift.pendingEmployees, newEmployee],
      );

      final updatedShifts = List<DailyShift>.from(day.shifts);
      updatedShifts[shiftIndex] = updatedShift;

      return day.copyWith(
        shifts: updatedShifts,
        totalPending: day.totalPending + 1,
      );
    } else {
      // Create new shift - use Entity instead of Map
      final shiftMeta = findShiftById(shiftId);
      final newShift = DailyShift(
        shiftId: shiftId,
        shiftName: shiftMeta?.shiftName ?? 'Unknown',
        startTime: shiftMeta?.startTime ?? '00:00:00',
        endTime: shiftMeta?.endTime ?? '00:00:00',
        pendingEmployees: [newEmployee],
        approvedEmployees: [],
      );

      return day.copyWith(
        shifts: [...day.shifts, newShift],
        totalPending: day.totalPending + 1,
      );
    }
  }

  MonthlyShiftStatus _createNewDay(
    String requestDate,
    String shiftId,
    String userId,
    String userName,
    String profileImage,
  ) {
    final newEmployee = EmployeeStatus(
      userId: userId,
      userName: userName,
      profileImage: profileImage,
      isApproved: false,
    );

    // ✅ Clean Architecture: Use Entity instead of Map
    final shiftMeta = findShiftById(shiftId);
    final newShift = DailyShift(
      shiftId: shiftId,
      shiftName: shiftMeta?.shiftName ?? 'Unknown',
      startTime: shiftMeta?.startTime ?? '00:00:00',
      endTime: shiftMeta?.endTime ?? '00:00:00',
      pendingEmployees: [newEmployee],
      approvedEmployees: [],
    );

    return MonthlyShiftStatus(
      requestDate: requestDate,
      totalPending: 1,
      totalApproved: 0,
      shifts: [newShift],
    );
  }


  /// Optimistically remove user from local shift status
  void removeFromLocalShiftStatusOptimistically({
    required String shiftId,
    required String userId,
    required String requestDate,
  }) {
    if (monthlyShiftStatus == null) return;

    final dayIndex = monthlyShiftStatus!.indexWhere(
      (day) => day.requestDate == requestDate,
    );

    if (dayIndex == -1) return;

    final day = monthlyShiftStatus![dayIndex];
    final updatedDay = _removeEmployeeFromDay(day, shiftId, userId);

    setState(() {
      monthlyShiftStatus![dayIndex] = updatedDay;
    });
  }

  MonthlyShiftStatus _removeEmployeeFromDay(
    MonthlyShiftStatus day,
    String shiftId,
    String userId,
  ) {
    final shiftIndex = day.shifts.indexWhere((s) => s.shiftId == shiftId);
    if (shiftIndex == -1) return day;

    final shift = day.shifts[shiftIndex];

    final pendingBefore = shift.pendingEmployees.length;
    final approvedBefore = shift.approvedEmployees.length;

    final updatedPending = shift.pendingEmployees.where((e) => e.userId != userId).toList();
    final updatedApproved = shift.approvedEmployees.where((e) => e.userId != userId).toList();

    final pendingRemoved = pendingBefore - updatedPending.length;
    final approvedRemoved = approvedBefore - updatedApproved.length;

    final updatedShift = shift.copyWith(
      pendingEmployees: updatedPending,
      approvedEmployees: updatedApproved,
    );

    final updatedShifts = List<DailyShift>.from(day.shifts);
    updatedShifts[shiftIndex] = updatedShift;

    return day.copyWith(
      shifts: updatedShifts,
      totalPending: day.totalPending - pendingRemoved,
      totalApproved: day.totalApproved - approvedRemoved,
    );
  }

  /// Get user shift data for a specific date and shift
  Map<String, dynamic>? getUserShiftData(DateTime date) {
    if (selectedShift == null || monthlyShiftStatus == null) return null;

    final dateStr = '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';

    try {
      final day = monthlyShiftStatus!.firstWhere(
        (d) => d.requestDate == dateStr,
      );

      final shift = day.getShiftById(selectedShift!);
      if (shift == null) return null;

      final authStateAsync = ref.read(authStateProvider);
      final user = authStateAsync.value;
      if (user == null) return null;

      // Check pending employees
      for (final emp in shift.pendingEmployees) {
        if (emp.userId == user.id) {
          return {
            'shift_id': shift.shiftId,
            'shift_request_id': emp.shiftRequestId,
            'is_approved': false,
            'shift_type': shift.shiftName ?? shift.shiftType,
          };
        }
      }

      // Check approved employees
      for (final emp in shift.approvedEmployees) {
        if (emp.userId == user.id) {
          return {
            'shift_id': shift.shiftId,
            'shift_request_id': emp.shiftRequestId,
            'is_approved': true,
            'shift_type': shift.shiftName ?? shift.shiftType,
          };
        }
      }
    } catch (e) {
      return null;
    }

    return null;
  }
}
