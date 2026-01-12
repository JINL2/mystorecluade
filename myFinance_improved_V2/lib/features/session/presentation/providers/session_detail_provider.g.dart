// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'session_detail_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$sessionDetailNotifierHash() =>
    r'97552a3f6dc398849d31444b5d6fa7d3f6600e38';

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

abstract class _$SessionDetailNotifier
    extends BuildlessAutoDisposeNotifier<SessionDetailState> {
  late final ({
    String sessionId,
    String? sessionName,
    String sessionType,
    String storeId
  }) params;

  SessionDetailState build(
    ({
      String sessionId,
      String? sessionName,
      String sessionType,
      String storeId
    }) params,
  );
}

/// Notifier for session detail state management
/// Migrated to @riverpod from StateNotifier (2025 Best Practice)
///
/// Copied from [SessionDetailNotifier].
@ProviderFor(SessionDetailNotifier)
const sessionDetailNotifierProvider = SessionDetailNotifierFamily();

/// Notifier for session detail state management
/// Migrated to @riverpod from StateNotifier (2025 Best Practice)
///
/// Copied from [SessionDetailNotifier].
class SessionDetailNotifierFamily extends Family<SessionDetailState> {
  /// Notifier for session detail state management
  /// Migrated to @riverpod from StateNotifier (2025 Best Practice)
  ///
  /// Copied from [SessionDetailNotifier].
  const SessionDetailNotifierFamily();

  /// Notifier for session detail state management
  /// Migrated to @riverpod from StateNotifier (2025 Best Practice)
  ///
  /// Copied from [SessionDetailNotifier].
  SessionDetailNotifierProvider call(
    ({
      String sessionId,
      String? sessionName,
      String sessionType,
      String storeId
    }) params,
  ) {
    return SessionDetailNotifierProvider(
      params,
    );
  }

  @override
  SessionDetailNotifierProvider getProviderOverride(
    covariant SessionDetailNotifierProvider provider,
  ) {
    return call(
      provider.params,
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
  String? get name => r'sessionDetailNotifierProvider';
}

/// Notifier for session detail state management
/// Migrated to @riverpod from StateNotifier (2025 Best Practice)
///
/// Copied from [SessionDetailNotifier].
class SessionDetailNotifierProvider extends AutoDisposeNotifierProviderImpl<
    SessionDetailNotifier, SessionDetailState> {
  /// Notifier for session detail state management
  /// Migrated to @riverpod from StateNotifier (2025 Best Practice)
  ///
  /// Copied from [SessionDetailNotifier].
  SessionDetailNotifierProvider(
    ({
      String sessionId,
      String? sessionName,
      String sessionType,
      String storeId
    }) params,
  ) : this._internal(
          () => SessionDetailNotifier()..params = params,
          from: sessionDetailNotifierProvider,
          name: r'sessionDetailNotifierProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$sessionDetailNotifierHash,
          dependencies: SessionDetailNotifierFamily._dependencies,
          allTransitiveDependencies:
              SessionDetailNotifierFamily._allTransitiveDependencies,
          params: params,
        );

  SessionDetailNotifierProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.params,
  }) : super.internal();

  final ({
    String sessionId,
    String? sessionName,
    String sessionType,
    String storeId
  }) params;

  @override
  SessionDetailState runNotifierBuild(
    covariant SessionDetailNotifier notifier,
  ) {
    return notifier.build(
      params,
    );
  }

  @override
  Override overrideWith(SessionDetailNotifier Function() create) {
    return ProviderOverride(
      origin: this,
      override: SessionDetailNotifierProvider._internal(
        () => create()..params = params,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        params: params,
      ),
    );
  }

  @override
  AutoDisposeNotifierProviderElement<SessionDetailNotifier, SessionDetailState>
      createElement() {
    return _SessionDetailNotifierProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is SessionDetailNotifierProvider && other.params == params;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, params.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin SessionDetailNotifierRef
    on AutoDisposeNotifierProviderRef<SessionDetailState> {
  /// The parameter `params` of this provider.
  ({String sessionId, String? sessionName, String sessionType, String storeId})
      get params;
}

class _SessionDetailNotifierProviderElement
    extends AutoDisposeNotifierProviderElement<SessionDetailNotifier,
        SessionDetailState> with SessionDetailNotifierRef {
  _SessionDetailNotifierProviderElement(super.provider);

  @override
  ({String sessionId, String? sessionName, String sessionType, String storeId})
      get params => (origin as SessionDetailNotifierProvider).params;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
