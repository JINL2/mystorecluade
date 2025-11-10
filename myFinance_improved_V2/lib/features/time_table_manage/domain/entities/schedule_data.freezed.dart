// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'schedule_data.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ScheduleData _$ScheduleDataFromJson(Map<String, dynamic> json) {
  return _ScheduleData.fromJson(json);
}

/// @nodoc
mixin _$ScheduleData {
  /// List of all employees in the store
  @JsonKey(defaultValue: <EmployeeInfo>[])
  List<EmployeeInfo> get employees => throw _privateConstructorUsedError;

  /// List of all shifts in the store
  @JsonKey(defaultValue: <Shift>[])
  List<Shift> get shifts => throw _privateConstructorUsedError;

  /// The store ID this schedule data is for
  @JsonKey(name: 'store_id')
  String get storeId => throw _privateConstructorUsedError;

  /// Serializes this ScheduleData to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ScheduleData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ScheduleDataCopyWith<ScheduleData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ScheduleDataCopyWith<$Res> {
  factory $ScheduleDataCopyWith(
          ScheduleData value, $Res Function(ScheduleData) then) =
      _$ScheduleDataCopyWithImpl<$Res, ScheduleData>;
  @useResult
  $Res call(
      {@JsonKey(defaultValue: <EmployeeInfo>[]) List<EmployeeInfo> employees,
      @JsonKey(defaultValue: <Shift>[]) List<Shift> shifts,
      @JsonKey(name: 'store_id') String storeId});
}

/// @nodoc
class _$ScheduleDataCopyWithImpl<$Res, $Val extends ScheduleData>
    implements $ScheduleDataCopyWith<$Res> {
  _$ScheduleDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ScheduleData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? employees = null,
    Object? shifts = null,
    Object? storeId = null,
  }) {
    return _then(_value.copyWith(
      employees: null == employees
          ? _value.employees
          : employees // ignore: cast_nullable_to_non_nullable
              as List<EmployeeInfo>,
      shifts: null == shifts
          ? _value.shifts
          : shifts // ignore: cast_nullable_to_non_nullable
              as List<Shift>,
      storeId: null == storeId
          ? _value.storeId
          : storeId // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ScheduleDataImplCopyWith<$Res>
    implements $ScheduleDataCopyWith<$Res> {
  factory _$$ScheduleDataImplCopyWith(
          _$ScheduleDataImpl value, $Res Function(_$ScheduleDataImpl) then) =
      __$$ScheduleDataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(defaultValue: <EmployeeInfo>[]) List<EmployeeInfo> employees,
      @JsonKey(defaultValue: <Shift>[]) List<Shift> shifts,
      @JsonKey(name: 'store_id') String storeId});
}

/// @nodoc
class __$$ScheduleDataImplCopyWithImpl<$Res>
    extends _$ScheduleDataCopyWithImpl<$Res, _$ScheduleDataImpl>
    implements _$$ScheduleDataImplCopyWith<$Res> {
  __$$ScheduleDataImplCopyWithImpl(
      _$ScheduleDataImpl _value, $Res Function(_$ScheduleDataImpl) _then)
      : super(_value, _then);

  /// Create a copy of ScheduleData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? employees = null,
    Object? shifts = null,
    Object? storeId = null,
  }) {
    return _then(_$ScheduleDataImpl(
      employees: null == employees
          ? _value._employees
          : employees // ignore: cast_nullable_to_non_nullable
              as List<EmployeeInfo>,
      shifts: null == shifts
          ? _value._shifts
          : shifts // ignore: cast_nullable_to_non_nullable
              as List<Shift>,
      storeId: null == storeId
          ? _value.storeId
          : storeId // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ScheduleDataImpl extends _ScheduleData {
  const _$ScheduleDataImpl(
      {@JsonKey(defaultValue: <EmployeeInfo>[])
      required final List<EmployeeInfo> employees,
      @JsonKey(defaultValue: <Shift>[]) required final List<Shift> shifts,
      @JsonKey(name: 'store_id') required this.storeId})
      : _employees = employees,
        _shifts = shifts,
        super._();

  factory _$ScheduleDataImpl.fromJson(Map<String, dynamic> json) =>
      _$$ScheduleDataImplFromJson(json);

  /// List of all employees in the store
  final List<EmployeeInfo> _employees;

  /// List of all employees in the store
  @override
  @JsonKey(defaultValue: <EmployeeInfo>[])
  List<EmployeeInfo> get employees {
    if (_employees is EqualUnmodifiableListView) return _employees;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_employees);
  }

  /// List of all shifts in the store
  final List<Shift> _shifts;

  /// List of all shifts in the store
  @override
  @JsonKey(defaultValue: <Shift>[])
  List<Shift> get shifts {
    if (_shifts is EqualUnmodifiableListView) return _shifts;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_shifts);
  }

  /// The store ID this schedule data is for
  @override
  @JsonKey(name: 'store_id')
  final String storeId;

  @override
  String toString() {
    return 'ScheduleData(employees: $employees, shifts: $shifts, storeId: $storeId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ScheduleDataImpl &&
            const DeepCollectionEquality()
                .equals(other._employees, _employees) &&
            const DeepCollectionEquality().equals(other._shifts, _shifts) &&
            (identical(other.storeId, storeId) || other.storeId == storeId));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_employees),
      const DeepCollectionEquality().hash(_shifts),
      storeId);

  /// Create a copy of ScheduleData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ScheduleDataImplCopyWith<_$ScheduleDataImpl> get copyWith =>
      __$$ScheduleDataImplCopyWithImpl<_$ScheduleDataImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ScheduleDataImplToJson(
      this,
    );
  }
}

abstract class _ScheduleData extends ScheduleData {
  const factory _ScheduleData(
          {@JsonKey(defaultValue: <EmployeeInfo>[])
          required final List<EmployeeInfo> employees,
          @JsonKey(defaultValue: <Shift>[]) required final List<Shift> shifts,
          @JsonKey(name: 'store_id') required final String storeId}) =
      _$ScheduleDataImpl;
  const _ScheduleData._() : super._();

  factory _ScheduleData.fromJson(Map<String, dynamic> json) =
      _$ScheduleDataImpl.fromJson;

  /// List of all employees in the store
  @override
  @JsonKey(defaultValue: <EmployeeInfo>[])
  List<EmployeeInfo> get employees;

  /// List of all shifts in the store
  @override
  @JsonKey(defaultValue: <Shift>[])
  List<Shift> get shifts;

  /// The store ID this schedule data is for
  @override
  @JsonKey(name: 'store_id')
  String get storeId;

  /// Create a copy of ScheduleData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ScheduleDataImplCopyWith<_$ScheduleDataImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
