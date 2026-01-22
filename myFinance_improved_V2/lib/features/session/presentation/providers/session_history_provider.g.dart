// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'session_history_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$sessionHistoryFilterHash() =>
    r'20a3553329b433a95b85d08a836d00bf66fb46df';

/// Provider for filter state only (for UI)
/// This is a simple derived provider that extracts filter from history state
///
/// Copied from [sessionHistoryFilter].
@ProviderFor(sessionHistoryFilter)
final sessionHistoryFilterProvider =
    AutoDisposeProvider<SessionHistoryFilterState>.internal(
  sessionHistoryFilter,
  name: r'sessionHistoryFilterProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$sessionHistoryFilterHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef SessionHistoryFilterRef
    = AutoDisposeProviderRef<SessionHistoryFilterState>;
String _$sessionHistoryNotifierHash() =>
    r'1278d1528afbea8d17182474489332e3da12c4a1';

/// Notifier for session history state management
/// Migrated to @riverpod from StateNotifier (2025 Best Practice)
///
/// Copied from [SessionHistoryNotifier].
@ProviderFor(SessionHistoryNotifier)
final sessionHistoryNotifierProvider = AutoDisposeNotifierProvider<
    SessionHistoryNotifier, SessionHistoryState>.internal(
  SessionHistoryNotifier.new,
  name: r'sessionHistoryNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$sessionHistoryNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$SessionHistoryNotifier = AutoDisposeNotifier<SessionHistoryState>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
