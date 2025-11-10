// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'available_employees_data.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

AvailableEmployeesData _$AvailableEmployeesDataFromJson(
    Map<String, dynamic> json) {
  return _AvailableEmployeesData.fromJson(json);
}

/// @nodoc
mixin _$AvailableEmployeesData {
  /// List of employees available for assignment
  @JsonKey(name: 'available_employees', defaultValue: <EmployeeInfo>[])
  List<EmployeeInfo> get availableEmployees =>
      throw _privateConstructorUsedError;

  /// List of existing shifts for the given date
  @JsonKey(name: 'existing_shifts', defaultValue: <Shift>[])
  List<Shift> get existingShifts => throw _privateConstructorUsedError;

  /// The store ID this data is for
  @JsonKey(name: 'store_id')
  String get storeId => throw _privateConstructorUsedError;

  /// The shift date this data is for (yyyy-MM-dd format)
  @JsonKey(name: 'shift_date')
  String get shiftDate => throw _privateConstructorUsedError;

  /// Serializes this AvailableEmployeesData to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of AvailableEmployeesData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AvailableEmployeesDataCopyWith<AvailableEmployeesData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AvailableEmployeesDataCopyWith<$Res> {
  factory $AvailableEmployeesDataCopyWith(AvailableEmployeesData value,
          $Res Function(AvailableEmployeesData) then) =
      _$AvailableEmployeesDataCopyWithImpl<$Res, AvailableEmployeesData>;
  @useResult
  $Res call(
      {@JsonKey(name: 'available_employees', defaultValue: <EmployeeInfo>[])
      List<EmployeeInfo> availableEmployees,
      @JsonKey(name: 'existing_shifts', defaultValue: <Shift>[])
      List<Shift> existingShifts,
      @JsonKey(name: 'store_id') String storeId,
      @JsonKey(name: 'shift_date') String shiftDate});
}

/// @nodoc
class _$AvailableEmployeesDataCopyWithImpl<$Res,
        $Val extends AvailableEmployeesData>
    implements $AvailableEmployeesDataCopyWith<$Res> {
  _$AvailableEmployeesDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AvailableEmployeesData
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
              as List<EmployeeInfo>,
      existingShifts: null == existingShifts
          ? _value.existingShifts
          : existingShifts // ignore: cast_nullable_to_non_nullable
              as List<Shift>,
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
abstract class _$$AvailableEmployeesDataImplCopyWith<$Res>
    implements $AvailableEmployeesDataCopyWith<$Res> {
  factory _$$AvailableEmployeesDataImplCopyWith(
          _$AvailableEmployeesDataImpl value,
          $Res Function(_$AvailableEmployeesDataImpl) then) =
      __$$AvailableEmployeesDataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'available_employees', defaultValue: <EmployeeInfo>[])
      List<EmployeeInfo> availableEmployees,
      @JsonKey(name: 'existing_shifts', defaultValue: <Shift>[])
      List<Shift> existingShifts,
      @JsonKey(name: 'store_id') String storeId,
      @JsonKey(name: 'shift_date') String shiftDate});
}

