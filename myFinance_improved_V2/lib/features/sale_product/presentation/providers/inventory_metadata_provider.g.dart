// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'inventory_metadata_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$inventoryMetadataNotifierHash() =>
    r'4e423ee70b281d503e15e676bb783acf84c0b9d4';

/// Provider to fetch inventory metadata including brands, categories, etc.
///
/// Uses @riverpod for automatic code generation and better type safety.
/// Returns AsyncValue<InventoryMetadata?> for loading/error states.
///
/// Copied from [InventoryMetadataNotifier].
@ProviderFor(InventoryMetadataNotifier)
final inventoryMetadataNotifierProvider = AutoDisposeAsyncNotifierProvider<
    InventoryMetadataNotifier, InventoryMetadata?>.internal(
  InventoryMetadataNotifier.new,
  name: r'inventoryMetadataNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$inventoryMetadataNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$InventoryMetadataNotifier
    = AutoDisposeAsyncNotifier<InventoryMetadata?>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
