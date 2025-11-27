import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/utils/datetime_utils.dart';
import '../../../domain/repositories/time_table_repository.dart';
import '../states/add_shift_form_state.dart';

/// Add Shift Form Notifier
///
/// Manages the business logic for the Add Shift form
class AddShiftFormNotifier extends StateNotifier<AddShiftFormState> {
  final TimeTableRepository _repository;
  final String _storeId;
  final String _timezone;

  AddShiftFormNotifier(this._repository, this._storeId, this._timezone)
      : super(const AddShiftFormState()) {
    // Load data on initialization
    loadScheduleData();
  }

  /// Load employees and shifts for the selected store
  Future<void> loadScheduleData() async {
    if (_storeId.isEmpty) {
      state = state.copyWith(
        error: 'Please select a store first',
        isLoadingData: false,
      );
      return;
    }

    state = state.copyWith(isLoadingData: true, error: null);

    try {
      print('🔄 AddShiftForm: Loading schedule data for storeId: $_storeId, timezone: $_timezone');

      final scheduleData = await _repository.getScheduleData(
        storeId: _storeId,
        timezone: _timezone,
      );

      print('📦 AddShiftForm: Got ${scheduleData.employees.length} employees, ${scheduleData.shifts.length} shifts');

      final employees = scheduleData.employees
          .map((emp) => {
                'user_id': emp.userId,
                'user_name': emp.userName,
                'profile_image': emp.profileImage,
              },)
          .toList();

      final shifts = scheduleData.shifts
          .map((shift) => {
                'shift_id': shift.shiftId,
                'shift_name': shift.shiftName ?? 'Shift',
                'required_employees': shift.targetCount,
                'start_time': DateTimeUtils.formatTimeOnly(shift.planStartTime),
                'end_time': DateTimeUtils.formatTimeOnly(shift.planEndTime),
              },)
          .toList();

      print('✅ AddShiftForm: Mapped ${employees.length} employees, ${shifts.length} shifts');

      state = state.copyWith(
        employees: employees,
        shifts: shifts,
        isLoadingData: false,
      );
    } catch (e, stackTrace) {
      print('❌ AddShiftForm: Error loading schedule data: $e');
      print('❌ AddShiftForm: Stack trace: $stackTrace');
      state = state.copyWith(
        error: 'Error: ${e.toString()}',
        isLoadingData: false,
      );
    }
  }

  /// Select an employee
  void selectEmployee(String? employeeId) {
    state = state.copyWith(selectedEmployeeId: employeeId);
  }

  /// Select a shift
  void selectShift(String? shiftId) {
    state = state.copyWith(selectedShiftId: shiftId);
  }

  /// Select a date
  void selectDate(DateTime? date) {
    state = state.copyWith(selectedDate: date);
  }

  /// Save the shift assignment
  Future<bool> saveShift({
    required String approvedBy,
  }) async {
    if (!state.isFormValid) {
      state = state.copyWith(error: 'Please fill all required fields');
      return false;
    }

    state = state.copyWith(isSaving: true, error: null);

    try {
      // v3 RPC uses p_request_date (DATE type) - just send yyyy-MM-dd format
      // RPC internally combines this date with store_shifts UTC times
      final selectedDate = state.selectedDate!;
      final requestDate = DateTimeUtils.toDateOnly(selectedDate);

      await _repository.insertSchedule(
        userId: state.selectedEmployeeId!,
        shiftId: state.selectedShiftId!,
        storeId: _storeId,
        requestDate: requestDate,
        approvedBy: approvedBy,
      );

      state = state.copyWith(isSaving: false);
      return true;
    } catch (e) {
      state = state.copyWith(
        isSaving: false,
        error: e.toString(),
      );
      return false;
    }
  }

  /// Reset form to initial state
  void reset() {
    state = const AddShiftFormState();
    loadScheduleData();
  }
}
