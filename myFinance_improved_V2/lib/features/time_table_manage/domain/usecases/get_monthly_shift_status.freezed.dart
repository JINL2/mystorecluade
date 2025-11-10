// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'get_monthly_shift_status.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$GetMonthlyShiftStatusParams {
  String get requestDate => throw _privateConstructorUsedError;
  String get companyId => throw _privateConstructorUsedError;
  String get storeId => throw _privateConstructorUsedError;

  /// Create a copy of GetMonthlyShiftStatusParams
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $GetMonthlyShiftStatusParamsCopyWith<GetMonthlyShiftStatusParams>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GetMonthlyShiftStatusParamsCopyWith<$Res> {
  factory $GetMonthlyShiftStatusParamsCopyWith(
          GetMonthlyShiftStatusParams value,
          $Res Function(GetMonthlyShiftStatusParams) then) =
      _$GetMonthlyShiftStatusParamsCopyWithImpl<$Res,
          GetMonthlyShiftStatusParams>;
  @useResult
  $Res call({String requestDate, String companyId, String storeId});
}

/// @nodoc
class _$GetMonthlyShiftStatusParamsCopyWithImpl<$Res,
        $Val extends GetMonthlyShiftStatusParams>
    implements $GetMonthlyShiftStatusParamsCopyWith<$Res> {
  _$GetMonthlyShiftStatusParamsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of GetMonthlyShiftStatusParams
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? requestDate = null,
    Object? companyId = null,
    Object? storeId = null,
  }) {
    return _then(_value.copyWith(
      requestDate: null == requestDate
          ? _value.requestDate
          : requestDate // ignore: cast_nullable_to_non_nullable
              as String,
      companyId: null == companyId
          ? _value.companyId
          : companyId // ignore: cast_nullable_to_non_nullable
              as String,
      storeId: null == storeId
          ? _value.storeId
          : storeId // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$GetMonthlyShiftStatusParamsImplCopyWith<$Res>
    implements $GetMonthlyShiftStatusParamsCopyWith<$Res> {
  factory _$$GetMonthlyShiftStatusParamsImplCopyWith(
          _$GetMonthlyShiftStatusParamsImpl value,
          $Res Function(_$GetMonthlyShiftStatusParamsImpl) then) =
      __$$GetMonthlyShiftStatusParamsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String requestDate, String companyId, String storeId});
}

/// @nodoc
class __$$GetMonthlyShiftStatusParamsImplCopyWithImpl<$Res>
    extends _$GetMonthlyShiftStatusParamsCopyWithImpl<$Res,
        _$GetMonthlyShiftStatusParamsImpl>
    implements _$$GetMonthlyShiftStatusParamsImplCopyWith<$Res> {
  __$$GetMonthlyShiftStatusParamsImplCopyWithImpl(
      _$GetMonthlyShiftStatusParamsImpl _value,
      $Res Function(_$GetMonthlyShiftStatusParamsImpl) _then)
      : super(_value, _then);

  /// Create a copy of GetMonthlyShiftStatusParams
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? requestDate = null,
    Object? companyId = null,
    Object? storeId = null,
  }) {
    return _then(_$GetMonthlyShiftStatusParamsImpl(
      requestDate: null == requestDate
          ? _value.requestDate
          : requestDate // ignore: cast_nullable_to_non_nullable
              as String,
      companyId: null == companyId
          ? _value.companyId
          : companyId // ignore: cast_nullable_to_non_nullable
              as String,
      storeId: null == storeId
          ? _value.storeId
          : storeId // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$GetMonthlyShiftStatusParamsImpl
    implements _GetMonthlyShiftStatusParams {
  const _$GetMonthlyShiftStatusParamsImpl(
      {required this.requestDate,
      required this.companyId,
      required this.storeId});

  @override
  final String requestDate;
  @override
  final String companyId;
  @override
  final String storeId;

  @override
  String toString() {
    return 'GetMonthlyShiftStatusParams(requestDate: $requestDate, companyId: $companyId, storeId: $storeId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GetMonthlyShiftStatusParamsImpl &&
            (identical(other.requestDate, requestDate) ||
                other.requestDate == requestDate) &&
            (identical(other.companyId, companyId) ||
                other.companyId == companyId) &&
            (identical(other.storeId, storeId) || other.storeId == storeId));
  }

  @override
  int get hashCode => Object.hash(runtimeType, requestDate, companyId, storeId);

  /// Create a copy of GetMonthlyShiftStatusParams
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$GetMonthlyShiftStatusParamsImplCopyWith<_$GetMonthlyShiftStatusParamsImpl>
      get copyWith => __$$GetMonthlyShiftStatusParamsImplCopyWithImpl<
          _$GetMonthlyShiftStatusParamsImpl>(this, _$identity);
}

abstract class _GetMonthlyShiftStatusParams
    implements GetMonthlyShiftStatusParams {
  const factory _GetMonthlyShiftStatusParams(
      {required final String requestDate,
      required final String companyId,
      required final String storeId}) = _$GetMonthlyShiftStatusParamsImpl;

  @override
  String get requestDate;
  @override
  String get companyId;
  @override
  String get storeId;

  /// Create a copy of GetMonthlyShiftStatusParams
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$GetMonthlyShiftStatusParamsImplCopyWith<_$GetMonthlyShiftStatusParamsImpl>
      get copyWith => throw _privateConstructorUsedError;
}
