// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'schedule_data_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ScheduleDataDto _$ScheduleDataDtoFromJson(Map<String, dynamic> json) {
  return _ScheduleDataDto.fromJson(json);
}

/// @nodoc
mixin _$ScheduleDataDto {
  @JsonKey(name: 'store_employees')
  List<StoreEmployeeDto> get storeEmployees =>
      throw _privateConstructorUsedError;
  @JsonKey(name: 'store_shifts')
  List<StoreShiftDto> get storeShifts => throw _privateConstructorUsedError;

  /// Serializes this ScheduleDataDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ScheduleDataDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ScheduleDataDtoCopyWith<ScheduleDataDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ScheduleDataDtoCopyWith<$Res> {
  factory $ScheduleDataDtoCopyWith(
          ScheduleDataDto value, $Res Function(ScheduleDataDto) then) =
      _$ScheduleDataDtoCopyWithImpl<$Res, ScheduleDataDto>;
  @useResult
  $Res call(
      {@JsonKey(name: 'store_employees') List<StoreEmployeeDto> storeEmployees,
      @JsonKey(name: 'store_shifts') List<StoreShiftDto> storeShifts});
}

/// @nodoc
class _$ScheduleDataDtoCopyWithImpl<$Res, $Val extends ScheduleDataDto>
    implements $ScheduleDataDtoCopyWith<$Res> {
  _$ScheduleDataDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ScheduleDataDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? storeEmployees = null,
    Object? storeShifts = null,
  }) {
    return _then(_value.copyWith(
      storeEmployees: null == storeEmployees
          ? _value.storeEmployees
          : storeEmployees // ignore: cast_nullable_to_non_nullable
              as List<StoreEmployeeDto>,
      storeShifts: null == storeShifts
          ? _value.storeShifts
          : storeShifts // ignore: cast_nullable_to_non_nullable
              as List<StoreShiftDto>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ScheduleDataDtoImplCopyWith<$Res>
    implements $ScheduleDataDtoCopyWith<$Res> {
  factory _$$ScheduleDataDtoImplCopyWith(_$ScheduleDataDtoImpl value,
          $Res Function(_$ScheduleDataDtoImpl) then) =
      __$$ScheduleDataDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'store_employees') List<StoreEmployeeDto> storeEmployees,
      @JsonKey(name: 'store_shifts') List<StoreShiftDto> storeShifts});
}

/// @nodoc
class __$$ScheduleDataDtoImplCopyWithImpl<$Res>
    extends _$ScheduleDataDtoCopyWithImpl<$Res, _$ScheduleDataDtoImpl>
    implements _$$ScheduleDataDtoImplCopyWith<$Res> {
  __$$ScheduleDataDtoImplCopyWithImpl(
      _$ScheduleDataDtoImpl _value, $Res Function(_$ScheduleDataDtoImpl) _then)
      : super(_value, _then);

  /// Create a copy of ScheduleDataDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? storeEmployees = null,
    Object? storeShifts = null,
  }) {
    return _then(_$ScheduleDataDtoImpl(
      storeEmployees: null == storeEmployees
          ? _value._storeEmployees
          : storeEmployees // ignore: cast_nullable_to_non_nullable
              as List<StoreEmployeeDto>,
      storeShifts: null == storeShifts
          ? _value._storeShifts
          : storeShifts // ignore: cast_nullable_to_non_nullable
              as List<StoreShiftDto>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ScheduleDataDtoImpl implements _ScheduleDataDto {
  const _$ScheduleDataDtoImpl(
      {@JsonKey(name: 'store_employees')
      final List<StoreEmployeeDto> storeEmployees = const [],
      @JsonKey(name: 'store_shifts')
      final List<StoreShiftDto> storeShifts = const []})
      : _storeEmployees = storeEmployees,
        _storeShifts = storeShifts;

  factory _$ScheduleDataDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$ScheduleDataDtoImplFromJson(json);

  final List<StoreEmployeeDto> _storeEmployees;
  @override
  @JsonKey(name: 'store_employees')
  List<StoreEmployeeDto> get storeEmployees {
    if (_storeEmployees is EqualUnmodifiableListView) return _storeEmployees;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_storeEmployees);
  }

  final List<StoreShiftDto> _storeShifts;
  @override
  @JsonKey(name: 'store_shifts')
  List<StoreShiftDto> get storeShifts {
    if (_storeShifts is EqualUnmodifiableListView) return _storeShifts;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_storeShifts);
  }

  @override
  String toString() {
    return 'ScheduleDataDto(storeEmployees: $storeEmployees, storeShifts: $storeShifts)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ScheduleDataDtoImpl &&
            const DeepCollectionEquality()
                .equals(other._storeEmployees, _storeEmployees) &&
            const DeepCollectionEquality()
                .equals(other._storeShifts, _storeShifts));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_storeEmployees),
      const DeepCollectionEquality().hash(_storeShifts));

  /// Create a copy of ScheduleDataDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ScheduleDataDtoImplCopyWith<_$ScheduleDataDtoImpl> get copyWith =>
      __$$ScheduleDataDtoImplCopyWithImpl<_$ScheduleDataDtoImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ScheduleDataDtoImplToJson(
      this,
    );
  }
}

abstract class _ScheduleDataDto implements ScheduleDataDto {
  const factory _ScheduleDataDto(
      {@JsonKey(name: 'store_employees')
      final List<StoreEmployeeDto> storeEmployees,
      @JsonKey(name: 'store_shifts')
      final List<StoreShiftDto> storeShifts}) = _$ScheduleDataDtoImpl;

  factory _ScheduleDataDto.fromJson(Map<String, dynamic> json) =
      _$ScheduleDataDtoImpl.fromJson;

  @override
  @JsonKey(name: 'store_employees')
  List<StoreEmployeeDto> get storeEmployees;
  @override
  @JsonKey(name: 'store_shifts')
  List<StoreShiftDto> get storeShifts;

  /// Create a copy of ScheduleDataDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ScheduleDataDtoImplCopyWith<_$ScheduleDataDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
