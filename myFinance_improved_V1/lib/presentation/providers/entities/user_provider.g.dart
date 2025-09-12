// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$currentUsersHash() => r'aad0410d1894501d8150bb8a1143764af4d28cac';

/// Current company users based on selected company
///
/// Copied from [currentUsers].
@ProviderFor(currentUsers)
final currentUsersProvider = AutoDisposeFutureProvider<List<UserData>>.internal(
  currentUsers,
  name: r'currentUsersProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$currentUsersHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef CurrentUsersRef = AutoDisposeFutureProviderRef<List<UserData>>;
String _$currentActiveUsersHash() =>
    r'da41c9a3762b97e81972f2262e7daae5e685975a';

/// Current users with transaction count filter (active users only)
///
/// Copied from [currentActiveUsers].
@ProviderFor(currentActiveUsers)
final currentActiveUsersProvider =
    AutoDisposeFutureProvider<List<UserData>>.internal(
  currentActiveUsers,
  name: r'currentActiveUsersProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$currentActiveUsersHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef CurrentActiveUsersRef = AutoDisposeFutureProviderRef<List<UserData>>;
String _$currentUsersSortedHash() =>
    r'1a0822fbac37bf0db7f595e8dc4270d77c6e3c4d';

/// Current users sorted by name
///
/// Copied from [currentUsersSorted].
@ProviderFor(currentUsersSorted)
final currentUsersSortedProvider =
    AutoDisposeFutureProvider<List<UserData>>.internal(
  currentUsersSorted,
  name: r'currentUsersSortedProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$currentUsersSortedHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef CurrentUsersSortedRef = AutoDisposeFutureProviderRef<List<UserData>>;
String _$userByIdHash() => r'675f3dd4ebbe79385b9d0be1f072179af98f69bd';

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

/// Find user by ID
///
/// Copied from [userById].
@ProviderFor(userById)
const userByIdProvider = UserByIdFamily();

/// Find user by ID
///
/// Copied from [userById].
class UserByIdFamily extends Family<AsyncValue<UserData?>> {
  /// Find user by ID
  ///
  /// Copied from [userById].
  const UserByIdFamily();

  /// Find user by ID
  ///
  /// Copied from [userById].
  UserByIdProvider call(
    String userId,
  ) {
    return UserByIdProvider(
      userId,
    );
  }

  @override
  UserByIdProvider getProviderOverride(
    covariant UserByIdProvider provider,
  ) {
    return call(
      provider.userId,
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
  String? get name => r'userByIdProvider';
}

/// Find user by ID
///
/// Copied from [userById].
class UserByIdProvider extends AutoDisposeFutureProvider<UserData?> {
  /// Find user by ID
  ///
  /// Copied from [userById].
  UserByIdProvider(
    String userId,
  ) : this._internal(
          (ref) => userById(
            ref as UserByIdRef,
            userId,
          ),
          from: userByIdProvider,
          name: r'userByIdProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$userByIdHash,
          dependencies: UserByIdFamily._dependencies,
          allTransitiveDependencies: UserByIdFamily._allTransitiveDependencies,
          userId: userId,
        );

  UserByIdProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.userId,
  }) : super.internal();

  final String userId;

  @override
  Override overrideWith(
    FutureOr<UserData?> Function(UserByIdRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: UserByIdProvider._internal(
        (ref) => create(ref as UserByIdRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        userId: userId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<UserData?> createElement() {
    return _UserByIdProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is UserByIdProvider && other.userId == userId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, userId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin UserByIdRef on AutoDisposeFutureProviderRef<UserData?> {
  /// The parameter `userId` of this provider.
  String get userId;
}

class _UserByIdProviderElement
    extends AutoDisposeFutureProviderElement<UserData?> with UserByIdRef {
  _UserByIdProviderElement(super.provider);

  @override
  String get userId => (origin as UserByIdProvider).userId;
}

String _$usersByIdsHash() => r'debe481c12fbaf4448235533b9e4d76c01535f72';

/// Find users by IDs
///
/// Copied from [usersByIds].
@ProviderFor(usersByIds)
const usersByIdsProvider = UsersByIdsFamily();

/// Find users by IDs
///
/// Copied from [usersByIds].
class UsersByIdsFamily extends Family<AsyncValue<List<UserData>>> {
  /// Find users by IDs
  ///
  /// Copied from [usersByIds].
  const UsersByIdsFamily();

  /// Find users by IDs
  ///
  /// Copied from [usersByIds].
  UsersByIdsProvider call(
    List<String> userIds,
  ) {
    return UsersByIdsProvider(
      userIds,
    );
  }

  @override
  UsersByIdsProvider getProviderOverride(
    covariant UsersByIdsProvider provider,
  ) {
    return call(
      provider.userIds,
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
  String? get name => r'usersByIdsProvider';
}

/// Find users by IDs
///
/// Copied from [usersByIds].
class UsersByIdsProvider extends AutoDisposeFutureProvider<List<UserData>> {
  /// Find users by IDs
  ///
  /// Copied from [usersByIds].
  UsersByIdsProvider(
    List<String> userIds,
  ) : this._internal(
          (ref) => usersByIds(
            ref as UsersByIdsRef,
            userIds,
          ),
          from: usersByIdsProvider,
          name: r'usersByIdsProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$usersByIdsHash,
          dependencies: UsersByIdsFamily._dependencies,
          allTransitiveDependencies:
              UsersByIdsFamily._allTransitiveDependencies,
          userIds: userIds,
        );

  UsersByIdsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.userIds,
  }) : super.internal();

  final List<String> userIds;

  @override
  Override overrideWith(
    FutureOr<List<UserData>> Function(UsersByIdsRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: UsersByIdsProvider._internal(
        (ref) => create(ref as UsersByIdsRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        userIds: userIds,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<UserData>> createElement() {
    return _UsersByIdsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is UsersByIdsProvider && other.userIds == userIds;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, userIds.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin UsersByIdsRef on AutoDisposeFutureProviderRef<List<UserData>> {
  /// The parameter `userIds` of this provider.
  List<String> get userIds;
}

class _UsersByIdsProviderElement
    extends AutoDisposeFutureProviderElement<List<UserData>>
    with UsersByIdsRef {
  _UsersByIdsProviderElement(super.provider);

  @override
  List<String> get userIds => (origin as UsersByIdsProvider).userIds;
}

String _$searchUsersHash() => r'cc6547ff43e383b71ca5d0ebc84cf7f6ef5b7aec';

/// Search users by name or email
///
/// Copied from [searchUsers].
@ProviderFor(searchUsers)
const searchUsersProvider = SearchUsersFamily();

/// Search users by name or email
///
/// Copied from [searchUsers].
class SearchUsersFamily extends Family<AsyncValue<List<UserData>>> {
  /// Search users by name or email
  ///
  /// Copied from [searchUsers].
  const SearchUsersFamily();

  /// Search users by name or email
  ///
  /// Copied from [searchUsers].
  SearchUsersProvider call(
    String searchQuery,
  ) {
    return SearchUsersProvider(
      searchQuery,
    );
  }

  @override
  SearchUsersProvider getProviderOverride(
    covariant SearchUsersProvider provider,
  ) {
    return call(
      provider.searchQuery,
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
  String? get name => r'searchUsersProvider';
}

/// Search users by name or email
///
/// Copied from [searchUsers].
class SearchUsersProvider extends AutoDisposeFutureProvider<List<UserData>> {
  /// Search users by name or email
  ///
  /// Copied from [searchUsers].
  SearchUsersProvider(
    String searchQuery,
  ) : this._internal(
          (ref) => searchUsers(
            ref as SearchUsersRef,
            searchQuery,
          ),
          from: searchUsersProvider,
          name: r'searchUsersProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$searchUsersHash,
          dependencies: SearchUsersFamily._dependencies,
          allTransitiveDependencies:
              SearchUsersFamily._allTransitiveDependencies,
          searchQuery: searchQuery,
        );

  SearchUsersProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.searchQuery,
  }) : super.internal();

  final String searchQuery;

  @override
  Override overrideWith(
    FutureOr<List<UserData>> Function(SearchUsersRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: SearchUsersProvider._internal(
        (ref) => create(ref as SearchUsersRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        searchQuery: searchQuery,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<UserData>> createElement() {
    return _SearchUsersProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is SearchUsersProvider && other.searchQuery == searchQuery;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, searchQuery.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin SearchUsersRef on AutoDisposeFutureProviderRef<List<UserData>> {
  /// The parameter `searchQuery` of this provider.
  String get searchQuery;
}

class _SearchUsersProviderElement
    extends AutoDisposeFutureProviderElement<List<UserData>>
    with SearchUsersRef {
  _SearchUsersProviderElement(super.provider);

  @override
  String get searchQuery => (origin as SearchUsersProvider).searchQuery;
}

String _$currentLoggedInUserHash() =>
    r'df54ab1df52e633b707f3b3f437590446236a908';

/// Get current logged-in user
///
/// Copied from [currentLoggedInUser].
@ProviderFor(currentLoggedInUser)
final currentLoggedInUserProvider =
    AutoDisposeFutureProvider<UserData?>.internal(
  currentLoggedInUser,
  name: r'currentLoggedInUserProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$currentLoggedInUserHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef CurrentLoggedInUserRef = AutoDisposeFutureProviderRef<UserData?>;
String _$userListHash() => r'5aaefb0066d3dac13e1317d322fe958ac047491e';

abstract class _$UserList
    extends BuildlessAutoDisposeAsyncNotifier<List<UserData>> {
  late final String companyId;

  FutureOr<List<UserData>> build(
    String companyId,
  );
}

/// See also [UserList].
@ProviderFor(UserList)
const userListProvider = UserListFamily();

/// See also [UserList].
class UserListFamily extends Family<AsyncValue<List<UserData>>> {
  /// See also [UserList].
  const UserListFamily();

  /// See also [UserList].
  UserListProvider call(
    String companyId,
  ) {
    return UserListProvider(
      companyId,
    );
  }

  @override
  UserListProvider getProviderOverride(
    covariant UserListProvider provider,
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
  String? get name => r'userListProvider';
}

/// See also [UserList].
class UserListProvider
    extends AutoDisposeAsyncNotifierProviderImpl<UserList, List<UserData>> {
  /// See also [UserList].
  UserListProvider(
    String companyId,
  ) : this._internal(
          () => UserList()..companyId = companyId,
          from: userListProvider,
          name: r'userListProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$userListHash,
          dependencies: UserListFamily._dependencies,
          allTransitiveDependencies: UserListFamily._allTransitiveDependencies,
          companyId: companyId,
        );

  UserListProvider._internal(
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
  FutureOr<List<UserData>> runNotifierBuild(
    covariant UserList notifier,
  ) {
    return notifier.build(
      companyId,
    );
  }

  @override
  Override overrideWith(UserList Function() create) {
    return ProviderOverride(
      origin: this,
      override: UserListProvider._internal(
        () => create()..companyId = companyId,
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
  AutoDisposeAsyncNotifierProviderElement<UserList, List<UserData>>
      createElement() {
    return _UserListProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is UserListProvider && other.companyId == companyId;
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
mixin UserListRef on AutoDisposeAsyncNotifierProviderRef<List<UserData>> {
  /// The parameter `companyId` of this provider.
  String get companyId;
}

class _UserListProviderElement
    extends AutoDisposeAsyncNotifierProviderElement<UserList, List<UserData>>
    with UserListRef {
  _UserListProviderElement(super.provider);

  @override
  String get companyId => (origin as UserListProvider).companyId;
}

String _$selectedUserHash() => r'8829fa6feb6abebbf15238a3aec654346f5447f1';

/// Single user selection state
///
/// Copied from [SelectedUser].
@ProviderFor(SelectedUser)
final selectedUserProvider =
    AutoDisposeNotifierProvider<SelectedUser, String?>.internal(
  SelectedUser.new,
  name: r'selectedUserProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$selectedUserHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$SelectedUser = AutoDisposeNotifier<String?>;
String _$selectedUsersHash() => r'3b54a847dde310293d8bc472de6050e97e734186';

/// Multiple user selection state
///
/// Copied from [SelectedUsers].
@ProviderFor(SelectedUsers)
final selectedUsersProvider =
    AutoDisposeNotifierProvider<SelectedUsers, List<String>>.internal(
  SelectedUsers.new,
  name: r'selectedUsersProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$selectedUsersHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$SelectedUsers = AutoDisposeNotifier<List<String>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
