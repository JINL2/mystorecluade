// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'available_employees_data_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

AvailableEmployeesDataDto _$AvailableEmployeesDataDtoFromJson(
    Map<String, dynamic> json) {
  return _AvailableEmployeesDataDto.fromJson(json);
}

/// @nodoc
mixin _$AvailableEmployeesDataDto {
  @JsonKey(name: 'available_employees')
  List<EmployeeInfoDto> get availableEmployees =>
      throw _privateConstructorUsedError;
  @JsonKey(name: 'existing_shifts')
  List<ShiftDto> get existingShifts => throw _privateConstructorUsedError;
  @JsonKey(name: 'store_id')
  String get storeId => throw _privateConstructorUsedError;
  @JsonKey(name: 'shift_date')
  String get shiftDate => throw _privateConstructorUsedError;

  /// Serializes this AvailableEmployeesDataDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of AvailableEmployeesDataDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AvailableEmployeesDataDtoCopyWith<AvailableEmployeesDataDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AvailableEmployeesDataDtoCopyWith<$Res> {
  factory $AvailableEmployeesDataDtoCopyWith(AvailableEmployeesDataDto value,
          $Res Function(AvailableEmployeesDataDto) then) =
      _$AvailableEmployeesDataDtoCopyWithImpl<$Res, AvailableEmployeesDataDto>;
  @useResult
  $Res call(
      {@JsonKey(name: 'available_employees')
      List<EmployeeInfoDto> availableEmployees,
      @JsonKey(name: 'existing_shifts') List<ShiftDto> existingShifts,
      @JsonKey(name: 'store_id') String storeId,
      @JsonKey(name: 'shift_date') String shiftDate});
}

/// @nodoc
class _$AvailableEmployeesDataDtoCopyWithImpl<$Res,
        $Val extends AvailableEmployeesDataDto>
    implements $AvailableEmployeesDataDtoCopyWith<$Res> {
  _$AvailableEmployeesDataDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AvailableEmployeesDataDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? availableEmployees = null,
    Object? existingShifts = null,
    Object? storeId = null,
    Object? shiftDate = null,
  }) {
    return _then(_value.copyWith(
      availableEmployees: null == availableEmployees
          ? _value.availableEmployees
          : availableEmployees // ignore: cast_nullable_to_non_nullable
              as List<EmployeeInfoDto>,
      existingShifts: null == existingShifts
          ? _value.existingShifts
          : existingShifts // ignore: cast_nullable_to_non_nullable
              as List<ShiftDto>,
      storeId: null == storeId
          ? _value.storeId
          : storeId // ignore: cast_nullable_to_non_nullable
              as String,
      shiftDate: null == shiftDate
          ? _value.shiftDate
          : shiftDate // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$AvailableEmployeesDataDtoImplCopyWith<$Res>
    implements $AvailableEmployeesDataDtoCopyWith<$Res> {
  factory _$$AvailableEmployeesDataDtoImplCopyWith(
          _$AvailableEmployeesDataDtoImpl value,
          $Res Function(_$AvailableEmployeesDataDtoImpl) then) =
      __$$AvailableEmployeesDataDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'available_employees')
      List<EmployeeInfoDto> availableEmployees,
      @JsonKey(name: 'existing_shifts') List<ShiftDto> existingShifts,
      @JsonKey(name: 'store_id') String storeId,
      @JsonKey(name: 'shift_date') String shiftDate});
}

