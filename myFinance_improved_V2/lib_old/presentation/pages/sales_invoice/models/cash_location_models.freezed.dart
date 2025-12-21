// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'cash_location_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$CashLocation {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get type => throw _privateConstructorUsedError;
  String? get storeId => throw _privateConstructorUsedError;
  bool get isCompanyWide => throw _privateConstructorUsedError;
  bool get isDeleted => throw _privateConstructorUsedError;
  String get currencyCode => throw _privateConstructorUsedError;
  String? get bankAccount => throw _privateConstructorUsedError;
  String? get bankName => throw _privateConstructorUsedError;
  String? get locationInfo => throw _privateConstructorUsedError;
  int get transactionCount => throw _privateConstructorUsedError;
  CashLocationAdditionalData? get additionalData =>
      throw _privateConstructorUsedError;

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
      {String id,
      String name,
      String type,
      String? storeId,
      bool isCompanyWide,
      bool isDeleted,
      String currencyCode,
      String? bankAccount,
      String? bankName,
      String? locationInfo,
      int transactionCount,
      CashLocationAdditionalData? additionalData});

  $CashLocationAdditionalDataCopyWith<$Res>? get additionalData;
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
    Object? id = null,
    Object? name = null,
    Object? type = null,
    Object? storeId = freezed,
    Object? isCompanyWide = null,
    Object? isDeleted = null,
    Object? currencyCode = null,
    Object? bankAccount = freezed,
    Object? bankName = freezed,
    Object? locationInfo = freezed,
    Object? transactionCount = null,
    Object? additionalData = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      storeId: freezed == storeId
          ? _value.storeId
          : storeId // ignore: cast_nullable_to_non_nullable
              as String?,
      isCompanyWide: null == isCompanyWide
          ? _value.isCompanyWide
          : isCompanyWide // ignore: cast_nullable_to_non_nullable
              as bool,
      isDeleted: null == isDeleted
          ? _value.isDeleted
          : isDeleted // ignore: cast_nullable_to_non_nullable
              as bool,
      currencyCode: null == currencyCode
          ? _value.currencyCode
          : currencyCode // ignore: cast_nullable_to_non_nullable
              as String,
      bankAccount: freezed == bankAccount
          ? _value.bankAccount
          : bankAccount // ignore: cast_nullable_to_non_nullable
              as String?,
      bankName: freezed == bankName
          ? _value.bankName
          : bankName // ignore: cast_nullable_to_non_nullable
              as String?,
      locationInfo: freezed == locationInfo
          ? _value.locationInfo
          : locationInfo // ignore: cast_nullable_to_non_nullable
              as String?,
      transactionCount: null == transactionCount
          ? _value.transactionCount
          : transactionCount // ignore: cast_nullable_to_non_nullable
              as int,
      additionalData: freezed == additionalData
          ? _value.additionalData
          : additionalData // ignore: cast_nullable_to_non_nullable
              as CashLocationAdditionalData?,
    ) as $Val);
  }

  /// Create a copy of CashLocation
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $CashLocationAdditionalDataCopyWith<$Res>? get additionalData {
    if (_value.additionalData == null) {
      return null;
    }

    return $CashLocationAdditionalDataCopyWith<$Res>(_value.additionalData!,
        (value) {
      return _then(_value.copyWith(additionalData: value) as $Val);
    });
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
      {String id,
      String name,
      String type,
      String? storeId,
      bool isCompanyWide,
      bool isDeleted,
      String currencyCode,
      String? bankAccount,
      String? bankName,
      String? locationInfo,
      int transactionCount,
      CashLocationAdditionalData? additionalData});

  @override
  $CashLocationAdditionalDataCopyWith<$Res>? get additionalData;
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
    Object? id = null,
    Object? name = null,
    Object? type = null,
    Object? storeId = freezed,
    Object? isCompanyWide = null,
    Object? isDeleted = null,
    Object? currencyCode = null,
    Object? bankAccount = freezed,
    Object? bankName = freezed,
    Object? locationInfo = freezed,
    Object? transactionCount = null,
    Object? additionalData = freezed,
  }) {
    return _then(_$CashLocationImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      storeId: freezed == storeId
          ? _value.storeId
          : storeId // ignore: cast_nullable_to_non_nullable
              as String?,
      isCompanyWide: null == isCompanyWide
          ? _value.isCompanyWide
          : isCompanyWide // ignore: cast_nullable_to_non_nullable
              as bool,
      isDeleted: null == isDeleted
          ? _value.isDeleted
          : isDeleted // ignore: cast_nullable_to_non_nullable
              as bool,
      currencyCode: null == currencyCode
          ? _value.currencyCode
          : currencyCode // ignore: cast_nullable_to_non_nullable
              as String,
      bankAccount: freezed == bankAccount
          ? _value.bankAccount
          : bankAccount // ignore: cast_nullable_to_non_nullable
              as String?,
      bankName: freezed == bankName
          ? _value.bankName
          : bankName // ignore: cast_nullable_to_non_nullable
              as String?,
      locationInfo: freezed == locationInfo
          ? _value.locationInfo
          : locationInfo // ignore: cast_nullable_to_non_nullable
              as String?,
      transactionCount: null == transactionCount
          ? _value.transactionCount
          : transactionCount // ignore: cast_nullable_to_non_nullable
              as int,
      additionalData: freezed == additionalData
          ? _value.additionalData
          : additionalData // ignore: cast_nullable_to_non_nullable
              as CashLocationAdditionalData?,
    ));
  }
}

