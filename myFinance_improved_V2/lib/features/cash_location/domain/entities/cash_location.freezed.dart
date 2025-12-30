// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'cash_location.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$CashLocation {
  String get locationId => throw _privateConstructorUsedError;
  String get locationName => throw _privateConstructorUsedError;
  String get locationType => throw _privateConstructorUsedError;
  double get totalJournalCashAmount => throw _privateConstructorUsedError;
  double get totalRealCashAmount => throw _privateConstructorUsedError;
  double get cashDifference => throw _privateConstructorUsedError;
  String get companyId => throw _privateConstructorUsedError;
  String? get storeId => throw _privateConstructorUsedError;
  String get currencySymbol => throw _privateConstructorUsedError;
  String? get currencyCode => throw _privateConstructorUsedError;
  bool get isDeleted =>
      throw _privateConstructorUsedError; // Bank-specific fields
  String? get bankName => throw _privateConstructorUsedError;
  String? get bankAccount => throw _privateConstructorUsedError;
  String? get beneficiaryName => throw _privateConstructorUsedError;
  String? get bankAddress => throw _privateConstructorUsedError;
  String? get swiftCode => throw _privateConstructorUsedError;
  String? get bankBranch => throw _privateConstructorUsedError;
  String? get accountType => throw _privateConstructorUsedError;

  /// Create a copy of CashLocation
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CashLocationCopyWith<CashLocation> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CashLocationCopyWith<$Res> {
  factory $CashLocationCopyWith(
          CashLocation value, $Res Function(CashLocation) then) =
      _$CashLocationCopyWithImpl<$Res, CashLocation>;
  @useResult
  $Res call(
      {String locationId,
      String locationName,
      String locationType,
      double totalJournalCashAmount,
      double totalRealCashAmount,
      double cashDifference,
      String companyId,
      String? storeId,
      String currencySymbol,
      String? currencyCode,
      bool isDeleted,
      String? bankName,
      String? bankAccount,
      String? beneficiaryName,
      String? bankAddress,
      String? swiftCode,
      String? bankBranch,
      String? accountType});
}

