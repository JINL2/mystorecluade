import 'package:geolocator/geolocator.dart';

class LocationUtils {
  /// Extract latitude or longitude from Position
  static double? extractLatLng(Position? location, bool isLatitude) {
    if (location == null) return null;
    return isLatitude ? location.latitude : location.longitude;
  }

  /// Get latitude from Position
  static double? getLatitude(Position? location) {
    return location?.latitude;
  }

  /// Get longitude from Position  
  static double? getLongitude(Position? location) {
    return location?.longitude;
  }
  
  /// Check if location services are enabled and permissions granted
  static Future<bool> checkLocationPermissions() async {
    try {
      // Check if location services are enabled
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        return false;
      }

      // Check location permissions
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          return false;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        return false;
      }

      return true;
    } catch (e) {
      return false;
    }
  }
  
  /// Get current location with proper error handling
  static Future<Position?> getCurrentLocation() async {
    try {
      final hasPermission = await checkLocationPermissions();
      if (!hasPermission) {
        return null;
      }
      
      return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: const Duration(seconds: 10),
      );
    } catch (e) {
      print('Error getting location: $e');
      return null;
    }
  }
}