/// @nodoc
class __$$AvailableEmployeesDataDtoImplCopyWithImpl<$Res>
    extends _$AvailableEmployeesDataDtoCopyWithImpl<$Res,
        _$AvailableEmployeesDataDtoImpl>
    implements _$$AvailableEmployeesDataDtoImplCopyWith<$Res> {
  __$$AvailableEmployeesDataDtoImplCopyWithImpl(
      _$AvailableEmployeesDataDtoImpl _value,
      $Res Function(_$AvailableEmployeesDataDtoImpl) _then)
      : super(_value, _then);

  /// Create a copy of AvailableEmployeesDataDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? availableEmployees = null,
    Object? existingShifts = null,
    Object? storeId = null,
    Object? shiftDate = null,
  }) {
    return _then(_$AvailableEmployeesDataDtoImpl(
      availableEmployees: null == availableEmployees
          ? _value._availableEmployees
          : availableEmployees // ignore: cast_nullable_to_non_nullable
              as List<EmployeeInfoDto>,
      existingShifts: null == existingShifts
          ? _value._existingShifts
          : existingShifts // ignore: cast_nullable_to_non_nullable
              as List<ShiftDto>,
      storeId: null == storeId
          ? _value.storeId
          : storeId // ignore: cast_nullable_to_non_nullable
              as String,
      shiftDate: null == shiftDate
          ? _value.shiftDate
          : shiftDate // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$AvailableEmployeesDataDtoImpl implements _AvailableEmployeesDataDto {
  const _$AvailableEmployeesDataDtoImpl(
      {@JsonKey(name: 'available_employees')
      final List<EmployeeInfoDto> availableEmployees = const [],
      @JsonKey(name: 'existing_shifts')
      final List<ShiftDto> existingShifts = const [],
      @JsonKey(name: 'store_id') this.storeId = '',
      @JsonKey(name: 'shift_date') this.shiftDate = ''})
      : _availableEmployees = availableEmployees,
        _existingShifts = existingShifts;

  factory _$AvailableEmployeesDataDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$AvailableEmployeesDataDtoImplFromJson(json);

  final List<EmployeeInfoDto> _availableEmployees;
  @override
  @JsonKey(name: 'available_employees')
  List<EmployeeInfoDto> get availableEmployees {
    if (_availableEmployees is EqualUnmodifiableListView)
      return _availableEmployees;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_availableEmployees);
  }

  final List<ShiftDto> _existingShifts;
  @override
  @JsonKey(name: 'existing_shifts')
  List<ShiftDto> get existingShifts {
    if (_existingShifts is EqualUnmodifiableListView) return _existingShifts;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_existingShifts);
  }

  @override
  @JsonKey(name: 'store_id')
  final String storeId;
  @override
  @JsonKey(name: 'shift_date')
  final String shiftDate;

  @override
  String toString() {
    return 'AvailableEmployeesDataDto(availableEmployees: $availableEmployees, existingShifts: $existingShifts, storeId: $storeId, shiftDate: $shiftDate)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AvailableEmployeesDataDtoImpl &&
            const DeepCollectionEquality()
                .equals(other._availableEmployees, _availableEmployees) &&
            const DeepCollectionEquality()
                .equals(other._existingShifts, _existingShifts) &&
            (identical(other.storeId, storeId) || other.storeId == storeId) &&
            (identical(other.shiftDate, shiftDate) ||
                other.shiftDate == shiftDate));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_availableEmployees),
      const DeepCollectionEquality().hash(_existingShifts),
      storeId,
      shiftDate);

  /// Create a copy of AvailableEmployeesDataDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AvailableEmployeesDataDtoImplCopyWith<_$AvailableEmployeesDataDtoImpl>
      get copyWith => __$$AvailableEmployeesDataDtoImplCopyWithImpl<
          _$AvailableEmployeesDataDtoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AvailableEmployeesDataDtoImplToJson(
      this,
    );
  }
}

abstract class _AvailableEmployeesDataDto implements AvailableEmployeesDataDto {
  const factory _AvailableEmployeesDataDto(
          {@JsonKey(name: 'available_employees')
          final List<EmployeeInfoDto> availableEmployees,
          @JsonKey(name: 'existing_shifts') final List<ShiftDto> existingShifts,
          @JsonKey(name: 'store_id') final String storeId,
          @JsonKey(name: 'shift_date') final String shiftDate}) =
      _$AvailableEmployeesDataDtoImpl;

  factory _AvailableEmployeesDataDto.fromJson(Map<String, dynamic> json) =
      _$AvailableEmployeesDataDtoImpl.fromJson;

  @override
  @JsonKey(name: 'available_employees')
  List<EmployeeInfoDto> get availableEmployees;
  @override
  @JsonKey(name: 'existing_shifts')
  List<ShiftDto> get existingShifts;
  @override
  @JsonKey(name: 'store_id')
  String get storeId;
  @override
  @JsonKey(name: 'shift_date')
  String get shiftDate;

  /// Create a copy of AvailableEmployeesDataDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AvailableEmployeesDataDtoImplCopyWith<_$AvailableEmployeesDataDtoImpl>
      get copyWith => throw _privateConstructorUsedError;
}
