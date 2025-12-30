// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'journal_input_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$totalDebitsHash() => r'0ae2189108bdb3656a3908253040ab621d530b63';

/// Total debits provider
///
/// Copied from [totalDebits].
@ProviderFor(totalDebits)
final totalDebitsProvider = AutoDisposeProvider<double>.internal(
  totalDebits,
  name: r'totalDebitsProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$totalDebitsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef TotalDebitsRef = AutoDisposeProviderRef<double>;
String _$totalCreditsHash() => r'c036cd5ace9c0fab63521be8a05d57b7ba65aa6f';

/// Total credits provider
///
/// Copied from [totalCredits].
@ProviderFor(totalCredits)
final totalCreditsProvider = AutoDisposeProvider<double>.internal(
  totalCredits,
  name: r'totalCreditsProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$totalCreditsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef TotalCreditsRef = AutoDisposeProviderRef<double>;
String _$differenceHash() => r'4b98c50d4e255d28699fc58bd46864709eb4c343';

/// Difference provider
///
/// Copied from [difference].
@ProviderFor(difference)
final differenceProvider = AutoDisposeProvider<double>.internal(
  difference,
  name: r'differenceProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$differenceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef DifferenceRef = AutoDisposeProviderRef<double>;
String _$isBalancedHash() => r'a2fa5a62e7b5a22aa112f852d69e65e07587956d';

/// Is balanced provider
///
/// Copied from [isBalanced].
@ProviderFor(isBalanced)
final isBalancedProvider = AutoDisposeProvider<bool>.internal(
  isBalanced,
  name: r'isBalancedProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$isBalancedHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef IsBalancedRef = AutoDisposeProviderRef<bool>;
String _$canSubmitHash() => r'c1322b3a109bad091d6b62e4d7deac304cc29313';

/// Can submit provider
///
/// Copied from [canSubmit].
@ProviderFor(canSubmit)
final canSubmitProvider = AutoDisposeProvider<bool>.internal(
  canSubmit,
  name: r'canSubmitProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$canSubmitHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef CanSubmitRef = AutoDisposeProviderRef<bool>;
String _$journalAccountsHash() => r'655854949746cbfa608d7fa9b61b288eab0d838e';

/// Fetch accounts
///
/// Copied from [journalAccounts].
@ProviderFor(journalAccounts)
final journalAccountsProvider =
    AutoDisposeFutureProvider<List<Map<String, dynamic>>>.internal(
  journalAccounts,
  name: r'journalAccountsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$journalAccountsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef JournalAccountsRef
    = AutoDisposeFutureProviderRef<List<Map<String, dynamic>>>;
String _$journalCounterpartiesHash() =>
    r'09c2d267bcda24e9f498695c0e95679be3d59bcf';

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

/// Fetch counterparties (family provider for company-specific data)
///
/// Copied from [journalCounterparties].
@ProviderFor(journalCounterparties)
const journalCounterpartiesProvider = JournalCounterpartiesFamily();

/// Fetch counterparties (family provider for company-specific data)
///
/// Copied from [journalCounterparties].
class JournalCounterpartiesFamily
    extends Family<AsyncValue<List<Map<String, dynamic>>>> {
  /// Fetch counterparties (family provider for company-specific data)
  ///
  /// Copied from [journalCounterparties].
  const JournalCounterpartiesFamily();

  /// Fetch counterparties (family provider for company-specific data)
  ///
  /// Copied from [journalCounterparties].
  JournalCounterpartiesProvider call(
    String companyId,
  ) {
    return JournalCounterpartiesProvider(
      companyId,
    );
  }

  @override
  JournalCounterpartiesProvider getProviderOverride(
    covariant JournalCounterpartiesProvider provider,
  ) {
    return call(
      provider.companyId,
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
  String? get name => r'journalCounterpartiesProvider';
}

/// Fetch counterparties (family provider for company-specific data)
///
/// Copied from [journalCounterparties].
class JournalCounterpartiesProvider
    extends AutoDisposeFutureProvider<List<Map<String, dynamic>>> {
  /// Fetch counterparties (family provider for company-specific data)
  ///
  /// Copied from [journalCounterparties].
  JournalCounterpartiesProvider(
    String companyId,
  ) : this._internal(
          (ref) => journalCounterparties(
            ref as JournalCounterpartiesRef,
            companyId,
          ),
          from: journalCounterpartiesProvider,
          name: r'journalCounterpartiesProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$journalCounterpartiesHash,
          dependencies: JournalCounterpartiesFamily._dependencies,
          allTransitiveDependencies:
              JournalCounterpartiesFamily._allTransitiveDependencies,
          companyId: companyId,
        );

  JournalCounterpartiesProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.companyId,
  }) : super.internal();

  final String companyId;

  @override
  Override overrideWith(
    FutureOr<List<Map<String, dynamic>>> Function(
            JournalCounterpartiesRef provider)
        create,
  ) {
    return ProviderOverride(
      origin: this,
      override: JournalCounterpartiesProvider._internal(
        (ref) => create(ref as JournalCounterpartiesRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        companyId: companyId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<Map<String, dynamic>>> createElement() {
    return _JournalCounterpartiesProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is JournalCounterpartiesProvider &&
        other.companyId == companyId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, companyId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin JournalCounterpartiesRef
    on AutoDisposeFutureProviderRef<List<Map<String, dynamic>>> {
  /// The parameter `companyId` of this provider.
  String get companyId;
}

class _JournalCounterpartiesProviderElement
    extends AutoDisposeFutureProviderElement<List<Map<String, dynamic>>>
    with JournalCounterpartiesRef {
  _JournalCounterpartiesProviderElement(super.provider);

  @override
  String get companyId => (origin as JournalCounterpartiesProvider).companyId;
}

String _$journalCounterpartyStoresHash() =>
    r'f0a7db00cd06b7acc69b11ffc87f56eda1e2b188';

/// Fetch counterparty stores
///
/// Copied from [journalCounterpartyStores].
@ProviderFor(journalCounterpartyStores)
const journalCounterpartyStoresProvider = JournalCounterpartyStoresFamily();

/// Fetch counterparty stores
///
/// Copied from [journalCounterpartyStores].
class JournalCounterpartyStoresFamily
    extends Family<AsyncValue<List<Map<String, dynamic>>>> {
  /// Fetch counterparty stores
  ///
  /// Copied from [journalCounterpartyStores].
  const JournalCounterpartyStoresFamily();

  /// Fetch counterparty stores
  ///
  /// Copied from [journalCounterpartyStores].
  JournalCounterpartyStoresProvider call(
    String? linkedCompanyId,
  ) {
    return JournalCounterpartyStoresProvider(
      linkedCompanyId,
    );
  }

  @override
  JournalCounterpartyStoresProvider getProviderOverride(
    covariant JournalCounterpartyStoresProvider provider,
  ) {
    return call(
      provider.linkedCompanyId,
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
  String? get name => r'journalCounterpartyStoresProvider';
}

/// Fetch counterparty stores
///
/// Copied from [journalCounterpartyStores].
class JournalCounterpartyStoresProvider
    extends AutoDisposeFutureProvider<List<Map<String, dynamic>>> {
  /// Fetch counterparty stores
  ///
  /// Copied from [journalCounterpartyStores].
  JournalCounterpartyStoresProvider(
    String? linkedCompanyId,
  ) : this._internal(
          (ref) => journalCounterpartyStores(
            ref as JournalCounterpartyStoresRef,
            linkedCompanyId,
          ),
          from: journalCounterpartyStoresProvider,
          name: r'journalCounterpartyStoresProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$journalCounterpartyStoresHash,
          dependencies: JournalCounterpartyStoresFamily._dependencies,
          allTransitiveDependencies:
              JournalCounterpartyStoresFamily._allTransitiveDependencies,
          linkedCompanyId: linkedCompanyId,
        );

  JournalCounterpartyStoresProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.linkedCompanyId,
  }) : super.internal();

  final String? linkedCompanyId;

  @override
  Override overrideWith(
    FutureOr<List<Map<String, dynamic>>> Function(
            JournalCounterpartyStoresRef provider)
        create,
  ) {
    return ProviderOverride(
      origin: this,
      override: JournalCounterpartyStoresProvider._internal(
        (ref) => create(ref as JournalCounterpartyStoresRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        linkedCompanyId: linkedCompanyId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<Map<String, dynamic>>> createElement() {
    return _JournalCounterpartyStoresProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is JournalCounterpartyStoresProvider &&
        other.linkedCompanyId == linkedCompanyId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, linkedCompanyId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin JournalCounterpartyStoresRef
    on AutoDisposeFutureProviderRef<List<Map<String, dynamic>>> {
  /// The parameter `linkedCompanyId` of this provider.
  String? get linkedCompanyId;
}

class _JournalCounterpartyStoresProviderElement
    extends AutoDisposeFutureProviderElement<List<Map<String, dynamic>>>
    with JournalCounterpartyStoresRef {
  _JournalCounterpartyStoresProviderElement(super.provider);

  @override
  String? get linkedCompanyId =>
      (origin as JournalCounterpartyStoresProvider).linkedCompanyId;
}

String _$journalCashLocationsHash() =>
    r'f6a262e4400ad009b9d7556e3472b0ff2181072c';

/// Fetch cash locations
///
/// Copied from [journalCashLocations].
@ProviderFor(journalCashLocations)
const journalCashLocationsProvider = JournalCashLocationsFamily();

/// Fetch cash locations
///
/// Copied from [journalCashLocations].
class JournalCashLocationsFamily
    extends Family<AsyncValue<List<Map<String, dynamic>>>> {
  /// Fetch cash locations
  ///
  /// Copied from [journalCashLocations].
  const JournalCashLocationsFamily();

  /// Fetch cash locations
  ///
  /// Copied from [journalCashLocations].
  JournalCashLocationsProvider call(
    CashLocationsParams params,
  ) {
    return JournalCashLocationsProvider(
      params,
    );
  }

  @override
  JournalCashLocationsProvider getProviderOverride(
    covariant JournalCashLocationsProvider provider,
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
  String? get name => r'journalCashLocationsProvider';
}

/// Fetch cash locations
///
/// Copied from [journalCashLocations].
class JournalCashLocationsProvider
    extends AutoDisposeFutureProvider<List<Map<String, dynamic>>> {
  /// Fetch cash locations
  ///
  /// Copied from [journalCashLocations].
  JournalCashLocationsProvider(
    CashLocationsParams params,
  ) : this._internal(
          (ref) => journalCashLocations(
            ref as JournalCashLocationsRef,
            params,
          ),
          from: journalCashLocationsProvider,
          name: r'journalCashLocationsProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$journalCashLocationsHash,
          dependencies: JournalCashLocationsFamily._dependencies,
          allTransitiveDependencies:
              JournalCashLocationsFamily._allTransitiveDependencies,
          params: params,
        );

  JournalCashLocationsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.params,
  }) : super.internal();

  final CashLocationsParams params;

  @override
  Override overrideWith(
    FutureOr<List<Map<String, dynamic>>> Function(
            JournalCashLocationsRef provider)
        create,
  ) {
    return ProviderOverride(
      origin: this,
      override: JournalCashLocationsProvider._internal(
        (ref) => create(ref as JournalCashLocationsRef),
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
  AutoDisposeFutureProviderElement<List<Map<String, dynamic>>> createElement() {
    return _JournalCashLocationsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is JournalCashLocationsProvider && other.params == params;
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
mixin JournalCashLocationsRef
    on AutoDisposeFutureProviderRef<List<Map<String, dynamic>>> {
  /// The parameter `params` of this provider.
  CashLocationsParams get params;
}

class _JournalCashLocationsProviderElement
    extends AutoDisposeFutureProviderElement<List<Map<String, dynamic>>>
    with JournalCashLocationsRef {
  _JournalCashLocationsProviderElement(super.provider);

  @override
  CashLocationsParams get params =>
      (origin as JournalCashLocationsProvider).params;
}

String _$exchangeRatesHash() => r'a5349eb349e9d6bfc7f7021df0c94199c7e4cdc9';

/// Fetch exchange rates
/// Uses get_exchange_rate_v3 which supports store-based currency sorting
///
/// Copied from [exchangeRates].
@ProviderFor(exchangeRates)
const exchangeRatesProvider = ExchangeRatesFamily();

/// Fetch exchange rates
/// Uses get_exchange_rate_v3 which supports store-based currency sorting
///
/// Copied from [exchangeRates].
class ExchangeRatesFamily extends Family<AsyncValue<Map<String, dynamic>>> {
  /// Fetch exchange rates
  /// Uses get_exchange_rate_v3 which supports store-based currency sorting
  ///
  /// Copied from [exchangeRates].
  const ExchangeRatesFamily();

  /// Fetch exchange rates
  /// Uses get_exchange_rate_v3 which supports store-based currency sorting
  ///
  /// Copied from [exchangeRates].
  ExchangeRatesProvider call(
    ExchangeRatesParams params,
  ) {
    return ExchangeRatesProvider(
      params,
    );
  }

  @override
  ExchangeRatesProvider getProviderOverride(
    covariant ExchangeRatesProvider provider,
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
  String? get name => r'exchangeRatesProvider';
}

/// Fetch exchange rates
/// Uses get_exchange_rate_v3 which supports store-based currency sorting
///
/// Copied from [exchangeRates].
class ExchangeRatesProvider
    extends AutoDisposeFutureProvider<Map<String, dynamic>> {
  /// Fetch exchange rates
  /// Uses get_exchange_rate_v3 which supports store-based currency sorting
  ///
  /// Copied from [exchangeRates].
  ExchangeRatesProvider(
    ExchangeRatesParams params,
  ) : this._internal(
          (ref) => exchangeRates(
            ref as ExchangeRatesRef,
            params,
          ),
          from: exchangeRatesProvider,
          name: r'exchangeRatesProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$exchangeRatesHash,
          dependencies: ExchangeRatesFamily._dependencies,
          allTransitiveDependencies:
              ExchangeRatesFamily._allTransitiveDependencies,
          params: params,
        );

  ExchangeRatesProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.params,
  }) : super.internal();

  final ExchangeRatesParams params;

  @override
  Override overrideWith(
    FutureOr<Map<String, dynamic>> Function(ExchangeRatesRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: ExchangeRatesProvider._internal(
        (ref) => create(ref as ExchangeRatesRef),
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
  AutoDisposeFutureProviderElement<Map<String, dynamic>> createElement() {
    return _ExchangeRatesProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ExchangeRatesProvider && other.params == params;
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
mixin ExchangeRatesRef on AutoDisposeFutureProviderRef<Map<String, dynamic>> {
  /// The parameter `params` of this provider.
  ExchangeRatesParams get params;
}

class _ExchangeRatesProviderElement
    extends AutoDisposeFutureProviderElement<Map<String, dynamic>>
    with ExchangeRatesRef {
  _ExchangeRatesProviderElement(super.provider);

  @override
  ExchangeRatesParams get params => (origin as ExchangeRatesProvider).params;
}

String _$journalAttachmentsHash() =>
    r'fd709e9cc04de343df0ebbf71b5365a5f11344ce';

/// Get journal attachments
///
/// Copied from [journalAttachments].
@ProviderFor(journalAttachments)
const journalAttachmentsProvider = JournalAttachmentsFamily();

/// Get journal attachments
///
/// Copied from [journalAttachments].
class JournalAttachmentsFamily
    extends Family<AsyncValue<List<JournalAttachment>>> {
  /// Get journal attachments
  ///
  /// Copied from [journalAttachments].
  const JournalAttachmentsFamily();

  /// Get journal attachments
  ///
  /// Copied from [journalAttachments].
  JournalAttachmentsProvider call(
    String journalId,
  ) {
    return JournalAttachmentsProvider(
      journalId,
    );
  }

  @override
  JournalAttachmentsProvider getProviderOverride(
    covariant JournalAttachmentsProvider provider,
  ) {
    return call(
      provider.journalId,
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
  String? get name => r'journalAttachmentsProvider';
}

/// Get journal attachments
///
/// Copied from [journalAttachments].
class JournalAttachmentsProvider
    extends AutoDisposeFutureProvider<List<JournalAttachment>> {
  /// Get journal attachments
  ///
  /// Copied from [journalAttachments].
  JournalAttachmentsProvider(
    String journalId,
  ) : this._internal(
          (ref) => journalAttachments(
            ref as JournalAttachmentsRef,
            journalId,
          ),
          from: journalAttachmentsProvider,
          name: r'journalAttachmentsProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$journalAttachmentsHash,
          dependencies: JournalAttachmentsFamily._dependencies,
          allTransitiveDependencies:
              JournalAttachmentsFamily._allTransitiveDependencies,
          journalId: journalId,
        );

  JournalAttachmentsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.journalId,
  }) : super.internal();

  final String journalId;

  @override
  Override overrideWith(
    FutureOr<List<JournalAttachment>> Function(JournalAttachmentsRef provider)
        create,
  ) {
    return ProviderOverride(
      origin: this,
      override: JournalAttachmentsProvider._internal(
        (ref) => create(ref as JournalAttachmentsRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        journalId: journalId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<JournalAttachment>> createElement() {
    return _JournalAttachmentsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is JournalAttachmentsProvider && other.journalId == journalId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, journalId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin JournalAttachmentsRef
    on AutoDisposeFutureProviderRef<List<JournalAttachment>> {
  /// The parameter `journalId` of this provider.
  String get journalId;
}

class _JournalAttachmentsProviderElement
    extends AutoDisposeFutureProviderElement<List<JournalAttachment>>
    with JournalAttachmentsRef {
  _JournalAttachmentsProviderElement(super.provider);

  @override
  String get journalId => (origin as JournalAttachmentsProvider).journalId;
}

String _$journalEntryNotifierHash() =>
    r'a2b0c1ecdf048162feaa27fa63c33f5fdcfd592d';

/// Journal Entry State Notifier - manages journal entry creation state
///
/// Copied from [JournalEntryNotifier].
@ProviderFor(JournalEntryNotifier)
final journalEntryNotifierProvider = AutoDisposeNotifierProvider<
    JournalEntryNotifier, JournalEntryState>.internal(
  JournalEntryNotifier.new,
  name: r'journalEntryNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$journalEntryNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$JournalEntryNotifier = AutoDisposeNotifier<JournalEntryState>;
String _$transactionLineCreationNotifierHash() =>
    r'e9f0c02e07bbbeb8718d05521eaea2f39890a72e';

/// Transaction Line Creation State Notifier
///
/// Copied from [TransactionLineCreationNotifier].
@ProviderFor(TransactionLineCreationNotifier)
final transactionLineCreationNotifierProvider = AutoDisposeNotifierProvider<
    TransactionLineCreationNotifier, TransactionLineCreationState>.internal(
  TransactionLineCreationNotifier.new,
  name: r'transactionLineCreationNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$transactionLineCreationNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$TransactionLineCreationNotifier
    = AutoDisposeNotifier<TransactionLineCreationState>;
String _$journalActionsNotifierHash() =>
    r'4a0bfbdac9e8f86bb7b9455fb802561212c53cfc';

/// Journal Actions Notifier for mutations
///
/// Copied from [JournalActionsNotifier].
@ProviderFor(JournalActionsNotifier)
final journalActionsNotifierProvider = AutoDisposeNotifierProvider<
    JournalActionsNotifier, AsyncValue<void>>.internal(
  JournalActionsNotifier.new,
  name: r'journalActionsNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$journalActionsNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$JournalActionsNotifier = AutoDisposeNotifier<AsyncValue<void>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
