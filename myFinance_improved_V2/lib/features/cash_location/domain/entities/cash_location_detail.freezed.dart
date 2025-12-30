// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'cash_location_detail.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$CashLocationDetail {
  String get locationId => throw _privateConstructorUsedError;
  String get locationName => throw _privateConstructorUsedError;
  String get locationType => throw _privateConstructorUsedError;
  String? get note => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  String? get bankName => throw _privateConstructorUsedError;
  String? get accountNumber => throw _privateConstructorUsedError;
  bool get isMainLocation => throw _privateConstructorUsedError;
  String get companyId => throw _privateConstructorUsedError;
  String? get storeId => throw _privateConstructorUsedError;
  bool get isDeleted =>
      throw _privateConstructorUsedError; // Trade/International banking fields
  String? get beneficiaryName => throw _privateConstructorUsedError;
  String? get bankAddress => throw _privateConstructorUsedError;
  String? get swiftCode => throw _privateConstructorUsedError;
  String? get bankBranch => throw _privateConstructorUsedError;
  String? get accountType => throw _privateConstructorUsedError;

  /// Create a copy of CashLocationDetail
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CashLocationDetailCopyWith<CashLocationDetail> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CashLocationDetailCopyWith<$Res> {
  factory $CashLocationDetailCopyWith(
          CashLocationDetail value, $Res Function(CashLocationDetail) then) =
      _$CashLocationDetailCopyWithImpl<$Res, CashLocationDetail>;
  @useResult
  $Res call(
      {String locationId,
      String locationName,
      String locationType,
      String? note,
      String? description,
      String? bankName,
      String? accountNumber,
      bool isMainLocation,
      String companyId,
      String? storeId,
      bool isDeleted,
      String? beneficiaryName,
      String? bankAddress,
      String? swiftCode,
      String? bankBranch,
      String? accountType});
}

/// @nodoc
class _$CashLocationDetailCopyWithImpl<$Res, $Val extends CashLocationDetail>
    implements $CashLocationDetailCopyWith<$Res> {
  _$CashLocationDetailCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CashLocationDetail
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? locationId = null,
    Object? locationName = null,
    Object? locationType = null,
    Object? note = freezed,
    Object? description = freezed,
    Object? bankName = freezed,
    Object? accountNumber = freezed,
    Object? isMainLocation = null,
    Object? companyId = null,
    Object? storeId = freezed,
    Object? isDeleted = null,
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
      note: freezed == note
          ? _value.note
          : note // ignore: cast_nullable_to_non_nullable
              as String?,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      bankName: freezed == bankName
          ? _value.bankName
          : bankName // ignore: cast_nullable_to_non_nullable
              as String?,
      accountNumber: freezed == accountNumber
          ? _value.accountNumber
          : accountNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      isMainLocation: null == isMainLocation
          ? _value.isMainLocation
          : isMainLocation // ignore: cast_nullable_to_non_nullable
              as bool,
      companyId: null == companyId
          ? _value.companyId
          : companyId // ignore: cast_nullable_to_non_nullable
              as String,
      storeId: freezed == storeId
          ? _value.storeId
          : storeId // ignore: cast_nullable_to_non_nullable
              as String?,
      isDeleted: null == isDeleted
          ? _value.isDeleted
          : isDeleted // ignore: cast_nullable_to_non_nullable
              as bool,
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
abstract class _$$CashLocationDetailImplCopyWith<$Res>
    implements $CashLocationDetailCopyWith<$Res> {
  factory _$$CashLocationDetailImplCopyWith(_$CashLocationDetailImpl value,
          $Res Function(_$CashLocationDetailImpl) then) =
      __$$CashLocationDetailImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String locationId,
      String locationName,
      String locationType,
      String? note,
      String? description,
      String? bankName,
      String? accountNumber,
      bool isMainLocation,
      String companyId,
      String? storeId,
      bool isDeleted,
      String? beneficiaryName,
      String? bankAddress,
      String? swiftCode,
      String? bankBranch,
      String? accountType});
}

