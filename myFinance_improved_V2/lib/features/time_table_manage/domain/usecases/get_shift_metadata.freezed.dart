// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'get_shift_metadata.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$GetShiftMetadataParams {
  String get storeId => throw _privateConstructorUsedError;

  /// Create a copy of GetShiftMetadataParams
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $GetShiftMetadataParamsCopyWith<GetShiftMetadataParams> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GetShiftMetadataParamsCopyWith<$Res> {
  factory $GetShiftMetadataParamsCopyWith(GetShiftMetadataParams value,
          $Res Function(GetShiftMetadataParams) then) =
      _$GetShiftMetadataParamsCopyWithImpl<$Res, GetShiftMetadataParams>;
  @useResult
  $Res call({String storeId});
}

/// @nodoc
class _$GetShiftMetadataParamsCopyWithImpl<$Res,
        $Val extends GetShiftMetadataParams>
    implements $GetShiftMetadataParamsCopyWith<$Res> {
  _$GetShiftMetadataParamsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of GetShiftMetadataParams
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? storeId = null,
  }) {
    return _then(_value.copyWith(
      storeId: null == storeId
          ? _value.storeId
          : storeId // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$GetShiftMetadataParamsImplCopyWith<$Res>
    implements $GetShiftMetadataParamsCopyWith<$Res> {
  factory _$$GetShiftMetadataParamsImplCopyWith(
          _$GetShiftMetadataParamsImpl value,
          $Res Function(_$GetShiftMetadataParamsImpl) then) =
      __$$GetShiftMetadataParamsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String storeId});
}

/// @nodoc
class __$$GetShiftMetadataParamsImplCopyWithImpl<$Res>
    extends _$GetShiftMetadataParamsCopyWithImpl<$Res,
        _$GetShiftMetadataParamsImpl>
    implements _$$GetShiftMetadataParamsImplCopyWith<$Res> {
  __$$GetShiftMetadataParamsImplCopyWithImpl(
      _$GetShiftMetadataParamsImpl _value,
      $Res Function(_$GetShiftMetadataParamsImpl) _then)
      : super(_value, _then);

  /// Create a copy of GetShiftMetadataParams
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? storeId = null,
  }) {
    return _then(_$GetShiftMetadataParamsImpl(
      storeId: null == storeId
          ? _value.storeId
          : storeId // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$GetShiftMetadataParamsImpl implements _GetShiftMetadataParams {
  const _$GetShiftMetadataParamsImpl({required this.storeId});

  @override
  final String storeId;

  @override
  String toString() {
    return 'GetShiftMetadataParams(storeId: $storeId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GetShiftMetadataParamsImpl &&
            (identical(other.storeId, storeId) || other.storeId == storeId));
  }

  @override
  int get hashCode => Object.hash(runtimeType, storeId);

  /// Create a copy of GetShiftMetadataParams
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$GetShiftMetadataParamsImplCopyWith<_$GetShiftMetadataParamsImpl>
      get copyWith => __$$GetShiftMetadataParamsImplCopyWithImpl<
          _$GetShiftMetadataParamsImpl>(this, _$identity);
}

abstract class _GetShiftMetadataParams implements GetShiftMetadataParams {
  const factory _GetShiftMetadataParams({required final String storeId}) =
      _$GetShiftMetadataParamsImpl;

  @override
  String get storeId;

  /// Create a copy of GetShiftMetadataParams
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$GetShiftMetadataParamsImplCopyWith<_$GetShiftMetadataParamsImpl>
      get copyWith => throw _privateConstructorUsedError;
}
