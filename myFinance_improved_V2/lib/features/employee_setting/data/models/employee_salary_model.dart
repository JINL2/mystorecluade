import 'package:myfinance_improved/core/utils/datetime_utils.dart';
import '../../domain/entities/employee_salary.dart';

/// Data Model: Employee Salary Model
///
/// DTO (Data Transfer Object) for EmployeeSalary with JSON serialization.
/// This model knows how to convert between JSON and Domain Entity.
class EmployeeSalaryModel extends EmployeeSalary {
  const EmployeeSalaryModel({
    super.salaryId,
    required super.userId,
    required super.fullName,
    required super.email,
    super.profileImage,
    required super.roleName,
    required super.companyId,
    super.storeId,
    required super.salaryAmount,
    required super.salaryType,
    required super.currencyId,
    required super.currencyName,
    required super.symbol,
    super.effectiveDate,
    required super.isActive,
    super.updatedAt,
    super.department,
    super.hireDate,
    super.employeeId,
    super.workLocation,
    super.performanceRating,
    super.employmentType,
    super.lastReviewDate,
    super.nextReviewDate,
    super.previousSalary,
    super.managerName,
    super.costCenter,
    super.employmentStatus,
    super.month,
    super.totalWorkingDay,
    super.totalWorkingHour,
    super.totalSalary,
    super.lastActivityAt,
    super.bankName,
    super.bankAccountNumber,
    // Edit tracking fields
    super.editedBy,
    super.editedByName,
    // Work Schedule Template fields
    super.workScheduleTemplateId,
    super.workScheduleTemplateName,
    super.workStartTime,
    super.workEndTime,
    super.workMonday,
    super.workTuesday,
    super.workWednesday,
    super.workThursday,
    super.workFriday,
    super.workSaturday,
    super.workSunday,
  });

  /// Create model from domain entity
  factory EmployeeSalaryModel.fromEntity(EmployeeSalary entity) {
    return EmployeeSalaryModel(
      salaryId: entity.salaryId,
      userId: entity.userId,
      fullName: entity.fullName,
      email: entity.email,
      profileImage: entity.profileImage,
      roleName: entity.roleName,
      companyId: entity.companyId,
      storeId: entity.storeId,
      salaryAmount: entity.salaryAmount,
      salaryType: entity.salaryType,
      currencyId: entity.currencyId,
      currencyName: entity.currencyName,
      symbol: entity.symbol,
      effectiveDate: entity.effectiveDate,
      isActive: entity.isActive,
      updatedAt: entity.updatedAt,
      department: entity.department,
      hireDate: entity.hireDate,
      employeeId: entity.employeeId,
      workLocation: entity.workLocation,
      performanceRating: entity.performanceRating,
      employmentType: entity.employmentType,
      lastReviewDate: entity.lastReviewDate,
      nextReviewDate: entity.nextReviewDate,
      previousSalary: entity.previousSalary,
      managerName: entity.managerName,
      costCenter: entity.costCenter,
      employmentStatus: entity.employmentStatus,
      month: entity.month,
      totalWorkingDay: entity.totalWorkingDay,
      totalWorkingHour: entity.totalWorkingHour,
      totalSalary: entity.totalSalary,
      lastActivityAt: entity.lastActivityAt,
      bankName: entity.bankName,
      bankAccountNumber: entity.bankAccountNumber,
      // Edit tracking fields
      editedBy: entity.editedBy,
      editedByName: entity.editedByName,
      // Work Schedule Template fields
      workScheduleTemplateId: entity.workScheduleTemplateId,
      workScheduleTemplateName: entity.workScheduleTemplateName,
      workStartTime: entity.workStartTime,
      workEndTime: entity.workEndTime,
      workMonday: entity.workMonday,
      workTuesday: entity.workTuesday,
      workWednesday: entity.workWednesday,
      workThursday: entity.workThursday,
      workFriday: entity.workFriday,
      workSaturday: entity.workSaturday,
      workSunday: entity.workSunday,
    );
  }

