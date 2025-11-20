/// Permission Constants - Domain Layer
///
/// Purpose: Single source of truth for permission identifiers
///
/// This file contains all permission-related constants used throughout
/// the transaction template feature. Permissions are stored as UUIDs
/// in the database and mapped to semantic names here.
///
/// Architecture Notes:
/// - Domain layer constant (no external dependencies)
/// - Used by Application and Presentation layers
/// - Prevents hardcoded UUIDs scattered across codebase
/// - Enables compile-time checking and IDE autocomplete
///
/// Database Structure:
/// - Permissions stored as UUID arrays in user.companies[].role.permissions
/// - Each UUID corresponds to a specific permission capability
/// - Permission IDs are immutable and version-controlled
library;

/// Permission Identifiers
///
/// Contains UUID mappings for all permissions in the system.
/// UUIDs must match the database permission_id values exactly.
class PermissionIds {
  // Private constructor to prevent instantiation
  PermissionIds._();

  // =============================================================================
  // Admin & Management Permissions
  // =============================================================================

  /// Admin permission - Full template management capabilities
  ///
  /// Grants access to:
  /// - Delete any template (including others' templates)
  /// - View admin-only templates tab
  /// - Modify system-level template settings
  /// - Manage template permissions for other users
  static const String adminPermission = 'c6bc2fc2-e4fc-4893-a7ed-a1afb4202d14';

  // =============================================================================
  // Template CRUD Permissions
  // =============================================================================

  /// Create template permission
  ///
  /// Allows user to create new transaction templates
  /// Note: This is a placeholder - actual UUID needs to be determined from DB
  static const String createTemplate = 'create_template'; // TODO: Replace with actual UUID

  /// Modify template permission
  ///
  /// Allows user to edit their own templates
  static const String modifyTemplate = 'modify_template'; // TODO: Replace with actual UUID

  /// Delete template permission
  ///
  /// Allows user to delete their own templates (not others')
  static const String deleteTemplate = 'delete_template'; // TODO: Replace with actual UUID

  // =============================================================================
  // Template Visibility Permissions
  // =============================================================================

  /// Create public template permission
  ///
  /// Allows user to create templates visible to all company users
  static const String createPublicTemplate = 'create_public_template'; // TODO: Replace with actual UUID

  /// Create manager template permission
  ///
  /// Allows user to create templates restricted to managers
  static const String createManagerTemplate = 'create_manager_template'; // TODO: Replace with actual UUID

  // =============================================================================
  // Transaction Permissions
  // =============================================================================

  /// Create transaction permission
  ///
  /// Allows user to create transactions from templates
  static const String createTransaction = 'create_transaction'; // TODO: Replace with actual UUID

  /// Create high-value transaction permission
  ///
  /// Allows user to create transactions above certain threshold
  static const String createHighValueTransaction = 'create_high_value_transaction'; // TODO: Replace with actual UUID

  // =============================================================================
  // Permission Name Mappings (UUID → Semantic Name)
  // =============================================================================

  /// Map of UUID to human-readable permission names
  ///
  /// This allows reverse lookup: given a UUID, get its semantic name.
  /// Useful for debugging, logging, and error messages.
  static const Map<String, String> idToName = {
    adminPermission: 'admin_permission',
    // TODO: Add other permission mappings as UUIDs are confirmed
  };

  /// Map of semantic names to UUIDs
  ///
  /// This allows forward lookup: given a name, get its UUID.
  /// Useful for permission checks using readable names.
  static const Map<String, String> nameToId = {
    'admin_permission': adminPermission,
    // TODO: Add other permission mappings as UUIDs are confirmed
  };

  // =============================================================================
  // Helper Methods
  // =============================================================================

  /// Check if a permission ID is valid
  ///
  /// Returns true if the UUID is a recognized permission ID
  static bool isValidPermissionId(String permissionId) {
    return idToName.containsKey(permissionId);
  }

