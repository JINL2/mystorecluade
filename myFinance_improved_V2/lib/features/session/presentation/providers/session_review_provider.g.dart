// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'session_review_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$sessionReviewNotifierHash() =>
    r'8a70dd7ba1f64ccb93afa0a2ab065697ca319029';

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

abstract class _$SessionReviewNotifier
    extends BuildlessAutoDisposeNotifier<SessionReviewState> {
  late final ({
    String sessionId,
    String? sessionName,
    String sessionType,
    String storeId
  }) params;

  SessionReviewState build(
    ({
      String sessionId,
      String? sessionName,
      String sessionType,
      String storeId
    }) params,
  );
}

/// Notifier for session review state management
/// Migrated to @riverpod from StateNotifier (2025 Best Practice)
///
/// Copied from [SessionReviewNotifier].
@ProviderFor(SessionReviewNotifier)
const sessionReviewNotifierProvider = SessionReviewNotifierFamily();

/// Notifier for session review state management
/// Migrated to @riverpod from StateNotifier (2025 Best Practice)
///
/// Copied from [SessionReviewNotifier].
class SessionReviewNotifierFamily extends Family<SessionReviewState> {
  /// Notifier for session review state management
  /// Migrated to @riverpod from StateNotifier (2025 Best Practice)
  ///
  /// Copied from [SessionReviewNotifier].
  const SessionReviewNotifierFamily();

  /// Notifier for session review state management
  /// Migrated to @riverpod from StateNotifier (2025 Best Practice)
  ///
  /// Copied from [SessionReviewNotifier].
  SessionReviewNotifierProvider call(
    ({
      String sessionId,
      String? sessionName,
      String sessionType,
      String storeId
    }) params,
  ) {
    return SessionReviewNotifierProvider(
      params,
    );
  }

  @override
  SessionReviewNotifierProvider getProviderOverride(
    covariant SessionReviewNotifierProvider provider,
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
  String? get name => r'sessionReviewNotifierProvider';
}

/// Notifier for session review state management
/// Migrated to @riverpod from StateNotifier (2025 Best Practice)
///
/// Copied from [SessionReviewNotifier].
class SessionReviewNotifierProvider extends AutoDisposeNotifierProviderImpl<
    SessionReviewNotifier, SessionReviewState> {
  /// Notifier for session review state management
  /// Migrated to @riverpod from StateNotifier (2025 Best Practice)
  ///
  /// Copied from [SessionReviewNotifier].
  SessionReviewNotifierProvider(
    ({
      String sessionId,
      String? sessionName,
      String sessionType,
      String storeId
    }) params,
  ) : this._internal(
          () => SessionReviewNotifier()..params = params,
          from: sessionReviewNotifierProvider,
          name: r'sessionReviewNotifierProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$sessionReviewNotifierHash,
          dependencies: SessionReviewNotifierFamily._dependencies,
          allTransitiveDependencies:
              SessionReviewNotifierFamily._allTransitiveDependencies,
          params: params,
        );

  SessionReviewNotifierProvider._internal(
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
  SessionReviewState runNotifierBuild(
    covariant SessionReviewNotifier notifier,
  ) {
    return notifier.build(
      params,
    );
  }

  @override
  Override overrideWith(SessionReviewNotifier Function() create) {
    return ProviderOverride(
      origin: this,
      override: SessionReviewNotifierProvider._internal(
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
  AutoDisposeNotifierProviderElement<SessionReviewNotifier, SessionReviewState>
      createElement() {
    return _SessionReviewNotifierProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is SessionReviewNotifierProvider && other.params == params;
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
mixin SessionReviewNotifierRef
    on AutoDisposeNotifierProviderRef<SessionReviewState> {
  /// The parameter `params` of this provider.
  ({String sessionId, String? sessionName, String sessionType, String storeId})
      get params;
}

class _SessionReviewNotifierProviderElement
    extends AutoDisposeNotifierProviderElement<SessionReviewNotifier,
        SessionReviewState> with SessionReviewNotifierRef {
  _SessionReviewNotifierProviderElement(super.provider);

  @override
  ({String sessionId, String? sessionName, String sessionType, String storeId})
      get params => (origin as SessionReviewNotifierProvider).params;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
