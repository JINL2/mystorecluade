// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'shift.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Shift _$ShiftFromJson(Map<String, dynamic> json) {
  return _Shift.fromJson(json);
}

/// @nodoc
mixin _$Shift {
  @JsonKey(name: 'shift_id', defaultValue: '')
  String get shiftId => throw _privateConstructorUsedError;
  @JsonKey(name: 'store_id', defaultValue: '')
  String get storeId => throw _privateConstructorUsedError;
  @JsonKey(name: 'shift_date', defaultValue: '')
  String get shiftDate => throw _privateConstructorUsedError;
  @JsonKey(
      name: 'plan_start_time',
      fromJson: _parseStartTime,
      toJson: _serializeTime)
  DateTime? get planStartTime => throw _privateConstructorUsedError;
  @JsonKey(
      name: 'plan_end_time', fromJson: _parseEndTime, toJson: _serializeTime)
  DateTime? get planEndTime => throw _privateConstructorUsedError;
  @JsonKey(name: 'target_count', defaultValue: 0)
  int get targetCount => throw _privateConstructorUsedError;
  @JsonKey(name: 'current_count', defaultValue: 0)
  int get currentCount => throw _privateConstructorUsedError;
  @JsonKey(defaultValue: <String>[])
  List<String> get tags => throw _privateConstructorUsedError;
  @JsonKey(name: 'shift_name')
  String? get shiftName => throw _privateConstructorUsedError;

  /// Serializes this Shift to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Shift
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ShiftCopyWith<Shift> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ShiftCopyWith<$Res> {
  factory $ShiftCopyWith(Shift value, $Res Function(Shift) then) =
      _$ShiftCopyWithImpl<$Res, Shift>;
  @useResult
  $Res call(
      {@JsonKey(name: 'shift_id', defaultValue: '') String shiftId,
      @JsonKey(name: 'store_id', defaultValue: '') String storeId,
      @JsonKey(name: 'shift_date', defaultValue: '') String shiftDate,
      @JsonKey(
          name: 'plan_start_time',
          fromJson: _parseStartTime,
          toJson: _serializeTime)
      DateTime? planStartTime,
      @JsonKey(
          name: 'plan_end_time',
          fromJson: _parseEndTime,
          toJson: _serializeTime)
      DateTime? planEndTime,
      @JsonKey(name: 'target_count', defaultValue: 0) int targetCount,
      @JsonKey(name: 'current_count', defaultValue: 0) int currentCount,
      @JsonKey(defaultValue: <String>[]) List<String> tags,
      @JsonKey(name: 'shift_name') String? shiftName});
}

/// @nodoc
class _$ShiftCopyWithImpl<$Res, $Val extends Shift>
    implements $ShiftCopyWith<$Res> {
  _$ShiftCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Shift
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? shiftId = null,
    Object? storeId = null,
    Object? shiftDate = null,
    Object? planStartTime = freezed,
    Object? planEndTime = freezed,
    Object? targetCount = null,
    Object? currentCount = null,
    Object? tags = null,
    Object? shiftName = freezed,
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
      planStartTime: freezed == planStartTime
          ? _value.planStartTime
          : planStartTime // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      planEndTime: freezed == planEndTime
          ? _value.planEndTime
          : planEndTime // ignore: cast_nullable_to_non_nullable
              as DateTime?,
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
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ShiftImplCopyWith<$Res> implements $ShiftCopyWith<$Res> {
  factory _$$ShiftImplCopyWith(
          _$ShiftImpl value, $Res Function(_$ShiftImpl) then) =
      __$$ShiftImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'shift_id', defaultValue: '') String shiftId,
      @JsonKey(name: 'store_id', defaultValue: '') String storeId,
      @JsonKey(name: 'shift_date', defaultValue: '') String shiftDate,
      @JsonKey(
          name: 'plan_start_time',
          fromJson: _parseStartTime,
          toJson: _serializeTime)
      DateTime? planStartTime,
      @JsonKey(
          name: 'plan_end_time',
          fromJson: _parseEndTime,
          toJson: _serializeTime)
      DateTime? planEndTime,
      @JsonKey(name: 'target_count', defaultValue: 0) int targetCount,
      @JsonKey(name: 'current_count', defaultValue: 0) int currentCount,
      @JsonKey(defaultValue: <String>[]) List<String> tags,
      @JsonKey(name: 'shift_name') String? shiftName});
}

