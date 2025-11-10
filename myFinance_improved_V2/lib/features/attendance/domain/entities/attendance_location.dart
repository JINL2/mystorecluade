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
  ///
  /// Latitude must be between -90 and 90
  /// Longitude must be between -180 and 180
  bool get isValid {
    return latitude >= -90 &&
           latitude <= 90 &&
           longitude >= -180 &&
           longitude <= 180;
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
