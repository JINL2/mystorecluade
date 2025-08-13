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

  EmployeeSalary({
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
  });

  factory EmployeeSalary.fromJson(Map<String, dynamic> json) {
    return EmployeeSalary(
      salaryId: json['salary_id'] as String?,
      userId: json['user_id'] as String? ?? '',
      fullName: json['full_name'] as String? ?? 'Unknown Employee',
      email: json['email'] as String? ?? '',
      profileImage: json['profile_image'] as String?,
      roleName: json['role_name'] as String? ?? 'Unknown Role',
      companyId: json['company_id'] as String? ?? '',
      storeId: json['store_id'] as String?,
      salaryAmount: (json['salary_amount'] as num?)?.toDouble() ?? 0.0,
      salaryType: json['salary_type'] as String? ?? 'monthly',
      currencyId: json['currency_id'] as String? ?? 'USD',
      currencyName: json['currency_name'] as String? ?? 'US Dollar',
      symbol: json['symbol'] as String? ?? '\$',
      effectiveDate: json['effective_date'] != null 
          ? DateTime.tryParse(json['effective_date'].toString()) 
          : null,
      isActive: json['is_active'] as bool? ?? true,
      updatedAt: json['updated_at'] != null 
          ? DateTime.tryParse(json['updated_at'].toString()) 
          : null,
      
      // Enhanced fields with defaults
      department: json['department'] as String?,
      hireDate: json['hire_date'] != null 
          ? DateTime.tryParse(json['hire_date'].toString()) 
          : null,
      employeeId: json['employee_id'] as String?,
      workLocation: json['work_location'] as String?,
      performanceRating: json['performance_rating'] as String?,
      employmentType: json['employment_type'] as String? ?? 'Full-time',
      lastReviewDate: json['last_review_date'] != null 
          ? DateTime.tryParse(json['last_review_date'].toString()) 
          : null,
      nextReviewDate: json['next_review_date'] != null 
          ? DateTime.tryParse(json['next_review_date'].toString()) 
          : null,
      previousSalary: (json['previous_salary'] as num?)?.toDouble(),
      managerName: json['manager_name'] as String?,
      costCenter: json['cost_center'] as String?,
      employmentStatus: json['employment_status'] as String? ?? 'Active',
    );
  }

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
      'effective_date': effectiveDate?.toIso8601String(),
      'is_active': isActive,
      'updated_at': updatedAt?.toIso8601String(),
      
      // Enhanced fields
      'department': department,
      'hire_date': hireDate?.toIso8601String(),
      'employee_id': employeeId,
      'work_location': workLocation,
      'performance_rating': performanceRating,
      'employment_type': employmentType,
      'last_review_date': lastReviewDate?.toIso8601String(),
      'next_review_date': nextReviewDate?.toIso8601String(),
      'previous_salary': previousSalary,
      'manager_name': managerName,
      'cost_center': costCenter,
      'employment_status': employmentStatus,
    };
  }

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

  String get displayDepartment => department ?? 'General';
  String get displayWorkLocation => workLocation ?? 'Office';
  String get displayEmploymentType => employmentType ?? 'Full-time';
  String get displayEmploymentStatus => employmentStatus ?? 'Active';
}