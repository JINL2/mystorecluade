// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'bank_real_entry.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$BankRealEntry {
  String get createdAt => throw _privateConstructorUsedError;
  String get recordDate => throw _privateConstructorUsedError;
  String get locationId => throw _privateConstructorUsedError;
  String get locationName => throw _privateConstructorUsedError;
  double get totalAmount => throw _privateConstructorUsedError;
  List<CurrencySummary> get currencySummary =>
      throw _privateConstructorUsedError;

  /// Create a copy of BankRealEntry
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $BankRealEntryCopyWith<BankRealEntry> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BankRealEntryCopyWith<$Res> {
  factory $BankRealEntryCopyWith(
          BankRealEntry value, $Res Function(BankRealEntry) then) =
      _$BankRealEntryCopyWithImpl<$Res, BankRealEntry>;
  @useResult
  $Res call(
      {String createdAt,
      String recordDate,
      String locationId,
      String locationName,
      double totalAmount,
      List<CurrencySummary> currencySummary});
}

/// @nodoc
class _$BankRealEntryCopyWithImpl<$Res, $Val extends BankRealEntry>
    implements $BankRealEntryCopyWith<$Res> {
  _$BankRealEntryCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of BankRealEntry
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? createdAt = null,
    Object? recordDate = null,
    Object? locationId = null,
    Object? locationName = null,
    Object? totalAmount = null,
    Object? currencySummary = null,
  }) {
    return _then(_value.copyWith(
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as String,
      recordDate: null == recordDate
          ? _value.recordDate
          : recordDate // ignore: cast_nullable_to_non_nullable
              as String,
      locationId: null == locationId
          ? _value.locationId
          : locationId // ignore: cast_nullable_to_non_nullable
              as String,
      locationName: null == locationName
          ? _value.locationName
          : locationName // ignore: cast_nullable_to_non_nullable
              as String,
      totalAmount: null == totalAmount
          ? _value.totalAmount
          : totalAmount // ignore: cast_nullable_to_non_nullable
              as double,
      currencySummary: null == currencySummary
          ? _value.currencySummary
          : currencySummary // ignore: cast_nullable_to_non_nullable
              as List<CurrencySummary>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$BankRealEntryImplCopyWith<$Res>
    implements $BankRealEntryCopyWith<$Res> {
  factory _$$BankRealEntryImplCopyWith(
          _$BankRealEntryImpl value, $Res Function(_$BankRealEntryImpl) then) =
      __$$BankRealEntryImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String createdAt,
      String recordDate,
      String locationId,
      String locationName,
      double totalAmount,
      List<CurrencySummary> currencySummary});
}

/// @nodoc
class __$$BankRealEntryImplCopyWithImpl<$Res>
    extends _$BankRealEntryCopyWithImpl<$Res, _$BankRealEntryImpl>
    implements _$$BankRealEntryImplCopyWith<$Res> {
  __$$BankRealEntryImplCopyWithImpl(
      _$BankRealEntryImpl _value, $Res Function(_$BankRealEntryImpl) _then)
      : super(_value, _then);

  /// Create a copy of BankRealEntry
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? createdAt = null,
    Object? recordDate = null,
    Object? locationId = null,
    Object? locationName = null,
    Object? totalAmount = null,
    Object? currencySummary = null,
  }) {
    return _then(_$BankRealEntryImpl(
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as String,
      recordDate: null == recordDate
          ? _value.recordDate
          : recordDate // ignore: cast_nullable_to_non_nullable
              as String,
      locationId: null == locationId
          ? _value.locationId
          : locationId // ignore: cast_nullable_to_non_nullable
              as String,
      locationName: null == locationName
          ? _value.locationName
          : locationName // ignore: cast_nullable_to_non_nullable
              as String,
      totalAmount: null == totalAmount
          ? _value.totalAmount
          : totalAmount // ignore: cast_nullable_to_non_nullable
              as double,
      currencySummary: null == currencySummary
          ? _value._currencySummary
          : currencySummary // ignore: cast_nullable_to_non_nullable
              as List<CurrencySummary>,
    ));
  }
}

/// @nodoc

class _$BankRealEntryImpl extends _BankRealEntry {
  const _$BankRealEntryImpl(
      {required this.createdAt,
      required this.recordDate,
      required this.locationId,
      required this.locationName,
      required this.totalAmount,
      required final List<CurrencySummary> currencySummary})
      : _currencySummary = currencySummary,
        super._();

