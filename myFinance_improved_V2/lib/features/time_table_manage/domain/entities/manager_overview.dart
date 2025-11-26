/// Manager Overview Entity
///
/// Represents overview statistics for manager's shift management dashboard.
class ManagerOverview {
  final String month; // yyyy-MM
  final int totalShifts;
  final int totalApprovedRequests;
  final int totalPendingRequests;
  final int totalProblems;
  final int totalEmployees;
  final double totalEstimatedCost;
  final Map<String, dynamic> additionalStats;

  const ManagerOverview({
    required this.month,
    required this.totalShifts,
    required this.totalApprovedRequests,
    required this.totalPendingRequests,
    required this.totalProblems,
    required this.totalEmployees,
    required this.totalEstimatedCost,
    this.additionalStats = const {},
  });

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

  /// Check if there are problems
  bool get hasProblems => totalProblems > 0;

  /// Get average employees per shift
  double get averageEmployeesPerShift {
    if (totalShifts == 0) return 0.0;
    return totalApprovedRequests / totalShifts;
  }

  /// Copy with method for immutability
  ManagerOverview copyWith({
    String? month,
    int? totalShifts,
    int? totalApprovedRequests,
    int? totalPendingRequests,
    int? totalProblems,
    int? totalEmployees,
    double? totalEstimatedCost,
    Map<String, dynamic>? additionalStats,
  }) {
    return ManagerOverview(
      month: month ?? this.month,
      totalShifts: totalShifts ?? this.totalShifts,
      totalApprovedRequests: totalApprovedRequests ?? this.totalApprovedRequests,
      totalPendingRequests: totalPendingRequests ?? this.totalPendingRequests,
      totalProblems: totalProblems ?? this.totalProblems,
      totalEmployees: totalEmployees ?? this.totalEmployees,
      totalEstimatedCost: totalEstimatedCost ?? this.totalEstimatedCost,
      additionalStats: additionalStats ?? this.additionalStats,
    );
  }

  @override
  String toString() => 'ManagerOverview(month: $month, shifts: $totalShifts, approved: $totalApprovedRequests, pending: $totalPendingRequests, problems: $totalProblems)';
}
