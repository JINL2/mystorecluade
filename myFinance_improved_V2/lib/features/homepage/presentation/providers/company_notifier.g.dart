// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'company_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$companyNotifierHash() => r'4429b3e5de7efd80292e2742d8a4ea779ea34363';

/// Notifier for managing Company creation state
///
/// Migrated from StateNotifier to @riverpod Notifier pattern.
/// Uses CompanyState (freezed) for type-safe state management.
///
/// Copied from [CompanyNotifier].
@ProviderFor(CompanyNotifier)
final companyNotifierProvider =
    AutoDisposeNotifierProvider<CompanyNotifier, CompanyState>.internal(
  CompanyNotifier.new,
  name: r'companyNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$companyNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$CompanyNotifier = AutoDisposeNotifier<CompanyState>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
