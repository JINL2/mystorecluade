// lib/features/delegate_role/domain/value_objects/role_priority.dart

/// Role Priority Value Object
///
/// Encapsulates business logic for role priority ordering.
/// Owner > Manager > Employee > Custom roles
///
/// Previously in data source (lines 298-317), now properly in domain layer.
class RolePriority {
  /// Priority values for standard roles (lower number = higher priority)
  static const Map<String, int> _standardPriorities = {
    'owner': 1,
    'manager': 2,
    'employee': 3,
  };

  /// Default priority for custom roles
  static const int _customRolePriority = 10;

  /// Get priority value for a role name
  /// Lower number = higher priority
  static int getPriority(String roleName) {
    final normalized = roleName.toLowerCase().trim();
    return _standardPriorities[normalized] ?? _customRolePriority;
  }

  /// Compare two role names by priority
  /// Returns negative if roleA has higher priority
  /// Returns positive if roleB has higher priority
  /// Returns 0 if equal priority
  static int compare(String roleA, String roleB) {
    return getPriority(roleA).compareTo(getPriority(roleB));
  }

  /// Get the highest priority role from a list
  /// Returns null if the list is empty
  static String? getHighestPriority(List<String> roleNames) {
    if (roleNames.isEmpty) return null;

    String highest = roleNames.first;
    int highestPriority = getPriority(highest);

    for (final role in roleNames.skip(1)) {
      final priority = getPriority(role);
      if (priority < highestPriority) {
        highest = role;
        highestPriority = priority;
      }
    }

    return highest;
  }

  /// Check if a role is a standard role (Owner, Manager, Employee)
  static bool isStandardRole(String roleName) {
    return _standardPriorities.containsKey(roleName.toLowerCase().trim());
  }

  /// Check if roleA has higher priority than roleB
  static bool hasHigherPriority(String roleA, String roleB) {
    return compare(roleA, roleB) < 0;
  }

  /// Check if role is Owner
  static bool isOwner(String roleName) {
    return roleName.toLowerCase().trim() == 'owner';
  }

  /// Check if role is Manager
  static bool isManager(String roleName) {
    return roleName.toLowerCase().trim() == 'manager';
  }

  /// Check if role is Employee
  static bool isEmployee(String roleName) {
    return roleName.toLowerCase().trim() == 'employee';
  }
}
