// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'transaction_line.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$TransactionLine {
  String? get accountId => throw _privateConstructorUsedError;
  String? get accountName => throw _privateConstructorUsedError;
  String? get categoryTag => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  double get amount => throw _privateConstructorUsedError;
  bool get isDebit => throw _privateConstructorUsedError;
  String? get counterpartyId => throw _privateConstructorUsedError;
  String? get counterpartyName => throw _privateConstructorUsedError;
  String? get counterpartyStoreId => throw _privateConstructorUsedError;
  String? get counterpartyStoreName => throw _privateConstructorUsedError;
  String? get cashLocationId => throw _privateConstructorUsedError;
  String? get cashLocationName => throw _privateConstructorUsedError;
  String? get cashLocationType => throw _privateConstructorUsedError;
  String? get linkedCompanyId => throw _privateConstructorUsedError;
  String? get counterpartyCashLocationId =>
      throw _privateConstructorUsedError; // Debt related fields
  String? get debtCategory => throw _privateConstructorUsedError;
  double? get interestRate => throw _privateConstructorUsedError;
  DateTime? get issueDate => throw _privateConstructorUsedError;
  DateTime? get dueDate => throw _privateConstructorUsedError;
  String? get debtDescription =>
      throw _privateConstructorUsedError; // Fixed asset fields
  String? get fixedAssetName => throw _privateConstructorUsedError;
  double? get salvageValue => throw _privateConstructorUsedError;
  DateTime? get acquisitionDate => throw _privateConstructorUsedError;
  int? get usefulLife =>
      throw _privateConstructorUsedError; // Account mapping fields for internal transactions
  Map<String, dynamic>? get accountMapping =>
      throw _privateConstructorUsedError;

  /// Create a copy of TransactionLine
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TransactionLineCopyWith<TransactionLine> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TransactionLineCopyWith<$Res> {
  factory $TransactionLineCopyWith(
          TransactionLine value, $Res Function(TransactionLine) then) =
      _$TransactionLineCopyWithImpl<$Res, TransactionLine>;
  @useResult
  $Res call(
      {String? accountId,
      String? accountName,
      String? categoryTag,
      String? description,
      double amount,
      bool isDebit,
      String? counterpartyId,
      String? counterpartyName,
      String? counterpartyStoreId,
      String? counterpartyStoreName,
      String? cashLocationId,
      String? cashLocationName,
      String? cashLocationType,
      String? linkedCompanyId,
      String? counterpartyCashLocationId,
      String? debtCategory,
      double? interestRate,
      DateTime? issueDate,
      DateTime? dueDate,
      String? debtDescription,
      String? fixedAssetName,
      double? salvageValue,
      DateTime? acquisitionDate,
      int? usefulLife,
      Map<String, dynamic>? accountMapping});
}

