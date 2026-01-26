// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'role_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$allCompanyRolesHash() => r'fccd6bc9a453ca885da8fc99e0738ada142fa917';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

/// Get all company roles
///
/// Copied from [allCompanyRoles].
@ProviderFor(allCompanyRoles)
const allCompanyRolesProvider = AllCompanyRolesFamily();

/// Get all company roles
///
/// Copied from [allCompanyRoles].
class AllCompanyRolesFamily extends Family<AsyncValue<List<Role>>> {
  /// Get all company roles
  ///
  /// Copied from [allCompanyRoles].
  const AllCompanyRolesFamily();

  /// Get all company roles
  ///
  /// Copied from [allCompanyRoles].
  AllCompanyRolesProvider call(
    CompanyRolesParams params,
  ) {
    return AllCompanyRolesProvider(
      params,
    );
  }

  @override
  AllCompanyRolesProvider getProviderOverride(
    covariant AllCompanyRolesProvider provider,
  ) {
    return call(
      provider.params,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'allCompanyRolesProvider';
}

/// Get all company roles
///
/// Copied from [allCompanyRoles].
class AllCompanyRolesProvider extends AutoDisposeFutureProvider<List<Role>> {
  /// Get all company roles
  ///
  /// Copied from [allCompanyRoles].
  AllCompanyRolesProvider(
    CompanyRolesParams params,
  ) : this._internal(
          (ref) => allCompanyRoles(
            ref as AllCompanyRolesRef,
            params,
          ),
          from: allCompanyRolesProvider,
          name: r'allCompanyRolesProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$allCompanyRolesHash,
          dependencies: AllCompanyRolesFamily._dependencies,
          allTransitiveDependencies:
              AllCompanyRolesFamily._allTransitiveDependencies,
          params: params,
        );

  AllCompanyRolesProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.params,
  }) : super.internal();

  final CompanyRolesParams params;

