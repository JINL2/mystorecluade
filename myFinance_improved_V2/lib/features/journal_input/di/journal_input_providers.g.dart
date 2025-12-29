// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'journal_input_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$supabaseClientHash() => r'834a58d6ae4b94e36f4e04a10d8a7684b929310e';

/// Supabase Client Provider
/// Singleton instance for all database operations
///
/// Copied from [supabaseClient].
@ProviderFor(supabaseClient)
final supabaseClientProvider = AutoDisposeProvider<SupabaseClient>.internal(
  supabaseClient,
  name: r'supabaseClientProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$supabaseClientHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef SupabaseClientRef = AutoDisposeProviderRef<SupabaseClient>;
String _$journalEntryDataSourceHash() =>
    r'62f6aa5eb2ed0476ef6e150b3e33e24a58669320';

/// Journal Entry DataSource
/// Handles all journal entry Supabase operations
///
/// Copied from [journalEntryDataSource].
@ProviderFor(journalEntryDataSource)
final journalEntryDataSourceProvider =
    AutoDisposeProvider<JournalEntryDataSource>.internal(
  journalEntryDataSource,
  name: r'journalEntryDataSourceProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$journalEntryDataSourceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef JournalEntryDataSourceRef
    = AutoDisposeProviderRef<JournalEntryDataSource>;
String _$journalEntryRepositoryHash() =>
    r'37dd28f153182119013a6ac1110adfda1200e4ae';

/// Journal Entry Repository
/// Implements domain JournalEntryRepository interface
///
/// Copied from [journalEntryRepository].
@ProviderFor(journalEntryRepository)
final journalEntryRepositoryProvider =
    AutoDisposeProvider<JournalEntryRepository>.internal(
  journalEntryRepository,
  name: r'journalEntryRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$journalEntryRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef JournalEntryRepositoryRef
    = AutoDisposeProviderRef<JournalEntryRepository>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
