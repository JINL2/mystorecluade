import 'package:flutter/material.dart';

/// Helper: Parse time string to TimeOfDay from timetz format
///
/// **중요:** DB에 저장된 timetz 값을 파싱합니다.
/// 예: "14:00:00+09:00" → TimeOfDay(14, 0)
/// PostgreSQL은 timetz를 클라이언트 타임존으로 자동 변환하여 반환합니다.
TimeOfDay? parseTimeString(String timeString) {
  try {
    // Remove timezone offset if present (e.g., "14:00:00+09:00" → "14:00:00")
    String cleanedTime = timeString;
    if (timeString.contains('+') || timeString.contains('-')) {
      // Find the position of timezone offset
      final plusIndex = timeString.indexOf('+');
      final minusIndex = timeString.lastIndexOf('-');
      final offsetIndex = plusIndex != -1 ? plusIndex : minusIndex;

      if (offsetIndex > 0) {
        cleanedTime = timeString.substring(0, offsetIndex);
      }
    }

    // Parse "HH:mm" or "HH:mm:ss" format
    final parts = cleanedTime.split(':');
    if (parts.length >= 2) {
      final hour = int.parse(parts[0]);
      final minute = int.parse(parts[1]);

      // Return as TimeOfDay (already in local timezone from DB)
      return TimeOfDay(hour: hour, minute: minute);
    }
  } catch (e) {
    // Return null if parsing fails
  }
  return null;
}

/// Helper: Format TimeOfDay to "HH:mm" string (local time only)
///
/// **중요:** RPC 함수가 타임존을 별도 파라미터로 받으므로 시간만 전달합니다.
/// 예: 7:00 AM 선택 → "07:00"
/// RPC에서 p_timezone과 함께 UTC로 변환됩니다.
String formatTimeOfDay(TimeOfDay time) {
  final hour = time.hour.toString().padLeft(2, '0');
  final minute = time.minute.toString().padLeft(2, '0');

  return '$hour:$minute';
}

/// Helper: Calculate duration between start and end times
String calculateDuration(TimeOfDay start, TimeOfDay end) {
  int startMinutes = start.hour * 60 + start.minute;
  int endMinutes = end.hour * 60 + end.minute;

  // Handle overnight shifts
  if (endMinutes < startMinutes) {
    endMinutes += 24 * 60;
  }

  int durationMinutes = endMinutes - startMinutes;
  int hours = durationMinutes ~/ 60;
  int minutes = durationMinutes % 60;

  if (minutes == 0) {
    return '$hours hours';
  }
  return '$hours hours $minutes minutes';
}
