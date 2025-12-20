// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'account_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$currentAccountsHash() => r'0aa758e399cf127d6a26992549b9efcdf871256e';

/// Current accounts (global - no company/store filter needed)
///
/// Copied from [currentAccounts].
@ProviderFor(currentAccounts)
final currentAccountsProvider =
    AutoDisposeFutureProvider<List<AccountData>>.internal(
  currentAccounts,
  name: r'currentAccountsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$currentAccountsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef CurrentAccountsRef = AutoDisposeFutureProviderRef<List<AccountData>>;
String _$currentAccountsByTypeHash() =>
    r'cd047b99889044b688f2dddd025154630d3f4ce9';

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

/// Current accounts filtered by type
///
/// Copied from [currentAccountsByType].
@ProviderFor(currentAccountsByType)
const currentAccountsByTypeProvider = CurrentAccountsByTypeFamily();

/// Current accounts filtered by type
///
/// Copied from [currentAccountsByType].
class CurrentAccountsByTypeFamily
    extends Family<AsyncValue<List<AccountData>>> {
  /// Current accounts filtered by type
  ///
  /// Copied from [currentAccountsByType].
  const CurrentAccountsByTypeFamily();

  /// Current accounts filtered by type
  ///
  /// Copied from [currentAccountsByType].
  CurrentAccountsByTypeProvider call(
    String accountType,
  ) {
    return CurrentAccountsByTypeProvider(
      accountType,
    );
  }

  @override
  CurrentAccountsByTypeProvider getProviderOverride(
    covariant CurrentAccountsByTypeProvider provider,
  ) {
    return call(
      provider.accountType,
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
  String? get name => r'currentAccountsByTypeProvider';
}

/// Current accounts filtered by type
///
/// Copied from [currentAccountsByType].
class CurrentAccountsByTypeProvider
    extends AutoDisposeFutureProvider<List<AccountData>> {
  /// Current accounts filtered by type
  ///
  /// Copied from [currentAccountsByType].
  CurrentAccountsByTypeProvider(
    String accountType,
  ) : this._internal(
          (ref) => currentAccountsByType(
            ref as CurrentAccountsByTypeRef,
            accountType,
          ),
          from: currentAccountsByTypeProvider,
          name: r'currentAccountsByTypeProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$currentAccountsByTypeHash,
          dependencies: CurrentAccountsByTypeFamily._dependencies,
          allTransitiveDependencies:
              CurrentAccountsByTypeFamily._allTransitiveDependencies,
          accountType: accountType,
        );

  CurrentAccountsByTypeProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.accountType,
  }) : super.internal();

  final String accountType;

  @override
  Override overrideWith(
    FutureOr<List<AccountData>> Function(CurrentAccountsByTypeRef provider)
        create,
  ) {
    return ProviderOverride(
      origin: this,
      override: CurrentAccountsByTypeProvider._internal(
        (ref) => create(ref as CurrentAccountsByTypeRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        accountType: accountType,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<AccountData>> createElement() {
    return _CurrentAccountsByTypeProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is CurrentAccountsByTypeProvider &&
        other.accountType == accountType;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, accountType.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin CurrentAccountsByTypeRef
    on AutoDisposeFutureProviderRef<List<AccountData>> {
  /// The parameter `accountType` of this provider.
  String get accountType;
}

class _CurrentAccountsByTypeProviderElement
    extends AutoDisposeFutureProviderElement<List<AccountData>>
    with CurrentAccountsByTypeRef {
  _CurrentAccountsByTypeProviderElement(super.provider);

  @override
  String get accountType =>
      (origin as CurrentAccountsByTypeProvider).accountType;
}

String _$currentAssetAccountsHash() =>
    r'8969ee40a99d3be126d8cbff0a8d251c6e0ff79b';

/// Asset accounts only
///
/// Copied from [currentAssetAccounts].
@ProviderFor(currentAssetAccounts)
final currentAssetAccountsProvider =
    AutoDisposeFutureProvider<List<AccountData>>.internal(
  currentAssetAccounts,
  name: r'currentAssetAccountsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$currentAssetAccountsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef CurrentAssetAccountsRef
    = AutoDisposeFutureProviderRef<List<AccountData>>;
String _$currentLiabilityAccountsHash() =>
    r'7076124779b737ce2e56070d6af8d561b296ebe9';

/// Liability accounts only
///
/// Copied from [currentLiabilityAccounts].
@ProviderFor(currentLiabilityAccounts)
final currentLiabilityAccountsProvider =
    AutoDisposeFutureProvider<List<AccountData>>.internal(
  currentLiabilityAccounts,
  name: r'currentLiabilityAccountsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$currentLiabilityAccountsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef CurrentLiabilityAccountsRef
    = AutoDisposeFutureProviderRef<List<AccountData>>;
String _$currentIncomeAccountsHash() =>
    r'c75d07bb9f9d740521d49b6194c2d2a5ae91a4d9';

/// Income accounts only
///
/// Copied from [currentIncomeAccounts].
@ProviderFor(currentIncomeAccounts)
final currentIncomeAccountsProvider =
    AutoDisposeFutureProvider<List<AccountData>>.internal(
  currentIncomeAccounts,
  name: r'currentIncomeAccountsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$currentIncomeAccountsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef CurrentIncomeAccountsRef
    = AutoDisposeFutureProviderRef<List<AccountData>>;
String _$currentExpenseAccountsHash() =>
    r'9ec26f587a7e663e52addb9f318e3b4ac497e875';

/// Expense accounts only
///
/// Copied from [currentExpenseAccounts].
@ProviderFor(currentExpenseAccounts)
final currentExpenseAccountsProvider =
    AutoDisposeFutureProvider<List<AccountData>>.internal(
  currentExpenseAccounts,
  name: r'currentExpenseAccountsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$currentExpenseAccountsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef CurrentExpenseAccountsRef
    = AutoDisposeFutureProviderRef<List<AccountData>>;
String _$currentEquityAccountsHash() =>
    r'fdca83a20dbd1f770e3464a5d59deb3442a342e0';

/// Equity accounts only
///
/// Copied from [currentEquityAccounts].
@ProviderFor(currentEquityAccounts)
final currentEquityAccountsProvider =
    AutoDisposeFutureProvider<List<AccountData>>.internal(
  currentEquityAccounts,
  name: r'currentEquityAccountsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$currentEquityAccountsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef CurrentEquityAccountsRef
    = AutoDisposeFutureProviderRef<List<AccountData>>;
String _$accountByIdHash() => r'5804374763dc180ab7891224bc49cd4d9abe14eb';

/// Find account by ID
///
/// Copied from [accountById].
@ProviderFor(accountById)
const accountByIdProvider = AccountByIdFamily();

/// Find account by ID
///
/// Copied from [accountById].
class AccountByIdFamily extends Family<AsyncValue<AccountData?>> {
  /// Find account by ID
  ///
  /// Copied from [accountById].
  const AccountByIdFamily();

  /// Find account by ID
  ///
  /// Copied from [accountById].
  AccountByIdProvider call(
    String accountId,
  ) {
    return AccountByIdProvider(
      accountId,
    );
  }

  @override
  AccountByIdProvider getProviderOverride(
    covariant AccountByIdProvider provider,
  ) {
    return call(
      provider.accountId,
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
  String? get name => r'accountByIdProvider';
}

/// Find account by ID
///
/// Copied from [accountById].
class AccountByIdProvider extends AutoDisposeFutureProvider<AccountData?> {
  /// Find account by ID
  ///
  /// Copied from [accountById].
  AccountByIdProvider(
    String accountId,
  ) : this._internal(
          (ref) => accountById(
            ref as AccountByIdRef,
            accountId,
          ),
          from: accountByIdProvider,
          name: r'accountByIdProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$accountByIdHash,
          dependencies: AccountByIdFamily._dependencies,
          allTransitiveDependencies:
              AccountByIdFamily._allTransitiveDependencies,
          accountId: accountId,
        );

  AccountByIdProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.accountId,
  }) : super.internal();

  final String accountId;

  @override
  Override overrideWith(
    FutureOr<AccountData?> Function(AccountByIdRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: AccountByIdProvider._internal(
        (ref) => create(ref as AccountByIdRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        accountId: accountId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<AccountData?> createElement() {
    return _AccountByIdProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is AccountByIdProvider && other.accountId == accountId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, accountId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin AccountByIdRef on AutoDisposeFutureProviderRef<AccountData?> {
  /// The parameter `accountId` of this provider.
  String get accountId;
}

class _AccountByIdProviderElement
    extends AutoDisposeFutureProviderElement<AccountData?> with AccountByIdRef {
  _AccountByIdProviderElement(super.provider);

  @override
  String get accountId => (origin as AccountByIdProvider).accountId;
}

String _$accountsByIdsHash() => r'9f6a84ad6946dfb22259317652d5894a6e3de8ee';

/// Find accounts by IDs
///
/// Copied from [accountsByIds].
@ProviderFor(accountsByIds)
const accountsByIdsProvider = AccountsByIdsFamily();

/// Find accounts by IDs
///
/// Copied from [accountsByIds].
class AccountsByIdsFamily extends Family<AsyncValue<List<AccountData>>> {
  /// Find accounts by IDs
  ///
  /// Copied from [accountsByIds].
  const AccountsByIdsFamily();

  /// Find accounts by IDs
  ///
  /// Copied from [accountsByIds].
  AccountsByIdsProvider call(
    List<String> accountIds,
  ) {
    return AccountsByIdsProvider(
      accountIds,
    );
  }

  @override
  AccountsByIdsProvider getProviderOverride(
    covariant AccountsByIdsProvider provider,
  ) {
    return call(
      provider.accountIds,
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
  String? get name => r'accountsByIdsProvider';
}

/// Find accounts by IDs
///
/// Copied from [accountsByIds].
class AccountsByIdsProvider
    extends AutoDisposeFutureProvider<List<AccountData>> {
  /// Find accounts by IDs
  ///
  /// Copied from [accountsByIds].
  AccountsByIdsProvider(
    List<String> accountIds,
  ) : this._internal(
          (ref) => accountsByIds(
            ref as AccountsByIdsRef,
            accountIds,
          ),
          from: accountsByIdsProvider,
          name: r'accountsByIdsProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$accountsByIdsHash,
          dependencies: AccountsByIdsFamily._dependencies,
          allTransitiveDependencies:
              AccountsByIdsFamily._allTransitiveDependencies,
          accountIds: accountIds,
        );

  AccountsByIdsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.accountIds,
  }) : super.internal();

  final List<String> accountIds;

  @override
  Override overrideWith(
    FutureOr<List<AccountData>> Function(AccountsByIdsRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: AccountsByIdsProvider._internal(
        (ref) => create(ref as AccountsByIdsRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        accountIds: accountIds,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<AccountData>> createElement() {
    return _AccountsByIdsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is AccountsByIdsProvider && other.accountIds == accountIds;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, accountIds.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin AccountsByIdsRef on AutoDisposeFutureProviderRef<List<AccountData>> {
  /// The parameter `accountIds` of this provider.
  List<String> get accountIds;
}

class _AccountsByIdsProviderElement
    extends AutoDisposeFutureProviderElement<List<AccountData>>
    with AccountsByIdsRef {
  _AccountsByIdsProviderElement(super.provider);

  @override
  List<String> get accountIds => (origin as AccountsByIdsProvider).accountIds;
}

String _$accountListHash() => r'a10212e24831bbdf0a57f0a1987658b46d2bd917';

abstract class _$AccountList
    extends BuildlessAutoDisposeAsyncNotifier<List<AccountData>> {
  late final String? accountType;

  FutureOr<List<AccountData>> build([
    String? accountType,
  ]);
}

/// See also [AccountList].
@ProviderFor(AccountList)
const accountListProvider = AccountListFamily();

/// See also [AccountList].
class AccountListFamily extends Family<AsyncValue<List<AccountData>>> {
  /// See also [AccountList].
  const AccountListFamily();

  /// See also [AccountList].
  AccountListProvider call([
    String? accountType,
  ]) {
    return AccountListProvider(
      accountType,
    );
  }

  @override
  AccountListProvider getProviderOverride(
    covariant AccountListProvider provider,
  ) {
    return call(
      provider.accountType,
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
  String? get name => r'accountListProvider';
}

/// See also [AccountList].
class AccountListProvider extends AutoDisposeAsyncNotifierProviderImpl<
    AccountList, List<AccountData>> {
  /// See also [AccountList].
  AccountListProvider([
    String? accountType,
  ]) : this._internal(
          () => AccountList()..accountType = accountType,
          from: accountListProvider,
          name: r'accountListProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$accountListHash,
          dependencies: AccountListFamily._dependencies,
          allTransitiveDependencies:
              AccountListFamily._allTransitiveDependencies,
          accountType: accountType,
        );

  AccountListProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.accountType,
  }) : super.internal();

  final String? accountType;

  @override
  FutureOr<List<AccountData>> runNotifierBuild(
    covariant AccountList notifier,
  ) {
    return notifier.build(
      accountType,
    );
  }

  @override
  Override overrideWith(AccountList Function() create) {
    return ProviderOverride(
      origin: this,
      override: AccountListProvider._internal(
        () => create()..accountType = accountType,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        accountType: accountType,
      ),
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<AccountList, List<AccountData>>
      createElement() {
    return _AccountListProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is AccountListProvider && other.accountType == accountType;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, accountType.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin AccountListRef on AutoDisposeAsyncNotifierProviderRef<List<AccountData>> {
  /// The parameter `accountType` of this provider.
  String? get accountType;
}

class _AccountListProviderElement
    extends AutoDisposeAsyncNotifierProviderElement<AccountList,
        List<AccountData>> with AccountListRef {
  _AccountListProviderElement(super.provider);

  @override
  String? get accountType => (origin as AccountListProvider).accountType;
}

String _$selectedAccountHash() => r'026934b4aef242e094fa33113257611fe3b3ceb4';

/// Single account selection state
///
/// Copied from [SelectedAccount].
@ProviderFor(SelectedAccount)
final selectedAccountProvider =
    AutoDisposeNotifierProvider<SelectedAccount, String?>.internal(
  SelectedAccount.new,
  name: r'selectedAccountProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$selectedAccountHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$SelectedAccount = AutoDisposeNotifier<String?>;
String _$selectedAccountsHash() => r'9914e5b9a35054d8f88835033b41e531175e5f72';

/// Multiple account selection state
///
/// Copied from [SelectedAccounts].
@ProviderFor(SelectedAccounts)
final selectedAccountsProvider =
    AutoDisposeNotifierProvider<SelectedAccounts, List<String>>.internal(
  SelectedAccounts.new,
  name: r'selectedAccountsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$selectedAccountsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$SelectedAccounts = AutoDisposeNotifier<List<String>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