/// @nodoc
class __$$AvailableEmployeesDataImplCopyWithImpl<$Res>
    extends _$AvailableEmployeesDataCopyWithImpl<$Res,
        _$AvailableEmployeesDataImpl>
    implements _$$AvailableEmployeesDataImplCopyWith<$Res> {
  __$$AvailableEmployeesDataImplCopyWithImpl(
      _$AvailableEmployeesDataImpl _value,
      $Res Function(_$AvailableEmployeesDataImpl) _then)
      : super(_value, _then);

  /// Create a copy of AvailableEmployeesData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? availableEmployees = null,
    Object? existingShifts = null,
    Object? storeId = null,
    Object? shiftDate = null,
  }) {
    return _then(_$AvailableEmployeesDataImpl(
      availableEmployees: null == availableEmployees
          ? _value._availableEmployees
          : availableEmployees // ignore: cast_nullable_to_non_nullable
              as List<EmployeeInfo>,
      existingShifts: null == existingShifts
          ? _value._existingShifts
          : existingShifts // ignore: cast_nullable_to_non_nullable
              as List<Shift>,
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
class _$AvailableEmployeesDataImpl extends _AvailableEmployeesData {
  const _$AvailableEmployeesDataImpl(
      {@JsonKey(name: 'available_employees', defaultValue: <EmployeeInfo>[])
      required final List<EmployeeInfo> availableEmployees,
      @JsonKey(name: 'existing_shifts', defaultValue: <Shift>[])
      required final List<Shift> existingShifts,
      @JsonKey(name: 'store_id') required this.storeId,
      @JsonKey(name: 'shift_date') required this.shiftDate})
      : _availableEmployees = availableEmployees,
        _existingShifts = existingShifts,
        super._();

  factory _$AvailableEmployeesDataImpl.fromJson(Map<String, dynamic> json) =>
      _$$AvailableEmployeesDataImplFromJson(json);

  /// List of employees available for assignment
  final List<EmployeeInfo> _availableEmployees;

  /// List of employees available for assignment
  @override
  @JsonKey(name: 'available_employees', defaultValue: <EmployeeInfo>[])
  List<EmployeeInfo> get availableEmployees {
    if (_availableEmployees is EqualUnmodifiableListView)
      return _availableEmployees;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_availableEmployees);
  }

  /// List of existing shifts for the given date
  final List<Shift> _existingShifts;

  /// List of existing shifts for the given date
  @override
  @JsonKey(name: 'existing_shifts', defaultValue: <Shift>[])
  List<Shift> get existingShifts {
    if (_existingShifts is EqualUnmodifiableListView) return _existingShifts;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_existingShifts);
  }

  /// The store ID this data is for
  @override
  @JsonKey(name: 'store_id')
  final String storeId;

  /// The shift date this data is for (yyyy-MM-dd format)
  @override
  @JsonKey(name: 'shift_date')
  final String shiftDate;

  @override
  String toString() {
    return 'AvailableEmployeesData(availableEmployees: $availableEmployees, existingShifts: $existingShifts, storeId: $storeId, shiftDate: $shiftDate)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AvailableEmployeesDataImpl &&
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

  /// Create a copy of AvailableEmployeesData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AvailableEmployeesDataImplCopyWith<_$AvailableEmployeesDataImpl>
      get copyWith => __$$AvailableEmployeesDataImplCopyWithImpl<
          _$AvailableEmployeesDataImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AvailableEmployeesDataImplToJson(
      this,
    );
  }
}

abstract class _AvailableEmployeesData extends AvailableEmployeesData {
  const factory _AvailableEmployeesData(
          {@JsonKey(name: 'available_employees', defaultValue: <EmployeeInfo>[])
          required final List<EmployeeInfo> availableEmployees,
          @JsonKey(name: 'existing_shifts', defaultValue: <Shift>[])
          required final List<Shift> existingShifts,
          @JsonKey(name: 'store_id') required final String storeId,
          @JsonKey(name: 'shift_date') required final String shiftDate}) =
      _$AvailableEmployeesDataImpl;
  const _AvailableEmployeesData._() : super._();

  factory _AvailableEmployeesData.fromJson(Map<String, dynamic> json) =
      _$AvailableEmployeesDataImpl.fromJson;

  /// List of employees available for assignment
  @override
  @JsonKey(name: 'available_employees', defaultValue: <EmployeeInfo>[])
  List<EmployeeInfo> get availableEmployees;

  /// List of existing shifts for the given date
  @override
  @JsonKey(name: 'existing_shifts', defaultValue: <Shift>[])
  List<Shift> get existingShifts;

  /// The store ID this data is for
  @override
  @JsonKey(name: 'store_id')
  String get storeId;

  /// The shift date this data is for (yyyy-MM-dd format)
  @override
  @JsonKey(name: 'shift_date')
  String get shiftDate;

  /// Create a copy of AvailableEmployeesData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AvailableEmployeesDataImplCopyWith<_$AvailableEmployeesDataImpl>
      get copyWith => throw _privateConstructorUsedError;
}