  @override
  Override overrideWith(
    FutureOr<List<Role>> Function(AllCompanyRolesRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: AllCompanyRolesProvider._internal(
        (ref) => create(ref as AllCompanyRolesRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        params: params,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<Role>> createElement() {
    return _AllCompanyRolesProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is AllCompanyRolesProvider && other.params == params;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, params.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin AllCompanyRolesRef on AutoDisposeFutureProviderRef<List<Role>> {
  /// The parameter `params` of this provider.
  CompanyRolesParams get params;
}

class _AllCompanyRolesProviderElement
    extends AutoDisposeFutureProviderElement<List<Role>>
    with AllCompanyRolesRef {
  _AllCompanyRolesProviderElement(super.provider);

  @override
  CompanyRolesParams get params => (origin as AllCompanyRolesProvider).params;
}

String _$rolePermissionsHash() => r'77de17df8bf830b6265220ee30c2eefa23169073';

/// Get role permissions with typed entities
///
/// Copied from [rolePermissions].
@ProviderFor(rolePermissions)
const rolePermissionsProvider = RolePermissionsFamily();

/// Get role permissions with typed entities
///
/// Copied from [rolePermissions].
class RolePermissionsFamily extends Family<AsyncValue<RolePermissionInfo>> {
  /// Get role permissions with typed entities
  ///
  /// Copied from [rolePermissions].
  const RolePermissionsFamily();

  /// Get role permissions with typed entities
  ///
  /// Copied from [rolePermissions].
  RolePermissionsProvider call(
    String roleId,
  ) {
    return RolePermissionsProvider(
      roleId,
    );
  }

  @override
  RolePermissionsProvider getProviderOverride(
    covariant RolePermissionsProvider provider,
  ) {
    return call(
      provider.roleId,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'rolePermissionsProvider';
}

/// Get role permissions with typed entities
///
/// Copied from [rolePermissions].
class RolePermissionsProvider
    extends AutoDisposeFutureProvider<RolePermissionInfo> {
  /// Get role permissions with typed entities
  ///
  /// Copied from [rolePermissions].
  RolePermissionsProvider(
    String roleId,
  ) : this._internal(
          (ref) => rolePermissions(
            ref as RolePermissionsRef,
            roleId,
          ),
          from: rolePermissionsProvider,
          name: r'rolePermissionsProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$rolePermissionsHash,
          dependencies: RolePermissionsFamily._dependencies,
          allTransitiveDependencies:
              RolePermissionsFamily._allTransitiveDependencies,
          roleId: roleId,
        );

  RolePermissionsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.roleId,
  }) : super.internal();

  final String roleId;

  @override
  Override overrideWith(
    FutureOr<RolePermissionInfo> Function(RolePermissionsRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: RolePermissionsProvider._internal(
        (ref) => create(ref as RolePermissionsRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        roleId: roleId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<RolePermissionInfo> createElement() {
    return _RolePermissionsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is RolePermissionsProvider && other.roleId == roleId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, roleId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin RolePermissionsRef on AutoDisposeFutureProviderRef<RolePermissionInfo> {
  /// The parameter `roleId` of this provider.
  String get roleId;
}

class _RolePermissionsProviderElement
    extends AutoDisposeFutureProviderElement<RolePermissionInfo>
    with RolePermissionsRef {
  _RolePermissionsProviderElement(super.provider);

  @override
  String get roleId => (origin as RolePermissionsProvider).roleId;
}

String _$roleMembersHash() => r'be9ac9bb56501bf8b442e50dd31b053fef79b893';

/// Get role members as typed entities
///
/// Copied from [roleMembers].
@ProviderFor(roleMembers)
const roleMembersProvider = RoleMembersFamily();

/// Get role members as typed entities
///
/// Copied from [roleMembers].
class RoleMembersFamily extends Family<AsyncValue<List<RoleMember>>> {
  /// Get role members as typed entities
  ///
  /// Copied from [roleMembers].
  const RoleMembersFamily();

  /// Get role members as typed entities
  ///
  /// Copied from [roleMembers].
  RoleMembersProvider call(
    String roleId,
  ) {
    return RoleMembersProvider(
      roleId,
    );
  }

  @override
  RoleMembersProvider getProviderOverride(
    covariant RoleMembersProvider provider,
  ) {
    return call(
      provider.roleId,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'roleMembersProvider';
}

/// Get role members as typed entities
///
/// Copied from [roleMembers].
class RoleMembersProvider extends AutoDisposeFutureProvider<List<RoleMember>> {
  /// Get role members as typed entities
  ///
  /// Copied from [roleMembers].
  RoleMembersProvider(
    String roleId,
  ) : this._internal(
          (ref) => roleMembers(
            ref as RoleMembersRef,
            roleId,
          ),
          from: roleMembersProvider,
          name: r'roleMembersProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$roleMembersHash,
          dependencies: RoleMembersFamily._dependencies,
          allTransitiveDependencies:
              RoleMembersFamily._allTransitiveDependencies,
          roleId: roleId,
        );

  RoleMembersProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.roleId,
  }) : super.internal();

  final String roleId;

  @override
  Override overrideWith(
    FutureOr<List<RoleMember>> Function(RoleMembersRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: RoleMembersProvider._internal(
        (ref) => create(ref as RoleMembersRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        roleId: roleId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<RoleMember>> createElement() {
    return _RoleMembersProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is RoleMembersProvider && other.roleId == roleId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, roleId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin RoleMembersRef on AutoDisposeFutureProviderRef<List<RoleMember>> {
  /// The parameter `roleId` of this provider.
  String get roleId;
}

class _RoleMembersProviderElement
    extends AutoDisposeFutureProviderElement<List<RoleMember>>
    with RoleMembersRef {
  _RoleMembersProviderElement(super.provider);

  @override
  String get roleId => (origin as RoleMembersProvider).roleId;
}

String _$companyUsersHash() => r'e602ad9e2ed08881a4568497254789f4fb848979';

/// Get company users with roles
///
/// Copied from [companyUsers].
@ProviderFor(companyUsers)
const companyUsersProvider = CompanyUsersFamily();

/// Get company users with roles
///
/// Copied from [companyUsers].
class CompanyUsersFamily
    extends Family<AsyncValue<List<Map<String, dynamic>>>> {
  /// Get company users with roles
  ///
  /// Copied from [companyUsers].
  const CompanyUsersFamily();

  /// Get company users with roles
  ///
  /// Copied from [companyUsers].
  CompanyUsersProvider call(
    String companyId,
  ) {
    return CompanyUsersProvider(
      companyId,
    );
  }

  @override
  CompanyUsersProvider getProviderOverride(
    covariant CompanyUsersProvider provider,
  ) {
    return call(
      provider.companyId,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'companyUsersProvider';
}

/// Get company users with roles
///
/// Copied from [companyUsers].
class CompanyUsersProvider
    extends AutoDisposeFutureProvider<List<Map<String, dynamic>>> {
  /// Get company users with roles
  ///
  /// Copied from [companyUsers].
  CompanyUsersProvider(
    String companyId,
  ) : this._internal(
          (ref) => companyUsers(
            ref as CompanyUsersRef,
            companyId,
          ),
          from: companyUsersProvider,
          name: r'companyUsersProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$companyUsersHash,
          dependencies: CompanyUsersFamily._dependencies,
          allTransitiveDependencies:
              CompanyUsersFamily._allTransitiveDependencies,
          companyId: companyId,
        );

  CompanyUsersProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.companyId,
  }) : super.internal();

  final String companyId;

  @override
  Override overrideWith(
    FutureOr<List<Map<String, dynamic>>> Function(CompanyUsersRef provider)
        create,
  ) {
    return ProviderOverride(
      origin: this,
      override: CompanyUsersProvider._internal(
        (ref) => create(ref as CompanyUsersRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        companyId: companyId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<Map<String, dynamic>>> createElement() {
    return _CompanyUsersProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is CompanyUsersProvider && other.companyId == companyId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, companyId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin CompanyUsersRef
    on AutoDisposeFutureProviderRef<List<Map<String, dynamic>>> {
  /// The parameter `companyId` of this provider.
  String get companyId;
}

class _CompanyUsersProviderElement
    extends AutoDisposeFutureProviderElement<List<Map<String, dynamic>>>
    with CompanyUsersRef {
  _CompanyUsersProviderElement(super.provider);

  @override
  String get companyId => (origin as CompanyUsersProvider).companyId;
}

String _$allFeaturesWithCategoriesHash() =>
    r'4cef2213cd60ac7e622cd664538d10287da5a395';

/// Get all features with categories
///
/// Copied from [allFeaturesWithCategories].
@ProviderFor(allFeaturesWithCategories)
final allFeaturesWithCategoriesProvider =
    AutoDisposeFutureProvider<List<Map<String, dynamic>>>.internal(
  allFeaturesWithCategories,
  name: r'allFeaturesWithCategoriesProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$allFeaturesWithCategoriesHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef AllFeaturesWithCategoriesRef
    = AutoDisposeFutureProviderRef<List<Map<String, dynamic>>>;
String _$rolePageNotifierHash() => r'd10df24d0ece53904ca015c4d1d373f17f842899';

/// Role Page State Notifier
///
/// Copied from [RolePageNotifier].
@ProviderFor(RolePageNotifier)
final rolePageNotifierProvider =
    AutoDisposeNotifierProvider<RolePageNotifier, RolePageState>.internal(
  RolePageNotifier.new,
  name: r'rolePageNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$rolePageNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$RolePageNotifier = AutoDisposeNotifier<RolePageState>;
String _$roleCreationNotifierHash() =>
    r'33e5717c8d7d5f24ff328bf69411156b3ff3389f';

/// Role Creation State Notifier
///
/// Copied from [RoleCreationNotifier].
@ProviderFor(RoleCreationNotifier)
final roleCreationNotifierProvider = AutoDisposeNotifierProvider<
    RoleCreationNotifier, RoleCreationState>.internal(
  RoleCreationNotifier.new,
  name: r'roleCreationNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$roleCreationNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$RoleCreationNotifier = AutoDisposeNotifier<RoleCreationState>;
String _$roleManagementNotifierHash() =>
    r'46aaaf545abc04eb8d61821891e0cbd36a3c48aa';

/// Role Management State Notifier
///
/// Copied from [RoleManagementNotifier].
@ProviderFor(RoleManagementNotifier)
final roleManagementNotifierProvider = AutoDisposeNotifierProvider<
    RoleManagementNotifier, RoleManagementState>.internal(
  RoleManagementNotifier.new,
  name: r'roleManagementNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$roleManagementNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$RoleManagementNotifier = AutoDisposeNotifier<RoleManagementState>;
String _$roleActionsNotifierHash() =>
    r'833ca006b5faad9f4fd41a9a1bcb981e8bb78df6';

/// Role Actions Notifier for mutations
///
/// Copied from [RoleActionsNotifier].
@ProviderFor(RoleActionsNotifier)
final roleActionsNotifierProvider =
    AutoDisposeNotifierProvider<RoleActionsNotifier, AsyncValue<void>>.internal(
  RoleActionsNotifier.new,
  name: r'roleActionsNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$roleActionsNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$RoleActionsNotifier = AutoDisposeNotifier<AsyncValue<void>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
