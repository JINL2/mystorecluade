// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'financial_statements_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$balanceSheetDataSourceHash() =>
    r'14ebcb2c4e1cb0f3778d4b2f862c62abea31684d';

/// See also [balanceSheetDataSource].
@ProviderFor(balanceSheetDataSource)
final balanceSheetDataSourceProvider =
    AutoDisposeProvider<BalanceSheetDataSource>.internal(
  balanceSheetDataSource,
  name: r'balanceSheetDataSourceProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$balanceSheetDataSourceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef BalanceSheetDataSourceRef
    = AutoDisposeProviderRef<BalanceSheetDataSource>;
String _$pnlSummaryHash() => r'6c9805b4f8aec5cff00b3ae233046947425a2054';

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

/// P&L Summary Provider
///
/// Copied from [pnlSummary].
@ProviderFor(pnlSummary)
const pnlSummaryProvider = PnlSummaryFamily();

/// P&L Summary Provider
///
/// Copied from [pnlSummary].
class PnlSummaryFamily extends Family<AsyncValue<PnlSummaryModel>> {
  /// P&L Summary Provider
  ///
  /// Copied from [pnlSummary].
  const PnlSummaryFamily();

  /// P&L Summary Provider
  ///
  /// Copied from [pnlSummary].
  PnlSummaryProvider call(
    PnlParams params,
  ) {
    return PnlSummaryProvider(
      params,
    );
  }

  @override
  PnlSummaryProvider getProviderOverride(
    covariant PnlSummaryProvider provider,
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
  String? get name => r'pnlSummaryProvider';
}

/// P&L Summary Provider
///
/// Copied from [pnlSummary].
class PnlSummaryProvider extends AutoDisposeFutureProvider<PnlSummaryModel> {
  /// P&L Summary Provider
  ///
  /// Copied from [pnlSummary].
  PnlSummaryProvider(
    PnlParams params,
  ) : this._internal(
          (ref) => pnlSummary(
            ref as PnlSummaryRef,
            params,
          ),
          from: pnlSummaryProvider,
          name: r'pnlSummaryProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$pnlSummaryHash,
          dependencies: PnlSummaryFamily._dependencies,
          allTransitiveDependencies:
              PnlSummaryFamily._allTransitiveDependencies,
          params: params,
        );

  PnlSummaryProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.params,
  }) : super.internal();

  final PnlParams params;

  @override
  Override overrideWith(
    FutureOr<PnlSummaryModel> Function(PnlSummaryRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: PnlSummaryProvider._internal(
        (ref) => create(ref as PnlSummaryRef),
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
  AutoDisposeFutureProviderElement<PnlSummaryModel> createElement() {
    return _PnlSummaryProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is PnlSummaryProvider && other.params == params;
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
mixin PnlSummaryRef on AutoDisposeFutureProviderRef<PnlSummaryModel> {
  /// The parameter `params` of this provider.
  PnlParams get params;
}

class _PnlSummaryProviderElement
    extends AutoDisposeFutureProviderElement<PnlSummaryModel>
    with PnlSummaryRef {
  _PnlSummaryProviderElement(super.provider);

  @override
  PnlParams get params => (origin as PnlSummaryProvider).params;
}

String _$pnlDetailHash() => r'a7ca5f843c831936adb554372ac1575dec56ad51';

/// P&L Detail Provider
///
/// Copied from [pnlDetail].
@ProviderFor(pnlDetail)
const pnlDetailProvider = PnlDetailFamily();

/// P&L Detail Provider
///
/// Copied from [pnlDetail].
class PnlDetailFamily extends Family<AsyncValue<List<PnlDetailRowModel>>> {
  /// P&L Detail Provider
  ///
  /// Copied from [pnlDetail].
  const PnlDetailFamily();

  /// P&L Detail Provider
  ///
  /// Copied from [pnlDetail].
  PnlDetailProvider call(
    PnlParams params,
  ) {
    return PnlDetailProvider(
      params,
    );
  }

  @override
  PnlDetailProvider getProviderOverride(
    covariant PnlDetailProvider provider,
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
  String? get name => r'pnlDetailProvider';
}

/// P&L Detail Provider
///
/// Copied from [pnlDetail].
class PnlDetailProvider
    extends AutoDisposeFutureProvider<List<PnlDetailRowModel>> {
  /// P&L Detail Provider
  ///
  /// Copied from [pnlDetail].
  PnlDetailProvider(
    PnlParams params,
  ) : this._internal(
          (ref) => pnlDetail(
            ref as PnlDetailRef,
            params,
          ),
          from: pnlDetailProvider,
          name: r'pnlDetailProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$pnlDetailHash,
          dependencies: PnlDetailFamily._dependencies,
          allTransitiveDependencies: PnlDetailFamily._allTransitiveDependencies,
          params: params,
        );

  PnlDetailProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.params,
  }) : super.internal();

  final PnlParams params;

  @override
  Override overrideWith(
    FutureOr<List<PnlDetailRowModel>> Function(PnlDetailRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: PnlDetailProvider._internal(
        (ref) => create(ref as PnlDetailRef),
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
  AutoDisposeFutureProviderElement<List<PnlDetailRowModel>> createElement() {
    return _PnlDetailProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is PnlDetailProvider && other.params == params;
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
mixin PnlDetailRef on AutoDisposeFutureProviderRef<List<PnlDetailRowModel>> {
  /// The parameter `params` of this provider.
  PnlParams get params;
}

class _PnlDetailProviderElement
    extends AutoDisposeFutureProviderElement<List<PnlDetailRowModel>>
    with PnlDetailRef {
  _PnlDetailProviderElement(super.provider);

  @override
  PnlParams get params => (origin as PnlDetailProvider).params;
}

String _$bsSummaryHash() => r'9f8e7e7a7a3d9b2181d9e7b3871685e7e9fbb54c';

/// B/S Summary Provider
///
/// Copied from [bsSummary].
@ProviderFor(bsSummary)
const bsSummaryProvider = BsSummaryFamily();

/// B/S Summary Provider
///
/// Copied from [bsSummary].
class BsSummaryFamily extends Family<AsyncValue<BsSummaryModel>> {
  /// B/S Summary Provider
  ///
  /// Copied from [bsSummary].
  const BsSummaryFamily();

  /// B/S Summary Provider
  ///
  /// Copied from [bsSummary].
  BsSummaryProvider call(
    BsParams params,
  ) {
    return BsSummaryProvider(
      params,
    );
  }

  @override
  BsSummaryProvider getProviderOverride(
    covariant BsSummaryProvider provider,
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
  String? get name => r'bsSummaryProvider';
}

/// B/S Summary Provider
///
/// Copied from [bsSummary].
class BsSummaryProvider extends AutoDisposeFutureProvider<BsSummaryModel> {
  /// B/S Summary Provider
  ///
  /// Copied from [bsSummary].
  BsSummaryProvider(
    BsParams params,
  ) : this._internal(
          (ref) => bsSummary(
            ref as BsSummaryRef,
            params,
          ),
          from: bsSummaryProvider,
          name: r'bsSummaryProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$bsSummaryHash,
          dependencies: BsSummaryFamily._dependencies,
          allTransitiveDependencies: BsSummaryFamily._allTransitiveDependencies,
          params: params,
        );

  BsSummaryProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.params,
  }) : super.internal();

  final BsParams params;

  @override
  Override overrideWith(
    FutureOr<BsSummaryModel> Function(BsSummaryRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: BsSummaryProvider._internal(
        (ref) => create(ref as BsSummaryRef),
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
  AutoDisposeFutureProviderElement<BsSummaryModel> createElement() {
    return _BsSummaryProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is BsSummaryProvider && other.params == params;
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
mixin BsSummaryRef on AutoDisposeFutureProviderRef<BsSummaryModel> {
  /// The parameter `params` of this provider.
  BsParams get params;
}

class _BsSummaryProviderElement
    extends AutoDisposeFutureProviderElement<BsSummaryModel> with BsSummaryRef {
  _BsSummaryProviderElement(super.provider);

  @override
  BsParams get params => (origin as BsSummaryProvider).params;
}

String _$bsDetailHash() => r'0fdc3af8d068f16259157c97c4e2af0c993569e9';

/// B/S Detail Provider
///
/// Copied from [bsDetail].
@ProviderFor(bsDetail)
const bsDetailProvider = BsDetailFamily();

/// B/S Detail Provider
///
/// Copied from [bsDetail].
class BsDetailFamily extends Family<AsyncValue<List<BsDetailRowModel>>> {
  /// B/S Detail Provider
  ///
  /// Copied from [bsDetail].
  const BsDetailFamily();

  /// B/S Detail Provider
  ///
  /// Copied from [bsDetail].
  BsDetailProvider call(
    BsParams params,
  ) {
    return BsDetailProvider(
      params,
    );
  }

  @override
  BsDetailProvider getProviderOverride(
    covariant BsDetailProvider provider,
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
  String? get name => r'bsDetailProvider';
}

/// B/S Detail Provider
///
/// Copied from [bsDetail].
class BsDetailProvider
    extends AutoDisposeFutureProvider<List<BsDetailRowModel>> {
  /// B/S Detail Provider
  ///
  /// Copied from [bsDetail].
  BsDetailProvider(
    BsParams params,
  ) : this._internal(
          (ref) => bsDetail(
            ref as BsDetailRef,
            params,
          ),
          from: bsDetailProvider,
          name: r'bsDetailProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$bsDetailHash,
          dependencies: BsDetailFamily._dependencies,
          allTransitiveDependencies: BsDetailFamily._allTransitiveDependencies,
          params: params,
        );

  BsDetailProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.params,
  }) : super.internal();

  final BsParams params;

  @override
  Override overrideWith(
    FutureOr<List<BsDetailRowModel>> Function(BsDetailRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: BsDetailProvider._internal(
        (ref) => create(ref as BsDetailRef),
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
  AutoDisposeFutureProviderElement<List<BsDetailRowModel>> createElement() {
    return _BsDetailProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is BsDetailProvider && other.params == params;
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
mixin BsDetailRef on AutoDisposeFutureProviderRef<List<BsDetailRowModel>> {
  /// The parameter `params` of this provider.
  BsParams get params;
}

class _BsDetailProviderElement
    extends AutoDisposeFutureProviderElement<List<BsDetailRowModel>>
    with BsDetailRef {
  _BsDetailProviderElement(super.provider);

  @override
  BsParams get params => (origin as BsDetailProvider).params;
}

String _$dailyPnlTrendHash() => r'870b37b76edb006749b9605773c9fed1a25990a5';

/// Daily P&L Trend Provider
///
/// Copied from [dailyPnlTrend].
@ProviderFor(dailyPnlTrend)
const dailyPnlTrendProvider = DailyPnlTrendFamily();

/// Daily P&L Trend Provider
///
/// Copied from [dailyPnlTrend].
class DailyPnlTrendFamily extends Family<AsyncValue<List<DailyPnlModel>>> {
  /// Daily P&L Trend Provider
  ///
  /// Copied from [dailyPnlTrend].
  const DailyPnlTrendFamily();

  /// Daily P&L Trend Provider
  ///
  /// Copied from [dailyPnlTrend].
  DailyPnlTrendProvider call(
    TrendParams params,
  ) {
    return DailyPnlTrendProvider(
      params,
    );
  }

  @override
  DailyPnlTrendProvider getProviderOverride(
    covariant DailyPnlTrendProvider provider,
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
  String? get name => r'dailyPnlTrendProvider';
}

/// Daily P&L Trend Provider
///
/// Copied from [dailyPnlTrend].
class DailyPnlTrendProvider
    extends AutoDisposeFutureProvider<List<DailyPnlModel>> {
  /// Daily P&L Trend Provider
  ///
  /// Copied from [dailyPnlTrend].
  DailyPnlTrendProvider(
    TrendParams params,
  ) : this._internal(
          (ref) => dailyPnlTrend(
            ref as DailyPnlTrendRef,
            params,
          ),
          from: dailyPnlTrendProvider,
          name: r'dailyPnlTrendProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$dailyPnlTrendHash,
          dependencies: DailyPnlTrendFamily._dependencies,
          allTransitiveDependencies:
              DailyPnlTrendFamily._allTransitiveDependencies,
          params: params,
        );

  DailyPnlTrendProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.params,
  }) : super.internal();

  final TrendParams params;

  @override
  Override overrideWith(
    FutureOr<List<DailyPnlModel>> Function(DailyPnlTrendRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: DailyPnlTrendProvider._internal(
        (ref) => create(ref as DailyPnlTrendRef),
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
  AutoDisposeFutureProviderElement<List<DailyPnlModel>> createElement() {
    return _DailyPnlTrendProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is DailyPnlTrendProvider && other.params == params;
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
mixin DailyPnlTrendRef on AutoDisposeFutureProviderRef<List<DailyPnlModel>> {
  /// The parameter `params` of this provider.
  TrendParams get params;
}

class _DailyPnlTrendProviderElement
    extends AutoDisposeFutureProviderElement<List<DailyPnlModel>>
    with DailyPnlTrendRef {
  _DailyPnlTrendProviderElement(super.provider);

  @override
  TrendParams get params => (origin as DailyPnlTrendProvider).params;
}

String _$companyCurrencyHash() => r'15ed4ab43ba14c734e87779b613036d7f9b3f268';

/// Currency Provider
///
/// Copied from [companyCurrency].
@ProviderFor(companyCurrency)
const companyCurrencyProvider = CompanyCurrencyFamily();

/// Currency Provider
///
/// Copied from [companyCurrency].
class CompanyCurrencyFamily extends Family<AsyncValue<String>> {
  /// Currency Provider
  ///
  /// Copied from [companyCurrency].
  const CompanyCurrencyFamily();

  /// Currency Provider
  ///
  /// Copied from [companyCurrency].
  CompanyCurrencyProvider call(
    String companyId,
  ) {
    return CompanyCurrencyProvider(
      companyId,
    );
  }

  @override
  CompanyCurrencyProvider getProviderOverride(
    covariant CompanyCurrencyProvider provider,
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
  String? get name => r'companyCurrencyProvider';
}

/// Currency Provider
///
/// Copied from [companyCurrency].
class CompanyCurrencyProvider extends AutoDisposeFutureProvider<String> {
  /// Currency Provider
  ///
  /// Copied from [companyCurrency].
  CompanyCurrencyProvider(
    String companyId,
  ) : this._internal(
          (ref) => companyCurrency(
            ref as CompanyCurrencyRef,
            companyId,
          ),
          from: companyCurrencyProvider,
          name: r'companyCurrencyProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$companyCurrencyHash,
          dependencies: CompanyCurrencyFamily._dependencies,
          allTransitiveDependencies:
              CompanyCurrencyFamily._allTransitiveDependencies,
          companyId: companyId,
        );

  CompanyCurrencyProvider._internal(
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
    FutureOr<String> Function(CompanyCurrencyRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: CompanyCurrencyProvider._internal(
        (ref) => create(ref as CompanyCurrencyRef),
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
  AutoDisposeFutureProviderElement<String> createElement() {
    return _CompanyCurrencyProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is CompanyCurrencyProvider && other.companyId == companyId;
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
mixin CompanyCurrencyRef on AutoDisposeFutureProviderRef<String> {
  /// The parameter `companyId` of this provider.
  String get companyId;
}

class _CompanyCurrencyProviderElement
    extends AutoDisposeFutureProviderElement<String> with CompanyCurrencyRef {
  _CompanyCurrencyProviderElement(super.provider);

  @override
  String get companyId => (origin as CompanyCurrencyProvider).companyId;
}

String _$financialStatementsPageNotifierHash() =>
    r'de9dac3d86a1032bc743dcfb1506ee7a30821ce4';

/// See also [FinancialStatementsPageNotifier].
@ProviderFor(FinancialStatementsPageNotifier)
final financialStatementsPageNotifierProvider = AutoDisposeNotifierProvider<
    FinancialStatementsPageNotifier, FinancialStatementsPageState>.internal(
  FinancialStatementsPageNotifier.new,
  name: r'financialStatementsPageNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$financialStatementsPageNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$FinancialStatementsPageNotifier
    = AutoDisposeNotifier<FinancialStatementsPageState>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
