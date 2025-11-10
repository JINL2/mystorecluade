// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'insert_shift_schedule.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$InsertShiftScheduleParams {
  String get storeId => throw _privateConstructorUsedError;
  String get shiftId => throw _privateConstructorUsedError;
  List<String> get employeeIds => throw _privateConstructorUsedError;

  /// Create a copy of InsertShiftScheduleParams
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $InsertShiftScheduleParamsCopyWith<InsertShiftScheduleParams> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $InsertShiftScheduleParamsCopyWith<$Res> {
  factory $InsertShiftScheduleParamsCopyWith(InsertShiftScheduleParams value,
          $Res Function(InsertShiftScheduleParams) then) =
      _$InsertShiftScheduleParamsCopyWithImpl<$Res, InsertShiftScheduleParams>;
  @useResult
  $Res call({String storeId, String shiftId, List<String> employeeIds});
}

/// @nodoc
class _$InsertShiftScheduleParamsCopyWithImpl<$Res,
        $Val extends InsertShiftScheduleParams>
    implements $InsertShiftScheduleParamsCopyWith<$Res> {
  _$InsertShiftScheduleParamsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of InsertShiftScheduleParams
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? storeId = null,
    Object? shiftId = null,
    Object? employeeIds = null,
  }) {
    return _then(_value.copyWith(
      storeId: null == storeId
          ? _value.storeId
          : storeId // ignore: cast_nullable_to_non_nullable
              as String,
      shiftId: null == shiftId
          ? _value.shiftId
          : shiftId // ignore: cast_nullable_to_non_nullable
              as String,
      employeeIds: null == employeeIds
          ? _value.employeeIds
          : employeeIds // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$InsertShiftScheduleParamsImplCopyWith<$Res>
    implements $InsertShiftScheduleParamsCopyWith<$Res> {
  factory _$$InsertShiftScheduleParamsImplCopyWith(
          _$InsertShiftScheduleParamsImpl value,
          $Res Function(_$InsertShiftScheduleParamsImpl) then) =
      __$$InsertShiftScheduleParamsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String storeId, String shiftId, List<String> employeeIds});
}

/// @nodoc
class __$$InsertShiftScheduleParamsImplCopyWithImpl<$Res>
    extends _$InsertShiftScheduleParamsCopyWithImpl<$Res,
        _$InsertShiftScheduleParamsImpl>
    implements _$$InsertShiftScheduleParamsImplCopyWith<$Res> {
  __$$InsertShiftScheduleParamsImplCopyWithImpl(
      _$InsertShiftScheduleParamsImpl _value,
      $Res Function(_$InsertShiftScheduleParamsImpl) _then)
      : super(_value, _then);

  /// Create a copy of InsertShiftScheduleParams
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? storeId = null,
    Object? shiftId = null,
    Object? employeeIds = null,
  }) {
    return _then(_$InsertShiftScheduleParamsImpl(
      storeId: null == storeId
          ? _value.storeId
          : storeId // ignore: cast_nullable_to_non_nullable
              as String,
      shiftId: null == shiftId
          ? _value.shiftId
          : shiftId // ignore: cast_nullable_to_non_nullable
              as String,
      employeeIds: null == employeeIds
          ? _value._employeeIds
          : employeeIds // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ));
  }
}

/// @nodoc

class _$InsertShiftScheduleParamsImpl implements _InsertShiftScheduleParams {
  const _$InsertShiftScheduleParamsImpl(
      {required this.storeId,
      required this.shiftId,
      required final List<String> employeeIds})
      : _employeeIds = employeeIds;

  @override
  final String storeId;
  @override
  final String shiftId;
  final List<String> _employeeIds;
  @override
  List<String> get employeeIds {
    if (_employeeIds is EqualUnmodifiableListView) return _employeeIds;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_employeeIds);
  }

  @override
  String toString() {
    return 'InsertShiftScheduleParams(storeId: $storeId, shiftId: $shiftId, employeeIds: $employeeIds)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$InsertShiftScheduleParamsImpl &&
            (identical(other.storeId, storeId) || other.storeId == storeId) &&
            (identical(other.shiftId, shiftId) || other.shiftId == shiftId) &&
            const DeepCollectionEquality()
                .equals(other._employeeIds, _employeeIds));
  }

  @override
  int get hashCode => Object.hash(runtimeType, storeId, shiftId,
      const DeepCollectionEquality().hash(_employeeIds));

  /// Create a copy of InsertShiftScheduleParams
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$InsertShiftScheduleParamsImplCopyWith<_$InsertShiftScheduleParamsImpl>
      get copyWith => __$$InsertShiftScheduleParamsImplCopyWithImpl<
          _$InsertShiftScheduleParamsImpl>(this, _$identity);
}

abstract class _InsertShiftScheduleParams implements InsertShiftScheduleParams {
  const factory _InsertShiftScheduleParams(
          {required final String storeId,
          required final String shiftId,
          required final List<String> employeeIds}) =
      _$InsertShiftScheduleParamsImpl;

  @override
  String get storeId;
  @override
  String get shiftId;
  @override
  List<String> get employeeIds;

  /// Create a copy of InsertShiftScheduleParams
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$InsertShiftScheduleParamsImplCopyWith<_$InsertShiftScheduleParamsImpl>
      get copyWith => throw _privateConstructorUsedError;
}
