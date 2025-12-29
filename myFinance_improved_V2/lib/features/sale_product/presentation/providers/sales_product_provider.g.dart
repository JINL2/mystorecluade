// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sales_product_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$salesProductNotifierHash() =>
    r'2134b69ed9348d51ce0959fb8815cdf651e7d804';

/// Sales product notifier - manages product loading and state
///
/// Uses @Riverpod(keepAlive: true) to persist state across navigation.
/// State is SalesProductState (freezed) for complex UI state management.
///
/// Copied from [SalesProductNotifier].
@ProviderFor(SalesProductNotifier)
final salesProductNotifierProvider =
    NotifierProvider<SalesProductNotifier, SalesProductState>.internal(
  SalesProductNotifier.new,
  name: r'salesProductNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$salesProductNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$SalesProductNotifier = Notifier<SalesProductState>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
