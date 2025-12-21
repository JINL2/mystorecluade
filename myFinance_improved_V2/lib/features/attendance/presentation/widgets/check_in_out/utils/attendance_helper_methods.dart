import 'package:flutter/material.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

import '../../../../../../core/monitoring/sentry_config.dart';
import '../../../../../../core/utils/datetime_utils.dart';
import '../../../../../../shared/themes/toss_colors.dart';
import '../../../../domain/entities/shift_card.dart';
import '../../../pages/utils/schedule_date_utils.dart';

/// Helper methods for attendance-related operations
class AttendanceHelpers {
  /// Format time from various formats to HH:mm
  /// Handles UTC to local time conversion
  static String formatTime(dynamic time, {String? requestDate}) {
    if (time == null || time.toString().isEmpty) {
      return '--:--';
    }

    final timeStr = time.toString();

    try {
      // If it's a datetime string (UTC from DB - need to convert to local time)
      // Handles both ISO8601 (2025-10-27T14:56:00Z) and PostgreSQL format (2025-10-27 14:56:00)
      if (timeStr.contains('T') || (timeStr.contains(' ') && timeStr.length > 10)) {
        DateTime dateTime;

        // PostgreSQL "timestamp without time zone" format: "2025-10-27 14:56:00"
        // We treat this as UTC and convert to local time
        if (timeStr.contains(' ') && !timeStr.contains('T')) {
          // Parse as UTC by adding 'Z' suffix
          final isoFormat = '${timeStr.replaceFirst(' ', 'T')}Z';
          dateTime = DateTimeUtils.toLocal(isoFormat);
        } else {
          // ISO8601 format with 'T'
          dateTime = DateTimeUtils.toLocal(timeStr);
        }

        return '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
      }

      // If it's just time string (HH:mm:ss or HH:mm) from RPC to_char()
      // We need to combine with request_date to convert from UTC to local time
      if (timeStr.contains(':') && !timeStr.contains(' ') && timeStr.length <= 10) {
        if (requestDate != null && requestDate.isNotEmpty) {
          // Combine date + time and treat as UTC
          final utcTimestamp = '${requestDate}T${timeStr}Z';
          try {
            final dateTime = DateTimeUtils.toLocal(utcTimestamp);
            return '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
          } catch (e) {
            // If parsing fails, return time as-is
            final parts = timeStr.split(':');
            if (parts.length >= 2) {
              return '${parts[0].padLeft(2, '0')}:${parts[1].padLeft(2, '0')}';
            }
          }
        }

        // No request_date provided, return time as-is
        final parts = timeStr.split(':');
        if (parts.length >= 2) {
          return '${parts[0].padLeft(2, '0')}:${parts[1].padLeft(2, '0')}';
        }
      }

      return timeStr;
    } catch (e) {
      // If all parsing fails, try to extract HH:mm from the string
      if (timeStr.length >= 5) {
        return timeStr.substring(0, 5);
      }
      return '--:--';
    }
  }

  /// Convert shift time string from UTC to local time
  /// Input: "14:56 ~ 17:56" (UTC), requestDate: "2025-10-27"
  /// Output: "21:56 ~ 00:56" (Local time, Vietnam = UTC+7)
  static String formatShiftTime(String? shiftTime, {String? requestDate}) {
    if (shiftTime == null || shiftTime.isEmpty) {
      return '--:-- ~ --:--';
    }

    try {
      // Parse shift time format: "14:56 ~ 17:56"
      final parts = shiftTime.split('~').map((e) => e.trim()).toList();
      if (parts.length != 2) {
        return shiftTime; // Return as-is if format is unexpected
      }

      final startTime = parts[0].trim();
      final endTime = parts[1].trim();

      // Convert each time using formatTime with requestDate
      final localStartTime = formatTime(startTime, requestDate: requestDate);
      final localEndTime = formatTime(endTime, requestDate: requestDate);

      return '$localStartTime ~ $localEndTime';
    } catch (e) {
      return shiftTime; // Return original if conversion fails
    }
  }

  /// Get color for activity status
  static Color getActivityStatusColor(String status) {
    switch (status) {
      case 'working':
        return TossColors.primary; // Blue for currently working
      case 'completed':
        return TossColors.success; // Green for completed shift
      case 'approved':
        return TossColors.success.withOpacity(0.7); // Lighter green for approved but not started
      case 'pending':
        return TossColors.warning; // Orange for pending approval
      default:
        return TossColors.gray400;
    }
  }

  /// Get text for activity status
  static String getActivityStatusText(String status) {
    switch (status) {
      case 'working':
        return 'Working';
      case 'completed':
        return 'Completed';
      case 'approved':
        return 'Approved';
      case 'pending':
        return 'Pending';
      default:
        return 'Unknown';
    }
  }

  /// ✅ Clean Architecture: Get work status text using Domain entity
  ///
  /// Accepts Map for backward compatibility, but uses Domain entity internally
  static String getWorkStatusFromCard(Map<String, dynamic> card) {
    try {
      // Convert Map to Domain entity
      final shiftCard = _mapToShiftCard(card);
      // Use Domain entity's business logic
      return shiftCard.workStatus;
    } catch (e) {
      // Fallback if conversion fails
      return 'Unknown';
    }
  }

  /// ✅ Clean Architecture: Get work status color using Domain entity
  ///
  /// UI layer responsibility: Map status to colors
  /// Business logic responsibility (Domain): Determine status
  static Color getWorkStatusColorFromCard(Map<String, dynamic> card) {
    final status = getWorkStatusFromCard(card);
    return getColorForWorkStatus(status);
  }

