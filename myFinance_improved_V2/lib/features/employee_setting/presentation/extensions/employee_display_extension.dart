/// Presentation Extension: Employee Display
///
/// UI-specific display helpers for EmployeeSalary entity.
/// These methods handle default values and formatting for the presentation layer.
library;

import '../../domain/entities/employee_salary.dart';

/// Extension for EmployeeSalary presentation concerns
///
/// Separates UI-specific display logic from pure domain entity.
/// This follows Clean Architecture by keeping UI concerns in Presentation layer.
extension EmployeeDisplayExtension on EmployeeSalary {
  /// Display-friendly department name with fallback
  String get displayDepartment => department ?? 'General';

  /// Display-friendly work location with fallback
  String get displayWorkLocation => workLocation ?? 'Office';

  /// Display-friendly employment type with fallback
  String get displayEmploymentType => employmentType ?? 'Full-time';

  /// Display-friendly employment status with fallback
  String get displayEmploymentStatus => employmentStatus ?? 'Active';

  /// Display-friendly manager name with fallback
  String get displayManagerName => managerName ?? 'Not assigned';

  /// Display-friendly cost center with fallback
  String get displayCostCenter => costCenter ?? 'Default';

  /// Display-friendly performance rating with fallback
  String get displayPerformanceRating => performanceRating ?? 'Not rated';

  /// Formatted salary amount for display
  String formatSalary({bool includeSymbol = true}) {
    String formatted;
    if (salaryAmount >= 1000000) {
      formatted = '${(salaryAmount / 1000000).toStringAsFixed(1)}M';
    } else if (salaryAmount >= 1000) {
      formatted = '${(salaryAmount / 1000).toStringAsFixed(1)}K';
    } else {
      formatted = salaryAmount.toStringAsFixed(0);
    }

    return includeSymbol ? '$symbol$formatted' : formatted;
  }

  /// Salary type display text
  String get salaryTypeDisplay => salaryType == 'hourly' ? '/hour' : '/month';

  /// Full salary display text
  String get fullSalaryDisplay => '${formatSalary()} $salaryTypeDisplay';
}