/// @nodoc

class _$CashLocationImpl implements _CashLocation {
  const _$CashLocationImpl(
      {required this.id,
      required this.name,
      required this.type,
      this.storeId,
      this.isCompanyWide = true,
      this.isDeleted = false,
      this.currencyCode = 'KRW',
      this.bankAccount,
      this.bankName,
      this.locationInfo,
      this.transactionCount = 0,
      this.additionalData});

  @override
  final String id;
  @override
  final String name;
  @override
  final String type;
  @override
  final String? storeId;
  @override
  @JsonKey()
  final bool isCompanyWide;
  @override
  @JsonKey()
  final bool isDeleted;
  @override
  @JsonKey()
  final String currencyCode;
  @override
  final String? bankAccount;
  @override
  final String? bankName;
  @override
  final String? locationInfo;
  @override
  @JsonKey()
  final int transactionCount;
  @override
  final CashLocationAdditionalData? additionalData;

  @override
  String toString() {
    return 'CashLocation(id: $id, name: $name, type: $type, storeId: $storeId, isCompanyWide: $isCompanyWide, isDeleted: $isDeleted, currencyCode: $currencyCode, bankAccount: $bankAccount, bankName: $bankName, locationInfo: $locationInfo, transactionCount: $transactionCount, additionalData: $additionalData)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CashLocationImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.storeId, storeId) || other.storeId == storeId) &&
            (identical(other.isCompanyWide, isCompanyWide) ||
                other.isCompanyWide == isCompanyWide) &&
            (identical(other.isDeleted, isDeleted) ||
                other.isDeleted == isDeleted) &&
            (identical(other.currencyCode, currencyCode) ||
                other.currencyCode == currencyCode) &&
            (identical(other.bankAccount, bankAccount) ||
                other.bankAccount == bankAccount) &&
            (identical(other.bankName, bankName) ||
                other.bankName == bankName) &&
            (identical(other.locationInfo, locationInfo) ||
                other.locationInfo == locationInfo) &&
            (identical(other.transactionCount, transactionCount) ||
                other.transactionCount == transactionCount) &&
            (identical(other.additionalData, additionalData) ||
                other.additionalData == additionalData));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      name,
      type,
      storeId,
      isCompanyWide,
      isDeleted,
      currencyCode,
      bankAccount,
      bankName,
      locationInfo,
      transactionCount,
      additionalData);

  /// Create a copy of CashLocation
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CashLocationImplCopyWith<_$CashLocationImpl> get copyWith =>
      __$$CashLocationImplCopyWithImpl<_$CashLocationImpl>(this, _$identity);
}