/// @nodoc
class _$TransactionLineCopyWithImpl<$Res, $Val extends TransactionLine>
    implements $TransactionLineCopyWith<$Res> {
  _$TransactionLineCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TransactionLine
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? accountId = freezed,
    Object? accountName = freezed,
    Object? categoryTag = freezed,
    Object? description = freezed,
    Object? amount = null,
    Object? isDebit = null,
    Object? counterpartyId = freezed,
    Object? counterpartyName = freezed,
    Object? counterpartyStoreId = freezed,
    Object? counterpartyStoreName = freezed,
    Object? cashLocationId = freezed,
    Object? cashLocationName = freezed,
    Object? cashLocationType = freezed,
    Object? linkedCompanyId = freezed,
    Object? counterpartyCashLocationId = freezed,
    Object? debtCategory = freezed,
    Object? interestRate = freezed,
    Object? issueDate = freezed,
    Object? dueDate = freezed,
    Object? debtDescription = freezed,
    Object? fixedAssetName = freezed,
    Object? salvageValue = freezed,
    Object? acquisitionDate = freezed,
    Object? usefulLife = freezed,
    Object? accountMapping = freezed,
  }) {
    return _then(_value.copyWith(
      accountId: freezed == accountId
          ? _value.accountId
          : accountId // ignore: cast_nullable_to_non_nullable
              as String?,
      accountName: freezed == accountName
          ? _value.accountName
          : accountName // ignore: cast_nullable_to_non_nullable
              as String?,
      categoryTag: freezed == categoryTag
          ? _value.categoryTag
          : categoryTag // ignore: cast_nullable_to_non_nullable
              as String?,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      amount: null == amount
          ? _value.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as double,
      isDebit: null == isDebit
          ? _value.isDebit
          : isDebit // ignore: cast_nullable_to_non_nullable
              as bool,
      counterpartyId: freezed == counterpartyId
          ? _value.counterpartyId
          : counterpartyId // ignore: cast_nullable_to_non_nullable
              as String?,
      counterpartyName: freezed == counterpartyName
          ? _value.counterpartyName
          : counterpartyName // ignore: cast_nullable_to_non_nullable
              as String?,
      counterpartyStoreId: freezed == counterpartyStoreId
          ? _value.counterpartyStoreId
          : counterpartyStoreId // ignore: cast_nullable_to_non_nullable
              as String?,
      counterpartyStoreName: freezed == counterpartyStoreName
          ? _value.counterpartyStoreName
          : counterpartyStoreName // ignore: cast_nullable_to_non_nullable
              as String?,
      cashLocationId: freezed == cashLocationId
          ? _value.cashLocationId
          : cashLocationId // ignore: cast_nullable_to_non_nullable
              as String?,
      cashLocationName: freezed == cashLocationName
          ? _value.cashLocationName
          : cashLocationName // ignore: cast_nullable_to_non_nullable
              as String?,
      cashLocationType: freezed == cashLocationType
          ? _value.cashLocationType
          : cashLocationType // ignore: cast_nullable_to_non_nullable
              as String?,
      linkedCompanyId: freezed == linkedCompanyId
          ? _value.linkedCompanyId
          : linkedCompanyId // ignore: cast_nullable_to_non_nullable
              as String?,
      counterpartyCashLocationId: freezed == counterpartyCashLocationId
          ? _value.counterpartyCashLocationId
          : counterpartyCashLocationId // ignore: cast_nullable_to_non_nullable
              as String?,
      debtCategory: freezed == debtCategory
          ? _value.debtCategory
          : debtCategory // ignore: cast_nullable_to_non_nullable
              as String?,
      interestRate: freezed == interestRate
          ? _value.interestRate
          : interestRate // ignore: cast_nullable_to_non_nullable
              as double?,
      issueDate: freezed == issueDate
          ? _value.issueDate
          : issueDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      dueDate: freezed == dueDate
          ? _value.dueDate
          : dueDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      debtDescription: freezed == debtDescription
          ? _value.debtDescription
          : debtDescription // ignore: cast_nullable_to_non_nullable
              as String?,
      fixedAssetName: freezed == fixedAssetName
          ? _value.fixedAssetName
          : fixedAssetName // ignore: cast_nullable_to_non_nullable
              as String?,
      salvageValue: freezed == salvageValue
          ? _value.salvageValue
          : salvageValue // ignore: cast_nullable_to_non_nullable
              as double?,
      acquisitionDate: freezed == acquisitionDate
          ? _value.acquisitionDate
          : acquisitionDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      usefulLife: freezed == usefulLife
          ? _value.usefulLife
          : usefulLife // ignore: cast_nullable_to_non_nullable
              as int?,
      accountMapping: freezed == accountMapping
          ? _value.accountMapping
          : accountMapping // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$TransactionLineImplCopyWith<$Res>
    implements $TransactionLineCopyWith<$Res> {
  factory _$$TransactionLineImplCopyWith(_$TransactionLineImpl value,
          $Res Function(_$TransactionLineImpl) then) =
      __$$TransactionLineImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String? accountId,
      String? accountName,
      String? categoryTag,
      String? description,
      double amount,
      bool isDebit,
      String? counterpartyId,
      String? counterpartyName,
      String? counterpartyStoreId,
      String? counterpartyStoreName,
      String? cashLocationId,
      String? cashLocationName,
      String? cashLocationType,
      String? linkedCompanyId,
      String? counterpartyCashLocationId,
      String? debtCategory,
      double? interestRate,
      DateTime? issueDate,
      DateTime? dueDate,
      String? debtDescription,
      String? fixedAssetName,
      double? salvageValue,
      DateTime? acquisitionDate,
      int? usefulLife,
      Map<String, dynamic>? accountMapping});
}

/// @nodoc
class __$$TransactionLineImplCopyWithImpl<$Res>
    extends _$TransactionLineCopyWithImpl<$Res, _$TransactionLineImpl>
    implements _$$TransactionLineImplCopyWith<$Res> {
  __$$TransactionLineImplCopyWithImpl(
      _$TransactionLineImpl _value, $Res Function(_$TransactionLineImpl) _then)
      : super(_value, _then);

  /// Create a copy of TransactionLine
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? accountId = freezed,
    Object? accountName = freezed,
    Object? categoryTag = freezed,
    Object? description = freezed,
    Object? amount = null,
    Object? isDebit = null,
    Object? counterpartyId = freezed,
    Object? counterpartyName = freezed,
    Object? counterpartyStoreId = freezed,
    Object? counterpartyStoreName = freezed,
    Object? cashLocationId = freezed,
    Object? cashLocationName = freezed,
    Object? cashLocationType = freezed,
    Object? linkedCompanyId = freezed,
    Object? counterpartyCashLocationId = freezed,
    Object? debtCategory = freezed,
    Object? interestRate = freezed,
    Object? issueDate = freezed,
    Object? dueDate = freezed,
    Object? debtDescription = freezed,
    Object? fixedAssetName = freezed,
    Object? salvageValue = freezed,
    Object? acquisitionDate = freezed,
    Object? usefulLife = freezed,
    Object? accountMapping = freezed,
  }) {
    return _then(_$TransactionLineImpl(
      accountId: freezed == accountId
          ? _value.accountId
          : accountId // ignore: cast_nullable_to_non_nullable
              as String?,
      accountName: freezed == accountName
          ? _value.accountName
          : accountName // ignore: cast_nullable_to_non_nullable
              as String?,
      categoryTag: freezed == categoryTag
          ? _value.categoryTag
          : categoryTag // ignore: cast_nullable_to_non_nullable
              as String?,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      amount: null == amount
          ? _value.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as double,
      isDebit: null == isDebit
          ? _value.isDebit
          : isDebit // ignore: cast_nullable_to_non_nullable
              as bool,
      counterpartyId: freezed == counterpartyId
          ? _value.counterpartyId
          : counterpartyId // ignore: cast_nullable_to_non_nullable
              as String?,
      counterpartyName: freezed == counterpartyName
          ? _value.counterpartyName
          : counterpartyName // ignore: cast_nullable_to_non_nullable
              as String?,
      counterpartyStoreId: freezed == counterpartyStoreId
          ? _value.counterpartyStoreId
          : counterpartyStoreId // ignore: cast_nullable_to_non_nullable
              as String?,
      counterpartyStoreName: freezed == counterpartyStoreName
          ? _value.counterpartyStoreName
          : counterpartyStoreName // ignore: cast_nullable_to_non_nullable
              as String?,
      cashLocationId: freezed == cashLocationId
          ? _value.cashLocationId
          : cashLocationId // ignore: cast_nullable_to_non_nullable
              as String?,
      cashLocationName: freezed == cashLocationName
          ? _value.cashLocationName
          : cashLocationName // ignore: cast_nullable_to_non_nullable
              as String?,
      cashLocationType: freezed == cashLocationType
          ? _value.cashLocationType
          : cashLocationType // ignore: cast_nullable_to_non_nullable
              as String?,
      linkedCompanyId: freezed == linkedCompanyId
          ? _value.linkedCompanyId
          : linkedCompanyId // ignore: cast_nullable_to_non_nullable
              as String?,
      counterpartyCashLocationId: freezed == counterpartyCashLocationId
          ? _value.counterpartyCashLocationId
          : counterpartyCashLocationId // ignore: cast_nullable_to_non_nullable
              as String?,
      debtCategory: freezed == debtCategory
          ? _value.debtCategory
          : debtCategory // ignore: cast_nullable_to_non_nullable
              as String?,
      interestRate: freezed == interestRate
          ? _value.interestRate
          : interestRate // ignore: cast_nullable_to_non_nullable
              as double?,
      issueDate: freezed == issueDate
          ? _value.issueDate
          : issueDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      dueDate: freezed == dueDate
          ? _value.dueDate
          : dueDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      debtDescription: freezed == debtDescription
          ? _value.debtDescription
          : debtDescription // ignore: cast_nullable_to_non_nullable
              as String?,
      fixedAssetName: freezed == fixedAssetName
          ? _value.fixedAssetName
          : fixedAssetName // ignore: cast_nullable_to_non_nullable
              as String?,
      salvageValue: freezed == salvageValue
          ? _value.salvageValue
          : salvageValue // ignore: cast_nullable_to_non_nullable
              as double?,
      acquisitionDate: freezed == acquisitionDate
          ? _value.acquisitionDate
          : acquisitionDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      usefulLife: freezed == usefulLife
          ? _value.usefulLife
          : usefulLife // ignore: cast_nullable_to_non_nullable
              as int?,
      accountMapping: freezed == accountMapping
          ? _value._accountMapping
          : accountMapping // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
    ));
  }
}

