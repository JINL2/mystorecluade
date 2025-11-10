// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'get_available_employees.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$GetAvailableEmployeesParams {
  String get storeId => throw _privateConstructorUsedError;
  String get shiftDate => throw _privateConstructorUsedError;

  /// Create a copy of GetAvailableEmployeesParams
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $GetAvailableEmployeesParamsCopyWith<GetAvailableEmployeesParams>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GetAvailableEmployeesParamsCopyWith<$Res> {
  factory $GetAvailableEmployeesParamsCopyWith(
          GetAvailableEmployeesParams value,
          $Res Function(GetAvailableEmployeesParams) then) =
      _$GetAvailableEmployeesParamsCopyWithImpl<$Res,
          GetAvailableEmployeesParams>;
  @useResult
  $Res call({String storeId, String shiftDate});
}

/// @nodoc
class _$GetAvailableEmployeesParamsCopyWithImpl<$Res,
        $Val extends GetAvailableEmployeesParams>
    implements $GetAvailableEmployeesParamsCopyWith<$Res> {
  _$GetAvailableEmployeesParamsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of GetAvailableEmployeesParams
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? storeId = null,
    Object? shiftDate = null,
  }) {
    return _then(_value.copyWith(
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
abstract class _$$GetAvailableEmployeesParamsImplCopyWith<$Res>
    implements $GetAvailableEmployeesParamsCopyWith<$Res> {
  factory _$$GetAvailableEmployeesParamsImplCopyWith(
          _$GetAvailableEmployeesParamsImpl value,
          $Res Function(_$GetAvailableEmployeesParamsImpl) then) =
      __$$GetAvailableEmployeesParamsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String storeId, String shiftDate});
}

/// @nodoc
class __$$GetAvailableEmployeesParamsImplCopyWithImpl<$Res>
    extends _$GetAvailableEmployeesParamsCopyWithImpl<$Res,
        _$GetAvailableEmployeesParamsImpl>
    implements _$$GetAvailableEmployeesParamsImplCopyWith<$Res> {
  __$$GetAvailableEmployeesParamsImplCopyWithImpl(
      _$GetAvailableEmployeesParamsImpl _value,
      $Res Function(_$GetAvailableEmployeesParamsImpl) _then)
      : super(_value, _then);

  /// Create a copy of GetAvailableEmployeesParams
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? storeId = null,
    Object? shiftDate = null,
  }) {
    return _then(_$GetAvailableEmployeesParamsImpl(
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

class _$GetAvailableEmployeesParamsImpl
    implements _GetAvailableEmployeesParams {
  const _$GetAvailableEmployeesParamsImpl(
      {required this.storeId, required this.shiftDate});

  @override
  final String storeId;
  @override
  final String shiftDate;

  @override
  String toString() {
    return 'GetAvailableEmployeesParams(storeId: $storeId, shiftDate: $shiftDate)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GetAvailableEmployeesParamsImpl &&
            (identical(other.storeId, storeId) || other.storeId == storeId) &&
            (identical(other.shiftDate, shiftDate) ||
                other.shiftDate == shiftDate));
  }

  @override
  int get hashCode => Object.hash(runtimeType, storeId, shiftDate);

  /// Create a copy of GetAvailableEmployeesParams
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$GetAvailableEmployeesParamsImplCopyWith<_$GetAvailableEmployeesParamsImpl>
      get copyWith => __$$GetAvailableEmployeesParamsImplCopyWithImpl<
          _$GetAvailableEmployeesParamsImpl>(this, _$identity);
}

abstract class _GetAvailableEmployeesParams
    implements GetAvailableEmployeesParams {
  const factory _GetAvailableEmployeesParams(
      {required final String storeId,
      required final String shiftDate}) = _$GetAvailableEmployeesParamsImpl;

  @override
  String get storeId;
  @override
  String get shiftDate;

  /// Create a copy of GetAvailableEmployeesParams
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$GetAvailableEmployeesParamsImplCopyWith<_$GetAvailableEmployeesParamsImpl>
      get copyWith => throw _privateConstructorUsedError;
}
