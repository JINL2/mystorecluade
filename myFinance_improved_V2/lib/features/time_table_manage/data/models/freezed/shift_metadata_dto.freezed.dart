// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'shift_metadata_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ShiftMetadataDto _$ShiftMetadataDtoFromJson(Map<String, dynamic> json) {
  return _ShiftMetadataDto.fromJson(json);
}

/// @nodoc
mixin _$ShiftMetadataDto {
  @JsonKey(name: 'shift_id')
  String get shiftId => throw _privateConstructorUsedError;
  @JsonKey(name: 'store_id')
  String get storeId => throw _privateConstructorUsedError;
  @JsonKey(name: 'shift_name')
  String get shiftName => throw _privateConstructorUsedError;
  @JsonKey(name: 'start_time')
  String get startTime => throw _privateConstructorUsedError;
  @JsonKey(name: 'end_time')
  String get endTime => throw _privateConstructorUsedError;
  @JsonKey(name: 'number_shift')
  int get numberShift => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_active')
  bool get isActive => throw _privateConstructorUsedError;

  /// Serializes this ShiftMetadataDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ShiftMetadataDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ShiftMetadataDtoCopyWith<ShiftMetadataDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ShiftMetadataDtoCopyWith<$Res> {
  factory $ShiftMetadataDtoCopyWith(
          ShiftMetadataDto value, $Res Function(ShiftMetadataDto) then) =
      _$ShiftMetadataDtoCopyWithImpl<$Res, ShiftMetadataDto>;
  @useResult
  $Res call(
      {@JsonKey(name: 'shift_id') String shiftId,
      @JsonKey(name: 'store_id') String storeId,
      @JsonKey(name: 'shift_name') String shiftName,
      @JsonKey(name: 'start_time') String startTime,
      @JsonKey(name: 'end_time') String endTime,
      @JsonKey(name: 'number_shift') int numberShift,
      @JsonKey(name: 'is_active') bool isActive});
}

/// @nodoc
class _$ShiftMetadataDtoCopyWithImpl<$Res, $Val extends ShiftMetadataDto>
    implements $ShiftMetadataDtoCopyWith<$Res> {
  _$ShiftMetadataDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ShiftMetadataDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? shiftId = null,
    Object? storeId = null,
    Object? shiftName = null,
    Object? startTime = null,
    Object? endTime = null,
    Object? numberShift = null,
    Object? isActive = null,
  }) {
    return _then(_value.copyWith(
      shiftId: null == shiftId
          ? _value.shiftId
          : shiftId // ignore: cast_nullable_to_non_nullable
              as String,
      storeId: null == storeId
          ? _value.storeId
          : storeId // ignore: cast_nullable_to_non_nullable
              as String,
      shiftName: null == shiftName
          ? _value.shiftName
          : shiftName // ignore: cast_nullable_to_non_nullable
              as String,
      startTime: null == startTime
          ? _value.startTime
          : startTime // ignore: cast_nullable_to_non_nullable
              as String,
      endTime: null == endTime
          ? _value.endTime
          : endTime // ignore: cast_nullable_to_non_nullable
              as String,
      numberShift: null == numberShift
          ? _value.numberShift
          : numberShift // ignore: cast_nullable_to_non_nullable
              as int,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ShiftMetadataDtoImplCopyWith<$Res>
    implements $ShiftMetadataDtoCopyWith<$Res> {
  factory _$$ShiftMetadataDtoImplCopyWith(_$ShiftMetadataDtoImpl value,
          $Res Function(_$ShiftMetadataDtoImpl) then) =
      __$$ShiftMetadataDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'shift_id') String shiftId,
      @JsonKey(name: 'store_id') String storeId,
      @JsonKey(name: 'shift_name') String shiftName,
      @JsonKey(name: 'start_time') String startTime,
      @JsonKey(name: 'end_time') String endTime,
      @JsonKey(name: 'number_shift') int numberShift,
      @JsonKey(name: 'is_active') bool isActive});
}

