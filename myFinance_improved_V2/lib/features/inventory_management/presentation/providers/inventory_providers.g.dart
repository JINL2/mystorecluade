// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'inventory_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$inventoryMetadataNotifierHash() =>
    r'18d150c2953fcfef8d43005700614b88e1c07529';

/// Inventory Metadata Notifier
/// Fetches categories, brands, units, etc.
///
/// Copied from [InventoryMetadataNotifier].
@ProviderFor(InventoryMetadataNotifier)
final inventoryMetadataNotifierProvider = AutoDisposeNotifierProvider<
    InventoryMetadataNotifier, InventoryMetadataState>.internal(
  InventoryMetadataNotifier.new,
  name: r'inventoryMetadataNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$inventoryMetadataNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$InventoryMetadataNotifier
    = AutoDisposeNotifier<InventoryMetadataState>;
String _$inventoryPageNotifierHash() =>
    r'46c1a94c15ae435f18f4c11bdee3df5e1c23030b';

/// Inventory Page Notifier
/// Manages product list, filters, sorting, and pagination
///
/// Copied from [InventoryPageNotifier].
@ProviderFor(InventoryPageNotifier)
final inventoryPageNotifierProvider = AutoDisposeNotifierProvider<
    InventoryPageNotifier, InventoryPageState>.internal(
  InventoryPageNotifier.new,
  name: r'inventoryPageNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$inventoryPageNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$InventoryPageNotifier = AutoDisposeNotifier<InventoryPageState>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