  @override
  final String createdAt;
  @override
  final String recordDate;
  @override
  final String locationId;
  @override
  final String locationName;
  @override
  final double totalAmount;
  final List<CurrencySummary> _currencySummary;
  @override
  List<CurrencySummary> get currencySummary {
    if (_currencySummary is EqualUnmodifiableListView) return _currencySummary;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_currencySummary);
  }

  @override
  String toString() {
    return 'BankRealEntry(createdAt: $createdAt, recordDate: $recordDate, locationId: $locationId, locationName: $locationName, totalAmount: $totalAmount, currencySummary: $currencySummary)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BankRealEntryImpl &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.recordDate, recordDate) ||
                other.recordDate == recordDate) &&
            (identical(other.locationId, locationId) ||
                other.locationId == locationId) &&
            (identical(other.locationName, locationName) ||
                other.locationName == locationName) &&
            (identical(other.totalAmount, totalAmount) ||
                other.totalAmount == totalAmount) &&
            const DeepCollectionEquality()
                .equals(other._currencySummary, _currencySummary));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      createdAt,
      recordDate,
      locationId,
      locationName,
      totalAmount,
      const DeepCollectionEquality().hash(_currencySummary));

  /// Create a copy of BankRealEntry
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$BankRealEntryImplCopyWith<_$BankRealEntryImpl> get copyWith =>
      __$$BankRealEntryImplCopyWithImpl<_$BankRealEntryImpl>(this, _$identity);
}

abstract class _BankRealEntry extends BankRealEntry {
  const factory _BankRealEntry(
          {required final String createdAt,
          required final String recordDate,
          required final String locationId,
          required final String locationName,
          required final double totalAmount,
          required final List<CurrencySummary> currencySummary}) =
      _$BankRealEntryImpl;
  const _BankRealEntry._() : super._();

  @override
  String get createdAt;
  @override
  String get recordDate;
  @override
  String get locationId;
  @override
  String get locationName;
  @override
  double get totalAmount;
  @override
  List<CurrencySummary> get currencySummary;

  /// Create a copy of BankRealEntry
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BankRealEntryImplCopyWith<_$BankRealEntryImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$CurrencySummary {
  String get currencyId => throw _privateConstructorUsedError;
  String get currencyCode => throw _privateConstructorUsedError;
  String get currencyName => throw _privateConstructorUsedError;
  String get symbol => throw _privateConstructorUsedError;
  double get totalValue => throw _privateConstructorUsedError;
  List<Denomination> get denominations => throw _privateConstructorUsedError;

  /// Create a copy of CurrencySummary
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CurrencySummaryCopyWith<CurrencySummary> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CurrencySummaryCopyWith<$Res> {
  factory $CurrencySummaryCopyWith(
          CurrencySummary value, $Res Function(CurrencySummary) then) =
      _$CurrencySummaryCopyWithImpl<$Res, CurrencySummary>;
  @useResult
  $Res call(
      {String currencyId,
      String currencyCode,
      String currencyName,
      String symbol,
      double totalValue,
      List<Denomination> denominations});
}

/// @nodoc
class _$CurrencySummaryCopyWithImpl<$Res, $Val extends CurrencySummary>
    implements $CurrencySummaryCopyWith<$Res> {
  _$CurrencySummaryCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CurrencySummary
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? currencyId = null,
    Object? currencyCode = null,
    Object? currencyName = null,
    Object? symbol = null,
    Object? totalValue = null,
    Object? denominations = null,
  }) {
    return _then(_value.copyWith(
      currencyId: null == currencyId
          ? _value.currencyId
          : currencyId // ignore: cast_nullable_to_non_nullable
              as String,
      currencyCode: null == currencyCode
          ? _value.currencyCode
          : currencyCode // ignore: cast_nullable_to_non_nullable
              as String,
      currencyName: null == currencyName
          ? _value.currencyName
          : currencyName // ignore: cast_nullable_to_non_nullable
              as String,
      symbol: null == symbol
          ? _value.symbol
          : symbol // ignore: cast_nullable_to_non_nullable
              as String,
      totalValue: null == totalValue
          ? _value.totalValue
          : totalValue // ignore: cast_nullable_to_non_nullable
              as double,
      denominations: null == denominations
          ? _value.denominations
          : denominations // ignore: cast_nullable_to_non_nullable
              as List<Denomination>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CurrencySummaryImplCopyWith<$Res>
    implements $CurrencySummaryCopyWith<$Res> {
  factory _$$CurrencySummaryImplCopyWith(_$CurrencySummaryImpl value,
          $Res Function(_$CurrencySummaryImpl) then) =
      __$$CurrencySummaryImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String currencyId,
      String currencyCode,
      String currencyName,
      String symbol,
      double totalValue,
      List<Denomination> denominations});
}

/// @nodoc
class __$$CurrencySummaryImplCopyWithImpl<$Res>
    extends _$CurrencySummaryCopyWithImpl<$Res, _$CurrencySummaryImpl>
    implements _$$CurrencySummaryImplCopyWith<$Res> {
  __$$CurrencySummaryImplCopyWithImpl(
      _$CurrencySummaryImpl _value, $Res Function(_$CurrencySummaryImpl) _then)
      : super(_value, _then);

  /// Create a copy of CurrencySummary
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? currencyId = null,
    Object? currencyCode = null,
    Object? currencyName = null,
    Object? symbol = null,
    Object? totalValue = null,
    Object? denominations = null,
  }) {
    return _then(_$CurrencySummaryImpl(
      currencyId: null == currencyId
          ? _value.currencyId
          : currencyId // ignore: cast_nullable_to_non_nullable
              as String,
      currencyCode: null == currencyCode
          ? _value.currencyCode
          : currencyCode // ignore: cast_nullable_to_non_nullable
              as String,
      currencyName: null == currencyName
          ? _value.currencyName
          : currencyName // ignore: cast_nullable_to_non_nullable
              as String,
      symbol: null == symbol
          ? _value.symbol
          : symbol // ignore: cast_nullable_to_non_nullable
              as String,
      totalValue: null == totalValue
          ? _value.totalValue
          : totalValue // ignore: cast_nullable_to_non_nullable
              as double,
      denominations: null == denominations
          ? _value._denominations
          : denominations // ignore: cast_nullable_to_non_nullable
              as List<Denomination>,
    ));
  }
}