/// @nodoc
class _$CashLocationCopyWithImpl<$Res, $Val extends CashLocation>
    implements $CashLocationCopyWith<$Res> {
  _$CashLocationCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CashLocation
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? locationId = null,
    Object? locationName = null,
    Object? locationType = null,
    Object? totalJournalCashAmount = null,
    Object? totalRealCashAmount = null,
    Object? cashDifference = null,
    Object? companyId = null,
    Object? storeId = freezed,
    Object? currencySymbol = null,
    Object? currencyCode = freezed,
    Object? isDeleted = null,
    Object? bankName = freezed,
    Object? bankAccount = freezed,
    Object? beneficiaryName = freezed,
    Object? bankAddress = freezed,
    Object? swiftCode = freezed,
    Object? bankBranch = freezed,
    Object? accountType = freezed,
  }) {
    return _then(_value.copyWith(
      locationId: null == locationId
          ? _value.locationId
          : locationId // ignore: cast_nullable_to_non_nullable
              as String,
      locationName: null == locationName
          ? _value.locationName
          : locationName // ignore: cast_nullable_to_non_nullable
              as String,
      locationType: null == locationType
          ? _value.locationType
          : locationType // ignore: cast_nullable_to_non_nullable
              as String,
      totalJournalCashAmount: null == totalJournalCashAmount
          ? _value.totalJournalCashAmount
          : totalJournalCashAmount // ignore: cast_nullable_to_non_nullable
              as double,
      totalRealCashAmount: null == totalRealCashAmount
          ? _value.totalRealCashAmount
          : totalRealCashAmount // ignore: cast_nullable_to_non_nullable
              as double,
      cashDifference: null == cashDifference
          ? _value.cashDifference
          : cashDifference // ignore: cast_nullable_to_non_nullable
              as double,
      companyId: null == companyId
          ? _value.companyId
          : companyId // ignore: cast_nullable_to_non_nullable
              as String,
      storeId: freezed == storeId
          ? _value.storeId
          : storeId // ignore: cast_nullable_to_non_nullable
              as String?,
      currencySymbol: null == currencySymbol
          ? _value.currencySymbol
          : currencySymbol // ignore: cast_nullable_to_non_nullable
              as String,
      currencyCode: freezed == currencyCode
          ? _value.currencyCode
          : currencyCode // ignore: cast_nullable_to_non_nullable
              as String?,
      isDeleted: null == isDeleted
          ? _value.isDeleted
          : isDeleted // ignore: cast_nullable_to_non_nullable
              as bool,
      bankName: freezed == bankName
          ? _value.bankName
          : bankName // ignore: cast_nullable_to_non_nullable
              as String?,
      bankAccount: freezed == bankAccount
          ? _value.bankAccount
          : bankAccount // ignore: cast_nullable_to_non_nullable
              as String?,
      beneficiaryName: freezed == beneficiaryName
          ? _value.beneficiaryName
          : beneficiaryName // ignore: cast_nullable_to_non_nullable
              as String?,
      bankAddress: freezed == bankAddress
          ? _value.bankAddress
          : bankAddress // ignore: cast_nullable_to_non_nullable
              as String?,
      swiftCode: freezed == swiftCode
          ? _value.swiftCode
          : swiftCode // ignore: cast_nullable_to_non_nullable
              as String?,
      bankBranch: freezed == bankBranch
          ? _value.bankBranch
          : bankBranch // ignore: cast_nullable_to_non_nullable
              as String?,
      accountType: freezed == accountType
          ? _value.accountType
          : accountType // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CashLocationImplCopyWith<$Res>
    implements $CashLocationCopyWith<$Res> {
  factory _$$CashLocationImplCopyWith(
          _$CashLocationImpl value, $Res Function(_$CashLocationImpl) then) =
      __$$CashLocationImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String locationId,
      String locationName,
      String locationType,
      double totalJournalCashAmount,
      double totalRealCashAmount,
      double cashDifference,
      String companyId,
      String? storeId,
      String currencySymbol,
      String? currencyCode,
      bool isDeleted,
      String? bankName,
      String? bankAccount,
      String? beneficiaryName,
      String? bankAddress,
      String? swiftCode,
      String? bankBranch,
      String? accountType});
}

/// @nodoc
class __$$CashLocationImplCopyWithImpl<$Res>
    extends _$CashLocationCopyWithImpl<$Res, _$CashLocationImpl>
    implements _$$CashLocationImplCopyWith<$Res> {
  __$$CashLocationImplCopyWithImpl(
      _$CashLocationImpl _value, $Res Function(_$CashLocationImpl) _then)
      : super(_value, _then);

  /// Create a copy of CashLocation
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? locationId = null,
    Object? locationName = null,
    Object? locationType = null,
    Object? totalJournalCashAmount = null,
    Object? totalRealCashAmount = null,
    Object? cashDifference = null,
    Object? companyId = null,
    Object? storeId = freezed,
    Object? currencySymbol = null,
    Object? currencyCode = freezed,
    Object? isDeleted = null,
    Object? bankName = freezed,
    Object? bankAccount = freezed,
    Object? beneficiaryName = freezed,
    Object? bankAddress = freezed,
    Object? swiftCode = freezed,
    Object? bankBranch = freezed,
    Object? accountType = freezed,
  }) {
    return _then(_$CashLocationImpl(
      locationId: null == locationId
          ? _value.locationId
          : locationId // ignore: cast_nullable_to_non_nullable
              as String,
      locationName: null == locationName
          ? _value.locationName
          : locationName // ignore: cast_nullable_to_non_nullable
              as String,
      locationType: null == locationType
          ? _value.locationType
          : locationType // ignore: cast_nullable_to_non_nullable
              as String,
      totalJournalCashAmount: null == totalJournalCashAmount
          ? _value.totalJournalCashAmount
          : totalJournalCashAmount // ignore: cast_nullable_to_non_nullable
              as double,
      totalRealCashAmount: null == totalRealCashAmount
          ? _value.totalRealCashAmount
          : totalRealCashAmount // ignore: cast_nullable_to_non_nullable
              as double,
      cashDifference: null == cashDifference
          ? _value.cashDifference
          : cashDifference // ignore: cast_nullable_to_non_nullable
              as double,
      companyId: null == companyId
          ? _value.companyId
          : companyId // ignore: cast_nullable_to_non_nullable
              as String,
      storeId: freezed == storeId
          ? _value.storeId
          : storeId // ignore: cast_nullable_to_non_nullable
              as String?,
      currencySymbol: null == currencySymbol
          ? _value.currencySymbol
          : currencySymbol // ignore: cast_nullable_to_non_nullable
              as String,
      currencyCode: freezed == currencyCode
          ? _value.currencyCode
          : currencyCode // ignore: cast_nullable_to_non_nullable
              as String?,
      isDeleted: null == isDeleted
          ? _value.isDeleted
          : isDeleted // ignore: cast_nullable_to_non_nullable
              as bool,
      bankName: freezed == bankName
          ? _value.bankName
          : bankName // ignore: cast_nullable_to_non_nullable
              as String?,
      bankAccount: freezed == bankAccount
          ? _value.bankAccount
          : bankAccount // ignore: cast_nullable_to_non_nullable
              as String?,
      beneficiaryName: freezed == beneficiaryName
          ? _value.beneficiaryName
          : beneficiaryName // ignore: cast_nullable_to_non_nullable
              as String?,
      bankAddress: freezed == bankAddress
          ? _value.bankAddress
          : bankAddress // ignore: cast_nullable_to_non_nullable
              as String?,
      swiftCode: freezed == swiftCode
          ? _value.swiftCode
          : swiftCode // ignore: cast_nullable_to_non_nullable
              as String?,
      bankBranch: freezed == bankBranch
          ? _value.bankBranch
          : bankBranch // ignore: cast_nullable_to_non_nullable
              as String?,
      accountType: freezed == accountType
          ? _value.accountType
          : accountType // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$CashLocationImpl extends _CashLocation {
  const _$CashLocationImpl(
      {required this.locationId,
      required this.locationName,
      required this.locationType,
      required this.totalJournalCashAmount,
      required this.totalRealCashAmount,
      required this.cashDifference,
      required this.companyId,
      this.storeId,
      required this.currencySymbol,
      this.currencyCode,
      this.isDeleted = false,
      this.bankName,
      this.bankAccount,
      this.beneficiaryName,
      this.bankAddress,
      this.swiftCode,
      this.bankBranch,
      this.accountType})
      : super._();

  @override
  final String locationId;
  @override
  final String locationName;
  @override
  final String locationType;
  @override
  final double totalJournalCashAmount;
  @override
  final double totalRealCashAmount;
  @override
  final double cashDifference;
  @override
  final String companyId;
  @override
  final String? storeId;
  @override
  final String currencySymbol;
  @override
  final String? currencyCode;
  @override
  @JsonKey()
  final bool isDeleted;
// Bank-specific fields
  @override
  final String? bankName;
  @override
  final String? bankAccount;
  @override
  final String? beneficiaryName;
  @override
  final String? bankAddress;
  @override
  final String? swiftCode;
  @override
  final String? bankBranch;
  @override
  final String? accountType;

  @override
  String toString() {
    return 'CashLocation(locationId: $locationId, locationName: $locationName, locationType: $locationType, totalJournalCashAmount: $totalJournalCashAmount, totalRealCashAmount: $totalRealCashAmount, cashDifference: $cashDifference, companyId: $companyId, storeId: $storeId, currencySymbol: $currencySymbol, currencyCode: $currencyCode, isDeleted: $isDeleted, bankName: $bankName, bankAccount: $bankAccount, beneficiaryName: $beneficiaryName, bankAddress: $bankAddress, swiftCode: $swiftCode, bankBranch: $bankBranch, accountType: $accountType)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CashLocationImpl &&
            (identical(other.locationId, locationId) ||
                other.locationId == locationId) &&
            (identical(other.locationName, locationName) ||
                other.locationName == locationName) &&
            (identical(other.locationType, locationType) ||
                other.locationType == locationType) &&
            (identical(other.totalJournalCashAmount, totalJournalCashAmount) ||
                other.totalJournalCashAmount == totalJournalCashAmount) &&
            (identical(other.totalRealCashAmount, totalRealCashAmount) ||
                other.totalRealCashAmount == totalRealCashAmount) &&
            (identical(other.cashDifference, cashDifference) ||
                other.cashDifference == cashDifference) &&
            (identical(other.companyId, companyId) ||
                other.companyId == companyId) &&
            (identical(other.storeId, storeId) || other.storeId == storeId) &&
            (identical(other.currencySymbol, currencySymbol) ||
                other.currencySymbol == currencySymbol) &&
            (identical(other.currencyCode, currencyCode) ||
                other.currencyCode == currencyCode) &&
            (identical(other.isDeleted, isDeleted) ||
                other.isDeleted == isDeleted) &&
            (identical(other.bankName, bankName) ||
                other.bankName == bankName) &&
            (identical(other.bankAccount, bankAccount) ||
                other.bankAccount == bankAccount) &&
            (identical(other.beneficiaryName, beneficiaryName) ||
                other.beneficiaryName == beneficiaryName) &&
            (identical(other.bankAddress, bankAddress) ||
                other.bankAddress == bankAddress) &&
            (identical(other.swiftCode, swiftCode) ||
                other.swiftCode == swiftCode) &&
            (identical(other.bankBranch, bankBranch) ||
                other.bankBranch == bankBranch) &&
            (identical(other.accountType, accountType) ||
                other.accountType == accountType));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      locationId,
      locationName,
      locationType,
      totalJournalCashAmount,
      totalRealCashAmount,
      cashDifference,
      companyId,
      storeId,
      currencySymbol,
      currencyCode,
      isDeleted,
      bankName,
      bankAccount,
      beneficiaryName,
      bankAddress,
      swiftCode,
      bankBranch,
      accountType);

  /// Create a copy of CashLocation
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CashLocationImplCopyWith<_$CashLocationImpl> get copyWith =>
      __$$CashLocationImplCopyWithImpl<_$CashLocationImpl>(this, _$identity);
}

abstract class _CashLocation extends CashLocation {
  const factory _CashLocation(
      {required final String locationId,
      required final String locationName,
      required final String locationType,
      required final double totalJournalCashAmount,
      required final double totalRealCashAmount,
      required final double cashDifference,
      required final String companyId,
      final String? storeId,
      required final String currencySymbol,
      final String? currencyCode,
      final bool isDeleted,
      final String? bankName,
      final String? bankAccount,
      final String? beneficiaryName,
      final String? bankAddress,
      final String? swiftCode,
      final String? bankBranch,
      final String? accountType}) = _$CashLocationImpl;
  const _CashLocation._() : super._();

  @override
  String get locationId;
  @override
  String get locationName;
  @override
  String get locationType;
  @override
  double get totalJournalCashAmount;
  @override
  double get totalRealCashAmount;
  @override
  double get cashDifference;
  @override
  String get companyId;
  @override
  String? get storeId;
  @override
  String get currencySymbol;
  @override
  String? get currencyCode;
  @override
  bool get isDeleted; // Bank-specific fields
  @override
  String? get bankName;
  @override
  String? get bankAccount;
  @override
  String? get beneficiaryName;
  @override
  String? get bankAddress;
  @override
  String? get swiftCode;
  @override
  String? get bankBranch;
  @override
  String? get accountType;

  /// Create a copy of CashLocation
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CashLocationImplCopyWith<_$CashLocationImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