/// @nodoc

class _$TransactionLineImpl implements _TransactionLine {
  const _$TransactionLineImpl(
      {this.accountId,
      this.accountName,
      this.categoryTag,
      this.description,
      this.amount = 0.0,
      this.isDebit = true,
      this.counterpartyId,
      this.counterpartyName,
      this.counterpartyStoreId,
      this.counterpartyStoreName,
      this.cashLocationId,
      this.cashLocationName,
      this.cashLocationType,
      this.linkedCompanyId,
      this.counterpartyCashLocationId,
      this.debtCategory,
      this.interestRate,
      this.issueDate,
      this.dueDate,
      this.debtDescription,
      this.fixedAssetName,
      this.salvageValue,
      this.acquisitionDate,
      this.usefulLife,
      final Map<String, dynamic>? accountMapping})
      : _accountMapping = accountMapping;

  @override
  final String? accountId;
  @override
  final String? accountName;
  @override
  final String? categoryTag;
  @override
  final String? description;
  @override
  @JsonKey()
  final double amount;
  @override
  @JsonKey()
  final bool isDebit;
  @override
  final String? counterpartyId;
  @override
  final String? counterpartyName;
  @override
  final String? counterpartyStoreId;
  @override
  final String? counterpartyStoreName;
  @override
  final String? cashLocationId;
  @override
  final String? cashLocationName;
  @override
  final String? cashLocationType;
  @override
  final String? linkedCompanyId;
  @override
  final String? counterpartyCashLocationId;
// Debt related fields
  @override
  final String? debtCategory;
  @override
  final double? interestRate;
  @override
  final DateTime? issueDate;
  @override
  final DateTime? dueDate;
  @override
  final String? debtDescription;
// Fixed asset fields
  @override
  final String? fixedAssetName;
  @override
  final double? salvageValue;
  @override
  final DateTime? acquisitionDate;
  @override
  final int? usefulLife;
// Account mapping fields for internal transactions
  final Map<String, dynamic>? _accountMapping;
// Account mapping fields for internal transactions
  @override
  Map<String, dynamic>? get accountMapping {
    final value = _accountMapping;
    if (value == null) return null;
    if (_accountMapping is EqualUnmodifiableMapView) return _accountMapping;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  String toString() {
    return 'TransactionLine(accountId: $accountId, accountName: $accountName, categoryTag: $categoryTag, description: $description, amount: $amount, isDebit: $isDebit, counterpartyId: $counterpartyId, counterpartyName: $counterpartyName, counterpartyStoreId: $counterpartyStoreId, counterpartyStoreName: $counterpartyStoreName, cashLocationId: $cashLocationId, cashLocationName: $cashLocationName, cashLocationType: $cashLocationType, linkedCompanyId: $linkedCompanyId, counterpartyCashLocationId: $counterpartyCashLocationId, debtCategory: $debtCategory, interestRate: $interestRate, issueDate: $issueDate, dueDate: $dueDate, debtDescription: $debtDescription, fixedAssetName: $fixedAssetName, salvageValue: $salvageValue, acquisitionDate: $acquisitionDate, usefulLife: $usefulLife, accountMapping: $accountMapping)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TransactionLineImpl &&
            (identical(other.accountId, accountId) ||
                other.accountId == accountId) &&
            (identical(other.accountName, accountName) ||
                other.accountName == accountName) &&
            (identical(other.categoryTag, categoryTag) ||
                other.categoryTag == categoryTag) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.amount, amount) || other.amount == amount) &&
            (identical(other.isDebit, isDebit) || other.isDebit == isDebit) &&
            (identical(other.counterpartyId, counterpartyId) ||
                other.counterpartyId == counterpartyId) &&
            (identical(other.counterpartyName, counterpartyName) ||
                other.counterpartyName == counterpartyName) &&
            (identical(other.counterpartyStoreId, counterpartyStoreId) ||
                other.counterpartyStoreId == counterpartyStoreId) &&
            (identical(other.counterpartyStoreName, counterpartyStoreName) ||
                other.counterpartyStoreName == counterpartyStoreName) &&
            (identical(other.cashLocationId, cashLocationId) ||
                other.cashLocationId == cashLocationId) &&
            (identical(other.cashLocationName, cashLocationName) ||
                other.cashLocationName == cashLocationName) &&
            (identical(other.cashLocationType, cashLocationType) ||
                other.cashLocationType == cashLocationType) &&
            (identical(other.linkedCompanyId, linkedCompanyId) ||
                other.linkedCompanyId == linkedCompanyId) &&
            (identical(other.counterpartyCashLocationId,
                    counterpartyCashLocationId) ||
                other.counterpartyCashLocationId ==
                    counterpartyCashLocationId) &&
            (identical(other.debtCategory, debtCategory) ||
                other.debtCategory == debtCategory) &&
            (identical(other.interestRate, interestRate) ||
                other.interestRate == interestRate) &&
            (identical(other.issueDate, issueDate) ||
                other.issueDate == issueDate) &&
            (identical(other.dueDate, dueDate) || other.dueDate == dueDate) &&
            (identical(other.debtDescription, debtDescription) ||
                other.debtDescription == debtDescription) &&
            (identical(other.fixedAssetName, fixedAssetName) ||
                other.fixedAssetName == fixedAssetName) &&
            (identical(other.salvageValue, salvageValue) ||
                other.salvageValue == salvageValue) &&
            (identical(other.acquisitionDate, acquisitionDate) ||
                other.acquisitionDate == acquisitionDate) &&
            (identical(other.usefulLife, usefulLife) ||
                other.usefulLife == usefulLife) &&
            const DeepCollectionEquality()
                .equals(other._accountMapping, _accountMapping));
  }

  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        accountId,
        accountName,
        categoryTag,
        description,
        amount,
        isDebit,
        counterpartyId,
        counterpartyName,
        counterpartyStoreId,
        counterpartyStoreName,
        cashLocationId,
        cashLocationName,
        cashLocationType,
        linkedCompanyId,
        counterpartyCashLocationId,
        debtCategory,
        interestRate,
        issueDate,
        dueDate,
        debtDescription,
        fixedAssetName,
        salvageValue,
        acquisitionDate,
        usefulLife,
        const DeepCollectionEquality().hash(_accountMapping)
      ]);

  /// Create a copy of TransactionLine
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TransactionLineImplCopyWith<_$TransactionLineImpl> get copyWith =>
      __$$TransactionLineImplCopyWithImpl<_$TransactionLineImpl>(
          this, _$identity);
}

