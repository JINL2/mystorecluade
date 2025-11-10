// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'shift_metadata_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ShiftMetadataModel _$ShiftMetadataModelFromJson(Map<String, dynamic> json) {
  return _ShiftMetadataModel.fromJson(json);
}

/// @nodoc
mixin _$ShiftMetadataModel {
  @JsonKey(name: 'shift_id')
  String get shiftId => throw _privateConstructorUsedError;
  @JsonKey(name: 'shift_name')
  String get shiftName => throw _privateConstructorUsedError;
  @JsonKey(name: 'start_time')
  String get startTime => throw _privateConstructorUsedError;
  @JsonKey(name: 'end_time')
  String get endTime => throw _privateConstructorUsedError;
  @JsonKey(name: 'description')
  String? get description => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_active')
  bool get isActive => throw _privateConstructorUsedError;

  /// Serializes this ShiftMetadataModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ShiftMetadataModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ShiftMetadataModelCopyWith<ShiftMetadataModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ShiftMetadataModelCopyWith<$Res> {
  factory $ShiftMetadataModelCopyWith(
          ShiftMetadataModel value, $Res Function(ShiftMetadataModel) then) =
      _$ShiftMetadataModelCopyWithImpl<$Res, ShiftMetadataModel>;
  @useResult
  $Res call(
      {@JsonKey(name: 'shift_id') String shiftId,
      @JsonKey(name: 'shift_name') String shiftName,
      @JsonKey(name: 'start_time') String startTime,
      @JsonKey(name: 'end_time') String endTime,
      @JsonKey(name: 'description') String? description,
      @JsonKey(name: 'is_active') bool isActive});
}

/// @nodoc
class _$ShiftMetadataModelCopyWithImpl<$Res, $Val extends ShiftMetadataModel>
    implements $ShiftMetadataModelCopyWith<$Res> {
  _$ShiftMetadataModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ShiftMetadataModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? shiftId = null,
    Object? shiftName = null,
    Object? startTime = null,
    Object? endTime = null,
    Object? description = freezed,
    Object? isActive = null,
  }) {
    return _then(_value.copyWith(
      shiftId: null == shiftId
          ? _value.shiftId
          : shiftId // ignore: cast_nullable_to_non_nullable
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
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ShiftMetadataModelImplCopyWith<$Res>
    implements $ShiftMetadataModelCopyWith<$Res> {
  factory _$$ShiftMetadataModelImplCopyWith(_$ShiftMetadataModelImpl value,
          $Res Function(_$ShiftMetadataModelImpl) then) =
      __$$ShiftMetadataModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'shift_id') String shiftId,
      @JsonKey(name: 'shift_name') String shiftName,
      @JsonKey(name: 'start_time') String startTime,
      @JsonKey(name: 'end_time') String endTime,
      @JsonKey(name: 'description') String? description,
      @JsonKey(name: 'is_active') bool isActive});
}

/// @nodoc
class __$$ShiftMetadataModelImplCopyWithImpl<$Res>
    extends _$ShiftMetadataModelCopyWithImpl<$Res, _$ShiftMetadataModelImpl>
    implements _$$ShiftMetadataModelImplCopyWith<$Res> {
  __$$ShiftMetadataModelImplCopyWithImpl(_$ShiftMetadataModelImpl _value,
      $Res Function(_$ShiftMetadataModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of ShiftMetadataModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? shiftId = null,
    Object? shiftName = null,
    Object? startTime = null,
    Object? endTime = null,
    Object? description = freezed,
    Object? isActive = null,
  }) {
    return _then(_$ShiftMetadataModelImpl(
      shiftId: null == shiftId
          ? _value.shiftId
          : shiftId // ignore: cast_nullable_to_non_nullable
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
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ShiftMetadataModelImpl extends _ShiftMetadataModel {
  const _$ShiftMetadataModelImpl(
      {@JsonKey(name: 'shift_id') required this.shiftId,
      @JsonKey(name: 'shift_name') required this.shiftName,
      @JsonKey(name: 'start_time') required this.startTime,
      @JsonKey(name: 'end_time') required this.endTime,
      @JsonKey(name: 'description') this.description,
      @JsonKey(name: 'is_active') this.isActive = true})
      : super._();

  factory _$ShiftMetadataModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$ShiftMetadataModelImplFromJson(json);

  @override
  @JsonKey(name: 'shift_id')
  final String shiftId;
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
  @JsonKey(name: 'description')
  final String? description;
  @override
  @JsonKey(name: 'is_active')
  final bool isActive;

  @override
  String toString() {
    return 'ShiftMetadataModel(shiftId: $shiftId, shiftName: $shiftName, startTime: $startTime, endTime: $endTime, description: $description, isActive: $isActive)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ShiftMetadataModelImpl &&
            (identical(other.shiftId, shiftId) || other.shiftId == shiftId) &&
            (identical(other.shiftName, shiftName) ||
                other.shiftName == shiftName) &&
            (identical(other.startTime, startTime) ||
                other.startTime == startTime) &&
            (identical(other.endTime, endTime) || other.endTime == endTime) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, shiftId, shiftName, startTime,
      endTime, description, isActive);

  /// Create a copy of ShiftMetadataModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ShiftMetadataModelImplCopyWith<_$ShiftMetadataModelImpl> get copyWith =>
      __$$ShiftMetadataModelImplCopyWithImpl<_$ShiftMetadataModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ShiftMetadataModelImplToJson(
      this,
    );
  }
}

abstract class _ShiftMetadataModel extends ShiftMetadataModel {
  const factory _ShiftMetadataModel(
          {@JsonKey(name: 'shift_id') required final String shiftId,
          @JsonKey(name: 'shift_name') required final String shiftName,
          @JsonKey(name: 'start_time') required final String startTime,
          @JsonKey(name: 'end_time') required final String endTime,
          @JsonKey(name: 'description') final String? description,
          @JsonKey(name: 'is_active') final bool isActive}) =
      _$ShiftMetadataModelImpl;
  const _ShiftMetadataModel._() : super._();

  factory _ShiftMetadataModel.fromJson(Map<String, dynamic> json) =
      _$ShiftMetadataModelImpl.fromJson;

  @override
  @JsonKey(name: 'shift_id')
  String get shiftId;
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
  @JsonKey(name: 'description')
  String? get description;
  @override
  @JsonKey(name: 'is_active')
  bool get isActive;

  /// Create a copy of ShiftMetadataModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ShiftMetadataModelImplCopyWith<_$ShiftMetadataModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
