// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'subscription_state_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

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
