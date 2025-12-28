// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'actual_flow.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$ActualFlow {
  String get flowId => throw _privateConstructorUsedError;
  String get createdAt => throw _privateConstructorUsedError;
  String get systemTime => throw _privateConstructorUsedError;
  double get balanceBefore => throw _privateConstructorUsedError;
  double get flowAmount => throw _privateConstructorUsedError;
  double get balanceAfter => throw _privateConstructorUsedError;
  CurrencyInfo get currency => throw _privateConstructorUsedError;
  CreatedBy get createdBy => throw _privateConstructorUsedError;
  List<DenominationDetail> get currentDenominations =>
      throw _privateConstructorUsedError;

  /// Create a copy of ActualFlow
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ActualFlowCopyWith<ActualFlow> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ActualFlowCopyWith<$Res> {
  factory $ActualFlowCopyWith(
          ActualFlow value, $Res Function(ActualFlow) then) =
      _$ActualFlowCopyWithImpl<$Res, ActualFlow>;
  @useResult
  $Res call(
      {String flowId,
      String createdAt,
      String systemTime,
      double balanceBefore,
      double flowAmount,
      double balanceAfter,
      CurrencyInfo currency,
      CreatedBy createdBy,
      List<DenominationDetail> currentDenominations});

  $CurrencyInfoCopyWith<$Res> get currency;
  $CreatedByCopyWith<$Res> get createdBy;
}

