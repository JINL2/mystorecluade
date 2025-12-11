/// Domain Entity: Employee Salary
///
/// Pure business object with no external dependencies.
/// This represents an employee's salary information in the business domain.
class EmployeeSalary {
  final String? salaryId;
  final String userId;
  final String fullName;
  final String email;
  final String? profileImage;
  final String roleName;
  final String companyId;
  final String? storeId;
  final double salaryAmount;
  final String salaryType;
  final String currencyId;
  final String currencyName;
  final String symbol;
  final DateTime? effectiveDate;
  final bool isActive;
  final DateTime? updatedAt;

  // Enhanced fields for better UX
  final String? department;
  final DateTime? hireDate;
  final String? employeeId;
  final String? workLocation; // Remote, Office, Hybrid
  final String? performanceRating; // A+, A, B, C, Needs Improvement
  final String? employmentType; // Full-time, Part-time, Contract
  final DateTime? lastReviewDate;
  final DateTime? nextReviewDate;
  final double? previousSalary;
  final String? managerName;
  final String? costCenter;
  final String? employmentStatus; // Active, On Leave, Terminated

  // Attendance fields from user_salaries table
  final String? month;
  final int? totalWorkingDay;
  final double? totalWorkingHour;
  final double? totalSalary;

  // Activity tracking
  final DateTime? lastActivityAt;

  // Bank information
  final String? bankName;
  final String? bankAccountNumber;

  const EmployeeSalary({
    this.salaryId,
    required this.userId,
    required this.fullName,
    required this.email,
    this.profileImage,
    required this.roleName,
    required this.companyId,
    this.storeId,
    required this.salaryAmount,
    required this.salaryType,
    required this.currencyId,
    required this.currencyName,
    required this.symbol,
    this.effectiveDate,
    required this.isActive,
    this.updatedAt,

    // Enhanced fields
    this.department,
    this.hireDate,
    this.employeeId,
    this.workLocation,
    this.performanceRating,
    this.employmentType,
    this.lastReviewDate,
    this.nextReviewDate,
    this.previousSalary,
    this.managerName,
    this.costCenter,
    this.employmentStatus,

    // Attendance fields
    this.month,
    this.totalWorkingDay,
    this.totalWorkingHour,
    this.totalSalary,

    // Activity tracking
    this.lastActivityAt,

    // Bank information
    this.bankName,
    this.bankAccountNumber,
  });

  EmployeeSalary copyWith({
    String? salaryId,
    String? userId,
    String? fullName,
    String? email,
    String? profileImage,
    String? roleName,
    String? companyId,
    String? storeId,
    double? salaryAmount,
    String? salaryType,
    String? currencyId,
    String? currencyName,
    String? symbol,
    DateTime? effectiveDate,
    bool? isActive,
    DateTime? updatedAt,
    String? employeeId,
    String? department,
    DateTime? hireDate,
    String? workLocation,
    String? employmentType,
    String? employmentStatus,
    String? costCenter,
    String? managerName,
    String? performanceRating,
    DateTime? lastReviewDate,
    DateTime? nextReviewDate,
    double? previousSalary,
    String? month,
    int? totalWorkingDay,
    double? totalWorkingHour,
    double? totalSalary,
    DateTime? lastActivityAt,
    String? bankName,
    String? bankAccountNumber,
  }) {
    return EmployeeSalary(
      salaryId: salaryId ?? this.salaryId,
      userId: userId ?? this.userId,
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      profileImage: profileImage ?? this.profileImage,
      roleName: roleName ?? this.roleName,
      companyId: companyId ?? this.companyId,
      storeId: storeId ?? this.storeId,
      salaryAmount: salaryAmount ?? this.salaryAmount,
      salaryType: salaryType ?? this.salaryType,
      currencyId: currencyId ?? this.currencyId,
      currencyName: currencyName ?? this.currencyName,
      symbol: symbol ?? this.symbol,
      effectiveDate: effectiveDate ?? this.effectiveDate,
      isActive: isActive ?? this.isActive,
      updatedAt: updatedAt ?? this.updatedAt,
      employeeId: employeeId ?? this.employeeId,
      department: department ?? this.department,
      hireDate: hireDate ?? this.hireDate,
      workLocation: workLocation ?? this.workLocation,
      employmentType: employmentType ?? this.employmentType,
      employmentStatus: employmentStatus ?? this.employmentStatus,
      costCenter: costCenter ?? this.costCenter,
      managerName: managerName ?? this.managerName,
      performanceRating: performanceRating ?? this.performanceRating,
      lastReviewDate: lastReviewDate ?? this.lastReviewDate,
      nextReviewDate: nextReviewDate ?? this.nextReviewDate,
      previousSalary: previousSalary ?? this.previousSalary,
      month: month ?? this.month,
      totalWorkingDay: totalWorkingDay ?? this.totalWorkingDay,
      totalWorkingHour: totalWorkingHour ?? this.totalWorkingHour,
      totalSalary: totalSalary ?? this.totalSalary,
      lastActivityAt: lastActivityAt ?? this.lastActivityAt,
      bankName: bankName ?? this.bankName,
      bankAccountNumber: bankAccountNumber ?? this.bankAccountNumber,
    );
  }

  // Convenience methods for enhanced UX
  String get tenureText {
    if (hireDate == null) return 'Unknown';

    final now = DateTime.now();
    final difference = now.difference(hireDate!);
    final years = difference.inDays ~/ 365;
    final months = (difference.inDays % 365) ~/ 30;

    if (years > 0) {
      return months > 0 ? '$years.${(months / 12 * 10).round()}yr' : '${years}yr';
    } else if (months > 0) {
      return '${months}mo';
    } else {
      final days = difference.inDays;
      return '${days}d';
    }
  }

  double? get salaryIncrease {
    if (previousSalary == null || previousSalary == 0) return null;
    return salaryAmount - previousSalary!;
  }

  double? get salaryIncreasePercentage {
    if (previousSalary == null || previousSalary == 0) return null;
    return ((salaryAmount - previousSalary!) / previousSalary!) * 100;
  }

  bool get isReviewDue {
    if (nextReviewDate == null) return false;
    final now = DateTime.now();
    final daysUntilReview = nextReviewDate!.difference(now).inDays;
    return daysUntilReview <= 30 && daysUntilReview >= 0;
  }

  bool get isReviewOverdue {
    if (nextReviewDate == null) return false;
    return DateTime.now().isAfter(nextReviewDate!);
  }

  /// Returns human-readable last activity text (e.g., "2 hours ago", "3 days ago")
  String get lastActivityText {
    if (lastActivityAt == null) return 'No activity';

    final now = DateTime.now();
    final difference = now.difference(lastActivityAt!);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else if (difference.inDays < 30) {
      final weeks = difference.inDays ~/ 7;
      return '${weeks}w ago';
    } else if (difference.inDays < 365) {
      final months = difference.inDays ~/ 30;
      return '${months}mo ago';
    } else {
      final years = difference.inDays ~/ 365;
      return '${years}y ago';
    }
  }

  /// Returns true if the employee has been active in the last 24 hours
  bool get isActiveToday {
    if (lastActivityAt == null) return false;
    return DateTime.now().difference(lastActivityAt!).inHours < 24;
  }

  /// Returns true if the employee has been inactive for more than 7 days
  bool get isInactive {
    if (lastActivityAt == null) return true;
    return DateTime.now().difference(lastActivityAt!).inDays > 7;
  }
}
