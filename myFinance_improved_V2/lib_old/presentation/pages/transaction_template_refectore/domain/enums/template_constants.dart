/// Template Constants for Refactored Version
///
/// Permission UUIDs and Visibility levels that match database schema
class TemplateConstants {
  /// Permission UUIDs - Database foreign keys
  static const String managerPermissionUUID = 'c6bc2fc2-e4fc-4893-a7ed-a1afb4202d14';
  static const String commonPermissionUUID = 'cffb000f-498b-4296-af84-4ce9bbd8bed7';
  static const String adminPermissionUUID = 'c6bc2fc2-e4fc-4893-a7ed-a1afb4202d14'; // Same as manager

  /// Visibility levels - Database varchar values (case-sensitive)
  static const String visibilityPublic = 'public';
  static const String visibilityPrivate = 'private';

  /// Convert display name to permission UUID
  static String getPermissionUUID(String displayName) {
    switch (displayName.toLowerCase()) {
      case 'manager':
      case 'admin':
        return managerPermissionUUID;
      case 'common':
      default:
        return commonPermissionUUID;
    }
  }

  /// Convert permission UUID to display name
  static String getPermissionDisplayName(String uuid) {
    switch (uuid) {
      case managerPermissionUUID:
        return 'Manager';
      case commonPermissionUUID:
        return 'Common';
      default:
        return 'Common';
    }
  }
}
