import '../../domain/entities/manager_overview.dart';

/// Manager Overview Model (DTO + Mapper)
///
/// Data Transfer Object for ManagerOverview entity with JSON serialization.
class ManagerOverviewModel {
  final String month;
  final int totalShifts;
  final int totalApprovedRequests;
  final int totalPendingRequests;
  final int totalEmployees;
  final double totalEstimatedCost;
  final Map<String, dynamic> additionalStats;

  const ManagerOverviewModel({
    required this.month,
    required this.totalShifts,
    required this.totalApprovedRequests,
    required this.totalPendingRequests,
    required this.totalEmployees,
    required this.totalEstimatedCost,
    this.additionalStats = const {},
  });

  /// Create from JSON
  factory ManagerOverviewModel.fromJson(Map<String, dynamic> json) {
    return ManagerOverviewModel(
      month: json['month'] as String? ?? '',
      totalShifts: json['total_shifts'] as int? ?? 0,
      totalApprovedRequests: json['total_approved_requests'] as int? ?? 0,
      totalPendingRequests: json['total_pending_requests'] as int? ?? 0,
      totalEmployees: json['total_employees'] as int? ?? 0,
      totalEstimatedCost:
          (json['total_estimated_cost'] as num?)?.toDouble() ?? 0.0,
      additionalStats: json['additional_stats'] as Map<String, dynamic>? ?? {},
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'month': month,
      'total_shifts': totalShifts,
      'total_approved_requests': totalApprovedRequests,
      'total_pending_requests': totalPendingRequests,
      'total_employees': totalEmployees,
      'total_estimated_cost': totalEstimatedCost,
      'additional_stats': additionalStats,
    };
  }

  /// Map to Domain Entity
  ManagerOverview toEntity() {
    return ManagerOverview(
      month: month,
      totalShifts: totalShifts,
      totalApprovedRequests: totalApprovedRequests,
      totalPendingRequests: totalPendingRequests,
      totalEmployees: totalEmployees,
      totalEstimatedCost: totalEstimatedCost,
      additionalStats: additionalStats,
    );
  }

  /// Create from Domain Entity
  factory ManagerOverviewModel.fromEntity(ManagerOverview entity) {
    return ManagerOverviewModel(
      month: entity.month,
      totalShifts: entity.totalShifts,
      totalApprovedRequests: entity.totalApprovedRequests,
      totalPendingRequests: entity.totalPendingRequests,
      totalEmployees: entity.totalEmployees,
      totalEstimatedCost: entity.totalEstimatedCost,
      additionalStats: entity.additionalStats,
    );
  }
}
