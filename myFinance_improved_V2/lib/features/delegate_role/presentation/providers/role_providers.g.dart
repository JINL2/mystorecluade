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

String _$roleByIdHash() => r'c0f04aff7d83a34cca39e773531a267a553f7714';

/// Get role by ID
///
/// Copied from [roleById].
@ProviderFor(roleById)
const roleByIdProvider = RoleByIdFamily();

/// Get role by ID
///
/// Copied from [roleById].
class RoleByIdFamily extends Family<AsyncValue<Role>> {
  /// Get role by ID
  ///
  /// Copied from [roleById].
  const RoleByIdFamily();

  /// Get role by ID
  ///
  /// Copied from [roleById].
  RoleByIdProvider call(
    String roleId,
  ) {
    return RoleByIdProvider(
      roleId,
    );
  }

  @override
  RoleByIdProvider getProviderOverride(
    covariant RoleByIdProvider provider,
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
  String? get name => r'roleByIdProvider';
}

/// Get role by ID
///
/// Copied from [roleById].
class RoleByIdProvider extends AutoDisposeFutureProvider<Role> {
  /// Get role by ID
  ///
  /// Copied from [roleById].
  RoleByIdProvider(
    String roleId,
  ) : this._internal(
          (ref) => roleById(
            ref as RoleByIdRef,
            roleId,
          ),
          from: roleByIdProvider,
          name: r'roleByIdProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$roleByIdHash,
          dependencies: RoleByIdFamily._dependencies,
          allTransitiveDependencies: RoleByIdFamily._allTransitiveDependencies,
          roleId: roleId,
        );

