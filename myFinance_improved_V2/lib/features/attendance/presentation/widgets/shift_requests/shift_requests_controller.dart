import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../../app/providers/app_state_provider.dart';
import '../../../../../core/utils/datetime_utils.dart';
import '../../../domain/entities/monthly_shift_status.dart';
import '../../../domain/entities/shift_metadata.dart';
import '../../providers/attendance_providers.dart';

/// Controller for shift requests state and data fetching
class ShiftRequestsController {
  final WidgetRef ref;

  ShiftRequestsController({required this.ref});

  /// Get selected store ID from app state
  String? getSelectedStoreId() {
    final appState = ref.read(appStateProvider);
    return appState.storeChoosen.isNotEmpty ? appState.storeChoosen : null;
  }

  /// Get current user ID from app state
  String getCurrentUserId() {
    final appState = ref.read(appStateProvider);
    return appState.userId;
  }

  /// Get store name from app state
  String getStoreName() {
    final appState = ref.read(appStateProvider);
    return appState.storeName.isNotEmpty ? appState.storeName : 'Store';
  }

  /// Calculate week start date (Monday) based on offset
  DateTime getWeekStartDate(int weekOffset) {
    final currentWeek = DateTime.now().add(Duration(days: weekOffset * 7));
    final weekday = currentWeek.weekday; // 1=Mon, 7=Sun
    final monday = currentWeek.subtract(Duration(days: weekday - 1));
    return DateTime(monday.year, monday.month, monday.day);
  }

  /// Format week label
  String getWeekLabel(int weekOffset) {
    if (weekOffset == 0) {
      return 'This week';
    } else if (weekOffset < 0) {
      return 'Previous week';
    } else {
      return 'Next week';
    }
  }

  /// Format date range (e.g., "10 - 16 Jun")
  String getDateRange(DateTime weekStartDate) {
    final start = weekStartDate;
    final end = weekStartDate.add(const Duration(days: 6));

    final startDay = start.day;
    final endDay = end.day;
    final month = DateFormat.MMM().format(end); // Use end month

    return '$startDay - $endDay $month';
  }

  /// Fetch monthly shift status data
  Future<List<MonthlyShiftStatus>?> fetchMonthlyShiftStatus(DateTime selectedDate) async {
    final appState = ref.read(appStateProvider);
    final storeId = appState.storeChoosen;
    final companyId = appState.companyChoosen;

    if (storeId.isEmpty || companyId.isEmpty) return null;

    try {
      final getMonthlyShiftStatus = ref.read(getMonthlyShiftStatusProvider);

      // Use the 15th of the selected month to fetch that month's data
      // Important: Always use the selectedDate's month, not current date
      final targetDate = DateTime(selectedDate.year, selectedDate.month, 15, 12, 0, 0);
      final requestTime = DateFormat('yyyy-MM-dd HH:mm:ss').format(targetDate);

      // Get user's local timezone from device
      final timezone = DateTimeUtils.getLocalTimezone();

      debugPrint('[ShiftRequestsController] fetchMonthlyShiftStatus: selectedDate=$selectedDate, requestTime=$requestTime');

      final response = await getMonthlyShiftStatus(
        storeId: storeId,
        companyId: companyId,
        requestTime: requestTime,
        timezone: timezone,
      );

      return response;
    } catch (e) {
      final errorMessage = e.toString();
      debugPrint('[ShiftRequestsController] fetchMonthlyShiftStatus ERROR: $errorMessage');

      // If it's a NOT_FOUND error, return empty list instead of null
      // This is expected when there are no shift requests yet
      if (errorMessage.contains('NOT_FOUND') || errorMessage.contains('No matching shift request')) {
        debugPrint('[ShiftRequestsController] NOT_FOUND error - returning empty list (no shift requests available)');
        return [];
      }

      return null;
    }
  }

  /// Fetch shift metadata
  Future<List<ShiftMetadata>?> fetchShiftMetadata(String storeId) async {
    if (storeId.isEmpty) return null;

    try {
      final getShiftMetadata = ref.read(getShiftMetadataProvider);
      final timezone = DateTimeUtils.getLocalTimezone();
      final response = await getShiftMetadata(
        storeId: storeId,
        timezone: timezone,
      );

      return response;
    } catch (_) {
      return [];
    }
  }

  /// Get active shifts from metadata
  List<ShiftMetadata> getActiveShifts(List<ShiftMetadata>? shiftMetadata) {
    if (shiftMetadata == null) {
      return [];
    }
    return shiftMetadata.where((shift) => shift.isActive).toList();
  }
}
