// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'payment_method_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$PaymentMethodState {
  bool get isLoading => throw _privateConstructorUsedError;

  /// Whether an invoice submission is in progress (prevents duplicate clicks)
  bool get isSubmitting => throw _privateConstructorUsedError;
  String? get error => throw _privateConstructorUsedError;
  BaseCurrencyResponse? get currencyResponse =>
      throw _privateConstructorUsedError;
  List<CashLocation> get cashLocations => throw _privateConstructorUsedError;
  CashLocation? get selectedCashLocation => throw _privateConstructorUsedError;
  PaymentCurrency? get selectedCurrency => throw _privateConstructorUsedError;
  Map<String, double> get currencyAmounts => throw _privateConstructorUsedError;
  String? get focusedCurrencyId => throw _privateConstructorUsedError;
  double get discountAmount => throw _privateConstructorUsedError;

  /// Create a copy of PaymentMethodState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PaymentMethodStateCopyWith<PaymentMethodState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PaymentMethodStateCopyWith<$Res> {
  factory $PaymentMethodStateCopyWith(
          PaymentMethodState value, $Res Function(PaymentMethodState) then) =
      _$PaymentMethodStateCopyWithImpl<$Res, PaymentMethodState>;
  @useResult
  $Res call(
      {bool isLoading,
      bool isSubmitting,
      String? error,
      BaseCurrencyResponse? currencyResponse,
      List<CashLocation> cashLocations,
      CashLocation? selectedCashLocation,
      PaymentCurrency? selectedCurrency,
      Map<String, double> currencyAmounts,
      String? focusedCurrencyId,
      double discountAmount});
}

