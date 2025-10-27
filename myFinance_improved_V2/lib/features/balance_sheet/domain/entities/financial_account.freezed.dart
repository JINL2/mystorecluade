// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'financial_account.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$FinancialAccount {
  String get accountId => throw _privateConstructorUsedError;
  String get accountName => throw _privateConstructorUsedError;
  String get accountType => throw _privateConstructorUsedError;
  double get balance => throw _privateConstructorUsedError;
  bool get hasTransactions => throw _privateConstructorUsedError;

  /// Create a copy of FinancialAccount
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $FinancialAccountCopyWith<FinancialAccount> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FinancialAccountCopyWith<$Res> {
  factory $FinancialAccountCopyWith(
          FinancialAccount value, $Res Function(FinancialAccount) then) =
      _$FinancialAccountCopyWithImpl<$Res, FinancialAccount>;
  @useResult
  $Res call(
      {String accountId,
      String accountName,
      String accountType,
      double balance,
      bool hasTransactions});
}

/// @nodoc
class _$FinancialAccountCopyWithImpl<$Res, $Val extends FinancialAccount>
    implements $FinancialAccountCopyWith<$Res> {
  _$FinancialAccountCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of FinancialAccount
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? accountId = null,
    Object? accountName = null,
    Object? accountType = null,
    Object? balance = null,
    Object? hasTransactions = null,
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
      balance: null == balance
          ? _value.balance
          : balance // ignore: cast_nullable_to_non_nullable
              as double,
      hasTransactions: null == hasTransactions
          ? _value.hasTransactions
          : hasTransactions // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$FinancialAccountImplCopyWith<$Res>
    implements $FinancialAccountCopyWith<$Res> {
  factory _$$FinancialAccountImplCopyWith(_$FinancialAccountImpl value,
          $Res Function(_$FinancialAccountImpl) then) =
      __$$FinancialAccountImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String accountId,
      String accountName,
      String accountType,
      double balance,
      bool hasTransactions});
}

