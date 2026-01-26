// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'manager_overview_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$managerOverviewNotifierHash() =>
    r'502218541a5746f780fb307fb9cb692e1de23588';

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

abstract class _$ManagerOverviewNotifier
    extends BuildlessAutoDisposeNotifier<ManagerOverviewState> {
  late final String storeId;

  ManagerOverviewState build(
    String storeId,
  );
}

/// Manager Overview Notifier
///
/// Features:
/// - Month-based caching
/// - Lazy loading
/// - Force refresh support
/// - Date range calculation (first day to last day of month)
///
/// Copied from [ManagerOverviewNotifier].
@ProviderFor(ManagerOverviewNotifier)
const managerOverviewNotifierProvider = ManagerOverviewNotifierFamily();

/// Manager Overview Notifier
///
/// Features:
/// - Month-based caching
/// - Lazy loading
/// - Force refresh support
/// - Date range calculation (first day to last day of month)
///
/// Copied from [ManagerOverviewNotifier].
class ManagerOverviewNotifierFamily extends Family<ManagerOverviewState> {
  /// Manager Overview Notifier
  ///
  /// Features:
  /// - Month-based caching
  /// - Lazy loading
  /// - Force refresh support
  /// - Date range calculation (first day to last day of month)
  ///
  /// Copied from [ManagerOverviewNotifier].
  const ManagerOverviewNotifierFamily();

  /// Manager Overview Notifier
  ///
  /// Features:
  /// - Month-based caching
  /// - Lazy loading
  /// - Force refresh support
  /// - Date range calculation (first day to last day of month)
  ///
  /// Copied from [ManagerOverviewNotifier].
  ManagerOverviewNotifierProvider call(
    String storeId,
  ) {
    return ManagerOverviewNotifierProvider(
      storeId,
    );
  }

  @override
  ManagerOverviewNotifierProvider getProviderOverride(
    covariant ManagerOverviewNotifierProvider provider,
  ) {
    return call(
      provider.storeId,
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
  String? get name => r'managerOverviewNotifierProvider';
}

/// Manager Overview Notifier
///
/// Features:
/// - Month-based caching
/// - Lazy loading
/// - Force refresh support
/// - Date range calculation (first day to last day of month)
///
/// Copied from [ManagerOverviewNotifier].
class ManagerOverviewNotifierProvider extends AutoDisposeNotifierProviderImpl<
    ManagerOverviewNotifier, ManagerOverviewState> {
  /// Manager Overview Notifier
  ///
  /// Features:
  /// - Month-based caching
  /// - Lazy loading
  /// - Force refresh support
  /// - Date range calculation (first day to last day of month)
  ///
  /// Copied from [ManagerOverviewNotifier].
  ManagerOverviewNotifierProvider(
    String storeId,
  ) : this._internal(
          () => ManagerOverviewNotifier()..storeId = storeId,
          from: managerOverviewNotifierProvider,
          name: r'managerOverviewNotifierProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$managerOverviewNotifierHash,
          dependencies: ManagerOverviewNotifierFamily._dependencies,
          allTransitiveDependencies:
              ManagerOverviewNotifierFamily._allTransitiveDependencies,
          storeId: storeId,
        );

  ManagerOverviewNotifierProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.storeId,
  }) : super.internal();

  final String storeId;

  @override
  ManagerOverviewState runNotifierBuild(
    covariant ManagerOverviewNotifier notifier,
  ) {
    return notifier.build(
      storeId,
    );
  }

  @override
  Override overrideWith(ManagerOverviewNotifier Function() create) {
    return ProviderOverride(
      origin: this,
      override: ManagerOverviewNotifierProvider._internal(
        () => create()..storeId = storeId,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        storeId: storeId,
      ),
    );
  }

  @override
  AutoDisposeNotifierProviderElement<ManagerOverviewNotifier,
      ManagerOverviewState> createElement() {
    return _ManagerOverviewNotifierProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ManagerOverviewNotifierProvider && other.storeId == storeId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, storeId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin ManagerOverviewNotifierRef
    on AutoDisposeNotifierProviderRef<ManagerOverviewState> {
  /// The parameter `storeId` of this provider.
  String get storeId;
}

class _ManagerOverviewNotifierProviderElement
    extends AutoDisposeNotifierProviderElement<ManagerOverviewNotifier,
        ManagerOverviewState> with ManagerOverviewNotifierRef {
  _ManagerOverviewNotifierProviderElement(super.provider);

  @override
  String get storeId => (origin as ManagerOverviewNotifierProvider).storeId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
