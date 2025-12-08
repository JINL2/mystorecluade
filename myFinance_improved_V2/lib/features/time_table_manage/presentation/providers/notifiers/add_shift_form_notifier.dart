import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/utils/datetime_utils.dart';
import '../../../domain/usecases/get_schedule_data.dart';
import '../../../domain/usecases/insert_schedule.dart';
import '../states/add_shift_form_state.dart';

/// Add Shift Form Notifier
///
/// Manages the business logic for the Add Shift form.
/// Uses UseCases for Clean Architecture compliance.
class AddShiftFormNotifier extends StateNotifier<AddShiftFormState> {
  final GetScheduleData _getScheduleDataUseCase;
  final InsertSchedule _insertScheduleUseCase;
  final String _storeId;
  final String _timezone;

  AddShiftFormNotifier(
    this._getScheduleDataUseCase,
    this._insertScheduleUseCase,
    this._storeId,
    this._timezone,
  ) : super(const AddShiftFormState()) {
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
      // Use UseCase instead of Repository directly
      final scheduleData = await _getScheduleDataUseCase.call(
        GetScheduleDataParams(
          storeId: _storeId,
          timezone: _timezone,
        ),
      );

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

      state = state.copyWith(
        employees: employees,
        shifts: shifts,
        isLoadingData: false,
      );
    } catch (e) {
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
      // Get the selected shift's start and end times
      final selectedShift = state.shifts.firstWhere(
        (shift) => shift['shift_id'] == state.selectedShiftId,
      );

      final startTime = selectedShift['start_time'] as String;
      final endTime = selectedShift['end_time'] as String;

      // Format selected date as "YYYY-MM-DD"
      final selectedDate = state.selectedDate!;
      final dateStr = '${selectedDate.year}-${selectedDate.month.toString().padLeft(2, '0')}-${selectedDate.day.toString().padLeft(2, '0')}';

      // Combine date and time: "YYYY-MM-DD HH:mm"
      final startTimeStr = '$dateStr $startTime';
      final endTimeStr = '$dateStr $endTime';

      // Use UseCase instead of Repository directly
      await _insertScheduleUseCase.call(
        InsertScheduleParams(
          userId: state.selectedEmployeeId!,
          shiftId: state.selectedShiftId!,
          storeId: _storeId,
          startTime: startTimeStr,
          endTime: endTimeStr,
          approvedBy: approvedBy,
          timezone: _timezone,
        ),
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