/// @nodoc
class _$ActualFlowCopyWithImpl<$Res, $Val extends ActualFlow>
    implements $ActualFlowCopyWith<$Res> {
  _$ActualFlowCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ActualFlow
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? flowId = null,
    Object? createdAt = null,
    Object? systemTime = null,
    Object? balanceBefore = null,
    Object? flowAmount = null,
    Object? balanceAfter = null,
    Object? currency = null,
    Object? createdBy = null,
    Object? currentDenominations = null,
  }) {
    return _then(_value.copyWith(
      flowId: null == flowId
          ? _value.flowId
          : flowId // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as String,
      systemTime: null == systemTime
          ? _value.systemTime
          : systemTime // ignore: cast_nullable_to_non_nullable
              as String,
      balanceBefore: null == balanceBefore
          ? _value.balanceBefore
          : balanceBefore // ignore: cast_nullable_to_non_nullable
              as double,
      flowAmount: null == flowAmount
          ? _value.flowAmount
          : flowAmount // ignore: cast_nullable_to_non_nullable
              as double,
      balanceAfter: null == balanceAfter
          ? _value.balanceAfter
          : balanceAfter // ignore: cast_nullable_to_non_nullable
              as double,
      currency: null == currency
          ? _value.currency
          : currency // ignore: cast_nullable_to_non_nullable
              as CurrencyInfo,
      createdBy: null == createdBy
          ? _value.createdBy
          : createdBy // ignore: cast_nullable_to_non_nullable
              as CreatedBy,
      currentDenominations: null == currentDenominations
          ? _value.currentDenominations
          : currentDenominations // ignore: cast_nullable_to_non_nullable
              as List<DenominationDetail>,
    ) as $Val);
  }

  /// Create a copy of ActualFlow
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $CurrencyInfoCopyWith<$Res> get currency {
    return $CurrencyInfoCopyWith<$Res>(_value.currency, (value) {
      return _then(_value.copyWith(currency: value) as $Val);
    });
  }

  /// Create a copy of ActualFlow
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $CreatedByCopyWith<$Res> get createdBy {
    return $CreatedByCopyWith<$Res>(_value.createdBy, (value) {
      return _then(_value.copyWith(createdBy: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$ActualFlowImplCopyWith<$Res>
    implements $ActualFlowCopyWith<$Res> {
  factory _$$ActualFlowImplCopyWith(
          _$ActualFlowImpl value, $Res Function(_$ActualFlowImpl) then) =
      __$$ActualFlowImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String flowId,
      String createdAt,
      String systemTime,
      double balanceBefore,
      double flowAmount,
      double balanceAfter,
      CurrencyInfo currency,
      CreatedBy createdBy,
      List<DenominationDetail> currentDenominations});

  @override
  $CurrencyInfoCopyWith<$Res> get currency;
  @override
  $CreatedByCopyWith<$Res> get createdBy;
}

/// @nodoc
class __$$ActualFlowImplCopyWithImpl<$Res>
    extends _$ActualFlowCopyWithImpl<$Res, _$ActualFlowImpl>
    implements _$$ActualFlowImplCopyWith<$Res> {
  __$$ActualFlowImplCopyWithImpl(
      _$ActualFlowImpl _value, $Res Function(_$ActualFlowImpl) _then)
      : super(_value, _then);

  /// Create a copy of ActualFlow
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? flowId = null,
    Object? createdAt = null,
    Object? systemTime = null,
    Object? balanceBefore = null,
    Object? flowAmount = null,
    Object? balanceAfter = null,
    Object? currency = null,
    Object? createdBy = null,
    Object? currentDenominations = null,
  }) {
    return _then(_$ActualFlowImpl(
      flowId: null == flowId
          ? _value.flowId
          : flowId // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as String,
      systemTime: null == systemTime
          ? _value.systemTime
          : systemTime // ignore: cast_nullable_to_non_nullable
              as String,
      balanceBefore: null == balanceBefore
          ? _value.balanceBefore
          : balanceBefore // ignore: cast_nullable_to_non_nullable
              as double,
      flowAmount: null == flowAmount
          ? _value.flowAmount
          : flowAmount // ignore: cast_nullable_to_non_nullable
              as double,
      balanceAfter: null == balanceAfter
          ? _value.balanceAfter
          : balanceAfter // ignore: cast_nullable_to_non_nullable
              as double,
      currency: null == currency
          ? _value.currency
          : currency // ignore: cast_nullable_to_non_nullable
              as CurrencyInfo,
      createdBy: null == createdBy
          ? _value.createdBy
          : createdBy // ignore: cast_nullable_to_non_nullable
              as CreatedBy,
      currentDenominations: null == currentDenominations
          ? _value._currentDenominations
          : currentDenominations // ignore: cast_nullable_to_non_nullable
              as List<DenominationDetail>,
    ));
  }
}

/// @nodoc

class _$ActualFlowImpl implements _ActualFlow {
  const _$ActualFlowImpl(
      {required this.flowId,
      required this.createdAt,
      required this.systemTime,
      required this.balanceBefore,
      required this.flowAmount,
      required this.balanceAfter,
      required this.currency,
      required this.createdBy,
      required final List<DenominationDetail> currentDenominations})
      : _currentDenominations = currentDenominations;

  @override
  final String flowId;
  @override
  final String createdAt;
  @override
  final String systemTime;
  @override
  final double balanceBefore;
  @override
  final double flowAmount;
  @override
  final double balanceAfter;
  @override
  final CurrencyInfo currency;
  @override
  final CreatedBy createdBy;
  final List<DenominationDetail> _currentDenominations;
  @override
  List<DenominationDetail> get currentDenominations {
    if (_currentDenominations is EqualUnmodifiableListView)
      return _currentDenominations;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_currentDenominations);
  }

  @override
  String toString() {
    return 'ActualFlow(flowId: $flowId, createdAt: $createdAt, systemTime: $systemTime, balanceBefore: $balanceBefore, flowAmount: $flowAmount, balanceAfter: $balanceAfter, currency: $currency, createdBy: $createdBy, currentDenominations: $currentDenominations)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ActualFlowImpl &&
            (identical(other.flowId, flowId) || other.flowId == flowId) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.systemTime, systemTime) ||
                other.systemTime == systemTime) &&
            (identical(other.balanceBefore, balanceBefore) ||
                other.balanceBefore == balanceBefore) &&
            (identical(other.flowAmount, flowAmount) ||
                other.flowAmount == flowAmount) &&
            (identical(other.balanceAfter, balanceAfter) ||
                other.balanceAfter == balanceAfter) &&
            (identical(other.currency, currency) ||
                other.currency == currency) &&
            (identical(other.createdBy, createdBy) ||
                other.createdBy == createdBy) &&
            const DeepCollectionEquality()
                .equals(other._currentDenominations, _currentDenominations));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      flowId,
      createdAt,
      systemTime,
      balanceBefore,
      flowAmount,
      balanceAfter,
      currency,
      createdBy,
      const DeepCollectionEquality().hash(_currentDenominations));

  /// Create a copy of ActualFlow
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ActualFlowImplCopyWith<_$ActualFlowImpl> get copyWith =>
      __$$ActualFlowImplCopyWithImpl<_$ActualFlowImpl>(this, _$identity);
}

abstract class _ActualFlow implements ActualFlow {
  const factory _ActualFlow(
          {required final String flowId,
          required final String createdAt,
          required final String systemTime,
          required final double balanceBefore,
          required final double flowAmount,
          required final double balanceAfter,
          required final CurrencyInfo currency,
          required final CreatedBy createdBy,
          required final List<DenominationDetail> currentDenominations}) =
      _$ActualFlowImpl;

