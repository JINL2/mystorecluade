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
String _$availablePackagesHash() => r'307c8b65005afc9164daa81091105073fdf38b8f';

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
String _$customerInfoHash() => r'be6c42aa703b5e60e734c3e9f07674078744875a';

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
String _$subscriptionPlansHash() => r'6de5da51b460fea774bb915435b5b1d92e249e4e';

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
String _$subscriptionDetailsHash() =>
    r'83951fd31e82a4a4d927df69d8bc1fb8a8c8f95e';

/// Provider for subscription details including trial information
///
/// Returns comprehensive subscription details combining:
/// 1. **Supabase DB** (SubscriptionStateNotifier) - Stripe 웹 결제 반영
/// 2. **RevenueCat SDK** - iOS/Android 앱 내 결제 반영
///
/// ## 데이터 소스 우선순위
/// - DB에 유료 플랜이 있으면 DB 데이터 우선 (Stripe 결제)
/// - RevenueCat에만 유료 플랜이 있으면 RevenueCat 사용 (앱 내 결제)
/// - 둘 다 없으면 free
///
/// 2026 Update: Now watches subscriptionStateNotifierProvider to auto-refresh
/// when Supabase Realtime detects subscription changes (e.g., from web/Stripe).
///
/// keepAlive: true - Provider stays alive so Realtime updates work even when
/// my_page is not on screen. Without this, autoDispose would disconnect
/// the watch link when user navigates away.
///
/// ## Data Source Priority (DB is SSOT)
/// DB (Supabase) is the Single Source of Truth because:
/// 1. RevenueCat webhook updates DB on purchase/cancel
/// 2. Stripe webhook updates DB on web purchase/cancel
/// 3. DB has the most accurate, up-to-date state
///
/// RevenueCat SDK cache can be stale (shows old Pro status after cancellation),
/// so we ALWAYS trust DB over RevenueCat SDK.
///
/// Copied from [subscriptionDetails].
@ProviderFor(subscriptionDetails)
final subscriptionDetailsProvider =
    FutureProvider<SubscriptionDetails>.internal(
  subscriptionDetails,
  name: r'subscriptionDetailsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$subscriptionDetailsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef SubscriptionDetailsRef = FutureProviderRef<SubscriptionDetails>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
