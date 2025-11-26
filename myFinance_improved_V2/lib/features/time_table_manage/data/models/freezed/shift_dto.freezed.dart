// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'shift_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ShiftDto _$ShiftDtoFromJson(Map<String, dynamic> json) {
  return _ShiftDto.fromJson(json);
}

/// @nodoc
mixin _$ShiftDto {
  @JsonKey(name: 'shift_id')
  String get shiftId => throw _privateConstructorUsedError;
  @JsonKey(name: 'store_id')
  String get storeId => throw _privateConstructorUsedError;
  @JsonKey(name: 'shift_date')
  String get shiftDate => throw _privateConstructorUsedError;
  @JsonKey(name: 'plan_start_time')
  String get planStartTime => throw _privateConstructorUsedError;
  @JsonKey(name: 'plan_end_time')
  String get planEndTime => throw _privateConstructorUsedError;
  @JsonKey(name: 'target_count')
  int get targetCount => throw _privateConstructorUsedError;
  @JsonKey(name: 'current_count')
  int get currentCount => throw _privateConstructorUsedError;
  @JsonKey(name: 'tags')
  List<String> get tags => throw _privateConstructorUsedError;
  @JsonKey(name: 'shift_name')
  String? get shiftName => throw _privateConstructorUsedError;
  @JsonKey(name: 'store_name')
  String? get storeName => throw _privateConstructorUsedError;

  /// Serializes this ShiftDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ShiftDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ShiftDtoCopyWith<ShiftDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ShiftDtoCopyWith<$Res> {
  factory $ShiftDtoCopyWith(ShiftDto value, $Res Function(ShiftDto) then) =
      _$ShiftDtoCopyWithImpl<$Res, ShiftDto>;
  @useResult
  $Res call(
      {@JsonKey(name: 'shift_id') String shiftId,
      @JsonKey(name: 'store_id') String storeId,
      @JsonKey(name: 'shift_date') String shiftDate,
      @JsonKey(name: 'plan_start_time') String planStartTime,
      @JsonKey(name: 'plan_end_time') String planEndTime,
      @JsonKey(name: 'target_count') int targetCount,
      @JsonKey(name: 'current_count') int currentCount,
      @JsonKey(name: 'tags') List<String> tags,
      @JsonKey(name: 'shift_name') String? shiftName,
      @JsonKey(name: 'store_name') String? storeName});
}

/// @nodoc
class _$ShiftDtoCopyWithImpl<$Res, $Val extends ShiftDto>
    implements $ShiftDtoCopyWith<$Res> {
  _$ShiftDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ShiftDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? shiftId = null,
    Object? storeId = null,
    Object? shiftDate = null,
    Object? planStartTime = null,
    Object? planEndTime = null,
    Object? targetCount = null,
    Object? currentCount = null,
    Object? tags = null,
    Object? shiftName = freezed,
    Object? storeName = freezed,
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
      shiftDate: null == shiftDate
          ? _value.shiftDate
          : shiftDate // ignore: cast_nullable_to_non_nullable
              as String,
      planStartTime: null == planStartTime
          ? _value.planStartTime
          : planStartTime // ignore: cast_nullable_to_non_nullable
              as String,
      planEndTime: null == planEndTime
          ? _value.planEndTime
          : planEndTime // ignore: cast_nullable_to_non_nullable
              as String,
      targetCount: null == targetCount
          ? _value.targetCount
          : targetCount // ignore: cast_nullable_to_non_nullable
              as int,
      currentCount: null == currentCount
          ? _value.currentCount
          : currentCount // ignore: cast_nullable_to_non_nullable
              as int,
      tags: null == tags
          ? _value.tags
          : tags // ignore: cast_nullable_to_non_nullable
              as List<String>,
      shiftName: freezed == shiftName
          ? _value.shiftName
          : shiftName // ignore: cast_nullable_to_non_nullable
              as String?,
      storeName: freezed == storeName
          ? _value.storeName
          : storeName // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ShiftDtoImplCopyWith<$Res>
    implements $ShiftDtoCopyWith<$Res> {
  factory _$$ShiftDtoImplCopyWith(
          _$ShiftDtoImpl value, $Res Function(_$ShiftDtoImpl) then) =
      __$$ShiftDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'shift_id') String shiftId,
      @JsonKey(name: 'store_id') String storeId,
      @JsonKey(name: 'shift_date') String shiftDate,
      @JsonKey(name: 'plan_start_time') String planStartTime,
      @JsonKey(name: 'plan_end_time') String planEndTime,
      @JsonKey(name: 'target_count') int targetCount,
      @JsonKey(name: 'current_count') int currentCount,
      @JsonKey(name: 'tags') List<String> tags,
      @JsonKey(name: 'shift_name') String? shiftName,
      @JsonKey(name: 'store_name') String? storeName});
}

