// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'balance_sheet_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$balanceSheetHash() => r'1a07aad8e61e746c347c04244e1a8024b1d9ba25';

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

/// Balance sheet data provider (v2 - no date filter)
///
/// Copied from [balanceSheet].
@ProviderFor(balanceSheet)
const balanceSheetProvider = BalanceSheetFamily();

/// Balance sheet data provider (v2 - no date filter)
///
/// Copied from [balanceSheet].
class BalanceSheetFamily extends Family<AsyncValue<BalanceSheet>> {
  /// Balance sheet data provider (v2 - no date filter)
  ///
  /// Copied from [balanceSheet].
  const BalanceSheetFamily();

  /// Balance sheet data provider (v2 - no date filter)
  ///
  /// Copied from [balanceSheet].
  BalanceSheetProvider call(
    BalanceSheetParams params,
  ) {
    return BalanceSheetProvider(
      params,
    );
  }

  @override
  BalanceSheetProvider getProviderOverride(
    covariant BalanceSheetProvider provider,
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
  String? get name => r'balanceSheetProvider';
}

/// Balance sheet data provider (v2 - no date filter)
///
/// Copied from [balanceSheet].
class BalanceSheetProvider extends AutoDisposeFutureProvider<BalanceSheet> {
  /// Balance sheet data provider (v2 - no date filter)
  ///
  /// Copied from [balanceSheet].
  BalanceSheetProvider(
    BalanceSheetParams params,
  ) : this._internal(
          (ref) => balanceSheet(
            ref as BalanceSheetRef,
            params,
          ),
          from: balanceSheetProvider,
          name: r'balanceSheetProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$balanceSheetHash,
          dependencies: BalanceSheetFamily._dependencies,
          allTransitiveDependencies:
              BalanceSheetFamily._allTransitiveDependencies,
          params: params,
        );

  BalanceSheetProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.params,
  }) : super.internal();

  final BalanceSheetParams params;

  @override
  Override overrideWith(
    FutureOr<BalanceSheet> Function(BalanceSheetRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: BalanceSheetProvider._internal(
        (ref) => create(ref as BalanceSheetRef),
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
  AutoDisposeFutureProviderElement<BalanceSheet> createElement() {
    return _BalanceSheetProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is BalanceSheetProvider && other.params == params;
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
mixin BalanceSheetRef on AutoDisposeFutureProviderRef<BalanceSheet> {
  /// The parameter `params` of this provider.
  BalanceSheetParams get params;
}

class _BalanceSheetProviderElement
    extends AutoDisposeFutureProviderElement<BalanceSheet>
    with BalanceSheetRef {
  _BalanceSheetProviderElement(super.provider);

  @override
  BalanceSheetParams get params => (origin as BalanceSheetProvider).params;
}

String _$incomeStatementHash() => r'92cfa302c1409a0d4ac2eab4d765b5ba45c43b7c';

/// Income statement data provider (v3 - with timezone support)
///
/// Copied from [incomeStatement].
@ProviderFor(incomeStatement)
const incomeStatementProvider = IncomeStatementFamily();

/// Income statement data provider (v3 - with timezone support)
///
/// Copied from [incomeStatement].
class IncomeStatementFamily extends Family<AsyncValue<IncomeStatement>> {
  /// Income statement data provider (v3 - with timezone support)
  ///
  /// Copied from [incomeStatement].
  const IncomeStatementFamily();

  /// Income statement data provider (v3 - with timezone support)
  ///
  /// Copied from [incomeStatement].
  IncomeStatementProvider call(
    IncomeStatementParams params,
  ) {
    return IncomeStatementProvider(
      params,
    );
  }

  @override
  IncomeStatementProvider getProviderOverride(
    covariant IncomeStatementProvider provider,
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
  String? get name => r'incomeStatementProvider';
}

/// Income statement data provider (v3 - with timezone support)
///
/// Copied from [incomeStatement].
class IncomeStatementProvider
    extends AutoDisposeFutureProvider<IncomeStatement> {
  /// Income statement data provider (v3 - with timezone support)
  ///
  /// Copied from [incomeStatement].
  IncomeStatementProvider(
    IncomeStatementParams params,
  ) : this._internal(
          (ref) => incomeStatement(
            ref as IncomeStatementRef,
            params,
          ),
          from: incomeStatementProvider,
          name: r'incomeStatementProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$incomeStatementHash,
          dependencies: IncomeStatementFamily._dependencies,
          allTransitiveDependencies:
              IncomeStatementFamily._allTransitiveDependencies,
          params: params,
        );

  IncomeStatementProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.params,
  }) : super.internal();

  final IncomeStatementParams params;

  @override
  Override overrideWith(
    FutureOr<IncomeStatement> Function(IncomeStatementRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: IncomeStatementProvider._internal(
        (ref) => create(ref as IncomeStatementRef),
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
  AutoDisposeFutureProviderElement<IncomeStatement> createElement() {
    return _IncomeStatementProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is IncomeStatementProvider && other.params == params;
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
mixin IncomeStatementRef on AutoDisposeFutureProviderRef<IncomeStatement> {
  /// The parameter `params` of this provider.
  IncomeStatementParams get params;
}

class _IncomeStatementProviderElement
    extends AutoDisposeFutureProviderElement<IncomeStatement>
    with IncomeStatementRef {
  _IncomeStatementProviderElement(super.provider);

  @override
  IncomeStatementParams get params =>
      (origin as IncomeStatementProvider).params;
}

String _$currencyHash() => r'6d70bac72a0dfdd7e8ce3e95f1b21dcc00ef4200';

/// Currency provider
///
/// Copied from [currency].
@ProviderFor(currency)
const currencyProvider = CurrencyFamily();

/// Currency provider
///
/// Copied from [currency].
class CurrencyFamily extends Family<AsyncValue<Currency>> {
  /// Currency provider
  ///
  /// Copied from [currency].
  const CurrencyFamily();

  /// Currency provider
  ///
  /// Copied from [currency].
  CurrencyProvider call(
    String companyId,
  ) {
    return CurrencyProvider(
      companyId,
    );
  }

  @override
  CurrencyProvider getProviderOverride(
    covariant CurrencyProvider provider,
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
  String? get name => r'currencyProvider';
}

/// Currency provider
///
/// Copied from [currency].
class CurrencyProvider extends AutoDisposeFutureProvider<Currency> {
  /// Currency provider
  ///
  /// Copied from [currency].
  CurrencyProvider(
    String companyId,
  ) : this._internal(
          (ref) => currency(
            ref as CurrencyRef,
            companyId,
          ),
          from: currencyProvider,
          name: r'currencyProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$currencyHash,
          dependencies: CurrencyFamily._dependencies,
          allTransitiveDependencies: CurrencyFamily._allTransitiveDependencies,
          companyId: companyId,
        );

  CurrencyProvider._internal(
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
    FutureOr<Currency> Function(CurrencyRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: CurrencyProvider._internal(
        (ref) => create(ref as CurrencyRef),
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
  AutoDisposeFutureProviderElement<Currency> createElement() {
    return _CurrencyProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is CurrencyProvider && other.companyId == companyId;
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
mixin CurrencyRef on AutoDisposeFutureProviderRef<Currency> {
  /// The parameter `companyId` of this provider.
  String get companyId;
}

class _CurrencyProviderElement
    extends AutoDisposeFutureProviderElement<Currency> with CurrencyRef {
  _CurrencyProviderElement(super.provider);

  @override
  String get companyId => (origin as CurrencyProvider).companyId;
}

String _$balanceSheetPageNotifierHash() =>
    r'a7469e2ee9426ab935d0a74058c33a450e08ab49';

/// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
/// 🎯 Balance Sheet Page Notifier - 페이지 상태 관리
/// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
///
/// Balance Sheet 페이지의 UI 상태만 관리합니다.
/// - 탭 선택 (Balance Sheet / Income Statement)
/// - 날짜 범위 선택
/// - 데이터 생성 플래그
///
/// 데이터 로딩은 FutureProvider (balanceSheetProvider, incomeStatementProvider)가 담당합니다.
///
/// Copied from [BalanceSheetPageNotifier].
@ProviderFor(BalanceSheetPageNotifier)
final balanceSheetPageNotifierProvider = AutoDisposeNotifierProvider<
    BalanceSheetPageNotifier, BalanceSheetPageState>.internal(
  BalanceSheetPageNotifier.new,
  name: r'balanceSheetPageNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$balanceSheetPageNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$BalanceSheetPageNotifier = AutoDisposeNotifier<BalanceSheetPageState>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
