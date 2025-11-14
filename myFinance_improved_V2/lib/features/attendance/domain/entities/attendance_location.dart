/// Attendance Location Value Object
///
/// Represents GPS coordinates for check-in/check-out location.
class AttendanceLocation {
  final double latitude;
  final double longitude;

  const AttendanceLocation({
    required this.latitude,
    required this.longitude,
  });

  /// Validate if location coordinates are valid
  bool get isValid {
    return latitude >= -90 &&
           latitude <= 90 &&
           longitude >= -180 &&
           longitude <= 180;
  }

  /// Convert to PostGIS POINT format for Supabase
  String toPostGISPoint() {
    return 'POINT($longitude $latitude)';
  }

  /// Alias for backward compatibility
  String toPostGIS() => toPostGISPoint();

  /// Parse from PostGIS POINT format
  static AttendanceLocation? fromPostGIS(String? postGISString) {
    if (postGISString == null || postGISString.isEmpty) return null;

    final regex = RegExp(r'POINT\((-?\d+\.?\d*)\s+(-?\d+\.?\d*)\)');
    final match = regex.firstMatch(postGISString);
    if (match != null) {
      final lng = double.parse(match.group(1)!);
      final lat = double.parse(match.group(2)!);
      return AttendanceLocation(latitude: lat, longitude: lng);
    }

    return null;
  }

  @override
  String toString() => 'AttendanceLocation(lat: $latitude, lng: $longitude)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is AttendanceLocation &&
        other.latitude == latitude &&
        other.longitude == longitude;
  }

  @override
  int get hashCode => latitude.hashCode ^ longitude.hashCode;
}
