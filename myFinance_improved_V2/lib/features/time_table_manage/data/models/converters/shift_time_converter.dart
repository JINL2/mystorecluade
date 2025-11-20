import 'package:freezed_annotation/freezed_annotation.dart';

/// Converter for shift_time field from RPC
///
/// RPC returns: "09:00-17:00" or "14:30-22:00"
/// Parses into structured ShiftTime object
class ShiftTimeConverter implements JsonConverter<ShiftTime?, String?> {
  const ShiftTimeConverter();

  @override
  ShiftTime? fromJson(String? json) {
    if (json == null || json.isEmpty || !json.contains('-')) {
      return null;
    }

    try {
      final parts = json.split('-');
      if (parts.length != 2) return null;

      return ShiftTime(
        startTime: parts[0].trim(),
        endTime: parts[1].trim(),
      );
    } catch (e) {
      return null;
    }
  }

  @override
  String? toJson(ShiftTime? object) {
    if (object == null) return null;
    return '${object.startTime}-${object.endTime}';
  }
}

/// Shift Time Value Object
///
/// Represents parsed shift time from RPC response
class ShiftTime {
  final String startTime; // HH:MM format
  final String endTime; // HH:MM format

  const ShiftTime({
    required this.startTime,
    required this.endTime,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ShiftTime &&
          runtimeType == other.runtimeType &&
          startTime == other.startTime &&
          endTime == other.endTime;

  @override
  int get hashCode => startTime.hashCode ^ endTime.hashCode;

  @override
  String toString() => '$startTime-$endTime';
}
