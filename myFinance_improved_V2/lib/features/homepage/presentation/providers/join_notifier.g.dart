// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'join_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$joinNotifierHash() => r'672219210af83be5356a850b9390a0f7d90da94d';

/// Notifier for managing join operations
///
/// Migrated from StateNotifier to @riverpod Notifier pattern.
/// Handles the state flow for joining companies/stores by code.
/// States: Initial → Loading → Success/Error
///
/// Copied from [JoinNotifier].
@ProviderFor(JoinNotifier)
final joinNotifierProvider =
    AutoDisposeNotifierProvider<JoinNotifier, JoinState>.internal(
  JoinNotifier.new,
  name: r'joinNotifierProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$joinNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$JoinNotifier = AutoDisposeNotifier<JoinState>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
