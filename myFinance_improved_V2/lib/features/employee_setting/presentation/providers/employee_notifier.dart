import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/repositories/repository_providers.dart';
import '../../domain/entities/employee_salary.dart';
import '../../domain/usecases/update_employee_salary_usecase.dart';
import 'states/employee_state.dart';
import 'use_case_providers.dart';

part 'employee_notifier.g.dart';

/// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
/// 🎯 Employee Notifier - 상태 관리 + UseCase 조율
/// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
///
/// Hybrid 구조:
/// - 단순 CRUD: Repository 직접 호출 (loadEmployees, searchEmployees)
/// - 복잡한 로직: UseCase 호출 (updateEmployeeSalary)
@riverpod
class EmployeeNotifier extends _$EmployeeNotifier {
  @override
  EmployeeState build() {
    return const EmployeeState();
  }

  /// 직원 급여 목록 로드 (직접 Repository 호출)
  Future<void> loadEmployees({
    required String companyId,
  }) async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      final repository = ref.read(employeeRepositoryProvider);
      final employees = await repository.getEmployeeSalaries(companyId);

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

  /// 직원 급여 업데이트 (UseCase 호출)
  Future<bool> updateEmployeeSalary({
    required String salaryId,
    required double salaryAmount,
    required String salaryType,
    required String currencyId,
    String? changeReason,
  }) async {
    state = state.copyWith(isUpdatingSalary: true, errorMessage: null);

    try {
      final updateSalaryUseCase = ref.read(updateEmployeeSalaryUseCaseProvider);

      final command = UpdateEmployeeSalaryCommand(
        salaryId: salaryId,
        salaryAmount: salaryAmount,
        salaryType: salaryType,
        currencyId: currencyId,
        changeReason: changeReason,
      );

      final result = await updateSalaryUseCase.execute(command);

      if (result.isSuccess) {
        state = state.copyWith(isUpdatingSalary: false);

        // 자동 새로고침
        if (state.employees.isNotEmpty) {
          final companyId = state.employees.first.companyId;
          await loadEmployees(companyId: companyId);
        }

        return true;
      } else {
        state = state.copyWith(
          isUpdatingSalary: false,
          errorMessage: result.errorMessage ?? 'Failed to update salary',
        );
        return false;
      }
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
      final repository = ref.read(employeeRepositoryProvider);
      final employees = await repository.searchEmployees(
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
