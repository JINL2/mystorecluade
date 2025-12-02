import 'package:intl/intl.dart';

/// DateTime utility for consistent timezone handling across the app
///
/// **핵심 원칙:**
/// - DB에는 항상 UTC로 저장
/// - 화면에는 항상 로컬 시간으로 표시
/// - 날짜만 필요한 경우 타임존 변환 안 함
///
/// **사용 예시:**
/// ```dart
/// // 저장
/// await supabase.insert({
///   'created_at': DateTimeUtils.toUtc(DateTime.now())
/// });
///
/// // 읽기
/// final data = await supabase.select();
/// final createdAt = DateTimeUtils.toLocal(data['created_at']);
/// ```
class DateTimeUtils {

  /// Converts DateTime to UTC ISO8601 string for database storage
  ///
  /// Example:
  /// ```dart
  /// final now = DateTime.now(); // 2025-01-15 14:30:00 (KST +9)
  /// DateTimeUtils.toUtc(now);   // "2025-01-15T05:30:00.000Z" (UTC)
  /// ```
  static String toUtc(DateTime dateTime) {
    return dateTime.toUtc().toIso8601String();
  }

  /// Returns current time as UTC ISO8601 string
  ///
  /// Example:
  /// ```dart
  /// await supabase.insert({
  ///   'created_at': DateTimeUtils.nowUtc()
  /// });
  /// ```
  static String nowUtc() {
    return DateTime.now().toUtc().toIso8601String();
  }

  /// Converts UTC string from database to local DateTime
  ///
  /// Handles both:
  /// - ISO 8601 with timezone: "2025-01-15T05:30:00.000Z"
  /// - Timestamp without timezone: "2025-10-27 17:54:41.715" (treats as UTC)
  ///
  /// Example:
  /// ```dart
  /// final utcString1 = "2025-01-15T05:30:00.000Z"; // ISO 8601 UTC
  /// final utcString2 = "2025-10-27 17:54:41.715"; // timestamp without timezone
  /// final local1 = DateTimeUtils.toLocal(utcString1);
  /// final local2 = DateTimeUtils.toLocal(utcString2);
  /// // Both converted to local time correctly
  /// ```
  ///
  /// Throws FormatException if string is invalid
  static DateTime toLocal(String utcString) {
    // Handle empty string
    if (utcString.isEmpty) {
      throw const FormatException('Cannot parse empty string as DateTime');
    }

    try {
      // If string doesn't contain timezone info (no Z, +, or -), add Z to force UTC parsing
      if (!utcString.contains('Z') &&
          !utcString.contains('+') &&
          !utcString.contains('-', utcString.length - 6)) {
        // Replace space with T for ISO 8601 format, then add Z
        final isoFormat = utcString.replaceFirst(' ', 'T');
        final result = DateTime.parse('${isoFormat}Z').toLocal();
        return result;
      }
      final result = DateTime.parse(utcString).toLocal();
      return result;
    } catch (e) {
      // Fallback: Remove timezone offset and treat as UTC
      try {
        // Remove any timezone offset (e.g., +00:00, -06:00, etc.)
        final cleanString = utcString
            .replaceAll(RegExp(r'[+-]\d{2}:\d{2}$'), '')
            .replaceAll('Z', '')
            .replaceFirst(' ', 'T');

        if (cleanString.isEmpty) {
          throw const FormatException('String became empty after cleaning');
        }

        final result = DateTime.parse('${cleanString}Z').toLocal();
        return result;
      } catch (fallbackError) {
        rethrow;
      }
    }
  }

  /// Safely converts UTC string to local DateTime (null-safe version)
  ///
  /// Handles both:
  /// - ISO 8601 with timezone: "2025-01-15T05:30:00.000Z"
  /// - Timestamp without timezone: "2025-10-27 17:54:41.715" (treats as UTC)
  ///
  /// Returns null if:
  /// - Input is null
  /// - Input is empty string
  /// - Parsing fails
  ///
  /// Example:
  /// ```dart
  /// final date = DateTimeUtils.toLocalSafe(json['updated_at']);
  /// if (date != null) {
  ///   print('Updated: ${DateTimeUtils.format(date)}');
  /// }
  /// ```
  static DateTime? toLocalSafe(String? utcString) {
    if (utcString == null || utcString.isEmpty) return null;
    try {
      return toLocal(utcString);
    } catch (e) {
      return null;
    }
  }

