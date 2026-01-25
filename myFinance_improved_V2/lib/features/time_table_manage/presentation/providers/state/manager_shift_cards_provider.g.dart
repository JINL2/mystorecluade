// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'manager_shift_cards_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$managerShiftCardsNotifierHash() =>
    r'215e678a76b3a7d1366d08f6e9cf81774148a70a';

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

abstract class _$ManagerShiftCardsNotifier
    extends BuildlessAutoDisposeNotifier<ManagerShiftCardsState> {
  late final String storeId;

  ManagerShiftCardsState build(
    String storeId,
  );
}

/// Manager Shift Cards Notifier
///
/// Features:
/// - Month-based caching
/// - Debug logging for data loading
/// - Selective month clearing
/// - Lazy loading with skip logic
///
/// Copied from [ManagerShiftCardsNotifier].
@ProviderFor(ManagerShiftCardsNotifier)
const managerShiftCardsNotifierProvider = ManagerShiftCardsNotifierFamily();

/// Manager Shift Cards Notifier
///
/// Features:
/// - Month-based caching
/// - Debug logging for data loading
/// - Selective month clearing
/// - Lazy loading with skip logic
///
/// Copied from [ManagerShiftCardsNotifier].
class ManagerShiftCardsNotifierFamily extends Family<ManagerShiftCardsState> {
  /// Manager Shift Cards Notifier
  ///
  /// Features:
  /// - Month-based caching
  /// - Debug logging for data loading
  /// - Selective month clearing
  /// - Lazy loading with skip logic
  ///
  /// Copied from [ManagerShiftCardsNotifier].
  const ManagerShiftCardsNotifierFamily();

  /// Manager Shift Cards Notifier
  ///
  /// Features:
  /// - Month-based caching
  /// - Debug logging for data loading
  /// - Selective month clearing
  /// - Lazy loading with skip logic
  ///
  /// Copied from [ManagerShiftCardsNotifier].
  ManagerShiftCardsNotifierProvider call(
    String storeId,
  ) {
    return ManagerShiftCardsNotifierProvider(
      storeId,
    );
  }

  @override
  ManagerShiftCardsNotifierProvider getProviderOverride(
    covariant ManagerShiftCardsNotifierProvider provider,
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
  String? get name => r'managerShiftCardsNotifierProvider';
}

/// Manager Shift Cards Notifier
///
/// Features:
/// - Month-based caching
/// - Debug logging for data loading
/// - Selective month clearing
/// - Lazy loading with skip logic
///
/// Copied from [ManagerShiftCardsNotifier].
class ManagerShiftCardsNotifierProvider extends AutoDisposeNotifierProviderImpl<
    ManagerShiftCardsNotifier, ManagerShiftCardsState> {
  /// Manager Shift Cards Notifier
  ///
  /// Features:
  /// - Month-based caching
  /// - Debug logging for data loading
  /// - Selective month clearing
  /// - Lazy loading with skip logic
  ///
  /// Copied from [ManagerShiftCardsNotifier].
  ManagerShiftCardsNotifierProvider(
    String storeId,
  ) : this._internal(
          () => ManagerShiftCardsNotifier()..storeId = storeId,
          from: managerShiftCardsNotifierProvider,
          name: r'managerShiftCardsNotifierProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$managerShiftCardsNotifierHash,
          dependencies: ManagerShiftCardsNotifierFamily._dependencies,
          allTransitiveDependencies:
              ManagerShiftCardsNotifierFamily._allTransitiveDependencies,
          storeId: storeId,
        );

  ManagerShiftCardsNotifierProvider._internal(
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
  ManagerShiftCardsState runNotifierBuild(
    covariant ManagerShiftCardsNotifier notifier,
  ) {
    return notifier.build(
      storeId,
    );
  }

  @override
  Override overrideWith(ManagerShiftCardsNotifier Function() create) {
    return ProviderOverride(
      origin: this,
      override: ManagerShiftCardsNotifierProvider._internal(
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
  AutoDisposeNotifierProviderElement<ManagerShiftCardsNotifier,
      ManagerShiftCardsState> createElement() {
    return _ManagerShiftCardsNotifierProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ManagerShiftCardsNotifierProvider &&
        other.storeId == storeId;
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
mixin ManagerShiftCardsNotifierRef
    on AutoDisposeNotifierProviderRef<ManagerShiftCardsState> {
  /// The parameter `storeId` of this provider.
  String get storeId;
}

class _ManagerShiftCardsNotifierProviderElement
    extends AutoDisposeNotifierProviderElement<ManagerShiftCardsNotifier,
        ManagerShiftCardsState> with ManagerShiftCardsNotifierRef {
  _ManagerShiftCardsNotifierProviderElement(super.provider);

  @override
  String get storeId => (origin as ManagerShiftCardsNotifierProvider).storeId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