/// @nodoc
class _$PaymentMethodStateCopyWithImpl<$Res, $Val extends PaymentMethodState>
    implements $PaymentMethodStateCopyWith<$Res> {
  _$PaymentMethodStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PaymentMethodState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isLoading = null,
    Object? isSubmitting = null,
    Object? error = freezed,
    Object? currencyResponse = freezed,
    Object? cashLocations = null,
    Object? selectedCashLocation = freezed,
    Object? selectedCurrency = freezed,
    Object? currencyAmounts = null,
    Object? focusedCurrencyId = freezed,
    Object? discountAmount = null,
  }) {
    return _then(_value.copyWith(
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      isSubmitting: null == isSubmitting
          ? _value.isSubmitting
          : isSubmitting // ignore: cast_nullable_to_non_nullable
              as bool,
      error: freezed == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as String?,
      currencyResponse: freezed == currencyResponse
          ? _value.currencyResponse
          : currencyResponse // ignore: cast_nullable_to_non_nullable
              as BaseCurrencyResponse?,
      cashLocations: null == cashLocations
          ? _value.cashLocations
          : cashLocations // ignore: cast_nullable_to_non_nullable
              as List<CashLocation>,
      selectedCashLocation: freezed == selectedCashLocation
          ? _value.selectedCashLocation
          : selectedCashLocation // ignore: cast_nullable_to_non_nullable
              as CashLocation?,
      selectedCurrency: freezed == selectedCurrency
          ? _value.selectedCurrency
          : selectedCurrency // ignore: cast_nullable_to_non_nullable
              as PaymentCurrency?,
      currencyAmounts: null == currencyAmounts
          ? _value.currencyAmounts
          : currencyAmounts // ignore: cast_nullable_to_non_nullable
              as Map<String, double>,
      focusedCurrencyId: freezed == focusedCurrencyId
          ? _value.focusedCurrencyId
          : focusedCurrencyId // ignore: cast_nullable_to_non_nullable
              as String?,
      discountAmount: null == discountAmount
          ? _value.discountAmount
          : discountAmount // ignore: cast_nullable_to_non_nullable
              as double,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PaymentMethodStateImplCopyWith<$Res>
    implements $PaymentMethodStateCopyWith<$Res> {
  factory _$$PaymentMethodStateImplCopyWith(_$PaymentMethodStateImpl value,
          $Res Function(_$PaymentMethodStateImpl) then) =
      __$$PaymentMethodStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {bool isLoading,
      bool isSubmitting,
      String? error,
      BaseCurrencyResponse? currencyResponse,
      List<CashLocation> cashLocations,
      CashLocation? selectedCashLocation,
      PaymentCurrency? selectedCurrency,
      Map<String, double> currencyAmounts,
      String? focusedCurrencyId,
      double discountAmount});
}

/// @nodoc
class __$$PaymentMethodStateImplCopyWithImpl<$Res>
    extends _$PaymentMethodStateCopyWithImpl<$Res, _$PaymentMethodStateImpl>
    implements _$$PaymentMethodStateImplCopyWith<$Res> {
  __$$PaymentMethodStateImplCopyWithImpl(_$PaymentMethodStateImpl _value,
      $Res Function(_$PaymentMethodStateImpl) _then)
      : super(_value, _then);

  /// Create a copy of PaymentMethodState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isLoading = null,
    Object? isSubmitting = null,
    Object? error = freezed,
    Object? currencyResponse = freezed,
    Object? cashLocations = null,
    Object? selectedCashLocation = freezed,
    Object? selectedCurrency = freezed,
    Object? currencyAmounts = null,
    Object? focusedCurrencyId = freezed,
    Object? discountAmount = null,
  }) {
    return _then(_$PaymentMethodStateImpl(
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      isSubmitting: null == isSubmitting
          ? _value.isSubmitting
          : isSubmitting // ignore: cast_nullable_to_non_nullable
              as bool,
      error: freezed == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as String?,
      currencyResponse: freezed == currencyResponse
          ? _value.currencyResponse
          : currencyResponse // ignore: cast_nullable_to_non_nullable
              as BaseCurrencyResponse?,
      cashLocations: null == cashLocations
          ? _value._cashLocations
          : cashLocations // ignore: cast_nullable_to_non_nullable
              as List<CashLocation>,
      selectedCashLocation: freezed == selectedCashLocation
          ? _value.selectedCashLocation
          : selectedCashLocation // ignore: cast_nullable_to_non_nullable
              as CashLocation?,
      selectedCurrency: freezed == selectedCurrency
          ? _value.selectedCurrency
          : selectedCurrency // ignore: cast_nullable_to_non_nullable
              as PaymentCurrency?,
      currencyAmounts: null == currencyAmounts
          ? _value._currencyAmounts
          : currencyAmounts // ignore: cast_nullable_to_non_nullable
              as Map<String, double>,
      focusedCurrencyId: freezed == focusedCurrencyId
          ? _value.focusedCurrencyId
          : focusedCurrencyId // ignore: cast_nullable_to_non_nullable
              as String?,
      discountAmount: null == discountAmount
          ? _value.discountAmount
          : discountAmount // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// @nodoc

class _$PaymentMethodStateImpl implements _PaymentMethodState {
  const _$PaymentMethodStateImpl(
      {this.isLoading = false,
      this.isSubmitting = false,
      this.error,
      this.currencyResponse,
      final List<CashLocation> cashLocations = const [],
      this.selectedCashLocation,
      this.selectedCurrency,
      final Map<String, double> currencyAmounts = const {},
      this.focusedCurrencyId,
      this.discountAmount = 0.0})
      : _cashLocations = cashLocations,
        _currencyAmounts = currencyAmounts;

  @override
  @JsonKey()
  final bool isLoading;

  /// Whether an invoice submission is in progress (prevents duplicate clicks)
  @override
  @JsonKey()
  final bool isSubmitting;
  @override
  final String? error;
  @override
  final BaseCurrencyResponse? currencyResponse;
  final List<CashLocation> _cashLocations;
  @override
  @JsonKey()
  List<CashLocation> get cashLocations {
    if (_cashLocations is EqualUnmodifiableListView) return _cashLocations;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_cashLocations);
  }

  @override
  final CashLocation? selectedCashLocation;
  @override
  final PaymentCurrency? selectedCurrency;
  final Map<String, double> _currencyAmounts;
  @override
  @JsonKey()
  Map<String, double> get currencyAmounts {
    if (_currencyAmounts is EqualUnmodifiableMapView) return _currencyAmounts;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_currencyAmounts);
  }

  @override
  final String? focusedCurrencyId;
  @override
  @JsonKey()
  final double discountAmount;

  @override
  String toString() {
    return 'PaymentMethodState(isLoading: $isLoading, isSubmitting: $isSubmitting, error: $error, currencyResponse: $currencyResponse, cashLocations: $cashLocations, selectedCashLocation: $selectedCashLocation, selectedCurrency: $selectedCurrency, currencyAmounts: $currencyAmounts, focusedCurrencyId: $focusedCurrencyId, discountAmount: $discountAmount)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PaymentMethodStateImpl &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            (identical(other.isSubmitting, isSubmitting) ||
                other.isSubmitting == isSubmitting) &&
            (identical(other.error, error) || other.error == error) &&
            (identical(other.currencyResponse, currencyResponse) ||
                other.currencyResponse == currencyResponse) &&
            const DeepCollectionEquality()
                .equals(other._cashLocations, _cashLocations) &&
            (identical(other.selectedCashLocation, selectedCashLocation) ||
                other.selectedCashLocation == selectedCashLocation) &&
            (identical(other.selectedCurrency, selectedCurrency) ||
                other.selectedCurrency == selectedCurrency) &&
            const DeepCollectionEquality()
                .equals(other._currencyAmounts, _currencyAmounts) &&
            (identical(other.focusedCurrencyId, focusedCurrencyId) ||
                other.focusedCurrencyId == focusedCurrencyId) &&
            (identical(other.discountAmount, discountAmount) ||
                other.discountAmount == discountAmount));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      isLoading,
      isSubmitting,
      error,
      currencyResponse,
      const DeepCollectionEquality().hash(_cashLocations),
      selectedCashLocation,
      selectedCurrency,
      const DeepCollectionEquality().hash(_currencyAmounts),
      focusedCurrencyId,
      discountAmount);

  /// Create a copy of PaymentMethodState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PaymentMethodStateImplCopyWith<_$PaymentMethodStateImpl> get copyWith =>
      __$$PaymentMethodStateImplCopyWithImpl<_$PaymentMethodStateImpl>(
          this, _$identity);
}

abstract class _PaymentMethodState implements PaymentMethodState {
  const factory _PaymentMethodState(
      {final bool isLoading,
      final bool isSubmitting,
      final String? error,
      final BaseCurrencyResponse? currencyResponse,
      final List<CashLocation> cashLocations,
      final CashLocation? selectedCashLocation,
      final PaymentCurrency? selectedCurrency,
      final Map<String, double> currencyAmounts,
      final String? focusedCurrencyId,
      final double discountAmount}) = _$PaymentMethodStateImpl;

  @override
  bool get isLoading;

  /// Whether an invoice submission is in progress (prevents duplicate clicks)
  @override
  bool get isSubmitting;
  @override
  String? get error;
  @override
  BaseCurrencyResponse? get currencyResponse;
  @override
  List<CashLocation> get cashLocations;
  @override
  CashLocation? get selectedCashLocation;
  @override
  PaymentCurrency? get selectedCurrency;
  @override
  Map<String, double> get currencyAmounts;
  @override
  String? get focusedCurrencyId;
  @override
  double get discountAmount;

  /// Create a copy of PaymentMethodState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PaymentMethodStateImplCopyWith<_$PaymentMethodStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
