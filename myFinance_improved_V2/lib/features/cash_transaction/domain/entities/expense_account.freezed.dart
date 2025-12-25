// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'expense_account.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$ExpenseAccount {
  String get accountId => throw _privateConstructorUsedError;
  String get accountName => throw _privateConstructorUsedError;
  String get accountCode => throw _privateConstructorUsedError;
  String? get expenseNature => throw _privateConstructorUsedError;
  String? get categoryTag => throw _privateConstructorUsedError;
  bool get isDefault => throw _privateConstructorUsedError;
  int get usageCount => throw _privateConstructorUsedError;

  /// Create a copy of ExpenseAccount
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ExpenseAccountCopyWith<ExpenseAccount> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ExpenseAccountCopyWith<$Res> {
  factory $ExpenseAccountCopyWith(
          ExpenseAccount value, $Res Function(ExpenseAccount) then) =
      _$ExpenseAccountCopyWithImpl<$Res, ExpenseAccount>;
  @useResult
  $Res call(
      {String accountId,
      String accountName,
      String accountCode,
      String? expenseNature,
      String? categoryTag,
      bool isDefault,
      int usageCount});
}

/// @nodoc
class _$ExpenseAccountCopyWithImpl<$Res, $Val extends ExpenseAccount>
    implements $ExpenseAccountCopyWith<$Res> {
  _$ExpenseAccountCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ExpenseAccount
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? accountId = null,
    Object? accountName = null,
    Object? accountCode = null,
    Object? expenseNature = freezed,
    Object? categoryTag = freezed,
    Object? isDefault = null,
    Object? usageCount = null,
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
      accountCode: null == accountCode
          ? _value.accountCode
          : accountCode // ignore: cast_nullable_to_non_nullable
              as String,
      expenseNature: freezed == expenseNature
          ? _value.expenseNature
          : expenseNature // ignore: cast_nullable_to_non_nullable
              as String?,
      categoryTag: freezed == categoryTag
          ? _value.categoryTag
          : categoryTag // ignore: cast_nullable_to_non_nullable
              as String?,
      isDefault: null == isDefault
          ? _value.isDefault
          : isDefault // ignore: cast_nullable_to_non_nullable
              as bool,
      usageCount: null == usageCount
          ? _value.usageCount
          : usageCount // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ExpenseAccountImplCopyWith<$Res>
    implements $ExpenseAccountCopyWith<$Res> {
  factory _$$ExpenseAccountImplCopyWith(_$ExpenseAccountImpl value,
          $Res Function(_$ExpenseAccountImpl) then) =
      __$$ExpenseAccountImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String accountId,
      String accountName,
      String accountCode,
      String? expenseNature,
      String? categoryTag,
      bool isDefault,
      int usageCount});
}

/// @nodoc
class __$$ExpenseAccountImplCopyWithImpl<$Res>
    extends _$ExpenseAccountCopyWithImpl<$Res, _$ExpenseAccountImpl>
    implements _$$ExpenseAccountImplCopyWith<$Res> {
  __$$ExpenseAccountImplCopyWithImpl(
      _$ExpenseAccountImpl _value, $Res Function(_$ExpenseAccountImpl) _then)
      : super(_value, _then);

  /// Create a copy of ExpenseAccount
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? accountId = null,
    Object? accountName = null,
    Object? accountCode = null,
    Object? expenseNature = freezed,
    Object? categoryTag = freezed,
    Object? isDefault = null,
    Object? usageCount = null,
  }) {
    return _then(_$ExpenseAccountImpl(
      accountId: null == accountId
          ? _value.accountId
          : accountId // ignore: cast_nullable_to_non_nullable
              as String,
      accountName: null == accountName
          ? _value.accountName
          : accountName // ignore: cast_nullable_to_non_nullable
              as String,
      accountCode: null == accountCode
          ? _value.accountCode
          : accountCode // ignore: cast_nullable_to_non_nullable
              as String,
      expenseNature: freezed == expenseNature
          ? _value.expenseNature
          : expenseNature // ignore: cast_nullable_to_non_nullable
              as String?,
      categoryTag: freezed == categoryTag
          ? _value.categoryTag
          : categoryTag // ignore: cast_nullable_to_non_nullable
              as String?,
      isDefault: null == isDefault
          ? _value.isDefault
          : isDefault // ignore: cast_nullable_to_non_nullable
              as bool,
      usageCount: null == usageCount
          ? _value.usageCount
          : usageCount // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc

class _$ExpenseAccountImpl extends _ExpenseAccount {
  const _$ExpenseAccountImpl(
      {required this.accountId,
      required this.accountName,
      required this.accountCode,
      this.expenseNature,
      this.categoryTag,
      this.isDefault = false,
      this.usageCount = 0})
      : super._();

  @override
  final String accountId;
  @override
  final String accountName;
  @override
  final String accountCode;
  @override
  final String? expenseNature;
  @override
  final String? categoryTag;
  @override
  @JsonKey()
  final bool isDefault;
  @override
  @JsonKey()
  final int usageCount;

  @override
  String toString() {
    return 'ExpenseAccount(accountId: $accountId, accountName: $accountName, accountCode: $accountCode, expenseNature: $expenseNature, categoryTag: $categoryTag, isDefault: $isDefault, usageCount: $usageCount)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ExpenseAccountImpl &&
            (identical(other.accountId, accountId) ||
                other.accountId == accountId) &&
            (identical(other.accountName, accountName) ||
                other.accountName == accountName) &&
            (identical(other.accountCode, accountCode) ||
                other.accountCode == accountCode) &&
            (identical(other.expenseNature, expenseNature) ||
                other.expenseNature == expenseNature) &&
            (identical(other.categoryTag, categoryTag) ||
                other.categoryTag == categoryTag) &&
            (identical(other.isDefault, isDefault) ||
                other.isDefault == isDefault) &&
            (identical(other.usageCount, usageCount) ||
                other.usageCount == usageCount));
  }

  @override
  int get hashCode => Object.hash(runtimeType, accountId, accountName,
      accountCode, expenseNature, categoryTag, isDefault, usageCount);

  /// Create a copy of ExpenseAccount
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ExpenseAccountImplCopyWith<_$ExpenseAccountImpl> get copyWith =>
      __$$ExpenseAccountImplCopyWithImpl<_$ExpenseAccountImpl>(
          this, _$identity);
}

abstract class _ExpenseAccount extends ExpenseAccount {
  const factory _ExpenseAccount(
      {required final String accountId,
      required final String accountName,
      required final String accountCode,
      final String? expenseNature,
      final String? categoryTag,
      final bool isDefault,
      final int usageCount}) = _$ExpenseAccountImpl;
  const _ExpenseAccount._() : super._();

  @override
  String get accountId;
  @override
  String get accountName;
  @override
  String get accountCode;
  @override
  String? get expenseNature;
  @override
  String? get categoryTag;
  @override
  bool get isDefault;
  @override
  int get usageCount;

  /// Create a copy of ExpenseAccount
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ExpenseAccountImplCopyWith<_$ExpenseAccountImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
