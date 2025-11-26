import '../../../domain/entities/manager_overview.dart';
import 'manager_overview_dto.dart';

/// Extension to map ManagerOverviewDto → Domain Entity
extension ManagerOverviewDtoMapper on ManagerOverviewDto {
  /// Convert DTO to Domain Entity
  ///
  /// Uses first store's monthly stats (like old app behavior)
  /// Does NOT aggregate across multiple stores - uses selected store only
  ManagerOverview toEntity() {
    // Default values
    String month = '';
    int totalRequests = 0;
    int totalApproved = 0;
    int totalPending = 0;
    int totalProblems = 0;

    // Get first store's monthly stats (matching old app behavior)
    if (stores.isNotEmpty) {
      final storeData = stores.first;
      if (storeData.monthlyStats.isNotEmpty) {
        final monthlyStat = storeData.monthlyStats.first;
        month = monthlyStat.month;
        totalRequests = monthlyStat.totalRequests;
        totalApproved = monthlyStat.totalApproved;
        totalPending = monthlyStat.totalPending;
        totalProblems = monthlyStat.totalProblems;
      }
    }

    return ManagerOverview(
      month: month,
      totalShifts: totalRequests,
      totalApprovedRequests: totalApproved,
      totalPendingRequests: totalPending,
      totalProblems: totalProblems,
      totalEmployees: 0, // Not provided by new RPC structure
      totalEstimatedCost: 0.0, // Not provided by new RPC structure
      additionalStats: const {},
    );
  }
}
