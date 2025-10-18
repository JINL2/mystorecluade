/// Core Context Types - Future Architecture Pattern
/// 
/// Purpose: Shared type definitions for cross-cutting concerns
/// - Business context types
/// - User context types  
/// - Permission types
/// - Common data structures
/// 
/// ✅ MIGRATED: Now in lib/app/core/types/context_types.dart

/// Business Context
/// 
/// Represents the current business operational context
class BusinessContext {
  final String companyId;
  final String storeId;
  final String? companyName;
  final String? storeName;
  
  const BusinessContext({
    required this.companyId,
    required this.storeId,
    this.companyName,
    this.storeName,
  });
  
  /// Check if context has required business data
  bool get isValid => companyId.isNotEmpty && storeId.isNotEmpty;
  
  /// Convert to map for backward compatibility
  Map<String, dynamic> toMap() => {
    'companyId': companyId,
    'storeId': storeId,
    'companyName': companyName,
    'storeName': storeName,
  };
  
  /// Create from map
  factory BusinessContext.fromMap(Map<String, dynamic> map) => BusinessContext(
    companyId: (map['companyId'] as String?) ?? '',
    storeId: (map['storeId'] as String?) ?? '',
    companyName: map['companyName'] as String?,
    storeName: map['storeName'] as String?,
  );
  
  @override
  bool operator ==(Object other) =>
    identical(this, other) ||
    other is BusinessContext &&
    runtimeType == other.runtimeType &&
    companyId == other.companyId &&
    storeId == other.storeId;
  
  @override
  int get hashCode => companyId.hashCode ^ storeId.hashCode;
  
  @override
  String toString() => 'BusinessContext(company: $companyId, store: $storeId)';
}

/// User Context
/// 
/// Represents the current user authentication and profile context
class UserContext {
  final String userId;
  final String? username;
  final String? email;
  final String? displayName;
  final bool isAuthenticated;
  final Map<String, dynamic> metadata;
  
  const UserContext({
    required this.userId,
    this.username,
    this.email,
    this.displayName,
    this.isAuthenticated = false,
    this.metadata = const {},
  });
  
  /// Check if user context is valid
  bool get isValid => userId.isNotEmpty && isAuthenticated;
  
  /// Get preferred display name
  String get preferredName => 
    displayName ?? username ?? email ?? 'Unknown User';
  
  /// Convert to map for backward compatibility
  Map<String, dynamic> toMap() => {
    'user_id': userId,
    'username': username,
    'email': email,
    'display_name': displayName,
    'isAuthenticated': isAuthenticated,
    ...metadata,
  };
  
  /// Create from map (legacy user format)
  factory UserContext.fromMap(Map<String, dynamic> map) => UserContext(
    userId: (map['user_id'] as String?) ?? '',
    username: map['username'] as String?,
    email: map['email'] as String?,
    displayName: map['display_name'] as String?,
    isAuthenticated: (map['isAuthenticated'] as bool?) ?? false,
    metadata: Map<String, dynamic>.from(map)..removeWhere((key, value) => 
      ['user_id', 'username', 'email', 'display_name', 'isAuthenticated'].contains(key)),
  );
  
  @override
  bool operator ==(Object other) =>
    identical(this, other) ||
    other is UserContext &&
    runtimeType == other.runtimeType &&
    userId == other.userId &&
    isAuthenticated == other.isAuthenticated;
  
  @override
  int get hashCode => userId.hashCode ^ isAuthenticated.hashCode;
  
  @override
  String toString() => 'UserContext(id: $userId, authenticated: $isAuthenticated)';
}

/// Permission Context
/// 
/// Represents user permissions and roles
class PermissionContext {
  final Set<String> permissions;
  final String? role;
  final bool hasAdminAccess;
  
  const PermissionContext({
    this.permissions = const {},
    this.role,
    this.hasAdminAccess = false,
  });
  
  /// Check if user has specific permission
  bool hasPermission(String permission) => permissions.contains(permission);
  
  /// Check if user has any of the specified permissions
  bool hasAnyPermission(List<String> permissionList) =>
    permissionList.any((p) => permissions.contains(p));
  
  /// Check if user has all of the specified permissions
  bool hasAllPermissions(List<String> permissionList) =>
    permissionList.every((p) => permissions.contains(p));
  
  /// Common permission checks
  bool get canCreateTemplates => hasPermission('create_templates') || hasAdminAccess;
  bool get canDeleteTemplates => hasPermission('delete_templates') || hasAdminAccess;
  bool get canManageUsers => hasPermission('manage_users') || hasAdminAccess;
  bool get canViewReports => hasPermission('view_reports') || hasAdminAccess;
  
  /// Convert to map
  Map<String, dynamic> toMap() => {
    'permissions': permissions.toList(),
    'role': role,
    'hasAdminAccess': hasAdminAccess,
  };
  
  /// Create from map
  factory PermissionContext.fromMap(Map<String, dynamic> map) => PermissionContext(
    permissions: Set<String>.from((map['permissions'] as List<dynamic>?) ?? <String>[]),
    role: map['role'] as String?,
    hasAdminAccess: (map['hasAdminAccess'] as bool?) ?? false,
  );
  
  @override
  bool operator ==(Object other) =>
    identical(this, other) ||
    other is PermissionContext &&
    runtimeType == other.runtimeType &&
    permissions == other.permissions &&
    role == other.role &&
    hasAdminAccess == other.hasAdminAccess;
  
  @override
  int get hashCode => 
    permissions.hashCode ^ role.hashCode ^ hasAdminAccess.hashCode;
  
  @override
  String toString() => 'PermissionContext(role: $role, permissions: ${permissions.length})';
}

/// App Context
/// 
/// Complete application context combining all context types
class AppContext {
  final UserContext user;
  final BusinessContext business;
  final PermissionContext permissions;
  final DateTime timestamp;
  
  AppContext({
    required this.user,
    required this.business,
    required this.permissions,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();
  
  /// Check if all required context is available
  bool get isComplete => user.isValid && business.isValid;
  
  /// Check if context is ready for business operations
  bool get isReadyForBusiness => isComplete && user.isAuthenticated;
  
  /// Get complete context as map (for legacy compatibility)
  Map<String, dynamic> toMap() => {
    'user': user.toMap(),
    'business': business.toMap(),
    'permissions': permissions.toMap(),
    'timestamp': timestamp.toIso8601String(),
  };
  
  /// Create from legacy app state format
  factory AppContext.fromLegacyAppState(Map<String, dynamic> appState) {
    return AppContext(
      user: UserContext.fromMap((appState['user'] as Map<String, dynamic>?) ?? <String, dynamic>{}),
      business: BusinessContext(
        companyId: (appState['companyChoosen'] as String?) ?? '',
        storeId: (appState['storeChoosen'] as String?) ?? '',
        companyName: appState['companyName'] as String?,
        storeName: appState['storeName'] as String?,
      ),
      permissions: PermissionContext(
        permissions: Set<String>.from((appState['permissions'] as List<dynamic>?) ?? <String>[]),
        hasAdminAccess: (appState['hasAdminPermission'] as bool?) ?? false,
      ),
      timestamp: DateTime.now(),
    );
  }
  
  @override
  bool operator ==(Object other) =>
    identical(this, other) ||
    other is AppContext &&
    runtimeType == other.runtimeType &&
    user == other.user &&
    business == other.business &&
    permissions == other.permissions;
  
  @override
  int get hashCode => user.hashCode ^ business.hashCode ^ permissions.hashCode;
  
  @override
  String toString() => 'AppContext(user: ${user.userId}, company: ${business.companyId})';
}