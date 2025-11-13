// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'store_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

StoreModel _$StoreModelFromJson(Map<String, dynamic> json) {
  return _StoreModel.fromJson(json);
}

/// @nodoc
mixin _$StoreModel {
  @JsonKey(name: 'store_id')
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'store_name')
  String get name => throw _privateConstructorUsedError;
  @JsonKey(name: 'store_code')
  String get code => throw _privateConstructorUsedError;
  @JsonKey(name: 'company_id')
  String get companyId => throw _privateConstructorUsedError;
  @JsonKey(name: 'store_address')
  String? get address => throw _privateConstructorUsedError;
  @JsonKey(name: 'store_phone')
  String? get phone => throw _privateConstructorUsedError;
  @JsonKey(name: 'huddle_time')
  int? get huddleTime => throw _privateConstructorUsedError;
  @JsonKey(name: 'payment_time')
  int? get paymentTime => throw _privateConstructorUsedError;
  @JsonKey(name: 'allowed_distance')
  int? get allowedDistance => throw _privateConstructorUsedError;

  /// Serializes this StoreModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of StoreModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $StoreModelCopyWith<StoreModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $StoreModelCopyWith<$Res> {
  factory $StoreModelCopyWith(
          StoreModel value, $Res Function(StoreModel) then) =
      _$StoreModelCopyWithImpl<$Res, StoreModel>;
  @useResult
  $Res call(
      {@JsonKey(name: 'store_id') String id,
      @JsonKey(name: 'store_name') String name,
      @JsonKey(name: 'store_code') String code,
      @JsonKey(name: 'company_id') String companyId,
      @JsonKey(name: 'store_address') String? address,
      @JsonKey(name: 'store_phone') String? phone,
      @JsonKey(name: 'huddle_time') int? huddleTime,
      @JsonKey(name: 'payment_time') int? paymentTime,
      @JsonKey(name: 'allowed_distance') int? allowedDistance});
}

/// @nodoc
class _$StoreModelCopyWithImpl<$Res, $Val extends StoreModel>
    implements $StoreModelCopyWith<$Res> {
  _$StoreModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of StoreModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? code = null,
    Object? companyId = null,
    Object? address = freezed,
    Object? phone = freezed,
    Object? huddleTime = freezed,
    Object? paymentTime = freezed,
    Object? allowedDistance = freezed,
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
      code: null == code
          ? _value.code
          : code // ignore: cast_nullable_to_non_nullable
              as String,
      companyId: null == companyId
          ? _value.companyId
          : companyId // ignore: cast_nullable_to_non_nullable
              as String,
      address: freezed == address
          ? _value.address
          : address // ignore: cast_nullable_to_non_nullable
              as String?,
      phone: freezed == phone
          ? _value.phone
          : phone // ignore: cast_nullable_to_non_nullable
              as String?,
      huddleTime: freezed == huddleTime
          ? _value.huddleTime
          : huddleTime // ignore: cast_nullable_to_non_nullable
              as int?,
      paymentTime: freezed == paymentTime
          ? _value.paymentTime
          : paymentTime // ignore: cast_nullable_to_non_nullable
              as int?,
      allowedDistance: freezed == allowedDistance
          ? _value.allowedDistance
          : allowedDistance // ignore: cast_nullable_to_non_nullable
              as int?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$StoreModelImplCopyWith<$Res>
    implements $StoreModelCopyWith<$Res> {
  factory _$$StoreModelImplCopyWith(
          _$StoreModelImpl value, $Res Function(_$StoreModelImpl) then) =
      __$$StoreModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'store_id') String id,
      @JsonKey(name: 'store_name') String name,
      @JsonKey(name: 'store_code') String code,
      @JsonKey(name: 'company_id') String companyId,
      @JsonKey(name: 'store_address') String? address,
      @JsonKey(name: 'store_phone') String? phone,
      @JsonKey(name: 'huddle_time') int? huddleTime,
      @JsonKey(name: 'payment_time') int? paymentTime,
      @JsonKey(name: 'allowed_distance') int? allowedDistance});
}

