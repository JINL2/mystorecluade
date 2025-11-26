// lib/features/cash_ending/presentation/extensions/stock_flow_presentation_extension.dart

import '../../../../core/utils/datetime_utils.dart';
import '../../domain/entities/stock_flow.dart';

/// Presentation extension for ActualFlow entity
///
/// This extension provides UI-specific formatting methods
/// Domain entities should remain pure without presentation concerns
extension ActualFlowPresentation on ActualFlow {
  /// Parse DateTime from createdAt - simplified single-pass parsing
  /// Returns null if parsing fails
  DateTime? _parseDateTime() {
    try {
      // Try parsing with Z suffix first (UTC format from DB)
      return DateTime.parse('${createdAt}Z');
    } catch (e) {
      try {
        // Fallback to regular ISO 8601 parsing
        return DateTime.parse(createdAt);
      } catch (e2) {
        return null;
      }
    }
  }

  /// Get local DateTime for display
  /// Returns null if parsing fails
  DateTime? _getLocalDateTime() {
    final parsed = _parseDateTime();
    if (parsed != null) return parsed.toLocal();

    // Fallback to DateTimeUtils
    try {
      return DateTimeUtils.toLocal(createdAt);
    } catch (e) {
      return null;
    }
  }

  /// Get formatted date for UI display (e.g., "25/11")
  String getFormattedDate() {
    final date = _parseDateTime();
    if (date == null) return createdAt;
    return '${date.day}/${date.month}';
  }

  /// Get formatted time for UI display (e.g., "14:30")
  String getFormattedTime() {
    final localDate = _getLocalDateTime();
    if (localDate == null) return '';
    return DateTimeUtils.formatTimeOnly(localDate);
  }

  /// Get full formatted datetime (e.g., "25/11 14:30")
  String getFormattedDateTime() {
    final date = getFormattedDate();
    final time = getFormattedTime();
    if (time.isEmpty) return date;
    return '$date $time';
  }
}
