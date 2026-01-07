// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'exchange_rate_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$calculatorExchangeRateDataHash() =>
    r'cda583d44c7dbabf31db2c934dfe0f4d0934d204';

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

/// Fetch exchange rates for currency conversion
/// Uses get_exchange_rate_v3 RPC which supports store-based currency sorting
///
/// Copied from [calculatorExchangeRateData].
@ProviderFor(calculatorExchangeRateData)
const calculatorExchangeRateDataProvider = CalculatorExchangeRateDataFamily();

/// Fetch exchange rates for currency conversion
/// Uses get_exchange_rate_v3 RPC which supports store-based currency sorting
///
/// Copied from [calculatorExchangeRateData].
class CalculatorExchangeRateDataFamily
    extends Family<AsyncValue<Map<String, dynamic>>> {
  /// Fetch exchange rates for currency conversion
  /// Uses get_exchange_rate_v3 RPC which supports store-based currency sorting
  ///
  /// Copied from [calculatorExchangeRateData].
  const CalculatorExchangeRateDataFamily();

  /// Fetch exchange rates for currency conversion
  /// Uses get_exchange_rate_v3 RPC which supports store-based currency sorting
  ///
  /// Copied from [calculatorExchangeRateData].
  CalculatorExchangeRateDataProvider call(
    CalculatorExchangeRateParams params,
  ) {
    return CalculatorExchangeRateDataProvider(
      params,
    );
  }

  @override
  CalculatorExchangeRateDataProvider getProviderOverride(
    covariant CalculatorExchangeRateDataProvider provider,
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
  String? get name => r'calculatorExchangeRateDataProvider';
}

/// Fetch exchange rates for currency conversion
/// Uses get_exchange_rate_v3 RPC which supports store-based currency sorting
///
/// Copied from [calculatorExchangeRateData].
class CalculatorExchangeRateDataProvider
    extends AutoDisposeFutureProvider<Map<String, dynamic>> {
  /// Fetch exchange rates for currency conversion
  /// Uses get_exchange_rate_v3 RPC which supports store-based currency sorting
  ///
  /// Copied from [calculatorExchangeRateData].
  CalculatorExchangeRateDataProvider(
    CalculatorExchangeRateParams params,
  ) : this._internal(
          (ref) => calculatorExchangeRateData(
            ref as CalculatorExchangeRateDataRef,
            params,
          ),
          from: calculatorExchangeRateDataProvider,
          name: r'calculatorExchangeRateDataProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$calculatorExchangeRateDataHash,
          dependencies: CalculatorExchangeRateDataFamily._dependencies,
          allTransitiveDependencies:
              CalculatorExchangeRateDataFamily._allTransitiveDependencies,
          params: params,
        );

  CalculatorExchangeRateDataProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.params,
  }) : super.internal();

  final CalculatorExchangeRateParams params;

  @override
  Override overrideWith(
    FutureOr<Map<String, dynamic>> Function(
            CalculatorExchangeRateDataRef provider)
        create,
  ) {
    return ProviderOverride(
      origin: this,
      override: CalculatorExchangeRateDataProvider._internal(
        (ref) => create(ref as CalculatorExchangeRateDataRef),
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
    return _CalculatorExchangeRateDataProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is CalculatorExchangeRateDataProvider &&
        other.params == params;
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
mixin CalculatorExchangeRateDataRef
    on AutoDisposeFutureProviderRef<Map<String, dynamic>> {
  /// The parameter `params` of this provider.
  CalculatorExchangeRateParams get params;
}

class _CalculatorExchangeRateDataProviderElement
    extends AutoDisposeFutureProviderElement<Map<String, dynamic>>
    with CalculatorExchangeRateDataRef {
  _CalculatorExchangeRateDataProviderElement(super.provider);

  @override
  CalculatorExchangeRateParams get params =>
      (origin as CalculatorExchangeRateDataProvider).params;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
