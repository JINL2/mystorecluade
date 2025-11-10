import 'package:flutter/foundation.dart';

import '../../../../core/utils/datetime_utils.dart';
import '../../domain/entities/monthly_shift_status.dart';

/// Mapper for converting RPC response to MonthlyShiftStatus entities
///
/// Separates complex data transformation logic from Repository
class MonthlyShiftStatusMapper {
  /// Converts RPC response to list of MonthlyShiftStatus entities
  static List<MonthlyShiftStatus> fromRpcResponse(List<dynamic> rpcData) {
    if (kDebugMode) {
      debugPrint('🔍 [MonthlyShiftStatusMapper] RPC data length: ${rpcData.length}');
      if (rpcData.isNotEmpty) {
        debugPrint('🔍 [MonthlyShiftStatusMapper] First item keys: ${(rpcData.first as Map).keys.toList()}');
      }
    }

    // 1. Group data by month
    final groupedByMonth = _groupByMonth(rpcData);

    if (kDebugMode) {
      debugPrint('✅ [MonthlyShiftStatusMapper] Grouped by months: ${groupedByMonth.keys.toList()}');
    }

    // 2. Convert each month's data to entity
    return groupedByMonth.entries
        .map((entry) => _toEntity(entry.key, entry.value))
        .toList();
  }

  /// Groups RPC data by month (yyyy-MM)
  static Map<String, List<Map<String, dynamic>>> _groupByMonth(
    List<dynamic> data,
  ) {
    final Map<String, List<Map<String, dynamic>>> grouped = {};

    for (final item in data) {
      final itemMap = item as Map<String, dynamic>;
      final requestDate = itemMap['request_date'] as String?;

      if (requestDate != null && requestDate.length >= 7) {
        // Extract month (yyyy-MM) from date (yyyy-MM-dd)
        final month = requestDate.substring(0, 7);

        grouped.putIfAbsent(month, () => []);
        grouped[month]!.add(_transformItem(itemMap));
      }
    }

    return grouped;
  }

  /// Transforms a single RPC item to match model expectations
  static Map<String, dynamic> _transformItem(Map<String, dynamic> item) {
    final transformed = Map<String, dynamic>.from(item);

    // Change field name: request_date → date
    transformed['date'] = item['request_date'];
    transformed.remove('request_date');

    // Transform shifts array structure
    if (transformed['shifts'] is List) {
      transformed['shifts'] = _transformShifts(
        transformed['shifts'] as List,
      );
    }

    return transformed;
  }

  /// Transforms shifts array from RPC format to model format
  static List<Map<String, dynamic>> _transformShifts(List<dynamic> shifts) {
    final now = DateTime.now();
    final defaultStartTime = DateTime(now.year, now.month, now.day, 9, 0);
    final defaultEndTime = DateTime(now.year, now.month, now.day, 18, 0);

    return shifts.map((shift) {
      if (shift is! Map<String, dynamic>) return shift;

      final pendingEmployees = shift['pending_employees'] as List? ?? [];
      final approvedEmployees = shift['approved_employees'] as List? ?? [];

      return {
        'shift': {
          'shift_id': shift['shift_id'],
          'shift_name': shift['shift_name'],
          'required_employees': shift['required_employees'],
          'plan_start_time': DateTimeUtils.toUtc(defaultStartTime),
          'plan_end_time': DateTimeUtils.toUtc(defaultEndTime),
        },
        'pending_requests': _transformEmployees(
          pendingEmployees,
          shift['shift_id'] as String,
          isPending: true,
        ),
        'approved_requests': _transformEmployees(
          approvedEmployees,
          shift['shift_id'] as String,
          isPending: false,
        ),
      };
    }).cast<Map<String, dynamic>>().toList();
  }

  /// Transforms employee list to shift request format
  static List<Map<String, dynamic>> _transformEmployees(
    List<dynamic> employees,
    String shiftId, {
    required bool isPending,
  }) {
    final now = DateTime.now();

    return employees.map((emp) {
      if (emp is! Map<String, dynamic>) return emp;

      return {
        ...emp,
        'shift_id': shiftId,
        'created_at': DateTimeUtils.toUtc(now),
        if (!isPending) 'approved_at': DateTimeUtils.toUtc(now),
        'employee': {
          'user_id': emp['user_id'],
          'user_name': emp['user_name'],
          'profile_image': emp['profile_image'],
        },
      };
    }).cast<Map<String, dynamic>>().toList();
  }

  /// Converts grouped data to MonthlyShiftStatus entity
  static MonthlyShiftStatus _toEntity(
    String month,
    List<Map<String, dynamic>> dailyData,
  ) {
    final monthData = {
      'month': month,
      'daily_shifts': dailyData,
      'statistics': <String, int>{},
    };

    return MonthlyShiftStatus.fromJson(monthData);
  }
}