/// @nodoc
class __$$ShiftDtoImplCopyWithImpl<$Res>
    extends _$ShiftDtoCopyWithImpl<$Res, _$ShiftDtoImpl>
    implements _$$ShiftDtoImplCopyWith<$Res> {
  __$$ShiftDtoImplCopyWithImpl(
      _$ShiftDtoImpl _value, $Res Function(_$ShiftDtoImpl) _then)
      : super(_value, _then);

  /// Create a copy of ShiftDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? shiftId = null,
    Object? storeId = null,
    Object? shiftDate = null,
    Object? planStartTime = null,
    Object? planEndTime = null,
    Object? targetCount = null,
    Object? currentCount = null,
    Object? tags = null,
    Object? shiftName = freezed,
    Object? storeName = freezed,
  }) {
    return _then(_$ShiftDtoImpl(
      shiftId: null == shiftId
          ? _value.shiftId
          : shiftId // ignore: cast_nullable_to_non_nullable
              as String,
      storeId: null == storeId
          ? _value.storeId
          : storeId // ignore: cast_nullable_to_non_nullable
              as String,
      shiftDate: null == shiftDate
          ? _value.shiftDate
          : shiftDate // ignore: cast_nullable_to_non_nullable
              as String,
      planStartTime: null == planStartTime
          ? _value.planStartTime
          : planStartTime // ignore: cast_nullable_to_non_nullable
              as String,
      planEndTime: null == planEndTime
          ? _value.planEndTime
          : planEndTime // ignore: cast_nullable_to_non_nullable
              as String,
      targetCount: null == targetCount
          ? _value.targetCount
          : targetCount // ignore: cast_nullable_to_non_nullable
              as int,
      currentCount: null == currentCount
          ? _value.currentCount
          : currentCount // ignore: cast_nullable_to_non_nullable
              as int,
      tags: null == tags
          ? _value._tags
          : tags // ignore: cast_nullable_to_non_nullable
              as List<String>,
      shiftName: freezed == shiftName
          ? _value.shiftName
          : shiftName // ignore: cast_nullable_to_non_nullable
              as String?,
      storeName: freezed == storeName
          ? _value.storeName
          : storeName // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ShiftDtoImpl implements _ShiftDto {
  const _$ShiftDtoImpl(
      {@JsonKey(name: 'shift_id') this.shiftId = '',
      @JsonKey(name: 'store_id') this.storeId = '',
      @JsonKey(name: 'shift_date') this.shiftDate = '',
      @JsonKey(name: 'plan_start_time') this.planStartTime = '',
      @JsonKey(name: 'plan_end_time') this.planEndTime = '',
      @JsonKey(name: 'target_count') this.targetCount = 0,
      @JsonKey(name: 'current_count') this.currentCount = 0,
      @JsonKey(name: 'tags') final List<String> tags = const [],
      @JsonKey(name: 'shift_name') this.shiftName,
      @JsonKey(name: 'store_name') this.storeName})
      : _tags = tags;

  factory _$ShiftDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$ShiftDtoImplFromJson(json);

  @override
  @JsonKey(name: 'shift_id')
  final String shiftId;
  @override
  @JsonKey(name: 'store_id')
  final String storeId;
  @override
  @JsonKey(name: 'shift_date')
  final String shiftDate;
  @override
  @JsonKey(name: 'plan_start_time')
  final String planStartTime;
  @override
  @JsonKey(name: 'plan_end_time')
  final String planEndTime;
  @override
  @JsonKey(name: 'target_count')
  final int targetCount;
  @override
  @JsonKey(name: 'current_count')
  final int currentCount;
  final List<String> _tags;
  @override
  @JsonKey(name: 'tags')
  List<String> get tags {
    if (_tags is EqualUnmodifiableListView) return _tags;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_tags);
  }

  @override
  @JsonKey(name: 'shift_name')
  final String? shiftName;
  @override
  @JsonKey(name: 'store_name')
  final String? storeName;

  @override
  String toString() {
    return 'ShiftDto(shiftId: $shiftId, storeId: $storeId, shiftDate: $shiftDate, planStartTime: $planStartTime, planEndTime: $planEndTime, targetCount: $targetCount, currentCount: $currentCount, tags: $tags, shiftName: $shiftName, storeName: $storeName)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ShiftDtoImpl &&
            (identical(other.shiftId, shiftId) || other.shiftId == shiftId) &&
            (identical(other.storeId, storeId) || other.storeId == storeId) &&
            (identical(other.shiftDate, shiftDate) ||
                other.shiftDate == shiftDate) &&
            (identical(other.planStartTime, planStartTime) ||
                other.planStartTime == planStartTime) &&
            (identical(other.planEndTime, planEndTime) ||
                other.planEndTime == planEndTime) &&
            (identical(other.targetCount, targetCount) ||
                other.targetCount == targetCount) &&
            (identical(other.currentCount, currentCount) ||
                other.currentCount == currentCount) &&
            const DeepCollectionEquality().equals(other._tags, _tags) &&
            (identical(other.shiftName, shiftName) ||
                other.shiftName == shiftName) &&
            (identical(other.storeName, storeName) ||
                other.storeName == storeName));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      shiftId,
      storeId,
      shiftDate,
      planStartTime,
      planEndTime,
      targetCount,
      currentCount,
      const DeepCollectionEquality().hash(_tags),
      shiftName,
      storeName);

  /// Create a copy of ShiftDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ShiftDtoImplCopyWith<_$ShiftDtoImpl> get copyWith =>
      __$$ShiftDtoImplCopyWithImpl<_$ShiftDtoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ShiftDtoImplToJson(
      this,
    );
  }
}

