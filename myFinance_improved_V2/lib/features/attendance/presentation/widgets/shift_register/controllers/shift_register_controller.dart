import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../app/providers/app_state_provider.dart';
import '../../../../../../app/providers/auth_providers.dart';
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
      final response = await getShiftMetadata(
        storeId: storeId,
        timezone: 'Asia/Seoul', // TODO: Get from user settings
      );

      setState(() {
        shiftMetadata = response;
        isLoadingMetadata = false;
      });
    } catch (e) {
      print('❌ Error fetching shift metadata: $e');
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

      final response = await getMonthlyShiftStatus(
        storeId: selectedStoreId!,
        companyId: companyId,
        requestTime: requestDate,
        timezone: 'Asia/Seoul', // TODO: Get from user settings
      });

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
      resetSelections();
    });
  }

  /// Navigate to previous date
  void goToPreviousDate() {
    setState(() {
      selectedDate = selectedDate.subtract(const Duration(days: 1));
      resetSelections();
    });
  }

  /// Navigate to next date
  void goToNextDate() {
    setState(() {
      selectedDate = selectedDate.add(const Duration(days: 1));
      resetSelections();
    });
  }

  /// Change focused month
  Future<void> changeFocusedMonth(int monthDelta) async {
    setState(() {
      focusedMonth = DateTime(
        focusedMonth.year,
        focusedMonth.month + monthDelta,
      );
      resetSelections();
    });
    await fetchMonthlyShiftStatus();
  }

  /// Update selected store
  Future<void> updateSelectedStore(String storeId, String? storeName) async {
    setState(() {
      selectedStoreId = storeId;
      resetSelections();
    });

    ref.read(appStateProvider.notifier).selectStore(storeId, storeName: storeName);
    await fetchShiftMetadata(storeId);
    await fetchMonthlyShiftStatus();
  }

  /// Get all active store shifts
  List<Map<String, dynamic>> getAllStoreShifts() {
    if (shiftMetadata == null || shiftMetadata!.isEmpty) {
      return [];
    }

    return shiftMetadata!
        .where((shift) => shift.isActive)
        .map((shift) => shift.toJson())
        .toList();
  }

  /// Optimistically update local shift status after registration
  void updateLocalShiftStatusOptimistically({
    required String shiftId,
    required String userId,
    required String userName,
    required String profileImage,
    required String requestDate,
  }) {
    monthlyShiftStatus ??= [];

    final newEmployee = {
      'user_id': userId,
      'user_name': userName,
      'profile_image': profileImage,
      'is_approved': false,
      'shift_request_id': null,
    };

    Map<String, dynamic>? existingDayData;
    int existingIndex = -1;

    for (int i = 0; i < monthlyShiftStatus!.length; i++) {
      if (monthlyShiftStatus![i].requestDate == requestDate) {
        existingDayData = monthlyShiftStatus![i].toJson();
        existingIndex = i;
        break;
      }
    }

    if (existingDayData != null && existingIndex != -1) {
      _updateExistingDayData(existingDayData, shiftId, newEmployee, userId);
    } else {
      _createNewDayData(requestDate, shiftId, newEmployee);
    }

    setState(() {
      monthlyShiftStatus = List<MonthlyShiftStatus>.from(monthlyShiftStatus!);
    });
  }

  void _updateExistingDayData(
    Map<String, dynamic> dayData,
    String shiftId,
    Map<String, dynamic> newEmployee,
    String userId,
  ) {
    var shifts = dayData['shifts'] as List<dynamic>? ?? [];
    bool shiftFound = false;

    for (var shift in shifts) {
      if (shift['shift_id'].toString() == shiftId) {
        shiftFound = true;
        var pendingEmployees = shift['pending_employees'] as List<dynamic>? ?? [];
        var approvedEmployees = shift['approved_employees'] as List<dynamic>? ?? [];

        bool alreadyRegistered = pendingEmployees.any((emp) => emp['user_id'] == userId) ||
            approvedEmployees.any((emp) => emp['user_id'] == userId);

        if (!alreadyRegistered) {
          pendingEmployees.add(newEmployee);
          shift['pending_employees'] = pendingEmployees;
          dayData['total_pending'] = (dayData['total_pending'] ?? 0) + 1;
        }
        break;
      }
    }

    if (!shiftFound) {
      _addNewShiftToDay(shifts, shiftId, newEmployee, dayData);
    }
  }

  void _addNewShiftToDay(
    List<dynamic> shifts,
    String shiftId,
    Map<String, dynamic> newEmployee,
    Map<String, dynamic> dayData,
  ) {
    final allStoreShifts = getAllStoreShifts();
    Map<String, dynamic>? shiftMetadata;

    for (final storeShift in allStoreShifts) {
      final storeShiftId = (storeShift['shift_id'] ?? storeShift['id'] ?? storeShift['store_shift_id'])?.toString();
      if (storeShiftId == shiftId) {
        shiftMetadata = storeShift;
        break;
      }
    }

    final newShift = {
      'shift_id': shiftId,
      'shift_name': shiftMetadata?['shift_name'] ?? shiftMetadata?['name'] ?? 'Unknown Shift',
      'start_time': shiftMetadata?['start_time'] ?? '00:00:00',
      'end_time': shiftMetadata?['end_time'] ?? '00:00:00',
      'pending_employees': [newEmployee],
      'approved_employees': [],
    };
    shifts.add(newShift);
    dayData['total_pending'] = (dayData['total_pending'] ?? 0) + 1;
  }

  void _createNewDayData(String requestDate, String shiftId, Map<String, dynamic> newEmployee) {
    final allStoreShifts = getAllStoreShifts();
    Map<String, dynamic>? shiftMetadata;

    for (final storeShift in allStoreShifts) {
      final storeShiftId = (storeShift['shift_id'] ?? storeShift['id'] ?? storeShift['store_shift_id'])?.toString();
      if (storeShiftId == shiftId) {
        shiftMetadata = storeShift;
        break;
      }
    }

    final newDayData = {
      'request_date': requestDate,
      'total_pending': 1,
      'total_approved': 0,
      'shifts': [
        {
          'shift_id': shiftId,
          'shift_name': shiftMetadata?['shift_name'] ?? shiftMetadata?['name'] ?? 'Unknown Shift',
          'start_time': shiftMetadata?['start_time'] ?? '00:00:00',
          'end_time': shiftMetadata?['end_time'] ?? '00:00:00',
          'pending_employees': [newEmployee],
          'approved_employees': [],
        }
      ],
    };
    monthlyShiftStatus!.add(MonthlyShiftStatus.fromJson(newDayData));
  }

  /// Optimistically remove user from local shift status
  void removeFromLocalShiftStatusOptimistically({
    required String shiftId,
    required String userId,
    required String requestDate,
  }) {
    if (monthlyShiftStatus == null || monthlyShiftStatus!.isEmpty) return;

    for (int dayIndex = 0; dayIndex < monthlyShiftStatus!.length; dayIndex++) {
      if (monthlyShiftStatus![dayIndex]['request_date'] == requestDate) {
        final dayData = monthlyShiftStatus![dayIndex];
        final shifts = dayData['shifts'] as List<dynamic>?;

        bool removedFromPending = false;
        bool removedFromApproved = false;

        if (shifts != null) {
          for (var shift in shifts) {
            if (shift['shift_id'].toString() == shiftId) {
              var pendingEmployees = shift['pending_employees'] as List<dynamic>? ?? [];
              int pendingCountBefore = pendingEmployees.length;
              pendingEmployees.removeWhere((emp) => emp['user_id'] == userId);
              shift['pending_employees'] = pendingEmployees;
              if (pendingCountBefore > pendingEmployees.length) {
                removedFromPending = true;
              }

              var approvedEmployees = shift['approved_employees'] as List<dynamic>? ?? [];
              int approvedCountBefore = approvedEmployees.length;
              approvedEmployees.removeWhere((emp) => emp['user_id'] == userId);
              shift['approved_employees'] = approvedEmployees;
              if (approvedCountBefore > approvedEmployees.length) {
                removedFromApproved = true;
              }

              break;
            }
          }
        }

        if (removedFromPending) {
          dayData['total_pending'] = (dayData['total_pending'] ?? 1) - 1;
        }
        if (removedFromApproved) {
          dayData['total_approved'] = (dayData['total_approved'] ?? 1) - 1;
        }

        break;
      }
    }

    setState(() {
      monthlyShiftStatus = List<MonthlyShiftStatus>.from(monthlyShiftStatus!);
    });
  }

  /// Get user shift data for a specific date and shift
  Map<String, dynamic>? getUserShiftData(DateTime date) {
    if (selectedShift == null) return null;

    final dateStr = '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
    final dayData = monthlyShiftStatus?.firstWhere(
      (day) => day.requestDate == dateStr,
      orElse: () => MonthlyShiftStatus({}),
    );

    if (dayData == null || dayData.toJson().isEmpty) return null;

    final authStateAsync = ref.read(authStateProvider);
    final user = authStateAsync.value;
    if (user == null) return null;

    final shifts = dayData['shifts'] as List? ?? [];

    for (final shift in shifts) {
      final shiftId = shift['shift_id']?.toString() ?? '';
      if (shiftId != selectedShift) continue;

      // Check pending employees
      final pendingEmployees = shift['pending_employees'] as List? ?? [];
      for (final emp in pendingEmployees) {
        if (emp['user_id'] == user.id) {
          return {
            'shift_id': shiftId,
            'shift_request_id': emp['shift_request_id'],
            'is_approved': false,
            'shift_type': shift['shift_name'] ?? shift['shift_type'],
          };
        }
      }

      // Check approved employees
      final approvedEmployees = shift['approved_employees'] as List? ?? [];
      for (final emp in approvedEmployees) {
        if (emp['user_id'] == user.id) {
          return {
            'shift_id': shiftId,
            'shift_request_id': emp['shift_request_id'],
            'is_approved': true,
            'shift_type': shift['shift_name'] ?? shift['shift_type'],
          };
        }
      }

      break;
    }

    return null;
  }
}
