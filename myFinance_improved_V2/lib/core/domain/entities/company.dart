import 'store.dart';
import 'subscription.dart';

/// Company entity representing a business organization
///
/// Rich Domain Model with business logic and rules
class Company {
  const Company({
    required this.id,
    required this.companyName,
    required this.companyCode,
    required this.role,
    required this.stores,
    this.subscription,
  });

  final String id;
  final String companyName;
  final String companyCode;
  final UserRole role;
  final List<Store> stores;
  final Subscription? subscription;

  // ============================================================================
  // Factory Constructors
  // ============================================================================

  /// Create Company from Map
  factory Company.fromMap(Map<String, dynamic> map) {
    return Company(
      id: map['company_id'] as String,
      companyName: map['company_name'] as String,
      companyCode: map['company_code'] as String,
      role: UserRole.fromMap(map['role'] as Map<String, dynamic>),
      stores: (map['stores'] as List<dynamic>)
          .map((s) => Store.fromMap(s as Map<String, dynamic>))
          .toList(),
      subscription: map['subscription'] != null
          ? Subscription.fromMap(map['subscription'] as Map<String, dynamic>)
          : null,
    );
  }

  // ============================================================================
  // Computed Properties (Business Logic)
  // ============================================================================

  /// Check if company code is valid format
  ///
  /// Valid format: "COMP" prefix + 5 digits (e.g., "COMP12345")
  bool get hasValidCode =>
      companyCode.isNotEmpty &&
      companyCode.startsWith('COMP') &&
      companyCode.length == 9;

  /// Check if company name is long
  ///
  /// Long names may need special handling in UI
  bool get hasLongName => companyName.length > 50;

  /// Get display name for UI
  ///
  /// Truncates long names with ellipsis
  String get displayName => companyName.length > 30
      ? '${companyName.substring(0, 27)}...'
      : companyName;

  /// Get store count
  int get storeCount => stores.length;

  /// Check if company has any stores
  bool get hasStores => stores.isNotEmpty;

  /// Get first store (if exists)
  Store? get firstStore => stores.isNotEmpty ? stores.first : null;

  // ============================================================================
  // Business Methods
  // ============================================================================

  /// Find store by ID
  ///
  /// Returns null if not found
  Store? findStoreById(String storeId) {
    try {
      return stores.firstWhere((store) => store.id == storeId);
    } catch (_) {
      return null;
    }
  }

  /// Check if user has specific permission
  ///
  /// Returns true if permission exists in user's role
  bool hasPermission(String permission) {
    return role.permissions.contains(permission);
  }

  /// Check if user is owner
  ///
  /// Owner has all permissions
  bool get isOwner => role.roleName.toLowerCase() == 'owner';

  /// Check if user is admin
  bool get isAdmin => role.roleName.toLowerCase() == 'admin';

  /// Check if user can manage stores
  ///
  /// Requires 'manage_stores' permission or owner role
  bool get canManageStores =>
      isOwner || hasPermission('manage_stores');

  /// Check if user can invite members
  ///
  /// Requires 'invite_members' permission or owner role
  bool get canInviteMembers =>
      isOwner || hasPermission('invite_members');

  // ============================================================================
  // Subscription-related Methods
  // ============================================================================

  /// Get current subscription (defaults to free if null)
  Subscription get currentSubscription =>
      subscription ?? Subscription.free();

  /// Check if on free plan
  bool get isFreePlan => currentSubscription.isFree;

  /// Check if on paid plan
  bool get isPaidPlan => currentSubscription.isPaid;

  /// Check if can add more stores based on subscription
  bool get canAddStore => currentSubscription.canAddStore(storeCount);

  /// Check if can add employee based on subscription
  bool canAddEmployee(int currentEmployeeCount) =>
      currentSubscription.canAddEmployee(currentEmployeeCount);

  /// Get subscription plan name for display
  String get planDisplayName => currentSubscription.displayName;
}

class UserRole {
  const UserRole({
    required this.roleName,
    required this.permissions,
  });

  final String roleName;
  final List<String> permissions;

  /// Create UserRole from Map
  factory UserRole.fromMap(Map<String, dynamic> map) {
    return UserRole(
      roleName: map['role_name'] as String,
      permissions: (map['permissions'] as List<dynamic>)
          .map((p) => p as String)
          .toList(),
    );
  }
}