  /// Get color for work status string
  ///
  /// ✅ Clean Architecture: UI-only logic (color mapping)
  static Color getColorForWorkStatus(String status) {
    switch (status) {
      case 'Pending Approval':
        return TossColors.warning;
      case 'Working':
        return TossColors.primary; // Blue for working
      case 'Completed':
        return TossColors.success; // Green for completed
      case 'Approved':
        return TossColors.success.withOpacity(0.7); // Lighter green for approved
      default:
        return TossColors.gray400;
    }
  }

  /// Convert Map to ShiftCard entity
  ///
  /// ⚠️ TEMPORARY: Helper to convert Map to entity for backward compatibility
  /// TODO: Refactor calling code to use ShiftCard entities directly
  /// v5: Uses problemDetails JSONB instead of individual problem fields
  static ShiftCard _mapToShiftCard(Map<String, dynamic> map) {
    // Provide defaults for required fields
    return ShiftCard(
      requestDate: map['request_date']?.toString() ?? map['shift_date']?.toString() ?? '',
      shiftRequestId: map['shift_request_id']?.toString() ?? '',
      shiftStartTime: map['shift_start_time']?.toString() ?? '',
      shiftEndTime: map['shift_end_time']?.toString() ?? '',
      storeName: map['store_name']?.toString() ?? '',
      scheduledHours: (map['scheduled_hours'] as num?)?.toDouble() ?? 0.0,
      isApproved: map['is_approved'] as bool? ?? false,
      actualStartTime: map['actual_start_time']?.toString(),
      actualEndTime: map['actual_end_time']?.toString(),
      confirmStartTime: map['confirm_start_time']?.toString(),
      confirmEndTime: map['confirm_end_time']?.toString(),
      paidHours: (map['paid_hours'] as num?)?.toDouble() ?? 0.0,
      basePay: map['base_pay']?.toString() ?? '0',
      bonusAmount: (map['bonus_amount'] as num?)?.toDouble() ?? 0.0,
      totalPayWithBonus: map['total_pay_with_bonus']?.toString() ?? '0',
      salaryType: map['salary_type']?.toString() ?? 'hourly',
      salaryAmount: map['salary_amount']?.toString() ?? '0',
      // v5: problemDetails is null here - this helper is only for workStatus
      // Full problemDetails would require proper parsing from JSONB
      problemDetails: null,
    );
  }

  /// Format number with comma separators
  static String formatNumber(dynamic value) {
    if (value == null) return '0';
    if (value is String) {
      // Remove any existing commas and try to parse
      final cleanValue = value.replaceAll(',', '');
      final parsed = int.tryParse(cleanValue);
      if (parsed != null) {
        return parsed.toString().replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (Match m) => '${m[1]},',
        );
      }
      return value;
    }
    if (value is num) {
      return value.toInt().toString().replaceAllMapped(
        RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
        (Match m) => '${m[1]},',
      );
    }
    return value.toString();
  }

  /// Find the shift_request_id for QR scan check-in/check-out
  ///
  /// Uses unified chain detection from [ScheduleDateUtils].
  ///
  /// Logic:
  /// 1. Detect continuous chain (if any shift is in-progress)
  /// 2. CHECKOUT mode: find shift with end_time closest to now
  /// 3. CHECKIN mode: find shift with start_time closest to now
  ///
  /// [shiftCards] - List of ShiftCard entities from user_shift_cards_v7
  /// [now] - Current DateTime (optional, for testing)
  ///
  /// Returns the shift_request_id, or null if no valid shift found
  static String? findClosestShiftRequestId(
    List<ShiftCard> shiftCards, {
    DateTime? now,
  }) {
    if (shiftCards.isEmpty) return null;
    final currentTime = now ?? DateTime.now();

    // Use unified chain detection
    final chain = ScheduleDateUtils.detectContinuousChain(
      shiftCards,
      currentTime: currentTime,
    );

    // CHECKOUT MODE: Chain detected and should checkout
    if (chain.shouldCheckout) {
      final checkoutShift = ScheduleDateUtils.findClosestCheckoutShift(
        chain,
        currentTime: currentTime,
      );
      if (checkoutShift != null) {
        SentryConfig.addBreadcrumb(
          message: 'QR Checkout: ${checkoutShift.shiftRequestId}',
          category: 'qr_scan',
          data: {'mode': 'checkout', 'shift_id': checkoutShift.shiftRequestId},
        );
        return checkoutShift.shiftRequestId;
      }
    }

    // CHECKIN MODE: Find closest check-in shift
    final checkinShift = ScheduleDateUtils.findClosestCheckinShift(
      shiftCards,
      currentTime: currentTime,
    );
    if (checkinShift != null) {
      SentryConfig.addBreadcrumb(
        message: 'QR Checkin: ${checkinShift.shiftRequestId}',
        category: 'qr_scan',
        data: {'mode': 'checkin', 'shift_id': checkinShift.shiftRequestId},
      );
      return checkinShift.shiftRequestId;
    }

    // ⚠️ CRITICAL: QR scan found no valid shift - this is a potential issue
    // Could indicate data inconsistency or user scanning at wrong time
    SentryConfig.captureMessage(
      'QR Scan: No valid shift found',
      level: SentryLevel.warning,
      extra: {
        'shift_count': shiftCards.length,
        'has_approved': shiftCards.any((c) => c.isApproved),
        'has_in_progress': shiftCards.any((c) => c.isCheckedIn && !c.isCheckedOut),
        'current_time': currentTime.toIso8601String(),
      },
    );
    return null;
  }
}
