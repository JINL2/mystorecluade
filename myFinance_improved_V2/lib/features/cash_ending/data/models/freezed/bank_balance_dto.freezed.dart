// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'bank_balance_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

BankBalanceDto _$BankBalanceDtoFromJson(Map<String, dynamic> json) {
  return _BankBalanceDto.fromJson(json);
}

/// @nodoc
mixin _$BankBalanceDto {
  @JsonKey(name: 'bank_amount_id')
  String? get balanceId => throw _privateConstructorUsedError;
  @JsonKey(name: 'company_id')
  String get companyId => throw _privateConstructorUsedError;
  @JsonKey(name: 'store_id')
  String? get storeId => throw _privateConstructorUsedError;
  @JsonKey(name: 'location_id')
  String get locationId => throw _privateConstructorUsedError;
  @JsonKey(name: 'currency_id')
  String get currencyId => throw _privateConstructorUsedError;
  @JsonKey(name: 'total_amount')
  int get totalAmount => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_by')
  String get userId => throw _privateConstructorUsedError;
  @JsonKey(name: 'record_date')
  DateTime get recordDate => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  DateTime get createdAt => throw _privateConstructorUsedError;

  /// Serializes this BankBalanceDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of BankBalanceDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $BankBalanceDtoCopyWith<BankBalanceDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BankBalanceDtoCopyWith<$Res> {
  factory $BankBalanceDtoCopyWith(
          BankBalanceDto value, $Res Function(BankBalanceDto) then) =
      _$BankBalanceDtoCopyWithImpl<$Res, BankBalanceDto>;
  @useResult
  $Res call(
      {@JsonKey(name: 'bank_amount_id') String? balanceId,
      @JsonKey(name: 'company_id') String companyId,
      @JsonKey(name: 'store_id') String? storeId,
      @JsonKey(name: 'location_id') String locationId,
      @JsonKey(name: 'currency_id') String currencyId,
      @JsonKey(name: 'total_amount') int totalAmount,
      @JsonKey(name: 'created_by') String userId,
      @JsonKey(name: 'record_date') DateTime recordDate,
      @JsonKey(name: 'created_at') DateTime createdAt});
}

/// @nodoc
class _$BankBalanceDtoCopyWithImpl<$Res, $Val extends BankBalanceDto>
    implements $BankBalanceDtoCopyWith<$Res> {
  _$BankBalanceDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of BankBalanceDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? balanceId = freezed,
    Object? companyId = null,
    Object? storeId = freezed,
    Object? locationId = null,
    Object? currencyId = null,
    Object? totalAmount = null,
    Object? userId = null,
    Object? recordDate = null,
    Object? createdAt = null,
  }) {
    return _then(_value.copyWith(
      balanceId: freezed == balanceId
          ? _value.balanceId
          : balanceId // ignore: cast_nullable_to_non_nullable
              as String?,
      companyId: null == companyId
          ? _value.companyId
          : companyId // ignore: cast_nullable_to_non_nullable
              as String,
      storeId: freezed == storeId
          ? _value.storeId
          : storeId // ignore: cast_nullable_to_non_nullable
              as String?,
      locationId: null == locationId
          ? _value.locationId
          : locationId // ignore: cast_nullable_to_non_nullable
              as String,
      currencyId: null == currencyId
          ? _value.currencyId
          : currencyId // ignore: cast_nullable_to_non_nullable
              as String,
      totalAmount: null == totalAmount
          ? _value.totalAmount
          : totalAmount // ignore: cast_nullable_to_non_nullable
              as int,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      recordDate: null == recordDate
          ? _value.recordDate
          : recordDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$BankBalanceDtoImplCopyWith<$Res>
    implements $BankBalanceDtoCopyWith<$Res> {
  factory _$$BankBalanceDtoImplCopyWith(_$BankBalanceDtoImpl value,
          $Res Function(_$BankBalanceDtoImpl) then) =
      __$$BankBalanceDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'bank_amount_id') String? balanceId,
      @JsonKey(name: 'company_id') String companyId,
      @JsonKey(name: 'store_id') String? storeId,
      @JsonKey(name: 'location_id') String locationId,
      @JsonKey(name: 'currency_id') String currencyId,
      @JsonKey(name: 'total_amount') int totalAmount,
      @JsonKey(name: 'created_by') String userId,
      @JsonKey(name: 'record_date') DateTime recordDate,
      @JsonKey(name: 'created_at') DateTime createdAt});
}

