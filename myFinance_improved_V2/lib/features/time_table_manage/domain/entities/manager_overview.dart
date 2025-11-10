import 'package:freezed_annotation/freezed_annotation.dart';

part 'manager_overview.freezed.dart';
part 'manager_overview.g.dart';

/// Manager Overview Entity
///
/// Represents overview statistics for manager's shift management dashboard.
@freezed
class ManagerOverview with _$ManagerOverview {
  const ManagerOverview._();

  const factory ManagerOverview({
    /// Month in yyyy-MM format
    required String month,
    @JsonKey(name: 'total_shifts')
    required int totalShifts,
    @JsonKey(name: 'total_approved_requests')
    required int totalApprovedRequests,
    @JsonKey(name: 'total_pending_requests')
    required int totalPendingRequests,
    @JsonKey(name: 'total_employees')
    required int totalEmployees,
    @JsonKey(name: 'total_estimated_cost')
    required double totalEstimatedCost,
    @JsonKey(name: 'additional_stats', defaultValue: <String, dynamic>{})
    required Map<String, dynamic> additionalStats,
  }) = _ManagerOverview;

  /// Create from JSON
  factory ManagerOverview.fromJson(Map<String, dynamic> json) =>
      _$ManagerOverviewFromJson(json);

  /// Get approval rate (approved / total requests)
  double get approvalRate {
    final total = totalApprovedRequests + totalPendingRequests;
    if (total == 0) return 0.0;
    return totalApprovedRequests / total;
  }

  /// Get approval rate as percentage
  String get approvalRatePercentage {
    return '${(approvalRate * 100).toStringAsFixed(1)}%';
  }

  /// Check if there are pending requests
  bool get hasPendingRequests => totalPendingRequests > 0;

  /// Get average employees per shift
  double get averageEmployeesPerShift {
    if (totalShifts == 0) return 0.0;
    return totalApprovedRequests / totalShifts;
  }
}
