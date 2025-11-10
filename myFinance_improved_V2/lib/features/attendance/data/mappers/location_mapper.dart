import '../../domain/entities/attendance_location.dart';

/// Location Mapper Extension
///
/// Converts AttendanceLocation domain entity to database-specific formats.
/// This keeps domain entities independent from infrastructure concerns.
extension AttendanceLocationMapper on AttendanceLocation {
  /// Convert to PostGIS POINT format for Supabase
  ///
  /// PostGIS uses WKT (Well-Known Text) format: POINT(longitude latitude)
  /// Note: PostGIS uses longitude first, then latitude
  String toPostGISPoint() {
    return 'POINT($longitude $latitude)';
  }
}

/// Location Parser
///
/// Parses database-specific location formats to domain entities.
class LocationParser {
  LocationParser._();

  /// Parse PostGIS POINT to AttendanceLocation
  ///
  /// Handles PostGIS WKT format: "POINT(lng lat)"
  static AttendanceLocation? fromPostGISPoint(dynamic locationData) {
    if (locationData == null) return null;

    // Handle PostGIS POINT format: "POINT(lng lat)"
    if (locationData is String) {
      final regex = RegExp(r'POINT\((-?\d+\.?\d*)\s+(-?\d+\.?\d*)\)');
      final match = regex.firstMatch(locationData);
      if (match != null) {
        final lng = double.parse(match.group(1)!);
        final lat = double.parse(match.group(2)!);
        return AttendanceLocation(latitude: lat, longitude: lng);
      }
    }

    return null;
  }
}