abstract class _CashLocation implements CashLocation {
  const factory _CashLocation(
      {required final String id,
      required final String name,
      required final String type,
      final String? storeId,
      final bool isCompanyWide,
      final bool isDeleted,
      final String currencyCode,
      final String? bankAccount,
      final String? bankName,
      final String? locationInfo,
      final int transactionCount,
      final CashLocationAdditionalData? additionalData}) = _$CashLocationImpl;

  @override
  String get id;
  @override
  String get name;
  @override
  String get type;
  @override
  String? get storeId;
  @override
  bool get isCompanyWide;
  @override
  bool get isDeleted;
  @override
  String get currencyCode;
  @override
  String? get bankAccount;
  @override
  String? get bankName;
  @override
  String? get locationInfo;
  @override
  int get transactionCount;
  @override
  CashLocationAdditionalData? get additionalData;

  /// Create a copy of CashLocation
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CashLocationImplCopyWith<_$CashLocationImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$CashLocationAdditionalData {
  @JsonKey(name: 'cash_location_id')
  String get cashLocationId => throw _privateConstructorUsedError;
  @JsonKey(name: 'company_id')
  String get companyId => throw _privateConstructorUsedError;
  @JsonKey(name: 'store_id')
  String? get storeId => throw _privateConstructorUsedError;
  @JsonKey(name: 'location_name')
  String get locationName => throw _privateConstructorUsedError;
  @JsonKey(name: 'location_type')
  String get locationType => throw _privateConstructorUsedError;
  @JsonKey(name: 'location_info')
  String? get locationInfo => throw _privateConstructorUsedError;
  @JsonKey(name: 'currency_code')
  String get currencyCode => throw _privateConstructorUsedError;
  @JsonKey(name: 'bank_account')
  String? get bankAccount => throw _privateConstructorUsedError;
  @JsonKey(name: 'bank_name')
  String? get bankName => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_deleted')
  bool get isDeleted => throw _privateConstructorUsedError;
  @JsonKey(name: 'deleted_at')
  String? get deletedAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  String get createdAt => throw _privateConstructorUsedError;

  /// Create a copy of CashLocationAdditionalData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CashLocationAdditionalDataCopyWith<CashLocationAdditionalData>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CashLocationAdditionalDataCopyWith<$Res> {
  factory $CashLocationAdditionalDataCopyWith(CashLocationAdditionalData value,
          $Res Function(CashLocationAdditionalData) then) =
      _$CashLocationAdditionalDataCopyWithImpl<$Res,
          CashLocationAdditionalData>;
  @useResult
  $Res call(
      {@JsonKey(name: 'cash_location_id') String cashLocationId,
      @JsonKey(name: 'company_id') String companyId,
      @JsonKey(name: 'store_id') String? storeId,
      @JsonKey(name: 'location_name') String locationName,
      @JsonKey(name: 'location_type') String locationType,
      @JsonKey(name: 'location_info') String? locationInfo,
      @JsonKey(name: 'currency_code') String currencyCode,
      @JsonKey(name: 'bank_account') String? bankAccount,
      @JsonKey(name: 'bank_name') String? bankName,
      @JsonKey(name: 'is_deleted') bool isDeleted,
      @JsonKey(name: 'deleted_at') String? deletedAt,
      @JsonKey(name: 'created_at') String createdAt});
}

/// @nodoc
class _$CashLocationAdditionalDataCopyWithImpl<$Res,
        $Val extends CashLocationAdditionalData>
    implements $CashLocationAdditionalDataCopyWith<$Res> {
  _$CashLocationAdditionalDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CashLocationAdditionalData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? cashLocationId = null,
    Object? companyId = null,
    Object? storeId = freezed,
    Object? locationName = null,
    Object? locationType = null,
    Object? locationInfo = freezed,
    Object? currencyCode = null,
    Object? bankAccount = freezed,
    Object? bankName = freezed,
    Object? isDeleted = null,
    Object? deletedAt = freezed,
    Object? createdAt = null,
  }) {
    return _then(_value.copyWith(
      cashLocationId: null == cashLocationId
          ? _value.cashLocationId
          : cashLocationId // ignore: cast_nullable_to_non_nullable
              as String,
      companyId: null == companyId
          ? _value.companyId
          : companyId // ignore: cast_nullable_to_non_nullable
              as String,
      storeId: freezed == storeId
          ? _value.storeId
          : storeId // ignore: cast_nullable_to_non_nullable
              as String?,
      locationName: null == locationName
          ? _value.locationName
          : locationName // ignore: cast_nullable_to_non_nullable
              as String,
      locationType: null == locationType
          ? _value.locationType
          : locationType // ignore: cast_nullable_to_non_nullable
              as String,
      locationInfo: freezed == locationInfo
          ? _value.locationInfo
          : locationInfo // ignore: cast_nullable_to_non_nullable
              as String?,
      currencyCode: null == currencyCode
          ? _value.currencyCode
          : currencyCode // ignore: cast_nullable_to_non_nullable
              as String,
      bankAccount: freezed == bankAccount
          ? _value.bankAccount
          : bankAccount // ignore: cast_nullable_to_non_nullable
              as String?,
      bankName: freezed == bankName
          ? _value.bankName
          : bankName // ignore: cast_nullable_to_non_nullable
              as String?,
      isDeleted: null == isDeleted
          ? _value.isDeleted
          : isDeleted // ignore: cast_nullable_to_non_nullable
              as bool,
      deletedAt: freezed == deletedAt
          ? _value.deletedAt
          : deletedAt // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CashLocationAdditionalDataImplCopyWith<$Res>
    implements $CashLocationAdditionalDataCopyWith<$Res> {
  factory _$$CashLocationAdditionalDataImplCopyWith(
          _$CashLocationAdditionalDataImpl value,
          $Res Function(_$CashLocationAdditionalDataImpl) then) =
      __$$CashLocationAdditionalDataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'cash_location_id') String cashLocationId,
      @JsonKey(name: 'company_id') String companyId,
      @JsonKey(name: 'store_id') String? storeId,
      @JsonKey(name: 'location_name') String locationName,
      @JsonKey(name: 'location_type') String locationType,
      @JsonKey(name: 'location_info') String? locationInfo,
      @JsonKey(name: 'currency_code') String currencyCode,
      @JsonKey(name: 'bank_account') String? bankAccount,
      @JsonKey(name: 'bank_name') String? bankName,
      @JsonKey(name: 'is_deleted') bool isDeleted,
      @JsonKey(name: 'deleted_at') String? deletedAt,
      @JsonKey(name: 'created_at') String createdAt});
}

