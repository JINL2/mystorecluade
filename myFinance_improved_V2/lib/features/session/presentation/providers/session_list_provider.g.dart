// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'session_list_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$sessionListNotifierHash() =>
    r'c22f07055c08fdd3d8a3fd012b3e6dbe2b6ad73c';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

abstract class _$SessionListNotifier
    extends BuildlessAutoDisposeNotifier<SessionListState> {
  late final String sessionType;

  SessionListState build(
    String sessionType,
  );
}

/// Notifier for session list state management
/// Migrated to @riverpod from StateNotifier (2025 Best Practice)
///
/// Copied from [SessionListNotifier].
@ProviderFor(SessionListNotifier)
const sessionListNotifierProvider = SessionListNotifierFamily();

/// Notifier for session list state management
/// Migrated to @riverpod from StateNotifier (2025 Best Practice)
///
/// Copied from [SessionListNotifier].
class SessionListNotifierFamily extends Family<SessionListState> {
  /// Notifier for session list state management
  /// Migrated to @riverpod from StateNotifier (2025 Best Practice)
  ///
  /// Copied from [SessionListNotifier].
  const SessionListNotifierFamily();

  /// Notifier for session list state management
  /// Migrated to @riverpod from StateNotifier (2025 Best Practice)
  ///
  /// Copied from [SessionListNotifier].
  SessionListNotifierProvider call(
    String sessionType,
  ) {
    return SessionListNotifierProvider(
      sessionType,
    );
  }

  @override
  SessionListNotifierProvider getProviderOverride(
    covariant SessionListNotifierProvider provider,
  ) {
    return call(
      provider.sessionType,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'sessionListNotifierProvider';
}

/// Notifier for session list state management
/// Migrated to @riverpod from StateNotifier (2025 Best Practice)
///
/// Copied from [SessionListNotifier].
class SessionListNotifierProvider extends AutoDisposeNotifierProviderImpl<
    SessionListNotifier, SessionListState> {
  /// Notifier for session list state management
  /// Migrated to @riverpod from StateNotifier (2025 Best Practice)
  ///
  /// Copied from [SessionListNotifier].
  SessionListNotifierProvider(
    String sessionType,
  ) : this._internal(
          () => SessionListNotifier()..sessionType = sessionType,
          from: sessionListNotifierProvider,
          name: r'sessionListNotifierProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$sessionListNotifierHash,
          dependencies: SessionListNotifierFamily._dependencies,
          allTransitiveDependencies:
              SessionListNotifierFamily._allTransitiveDependencies,
          sessionType: sessionType,
        );

  SessionListNotifierProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.sessionType,
  }) : super.internal();

  final String sessionType;

  @override
  SessionListState runNotifierBuild(
    covariant SessionListNotifier notifier,
  ) {
    return notifier.build(
      sessionType,
    );
  }

  @override
  Override overrideWith(SessionListNotifier Function() create) {
    return ProviderOverride(
      origin: this,
      override: SessionListNotifierProvider._internal(
        () => create()..sessionType = sessionType,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        sessionType: sessionType,
      ),
    );
  }

  @override
  AutoDisposeNotifierProviderElement<SessionListNotifier, SessionListState>
      createElement() {
    return _SessionListNotifierProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is SessionListNotifierProvider &&
        other.sessionType == sessionType;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, sessionType.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin SessionListNotifierRef
    on AutoDisposeNotifierProviderRef<SessionListState> {
  /// The parameter `sessionType` of this provider.
  String get sessionType;
}

class _SessionListNotifierProviderElement
    extends AutoDisposeNotifierProviderElement<SessionListNotifier,
        SessionListState> with SessionListNotifierRef {
  _SessionListNotifierProviderElement(super.provider);

  @override
  String get sessionType => (origin as SessionListNotifierProvider).sessionType;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