/// @nodoc

class _$CurrencySummaryImpl implements _CurrencySummary {
  const _$CurrencySummaryImpl(
      {required this.currencyId,
      required this.currencyCode,
      required this.currencyName,
      required this.symbol,
      required this.totalValue,
      required final List<Denomination> denominations})
      : _denominations = denominations;

  @override
  final String currencyId;
  @override
  final String currencyCode;
  @override
  final String currencyName;
  @override
  final String symbol;
  @override
  final double totalValue;
  final List<Denomination> _denominations;
  @override
  List<Denomination> get denominations {
    if (_denominations is EqualUnmodifiableListView) return _denominations;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_denominations);
  }

  @override
  String toString() {
    return 'CurrencySummary(currencyId: $currencyId, currencyCode: $currencyCode, currencyName: $currencyName, symbol: $symbol, totalValue: $totalValue, denominations: $denominations)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CurrencySummaryImpl &&
            (identical(other.currencyId, currencyId) ||
                other.currencyId == currencyId) &&
            (identical(other.currencyCode, currencyCode) ||
                other.currencyCode == currencyCode) &&
            (identical(other.currencyName, currencyName) ||
                other.currencyName == currencyName) &&
            (identical(other.symbol, symbol) || other.symbol == symbol) &&
            (identical(other.totalValue, totalValue) ||
                other.totalValue == totalValue) &&
            const DeepCollectionEquality()
                .equals(other._denominations, _denominations));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      currencyId,
      currencyCode,
      currencyName,
      symbol,
      totalValue,
      const DeepCollectionEquality().hash(_denominations));

  /// Create a copy of CurrencySummary
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CurrencySummaryImplCopyWith<_$CurrencySummaryImpl> get copyWith =>
      __$$CurrencySummaryImplCopyWithImpl<_$CurrencySummaryImpl>(
          this, _$identity);
}

abstract class _CurrencySummary implements CurrencySummary {
  const factory _CurrencySummary(
      {required final String currencyId,
      required final String currencyCode,
      required final String currencyName,
      required final String symbol,
      required final double totalValue,
      required final List<Denomination> denominations}) = _$CurrencySummaryImpl;

  @override
  String get currencyId;
  @override
  String get currencyCode;
  @override
  String get currencyName;
  @override
  String get symbol;
  @override
  double get totalValue;
  @override
  List<Denomination> get denominations;

