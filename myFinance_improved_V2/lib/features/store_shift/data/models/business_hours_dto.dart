import '../../domain/entities/business_hours.dart';

/// Business Hours DTO
///
/// Data Transfer Object for store_business_hours table.
/// Handles JSON serialization and conversion to Domain Entity.
///
/// Clean Architecture 2025:
/// - DTO는 Data 레이어에 위치
/// - JSON 직렬화 로직 포함
/// - toEntity() 메서드로 Domain Entity 변환
class BusinessHoursDto {
  final int dayOfWeek;
  final String? dayName;
  final bool isOpen;
  final String? openTime;
  final String? closeTime;
  final bool closesNextDay;

  const BusinessHoursDto({
    required this.dayOfWeek,
    this.dayName,
    required this.isOpen,
    this.openTime,
    this.closeTime,
    this.closesNextDay = false,
  });

  /// Create from JSON response (from RPC get_store_business_hours)
  factory BusinessHoursDto.fromJson(Map<String, dynamic> json) {
    return BusinessHoursDto(
      dayOfWeek: json['day_of_week'] as int,
      dayName: json['day_name'] as String?,
      isOpen: json['is_open'] as bool? ?? true,
      openTime: _parseTime(json['open_time']),
      closeTime: _parseTime(json['close_time']),
      closesNextDay: json['closes_next_day'] as bool? ?? false,
    );
  }

  /// Parse time from various formats (HH:mm:ss or HH:mm)
  static String? _parseTime(dynamic time) {
    if (time == null) return null;
    final timeStr = time.toString();
    // If format is HH:mm:ss, truncate to HH:mm
    if (timeStr.length >= 5) {
      return timeStr.substring(0, 5);
    }
    return timeStr;
  }

  /// Convert to JSON for upsert RPC
  Map<String, dynamic> toJson() {
    return {
      'day_of_week': dayOfWeek,
      'is_open': isOpen,
      'open_time': openTime,
      'close_time': closeTime,
      'closes_next_day': closesNextDay,
    };
  }

  /// Convert to Domain Entity
  BusinessHours toEntity() {
    return BusinessHours(
      dayOfWeek: dayOfWeek,
      dayName: dayName ?? BusinessHours.dayNumberToName[dayOfWeek] ?? '',
      isOpen: isOpen,
      openTime: openTime,
      closeTime: closeTime,
      closesNextDay: closesNextDay,
    );
  }

  /// Create DTO from Domain Entity (for save operations)
  factory BusinessHoursDto.fromEntity(BusinessHours entity) {
    return BusinessHoursDto(
      dayOfWeek: entity.dayOfWeek,
      dayName: entity.dayName,
      isOpen: entity.isOpen,
      openTime: entity.openTime,
      closeTime: entity.closeTime,
      closesNextDay: entity.closesNextDay,
    );
  }
}