  @override
  String get flowId;
  @override
  String get createdAt;
  @override
  String get systemTime;
  @override
  double get balanceBefore;
  @override
  double get flowAmount;
  @override
  double get balanceAfter;
  @override
  CurrencyInfo get currency;
  @override
  CreatedBy get createdBy;
  @override
  List<DenominationDetail> get currentDenominations;

  /// Create a copy of ActualFlow
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ActualFlowImplCopyWith<_$ActualFlowImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$DenominationDetail {
  String get denominationId => throw _privateConstructorUsedError;
  double get denominationValue => throw _privateConstructorUsedError;
  String get denominationType => throw _privateConstructorUsedError;
  int get previousQuantity => throw _privateConstructorUsedError;
  int get currentQuantity => throw _privateConstructorUsedError;
  int get quantityChange => throw _privateConstructorUsedError;
  double get subtotal => throw _privateConstructorUsedError;
  String? get currencySymbol =>
      throw _privateConstructorUsedError; // Bank multi-currency fields
  String? get currencyId => throw _privateConstructorUsedError;
  String? get currencyCode => throw _privateConstructorUsedError;
  String? get currencyName => throw _privateConstructorUsedError;
  double? get amount => throw _privateConstructorUsedError;
  double? get exchangeRate => throw _privateConstructorUsedError;
  double? get amountInBaseCurrency => throw _privateConstructorUsedError;

  /// Create a copy of DenominationDetail
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $DenominationDetailCopyWith<DenominationDetail> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DenominationDetailCopyWith<$Res> {
  factory $DenominationDetailCopyWith(
          DenominationDetail value, $Res Function(DenominationDetail) then) =
      _$DenominationDetailCopyWithImpl<$Res, DenominationDetail>;
  @useResult
  $Res call(
      {String denominationId,
      double denominationValue,
      String denominationType,
      int previousQuantity,
      int currentQuantity,
      int quantityChange,
      double subtotal,
      String? currencySymbol,
      String? currencyId,
      String? currencyCode,
      String? currencyName,
      double? amount,
      double? exchangeRate,
      double? amountInBaseCurrency});
}

/// @nodoc
class _$DenominationDetailCopyWithImpl<$Res, $Val extends DenominationDetail>
    implements $DenominationDetailCopyWith<$Res> {
  _$DenominationDetailCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of DenominationDetail
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? denominationId = null,
    Object? denominationValue = null,
    Object? denominationType = null,
    Object? previousQuantity = null,
    Object? currentQuantity = null,
    Object? quantityChange = null,
    Object? subtotal = null,
    Object? currencySymbol = freezed,
    Object? currencyId = freezed,
    Object? currencyCode = freezed,
    Object? currencyName = freezed,
    Object? amount = freezed,
    Object? exchangeRate = freezed,
    Object? amountInBaseCurrency = freezed,
  }) {
    return _then(_value.copyWith(
      denominationId: null == denominationId
          ? _value.denominationId
          : denominationId // ignore: cast_nullable_to_non_nullable
              as String,
      denominationValue: null == denominationValue
          ? _value.denominationValue
          : denominationValue // ignore: cast_nullable_to_non_nullable
              as double,
      denominationType: null == denominationType
          ? _value.denominationType
          : denominationType // ignore: cast_nullable_to_non_nullable
              as String,
      previousQuantity: null == previousQuantity
          ? _value.previousQuantity
          : previousQuantity // ignore: cast_nullable_to_non_nullable
              as int,
      currentQuantity: null == currentQuantity
          ? _value.currentQuantity
          : currentQuantity // ignore: cast_nullable_to_non_nullable
              as int,
      quantityChange: null == quantityChange
          ? _value.quantityChange
          : quantityChange // ignore: cast_nullable_to_non_nullable
              as int,
      subtotal: null == subtotal
          ? _value.subtotal
          : subtotal // ignore: cast_nullable_to_non_nullable
              as double,
      currencySymbol: freezed == currencySymbol
          ? _value.currencySymbol
          : currencySymbol // ignore: cast_nullable_to_non_nullable
              as String?,
      currencyId: freezed == currencyId
          ? _value.currencyId
          : currencyId // ignore: cast_nullable_to_non_nullable
              as String?,
      currencyCode: freezed == currencyCode
          ? _value.currencyCode
          : currencyCode // ignore: cast_nullable_to_non_nullable
              as String?,
      currencyName: freezed == currencyName
          ? _value.currencyName
          : currencyName // ignore: cast_nullable_to_non_nullable
              as String?,
      amount: freezed == amount
          ? _value.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as double?,
      exchangeRate: freezed == exchangeRate
          ? _value.exchangeRate
          : exchangeRate // ignore: cast_nullable_to_non_nullable
              as double?,
      amountInBaseCurrency: freezed == amountInBaseCurrency
          ? _value.amountInBaseCurrency
          : amountInBaseCurrency // ignore: cast_nullable_to_non_nullable
              as double?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$DenominationDetailImplCopyWith<$Res>
    implements $DenominationDetailCopyWith<$Res> {
  factory _$$DenominationDetailImplCopyWith(_$DenominationDetailImpl value,
          $Res Function(_$DenominationDetailImpl) then) =
      __$$DenominationDetailImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String denominationId,
      double denominationValue,
      String denominationType,
      int previousQuantity,
      int currentQuantity,
      int quantityChange,
      double subtotal,
      String? currencySymbol,
      String? currencyId,
      String? currencyCode,
      String? currencyName,
      double? amount,
      double? exchangeRate,
      double? amountInBaseCurrency});
}

/// @nodoc
class __$$DenominationDetailImplCopyWithImpl<$Res>
    extends _$DenominationDetailCopyWithImpl<$Res, _$DenominationDetailImpl>
    implements _$$DenominationDetailImplCopyWith<$Res> {
  __$$DenominationDetailImplCopyWithImpl(_$DenominationDetailImpl _value,
      $Res Function(_$DenominationDetailImpl) _then)
      : super(_value, _then);

  /// Create a copy of DenominationDetail
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? denominationId = null,
    Object? denominationValue = null,
    Object? denominationType = null,
    Object? previousQuantity = null,
    Object? currentQuantity = null,
    Object? quantityChange = null,
    Object? subtotal = null,
    Object? currencySymbol = freezed,
    Object? currencyId = freezed,
    Object? currencyCode = freezed,
    Object? currencyName = freezed,
    Object? amount = freezed,
    Object? exchangeRate = freezed,
    Object? amountInBaseCurrency = freezed,
  }) {
    return _then(_$DenominationDetailImpl(
      denominationId: null == denominationId
          ? _value.denominationId
          : denominationId // ignore: cast_nullable_to_non_nullable
              as String,
      denominationValue: null == denominationValue
          ? _value.denominationValue
          : denominationValue // ignore: cast_nullable_to_non_nullable
              as double,
      denominationType: null == denominationType
          ? _value.denominationType
          : denominationType // ignore: cast_nullable_to_non_nullable
              as String,
      previousQuantity: null == previousQuantity
          ? _value.previousQuantity
          : previousQuantity // ignore: cast_nullable_to_non_nullable
              as int,
      currentQuantity: null == currentQuantity
          ? _value.currentQuantity
          : currentQuantity // ignore: cast_nullable_to_non_nullable
              as int,
      quantityChange: null == quantityChange
          ? _value.quantityChange
          : quantityChange // ignore: cast_nullable_to_non_nullable
              as int,
      subtotal: null == subtotal
          ? _value.subtotal
          : subtotal // ignore: cast_nullable_to_non_nullable
              as double,
      currencySymbol: freezed == currencySymbol
          ? _value.currencySymbol
          : currencySymbol // ignore: cast_nullable_to_non_nullable
              as String?,
      currencyId: freezed == currencyId
          ? _value.currencyId
          : currencyId // ignore: cast_nullable_to_non_nullable
              as String?,
      currencyCode: freezed == currencyCode
          ? _value.currencyCode
          : currencyCode // ignore: cast_nullable_to_non_nullable
              as String?,
      currencyName: freezed == currencyName
          ? _value.currencyName
          : currencyName // ignore: cast_nullable_to_non_nullable
              as String?,
      amount: freezed == amount
          ? _value.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as double?,
      exchangeRate: freezed == exchangeRate
          ? _value.exchangeRate
          : exchangeRate // ignore: cast_nullable_to_non_nullable
              as double?,
      amountInBaseCurrency: freezed == amountInBaseCurrency
          ? _value.amountInBaseCurrency
          : amountInBaseCurrency // ignore: cast_nullable_to_non_nullable
              as double?,
    ));
  }
}

