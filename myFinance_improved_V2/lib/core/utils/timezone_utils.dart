/// Timezone utility functions for converting between timezone formats
///
/// Provides conversion from platform timezone abbreviations (like 'KST', 'ICT')
/// to IANA timezone format (like 'Asia/Seoul', 'Asia/Ho_Chi_Minh')
class TimezoneUtils {
  TimezoneUtils._();

  /// Common timezone abbreviation to IANA mappings
  static const Map<String, String> _timezoneMap = {
    // Vietnam
    'ICT': 'Asia/Ho_Chi_Minh',
    '+07': 'Asia/Ho_Chi_Minh',
    // Korea
    'KST': 'Asia/Seoul',
    '+09': 'Asia/Seoul',
    // Japan
    'JST': 'Asia/Tokyo',
    // China
    'CST': 'Asia/Shanghai',
    '+08': 'Asia/Shanghai',
    // US Eastern
    'EST': 'America/New_York',
    'EDT': 'America/New_York',
    // US Pacific
    'PST': 'America/Los_Angeles',
    'PDT': 'America/Los_Angeles',
    // UTC/GMT
    'UTC': 'UTC',
    'GMT': 'UTC',
  };

  /// Convert timezone abbreviation to IANA timezone format
  ///
  /// If the input is already in IANA format (contains '/'), returns as-is.
  /// If the abbreviation is not found, defaults to 'Asia/Ho_Chi_Minh'.
  ///
  /// Example:
  /// ```dart
  /// TimezoneUtils.toIanaTimezone('KST'); // Returns 'Asia/Seoul'
  /// TimezoneUtils.toIanaTimezone('Asia/Tokyo'); // Returns 'Asia/Tokyo'
  /// ```
  static String toIanaTimezone(String abbreviation) {
    // If it's already IANA format (contains '/'), return as-is
    if (abbreviation.contains('/')) {
      return abbreviation;
    }

    // Try to find mapping
    return _timezoneMap[abbreviation] ?? 'Asia/Ho_Chi_Minh';
  }

  /// Get current device timezone in IANA format
  ///
  /// Uses DateTime.now().timeZoneName and converts to IANA format
  static String getCurrentIanaTimezone() {
    final abbreviation = DateTime.now().timeZoneName;
    return toIanaTimezone(abbreviation);
  }
}
