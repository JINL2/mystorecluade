/// Pure domain entity for business dashboard
/// JSON serialization is handled by BusinessDashboardModel in data layer
class BusinessDashboard {
  final String companyName;
  final String storeName;
  final String userRole;
  final int totalEmployees;
  final double monthlyRevenue;
  final int activeShifts;

  const BusinessDashboard({
    required this.companyName,
    required this.storeName,
    required this.userRole,
    required this.totalEmployees,
    required this.monthlyRevenue,
    required this.activeShifts,
  });
}
