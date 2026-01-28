// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'denomination_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$denominationListHash() => r'1560f0ae2b26b44e3029da5380bbad990300001f';

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

/// Denominations for a specific currency
///
/// Copied from [denominationList].
@ProviderFor(denominationList)
const denominationListProvider = DenominationListFamily();

/// Denominations for a specific currency
///
/// Copied from [denominationList].
class DenominationListFamily extends Family<AsyncValue<List<Denomination>>> {
  /// Denominations for a specific currency
  ///
  /// Copied from [denominationList].
  const DenominationListFamily();

  /// Denominations for a specific currency
  ///
  /// Copied from [denominationList].
  DenominationListProvider call(
    String currencyId,
  ) {
    return DenominationListProvider(
      currencyId,
    );
  }

  @override
  DenominationListProvider getProviderOverride(
    covariant DenominationListProvider provider,
  ) {
    return call(
      provider.currencyId,
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
  String? get name => r'denominationListProvider';
}

/// Denominations for a specific currency
///
/// Copied from [denominationList].
class DenominationListProvider
    extends AutoDisposeFutureProvider<List<Denomination>> {
  /// Denominations for a specific currency
  ///
  /// Copied from [denominationList].
  DenominationListProvider(
    String currencyId,
  ) : this._internal(
          (ref) => denominationList(
            ref as DenominationListRef,
            currencyId,
          ),
          from: denominationListProvider,
          name: r'denominationListProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$denominationListHash,
          dependencies: DenominationListFamily._dependencies,
          allTransitiveDependencies:
              DenominationListFamily._allTransitiveDependencies,
          currencyId: currencyId,
        );

  DenominationListProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.currencyId,
  }) : super.internal();

  final String currencyId;

