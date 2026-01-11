// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cart_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$cartNotifierHash() => r'286eae22cd6722adc56df746c348f76af64bafa4';

/// Cart notifier - manages shopping cart state
///
/// Uses @Riverpod(keepAlive: true) to persist cart data across navigation.
/// State is List<CartItem> for synchronous updates.
/// Supports variant products from get_inventory_page_v6.
///
/// Copied from [CartNotifier].
@ProviderFor(CartNotifier)
final cartNotifierProvider =
    NotifierProvider<CartNotifier, List<CartItem>>.internal(
  CartNotifier.new,
  name: r'cartNotifierProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$cartNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$CartNotifier = Notifier<List<CartItem>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