  /// Create model from JSON (Supabase response)
  factory EmployeeSalaryModel.fromJson(Map<String, dynamic> json) {
    return EmployeeSalaryModel(
      salaryId: json['salary_id'] as String?,
      userId: json['user_id'] as String? ?? '',
      fullName: json['full_name'] as String? ?? 'Unknown Employee',
      email: json['email'] as String? ?? '',
      profileImage: json['profile_image'] as String?,
      roleName: json['role_name'] as String? ?? '',
      companyId: json['company_id'] as String? ?? '',
      storeId: json['store_id'] as String?,
      salaryAmount: (json['salary_amount'] as num?)?.toDouble() ?? 0.0,
      salaryType: json['salary_type'] as String? ?? 'monthly',
      currencyId: json['currency_id'] as String? ?? 'USD',
      currencyName: json['currency_name'] as String? ?? 'US Dollar',
      symbol: json['symbol'] as String? ?? '\$',
      effectiveDate: DateTimeUtils.toLocalSafe(json['effective_date'] as String?),
      isActive: json['is_active'] as bool? ?? true,
      updatedAt: DateTimeUtils.toLocalSafe(json['updated_at'] as String?),

      // Enhanced fields with defaults
      department: json['department'] as String?,
      hireDate: DateTimeUtils.toLocalSafe(json['hire_date'] as String?),
      employeeId: json['employee_id'] as String?,
      workLocation: json['work_location'] as String?,
      performanceRating: json['performance_rating'] as String?,
      employmentType: json['employment_type'] as String? ?? 'Full-time',
      lastReviewDate: DateTimeUtils.toLocalSafe(json['last_review_date'] as String?),
      nextReviewDate: DateTimeUtils.toLocalSafe(json['next_review_date'] as String?),
      previousSalary: (json['previous_salary'] as num?)?.toDouble(),
      managerName: json['manager_name'] as String?,
      costCenter: json['cost_center'] as String?,
      employmentStatus: json['employment_status'] as String? ?? 'Active',

      // Attendance fields
      month: json['month'] as String?,
      totalWorkingDay: json['total_working_day'] as int?,
      totalWorkingHour: (json['total_working_hour'] as num?)?.toDouble(),
      totalSalary: (json['total_salary'] as num?)?.toDouble(),

      // Activity tracking
      lastActivityAt: DateTimeUtils.toLocalSafe(json['last_activity_at'] as String?),

      // Bank information
      bankName: json['bank_name'] as String?,
      bankAccountNumber: json['bank_account_number'] as String?,

      // Edit tracking fields (from v_user_salary view)
      editedBy: json['edited_by'] as String?,
      editedByName: json['edited_by_name'] as String?,

      // Work Schedule Template fields (from v_user_salary view)
      workScheduleTemplateId: json['work_schedule_template_id'] as String?,
      workScheduleTemplateName: json['work_schedule_template_name'] as String?,
      workStartTime: _parseTimeString(json['work_start_time'] as String?),
      workEndTime: _parseTimeString(json['work_end_time'] as String?),
      workMonday: json['work_monday'] as bool?,
      workTuesday: json['work_tuesday'] as bool?,
      workWednesday: json['work_wednesday'] as bool?,
      workThursday: json['work_thursday'] as bool?,
      workFriday: json['work_friday'] as bool?,
      workSaturday: json['work_saturday'] as bool?,
      workSunday: json['work_sunday'] as bool?,
    );
  }

  /// Parse time string and return in HH:mm format
  /// Handles: "09:00:00", "09:00", "09:00:00+09:00"
  static String? _parseTimeString(String? timeString) {
    if (timeString == null) return null;

    try {
      // Remove timezone offset if present
      String cleanedTime = timeString;
      if (timeString.contains('+') || timeString.contains('-')) {
        final plusIndex = timeString.indexOf('+');
        final minusIndex = timeString.lastIndexOf('-');
        final offsetIndex = plusIndex != -1 ? plusIndex : minusIndex;
        if (offsetIndex > 0) {
          cleanedTime = timeString.substring(0, offsetIndex);
        }
      }

      // Extract HH:mm from HH:mm:ss
      final parts = cleanedTime.split(':');
      if (parts.length >= 2) {
        return '${parts[0].padLeft(2, '0')}:${parts[1].padLeft(2, '0')}';
      }

      return cleanedTime;
    } catch (e) {
      return timeString;
    }
  }

