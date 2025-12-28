// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'subscription_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$subscriptionDataSourceHash() =>
    r'ca770399284f4103c4223b95dcad955988521a69';

/// SubscriptionDataSource Provider
///
/// Copied from [subscriptionDataSource].
@ProviderFor(subscriptionDataSource)
final subscriptionDataSourceProvider =
    Provider<SubscriptionDataSource>.internal(
  subscriptionDataSource,
  name: r'subscriptionDataSourceProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$subscriptionDataSourceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef SubscriptionDataSourceRef = ProviderRef<SubscriptionDataSource>;
String _$isProHash() => r'ebd40dd4037a0caaf841b9460f48c9fd6e6d76e1';

/// Simple provider to check if user is Pro
///
/// Use this provider to conditionally show Pro features:
/// ```dart
/// final isPro = ref.watch(isProProvider);
/// if (isPro) {
///   // Show Pro feature
/// }
/// ```
///
/// Copied from [isPro].
@ProviderFor(isPro)
final isProProvider = AutoDisposeProvider<bool>.internal(
  isPro,
  name: r'isProProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$isProHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef IsProRef = AutoDisposeProviderRef<bool>;
String _$proStatusHash() => r'96ed5a3ee426b94dc5d137dbcf4142c8c9ad1153';

/// FutureProvider to fetch Pro status from RevenueCat
///
/// Automatically fetches and caches the Pro status.
/// Use ref.invalidate(proStatusProvider) to refresh.
///
/// Copied from [proStatus].
@ProviderFor(proStatus)
final proStatusProvider = AutoDisposeFutureProvider<bool>.internal(
  proStatus,
  name: r'proStatusProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$proStatusHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ProStatusRef = AutoDisposeFutureProviderRef<bool>;
String _$availablePackagesHash() => r'21e3c36e4645d9e995b2d0218e80f1d1cb544b2b';

/// Provider for available packages (subscription options)
///
/// Copied from [availablePackages].
@ProviderFor(availablePackages)
final availablePackagesProvider =
    AutoDisposeFutureProvider<List<Package>>.internal(
  availablePackages,
  name: r'availablePackagesProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$availablePackagesHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef AvailablePackagesRef = AutoDisposeFutureProviderRef<List<Package>>;
String _$customerInfoHash() => r'bf006722b5f0eb25aeb8bd6b34e3699502a846c0';

/// Provider for customer info
///
/// Copied from [customerInfo].
@ProviderFor(customerInfo)
final customerInfoProvider = AutoDisposeFutureProvider<CustomerInfo?>.internal(
  customerInfo,
  name: r'customerInfoProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$customerInfoHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef CustomerInfoRef = AutoDisposeFutureProviderRef<CustomerInfo?>;
String _$subscriptionPlansHash() => r'c52462e1e012ead91145279de152542fee07348a';

/// Provider for subscription plans from database
///
/// Fetches all active subscription plans from Supabase.
/// Automatically caches the result. Use ref.invalidate() to refresh.
///
/// Copied from [subscriptionPlans].
@ProviderFor(subscriptionPlans)
final subscriptionPlansProvider =
    AutoDisposeFutureProvider<List<SubscriptionPlan>>.internal(
  subscriptionPlans,
  name: r'subscriptionPlansProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$subscriptionPlansHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef SubscriptionPlansRef
    = AutoDisposeFutureProviderRef<List<SubscriptionPlan>>;
String _$subscriptionPlanByNameHash() =>
    r'ec628fef33d74a1a994f922f1f71052cda5b2f50';

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

/// Provider for a specific plan by name
///
/// Copied from [subscriptionPlanByName].
@ProviderFor(subscriptionPlanByName)
const subscriptionPlanByNameProvider = SubscriptionPlanByNameFamily();

/// Provider for a specific plan by name
///
/// Copied from [subscriptionPlanByName].
class SubscriptionPlanByNameFamily
    extends Family<AsyncValue<SubscriptionPlan?>> {
  /// Provider for a specific plan by name
  ///
  /// Copied from [subscriptionPlanByName].
  const SubscriptionPlanByNameFamily();

  /// Provider for a specific plan by name
  ///
  /// Copied from [subscriptionPlanByName].
  SubscriptionPlanByNameProvider call(
    String planName,
  ) {
    return SubscriptionPlanByNameProvider(
      planName,
    );
  }

  @override
  SubscriptionPlanByNameProvider getProviderOverride(
    covariant SubscriptionPlanByNameProvider provider,
  ) {
    return call(
      provider.planName,
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
  String? get name => r'subscriptionPlanByNameProvider';
}

/// Provider for a specific plan by name
///
/// Copied from [subscriptionPlanByName].
class SubscriptionPlanByNameProvider
    extends AutoDisposeFutureProvider<SubscriptionPlan?> {
  /// Provider for a specific plan by name
  ///
  /// Copied from [subscriptionPlanByName].
  SubscriptionPlanByNameProvider(
    String planName,
  ) : this._internal(
          (ref) => subscriptionPlanByName(
            ref as SubscriptionPlanByNameRef,
            planName,
          ),
          from: subscriptionPlanByNameProvider,
          name: r'subscriptionPlanByNameProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$subscriptionPlanByNameHash,
          dependencies: SubscriptionPlanByNameFamily._dependencies,
          allTransitiveDependencies:
              SubscriptionPlanByNameFamily._allTransitiveDependencies,
          planName: planName,
        );

  SubscriptionPlanByNameProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.planName,
  }) : super.internal();

  final String planName;

  @override
  Override overrideWith(
    FutureOr<SubscriptionPlan?> Function(SubscriptionPlanByNameRef provider)
        create,
  ) {
    return ProviderOverride(
      origin: this,
      override: SubscriptionPlanByNameProvider._internal(
        (ref) => create(ref as SubscriptionPlanByNameRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        planName: planName,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<SubscriptionPlan?> createElement() {
    return _SubscriptionPlanByNameProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is SubscriptionPlanByNameProvider &&
        other.planName == planName;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, planName.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin SubscriptionPlanByNameRef
    on AutoDisposeFutureProviderRef<SubscriptionPlan?> {
  /// The parameter `planName` of this provider.
  String get planName;
}

class _SubscriptionPlanByNameProviderElement
    extends AutoDisposeFutureProviderElement<SubscriptionPlan?>
    with SubscriptionPlanByNameRef {
  _SubscriptionPlanByNameProviderElement(super.provider);

  @override
  String get planName => (origin as SubscriptionPlanByNameProvider).planName;
}

String _$basicPlanHash() => r'5a454376c959e115cd40184f75857e1b835f408c';

/// Provider for Basic plan
///
/// Copied from [basicPlan].
@ProviderFor(basicPlan)
final basicPlanProvider = AutoDisposeFutureProvider<SubscriptionPlan?>.internal(
  basicPlan,
  name: r'basicPlanProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$basicPlanHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef BasicPlanRef = AutoDisposeFutureProviderRef<SubscriptionPlan?>;
String _$proPlanHash() => r'010230633c0439705cc9822c82e7e1744ba867aa';

/// Provider for Pro plan
///
/// Copied from [proPlan].
@ProviderFor(proPlan)
final proPlanProvider = AutoDisposeFutureProvider<SubscriptionPlan?>.internal(
  proPlan,
  name: r'proPlanProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$proPlanHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ProPlanRef = AutoDisposeFutureProviderRef<SubscriptionPlan?>;
String _$subscriptionNotifierHash() =>
    r'aada39d1c6d9a59164350dedca19b60dfd7209a6';

/// Subscription notifier for managing subscription state
///
/// Copied from [SubscriptionNotifier].
@ProviderFor(SubscriptionNotifier)
final subscriptionNotifierProvider = AutoDisposeNotifierProvider<
    SubscriptionNotifier, SubscriptionState>.internal(
  SubscriptionNotifier.new,
  name: r'subscriptionNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$subscriptionNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$SubscriptionNotifier = AutoDisposeNotifier<SubscriptionState>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
