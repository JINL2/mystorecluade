// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sale_preload_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$salePreloadNotifierHash() =>
    r'1a27810d6d1c3b6384d9052fd51ee99d65e861f4';

/// Provider to preload sale data (exchange rates + cash locations)
///
/// Uses @riverpod for automatic code generation and better type safety.
/// Returns AsyncValue<SalePreloadData> for loading/error states.
///
/// Copied from [SalePreloadNotifier].
@ProviderFor(SalePreloadNotifier)
final salePreloadNotifierProvider = AutoDisposeAsyncNotifierProvider<
    SalePreloadNotifier, SalePreloadData>.internal(
  SalePreloadNotifier.new,
  name: r'salePreloadNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$salePreloadNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$SalePreloadNotifier = AutoDisposeAsyncNotifier<SalePreloadData>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
