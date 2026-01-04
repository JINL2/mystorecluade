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

  // Edit tracking - 누가 언제 수정했는지 추적
  final String? editedBy;       // 편집자 user_id
  final String? editedByName;   // 편집자 이름 (뷰에서 JOIN)

  // Work Schedule Template (for monthly employees)
  final String? workScheduleTemplateId;
  final String? workScheduleTemplateName;
  final String? workStartTime; // HH:mm format
  final String? workEndTime;   // HH:mm format
  final bool? workMonday;
  final bool? workTuesday;
  final bool? workWednesday;
  final bool? workThursday;
  final bool? workFriday;
  final bool? workSaturday;
  final bool? workSunday;

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

    // Edit tracking
    this.editedBy,
    this.editedByName,

    // Work Schedule Template
    this.workScheduleTemplateId,
    this.workScheduleTemplateName,
    this.workStartTime,
    this.workEndTime,
    this.workMonday,
    this.workTuesday,
    this.workWednesday,
    this.workThursday,
    this.workFriday,
    this.workSaturday,
    this.workSunday,
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
    String? editedBy,
    String? editedByName,
    String? workScheduleTemplateId,
    String? workScheduleTemplateName,
    String? workStartTime,
    String? workEndTime,
    bool? workMonday,
    bool? workTuesday,
    bool? workWednesday,
    bool? workThursday,
    bool? workFriday,
    bool? workSaturday,
    bool? workSunday,
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
      editedBy: editedBy ?? this.editedBy,
      editedByName: editedByName ?? this.editedByName,
      workScheduleTemplateId: workScheduleTemplateId ?? this.workScheduleTemplateId,
      workScheduleTemplateName: workScheduleTemplateName ?? this.workScheduleTemplateName,
      workStartTime: workStartTime ?? this.workStartTime,
      workEndTime: workEndTime ?? this.workEndTime,
      workMonday: workMonday ?? this.workMonday,
      workTuesday: workTuesday ?? this.workTuesday,
      workWednesday: workWednesday ?? this.workWednesday,
      workThursday: workThursday ?? this.workThursday,
      workFriday: workFriday ?? this.workFriday,
      workSaturday: workSaturday ?? this.workSaturday,
      workSunday: workSunday ?? this.workSunday,
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

  // ========================================
  // Work Schedule Template convenience methods
  // ========================================

  /// Returns true if this employee has a work schedule template assigned
  bool get hasWorkScheduleTemplate => workScheduleTemplateId != null;

  /// Returns true if this is a monthly (salary-based) employee
  bool get isMonthlyEmployee => salaryType == 'monthly';

  /// Returns formatted work time range (e.g., "09:00 - 18:00")
  String get workTimeRangeText {
    if (workStartTime == null || workEndTime == null) return 'Not set';
    return '$workStartTime - $workEndTime';
  }

  /// Returns list of working days as short names (e.g., ["Mon", "Tue", "Wed"])
  List<String> get workingDayNames {
    final days = <String>[];
    if (workMonday == true) days.add('Mon');
    if (workTuesday == true) days.add('Tue');
    if (workWednesday == true) days.add('Wed');
    if (workThursday == true) days.add('Thu');
    if (workFriday == true) days.add('Fri');
    if (workSaturday == true) days.add('Sat');
    if (workSunday == true) days.add('Sun');
    return days;
  }

  /// Returns formatted working days text (e.g., "Mon-Fri" or "Mon, Wed, Fri")
  String get workingDaysText {
    if (!hasWorkScheduleTemplate) return 'No template';

    final days = workingDayNames;
    if (days.isEmpty) return 'No working days';
    if (days.length == 7) return 'Every day';

    // Check for consecutive weekdays (Mon-Fri)
    if (workMonday == true &&
        workTuesday == true &&
        workWednesday == true &&
        workThursday == true &&
        workFriday == true &&
        workSaturday != true &&
        workSunday != true) {
      return 'Mon-Fri';
    }

    // Check for Mon-Sat
    if (workMonday == true &&
        workTuesday == true &&
        workWednesday == true &&
        workThursday == true &&
        workFriday == true &&
        workSaturday == true &&
        workSunday != true) {
      return 'Mon-Sat';
    }

    return days.join(', ');
  }

  /// Returns total working days per week
  int get workingDaysCount {
    int count = 0;
    if (workMonday == true) count++;
    if (workTuesday == true) count++;
    if (workWednesday == true) count++;
    if (workThursday == true) count++;
    if (workFriday == true) count++;
    if (workSaturday == true) count++;
    if (workSunday == true) count++;
    return count;
  }

  /// Returns true if today is a working day for this employee
  bool get isTodayWorkingDay {
    if (!hasWorkScheduleTemplate) return true; // Default to working day if no template

    final weekday = DateTime.now().weekday; // 1=Mon, 7=Sun
    switch (weekday) {
      case 1: return workMonday == true;
      case 2: return workTuesday == true;
      case 3: return workWednesday == true;
      case 4: return workThursday == true;
      case 5: return workFriday == true;
      case 6: return workSaturday == true;
      case 7: return workSunday == true;
      default: return false;
    }
  }
}