/// @nodoc
class __$$CashLocationAdditionalDataImplCopyWithImpl<$Res>
    extends _$CashLocationAdditionalDataCopyWithImpl<$Res,
        _$CashLocationAdditionalDataImpl>
    implements _$$CashLocationAdditionalDataImplCopyWith<$Res> {
  __$$CashLocationAdditionalDataImplCopyWithImpl(
      _$CashLocationAdditionalDataImpl _value,
      $Res Function(_$CashLocationAdditionalDataImpl) _then)
      : super(_value, _then);

  /// Create a copy of CashLocationAdditionalData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? cashLocationId = null,
    Object? companyId = null,
    Object? storeId = freezed,
    Object? locationName = null,
    Object? locationType = null,
    Object? locationInfo = freezed,
    Object? currencyCode = null,
    Object? bankAccount = freezed,
    Object? bankName = freezed,
    Object? isDeleted = null,
    Object? deletedAt = freezed,
    Object? createdAt = null,
  }) {
    return _then(_$CashLocationAdditionalDataImpl(
      cashLocationId: null == cashLocationId
          ? _value.cashLocationId
          : cashLocationId // ignore: cast_nullable_to_non_nullable
              as String,
      companyId: null == companyId
          ? _value.companyId
          : companyId // ignore: cast_nullable_to_non_nullable
              as String,
      storeId: freezed == storeId
          ? _value.storeId
          : storeId // ignore: cast_nullable_to_non_nullable
              as String?,
      locationName: null == locationName
          ? _value.locationName
          : locationName // ignore: cast_nullable_to_non_nullable
              as String,
      locationType: null == locationType
          ? _value.locationType
          : locationType // ignore: cast_nullable_to_non_nullable
              as String,
      locationInfo: freezed == locationInfo
          ? _value.locationInfo
          : locationInfo // ignore: cast_nullable_to_non_nullable
              as String?,
      currencyCode: null == currencyCode
          ? _value.currencyCode
          : currencyCode // ignore: cast_nullable_to_non_nullable
              as String,
      bankAccount: freezed == bankAccount
          ? _value.bankAccount
          : bankAccount // ignore: cast_nullable_to_non_nullable
              as String?,
      bankName: freezed == bankName
          ? _value.bankName
          : bankName // ignore: cast_nullable_to_non_nullable
              as String?,
      isDeleted: null == isDeleted
          ? _value.isDeleted
          : isDeleted // ignore: cast_nullable_to_non_nullable
              as bool,
      deletedAt: freezed == deletedAt
          ? _value.deletedAt
          : deletedAt // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$CashLocationAdditionalDataImpl implements _CashLocationAdditionalData {
  const _$CashLocationAdditionalDataImpl(
      {@JsonKey(name: 'cash_location_id') required this.cashLocationId,
      @JsonKey(name: 'company_id') required this.companyId,
      @JsonKey(name: 'store_id') this.storeId,
      @JsonKey(name: 'location_name') required this.locationName,
      @JsonKey(name: 'location_type') required this.locationType,
      @JsonKey(name: 'location_info') this.locationInfo,
      @JsonKey(name: 'currency_code') this.currencyCode = 'KRW',
      @JsonKey(name: 'bank_account') this.bankAccount,
      @JsonKey(name: 'bank_name') this.bankName,
      @JsonKey(name: 'is_deleted') this.isDeleted = false,
      @JsonKey(name: 'deleted_at') this.deletedAt,
      @JsonKey(name: 'created_at') required this.createdAt});

  @override
  @JsonKey(name: 'cash_location_id')
  final String cashLocationId;
  @override
  @JsonKey(name: 'company_id')
  final String companyId;
  @override
  @JsonKey(name: 'store_id')
  final String? storeId;
  @override
  @JsonKey(name: 'location_name')
  final String locationName;
  @override
  @JsonKey(name: 'location_type')
  final String locationType;
  @override
  @JsonKey(name: 'location_info')
  final String? locationInfo;
  @override
  @JsonKey(name: 'currency_code')
  final String currencyCode;
  @override
  @JsonKey(name: 'bank_account')
  final String? bankAccount;
  @override
  @JsonKey(name: 'bank_name')
  final String? bankName;
  @override
  @JsonKey(name: 'is_deleted')
  final bool isDeleted;
  @override
  @JsonKey(name: 'deleted_at')
  final String? deletedAt;
  @override
  @JsonKey(name: 'created_at')
  final String createdAt;

  @override
  String toString() {
    return 'CashLocationAdditionalData(cashLocationId: $cashLocationId, companyId: $companyId, storeId: $storeId, locationName: $locationName, locationType: $locationType, locationInfo: $locationInfo, currencyCode: $currencyCode, bankAccount: $bankAccount, bankName: $bankName, isDeleted: $isDeleted, deletedAt: $deletedAt, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CashLocationAdditionalDataImpl &&
            (identical(other.cashLocationId, cashLocationId) ||
                other.cashLocationId == cashLocationId) &&
            (identical(other.companyId, companyId) ||
                other.companyId == companyId) &&
            (identical(other.storeId, storeId) || other.storeId == storeId) &&
            (identical(other.locationName, locationName) ||
                other.locationName == locationName) &&
            (identical(other.locationType, locationType) ||
                other.locationType == locationType) &&
            (identical(other.locationInfo, locationInfo) ||
                other.locationInfo == locationInfo) &&
            (identical(other.currencyCode, currencyCode) ||
                other.currencyCode == currencyCode) &&
            (identical(other.bankAccount, bankAccount) ||
                other.bankAccount == bankAccount) &&
            (identical(other.bankName, bankName) ||
                other.bankName == bankName) &&
            (identical(other.isDeleted, isDeleted) ||
                other.isDeleted == isDeleted) &&
            (identical(other.deletedAt, deletedAt) ||
                other.deletedAt == deletedAt) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      cashLocationId,
      companyId,
      storeId,
      locationName,
      locationType,
      locationInfo,
      currencyCode,
      bankAccount,
      bankName,
      isDeleted,
      deletedAt,
      createdAt);

  /// Create a copy of CashLocationAdditionalData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CashLocationAdditionalDataImplCopyWith<_$CashLocationAdditionalDataImpl>
      get copyWith => __$$CashLocationAdditionalDataImplCopyWithImpl<
          _$CashLocationAdditionalDataImpl>(this, _$identity);
}

abstract class _CashLocationAdditionalData
    implements CashLocationAdditionalData {
  const factory _CashLocationAdditionalData(
      {@JsonKey(name: 'cash_location_id') required final String cashLocationId,
      @JsonKey(name: 'company_id') required final String companyId,
      @JsonKey(name: 'store_id') final String? storeId,
      @JsonKey(name: 'location_name') required final String locationName,
      @JsonKey(name: 'location_type') required final String locationType,
      @JsonKey(name: 'location_info') final String? locationInfo,
      @JsonKey(name: 'currency_code') final String currencyCode,
      @JsonKey(name: 'bank_account') final String? bankAccount,
      @JsonKey(name: 'bank_name') final String? bankName,
      @JsonKey(name: 'is_deleted') final bool isDeleted,
      @JsonKey(name: 'deleted_at') final String? deletedAt,
      @JsonKey(name: 'created_at')
      required final String createdAt}) = _$CashLocationAdditionalDataImpl;

  @override
  @JsonKey(name: 'cash_location_id')
  String get cashLocationId;
  @override
  @JsonKey(name: 'company_id')
  String get companyId;
  @override
  @JsonKey(name: 'store_id')
  String? get storeId;
  @override
  @JsonKey(name: 'location_name')
  String get locationName;
  @override
  @JsonKey(name: 'location_type')
  String get locationType;
  @override
  @JsonKey(name: 'location_info')
  String? get locationInfo;
  @override
  @JsonKey(name: 'currency_code')
  String get currencyCode;
  @override
  @JsonKey(name: 'bank_account')
  String? get bankAccount;
  @override
  @JsonKey(name: 'bank_name')
  String? get bankName;
  @override
  @JsonKey(name: 'is_deleted')
  bool get isDeleted;
  @override
  @JsonKey(name: 'deleted_at')
  String? get deletedAt;
  @override
  @JsonKey(name: 'created_at')
  String get createdAt;

  /// Create a copy of CashLocationAdditionalData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CashLocationAdditionalDataImplCopyWith<_$CashLocationAdditionalDataImpl>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$CashLocationsResponse {
  bool get success => throw _privateConstructorUsedError;
  List<CashLocation> get data => throw _privateConstructorUsedError;
  String? get message => throw _privateConstructorUsedError;
  Map<String, dynamic>? get error => throw _privateConstructorUsedError;

  /// Create a copy of CashLocationsResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CashLocationsResponseCopyWith<CashLocationsResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CashLocationsResponseCopyWith<$Res> {
  factory $CashLocationsResponseCopyWith(CashLocationsResponse value,
          $Res Function(CashLocationsResponse) then) =
      _$CashLocationsResponseCopyWithImpl<$Res, CashLocationsResponse>;
  @useResult
  $Res call(
      {bool success,
      List<CashLocation> data,
      String? message,
      Map<String, dynamic>? error});
}

/// @nodoc
class _$CashLocationsResponseCopyWithImpl<$Res,
        $Val extends CashLocationsResponse>
    implements $CashLocationsResponseCopyWith<$Res> {
  _$CashLocationsResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CashLocationsResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? success = null,
    Object? data = null,
    Object? message = freezed,
    Object? error = freezed,
  }) {
    return _then(_value.copyWith(
      success: null == success
          ? _value.success
          : success // ignore: cast_nullable_to_non_nullable
              as bool,
      data: null == data
          ? _value.data
          : data // ignore: cast_nullable_to_non_nullable
              as List<CashLocation>,
      message: freezed == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String?,
      error: freezed == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CashLocationsResponseImplCopyWith<$Res>
    implements $CashLocationsResponseCopyWith<$Res> {
  factory _$$CashLocationsResponseImplCopyWith(
          _$CashLocationsResponseImpl value,
          $Res Function(_$CashLocationsResponseImpl) then) =
      __$$CashLocationsResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {bool success,
      List<CashLocation> data,
      String? message,
      Map<String, dynamic>? error});
}

/// @nodoc
class __$$CashLocationsResponseImplCopyWithImpl<$Res>
    extends _$CashLocationsResponseCopyWithImpl<$Res,
        _$CashLocationsResponseImpl>
    implements _$$CashLocationsResponseImplCopyWith<$Res> {
  __$$CashLocationsResponseImplCopyWithImpl(_$CashLocationsResponseImpl _value,
      $Res Function(_$CashLocationsResponseImpl) _then)
      : super(_value, _then);

  /// Create a copy of CashLocationsResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? success = null,
    Object? data = null,
    Object? message = freezed,
    Object? error = freezed,
  }) {
    return _then(_$CashLocationsResponseImpl(
      success: null == success
          ? _value.success
          : success // ignore: cast_nullable_to_non_nullable
              as bool,
      data: null == data
          ? _value._data
          : data // ignore: cast_nullable_to_non_nullable
              as List<CashLocation>,
      message: freezed == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String?,
      error: freezed == error
          ? _value._error
          : error // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
    ));
  }
}

/// @nodoc

class _$CashLocationsResponseImpl implements _CashLocationsResponse {
  const _$CashLocationsResponseImpl(
      {required this.success,
      required final List<CashLocation> data,
      this.message,
      final Map<String, dynamic>? error})
      : _data = data,
        _error = error;

  @override
  final bool success;
  final List<CashLocation> _data;
  @override
  List<CashLocation> get data {
    if (_data is EqualUnmodifiableListView) return _data;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_data);
  }

  @override
  final String? message;
  final Map<String, dynamic>? _error;
  @override
  Map<String, dynamic>? get error {
    final value = _error;
    if (value == null) return null;
    if (_error is EqualUnmodifiableMapView) return _error;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  String toString() {
    return 'CashLocationsResponse(success: $success, data: $data, message: $message, error: $error)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CashLocationsResponseImpl &&
            (identical(other.success, success) || other.success == success) &&
            const DeepCollectionEquality().equals(other._data, _data) &&
            (identical(other.message, message) || other.message == message) &&
            const DeepCollectionEquality().equals(other._error, _error));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      success,
      const DeepCollectionEquality().hash(_data),
      message,
      const DeepCollectionEquality().hash(_error));

  /// Create a copy of CashLocationsResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CashLocationsResponseImplCopyWith<_$CashLocationsResponseImpl>
      get copyWith => __$$CashLocationsResponseImplCopyWithImpl<
          _$CashLocationsResponseImpl>(this, _$identity);
}

abstract class _CashLocationsResponse implements CashLocationsResponse {
  const factory _CashLocationsResponse(
      {required final bool success,
      required final List<CashLocation> data,
      final String? message,
      final Map<String, dynamic>? error}) = _$CashLocationsResponseImpl;

  @override
  bool get success;
  @override
  List<CashLocation> get data;
  @override
  String? get message;
  @override
  Map<String, dynamic>? get error;

  /// Create a copy of CashLocationsResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CashLocationsResponseImplCopyWith<_$CashLocationsResponseImpl>
      get copyWith => throw _privateConstructorUsedError;
}