  /// Get semantic name for a permission UUID
  ///
  /// Returns the human-readable name for a UUID, or null if not found
  static String? getPermissionName(String permissionId) {
    return idToName[permissionId];
  }

  /// Get permission UUID for a semantic name
  ///
  /// Returns the UUID for a name, or null if not found
  static String? getPermissionId(String permissionName) {
    return nameToId[permissionName];
  }

  // =============================================================================
  // All Known Permission IDs (from logs)
  // =============================================================================

  /// Complete list of permission UUIDs extracted from database logs
  ///
  /// This serves as documentation of all permissions in the system.
  /// Some permissions may not have semantic names assigned yet.
  ///
  /// Source: Flutter debug logs from user.companies[].role.permissions
  static const List<String> allKnownPermissionIds = [
    '069fc24c-915b-43a0-8c27-6872badfc4a1',
    '0808e763-51a0-4f88-b470-f552e4a90113',
    '0c9eb544-2640-46e6-a2a1-46a0ee0992da',
    '247a7896-ea5c-49b7-afec-94b500093cd4',
    '4a0c90b6-7099-4d76-88b2-783302e1248f',
    '4ce4fdcf-3865-47ea-ba86-7ee31e8f798a',
    '4f64a0a0-fd1f-4e07-a374-1efdc2540484',
    '57b2972a-d2d4-478e-ab10-83e1f429b94b',
    '582171a8-6a92-42e7-99ed-f8233169a652',
    '58fddce6-6b45-4735-8c59-9d80ccc1928e',
    '5f622ea0-ede7-4b24-a203-92d5c9f31a6b',
    '6e527ba2-9421-4243-a0f9-2497f5ed9772',
    '7b767def-41bb-420c-a548-807e4336e738',
    '7e1fd11a-f632-427d-aefc-8b3dd6734faa',
    '8763e044-fa60-4346-a60e-908dab2be3fd',
    '87e1d185-ce07-4010-b1c6-0ae39a4195fe',
    '95310d59-24ae-4d8b-9474-c536ed8b0584',
    '98cc610a-9dff-4276-91f2-d900cdf00ba7',
    'ab18cd24-ed74-4df9-9e7b-6c88e616ba4e',
    'aef426a2-c50a-4ce2-aee9-c6509cfbd571',
    'b478a1ca-ba8e-4b55-949a-053f44ea2e36',
    'b5affc71-32e5-481b-932a-77a743253ddc',
    'bdd46e64-5a59-4001-b70f-b9f4b23da33d',
    adminPermission, // c6bc2fc2-e4fc-4893-a7ed-a1afb4202d14
    'ced86713-e046-457a-b3c9-775304b31557',
    // More UUIDs may exist - update as discovered
  ];
}

/// Permission Check Helper
///
/// Provides convenient methods for permission checking.
/// Reduces boilerplate and makes permission logic more readable.
class PermissionChecker {
  // Private constructor
  PermissionChecker._();

  /// Check if user has admin permission
  ///
  /// Returns true if the permission set contains the admin UUID
  static bool hasAdminPermission(Set<String> permissions) {
    return permissions.contains(PermissionIds.adminPermission);
  }

  /// Check if user has a specific permission by UUID
  ///
  /// Returns true if the permission set contains the given UUID
  static bool hasPermission(Set<String> permissions, String permissionId) {
    return permissions.contains(permissionId);
  }

  /// Check if user has a permission by semantic name
  ///
  /// Looks up the UUID from the name and checks if present
  /// Returns false if the name is not recognized
  static bool hasPermissionByName(Set<String> permissions, String permissionName) {
    final permissionId = PermissionIds.getPermissionId(permissionName);
    if (permissionId == null) return false;
    return permissions.contains(permissionId);
  }

  /// Get all permission names for a user
  ///
  /// Converts a set of UUIDs to their semantic names
  /// Unknown UUIDs are returned as-is
  static Set<String> getPermissionNames(Set<String> permissions) {
    return permissions.map((id) {
      return PermissionIds.getPermissionName(id) ?? id;
    }).toSet();
  }
}