/// @nodoc
class __$$CashLocationDetailImplCopyWithImpl<$Res>
    extends _$CashLocationDetailCopyWithImpl<$Res, _$CashLocationDetailImpl>
    implements _$$CashLocationDetailImplCopyWith<$Res> {
  __$$CashLocationDetailImplCopyWithImpl(_$CashLocationDetailImpl _value,
      $Res Function(_$CashLocationDetailImpl) _then)
      : super(_value, _then);

  /// Create a copy of CashLocationDetail
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? locationId = null,
    Object? locationName = null,
    Object? locationType = null,
    Object? note = freezed,
    Object? description = freezed,
    Object? bankName = freezed,
    Object? accountNumber = freezed,
    Object? isMainLocation = null,
    Object? companyId = null,
    Object? storeId = freezed,
    Object? isDeleted = null,
    Object? beneficiaryName = freezed,
    Object? bankAddress = freezed,
    Object? swiftCode = freezed,
    Object? bankBranch = freezed,
    Object? accountType = freezed,
  }) {
    return _then(_$CashLocationDetailImpl(
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
      note: freezed == note
          ? _value.note
          : note // ignore: cast_nullable_to_non_nullable
              as String?,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      bankName: freezed == bankName
          ? _value.bankName
          : bankName // ignore: cast_nullable_to_non_nullable
              as String?,
      accountNumber: freezed == accountNumber
          ? _value.accountNumber
          : accountNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      isMainLocation: null == isMainLocation
          ? _value.isMainLocation
          : isMainLocation // ignore: cast_nullable_to_non_nullable
              as bool,
      companyId: null == companyId
          ? _value.companyId
          : companyId // ignore: cast_nullable_to_non_nullable
              as String,
      storeId: freezed == storeId
          ? _value.storeId
          : storeId // ignore: cast_nullable_to_non_nullable
              as String?,
      isDeleted: null == isDeleted
          ? _value.isDeleted
          : isDeleted // ignore: cast_nullable_to_non_nullable
              as bool,
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

class _$CashLocationDetailImpl implements _CashLocationDetail {
  const _$CashLocationDetailImpl(
      {required this.locationId,
      required this.locationName,
      required this.locationType,
      this.note,
      this.description,
      this.bankName,
      this.accountNumber,
      required this.isMainLocation,
      required this.companyId,
      this.storeId,
      this.isDeleted = false,
      this.beneficiaryName,
      this.bankAddress,
      this.swiftCode,
      this.bankBranch,
      this.accountType});

  @override
  final String locationId;
  @override
  final String locationName;
  @override
  final String locationType;
  @override
  final String? note;
  @override
  final String? description;
  @override
  final String? bankName;
  @override
  final String? accountNumber;
  @override
  final bool isMainLocation;
  @override
  final String companyId;
  @override
  final String? storeId;
  @override
  @JsonKey()
  final bool isDeleted;
// Trade/International banking fields
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
    return 'CashLocationDetail(locationId: $locationId, locationName: $locationName, locationType: $locationType, note: $note, description: $description, bankName: $bankName, accountNumber: $accountNumber, isMainLocation: $isMainLocation, companyId: $companyId, storeId: $storeId, isDeleted: $isDeleted, beneficiaryName: $beneficiaryName, bankAddress: $bankAddress, swiftCode: $swiftCode, bankBranch: $bankBranch, accountType: $accountType)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CashLocationDetailImpl &&
            (identical(other.locationId, locationId) ||
                other.locationId == locationId) &&
            (identical(other.locationName, locationName) ||
                other.locationName == locationName) &&
            (identical(other.locationType, locationType) ||
                other.locationType == locationType) &&
            (identical(other.note, note) || other.note == note) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.bankName, bankName) ||
                other.bankName == bankName) &&
            (identical(other.accountNumber, accountNumber) ||
                other.accountNumber == accountNumber) &&
            (identical(other.isMainLocation, isMainLocation) ||
                other.isMainLocation == isMainLocation) &&
            (identical(other.companyId, companyId) ||
                other.companyId == companyId) &&
            (identical(other.storeId, storeId) || other.storeId == storeId) &&
            (identical(other.isDeleted, isDeleted) ||
                other.isDeleted == isDeleted) &&
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
      note,
      description,
      bankName,
      accountNumber,
      isMainLocation,
      companyId,
      storeId,
      isDeleted,
      beneficiaryName,
      bankAddress,
      swiftCode,
      bankBranch,
      accountType);

  /// Create a copy of CashLocationDetail
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CashLocationDetailImplCopyWith<_$CashLocationDetailImpl> get copyWith =>
      __$$CashLocationDetailImplCopyWithImpl<_$CashLocationDetailImpl>(
          this, _$identity);
}

abstract class _CashLocationDetail implements CashLocationDetail {
  const factory _CashLocationDetail(
      {required final String locationId,
      required final String locationName,
      required final String locationType,
      final String? note,
      final String? description,
      final String? bankName,
      final String? accountNumber,
      required final bool isMainLocation,
      required final String companyId,
      final String? storeId,
      final bool isDeleted,
      final String? beneficiaryName,
      final String? bankAddress,
      final String? swiftCode,
      final String? bankBranch,
      final String? accountType}) = _$CashLocationDetailImpl;

  @override
  String get locationId;
  @override
  String get locationName;
  @override
  String get locationType;
  @override
  String? get note;
  @override
  String? get description;
  @override
  String? get bankName;
  @override
  String? get accountNumber;
  @override
  bool get isMainLocation;
  @override
  String get companyId;
  @override
  String? get storeId;
  @override
  bool get isDeleted; // Trade/International banking fields
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

  /// Create a copy of CashLocationDetail
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CashLocationDetailImplCopyWith<_$CashLocationDetailImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
