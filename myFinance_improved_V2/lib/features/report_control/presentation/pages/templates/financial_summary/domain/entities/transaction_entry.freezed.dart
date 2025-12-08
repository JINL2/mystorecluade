// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'transaction_entry.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

TransactionEntry _$TransactionEntryFromJson(Map<String, dynamic> json) {
  return _TransactionEntry.fromJson(json);
}

/// @nodoc
mixin _$TransactionEntry {
  double get amount => throw _privateConstructorUsedError;
  String get formattedAmount => throw _privateConstructorUsedError;
  String get debitAccount => throw _privateConstructorUsedError; // 차변 계정
  String get creditAccount => throw _privateConstructorUsedError; // 대변 계정
  String get employeeName => throw _privateConstructorUsedError;
  String get storeName => throw _privateConstructorUsedError;
  DateTime get entryDate => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;

  /// Serializes this TransactionEntry to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of TransactionEntry
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TransactionEntryCopyWith<TransactionEntry> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TransactionEntryCopyWith<$Res> {
  factory $TransactionEntryCopyWith(
          TransactionEntry value, $Res Function(TransactionEntry) then) =
      _$TransactionEntryCopyWithImpl<$Res, TransactionEntry>;
  @useResult
  $Res call(
      {double amount,
      String formattedAmount,
      String debitAccount,
      String creditAccount,
      String employeeName,
      String storeName,
      DateTime entryDate,
      String? description});
}

/// @nodoc
class _$TransactionEntryCopyWithImpl<$Res, $Val extends TransactionEntry>
    implements $TransactionEntryCopyWith<$Res> {
  _$TransactionEntryCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TransactionEntry
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? amount = null,
    Object? formattedAmount = null,
    Object? debitAccount = null,
    Object? creditAccount = null,
    Object? employeeName = null,
    Object? storeName = null,
    Object? entryDate = null,
    Object? description = freezed,
  }) {
    return _then(_value.copyWith(
      amount: null == amount
          ? _value.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as double,
      formattedAmount: null == formattedAmount
          ? _value.formattedAmount
          : formattedAmount // ignore: cast_nullable_to_non_nullable
              as String,
      debitAccount: null == debitAccount
          ? _value.debitAccount
          : debitAccount // ignore: cast_nullable_to_non_nullable
              as String,
      creditAccount: null == creditAccount
          ? _value.creditAccount
          : creditAccount // ignore: cast_nullable_to_non_nullable
              as String,
      employeeName: null == employeeName
          ? _value.employeeName
          : employeeName // ignore: cast_nullable_to_non_nullable
              as String,
      storeName: null == storeName
          ? _value.storeName
          : storeName // ignore: cast_nullable_to_non_nullable
              as String,
      entryDate: null == entryDate
          ? _value.entryDate
          : entryDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$TransactionEntryImplCopyWith<$Res>
    implements $TransactionEntryCopyWith<$Res> {
  factory _$$TransactionEntryImplCopyWith(_$TransactionEntryImpl value,
          $Res Function(_$TransactionEntryImpl) then) =
      __$$TransactionEntryImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {double amount,
      String formattedAmount,
      String debitAccount,
      String creditAccount,
      String employeeName,
      String storeName,
      DateTime entryDate,
      String? description});
}

/// @nodoc
class __$$TransactionEntryImplCopyWithImpl<$Res>
    extends _$TransactionEntryCopyWithImpl<$Res, _$TransactionEntryImpl>
    implements _$$TransactionEntryImplCopyWith<$Res> {
  __$$TransactionEntryImplCopyWithImpl(_$TransactionEntryImpl _value,
      $Res Function(_$TransactionEntryImpl) _then)
      : super(_value, _then);

  /// Create a copy of TransactionEntry
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? amount = null,
    Object? formattedAmount = null,
    Object? debitAccount = null,
    Object? creditAccount = null,
    Object? employeeName = null,
    Object? storeName = null,
    Object? entryDate = null,
    Object? description = freezed,
  }) {
    return _then(_$TransactionEntryImpl(
      amount: null == amount
          ? _value.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as double,
      formattedAmount: null == formattedAmount
          ? _value.formattedAmount
          : formattedAmount // ignore: cast_nullable_to_non_nullable
              as String,
      debitAccount: null == debitAccount
          ? _value.debitAccount
          : debitAccount // ignore: cast_nullable_to_non_nullable
              as String,
      creditAccount: null == creditAccount
          ? _value.creditAccount
          : creditAccount // ignore: cast_nullable_to_non_nullable
              as String,
      employeeName: null == employeeName
          ? _value.employeeName
          : employeeName // ignore: cast_nullable_to_non_nullable
              as String,
      storeName: null == storeName
          ? _value.storeName
          : storeName // ignore: cast_nullable_to_non_nullable
              as String,
      entryDate: null == entryDate
          ? _value.entryDate
          : entryDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$TransactionEntryImpl extends _TransactionEntry {
  const _$TransactionEntryImpl(
      {required this.amount,
      required this.formattedAmount,
      required this.debitAccount,
      required this.creditAccount,
      required this.employeeName,
      required this.storeName,
      required this.entryDate,
      this.description})
      : super._();

  factory _$TransactionEntryImpl.fromJson(Map<String, dynamic> json) =>
      _$$TransactionEntryImplFromJson(json);

  @override
  final double amount;
  @override
  final String formattedAmount;
  @override
  final String debitAccount;
// 차변 계정
  @override
  final String creditAccount;
// 대변 계정
  @override
  final String employeeName;
  @override
  final String storeName;
  @override
  final DateTime entryDate;
  @override
  final String? description;

  @override
  String toString() {
    return 'TransactionEntry(amount: $amount, formattedAmount: $formattedAmount, debitAccount: $debitAccount, creditAccount: $creditAccount, employeeName: $employeeName, storeName: $storeName, entryDate: $entryDate, description: $description)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TransactionEntryImpl &&
            (identical(other.amount, amount) || other.amount == amount) &&
            (identical(other.formattedAmount, formattedAmount) ||
                other.formattedAmount == formattedAmount) &&
            (identical(other.debitAccount, debitAccount) ||
                other.debitAccount == debitAccount) &&
            (identical(other.creditAccount, creditAccount) ||
                other.creditAccount == creditAccount) &&
            (identical(other.employeeName, employeeName) ||
                other.employeeName == employeeName) &&
            (identical(other.storeName, storeName) ||
                other.storeName == storeName) &&
            (identical(other.entryDate, entryDate) ||
                other.entryDate == entryDate) &&
            (identical(other.description, description) ||
                other.description == description));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      amount,
      formattedAmount,
      debitAccount,
      creditAccount,
      employeeName,
      storeName,
      entryDate,
      description);

  /// Create a copy of TransactionEntry
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TransactionEntryImplCopyWith<_$TransactionEntryImpl> get copyWith =>
      __$$TransactionEntryImplCopyWithImpl<_$TransactionEntryImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TransactionEntryImplToJson(
      this,
    );
  }
}

abstract class _TransactionEntry extends TransactionEntry {
  const factory _TransactionEntry(
      {required final double amount,
      required final String formattedAmount,
      required final String debitAccount,
      required final String creditAccount,
      required final String employeeName,
      required final String storeName,
      required final DateTime entryDate,
      final String? description}) = _$TransactionEntryImpl;
  const _TransactionEntry._() : super._();

  factory _TransactionEntry.fromJson(Map<String, dynamic> json) =
      _$TransactionEntryImpl.fromJson;

  @override
  double get amount;
  @override
  String get formattedAmount;
  @override
  String get debitAccount; // 차변 계정
  @override
  String get creditAccount; // 대변 계정
  @override
  String get employeeName;
  @override
  String get storeName;
  @override
  DateTime get entryDate;
  @override
  String? get description;

  /// Create a copy of TransactionEntry
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TransactionEntryImplCopyWith<_$TransactionEntryImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