  /// Converts DateTime to date-only string (yyyy-MM-dd)
  ///
  /// **중요:** 타임존 변환을 하지 않습니다!
  /// 날짜만 필요한 경우 사용하세요 (예: 생일, 계약일)
  ///
  /// Example:
  /// ```dart
  /// final birthday = DateTime(1990, 5, 15);
  /// DateTimeUtils.toDateOnly(birthday); // "1990-05-15"
  ///
  /// // ❌ 이렇게 하면 날짜가 바뀔 수 있음:
  /// birthday.toUtc().toIso8601String().split('T')[0];
  ///
  /// // ✅ 이렇게 해야 함:
  /// DateTimeUtils.toDateOnly(birthday);
  /// ```
  static String toDateOnly(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  /// Converts DateTime to Supabase RPC format (yyyy-MM-dd HH:mm:ss in UTC)
  ///
  /// Supabase의 일부 RPC 함수는 특정 포맷을 요구합니다.
  /// 이 함수는 UTC로 변환 후 RPC 포맷으로 변환합니다.
  ///
  /// Example:
  /// ```dart
  /// final now = DateTime.now(); // 2025-01-15 14:30:00 (KST +9)
  /// DateTimeUtils.toRpcFormat(now); // "2025-01-15 05:30:00" (UTC)
  ///
  /// await supabase.rpc('insert_cashier_amount_lines', {
  ///   'p_created_at': DateTimeUtils.toRpcFormat(DateTime.now())
  /// });
  /// ```
  static String toRpcFormat(DateTime dateTime) {
    final utc = dateTime.toUtc();
    return utc.toIso8601String().replaceFirst('T', ' ').split('.')[0];
  }

  /// Formats DateTime for display on screen (yyyy-MM-dd HH:mm)
  ///
  /// **로컬 시간**으로 표시됩니다.
  ///
  /// Example:
  /// ```dart
  /// final utcString = "2025-01-15T05:30:00.000Z"; // from DB
  /// final local = DateTimeUtils.toLocal(utcString);
  /// print(DateTimeUtils.format(local));
  /// // Korea: "2025-01-15 14:30"
  /// // Vietnam: "2025-01-15 12:30"
  /// ```
  static String format(DateTime dateTime) {
    return '${dateTime.year}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')} ${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }

  /// Formats DateTime with custom pattern using intl package
  ///
  /// Example:
  /// ```dart
  /// final now = DateTime.now();
  /// DateTimeUtils.formatCustom(now, 'yyyy년 MM월 dd일'); // "2025년 01월 15일"
  /// DateTimeUtils.formatCustom(now, 'MMM dd, yyyy'); // "Jan 15, 2025"
  /// DateTimeUtils.formatCustom(now, 'HH:mm:ss'); // "14:30:00"
  /// ```
  static String formatCustom(DateTime dateTime, String pattern) {
    final formatter = DateFormat(pattern);
    return formatter.format(dateTime);
  }

  /// Formats date-only display (yyyy-MM-dd)
  ///
  /// Example:
  /// ```dart
  /// final date = DateTime.now();
  /// DateTimeUtils.formatDateOnly(date); // "2025-01-15"
  /// ```
  static String formatDateOnly(DateTime dateTime) {
    return toDateOnly(dateTime);
  }

