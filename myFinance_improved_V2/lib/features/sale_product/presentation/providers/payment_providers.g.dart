// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payment_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$paymentMethodDataHash() => r'06b90fbf61e428f2f5b20158b2a9fdb360d980d6';

/// Provider to auto-load currency data when company changes
///
/// Copied from [paymentMethodData].
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
    r'2b53eb5172c693aede372cba065701d3ddc384ee';

/// Payment method notifier - manages payment method selection and currency data
///
/// Uses @riverpod for auto-dispose behavior (resets when leaving payment page).
/// State is PaymentMethodState (freezed) for complex UI state management.
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