/// @nodoc
class __$$ShiftMetadataDtoImplCopyWithImpl<$Res>
    extends _$ShiftMetadataDtoCopyWithImpl<$Res, _$ShiftMetadataDtoImpl>
    implements _$$ShiftMetadataDtoImplCopyWith<$Res> {
  __$$ShiftMetadataDtoImplCopyWithImpl(_$ShiftMetadataDtoImpl _value,
      $Res Function(_$ShiftMetadataDtoImpl) _then)
      : super(_value, _then);

  /// Create a copy of ShiftMetadataDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? shiftId = null,
    Object? storeId = null,
    Object? shiftName = null,
    Object? startTime = null,
    Object? endTime = null,
    Object? numberShift = null,
    Object? isActive = null,
  }) {
    return _then(_$ShiftMetadataDtoImpl(
      shiftId: null == shiftId
          ? _value.shiftId
          : shiftId // ignore: cast_nullable_to_non_nullable
              as String,
      storeId: null == storeId
          ? _value.storeId
          : storeId // ignore: cast_nullable_to_non_nullable
              as String,
      shiftName: null == shiftName
          ? _value.shiftName
          : shiftName // ignore: cast_nullable_to_non_nullable
              as String,
      startTime: null == startTime
          ? _value.startTime
          : startTime // ignore: cast_nullable_to_non_nullable
              as String,
      endTime: null == endTime
          ? _value.endTime
          : endTime // ignore: cast_nullable_to_non_nullable
              as String,
      numberShift: null == numberShift
          ? _value.numberShift
          : numberShift // ignore: cast_nullable_to_non_nullable
              as int,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ShiftMetadataDtoImpl implements _ShiftMetadataDto {
  const _$ShiftMetadataDtoImpl(
      {@JsonKey(name: 'shift_id') this.shiftId = '',
      @JsonKey(name: 'store_id') this.storeId = '',
      @JsonKey(name: 'shift_name') this.shiftName = '',
      @JsonKey(name: 'start_time') this.startTime = '',
      @JsonKey(name: 'end_time') this.endTime = '',
      @JsonKey(name: 'number_shift') this.numberShift = 0,
      @JsonKey(name: 'is_active') this.isActive = true});

  factory _$ShiftMetadataDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$ShiftMetadataDtoImplFromJson(json);

  @override
  @JsonKey(name: 'shift_id')
  final String shiftId;
  @override
  @JsonKey(name: 'store_id')
  final String storeId;
  @override
  @JsonKey(name: 'shift_name')
  final String shiftName;
  @override
  @JsonKey(name: 'start_time')
  final String startTime;
  @override
  @JsonKey(name: 'end_time')
  final String endTime;
  @override
  @JsonKey(name: 'number_shift')
  final int numberShift;
  @override
  @JsonKey(name: 'is_active')
  final bool isActive;

  @override
  String toString() {
    return 'ShiftMetadataDto(shiftId: $shiftId, storeId: $storeId, shiftName: $shiftName, startTime: $startTime, endTime: $endTime, numberShift: $numberShift, isActive: $isActive)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ShiftMetadataDtoImpl &&
            (identical(other.shiftId, shiftId) || other.shiftId == shiftId) &&
            (identical(other.storeId, storeId) || other.storeId == storeId) &&
            (identical(other.shiftName, shiftName) ||
                other.shiftName == shiftName) &&
            (identical(other.startTime, startTime) ||
                other.startTime == startTime) &&
            (identical(other.endTime, endTime) || other.endTime == endTime) &&
            (identical(other.numberShift, numberShift) ||
                other.numberShift == numberShift) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, shiftId, storeId, shiftName,
      startTime, endTime, numberShift, isActive);

  /// Create a copy of ShiftMetadataDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ShiftMetadataDtoImplCopyWith<_$ShiftMetadataDtoImpl> get copyWith =>
      __$$ShiftMetadataDtoImplCopyWithImpl<_$ShiftMetadataDtoImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ShiftMetadataDtoImplToJson(
      this,
    );
  }
}

abstract class _ShiftMetadataDto implements ShiftMetadataDto {
  const factory _ShiftMetadataDto(
          {@JsonKey(name: 'shift_id') final String shiftId,
          @JsonKey(name: 'store_id') final String storeId,
          @JsonKey(name: 'shift_name') final String shiftName,
          @JsonKey(name: 'start_time') final String startTime,
          @JsonKey(name: 'end_time') final String endTime,
          @JsonKey(name: 'number_shift') final int numberShift,
          @JsonKey(name: 'is_active') final bool isActive}) =
      _$ShiftMetadataDtoImpl;

  factory _ShiftMetadataDto.fromJson(Map<String, dynamic> json) =
      _$ShiftMetadataDtoImpl.fromJson;

  @override
  @JsonKey(name: 'shift_id')
  String get shiftId;
  @override
  @JsonKey(name: 'store_id')
  String get storeId;
  @override
  @JsonKey(name: 'shift_name')
  String get shiftName;
  @override
  @JsonKey(name: 'start_time')
  String get startTime;
  @override
  @JsonKey(name: 'end_time')
  String get endTime;
  @override
  @JsonKey(name: 'number_shift')
  int get numberShift;
  @override
  @JsonKey(name: 'is_active')
  bool get isActive;

  /// Create a copy of ShiftMetadataDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ShiftMetadataDtoImplCopyWith<_$ShiftMetadataDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
