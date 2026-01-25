// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'subscription_limit_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$companyLimitFromCacheHash() =>
    r'8e9542d426e334fa1042f88e2021828166072d68';

/// Company limit check from AppState cache
///
/// Use this for instant UI response (button enable/disable).
/// Data comes from get_user_companies_with_subscription RPC loaded at app start.
///
/// Copied from [companyLimitFromCache].
@ProviderFor(companyLimitFromCache)
final companyLimitFromCacheProvider =
    AutoDisposeProvider<SubscriptionLimitCheck>.internal(
  companyLimitFromCache,
  name: r'companyLimitFromCacheProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$companyLimitFromCacheHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef CompanyLimitFromCacheRef
    = AutoDisposeProviderRef<SubscriptionLimitCheck>;
String _$storeLimitFromCacheHash() =>
    r'cd8a669d1c91a148933f0562e5c4cedbc6ff3f7c';

/// Store limit check from AppState cache
///
/// Use this for instant UI response (button enable/disable).
/// Data comes from get_user_companies_with_subscription RPC loaded at app start.
///
/// Copied from [storeLimitFromCache].
@ProviderFor(storeLimitFromCache)
final storeLimitFromCacheProvider =
    AutoDisposeProvider<SubscriptionLimitCheck>.internal(
  storeLimitFromCache,
  name: r'storeLimitFromCacheProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$storeLimitFromCacheHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef StoreLimitFromCacheRef = AutoDisposeProviderRef<SubscriptionLimitCheck>;
String _$employeeLimitFromCacheHash() =>
    r'61f8a10f8a9e6fcba0ba68190430711279836e62';

/// Employee limit check from AppState cache
///
/// Use this for instant UI response (button enable/disable).
/// Data comes from get_user_companies_with_subscription RPC loaded at app start.
///
/// Copied from [employeeLimitFromCache].
@ProviderFor(employeeLimitFromCache)
final employeeLimitFromCacheProvider =
    AutoDisposeProvider<SubscriptionLimitCheck>.internal(
  employeeLimitFromCache,
  name: r'employeeLimitFromCacheProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$employeeLimitFromCacheHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef EmployeeLimitFromCacheRef
    = AutoDisposeProviderRef<SubscriptionLimitCheck>;
String _$companyLimitFreshHash() => r'ee0803ae7bf26fbd0a1b4c13328dc72d095c467c';

/// Fresh company limit check from RPC
///
/// Call this when user clicks "Create Company" button to get latest count.
/// This ensures multi-device scenarios are handled correctly.
///
/// Copied from [companyLimitFresh].
@ProviderFor(companyLimitFresh)
final companyLimitFreshProvider =
    AutoDisposeFutureProvider<SubscriptionLimitCheck>.internal(
  companyLimitFresh,
  name: r'companyLimitFreshProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$companyLimitFreshHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef CompanyLimitFreshRef
    = AutoDisposeFutureProviderRef<SubscriptionLimitCheck>;
String _$storeLimitFreshHash() => r'827541c80b77458d4a8e791871d780f06fd291c7';

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

/// Fresh store limit check from RPC
///
/// Call this when user clicks "Create Store" button to get latest count.
/// Pass companyId to check limit for specific company.
///
/// Copied from [storeLimitFresh].
@ProviderFor(storeLimitFresh)
const storeLimitFreshProvider = StoreLimitFreshFamily();

/// Fresh store limit check from RPC
///
/// Call this when user clicks "Create Store" button to get latest count.
/// Pass companyId to check limit for specific company.
///
/// Copied from [storeLimitFresh].
class StoreLimitFreshFamily extends Family<AsyncValue<SubscriptionLimitCheck>> {
  /// Fresh store limit check from RPC
  ///
  /// Call this when user clicks "Create Store" button to get latest count.
  /// Pass companyId to check limit for specific company.
  ///
  /// Copied from [storeLimitFresh].
  const StoreLimitFreshFamily();

  /// Fresh store limit check from RPC
  ///
  /// Call this when user clicks "Create Store" button to get latest count.
  /// Pass companyId to check limit for specific company.
  ///
  /// Copied from [storeLimitFresh].
  StoreLimitFreshProvider call({
    String? companyId,
  }) {
    return StoreLimitFreshProvider(
      companyId: companyId,
    );
  }

  @override
  StoreLimitFreshProvider getProviderOverride(
    covariant StoreLimitFreshProvider provider,
  ) {
    return call(
      companyId: provider.companyId,
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
  String? get name => r'storeLimitFreshProvider';
}

/// Fresh store limit check from RPC
///
/// Call this when user clicks "Create Store" button to get latest count.
/// Pass companyId to check limit for specific company.
///
/// Copied from [storeLimitFresh].
class StoreLimitFreshProvider
    extends AutoDisposeFutureProvider<SubscriptionLimitCheck> {
  /// Fresh store limit check from RPC
  ///
  /// Call this when user clicks "Create Store" button to get latest count.
  /// Pass companyId to check limit for specific company.
  ///
  /// Copied from [storeLimitFresh].
  StoreLimitFreshProvider({
    String? companyId,
  }) : this._internal(
          (ref) => storeLimitFresh(
            ref as StoreLimitFreshRef,
            companyId: companyId,
          ),
          from: storeLimitFreshProvider,
          name: r'storeLimitFreshProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$storeLimitFreshHash,
          dependencies: StoreLimitFreshFamily._dependencies,
          allTransitiveDependencies:
              StoreLimitFreshFamily._allTransitiveDependencies,
          companyId: companyId,
        );

  StoreLimitFreshProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.companyId,
  }) : super.internal();

  final String? companyId;

  @override
  Override overrideWith(
    FutureOr<SubscriptionLimitCheck> Function(StoreLimitFreshRef provider)
        create,
  ) {
    return ProviderOverride(
      origin: this,
      override: StoreLimitFreshProvider._internal(
        (ref) => create(ref as StoreLimitFreshRef),
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
  AutoDisposeFutureProviderElement<SubscriptionLimitCheck> createElement() {
    return _StoreLimitFreshProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is StoreLimitFreshProvider && other.companyId == companyId;
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
mixin StoreLimitFreshRef
    on AutoDisposeFutureProviderRef<SubscriptionLimitCheck> {
  /// The parameter `companyId` of this provider.
  String? get companyId;
}

class _StoreLimitFreshProviderElement
    extends AutoDisposeFutureProviderElement<SubscriptionLimitCheck>
    with StoreLimitFreshRef {
  _StoreLimitFreshProviderElement(super.provider);

  @override
  String? get companyId => (origin as StoreLimitFreshProvider).companyId;
}

String _$employeeLimitFreshHash() =>
    r'bf362dae9c25ad5b83b68cae5a2d26618e8355f3';

/// Fresh employee limit check from RPC
///
/// Call this when user clicks "Add Employee" button to get latest count.
/// Pass companyId to check limit for specific company.
///
/// Copied from [employeeLimitFresh].
@ProviderFor(employeeLimitFresh)
const employeeLimitFreshProvider = EmployeeLimitFreshFamily();

/// Fresh employee limit check from RPC
///
/// Call this when user clicks "Add Employee" button to get latest count.
/// Pass companyId to check limit for specific company.
///
/// Copied from [employeeLimitFresh].
class EmployeeLimitFreshFamily
    extends Family<AsyncValue<SubscriptionLimitCheck>> {
  /// Fresh employee limit check from RPC
  ///
  /// Call this when user clicks "Add Employee" button to get latest count.
  /// Pass companyId to check limit for specific company.
  ///
  /// Copied from [employeeLimitFresh].
  const EmployeeLimitFreshFamily();

  /// Fresh employee limit check from RPC
  ///
  /// Call this when user clicks "Add Employee" button to get latest count.
  /// Pass companyId to check limit for specific company.
  ///
  /// Copied from [employeeLimitFresh].
  EmployeeLimitFreshProvider call({
    String? companyId,
  }) {
    return EmployeeLimitFreshProvider(
      companyId: companyId,
    );
  }

  @override
  EmployeeLimitFreshProvider getProviderOverride(
    covariant EmployeeLimitFreshProvider provider,
  ) {
    return call(
      companyId: provider.companyId,
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
  String? get name => r'employeeLimitFreshProvider';
}

/// Fresh employee limit check from RPC
///
/// Call this when user clicks "Add Employee" button to get latest count.
/// Pass companyId to check limit for specific company.
///
/// Copied from [employeeLimitFresh].
class EmployeeLimitFreshProvider
    extends AutoDisposeFutureProvider<SubscriptionLimitCheck> {
  /// Fresh employee limit check from RPC
  ///
  /// Call this when user clicks "Add Employee" button to get latest count.
  /// Pass companyId to check limit for specific company.
  ///
  /// Copied from [employeeLimitFresh].
  EmployeeLimitFreshProvider({
    String? companyId,
  }) : this._internal(
          (ref) => employeeLimitFresh(
            ref as EmployeeLimitFreshRef,
            companyId: companyId,
          ),
          from: employeeLimitFreshProvider,
          name: r'employeeLimitFreshProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$employeeLimitFreshHash,
          dependencies: EmployeeLimitFreshFamily._dependencies,
          allTransitiveDependencies:
              EmployeeLimitFreshFamily._allTransitiveDependencies,
          companyId: companyId,
        );

  EmployeeLimitFreshProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.companyId,
  }) : super.internal();

  final String? companyId;

  @override
  Override overrideWith(
    FutureOr<SubscriptionLimitCheck> Function(EmployeeLimitFreshRef provider)
        create,
  ) {
    return ProviderOverride(
      origin: this,
      override: EmployeeLimitFreshProvider._internal(
        (ref) => create(ref as EmployeeLimitFreshRef),
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
  AutoDisposeFutureProviderElement<SubscriptionLimitCheck> createElement() {
    return _EmployeeLimitFreshProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is EmployeeLimitFreshProvider && other.companyId == companyId;
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
mixin EmployeeLimitFreshRef
    on AutoDisposeFutureProviderRef<SubscriptionLimitCheck> {
  /// The parameter `companyId` of this provider.
  String? get companyId;
}

class _EmployeeLimitFreshProviderElement
    extends AutoDisposeFutureProviderElement<SubscriptionLimitCheck>
    with EmployeeLimitFreshRef {
  _EmployeeLimitFreshProviderElement(super.provider);

  @override
  String? get companyId => (origin as EmployeeLimitFreshProvider).companyId;
}

String _$isProPlanHash() => r'd84bba11050d80930de98a1f74fe6240774fe619';

/// Check if current plan is Pro (unlimited everything)
///
/// Copied from [isProPlan].
@ProviderFor(isProPlan)
final isProPlanProvider = AutoDisposeProvider<bool>.internal(
  isProPlan,
  name: r'isProPlanProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$isProPlanHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef IsProPlanRef = AutoDisposeProviderRef<bool>;
String _$shouldShowUpgradePromptHash() =>
    r'c4928377b9a1f42da92e019bfe266514771035aa';

/// Check if user should see upgrade prompt
///
/// Copied from [shouldShowUpgradePrompt].
@ProviderFor(shouldShowUpgradePrompt)
final shouldShowUpgradePromptProvider = AutoDisposeProvider<bool>.internal(
  shouldShowUpgradePrompt,
  name: r'shouldShowUpgradePromptProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$shouldShowUpgradePromptHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ShouldShowUpgradePromptRef = AutoDisposeProviderRef<bool>;
String _$employeeLimitFromSubscriptionStateHash() =>
    r'fb35fce863a827883b19bd621781b297a4925e8c';

/// Employee limit check from SubscriptionStateNotifier
///
/// New 2026 provider that uses real-time subscription data.
/// Falls back to AppState if SubscriptionState is not yet loaded.
///
/// Combines SubscriptionState (limits) + AppState (usage counts).
///
/// Copied from [employeeLimitFromSubscriptionState].
@ProviderFor(employeeLimitFromSubscriptionState)
final employeeLimitFromSubscriptionStateProvider =
    AutoDisposeProvider<SubscriptionLimitCheck>.internal(
  employeeLimitFromSubscriptionState,
  name: r'employeeLimitFromSubscriptionStateProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$employeeLimitFromSubscriptionStateHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef EmployeeLimitFromSubscriptionStateRef
    = AutoDisposeProviderRef<SubscriptionLimitCheck>;
String _$storeLimitFromSubscriptionStateHash() =>
    r'5ca9e4f492dffb84ad4d770b81b06648b5203af8';

/// Store limit check from SubscriptionStateNotifier
///
/// Copied from [storeLimitFromSubscriptionState].
@ProviderFor(storeLimitFromSubscriptionState)
final storeLimitFromSubscriptionStateProvider =
    AutoDisposeProvider<SubscriptionLimitCheck>.internal(
  storeLimitFromSubscriptionState,
  name: r'storeLimitFromSubscriptionStateProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$storeLimitFromSubscriptionStateHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef StoreLimitFromSubscriptionStateRef
    = AutoDisposeProviderRef<SubscriptionLimitCheck>;
String _$companyLimitFromSubscriptionStateHash() =>
    r'c268ec2a8a20e5fadc51d45dbb5ef1250d2dd2ce';

/// Company limit check from SubscriptionStateNotifier
///
/// Copied from [companyLimitFromSubscriptionState].
@ProviderFor(companyLimitFromSubscriptionState)
final companyLimitFromSubscriptionStateProvider =
    AutoDisposeProvider<SubscriptionLimitCheck>.internal(
  companyLimitFromSubscriptionState,
  name: r'companyLimitFromSubscriptionStateProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$companyLimitFromSubscriptionStateHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef CompanyLimitFromSubscriptionStateRef
    = AutoDisposeProviderRef<SubscriptionLimitCheck>;
String _$isSubscriptionDataStaleHash() =>
    r'0b1c6a39b0cba59531a7839036113198357e0405';

/// Check if subscription is stale and needs refresh
///
/// Copied from [isSubscriptionDataStale].
@ProviderFor(isSubscriptionDataStale)
final isSubscriptionDataStaleProvider = AutoDisposeProvider<bool>.internal(
  isSubscriptionDataStale,
  name: r'isSubscriptionDataStaleProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$isSubscriptionDataStaleHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef IsSubscriptionDataStaleRef = AutoDisposeProviderRef<bool>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
