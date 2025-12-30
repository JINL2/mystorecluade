// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'exchange_rate_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$saleExchangeRateNotifierHash() =>
    r'1d07966331d1dff0e7f16a7805564e39fce1cbc0';

/// Provider to fetch and manage exchange rates
///
/// Uses @riverpod for automatic code generation and better type safety.
/// Returns AsyncValue<ExchangeRateData?> for loading/error states.
///
/// Copied from [SaleExchangeRateNotifier].
@ProviderFor(SaleExchangeRateNotifier)
final saleExchangeRateNotifierProvider = AutoDisposeAsyncNotifierProvider<
    SaleExchangeRateNotifier, ExchangeRateData?>.internal(
  SaleExchangeRateNotifier.new,
  name: r'saleExchangeRateNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$saleExchangeRateNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$SaleExchangeRateNotifier
    = AutoDisposeAsyncNotifier<ExchangeRateData?>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
