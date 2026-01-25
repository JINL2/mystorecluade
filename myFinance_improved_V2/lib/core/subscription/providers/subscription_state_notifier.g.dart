// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'subscription_state_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$currentPlanNameHash() => r'c42ad9151da3ab7503b5366dd15cb329a2bdda0a';

/// 현재 플랜 이름 (free, basic, pro)
///
/// Copied from [currentPlanName].
@ProviderFor(currentPlanName)
final currentPlanNameProvider = AutoDisposeProvider<String>.internal(
  currentPlanName,
  name: r'currentPlanNameProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$currentPlanNameHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef CurrentPlanNameRef = AutoDisposeProviderRef<String>;
String _$isPaidSubscriptionHash() =>
    r'07827bfd16338760176494a9afc7588d03665924';

/// 유료 구독 여부
///
/// Copied from [isPaidSubscription].
@ProviderFor(isPaidSubscription)
final isPaidSubscriptionProvider = AutoDisposeProvider<bool>.internal(
  isPaidSubscription,
  name: r'isPaidSubscriptionProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$isPaidSubscriptionHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef IsPaidSubscriptionRef = AutoDisposeProviderRef<bool>;
String _$subscriptionSyncStatusHash() =>
    r'e6254d03953e7cd0f72ef29b71291672ca3a45e1';

/// 구독 동기화 상태
///
/// Copied from [subscriptionSyncStatus].
@ProviderFor(subscriptionSyncStatus)
final subscriptionSyncStatusProvider = AutoDisposeProvider<SyncStatus>.internal(
  subscriptionSyncStatus,
  name: r'subscriptionSyncStatusProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$subscriptionSyncStatusHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef SubscriptionSyncStatusRef = AutoDisposeProviderRef<SyncStatus>;
String _$isSubscriptionStaleHash() =>
    r'25e5de1054343f49b9c933cf621ed57755aaed53';

/// 구독 데이터 stale 여부
///
/// Copied from [isSubscriptionStale].
@ProviderFor(isSubscriptionStale)
final isSubscriptionStaleProvider = AutoDisposeProvider<bool>.internal(
  isSubscriptionStale,
  name: r'isSubscriptionStaleProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$isSubscriptionStaleHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef IsSubscriptionStaleRef = AutoDisposeProviderRef<bool>;
String _$subscriptionStateNotifierHash() =>
    r'e7dc8225b2c57d3f4f9ed06710200487e0f47381';

/// 구독 상태 관리 Notifier (SSOT)
///
/// 앱 전체에서 구독 상태를 관리하는 중앙 허브.
/// UI에서 구독 정보가 필요하면 이 provider를 watch하세요.
///
/// Copied from [SubscriptionStateNotifier].
@ProviderFor(SubscriptionStateNotifier)
final subscriptionStateNotifierProvider = AsyncNotifierProvider<
    SubscriptionStateNotifier, SubscriptionState>.internal(
  SubscriptionStateNotifier.new,
  name: r'subscriptionStateNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$subscriptionStateNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$SubscriptionStateNotifier = AsyncNotifier<SubscriptionState>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
