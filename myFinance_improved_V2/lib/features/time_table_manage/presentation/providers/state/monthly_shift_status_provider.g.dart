// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'monthly_shift_status_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$monthlyShiftStatusNotifierHash() =>
    r'db2f617d413d373f759089c5f954e9212df0c690';

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

abstract class _$MonthlyShiftStatusNotifier
    extends BuildlessAutoDisposeNotifier<MonthlyShiftStatusState> {
  late final String storeId;

  MonthlyShiftStatusState build(
    String storeId,
  );
}

/// Monthly Shift Status Notifier
///
/// Features:
/// - Lazy loading per month
/// - Caching to prevent redundant API calls
/// - Force refresh capability
/// - Multi-month support (RPC returns current + next month)
///
/// Copied from [MonthlyShiftStatusNotifier].
@ProviderFor(MonthlyShiftStatusNotifier)
const monthlyShiftStatusNotifierProvider = MonthlyShiftStatusNotifierFamily();

/// Monthly Shift Status Notifier
///
/// Features:
/// - Lazy loading per month
/// - Caching to prevent redundant API calls
/// - Force refresh capability
/// - Multi-month support (RPC returns current + next month)
///
/// Copied from [MonthlyShiftStatusNotifier].
class MonthlyShiftStatusNotifierFamily extends Family<MonthlyShiftStatusState> {
  /// Monthly Shift Status Notifier
  ///
  /// Features:
  /// - Lazy loading per month
  /// - Caching to prevent redundant API calls
  /// - Force refresh capability
  /// - Multi-month support (RPC returns current + next month)
  ///
  /// Copied from [MonthlyShiftStatusNotifier].
  const MonthlyShiftStatusNotifierFamily();

  /// Monthly Shift Status Notifier
  ///
  /// Features:
  /// - Lazy loading per month
  /// - Caching to prevent redundant API calls
  /// - Force refresh capability
  /// - Multi-month support (RPC returns current + next month)
  ///
  /// Copied from [MonthlyShiftStatusNotifier].
  MonthlyShiftStatusNotifierProvider call(
    String storeId,
  ) {
    return MonthlyShiftStatusNotifierProvider(
      storeId,
    );
  }

  @override
  MonthlyShiftStatusNotifierProvider getProviderOverride(
    covariant MonthlyShiftStatusNotifierProvider provider,
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
  String? get name => r'monthlyShiftStatusNotifierProvider';
}

/// Monthly Shift Status Notifier
///
/// Features:
/// - Lazy loading per month
/// - Caching to prevent redundant API calls
/// - Force refresh capability
/// - Multi-month support (RPC returns current + next month)
///
/// Copied from [MonthlyShiftStatusNotifier].
class MonthlyShiftStatusNotifierProvider
    extends AutoDisposeNotifierProviderImpl<MonthlyShiftStatusNotifier,
        MonthlyShiftStatusState> {
  /// Monthly Shift Status Notifier
  ///
  /// Features:
  /// - Lazy loading per month
  /// - Caching to prevent redundant API calls
  /// - Force refresh capability
  /// - Multi-month support (RPC returns current + next month)
  ///
  /// Copied from [MonthlyShiftStatusNotifier].
  MonthlyShiftStatusNotifierProvider(
    String storeId,
  ) : this._internal(
          () => MonthlyShiftStatusNotifier()..storeId = storeId,
          from: monthlyShiftStatusNotifierProvider,
          name: r'monthlyShiftStatusNotifierProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$monthlyShiftStatusNotifierHash,
          dependencies: MonthlyShiftStatusNotifierFamily._dependencies,
          allTransitiveDependencies:
              MonthlyShiftStatusNotifierFamily._allTransitiveDependencies,
          storeId: storeId,
        );

  MonthlyShiftStatusNotifierProvider._internal(
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
  MonthlyShiftStatusState runNotifierBuild(
    covariant MonthlyShiftStatusNotifier notifier,
  ) {
    return notifier.build(
      storeId,
    );
  }

  @override
  Override overrideWith(MonthlyShiftStatusNotifier Function() create) {
    return ProviderOverride(
      origin: this,
      override: MonthlyShiftStatusNotifierProvider._internal(
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
  AutoDisposeNotifierProviderElement<MonthlyShiftStatusNotifier,
      MonthlyShiftStatusState> createElement() {
    return _MonthlyShiftStatusNotifierProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is MonthlyShiftStatusNotifierProvider &&
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
mixin MonthlyShiftStatusNotifierRef
    on AutoDisposeNotifierProviderRef<MonthlyShiftStatusState> {
  /// The parameter `storeId` of this provider.
  String get storeId;
}

class _MonthlyShiftStatusNotifierProviderElement
    extends AutoDisposeNotifierProviderElement<MonthlyShiftStatusNotifier,
        MonthlyShiftStatusState> with MonthlyShiftStatusNotifierRef {
  _MonthlyShiftStatusNotifierProviderElement(super.provider);

  @override
  String get storeId => (origin as MonthlyShiftStatusNotifierProvider).storeId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