  /// Convert model to JSON (for Supabase requests)
  Map<String, dynamic> toJson() {
    return {
      'salary_id': salaryId,
      'user_id': userId,
      'full_name': fullName,
      'email': email,
      'profile_image': profileImage,
      'role_name': roleName,
      'company_id': companyId,
      'store_id': storeId,
      'salary_amount': salaryAmount,
      'salary_type': salaryType,
      'currency_id': currencyId,
      'currency_name': currencyName,
      'symbol': symbol,
      'effective_date': effectiveDate != null ? DateTimeUtils.toUtc(effectiveDate!) : null,
      'is_active': isActive,
      'updated_at': updatedAt != null ? DateTimeUtils.toUtc(updatedAt!) : null,

      // Enhanced fields
      'department': department,
      'hire_date': hireDate != null ? DateTimeUtils.toUtc(hireDate!) : null,
      'employee_id': employeeId,
      'work_location': workLocation,
      'performance_rating': performanceRating,
      'employment_type': employmentType,
      'last_review_date': lastReviewDate != null ? DateTimeUtils.toUtc(lastReviewDate!) : null,
      'next_review_date': nextReviewDate != null ? DateTimeUtils.toUtc(nextReviewDate!) : null,
      'previous_salary': previousSalary,
      'manager_name': managerName,
      'cost_center': costCenter,
      'employment_status': employmentStatus,

      // Attendance fields
      'month': month,
      'total_working_day': totalWorkingDay,
      'total_working_hour': totalWorkingHour,
      'total_salary': totalSalary,

      // Activity tracking
      'last_activity_at': lastActivityAt != null ? DateTimeUtils.toUtc(lastActivityAt!) : null,

      // Bank information
      'bank_name': bankName,
      'bank_account_number': bankAccountNumber,

      // Edit tracking fields
      'edited_by': editedBy,
      'edited_by_name': editedByName,

      // Work Schedule Template fields
      'work_schedule_template_id': workScheduleTemplateId,
      'work_schedule_template_name': workScheduleTemplateName,
      'work_start_time': workStartTime,
      'work_end_time': workEndTime,
      'work_monday': workMonday,
      'work_tuesday': workTuesday,
      'work_wednesday': workWednesday,
      'work_thursday': workThursday,
      'work_friday': workFriday,
      'work_saturday': workSaturday,
      'work_sunday': workSunday,
    };
  }

  /// Convert model to domain entity
  EmployeeSalary toEntity() {
    return EmployeeSalary(
      salaryId: salaryId,
      userId: userId,
      fullName: fullName,
      email: email,
      profileImage: profileImage,
      roleName: roleName,
      companyId: companyId,
      storeId: storeId,
      salaryAmount: salaryAmount,
      salaryType: salaryType,
      currencyId: currencyId,
      currencyName: currencyName,
      symbol: symbol,
      effectiveDate: effectiveDate,
      isActive: isActive,
      updatedAt: updatedAt,
      department: department,
      hireDate: hireDate,
      employeeId: employeeId,
      workLocation: workLocation,
      performanceRating: performanceRating,
      employmentType: employmentType,
      lastReviewDate: lastReviewDate,
      nextReviewDate: nextReviewDate,
      previousSalary: previousSalary,
      managerName: managerName,
      costCenter: costCenter,
      employmentStatus: employmentStatus,
      month: month,
      totalWorkingDay: totalWorkingDay,
      totalWorkingHour: totalWorkingHour,
      totalSalary: totalSalary,
      lastActivityAt: lastActivityAt,
      bankName: bankName,
      bankAccountNumber: bankAccountNumber,
      // Edit tracking fields
      editedBy: editedBy,
      editedByName: editedByName,
      // Work Schedule Template fields
      workScheduleTemplateId: workScheduleTemplateId,
      workScheduleTemplateName: workScheduleTemplateName,
      workStartTime: workStartTime,
      workEndTime: workEndTime,
      workMonday: workMonday,
      workTuesday: workTuesday,
      workWednesday: workWednesday,
      workThursday: workThursday,
      workFriday: workFriday,
      workSaturday: workSaturday,
      workSunday: workSunday,
    );
  }
}
