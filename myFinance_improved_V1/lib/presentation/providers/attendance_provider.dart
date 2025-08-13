import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/services/attendance_service.dart';
import 'auth_provider.dart';
import 'app_state_provider.dart';

// Service provider
final attendanceServiceProvider = Provider<AttendanceService>((ref) {
  return AttendanceService();
});

// Shift overview data model
class ShiftOverview {
  final String requestMonth;
  final int actualWorkDays;
  final double actualWorkHours;
  final String estimatedSalary;
  final String currencySymbol;
  final double salaryAmount;
  final String salaryType;
  final int lateDeductionTotal;
  final int overtimeTotal;
  final bool isLoading;
  final String? error;

  ShiftOverview({
    required this.requestMonth,
    required this.actualWorkDays,
    required this.actualWorkHours,
    required this.estimatedSalary,
    required this.currencySymbol,
    required this.salaryAmount,
    required this.salaryType,
    required this.lateDeductionTotal,
    required this.overtimeTotal,
    this.isLoading = false,
    this.error,
  });

  factory ShiftOverview.fromJson(Map<String, dynamic> json) {
    return ShiftOverview(
      requestMonth: json['request_month'] ?? '',
      actualWorkDays: json['actual_work_days'] ?? 0,
      actualWorkHours: (json['actual_work_hours'] ?? 0).toDouble(),
      estimatedSalary: json['estimated_salary'] ?? '0',
      currencySymbol: json['currency_symbol'] ?? '₩',
      salaryAmount: (json['salary_amount'] ?? 0).toDouble(),
      salaryType: json['salary_type'] ?? 'hourly',
      lateDeductionTotal: json['late_deduction_total'] ?? 0,
      overtimeTotal: json['overtime_total'] ?? 0,
    );
  }

  factory ShiftOverview.empty() {
    return ShiftOverview(
      requestMonth: '',
      actualWorkDays: 0,
      actualWorkHours: 0,
      estimatedSalary: '0',
      currencySymbol: '₩',
      salaryAmount: 0,
      salaryType: 'hourly',
      lateDeductionTotal: 0,
      overtimeTotal: 0,
    );
  }

  factory ShiftOverview.loading() {
    return ShiftOverview(
      requestMonth: '',
      actualWorkDays: 0,
      actualWorkHours: 0,
      estimatedSalary: '0',
      currencySymbol: '₩',
      salaryAmount: 0,
      salaryType: 'hourly',
      lateDeductionTotal: 0,
      overtimeTotal: 0,
      isLoading: true,
    );
  }

  ShiftOverview copyWith({
    String? requestMonth,
    int? actualWorkDays,
    double? actualWorkHours,
    String? estimatedSalary,
    String? currencySymbol,
    double? salaryAmount,
    String? salaryType,
    int? lateDeductionTotal,
    int? overtimeTotal,
    bool? isLoading,
    String? error,
  }) {
    return ShiftOverview(
      requestMonth: requestMonth ?? this.requestMonth,
      actualWorkDays: actualWorkDays ?? this.actualWorkDays,
      actualWorkHours: actualWorkHours ?? this.actualWorkHours,
      estimatedSalary: estimatedSalary ?? this.estimatedSalary,
      currencySymbol: currencySymbol ?? this.currencySymbol,
      salaryAmount: salaryAmount ?? this.salaryAmount,
      salaryType: salaryType ?? this.salaryType,
      lateDeductionTotal: lateDeductionTotal ?? this.lateDeductionTotal,
      overtimeTotal: overtimeTotal ?? this.overtimeTotal,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}

// Provider for shift overview
final shiftOverviewProvider = StateNotifierProvider<ShiftOverviewNotifier, ShiftOverview>((ref) {
  // Watch app state changes to refresh when company/store changes
  ref.watch(appStateProvider);
  return ShiftOverviewNotifier(ref);
});

class ShiftOverviewNotifier extends StateNotifier<ShiftOverview> {
  final Ref ref;

  ShiftOverviewNotifier(this.ref) : super(ShiftOverview.empty()) {
    // Fetch data when provider is created or when company/store changes
    // Check if we have company and store selected before fetching
    final appState = ref.read(appStateProvider);
    if (appState.companyChoosen.isNotEmpty && appState.storeChoosen.isNotEmpty) {
      fetchShiftOverview();
    }
  }

  Future<void> fetchShiftOverview() async {
    state = ShiftOverview.loading();

    try {
      final service = ref.read(attendanceServiceProvider);
      final authState = ref.read(authStateProvider);
      final appState = ref.read(appStateProvider);
      
      // Get user ID from auth state
      final userId = authState?.id;
      if (userId == null) {
        state = state.copyWith(
          isLoading: false,
          error: 'User not logged in',
        );
        return;
      }

      // Get company and store from app state
      final companyId = appState.companyChoosen;
      final storeId = appState.storeChoosen;
      
      print('AttendanceProvider: companyId = $companyId, storeId = $storeId');

      if (companyId.isEmpty || storeId.isEmpty) {
        print('AttendanceProvider: No company or store selected');
        state = state.copyWith(
          isLoading: false,
          error: 'Please select a company and store',
        );
        return;
      }

      // IMPORTANT: RPC functions require the LAST day of the month as p_request_date
      final now = DateTime.now();
      // Calculate the last day of the current month
      final lastDayOfMonth = DateTime(now.year, now.month + 1, 0);
      final requestDate = '${lastDayOfMonth.year}-${lastDayOfMonth.month.toString().padLeft(2, '0')}-${lastDayOfMonth.day.toString().padLeft(2, '0')}';

      print('AttendanceProvider: Calling getUserShiftOverview with:');
      print('  requestDate: $requestDate (last day of month for ${now.year}-${now.month.toString().padLeft(2, '0')})');
      print('  userId: $userId');
      print('  companyId: $companyId');
      print('  storeId: $storeId');
      
      final response = await service.getUserShiftOverview(
        requestDate: requestDate,
        userId: userId,
        companyId: companyId,
        storeId: storeId,
      );
      
      print('AttendanceProvider: Response received: $response');

      state = ShiftOverview.fromJson(response);
    } catch (e) {
      print('AttendanceProvider: Error - $e');
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  void refresh() {
    fetchShiftOverview();
  }
}

// Provider for current shift status
final currentShiftProvider = FutureProvider<Map<String, dynamic>?>((ref) async {
  final service = ref.read(attendanceServiceProvider);
  final authState = ref.read(authStateProvider);
  final appState = ref.read(appStateProvider);
  
  final userId = authState?.id;
  final storeId = appState.storeChoosen;
  
  if (userId == null || storeId.isEmpty) {
    return null;
  }

  return await service.getCurrentShift(
    userId: userId,
    storeId: storeId,
  );
});

// Provider for checking if user is currently working
final isWorkingProvider = Provider<bool>((ref) {
  final currentShift = ref.watch(currentShiftProvider);
  
  return currentShift.when(
    data: (shift) {
      if (shift == null) return false;
      // Check if user has checked in but not checked out
      return shift['actual_start_time'] != null && shift['actual_end_time'] == null;
    },
    loading: () => false,
    error: (_, __) => false,
  );
});