  /// Create a copy of CurrencySummary
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CurrencySummaryImplCopyWith<_$CurrencySummaryImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$Denomination {
  String get denominationId => throw _privateConstructorUsedError;
  String get denominationType => throw _privateConstructorUsedError;
  double get denominationValue => throw _privateConstructorUsedError;
  int get quantity => throw _privateConstructorUsedError;
  double get subtotal => throw _privateConstructorUsedError;

  /// Create a copy of Denomination
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $DenominationCopyWith<Denomination> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DenominationCopyWith<$Res> {
  factory $DenominationCopyWith(
          Denomination value, $Res Function(Denomination) then) =
      _$DenominationCopyWithImpl<$Res, Denomination>;
  @useResult
  $Res call(
      {String denominationId,
      String denominationType,
      double denominationValue,
      int quantity,
      double subtotal});
}

/// @nodoc
class _$DenominationCopyWithImpl<$Res, $Val extends Denomination>
    implements $DenominationCopyWith<$Res> {
  _$DenominationCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Denomination
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? denominationId = null,
    Object? denominationType = null,
    Object? denominationValue = null,
    Object? quantity = null,
    Object? subtotal = null,
  }) {
    return _then(_value.copyWith(
      denominationId: null == denominationId
          ? _value.denominationId
          : denominationId // ignore: cast_nullable_to_non_nullable
              as String,
      denominationType: null == denominationType
          ? _value.denominationType
          : denominationType // ignore: cast_nullable_to_non_nullable
              as String,
      denominationValue: null == denominationValue
          ? _value.denominationValue
          : denominationValue // ignore: cast_nullable_to_non_nullable
              as double,
      quantity: null == quantity
          ? _value.quantity
          : quantity // ignore: cast_nullable_to_non_nullable
              as int,
      subtotal: null == subtotal
          ? _value.subtotal
          : subtotal // ignore: cast_nullable_to_non_nullable
              as double,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$DenominationImplCopyWith<$Res>
    implements $DenominationCopyWith<$Res> {
  factory _$$DenominationImplCopyWith(
          _$DenominationImpl value, $Res Function(_$DenominationImpl) then) =
      __$$DenominationImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String denominationId,
      String denominationType,
      double denominationValue,
      int quantity,
      double subtotal});
}

/// @nodoc
class __$$DenominationImplCopyWithImpl<$Res>
    extends _$DenominationCopyWithImpl<$Res, _$DenominationImpl>
    implements _$$DenominationImplCopyWith<$Res> {
  __$$DenominationImplCopyWithImpl(
      _$DenominationImpl _value, $Res Function(_$DenominationImpl) _then)
      : super(_value, _then);

  /// Create a copy of Denomination
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? denominationId = null,
    Object? denominationType = null,
    Object? denominationValue = null,
    Object? quantity = null,
    Object? subtotal = null,
  }) {
    return _then(_$DenominationImpl(
      denominationId: null == denominationId
          ? _value.denominationId
          : denominationId // ignore: cast_nullable_to_non_nullable
              as String,
      denominationType: null == denominationType
          ? _value.denominationType
          : denominationType // ignore: cast_nullable_to_non_nullable
              as String,
      denominationValue: null == denominationValue
          ? _value.denominationValue
          : denominationValue // ignore: cast_nullable_to_non_nullable
              as double,
      quantity: null == quantity
          ? _value.quantity
          : quantity // ignore: cast_nullable_to_non_nullable
              as int,
      subtotal: null == subtotal
          ? _value.subtotal
          : subtotal // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// @nodoc

class _$DenominationImpl implements _Denomination {
  const _$DenominationImpl(
      {required this.denominationId,
      required this.denominationType,
      required this.denominationValue,
      required this.quantity,
      required this.subtotal});

  @override
  final String denominationId;
  @override
  final String denominationType;
  @override
  final double denominationValue;
  @override
  final int quantity;
  @override
  final double subtotal;

  @override
  String toString() {
    return 'Denomination(denominationId: $denominationId, denominationType: $denominationType, denominationValue: $denominationValue, quantity: $quantity, subtotal: $subtotal)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DenominationImpl &&
            (identical(other.denominationId, denominationId) ||
                other.denominationId == denominationId) &&
            (identical(other.denominationType, denominationType) ||
                other.denominationType == denominationType) &&
            (identical(other.denominationValue, denominationValue) ||
                other.denominationValue == denominationValue) &&
            (identical(other.quantity, quantity) ||
                other.quantity == quantity) &&
            (identical(other.subtotal, subtotal) ||
                other.subtotal == subtotal));
  }

  @override
  int get hashCode => Object.hash(runtimeType, denominationId, denominationType,
      denominationValue, quantity, subtotal);

  /// Create a copy of Denomination
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DenominationImplCopyWith<_$DenominationImpl> get copyWith =>
      __$$DenominationImplCopyWithImpl<_$DenominationImpl>(this, _$identity);
}

abstract class _Denomination implements Denomination {
  const factory _Denomination(
      {required final String denominationId,
      required final String denominationType,
      required final double denominationValue,
      required final int quantity,
      required final double subtotal}) = _$DenominationImpl;

  @override
  String get denominationId;
  @override
  String get denominationType;
  @override
  double get denominationValue;
  @override
  int get quantity;
  @override
  double get subtotal;

  /// Create a copy of Denomination
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DenominationImplCopyWith<_$DenominationImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