abstract class _TransactionLine implements TransactionLine {
  const factory _TransactionLine(
      {final String? accountId,
      final String? accountName,
      final String? categoryTag,
      final String? description,
      final double amount,
      final bool isDebit,
      final String? counterpartyId,
      final String? counterpartyName,
      final String? counterpartyStoreId,
      final String? counterpartyStoreName,
      final String? cashLocationId,
      final String? cashLocationName,
      final String? cashLocationType,
      final String? linkedCompanyId,
      final String? counterpartyCashLocationId,
      final String? debtCategory,
      final double? interestRate,
      final DateTime? issueDate,
      final DateTime? dueDate,
      final String? debtDescription,
      final String? fixedAssetName,
      final double? salvageValue,
      final DateTime? acquisitionDate,
      final int? usefulLife,
      final Map<String, dynamic>? accountMapping}) = _$TransactionLineImpl;

  @override
  String? get accountId;
  @override
  String? get accountName;
  @override
  String? get categoryTag;
  @override
  String? get description;
  @override
  double get amount;
  @override
  bool get isDebit;
  @override
  String? get counterpartyId;
  @override
  String? get counterpartyName;
  @override
  String? get counterpartyStoreId;
  @override
  String? get counterpartyStoreName;
  @override
  String? get cashLocationId;
  @override
  String? get cashLocationName;
  @override
  String? get cashLocationType;
  @override
  String? get linkedCompanyId;
  @override
  String? get counterpartyCashLocationId; // Debt related fields
  @override
  String? get debtCategory;
  @override
  double? get interestRate;
  @override
  DateTime? get issueDate;
  @override
  DateTime? get dueDate;
  @override
  String? get debtDescription; // Fixed asset fields
  @override
  String? get fixedAssetName;
  @override
  double? get salvageValue;
  @override
  DateTime? get acquisitionDate;
  @override
  int? get usefulLife; // Account mapping fields for internal transactions
  @override
  Map<String, dynamic>? get accountMapping;

  /// Create a copy of TransactionLine
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TransactionLineImplCopyWith<_$TransactionLineImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