abstract class _ShiftDto implements ShiftDto {
  const factory _ShiftDto(
      {@JsonKey(name: 'shift_id') final String shiftId,
      @JsonKey(name: 'store_id') final String storeId,
      @JsonKey(name: 'shift_date') final String shiftDate,
      @JsonKey(name: 'plan_start_time') final String planStartTime,
      @JsonKey(name: 'plan_end_time') final String planEndTime,
      @JsonKey(name: 'target_count') final int targetCount,
      @JsonKey(name: 'current_count') final int currentCount,
      @JsonKey(name: 'tags') final List<String> tags,
      @JsonKey(name: 'shift_name') final String? shiftName,
      @JsonKey(name: 'store_name') final String? storeName}) = _$ShiftDtoImpl;

  factory _ShiftDto.fromJson(Map<String, dynamic> json) =
      _$ShiftDtoImpl.fromJson;

  @override
  @JsonKey(name: 'shift_id')
  String get shiftId;
  @override
  @JsonKey(name: 'store_id')
  String get storeId;
  @override
  @JsonKey(name: 'shift_date')
  String get shiftDate;
  @override
  @JsonKey(name: 'plan_start_time')
  String get planStartTime;
  @override
  @JsonKey(name: 'plan_end_time')
  String get planEndTime;
  @override
  @JsonKey(name: 'target_count')
  int get targetCount;
  @override
  @JsonKey(name: 'current_count')
  int get currentCount;
  @override
  @JsonKey(name: 'tags')
  List<String> get tags;
  @override
  @JsonKey(name: 'shift_name')
  String? get shiftName;
  @override
  @JsonKey(name: 'store_name')
  String? get storeName;

  /// Create a copy of ShiftDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ShiftDtoImplCopyWith<_$ShiftDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