/// @nodoc
class __$$ShiftImplCopyWithImpl<$Res>
    extends _$ShiftCopyWithImpl<$Res, _$ShiftImpl>
    implements _$$ShiftImplCopyWith<$Res> {
  __$$ShiftImplCopyWithImpl(
      _$ShiftImpl _value, $Res Function(_$ShiftImpl) _then)
      : super(_value, _then);

  /// Create a copy of Shift
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? shiftId = null,
    Object? storeId = null,
    Object? shiftDate = null,
    Object? planStartTime = freezed,
    Object? planEndTime = freezed,
    Object? targetCount = null,
    Object? currentCount = null,
    Object? tags = null,
    Object? shiftName = freezed,
  }) {
    return _then(_$ShiftImpl(
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
      planStartTime: freezed == planStartTime
          ? _value.planStartTime
          : planStartTime // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      planEndTime: freezed == planEndTime
          ? _value.planEndTime
          : planEndTime // ignore: cast_nullable_to_non_nullable
              as DateTime?,
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
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ShiftImpl extends _Shift {
  const _$ShiftImpl(
      {@JsonKey(name: 'shift_id', defaultValue: '') required this.shiftId,
      @JsonKey(name: 'store_id', defaultValue: '') required this.storeId,
      @JsonKey(name: 'shift_date', defaultValue: '') required this.shiftDate,
      @JsonKey(
          name: 'plan_start_time',
          fromJson: _parseStartTime,
          toJson: _serializeTime)
      this.planStartTime,
      @JsonKey(
          name: 'plan_end_time',
          fromJson: _parseEndTime,
          toJson: _serializeTime)
      this.planEndTime,
      @JsonKey(name: 'target_count', defaultValue: 0) required this.targetCount,
      @JsonKey(name: 'current_count', defaultValue: 0)
      required this.currentCount,
      @JsonKey(defaultValue: <String>[]) required final List<String> tags,
      @JsonKey(name: 'shift_name') this.shiftName})
      : _tags = tags,
        super._();

  factory _$ShiftImpl.fromJson(Map<String, dynamic> json) =>
      _$$ShiftImplFromJson(json);

  @override
  @JsonKey(name: 'shift_id', defaultValue: '')
  final String shiftId;
  @override
  @JsonKey(name: 'store_id', defaultValue: '')
  final String storeId;
  @override
  @JsonKey(name: 'shift_date', defaultValue: '')
  final String shiftDate;
  @override
  @JsonKey(
      name: 'plan_start_time',
      fromJson: _parseStartTime,
      toJson: _serializeTime)
  final DateTime? planStartTime;
  @override
  @JsonKey(
      name: 'plan_end_time', fromJson: _parseEndTime, toJson: _serializeTime)
  final DateTime? planEndTime;
  @override
  @JsonKey(name: 'target_count', defaultValue: 0)
  final int targetCount;
  @override
  @JsonKey(name: 'current_count', defaultValue: 0)
  final int currentCount;
  final List<String> _tags;
  @override
  @JsonKey(defaultValue: <String>[])
  List<String> get tags {
    if (_tags is EqualUnmodifiableListView) return _tags;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_tags);
  }

  @override
  @JsonKey(name: 'shift_name')
  final String? shiftName;

  @override
  String toString() {
    return 'Shift(shiftId: $shiftId, storeId: $storeId, shiftDate: $shiftDate, planStartTime: $planStartTime, planEndTime: $planEndTime, targetCount: $targetCount, currentCount: $currentCount, tags: $tags, shiftName: $shiftName)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ShiftImpl &&
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
                other.shiftName == shiftName));
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
      shiftName);

  /// Create a copy of Shift
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ShiftImplCopyWith<_$ShiftImpl> get copyWith =>
      __$$ShiftImplCopyWithImpl<_$ShiftImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ShiftImplToJson(
      this,
    );
  }
}

abstract class _Shift extends Shift {
  const factory _Shift(
      {@JsonKey(name: 'shift_id', defaultValue: '')
      required final String shiftId,
      @JsonKey(name: 'store_id', defaultValue: '')
      required final String storeId,
      @JsonKey(name: 'shift_date', defaultValue: '')
      required final String shiftDate,
      @JsonKey(
          name: 'plan_start_time',
          fromJson: _parseStartTime,
          toJson: _serializeTime)
      final DateTime? planStartTime,
      @JsonKey(
          name: 'plan_end_time',
          fromJson: _parseEndTime,
          toJson: _serializeTime)
      final DateTime? planEndTime,
      @JsonKey(name: 'target_count', defaultValue: 0)
      required final int targetCount,
      @JsonKey(name: 'current_count', defaultValue: 0)
      required final int currentCount,
      @JsonKey(defaultValue: <String>[]) required final List<String> tags,
      @JsonKey(name: 'shift_name') final String? shiftName}) = _$ShiftImpl;
  const _Shift._() : super._();

  factory _Shift.fromJson(Map<String, dynamic> json) = _$ShiftImpl.fromJson;

  @override
  @JsonKey(name: 'shift_id', defaultValue: '')
  String get shiftId;
  @override
  @JsonKey(name: 'store_id', defaultValue: '')
  String get storeId;
  @override
  @JsonKey(name: 'shift_date', defaultValue: '')
  String get shiftDate;
  @override
  @JsonKey(
      name: 'plan_start_time',
      fromJson: _parseStartTime,
      toJson: _serializeTime)
  DateTime? get planStartTime;
  @override
  @JsonKey(
      name: 'plan_end_time', fromJson: _parseEndTime, toJson: _serializeTime)
  DateTime? get planEndTime;
  @override
  @JsonKey(name: 'target_count', defaultValue: 0)
  int get targetCount;
  @override
  @JsonKey(name: 'current_count', defaultValue: 0)
  int get currentCount;
  @override
  @JsonKey(defaultValue: <String>[])
  List<String> get tags;
  @override
  @JsonKey(name: 'shift_name')
  String? get shiftName;

  /// Create a copy of Shift
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ShiftImplCopyWith<_$ShiftImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