/// @nodoc
class __$$BankBalanceDtoImplCopyWithImpl<$Res>
    extends _$BankBalanceDtoCopyWithImpl<$Res, _$BankBalanceDtoImpl>
    implements _$$BankBalanceDtoImplCopyWith<$Res> {
  __$$BankBalanceDtoImplCopyWithImpl(
      _$BankBalanceDtoImpl _value, $Res Function(_$BankBalanceDtoImpl) _then)
      : super(_value, _then);

  /// Create a copy of BankBalanceDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? balanceId = freezed,
    Object? companyId = null,
    Object? storeId = freezed,
    Object? locationId = null,
    Object? currencyId = null,
    Object? totalAmount = null,
    Object? userId = null,
    Object? recordDate = null,
    Object? createdAt = null,
  }) {
    return _then(_$BankBalanceDtoImpl(
      balanceId: freezed == balanceId
          ? _value.balanceId
          : balanceId // ignore: cast_nullable_to_non_nullable
              as String?,
      companyId: null == companyId
          ? _value.companyId
          : companyId // ignore: cast_nullable_to_non_nullable
              as String,
      storeId: freezed == storeId
          ? _value.storeId
          : storeId // ignore: cast_nullable_to_non_nullable
              as String?,
      locationId: null == locationId
          ? _value.locationId
          : locationId // ignore: cast_nullable_to_non_nullable
              as String,
      currencyId: null == currencyId
          ? _value.currencyId
          : currencyId // ignore: cast_nullable_to_non_nullable
              as String,
      totalAmount: null == totalAmount
          ? _value.totalAmount
          : totalAmount // ignore: cast_nullable_to_non_nullable
              as int,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      recordDate: null == recordDate
          ? _value.recordDate
          : recordDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$BankBalanceDtoImpl extends _BankBalanceDto {
  const _$BankBalanceDtoImpl(
      {@JsonKey(name: 'bank_amount_id') this.balanceId,
      @JsonKey(name: 'company_id') required this.companyId,
      @JsonKey(name: 'store_id') this.storeId,
      @JsonKey(name: 'location_id') required this.locationId,
      @JsonKey(name: 'currency_id') required this.currencyId,
      @JsonKey(name: 'total_amount') required this.totalAmount,
      @JsonKey(name: 'created_by') required this.userId,
      @JsonKey(name: 'record_date') required this.recordDate,
      @JsonKey(name: 'created_at') required this.createdAt})
      : super._();

  factory _$BankBalanceDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$BankBalanceDtoImplFromJson(json);

  @override
  @JsonKey(name: 'bank_amount_id')
  final String? balanceId;
  @override
  @JsonKey(name: 'company_id')
  final String companyId;
  @override
  @JsonKey(name: 'store_id')
  final String? storeId;
  @override
  @JsonKey(name: 'location_id')
  final String locationId;
  @override
  @JsonKey(name: 'currency_id')
  final String currencyId;
  @override
  @JsonKey(name: 'total_amount')
  final int totalAmount;
  @override
  @JsonKey(name: 'created_by')
  final String userId;
  @override
  @JsonKey(name: 'record_date')
  final DateTime recordDate;
  @override
  @JsonKey(name: 'created_at')
  final DateTime createdAt;

  @override
  String toString() {
    return 'BankBalanceDto(balanceId: $balanceId, companyId: $companyId, storeId: $storeId, locationId: $locationId, currencyId: $currencyId, totalAmount: $totalAmount, userId: $userId, recordDate: $recordDate, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BankBalanceDtoImpl &&
            (identical(other.balanceId, balanceId) ||
                other.balanceId == balanceId) &&
            (identical(other.companyId, companyId) ||
                other.companyId == companyId) &&
            (identical(other.storeId, storeId) || other.storeId == storeId) &&
            (identical(other.locationId, locationId) ||
                other.locationId == locationId) &&
            (identical(other.currencyId, currencyId) ||
                other.currencyId == currencyId) &&
            (identical(other.totalAmount, totalAmount) ||
                other.totalAmount == totalAmount) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.recordDate, recordDate) ||
                other.recordDate == recordDate) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, balanceId, companyId, storeId,
      locationId, currencyId, totalAmount, userId, recordDate, createdAt);

  /// Create a copy of BankBalanceDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$BankBalanceDtoImplCopyWith<_$BankBalanceDtoImpl> get copyWith =>
      __$$BankBalanceDtoImplCopyWithImpl<_$BankBalanceDtoImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$BankBalanceDtoImplToJson(
      this,
    );
  }
}

abstract class _BankBalanceDto extends BankBalanceDto {
  const factory _BankBalanceDto(
          {@JsonKey(name: 'bank_amount_id') final String? balanceId,
          @JsonKey(name: 'company_id') required final String companyId,
          @JsonKey(name: 'store_id') final String? storeId,
          @JsonKey(name: 'location_id') required final String locationId,
          @JsonKey(name: 'currency_id') required final String currencyId,
          @JsonKey(name: 'total_amount') required final int totalAmount,
          @JsonKey(name: 'created_by') required final String userId,
          @JsonKey(name: 'record_date') required final DateTime recordDate,
          @JsonKey(name: 'created_at') required final DateTime createdAt}) =
      _$BankBalanceDtoImpl;
  const _BankBalanceDto._() : super._();

  factory _BankBalanceDto.fromJson(Map<String, dynamic> json) =
      _$BankBalanceDtoImpl.fromJson;

  @override
  @JsonKey(name: 'bank_amount_id')
  String? get balanceId;
  @override
  @JsonKey(name: 'company_id')
  String get companyId;
  @override
  @JsonKey(name: 'store_id')
  String? get storeId;
  @override
  @JsonKey(name: 'location_id')
  String get locationId;
  @override
  @JsonKey(name: 'currency_id')
  String get currencyId;
  @override
  @JsonKey(name: 'total_amount')
  int get totalAmount;
  @override
  @JsonKey(name: 'created_by')
  String get userId;
  @override
  @JsonKey(name: 'record_date')
  DateTime get recordDate;
  @override
  @JsonKey(name: 'created_at')
  DateTime get createdAt;

  /// Create a copy of BankBalanceDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BankBalanceDtoImplCopyWith<_$BankBalanceDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
