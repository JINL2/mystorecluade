// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payment_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$paymentMethodDataHash() => r'd8f97d02fc19c31fc3f59138a2541603e03f7f95';

/// See also [paymentMethodData].
@ProviderFor(paymentMethodData)
final paymentMethodDataProvider = AutoDisposeFutureProvider<void>.internal(
  paymentMethodData,
  name: r'paymentMethodDataProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$paymentMethodDataHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef PaymentMethodDataRef = AutoDisposeFutureProviderRef<void>;
String _$paymentMethodNotifierHash() =>
    r'afd1ab75925df983105ab1cdef0936c2d15123fe';

/// Payment method notifier using @riverpod
///
/// Copied from [PaymentMethodNotifier].
@ProviderFor(PaymentMethodNotifier)
final paymentMethodNotifierProvider = AutoDisposeNotifierProvider<
    PaymentMethodNotifier, PaymentMethodState>.internal(
  PaymentMethodNotifier.new,
  name: r'paymentMethodNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$paymentMethodNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$PaymentMethodNotifier = AutoDisposeNotifier<PaymentMethodState>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
