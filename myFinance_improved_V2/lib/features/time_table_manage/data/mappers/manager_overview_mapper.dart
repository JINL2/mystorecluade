import 'package:flutter/foundation.dart';

import '../../domain/entities/manager_overview.dart';

/// Mapper for converting RPC response to ManagerOverview entity
///
/// Separates complex data transformation logic from Repository
class ManagerOverviewMapper {
  /// Converts RPC response to ManagerOverview entity
  static ManagerOverview fromRpcResponse(Map<String, dynamic> rpcData) {
    if (kDebugMode) {
      debugPrint('🔍 [Mapper] RPC data keys: ${rpcData.keys.toList()}');
    }

    // 1. Extract stores array
    final stores = rpcData['stores'] as List<dynamic>? ?? [];
    if (stores.isEmpty) {
      if (kDebugMode) debugPrint('⚠️ [Mapper] stores is EMPTY → returning _emptyOverview()');
      return _emptyOverview();
    }

    if (kDebugMode) {
      debugPrint('✅ [Mapper] stores.length = ${stores.length}');
      debugPrint('🔍 [Mapper] stores[0] keys: ${(stores.first as Map).keys.toList()}');
    }

    // 2. Extract monthly_stats from first store
    final storeData = stores.first as Map<String, dynamic>;
    final monthlyStats = storeData['monthly_stats'] as List<dynamic>? ?? [];

    if (monthlyStats.isEmpty) {
      if (kDebugMode) debugPrint('⚠️ [Mapper] monthly_stats is EMPTY → returning _emptyOverview()');
      return _emptyOverview();
    }

    if (kDebugMode) {
      debugPrint('✅ [Mapper] monthly_stats.length = ${monthlyStats.length}');
      debugPrint('🔍 [Mapper] monthly_stats[0] = ${monthlyStats.first}');
    }

    // 3. Transform stats data to model format
    final statsData = monthlyStats.first as Map<String, dynamic>;
    final mappedData = _transformStatsData(statsData);

    if (kDebugMode) {
      debugPrint('✅ [Mapper] Final mapped data: $mappedData');
    }

    // 4. Convert to entity
    return ManagerOverview.fromJson(mappedData);
  }

  /// Returns empty ManagerOverview when no data available
  static ManagerOverview _emptyOverview() {
    return const ManagerOverview(
      month: '',
      totalShifts: 0,
      totalApprovedRequests: 0,
      totalPendingRequests: 0,
      totalEmployees: 0,
      totalEstimatedCost: 0.0,
      additionalStats: {},
    );
  }

  /// Transforms RPC stats data to model format
  static Map<String, dynamic> _transformStatsData(Map<String, dynamic> stats) {
    return {
      'month': stats['month'] ?? '',
      // Map RPC field names to model field names
      'total_shifts': stats['total_requests'] ?? 0,
      'total_approved_requests': stats['total_approved'] ?? 0,
      'total_pending_requests': stats['total_pending'] ?? 0,
      'total_employees': stats['total_employees'] ?? 0,
      'total_estimated_cost': stats['total_estimated_cost'] ?? 0.0,
      'additional_stats': {
        'total_problems': stats['total_problems'] ?? 0,
      },
    };
  }
}
