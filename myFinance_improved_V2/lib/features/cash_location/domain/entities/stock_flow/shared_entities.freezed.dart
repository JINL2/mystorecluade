// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'shared_entities.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$LocationSummary {
  String get cashLocationId => throw _privateConstructorUsedError;
  String get locationName => throw _privateConstructorUsedError;
  String get locationType => throw _privateConstructorUsedError;
  String? get bankName => throw _privateConstructorUsedError;
  String? get bankAccount => throw _privateConstructorUsedError;
  String get currencyCode => throw _privateConstructorUsedError;
  String get currencyId => throw _privateConstructorUsedError;
  String? get baseCurrencySymbol => throw _privateConstructorUsedError;

  /// Create a copy of LocationSummary
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $LocationSummaryCopyWith<LocationSummary> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LocationSummaryCopyWith<$Res> {
  factory $LocationSummaryCopyWith(
          LocationSummary value, $Res Function(LocationSummary) then) =
      _$LocationSummaryCopyWithImpl<$Res, LocationSummary>;
  @useResult
  $Res call(
      {String cashLocationId,
      String locationName,
      String locationType,
      String? bankName,
      String? bankAccount,
      String currencyCode,
      String currencyId,
      String? baseCurrencySymbol});
}

/// @nodoc
class _$LocationSummaryCopyWithImpl<$Res, $Val extends LocationSummary>
    implements $LocationSummaryCopyWith<$Res> {
  _$LocationSummaryCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of LocationSummary
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? cashLocationId = null,
    Object? locationName = null,
    Object? locationType = null,
    Object? bankName = freezed,
    Object? bankAccount = freezed,
    Object? currencyCode = null,
    Object? currencyId = null,
    Object? baseCurrencySymbol = freezed,
  }) {
    return _then(_value.copyWith(
      cashLocationId: null == cashLocationId
          ? _value.cashLocationId
          : cashLocationId // ignore: cast_nullable_to_non_nullable
              as String,
      locationName: null == locationName
          ? _value.locationName
          : locationName // ignore: cast_nullable_to_non_nullable
              as String,
      locationType: null == locationType
          ? _value.locationType
          : locationType // ignore: cast_nullable_to_non_nullable
              as String,
      bankName: freezed == bankName
          ? _value.bankName
          : bankName // ignore: cast_nullable_to_non_nullable
              as String?,
      bankAccount: freezed == bankAccount
          ? _value.bankAccount
          : bankAccount // ignore: cast_nullable_to_non_nullable
              as String?,
      currencyCode: null == currencyCode
          ? _value.currencyCode
          : currencyCode // ignore: cast_nullable_to_non_nullable
              as String,
      currencyId: null == currencyId
          ? _value.currencyId
          : currencyId // ignore: cast_nullable_to_non_nullable
              as String,
      baseCurrencySymbol: freezed == baseCurrencySymbol
          ? _value.baseCurrencySymbol
          : baseCurrencySymbol // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$LocationSummaryImplCopyWith<$Res>
    implements $LocationSummaryCopyWith<$Res> {
  factory _$$LocationSummaryImplCopyWith(_$LocationSummaryImpl value,
          $Res Function(_$LocationSummaryImpl) then) =
      __$$LocationSummaryImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String cashLocationId,
      String locationName,
      String locationType,
      String? bankName,
      String? bankAccount,
      String currencyCode,
      String currencyId,
      String? baseCurrencySymbol});
}

/// @nodoc
class __$$LocationSummaryImplCopyWithImpl<$Res>
    extends _$LocationSummaryCopyWithImpl<$Res, _$LocationSummaryImpl>
    implements _$$LocationSummaryImplCopyWith<$Res> {
  __$$LocationSummaryImplCopyWithImpl(
      _$LocationSummaryImpl _value, $Res Function(_$LocationSummaryImpl) _then)
      : super(_value, _then);

  /// Create a copy of LocationSummary
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? cashLocationId = null,
    Object? locationName = null,
    Object? locationType = null,
    Object? bankName = freezed,
    Object? bankAccount = freezed,
    Object? currencyCode = null,
    Object? currencyId = null,
    Object? baseCurrencySymbol = freezed,
  }) {
    return _then(_$LocationSummaryImpl(
      cashLocationId: null == cashLocationId
          ? _value.cashLocationId
          : cashLocationId // ignore: cast_nullable_to_non_nullable
              as String,
      locationName: null == locationName
          ? _value.locationName
          : locationName // ignore: cast_nullable_to_non_nullable
              as String,
      locationType: null == locationType
          ? _value.locationType
          : locationType // ignore: cast_nullable_to_non_nullable
              as String,
      bankName: freezed == bankName
          ? _value.bankName
          : bankName // ignore: cast_nullable_to_non_nullable
              as String?,
      bankAccount: freezed == bankAccount
          ? _value.bankAccount
          : bankAccount // ignore: cast_nullable_to_non_nullable
              as String?,
      currencyCode: null == currencyCode
          ? _value.currencyCode
          : currencyCode // ignore: cast_nullable_to_non_nullable
              as String,
      currencyId: null == currencyId
          ? _value.currencyId
          : currencyId // ignore: cast_nullable_to_non_nullable
              as String,
      baseCurrencySymbol: freezed == baseCurrencySymbol
          ? _value.baseCurrencySymbol
          : baseCurrencySymbol // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$LocationSummaryImpl implements _LocationSummary {
  const _$LocationSummaryImpl(
      {required this.cashLocationId,
      required this.locationName,
      required this.locationType,
      this.bankName,
      this.bankAccount,
      required this.currencyCode,
      required this.currencyId,
      this.baseCurrencySymbol});

  @override
  final String cashLocationId;
  @override
  final String locationName;
  @override
  final String locationType;
  @override
  final String? bankName;
  @override
  final String? bankAccount;
  @override
  final String currencyCode;
  @override
  final String currencyId;
  @override
  final String? baseCurrencySymbol;

  @override
  String toString() {
    return 'LocationSummary(cashLocationId: $cashLocationId, locationName: $locationName, locationType: $locationType, bankName: $bankName, bankAccount: $bankAccount, currencyCode: $currencyCode, currencyId: $currencyId, baseCurrencySymbol: $baseCurrencySymbol)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LocationSummaryImpl &&
            (identical(other.cashLocationId, cashLocationId) ||
                other.cashLocationId == cashLocationId) &&
            (identical(other.locationName, locationName) ||
                other.locationName == locationName) &&
            (identical(other.locationType, locationType) ||
                other.locationType == locationType) &&
            (identical(other.bankName, bankName) ||
                other.bankName == bankName) &&
            (identical(other.bankAccount, bankAccount) ||
                other.bankAccount == bankAccount) &&
            (identical(other.currencyCode, currencyCode) ||
                other.currencyCode == currencyCode) &&
            (identical(other.currencyId, currencyId) ||
                other.currencyId == currencyId) &&
            (identical(other.baseCurrencySymbol, baseCurrencySymbol) ||
                other.baseCurrencySymbol == baseCurrencySymbol));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      cashLocationId,
      locationName,
      locationType,
      bankName,
      bankAccount,
      currencyCode,
      currencyId,
      baseCurrencySymbol);

  /// Create a copy of LocationSummary
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$LocationSummaryImplCopyWith<_$LocationSummaryImpl> get copyWith =>
      __$$LocationSummaryImplCopyWithImpl<_$LocationSummaryImpl>(
          this, _$identity);
}

abstract class _LocationSummary implements LocationSummary {
  const factory _LocationSummary(
      {required final String cashLocationId,
      required final String locationName,
      required final String locationType,
      final String? bankName,
      final String? bankAccount,
      required final String currencyCode,
      required final String currencyId,
      final String? baseCurrencySymbol}) = _$LocationSummaryImpl;

  @override
  String get cashLocationId;
  @override
  String get locationName;
  @override
  String get locationType;
  @override
  String? get bankName;
  @override
  String? get bankAccount;
  @override
  String get currencyCode;
  @override
  String get currencyId;
  @override
  String? get baseCurrencySymbol;

  /// Create a copy of LocationSummary
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$LocationSummaryImplCopyWith<_$LocationSummaryImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$CounterAccount {
  String get accountId => throw _privateConstructorUsedError;
  String get accountName => throw _privateConstructorUsedError;
  String get accountType => throw _privateConstructorUsedError;
  double get debit => throw _privateConstructorUsedError;
  double get credit => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;

  /// Create a copy of CounterAccount
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CounterAccountCopyWith<CounterAccount> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CounterAccountCopyWith<$Res> {
  factory $CounterAccountCopyWith(
          CounterAccount value, $Res Function(CounterAccount) then) =
      _$CounterAccountCopyWithImpl<$Res, CounterAccount>;
  @useResult
  $Res call(
      {String accountId,
      String accountName,
      String accountType,
      double debit,
      double credit,
      String description});
}

/// @nodoc
class _$CounterAccountCopyWithImpl<$Res, $Val extends CounterAccount>
    implements $CounterAccountCopyWith<$Res> {
  _$CounterAccountCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CounterAccount
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? accountId = null,
    Object? accountName = null,
    Object? accountType = null,
    Object? debit = null,
    Object? credit = null,
    Object? description = null,
  }) {
    return _then(_value.copyWith(
      accountId: null == accountId
          ? _value.accountId
          : accountId // ignore: cast_nullable_to_non_nullable
              as String,
      accountName: null == accountName
          ? _value.accountName
          : accountName // ignore: cast_nullable_to_non_nullable
              as String,
      accountType: null == accountType
          ? _value.accountType
          : accountType // ignore: cast_nullable_to_non_nullable
              as String,
      debit: null == debit
          ? _value.debit
          : debit // ignore: cast_nullable_to_non_nullable
              as double,
      credit: null == credit
          ? _value.credit
          : credit // ignore: cast_nullable_to_non_nullable
              as double,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CounterAccountImplCopyWith<$Res>
    implements $CounterAccountCopyWith<$Res> {
  factory _$$CounterAccountImplCopyWith(_$CounterAccountImpl value,
          $Res Function(_$CounterAccountImpl) then) =
      __$$CounterAccountImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String accountId,
      String accountName,
      String accountType,
      double debit,
      double credit,
      String description});
}

/// @nodoc
class __$$CounterAccountImplCopyWithImpl<$Res>
    extends _$CounterAccountCopyWithImpl<$Res, _$CounterAccountImpl>
    implements _$$CounterAccountImplCopyWith<$Res> {
  __$$CounterAccountImplCopyWithImpl(
      _$CounterAccountImpl _value, $Res Function(_$CounterAccountImpl) _then)
      : super(_value, _then);

  /// Create a copy of CounterAccount
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? accountId = null,
    Object? accountName = null,
    Object? accountType = null,
    Object? debit = null,
    Object? credit = null,
    Object? description = null,
  }) {
    return _then(_$CounterAccountImpl(
      accountId: null == accountId
          ? _value.accountId
          : accountId // ignore: cast_nullable_to_non_nullable
              as String,
      accountName: null == accountName
          ? _value.accountName
          : accountName // ignore: cast_nullable_to_non_nullable
              as String,
      accountType: null == accountType
          ? _value.accountType
          : accountType // ignore: cast_nullable_to_non_nullable
              as String,
      debit: null == debit
          ? _value.debit
          : debit // ignore: cast_nullable_to_non_nullable
              as double,
      credit: null == credit
          ? _value.credit
          : credit // ignore: cast_nullable_to_non_nullable
              as double,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$CounterAccountImpl implements _CounterAccount {
  const _$CounterAccountImpl(
      {required this.accountId,
      required this.accountName,
      required this.accountType,
      required this.debit,
      required this.credit,
      required this.description});

  @override
  final String accountId;
  @override
  final String accountName;
  @override
  final String accountType;
  @override
  final double debit;
  @override
  final double credit;
  @override
  final String description;

  @override
  String toString() {
    return 'CounterAccount(accountId: $accountId, accountName: $accountName, accountType: $accountType, debit: $debit, credit: $credit, description: $description)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CounterAccountImpl &&
            (identical(other.accountId, accountId) ||
                other.accountId == accountId) &&
            (identical(other.accountName, accountName) ||
                other.accountName == accountName) &&
            (identical(other.accountType, accountType) ||
                other.accountType == accountType) &&
            (identical(other.debit, debit) || other.debit == debit) &&
            (identical(other.credit, credit) || other.credit == credit) &&
            (identical(other.description, description) ||
                other.description == description));
  }

  @override
  int get hashCode => Object.hash(runtimeType, accountId, accountName,
      accountType, debit, credit, description);

  /// Create a copy of CounterAccount
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CounterAccountImplCopyWith<_$CounterAccountImpl> get copyWith =>
      __$$CounterAccountImplCopyWithImpl<_$CounterAccountImpl>(
          this, _$identity);
}

abstract class _CounterAccount implements CounterAccount {
  const factory _CounterAccount(
      {required final String accountId,
      required final String accountName,
      required final String accountType,
      required final double debit,
      required final double credit,
      required final String description}) = _$CounterAccountImpl;

  @override
  String get accountId;
  @override
  String get accountName;
  @override
  String get accountType;
  @override
  double get debit;
  @override
  double get credit;
  @override
  String get description;

  /// Create a copy of CounterAccount
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CounterAccountImplCopyWith<_$CounterAccountImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$CurrencyInfo {
  String get currencyId => throw _privateConstructorUsedError;
  String get currencyCode => throw _privateConstructorUsedError;
  String get currencyName => throw _privateConstructorUsedError;
  String get symbol => throw _privateConstructorUsedError;

  /// Create a copy of CurrencyInfo
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CurrencyInfoCopyWith<CurrencyInfo> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CurrencyInfoCopyWith<$Res> {
  factory $CurrencyInfoCopyWith(
          CurrencyInfo value, $Res Function(CurrencyInfo) then) =
      _$CurrencyInfoCopyWithImpl<$Res, CurrencyInfo>;
  @useResult
  $Res call(
      {String currencyId,
      String currencyCode,
      String currencyName,
      String symbol});
}

/// @nodoc
class _$CurrencyInfoCopyWithImpl<$Res, $Val extends CurrencyInfo>
    implements $CurrencyInfoCopyWith<$Res> {
  _$CurrencyInfoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CurrencyInfo
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? currencyId = null,
    Object? currencyCode = null,
    Object? currencyName = null,
    Object? symbol = null,
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
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CurrencyInfoImplCopyWith<$Res>
    implements $CurrencyInfoCopyWith<$Res> {
  factory _$$CurrencyInfoImplCopyWith(
          _$CurrencyInfoImpl value, $Res Function(_$CurrencyInfoImpl) then) =
      __$$CurrencyInfoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String currencyId,
      String currencyCode,
      String currencyName,
      String symbol});
}

/// @nodoc
class __$$CurrencyInfoImplCopyWithImpl<$Res>
    extends _$CurrencyInfoCopyWithImpl<$Res, _$CurrencyInfoImpl>
    implements _$$CurrencyInfoImplCopyWith<$Res> {
  __$$CurrencyInfoImplCopyWithImpl(
      _$CurrencyInfoImpl _value, $Res Function(_$CurrencyInfoImpl) _then)
      : super(_value, _then);

  /// Create a copy of CurrencyInfo
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? currencyId = null,
    Object? currencyCode = null,
    Object? currencyName = null,
    Object? symbol = null,
  }) {
    return _then(_$CurrencyInfoImpl(
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
    ));
  }
}

/// @nodoc

class _$CurrencyInfoImpl implements _CurrencyInfo {
  const _$CurrencyInfoImpl(
      {required this.currencyId,
      required this.currencyCode,
      required this.currencyName,
      required this.symbol});

  @override
  final String currencyId;
  @override
  final String currencyCode;
  @override
  final String currencyName;
  @override
  final String symbol;

  @override
  String toString() {
    return 'CurrencyInfo(currencyId: $currencyId, currencyCode: $currencyCode, currencyName: $currencyName, symbol: $symbol)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CurrencyInfoImpl &&
            (identical(other.currencyId, currencyId) ||
                other.currencyId == currencyId) &&
            (identical(other.currencyCode, currencyCode) ||
                other.currencyCode == currencyCode) &&
            (identical(other.currencyName, currencyName) ||
                other.currencyName == currencyName) &&
            (identical(other.symbol, symbol) || other.symbol == symbol));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, currencyId, currencyCode, currencyName, symbol);

  /// Create a copy of CurrencyInfo
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CurrencyInfoImplCopyWith<_$CurrencyInfoImpl> get copyWith =>
      __$$CurrencyInfoImplCopyWithImpl<_$CurrencyInfoImpl>(this, _$identity);
}

abstract class _CurrencyInfo implements CurrencyInfo {
  const factory _CurrencyInfo(
      {required final String currencyId,
      required final String currencyCode,
      required final String currencyName,
      required final String symbol}) = _$CurrencyInfoImpl;

  @override
  String get currencyId;
  @override
  String get currencyCode;
  @override
  String get currencyName;
  @override
  String get symbol;

  /// Create a copy of CurrencyInfo
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CurrencyInfoImplCopyWith<_$CurrencyInfoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$CreatedBy {
  String get userId => throw _privateConstructorUsedError;
  String get fullName => throw _privateConstructorUsedError;
  String? get profileImage => throw _privateConstructorUsedError;

  /// Create a copy of CreatedBy
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CreatedByCopyWith<CreatedBy> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CreatedByCopyWith<$Res> {
  factory $CreatedByCopyWith(CreatedBy value, $Res Function(CreatedBy) then) =
      _$CreatedByCopyWithImpl<$Res, CreatedBy>;
  @useResult
  $Res call({String userId, String fullName, String? profileImage});
}

/// @nodoc
class _$CreatedByCopyWithImpl<$Res, $Val extends CreatedBy>
    implements $CreatedByCopyWith<$Res> {
  _$CreatedByCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CreatedBy
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = null,
    Object? fullName = null,
    Object? profileImage = freezed,
  }) {
    return _then(_value.copyWith(
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      fullName: null == fullName
          ? _value.fullName
          : fullName // ignore: cast_nullable_to_non_nullable
              as String,
      profileImage: freezed == profileImage
          ? _value.profileImage
          : profileImage // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CreatedByImplCopyWith<$Res>
    implements $CreatedByCopyWith<$Res> {
  factory _$$CreatedByImplCopyWith(
          _$CreatedByImpl value, $Res Function(_$CreatedByImpl) then) =
      __$$CreatedByImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String userId, String fullName, String? profileImage});
}

/// @nodoc
class __$$CreatedByImplCopyWithImpl<$Res>
    extends _$CreatedByCopyWithImpl<$Res, _$CreatedByImpl>
    implements _$$CreatedByImplCopyWith<$Res> {
  __$$CreatedByImplCopyWithImpl(
      _$CreatedByImpl _value, $Res Function(_$CreatedByImpl) _then)
      : super(_value, _then);

  /// Create a copy of CreatedBy
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = null,
    Object? fullName = null,
    Object? profileImage = freezed,
  }) {
    return _then(_$CreatedByImpl(
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      fullName: null == fullName
          ? _value.fullName
          : fullName // ignore: cast_nullable_to_non_nullable
              as String,
      profileImage: freezed == profileImage
          ? _value.profileImage
          : profileImage // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$CreatedByImpl implements _CreatedBy {
  const _$CreatedByImpl(
      {required this.userId, required this.fullName, this.profileImage});

  @override
  final String userId;
  @override
  final String fullName;
  @override
  final String? profileImage;

  @override
  String toString() {
    return 'CreatedBy(userId: $userId, fullName: $fullName, profileImage: $profileImage)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CreatedByImpl &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.fullName, fullName) ||
                other.fullName == fullName) &&
            (identical(other.profileImage, profileImage) ||
                other.profileImage == profileImage));
  }

  @override
  int get hashCode => Object.hash(runtimeType, userId, fullName, profileImage);

  /// Create a copy of CreatedBy
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CreatedByImplCopyWith<_$CreatedByImpl> get copyWith =>
      __$$CreatedByImplCopyWithImpl<_$CreatedByImpl>(this, _$identity);
}

abstract class _CreatedBy implements CreatedBy {
  const factory _CreatedBy(
      {required final String userId,
      required final String fullName,
      final String? profileImage}) = _$CreatedByImpl;

  @override
  String get userId;
  @override
  String get fullName;
  @override
  String? get profileImage;

  /// Create a copy of CreatedBy
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CreatedByImplCopyWith<_$CreatedByImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