/// @nodoc
class __$$FinancialAccountImplCopyWithImpl<$Res>
    extends _$FinancialAccountCopyWithImpl<$Res, _$FinancialAccountImpl>
    implements _$$FinancialAccountImplCopyWith<$Res> {
  __$$FinancialAccountImplCopyWithImpl(_$FinancialAccountImpl _value,
      $Res Function(_$FinancialAccountImpl) _then)
      : super(_value, _then);

  /// Create a copy of FinancialAccount
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? accountId = null,
    Object? accountName = null,
    Object? accountType = null,
    Object? balance = null,
    Object? hasTransactions = null,
  }) {
    return _then(_$FinancialAccountImpl(
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
      balance: null == balance
          ? _value.balance
          : balance // ignore: cast_nullable_to_non_nullable
              as double,
      hasTransactions: null == hasTransactions
          ? _value.hasTransactions
          : hasTransactions // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

class _$FinancialAccountImpl implements _FinancialAccount {
  const _$FinancialAccountImpl(
      {required this.accountId,
      required this.accountName,
      required this.accountType,
      required this.balance,
      this.hasTransactions = false});

  @override
  final String accountId;
  @override
  final String accountName;
  @override
  final String accountType;
  @override
  final double balance;
  @override
  @JsonKey()
  final bool hasTransactions;

  @override
  String toString() {
    return 'FinancialAccount(accountId: $accountId, accountName: $accountName, accountType: $accountType, balance: $balance, hasTransactions: $hasTransactions)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FinancialAccountImpl &&
            (identical(other.accountId, accountId) ||
                other.accountId == accountId) &&
            (identical(other.accountName, accountName) ||
                other.accountName == accountName) &&
            (identical(other.accountType, accountType) ||
                other.accountType == accountType) &&
            (identical(other.balance, balance) || other.balance == balance) &&
            (identical(other.hasTransactions, hasTransactions) ||
                other.hasTransactions == hasTransactions));
  }

  @override
  int get hashCode => Object.hash(runtimeType, accountId, accountName,
      accountType, balance, hasTransactions);

  /// Create a copy of FinancialAccount
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$FinancialAccountImplCopyWith<_$FinancialAccountImpl> get copyWith =>
      __$$FinancialAccountImplCopyWithImpl<_$FinancialAccountImpl>(
          this, _$identity);
}

abstract class _FinancialAccount implements FinancialAccount {
  const factory _FinancialAccount(
      {required final String accountId,
      required final String accountName,
      required final String accountType,
      required final double balance,
      final bool hasTransactions}) = _$FinancialAccountImpl;

  @override
  String get accountId;
  @override
  String get accountName;
  @override
  String get accountType;
  @override
  double get balance;
  @override
  bool get hasTransactions;

  /// Create a copy of FinancialAccount
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$FinancialAccountImplCopyWith<_$FinancialAccountImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$IncomeStatementAccount {
  String get accountId => throw _privateConstructorUsedError;
  String get accountName => throw _privateConstructorUsedError;
  String get accountType => throw _privateConstructorUsedError;
  double get netAmount => throw _privateConstructorUsedError;

  /// Create a copy of IncomeStatementAccount
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $IncomeStatementAccountCopyWith<IncomeStatementAccount> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $IncomeStatementAccountCopyWith<$Res> {
  factory $IncomeStatementAccountCopyWith(IncomeStatementAccount value,
          $Res Function(IncomeStatementAccount) then) =
      _$IncomeStatementAccountCopyWithImpl<$Res, IncomeStatementAccount>;
  @useResult
  $Res call(
      {String accountId,
      String accountName,
      String accountType,
      double netAmount});
}

/// @nodoc
class _$IncomeStatementAccountCopyWithImpl<$Res,
        $Val extends IncomeStatementAccount>
    implements $IncomeStatementAccountCopyWith<$Res> {
  _$IncomeStatementAccountCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of IncomeStatementAccount
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? accountId = null,
    Object? accountName = null,
    Object? accountType = null,
    Object? netAmount = null,
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
      netAmount: null == netAmount
          ? _value.netAmount
          : netAmount // ignore: cast_nullable_to_non_nullable
              as double,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$IncomeStatementAccountImplCopyWith<$Res>
    implements $IncomeStatementAccountCopyWith<$Res> {
  factory _$$IncomeStatementAccountImplCopyWith(
          _$IncomeStatementAccountImpl value,
          $Res Function(_$IncomeStatementAccountImpl) then) =
      __$$IncomeStatementAccountImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String accountId,
      String accountName,
      String accountType,
      double netAmount});
}

/// @nodoc
class __$$IncomeStatementAccountImplCopyWithImpl<$Res>
    extends _$IncomeStatementAccountCopyWithImpl<$Res,
        _$IncomeStatementAccountImpl>
    implements _$$IncomeStatementAccountImplCopyWith<$Res> {
  __$$IncomeStatementAccountImplCopyWithImpl(
      _$IncomeStatementAccountImpl _value,
      $Res Function(_$IncomeStatementAccountImpl) _then)
      : super(_value, _then);

  /// Create a copy of IncomeStatementAccount
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? accountId = null,
    Object? accountName = null,
    Object? accountType = null,
    Object? netAmount = null,
  }) {
    return _then(_$IncomeStatementAccountImpl(
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
      netAmount: null == netAmount
          ? _value.netAmount
          : netAmount // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// @nodoc

class _$IncomeStatementAccountImpl implements _IncomeStatementAccount {
  const _$IncomeStatementAccountImpl(
      {required this.accountId,
      required this.accountName,
      required this.accountType,
      required this.netAmount});

  @override
  final String accountId;
  @override
  final String accountName;
  @override
  final String accountType;
  @override
  final double netAmount;

  @override
  String toString() {
    return 'IncomeStatementAccount(accountId: $accountId, accountName: $accountName, accountType: $accountType, netAmount: $netAmount)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$IncomeStatementAccountImpl &&
            (identical(other.accountId, accountId) ||
                other.accountId == accountId) &&
            (identical(other.accountName, accountName) ||
                other.accountName == accountName) &&
            (identical(other.accountType, accountType) ||
                other.accountType == accountType) &&
            (identical(other.netAmount, netAmount) ||
                other.netAmount == netAmount));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, accountId, accountName, accountType, netAmount);

  /// Create a copy of IncomeStatementAccount
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$IncomeStatementAccountImplCopyWith<_$IncomeStatementAccountImpl>
      get copyWith => __$$IncomeStatementAccountImplCopyWithImpl<
          _$IncomeStatementAccountImpl>(this, _$identity);
}

abstract class _IncomeStatementAccount implements IncomeStatementAccount {
  const factory _IncomeStatementAccount(
      {required final String accountId,
      required final String accountName,
      required final String accountType,
      required final double netAmount}) = _$IncomeStatementAccountImpl;

  @override
  String get accountId;
  @override
  String get accountName;
  @override
  String get accountType;
  @override
  double get netAmount;

  /// Create a copy of IncomeStatementAccount
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$IncomeStatementAccountImplCopyWith<_$IncomeStatementAccountImpl>
      get copyWith => throw _privateConstructorUsedError;
}