  @override
  Override overrideWith(
    FutureOr<List<Denomination>> Function(DenominationListRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: DenominationListProvider._internal(
        (ref) => create(ref as DenominationListRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        currencyId: currencyId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<Denomination>> createElement() {
    return _DenominationListProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is DenominationListProvider && other.currencyId == currencyId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, currencyId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin DenominationListRef on AutoDisposeFutureProviderRef<List<Denomination>> {
  /// The parameter `currencyId` of this provider.
  String get currencyId;
}

class _DenominationListProviderElement
    extends AutoDisposeFutureProviderElement<List<Denomination>>
    with DenominationListRef {
  _DenominationListProviderElement(super.provider);

  @override
  String get currencyId => (origin as DenominationListProvider).currencyId;
}

String _$availableTemplatesHash() =>
    r'4750548611fee5697abae3fbb8f99f421571fec9';

/// Available templates provider
///
/// Copied from [availableTemplates].
@ProviderFor(availableTemplates)
final availableTemplatesProvider = AutoDisposeProvider<List<String>>.internal(
  availableTemplates,
  name: r'availableTemplatesProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$availableTemplatesHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef AvailableTemplatesRef = AutoDisposeProviderRef<List<String>>;
String _$denominationTemplateHash() =>
    r'd4281e2bc5dfc36395da216830c88d24e733e877';

/// Denomination template provider
///
/// Copied from [denominationTemplate].
@ProviderFor(denominationTemplate)
const denominationTemplateProvider = DenominationTemplateFamily();

/// Denomination template provider
///
/// Copied from [denominationTemplate].
class DenominationTemplateFamily
    extends Family<List<DenominationTemplateItem>> {
  /// Denomination template provider
  ///
  /// Copied from [denominationTemplate].
  const DenominationTemplateFamily();

  /// Denomination template provider
  ///
  /// Copied from [denominationTemplate].
  DenominationTemplateProvider call(
    String currencyCode,
  ) {
    return DenominationTemplateProvider(
      currencyCode,
    );
  }

  @override
  DenominationTemplateProvider getProviderOverride(
    covariant DenominationTemplateProvider provider,
  ) {
    return call(
      provider.currencyCode,
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
  String? get name => r'denominationTemplateProvider';
}

/// Denomination template provider
///
/// Copied from [denominationTemplate].
class DenominationTemplateProvider
    extends AutoDisposeProvider<List<DenominationTemplateItem>> {
  /// Denomination template provider
  ///
  /// Copied from [denominationTemplate].
  DenominationTemplateProvider(
    String currencyCode,
  ) : this._internal(
          (ref) => denominationTemplate(
            ref as DenominationTemplateRef,
            currencyCode,
          ),
          from: denominationTemplateProvider,
          name: r'denominationTemplateProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$denominationTemplateHash,
          dependencies: DenominationTemplateFamily._dependencies,
          allTransitiveDependencies:
              DenominationTemplateFamily._allTransitiveDependencies,
          currencyCode: currencyCode,
        );

  DenominationTemplateProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.currencyCode,
  }) : super.internal();

  final String currencyCode;

  @override
  Override overrideWith(
    List<DenominationTemplateItem> Function(DenominationTemplateRef provider)
        create,
  ) {
    return ProviderOverride(
      origin: this,
      override: DenominationTemplateProvider._internal(
        (ref) => create(ref as DenominationTemplateRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        currencyCode: currencyCode,
      ),
    );
  }

  @override
  AutoDisposeProviderElement<List<DenominationTemplateItem>> createElement() {
    return _DenominationTemplateProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is DenominationTemplateProvider &&
        other.currencyCode == currencyCode;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, currencyCode.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin DenominationTemplateRef
    on AutoDisposeProviderRef<List<DenominationTemplateItem>> {
  /// The parameter `currencyCode` of this provider.
  String get currencyCode;
}

class _DenominationTemplateProviderElement
    extends AutoDisposeProviderElement<List<DenominationTemplateItem>>
    with DenominationTemplateRef {
  _DenominationTemplateProviderElement(super.provider);

  @override
  String get currencyCode =>
      (origin as DenominationTemplateProvider).currencyCode;
}

String _$hasTemplateHash() => r'5d04f5f66ef71d71ee7c25eb1e9a33520c70e554';

/// Has template provider
///
/// Copied from [hasTemplate].
@ProviderFor(hasTemplate)
const hasTemplateProvider = HasTemplateFamily();

/// Has template provider
///
/// Copied from [hasTemplate].
class HasTemplateFamily extends Family<bool> {
  /// Has template provider
  ///
  /// Copied from [hasTemplate].
  const HasTemplateFamily();

  /// Has template provider
  ///
  /// Copied from [hasTemplate].
  HasTemplateProvider call(
    String currencyCode,
  ) {
    return HasTemplateProvider(
      currencyCode,
    );
  }

  @override
  HasTemplateProvider getProviderOverride(
    covariant HasTemplateProvider provider,
  ) {
    return call(
      provider.currencyCode,
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
  String? get name => r'hasTemplateProvider';
}

/// Has template provider
///
/// Copied from [hasTemplate].
class HasTemplateProvider extends AutoDisposeProvider<bool> {
  /// Has template provider
  ///
  /// Copied from [hasTemplate].
  HasTemplateProvider(
    String currencyCode,
  ) : this._internal(
          (ref) => hasTemplate(
            ref as HasTemplateRef,
            currencyCode,
          ),
          from: hasTemplateProvider,
          name: r'hasTemplateProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$hasTemplateHash,
          dependencies: HasTemplateFamily._dependencies,
          allTransitiveDependencies:
              HasTemplateFamily._allTransitiveDependencies,
          currencyCode: currencyCode,
        );

  HasTemplateProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.currencyCode,
  }) : super.internal();

  final String currencyCode;

  @override
  Override overrideWith(
    bool Function(HasTemplateRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: HasTemplateProvider._internal(
        (ref) => create(ref as HasTemplateRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        currencyCode: currencyCode,
      ),
    );
  }

  @override
  AutoDisposeProviderElement<bool> createElement() {
    return _HasTemplateProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is HasTemplateProvider && other.currencyCode == currencyCode;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, currencyCode.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin HasTemplateRef on AutoDisposeProviderRef<bool> {
  /// The parameter `currencyCode` of this provider.
  String get currencyCode;
}

class _HasTemplateProviderElement extends AutoDisposeProviderElement<bool>
    with HasTemplateRef {
  _HasTemplateProviderElement(super.provider);

  @override
  String get currencyCode => (origin as HasTemplateProvider).currencyCode;
}

String _$effectiveDenominationListHash() =>
    r'1a47f7f730f35df33cd124f5ddf8fb5cf0a66243';

/// Combined provider that uses local state when available, falls back to remote
///
/// Copied from [effectiveDenominationList].
@ProviderFor(effectiveDenominationList)
const effectiveDenominationListProvider = EffectiveDenominationListFamily();

/// Combined provider that uses local state when available, falls back to remote
///
/// Copied from [effectiveDenominationList].
class EffectiveDenominationListFamily
    extends Family<AsyncValue<List<Denomination>>> {
  /// Combined provider that uses local state when available, falls back to remote
  ///
  /// Copied from [effectiveDenominationList].
  const EffectiveDenominationListFamily();

  /// Combined provider that uses local state when available, falls back to remote
  ///
  /// Copied from [effectiveDenominationList].
  EffectiveDenominationListProvider call(
    String currencyId,
  ) {
    return EffectiveDenominationListProvider(
      currencyId,
    );
  }

  @override
  EffectiveDenominationListProvider getProviderOverride(
    covariant EffectiveDenominationListProvider provider,
  ) {
    return call(
      provider.currencyId,
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
  String? get name => r'effectiveDenominationListProvider';
}

/// Combined provider that uses local state when available, falls back to remote
///
/// Copied from [effectiveDenominationList].
class EffectiveDenominationListProvider
    extends AutoDisposeProvider<AsyncValue<List<Denomination>>> {
  /// Combined provider that uses local state when available, falls back to remote
  ///
  /// Copied from [effectiveDenominationList].
  EffectiveDenominationListProvider(
    String currencyId,
  ) : this._internal(
          (ref) => effectiveDenominationList(
            ref as EffectiveDenominationListRef,
            currencyId,
          ),
          from: effectiveDenominationListProvider,
          name: r'effectiveDenominationListProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$effectiveDenominationListHash,
          dependencies: EffectiveDenominationListFamily._dependencies,
          allTransitiveDependencies:
              EffectiveDenominationListFamily._allTransitiveDependencies,
          currencyId: currencyId,
        );

  EffectiveDenominationListProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.currencyId,
  }) : super.internal();

  final String currencyId;

  @override
  Override overrideWith(
    AsyncValue<List<Denomination>> Function(
            EffectiveDenominationListRef provider)
        create,
  ) {
    return ProviderOverride(
      origin: this,
      override: EffectiveDenominationListProvider._internal(
        (ref) => create(ref as EffectiveDenominationListRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        currencyId: currencyId,
      ),
    );
  }

  @override
  AutoDisposeProviderElement<AsyncValue<List<Denomination>>> createElement() {
    return _EffectiveDenominationListProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is EffectiveDenominationListProvider &&
        other.currencyId == currencyId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, currencyId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin EffectiveDenominationListRef
    on AutoDisposeProviderRef<AsyncValue<List<Denomination>>> {
  /// The parameter `currencyId` of this provider.
  String get currencyId;
}

class _EffectiveDenominationListProviderElement
    extends AutoDisposeProviderElement<AsyncValue<List<Denomination>>>
    with EffectiveDenominationListRef {
  _EffectiveDenominationListProviderElement(super.provider);

  @override
  String get currencyId =>
      (origin as EffectiveDenominationListProvider).currencyId;
}

String _$denominationOperationsHash() =>
    r'e4dd1a663b7221e93a5f3024e8364532988a3355';

/// Denomination operations notifier
///
/// Copied from [DenominationOperations].
@ProviderFor(DenominationOperations)
final denominationOperationsProvider = AutoDisposeNotifierProvider<
    DenominationOperations, AsyncValue<void>>.internal(
  DenominationOperations.new,
  name: r'denominationOperationsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$denominationOperationsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$DenominationOperations = AutoDisposeNotifier<AsyncValue<void>>;
String _$localDenominationListHash() =>
    r'2ebcb457bfa1cd128b9fb9d8a5243e24d941e1f8';

/// Local denomination list notifier for optimistic UI updates
///
/// Copied from [LocalDenominationList].
@ProviderFor(LocalDenominationList)
final localDenominationListProvider = AutoDisposeNotifierProvider<
    LocalDenominationList, Map<String, List<Denomination>>>.internal(
  LocalDenominationList.new,
  name: r'localDenominationListProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$localDenominationListHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$LocalDenominationList
    = AutoDisposeNotifier<Map<String, List<Denomination>>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
