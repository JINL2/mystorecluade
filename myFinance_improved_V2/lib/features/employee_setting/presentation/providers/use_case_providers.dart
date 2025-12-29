/// Use Case Providers for employee_setting
///
/// Provides dependency injection for use cases.
/// Following the same pattern as transaction_template.
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/repositories/repository_providers.dart';
import '../../domain/usecases/search_and_sort_employees_usecase.dart';
import '../../domain/usecases/update_employee_salary_usecase.dart';

part 'use_case_providers.g.dart';

/// Update employee salary use case provider
///
/// Provides the use case for updating employee salary.
/// This is injected into the Notifier.
@riverpod
UpdateEmployeeSalaryUseCase updateEmployeeSalaryUseCase(Ref ref) {
  return UpdateEmployeeSalaryUseCase(
    repository: ref.read(employeeRepositoryProvider),
  );
}

/// Search and sort employees use case provider
///
/// Provides the use case for searching and sorting employees.
/// This encapsulates filtering and sorting business logic.
@riverpod
SearchAndSortEmployeesUseCase searchAndSortEmployeesUseCase(Ref ref) {
  return SearchAndSortEmployeesUseCase();
}
