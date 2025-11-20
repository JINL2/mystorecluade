/// Use Case: Update Employee Salary
///
/// Handles salary update business logic including validation and orchestration.
/// This is the only complex operation that warrants a UseCase.
/// Simple CRUD operations (load, search) remain in the Notifier.
library;
import '../repositories/employee_repository.dart';
import '../value_objects/salary_update_request.dart';

/// Command for updating employee salary
class UpdateEmployeeSalaryCommand {
  final String salaryId;
  final double salaryAmount;
  final String salaryType;
  final String currencyId;
  final String? changeReason;

  const UpdateEmployeeSalaryCommand({
    required this.salaryId,
    required this.salaryAmount,
    required this.salaryType,
    required this.currencyId,
    this.changeReason,
  });
}

/// Result of salary update operation
class UpdateEmployeeSalaryResult {
  final bool isSuccess;
  final String? errorMessage;

  const UpdateEmployeeSalaryResult._({
    required this.isSuccess,
    this.errorMessage,
  });

  factory UpdateEmployeeSalaryResult.success() {
    return const UpdateEmployeeSalaryResult._(isSuccess: true);
  }

  factory UpdateEmployeeSalaryResult.failure(String errorMessage) {
    return UpdateEmployeeSalaryResult._(
      isSuccess: false,
      errorMessage: errorMessage,
    );
  }
}

/// Use case for updating employee salary
///
/// This UseCase handles:
/// - Basic validation
/// - Request creation
/// - Repository orchestration
class UpdateEmployeeSalaryUseCase {
  final EmployeeRepository _repository;

  const UpdateEmployeeSalaryUseCase({
    required EmployeeRepository repository,
  }) : _repository = repository;

  /// Execute the salary update use case
  Future<UpdateEmployeeSalaryResult> execute(
    UpdateEmployeeSalaryCommand command,
  ) async {
    try {
      // Basic validation
      if (command.salaryAmount < 0) {
        return UpdateEmployeeSalaryResult.failure(
          'Salary amount cannot be negative',
        );
      }

      if (command.salaryId.isEmpty) {
        return UpdateEmployeeSalaryResult.failure(
          'Salary ID is required',
        );
      }

      // Create request
      final request = SalaryUpdateRequest(
        salaryId: command.salaryId,
        salaryAmount: command.salaryAmount,
        salaryType: command.salaryType,
        currencyId: command.currencyId,
        changeReason: command.changeReason ?? 'Salary updated',
      );

      // Execute update
      await _repository.updateSalary(request);

      return UpdateEmployeeSalaryResult.success();
    } catch (e) {
      return UpdateEmployeeSalaryResult.failure(e.toString());
    }
  }
}
