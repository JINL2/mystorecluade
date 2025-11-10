/// Use Case Providers for employee_setting
///
/// Provides dependency injection for use cases.
/// Following the same pattern as transaction_template.
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/repositories/repository_providers.dart';
import '../../domain/usecases/update_employee_salary_usecase.dart';

/// Update employee salary use case provider
///
/// Provides the use case for updating employee salary.
/// This is injected into the Notifier.
final updateEmployeeSalaryUseCaseProvider = Provider<UpdateEmployeeSalaryUseCase>((ref) {
  return UpdateEmployeeSalaryUseCase(
    repository: ref.read(employeeRepositoryProvider),
  );
});
