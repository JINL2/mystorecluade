import '../../../domain/entities/manager_overview.dart';
import 'manager_overview_dto.dart';

/// Extension to map ManagerOverviewDto → Domain Entity
extension ManagerOverviewDtoMapper on ManagerOverviewDto {
  /// Convert DTO to Domain Entity
  ///
  /// Aggregates data from all stores and monthly_stats
  ManagerOverview toEntity() {
    // Extract month from first store's first monthly stat, or use empty string
    String month = '';
    int totalRequests = 0;
    int totalApproved = 0;
    int totalPending = 0;
    int totalProblems = 0;

    // Aggregate all stores' monthly stats
    for (final store in stores) {
      for (final monthlyStat in store.monthlyStats) {
        if (month.isEmpty) {
          month = monthlyStat.month;
        }
        totalRequests += monthlyStat.totalRequests;
        totalApproved += monthlyStat.totalApproved;
        totalPending += monthlyStat.totalPending;
        totalProblems += monthlyStat.totalProblems;
      }
    }

    return ManagerOverview(
      month: month,
      totalShifts: totalRequests,
      totalApprovedRequests: totalApproved,
      totalPendingRequests: totalPending,
      totalEmployees: 0, // Not provided by new RPC structure
      totalEstimatedCost: 0.0, // Not provided by new RPC structure
      additionalStats: {
        'total_problems': totalProblems,
      },
    );
  }
}
