// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'get_tags_by_card_id.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$GetTagsByCardIdParams {
  String get cardId => throw _privateConstructorUsedError;

  /// Create a copy of GetTagsByCardIdParams
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $GetTagsByCardIdParamsCopyWith<GetTagsByCardIdParams> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GetTagsByCardIdParamsCopyWith<$Res> {
  factory $GetTagsByCardIdParamsCopyWith(GetTagsByCardIdParams value,
          $Res Function(GetTagsByCardIdParams) then) =
      _$GetTagsByCardIdParamsCopyWithImpl<$Res, GetTagsByCardIdParams>;
  @useResult
  $Res call({String cardId});
}

/// @nodoc
class _$GetTagsByCardIdParamsCopyWithImpl<$Res,
        $Val extends GetTagsByCardIdParams>
    implements $GetTagsByCardIdParamsCopyWith<$Res> {
  _$GetTagsByCardIdParamsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of GetTagsByCardIdParams
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? cardId = null,
  }) {
    return _then(_value.copyWith(
      cardId: null == cardId
          ? _value.cardId
          : cardId // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$GetTagsByCardIdParamsImplCopyWith<$Res>
    implements $GetTagsByCardIdParamsCopyWith<$Res> {
  factory _$$GetTagsByCardIdParamsImplCopyWith(
          _$GetTagsByCardIdParamsImpl value,
          $Res Function(_$GetTagsByCardIdParamsImpl) then) =
      __$$GetTagsByCardIdParamsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String cardId});
}

/// @nodoc
class __$$GetTagsByCardIdParamsImplCopyWithImpl<$Res>
    extends _$GetTagsByCardIdParamsCopyWithImpl<$Res,
        _$GetTagsByCardIdParamsImpl>
    implements _$$GetTagsByCardIdParamsImplCopyWith<$Res> {
  __$$GetTagsByCardIdParamsImplCopyWithImpl(_$GetTagsByCardIdParamsImpl _value,
      $Res Function(_$GetTagsByCardIdParamsImpl) _then)
      : super(_value, _then);

  /// Create a copy of GetTagsByCardIdParams
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? cardId = null,
  }) {
    return _then(_$GetTagsByCardIdParamsImpl(
      cardId: null == cardId
          ? _value.cardId
          : cardId // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$GetTagsByCardIdParamsImpl implements _GetTagsByCardIdParams {
  const _$GetTagsByCardIdParamsImpl({required this.cardId});

  @override
  final String cardId;

  @override
  String toString() {
    return 'GetTagsByCardIdParams(cardId: $cardId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GetTagsByCardIdParamsImpl &&
            (identical(other.cardId, cardId) || other.cardId == cardId));
  }

  @override
  int get hashCode => Object.hash(runtimeType, cardId);

  /// Create a copy of GetTagsByCardIdParams
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$GetTagsByCardIdParamsImplCopyWith<_$GetTagsByCardIdParamsImpl>
      get copyWith => __$$GetTagsByCardIdParamsImplCopyWithImpl<
          _$GetTagsByCardIdParamsImpl>(this, _$identity);
}

abstract class _GetTagsByCardIdParams implements GetTagsByCardIdParams {
  const factory _GetTagsByCardIdParams({required final String cardId}) =
      _$GetTagsByCardIdParamsImpl;

  @override
  String get cardId;

  /// Create a copy of GetTagsByCardIdParams
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$GetTagsByCardIdParamsImplCopyWith<_$GetTagsByCardIdParamsImpl>
      get copyWith => throw _privateConstructorUsedError;
}
