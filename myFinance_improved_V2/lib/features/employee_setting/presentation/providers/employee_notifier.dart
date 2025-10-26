import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/employee_salary.dart';
import '../../domain/repositories/employee_repository.dart';
import '../../domain/value_objects/salary_update_request.dart';
import 'states/employee_state.dart';

/// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
/// 🎯 Employee Notifier - 상태 관리 + 비즈니스 로직 조율
/// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
///
/// Flutter 표준 구조: Notifier가 직접 Repository 호출
/// Controller 레이어 없이 Domain Layer와 직접 통신
class EmployeeNotifier extends StateNotifier<EmployeeState> {
  final EmployeeRepository _repository;

  EmployeeNotifier({
    required EmployeeRepository repository,
  })  : _repository = repository,
        super(const EmployeeState());

  /// 직원 급여 목록 로드 (직접 Repository 호출)
  Future<void> loadEmployees({
    required String companyId,
  }) async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      // ✅ Flutter 표준: Repository 직접 호출
      final employees = await _repository.getEmployeeSalaries(companyId);

      state = state.copyWith(
        isLoading: false,
        employees: employees,
        errorMessage: null,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString(),
      );
    }
  }

  /// 직원 급여 업데이트 (직접 Repository 호출)
  Future<bool> updateEmployeeSalary({
    required String salaryId,
    required double salaryAmount,
    required String salaryType,
    required String currencyId,
    String? changeReason,
  }) async {
    state = state.copyWith(isUpdatingSalary: true, errorMessage: null);

    try {
      // ✅ Flutter 표준: Repository 직접 호출
      final request = SalaryUpdateRequest(
        salaryId: salaryId,
        salaryAmount: salaryAmount,
        salaryType: salaryType,
        currencyId: currencyId,
        changeReason: changeReason,
      );

      await _repository.updateSalary(request);

      state = state.copyWith(isUpdatingSalary: false);

      // 자동 새로고침
      // Note: companyId는 filteredEmployees에서 가져올 수 있음
      if (state.employees.isNotEmpty) {
        final companyId = state.employees.first.companyId;
        await loadEmployees(companyId: companyId);
      }

      return true;
    } catch (e) {
      state = state.copyWith(
        isUpdatingSalary: false,
        errorMessage: e.toString(),
      );
      return false;
    }
  }

  /// 직원 검색 (직접 Repository 호출)
  Future<void> searchEmployees({
    required String companyId,
    String? searchQuery,
    String? storeId,
  }) async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      // ✅ Flutter 표준: Repository 직접 호출
      final employees = await _repository.searchEmployees(
        companyId: companyId,
        searchQuery: searchQuery,
        storeId: storeId,
      );

      state = state.copyWith(
        isLoading: false,
        employees: employees,
        searchQuery: searchQuery ?? '',
        errorMessage: null,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString(),
      );
    }
  }

  /// 검색 쿼리 업데이트
  void updateSearchQuery(String query) {
    state = state.copyWith(searchQuery: query);
  }

  /// Role 필터 업데이트
  void updateRoleFilter(String? roleFilter) {
    state = state.copyWith(selectedRoleFilter: roleFilter);
  }

  /// Department 필터 업데이트
  void updateDepartmentFilter(String? departmentFilter) {
    state = state.copyWith(selectedDepartmentFilter: departmentFilter);
  }

  /// Salary Type 필터 업데이트
  void updateSalaryTypeFilter(String? salaryTypeFilter) {
    state = state.copyWith(selectedSalaryTypeFilter: salaryTypeFilter);
  }

  /// 모든 필터 초기화
  void clearAllFilters() {
    state = state.copyWith(
      selectedRoleFilter: null,
      selectedDepartmentFilter: null,
      selectedSalaryTypeFilter: null,
      searchQuery: '',
    );
  }

  /// Sort Option 업데이트
  void updateSortOption(String sortOption) {
    state = state.copyWith(sortOption: sortOption);
  }

  /// Sort Direction 토글
  void toggleSortDirection() {
    state = state.copyWith(sortAscending: !state.sortAscending);
  }

  /// 선택된 직원 설정
  void selectEmployee(EmployeeSalary? employee) {
    state = state.copyWith(selectedEmployee: employee);
  }

  /// 에러 메시지 지우기
  void clearError() {
    state = state.copyWith(errorMessage: null);
  }

  /// 상태 초기화
  void reset() {
    state = const EmployeeState();
  }
}
