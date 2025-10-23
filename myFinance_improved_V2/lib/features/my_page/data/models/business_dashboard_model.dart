import '../../domain/entities/business_dashboard.dart';

class BusinessDashboardModel {
  final String companyName;
  final String storeName;
  final String userRole;
  final int totalEmployees;
  final double monthlyRevenue;
  final int activeShifts;

  const BusinessDashboardModel({
    required this.companyName,
    required this.storeName,
    required this.userRole,
    required this.totalEmployees,
    required this.monthlyRevenue,
    required this.activeShifts,
  });

  factory BusinessDashboardModel.fromJson(Map<String, dynamic> json) {
    return BusinessDashboardModel(
      companyName: json['company_name']?.toString() ?? '',
      storeName: json['store_name']?.toString() ?? '',
      userRole: json['user_role']?.toString() ?? 'Employee',
      totalEmployees: json['total_employees'] as int? ?? 0,
      monthlyRevenue: (json['monthly_revenue'] as num?)?.toDouble() ?? 0.0,
      activeShifts: json['active_shifts'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'company_name': companyName,
      'store_name': storeName,
      'user_role': userRole,
      'total_employees': totalEmployees,
      'monthly_revenue': monthlyRevenue,
      'active_shifts': activeShifts,
    };
  }

  BusinessDashboard toEntity() {
    return BusinessDashboard(
      companyName: companyName,
      storeName: storeName,
      userRole: userRole,
      totalEmployees: totalEmployees,
      monthlyRevenue: monthlyRevenue,
      activeShifts: activeShifts,
    );
  }

  factory BusinessDashboardModel.fromEntity(BusinessDashboard entity) {
    return BusinessDashboardModel(
      companyName: entity.companyName,
      storeName: entity.storeName,
      userRole: entity.userRole,
      totalEmployees: entity.totalEmployees,
      monthlyRevenue: entity.monthlyRevenue,
      activeShifts: entity.activeShifts,
    );
  }
}
