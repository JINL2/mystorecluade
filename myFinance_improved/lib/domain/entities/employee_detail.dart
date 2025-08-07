// lib/domain/entities/employee_detail.dart

class EmployeeDetail {
  final String userId;
  final String fullName;
  final String? email;
  final String? profileImage;
  final String? roleId;
  final String? roleName;
  final String companyId;
  final String? salaryId;
  final double? salaryAmount;
  final String? salaryType;
  final String? currencyId;
  final String? currencySymbol;
  final DateTime? hireDate;
  final bool isActive;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  // Additional fields from v_user_salary view
  final String? firstName;
  final String? lastName;
  final String? companyName;
  final String? storeName;
  final String? storeId;
  final String? currencyName;
  final String? currencyCode;
  final double? bonusAmount;
  final String? phoneNumber;
  final DateTime? dateOfBirth;

  const EmployeeDetail({
    required this.userId,
    required this.fullName,
    this.email,
    this.profileImage,
    this.roleId,
    this.roleName,
    required this.companyId,
    this.salaryId,
    this.salaryAmount,
    this.salaryType,
    this.currencyId,
    this.currencySymbol,
    this.hireDate,
    this.isActive = true,
    this.createdAt,
    this.updatedAt,
    this.firstName,
    this.lastName,
    this.companyName,
    this.storeName,
    this.storeId,
    this.currencyName,
    this.currencyCode,
    this.bonusAmount,
    this.phoneNumber,
    this.dateOfBirth,
  });

  // Computed properties
  String get initials {
    final parts = fullName.split(' ');
    if (parts.length >= 2) {
      return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
    }
    return fullName.isNotEmpty ? fullName[0].toUpperCase() : '';
  }

  String get displaySalary {
    if (salaryAmount == null) return 'Not set';
    
    // Format large numbers with K, M suffixes
    double amount = salaryAmount!;
    String suffix = '';
    
    if (amount >= 1000000) {
      amount = amount / 1000000;
      suffix = 'M';
    } else if (amount >= 1000) {
      amount = amount / 1000;
      suffix = 'K';
    }
    
    final formattedAmount = amount.toStringAsFixed(
      amount % 1 == 0 ? 0 : 1,
    );
    
    final symbol = currencySymbol ?? '\$';
    final type = salaryType == 'hourly' ? '/hr' : '/mo';
    return '$symbol$formattedAmount$suffix$type';
  }

  String get status {
    if (!isActive) return 'Inactive';
    // Add more status logic here if needed
    return 'Active';
  }

  factory EmployeeDetail.fromEmployee(dynamic employee) {
    return EmployeeDetail(
      userId: employee.userId,
      fullName: employee.fullName,
      email: employee.email,
      profileImage: employee.profileImage,
      roleId: employee.roleId,
      roleName: employee.roleName,
      companyId: employee.companyId,
      salaryAmount: employee.salary?.toDouble(),
      salaryType: employee.salaryType,
      currencySymbol: '\$',
      createdAt: employee.createdAt,
      updatedAt: employee.updatedAt,
      storeName: employee.stores?.isNotEmpty == true ? employee.stores.first['store_name'] : null,
      storeId: employee.stores?.isNotEmpty == true ? employee.stores.first['store_id'] : null,
    );
  }
}