  /// Formats time-only display (HH:mm)
  ///
  /// Example:
  /// ```dart
  /// final time = DateTime.now();
  /// DateTimeUtils.formatTimeOnly(time); // "14:30"
  /// ```
  static String formatTimeOnly(DateTime dateTime) {
    return '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }

  /// Converts DateTime to ISO 8601 string with local timezone offset
  ///
  /// This format includes the timezone offset to preserve exact moment in time
  /// while maintaining the local time representation.
  ///
  /// Format: "yyyy-MM-ddTHH:mm:ss+HH:mm" (e.g., "2024-11-15T10:30:25+07:00")
  ///
  /// Example:
  /// ```dart
  /// final now = DateTime.now(); // 2025-01-15 14:30:25 (KST +9)
  /// DateTimeUtils.toLocalWithOffset(now); // "2025-01-15T14:30:25+09:00"
  ///
  /// // Vietnam time
  /// final vietnamTime = DateTime.now(); // 2024-11-15 10:30:25 (ICT +7)
  /// DateTimeUtils.toLocalWithOffset(vietnamTime); // "2024-11-15T10:30:25+07:00"
  ///
  /// // For RPC calls
  /// await supabase.rpc('user_shift_overview_v3', {
  ///   'p_request_time': DateTimeUtils.toLocalWithOffset(DateTime.now())
  /// });
  /// ```
  static String toLocalWithOffset(DateTime dateTime) {
    // Get timezone offset
    final offset = dateTime.timeZoneOffset;
    final hours = offset.inHours;
    final minutes = offset.inMinutes.remainder(60);

    // Format offset as +HH:mm or -HH:mm
    final sign = hours >= 0 ? '+' : '-';
    final absHours = hours.abs().toString().padLeft(2, '0');
    final absMinutes = minutes.abs().toString().padLeft(2, '0');
    final offsetString = '$sign$absHours:$absMinutes';

    // Format datetime as ISO 8601 with offset
    final year = dateTime.year.toString();
    final month = dateTime.month.toString().padLeft(2, '0');
    final day = dateTime.day.toString().padLeft(2, '0');
    final hour = dateTime.hour.toString().padLeft(2, '0');
    final minute = dateTime.minute.toString().padLeft(2, '0');
    final second = dateTime.second.toString().padLeft(2, '0');

    return '$year-$month-${day}T$hour:$minute:$second$offsetString';
  }

  /// Formats current local DateTime as 'yyyy-MM-dd HH:mm:ss' string
  ///
  /// This format is commonly required by Supabase RPC functions
  /// that need local time with timezone parameter.
  ///
  /// Example:
  /// ```dart
  /// final localTime = DateTimeUtils.formatLocalTimestamp();
  /// // "2025-01-15 14:30:25"
  ///
  /// await supabase.rpc('create_store_shift', {
  ///   'p_time': localTime,
  ///   'p_timezone': DateTimeUtils.getLocalTimezone(),
  /// });
  /// ```
  static String formatLocalTimestamp([DateTime? dateTime]) {
    final now = dateTime ?? DateTime.now();
    return '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')} '
        '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}:${now.second.toString().padLeft(2, '0')}';
  }

  /// Gets the user's local timezone in IANA format (e.g., "Asia/Seoul", "Asia/Ho_Chi_Minh")
  ///
  /// This timezone string is used for RPC functions that need to handle timezone-aware calculations.
  /// Since Dart doesn't provide direct access to IANA timezone names, we derive it from the offset.
  ///
  /// **Note**: This is a best-effort approximation. Multiple timezones can share the same offset.
  /// For production, consider using platform-specific APIs or a timezone package.
  ///
  /// Example:
  /// ```dart
  /// final timezone = DateTimeUtils.getLocalTimezone();
  /// // Korea (UTC+9): "Asia/Seoul"
  /// // Vietnam (UTC+7): "Asia/Ho_Chi_Minh"
  /// // UTC: "UTC"
  ///
  /// await supabase.rpc('user_shift_overview_v3', {
  ///   'p_timezone': timezone,
  /// });
  /// ```
  static String getLocalTimezone() {
    final now = DateTime.now();
    final offset = now.timeZoneOffset;

    // Get timezone name from DateTime
    final timeZoneName = now.timeZoneName;

    // If timezone name is available and not just an offset, use it
    if (timeZoneName.isNotEmpty && !timeZoneName.contains('+') && !timeZoneName.contains('-')) {
      // Common timezone abbreviations to IANA mapping
      const timezoneMap = {
        'KST': 'Asia/Seoul',
        'JST': 'Asia/Tokyo',
        'ICT': 'Asia/Ho_Chi_Minh',
        'CST': 'Asia/Shanghai',
        'PST': 'America/Los_Angeles',
        'EST': 'America/New_York',
        'GMT': 'Europe/London',
        'UTC': 'UTC',
      };

      if (timezoneMap.containsKey(timeZoneName)) {
        return timezoneMap[timeZoneName]!;
      }
    }

    // Fallback: Map offset to most common timezone
    // This is not perfect but works for most cases
    final hours = offset.inHours;
    final minutes = offset.inMinutes.remainder(60);

    // Format: +HH:MM or -HH:MM
    final sign = hours >= 0 ? '+' : '-';
    final absHours = hours.abs().toString().padLeft(2, '0');
    final absMinutes = minutes.abs().toString().padLeft(2, '0');

    // Map common offsets to IANA timezones
    const offsetToTimezone = {
      '+09:00': 'Asia/Seoul',      // Korea, Japan
      '+08:00': 'Asia/Shanghai',   // China, Singapore
      '+07:00': 'Asia/Ho_Chi_Minh', // Vietnam, Thailand
      '+05:30': 'Asia/Kolkata',    // India
      '+00:00': 'UTC',             // UTC
      '-05:00': 'America/New_York', // US Eastern
      '-08:00': 'America/Los_Angeles', // US Pacific
    };

    final offsetString = '$sign$absHours:$absMinutes';
    return offsetToTimezone[offsetString] ?? 'UTC';
  }
}