/// @nodoc
class __$$StoreModelImplCopyWithImpl<$Res>
    extends _$StoreModelCopyWithImpl<$Res, _$StoreModelImpl>
    implements _$$StoreModelImplCopyWith<$Res> {
  __$$StoreModelImplCopyWithImpl(
      _$StoreModelImpl _value, $Res Function(_$StoreModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of StoreModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? code = null,
    Object? companyId = null,
    Object? address = freezed,
    Object? phone = freezed,
    Object? huddleTime = freezed,
    Object? paymentTime = freezed,
    Object? allowedDistance = freezed,
  }) {
    return _then(_$StoreModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      code: null == code
          ? _value.code
          : code // ignore: cast_nullable_to_non_nullable
              as String,
      companyId: null == companyId
          ? _value.companyId
          : companyId // ignore: cast_nullable_to_non_nullable
              as String,
      address: freezed == address
          ? _value.address
          : address // ignore: cast_nullable_to_non_nullable
              as String?,
      phone: freezed == phone
          ? _value.phone
          : phone // ignore: cast_nullable_to_non_nullable
              as String?,
      huddleTime: freezed == huddleTime
          ? _value.huddleTime
          : huddleTime // ignore: cast_nullable_to_non_nullable
              as int?,
      paymentTime: freezed == paymentTime
          ? _value.paymentTime
          : paymentTime // ignore: cast_nullable_to_non_nullable
              as int?,
      allowedDistance: freezed == allowedDistance
          ? _value.allowedDistance
          : allowedDistance // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$StoreModelImpl extends _StoreModel {
  const _$StoreModelImpl(
      {@JsonKey(name: 'store_id') required this.id,
      @JsonKey(name: 'store_name') required this.name,
      @JsonKey(name: 'store_code') required this.code,
      @JsonKey(name: 'company_id') required this.companyId,
      @JsonKey(name: 'store_address') this.address,
      @JsonKey(name: 'store_phone') this.phone,
      @JsonKey(name: 'huddle_time') this.huddleTime,
      @JsonKey(name: 'payment_time') this.paymentTime,
      @JsonKey(name: 'allowed_distance') this.allowedDistance})
      : super._();

  factory _$StoreModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$StoreModelImplFromJson(json);

  @override
  @JsonKey(name: 'store_id')
  final String id;
  @override
  @JsonKey(name: 'store_name')
  final String name;
  @override
  @JsonKey(name: 'store_code')
  final String code;
  @override
  @JsonKey(name: 'company_id')
  final String companyId;
  @override
  @JsonKey(name: 'store_address')
  final String? address;
  @override
  @JsonKey(name: 'store_phone')
  final String? phone;
  @override
  @JsonKey(name: 'huddle_time')
  final int? huddleTime;
  @override
  @JsonKey(name: 'payment_time')
  final int? paymentTime;
  @override
  @JsonKey(name: 'allowed_distance')
  final int? allowedDistance;

  @override
  String toString() {
    return 'StoreModel(id: $id, name: $name, code: $code, companyId: $companyId, address: $address, phone: $phone, huddleTime: $huddleTime, paymentTime: $paymentTime, allowedDistance: $allowedDistance)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$StoreModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.code, code) || other.code == code) &&
            (identical(other.companyId, companyId) ||
                other.companyId == companyId) &&
            (identical(other.address, address) || other.address == address) &&
            (identical(other.phone, phone) || other.phone == phone) &&
            (identical(other.huddleTime, huddleTime) ||
                other.huddleTime == huddleTime) &&
            (identical(other.paymentTime, paymentTime) ||
                other.paymentTime == paymentTime) &&
            (identical(other.allowedDistance, allowedDistance) ||
                other.allowedDistance == allowedDistance));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, name, code, companyId,
      address, phone, huddleTime, paymentTime, allowedDistance);

  /// Create a copy of StoreModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$StoreModelImplCopyWith<_$StoreModelImpl> get copyWith =>
      __$$StoreModelImplCopyWithImpl<_$StoreModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$StoreModelImplToJson(
      this,
    );
  }
}

abstract class _StoreModel extends StoreModel {
  const factory _StoreModel(
          {@JsonKey(name: 'store_id') required final String id,
          @JsonKey(name: 'store_name') required final String name,
          @JsonKey(name: 'store_code') required final String code,
          @JsonKey(name: 'company_id') required final String companyId,
          @JsonKey(name: 'store_address') final String? address,
          @JsonKey(name: 'store_phone') final String? phone,
          @JsonKey(name: 'huddle_time') final int? huddleTime,
          @JsonKey(name: 'payment_time') final int? paymentTime,
          @JsonKey(name: 'allowed_distance') final int? allowedDistance}) =
      _$StoreModelImpl;
  const _StoreModel._() : super._();

  factory _StoreModel.fromJson(Map<String, dynamic> json) =
      _$StoreModelImpl.fromJson;

  @override
  @JsonKey(name: 'store_id')
  String get id;
  @override
  @JsonKey(name: 'store_name')
  String get name;
  @override
  @JsonKey(name: 'store_code')
  String get code;
  @override
  @JsonKey(name: 'company_id')
  String get companyId;
  @override
  @JsonKey(name: 'store_address')
  String? get address;
  @override
  @JsonKey(name: 'store_phone')
  String? get phone;
  @override
  @JsonKey(name: 'huddle_time')
  int? get huddleTime;
  @override
  @JsonKey(name: 'payment_time')
  int? get paymentTime;
  @override
  @JsonKey(name: 'allowed_distance')
  int? get allowedDistance;

  /// Create a copy of StoreModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$StoreModelImplCopyWith<_$StoreModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