/// @nodoc

class _$DenominationDetailImpl implements _DenominationDetail {
  const _$DenominationDetailImpl(
      {required this.denominationId,
      required this.denominationValue,
      required this.denominationType,
      required this.previousQuantity,
      required this.currentQuantity,
      required this.quantityChange,
      required this.subtotal,
      this.currencySymbol,
      this.currencyId,
      this.currencyCode,
      this.currencyName,
      this.amount,
      this.exchangeRate,
      this.amountInBaseCurrency});

  @override
  final String denominationId;
  @override
  final double denominationValue;
  @override
  final String denominationType;
  @override
  final int previousQuantity;
  @override
  final int currentQuantity;
  @override
  final int quantityChange;
  @override
  final double subtotal;
  @override
  final String? currencySymbol;
// Bank multi-currency fields
  @override
  final String? currencyId;
  @override
  final String? currencyCode;
  @override
  final String? currencyName;
  @override
  final double? amount;
  @override
  final double? exchangeRate;
  @override
  final double? amountInBaseCurrency;

  @override
  String toString() {
    return 'DenominationDetail(denominationId: $denominationId, denominationValue: $denominationValue, denominationType: $denominationType, previousQuantity: $previousQuantity, currentQuantity: $currentQuantity, quantityChange: $quantityChange, subtotal: $subtotal, currencySymbol: $currencySymbol, currencyId: $currencyId, currencyCode: $currencyCode, currencyName: $currencyName, amount: $amount, exchangeRate: $exchangeRate, amountInBaseCurrency: $amountInBaseCurrency)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DenominationDetailImpl &&
            (identical(other.denominationId, denominationId) ||
                other.denominationId == denominationId) &&
            (identical(other.denominationValue, denominationValue) ||
                other.denominationValue == denominationValue) &&
            (identical(other.denominationType, denominationType) ||
                other.denominationType == denominationType) &&
            (identical(other.previousQuantity, previousQuantity) ||
                other.previousQuantity == previousQuantity) &&
            (identical(other.currentQuantity, currentQuantity) ||
                other.currentQuantity == currentQuantity) &&
            (identical(other.quantityChange, quantityChange) ||
                other.quantityChange == quantityChange) &&
            (identical(other.subtotal, subtotal) ||
                other.subtotal == subtotal) &&
            (identical(other.currencySymbol, currencySymbol) ||
                other.currencySymbol == currencySymbol) &&
            (identical(other.currencyId, currencyId) ||
                other.currencyId == currencyId) &&
            (identical(other.currencyCode, currencyCode) ||
                other.currencyCode == currencyCode) &&
            (identical(other.currencyName, currencyName) ||
                other.currencyName == currencyName) &&
            (identical(other.amount, amount) || other.amount == amount) &&
            (identical(other.exchangeRate, exchangeRate) ||
                other.exchangeRate == exchangeRate) &&
            (identical(other.amountInBaseCurrency, amountInBaseCurrency) ||
                other.amountInBaseCurrency == amountInBaseCurrency));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      denominationId,
      denominationValue,
      denominationType,
      previousQuantity,
      currentQuantity,
      quantityChange,
      subtotal,
      currencySymbol,
      currencyId,
      currencyCode,
      currencyName,
      amount,
      exchangeRate,
      amountInBaseCurrency);

  /// Create a copy of DenominationDetail
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DenominationDetailImplCopyWith<_$DenominationDetailImpl> get copyWith =>
      __$$DenominationDetailImplCopyWithImpl<_$DenominationDetailImpl>(
          this, _$identity);
}

abstract class _DenominationDetail implements DenominationDetail {
  const factory _DenominationDetail(
      {required final String denominationId,
      required final double denominationValue,
      required final String denominationType,
      required final int previousQuantity,
      required final int currentQuantity,
      required final int quantityChange,
      required final double subtotal,
      final String? currencySymbol,
      final String? currencyId,
      final String? currencyCode,
      final String? currencyName,
      final double? amount,
      final double? exchangeRate,
      final double? amountInBaseCurrency}) = _$DenominationDetailImpl;

  @override
  String get denominationId;
  @override
  double get denominationValue;
  @override
  String get denominationType;
  @override
  int get previousQuantity;
  @override
  int get currentQuantity;
  @override
  int get quantityChange;
  @override
  double get subtotal;
  @override
  String? get currencySymbol; // Bank multi-currency fields
  @override
  String? get currencyId;
  @override
  String? get currencyCode;
  @override
  String? get currencyName;
  @override
  double? get amount;
  @override
  double? get exchangeRate;
  @override
  double? get amountInBaseCurrency;

  /// Create a copy of DenominationDetail
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DenominationDetailImplCopyWith<_$DenominationDetailImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