  RoleByIdProvider._internal(
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
    FutureOr<Role> Function(RoleByIdRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: RoleByIdProvider._internal(
        (ref) => create(ref as RoleByIdRef),
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
  AutoDisposeFutureProviderElement<Role> createElement() {
    return _RoleByIdProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is RoleByIdProvider && other.roleId == roleId;
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
mixin RoleByIdRef on AutoDisposeFutureProviderRef<Role> {
  /// The parameter `roleId` of this provider.
  String get roleId;
}

class _RoleByIdProviderElement extends AutoDisposeFutureProviderElement<Role>
    with RoleByIdRef {
  _RoleByIdProviderElement(super.provider);

  @override
  String get roleId => (origin as RoleByIdProvider).roleId;
}

String _$rolePermissionsHash() => r'5830fa0411fcf82386eb2d6a06725b350304ccdd';

/// Get role permissions
///
/// Copied from [rolePermissions].
@ProviderFor(rolePermissions)
const rolePermissionsProvider = RolePermissionsFamily();

/// Get role permissions
///
/// Copied from [rolePermissions].
class RolePermissionsFamily extends Family<AsyncValue<Map<String, dynamic>>> {
  /// Get role permissions
  ///
  /// Copied from [rolePermissions].
  const RolePermissionsFamily();

  /// Get role permissions
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

/// Get role permissions
///
/// Copied from [rolePermissions].
class RolePermissionsProvider
    extends AutoDisposeFutureProvider<Map<String, dynamic>> {
  /// Get role permissions
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
    FutureOr<Map<String, dynamic>> Function(RolePermissionsRef provider) create,
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
  AutoDisposeFutureProviderElement<Map<String, dynamic>> createElement() {
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
mixin RolePermissionsRef on AutoDisposeFutureProviderRef<Map<String, dynamic>> {
  /// The parameter `roleId` of this provider.
  String get roleId;
}

class _RolePermissionsProviderElement
    extends AutoDisposeFutureProviderElement<Map<String, dynamic>>
    with RolePermissionsRef {
  _RolePermissionsProviderElement(super.provider);

  @override
  String get roleId => (origin as RolePermissionsProvider).roleId;
}

String _$delegatableRolesHash() => r'677178a6980c3b882612fa12e0619f8a20d839de';

/// Get delegatable roles
///
/// Copied from [delegatableRoles].
@ProviderFor(delegatableRoles)
const delegatableRolesProvider = DelegatableRolesFamily();

/// Get delegatable roles
///
/// Copied from [delegatableRoles].
class DelegatableRolesFamily extends Family<AsyncValue<List<DelegatableRole>>> {
  /// Get delegatable roles
  ///
  /// Copied from [delegatableRoles].
  const DelegatableRolesFamily();

  /// Get delegatable roles
  ///
  /// Copied from [delegatableRoles].
  DelegatableRolesProvider call(
    String companyId,
  ) {
    return DelegatableRolesProvider(
      companyId,
    );
  }

  @override
  DelegatableRolesProvider getProviderOverride(
    covariant DelegatableRolesProvider provider,
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
  String? get name => r'delegatableRolesProvider';
}

/// Get delegatable roles
///
/// Copied from [delegatableRoles].
class DelegatableRolesProvider
    extends AutoDisposeFutureProvider<List<DelegatableRole>> {
  /// Get delegatable roles
  ///
  /// Copied from [delegatableRoles].
  DelegatableRolesProvider(
    String companyId,
  ) : this._internal(
          (ref) => delegatableRoles(
            ref as DelegatableRolesRef,
            companyId,
          ),
          from: delegatableRolesProvider,
          name: r'delegatableRolesProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$delegatableRolesHash,
          dependencies: DelegatableRolesFamily._dependencies,
          allTransitiveDependencies:
              DelegatableRolesFamily._allTransitiveDependencies,
          companyId: companyId,
        );

  DelegatableRolesProvider._internal(
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
    FutureOr<List<DelegatableRole>> Function(DelegatableRolesRef provider)
        create,
  ) {
    return ProviderOverride(
      origin: this,
      override: DelegatableRolesProvider._internal(
        (ref) => create(ref as DelegatableRolesRef),
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
  AutoDisposeFutureProviderElement<List<DelegatableRole>> createElement() {
    return _DelegatableRolesProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is DelegatableRolesProvider && other.companyId == companyId;
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
mixin DelegatableRolesRef
    on AutoDisposeFutureProviderRef<List<DelegatableRole>> {
  /// The parameter `companyId` of this provider.
  String get companyId;
}

class _DelegatableRolesProviderElement
    extends AutoDisposeFutureProviderElement<List<DelegatableRole>>
    with DelegatableRolesRef {
  _DelegatableRolesProviderElement(super.provider);

  @override
  String get companyId => (origin as DelegatableRolesProvider).companyId;
}

String _$roleMembersHash() => r'f98ff2a4c886b11f01f2e60db648e3240c3b8610';

/// Get role members
///
/// Copied from [roleMembers].
@ProviderFor(roleMembers)
const roleMembersProvider = RoleMembersFamily();

/// Get role members
///
/// Copied from [roleMembers].
class RoleMembersFamily extends Family<AsyncValue<List<Map<String, dynamic>>>> {
  /// Get role members
  ///
  /// Copied from [roleMembers].
  const RoleMembersFamily();

  /// Get role members
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

/// Get role members
///
/// Copied from [roleMembers].
class RoleMembersProvider
    extends AutoDisposeFutureProvider<List<Map<String, dynamic>>> {
  /// Get role members
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
    FutureOr<List<Map<String, dynamic>>> Function(RoleMembersRef provider)
        create,
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
  AutoDisposeFutureProviderElement<List<Map<String, dynamic>>> createElement() {
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
mixin RoleMembersRef
    on AutoDisposeFutureProviderRef<List<Map<String, dynamic>>> {
  /// The parameter `roleId` of this provider.
  String get roleId;
}

class _RoleMembersProviderElement
    extends AutoDisposeFutureProviderElement<List<Map<String, dynamic>>>
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
String _$activeDelegationsHash() => r'62f536f1ebe053f35afa00b625b5a087b1770d9b';

/// Get active delegations
///
/// Copied from [activeDelegations].
@ProviderFor(activeDelegations)
const activeDelegationsProvider = ActiveDelegationsFamily();

/// Get active delegations
///
/// Copied from [activeDelegations].
class ActiveDelegationsFamily extends Family<AsyncValue<List<RoleDelegation>>> {
  /// Get active delegations
  ///
  /// Copied from [activeDelegations].
  const ActiveDelegationsFamily();

  /// Get active delegations
  ///
  /// Copied from [activeDelegations].
  ActiveDelegationsProvider call(
    ActiveDelegationsParams params,
  ) {
    return ActiveDelegationsProvider(
      params,
    );
  }

  @override
  ActiveDelegationsProvider getProviderOverride(
    covariant ActiveDelegationsProvider provider,
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
  String? get name => r'activeDelegationsProvider';
}

/// Get active delegations
///
/// Copied from [activeDelegations].
class ActiveDelegationsProvider
    extends AutoDisposeFutureProvider<List<RoleDelegation>> {
  /// Get active delegations
  ///
  /// Copied from [activeDelegations].
  ActiveDelegationsProvider(
    ActiveDelegationsParams params,
  ) : this._internal(
          (ref) => activeDelegations(
            ref as ActiveDelegationsRef,
            params,
          ),
          from: activeDelegationsProvider,
          name: r'activeDelegationsProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$activeDelegationsHash,
          dependencies: ActiveDelegationsFamily._dependencies,
          allTransitiveDependencies:
              ActiveDelegationsFamily._allTransitiveDependencies,
          params: params,
        );

  ActiveDelegationsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.params,
  }) : super.internal();

  final ActiveDelegationsParams params;

  @override
  Override overrideWith(
    FutureOr<List<RoleDelegation>> Function(ActiveDelegationsRef provider)
        create,
  ) {
    return ProviderOverride(
      origin: this,
      override: ActiveDelegationsProvider._internal(
        (ref) => create(ref as ActiveDelegationsRef),
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
  AutoDisposeFutureProviderElement<List<RoleDelegation>> createElement() {
    return _ActiveDelegationsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ActiveDelegationsProvider && other.params == params;
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
mixin ActiveDelegationsRef
    on AutoDisposeFutureProviderRef<List<RoleDelegation>> {
  /// The parameter `params` of this provider.
  ActiveDelegationsParams get params;
}

class _ActiveDelegationsProviderElement
    extends AutoDisposeFutureProviderElement<List<RoleDelegation>>
    with ActiveDelegationsRef {
  _ActiveDelegationsProviderElement(super.provider);

  @override
  ActiveDelegationsParams get params =>
      (origin as ActiveDelegationsProvider).params;
}

String _$delegationHistoryHash() => r'0b600b86573b8c0a5d01b5e15597876f4085d083';

/// Get delegation history
///
/// Copied from [delegationHistory].
@ProviderFor(delegationHistory)
const delegationHistoryProvider = DelegationHistoryFamily();

/// Get delegation history
///
/// Copied from [delegationHistory].
class DelegationHistoryFamily
    extends Family<AsyncValue<List<DelegationAudit>>> {
  /// Get delegation history
  ///
  /// Copied from [delegationHistory].
  const DelegationHistoryFamily();

  /// Get delegation history
  ///
  /// Copied from [delegationHistory].
  DelegationHistoryProvider call(
    String companyId,
  ) {
    return DelegationHistoryProvider(
      companyId,
    );
  }

  @override
  DelegationHistoryProvider getProviderOverride(
    covariant DelegationHistoryProvider provider,
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
  String? get name => r'delegationHistoryProvider';
}

/// Get delegation history
///
/// Copied from [delegationHistory].
class DelegationHistoryProvider
    extends AutoDisposeFutureProvider<List<DelegationAudit>> {
  /// Get delegation history
  ///
  /// Copied from [delegationHistory].
  DelegationHistoryProvider(
    String companyId,
  ) : this._internal(
          (ref) => delegationHistory(
            ref as DelegationHistoryRef,
            companyId,
          ),
          from: delegationHistoryProvider,
          name: r'delegationHistoryProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$delegationHistoryHash,
          dependencies: DelegationHistoryFamily._dependencies,
          allTransitiveDependencies:
              DelegationHistoryFamily._allTransitiveDependencies,
          companyId: companyId,
        );

  DelegationHistoryProvider._internal(
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
    FutureOr<List<DelegationAudit>> Function(DelegationHistoryRef provider)
        create,
  ) {
    return ProviderOverride(
      origin: this,
      override: DelegationHistoryProvider._internal(
        (ref) => create(ref as DelegationHistoryRef),
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
  AutoDisposeFutureProviderElement<List<DelegationAudit>> createElement() {
    return _DelegationHistoryProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is DelegationHistoryProvider && other.companyId == companyId;
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
mixin DelegationHistoryRef
    on AutoDisposeFutureProviderRef<List<DelegationAudit>> {
  /// The parameter `companyId` of this provider.
  String get companyId;
}

class _DelegationHistoryProviderElement
    extends AutoDisposeFutureProviderElement<List<DelegationAudit>>
    with DelegationHistoryRef {
  _DelegationHistoryProviderElement(super.provider);

  @override
  String get companyId => (origin as DelegationHistoryProvider).companyId;
}

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
    r'17de7a14659490c790ef09fb7a64c9f7fc548906';

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
String _$delegationActionsNotifierHash() =>
    r'5f933b7afdd129d55f7fc1c8853c46091fbed826';

/// Delegation Actions Notifier for mutations
///
/// Copied from [DelegationActionsNotifier].
@ProviderFor(DelegationActionsNotifier)
final delegationActionsNotifierProvider = AutoDisposeNotifierProvider<
    DelegationActionsNotifier, AsyncValue<void>>.internal(
  DelegationActionsNotifier.new,
  name: r'delegationActionsNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$delegationActionsNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$DelegationActionsNotifier = AutoDisposeNotifier<AsyncValue<void>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
