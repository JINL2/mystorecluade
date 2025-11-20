// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'subscription_response_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

SubscriptionResponseDto _$SubscriptionResponseDtoFromJson(
    Map<String, dynamic> json) {
  return _SubscriptionResponseDto.fromJson(json);
}

/// @nodoc
mixin _$SubscriptionResponseDto {
  @JsonKey(name: 'subscription_id')
  String get subscriptionId => throw _privateConstructorUsedError;

  /// Serializes this SubscriptionResponseDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SubscriptionResponseDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SubscriptionResponseDtoCopyWith<SubscriptionResponseDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SubscriptionResponseDtoCopyWith<$Res> {
  factory $SubscriptionResponseDtoCopyWith(SubscriptionResponseDto value,
          $Res Function(SubscriptionResponseDto) then) =
      _$SubscriptionResponseDtoCopyWithImpl<$Res, SubscriptionResponseDto>;
  @useResult
  $Res call({@JsonKey(name: 'subscription_id') String subscriptionId});
}

/// @nodoc
class _$SubscriptionResponseDtoCopyWithImpl<$Res,
        $Val extends SubscriptionResponseDto>
    implements $SubscriptionResponseDtoCopyWith<$Res> {
  _$SubscriptionResponseDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SubscriptionResponseDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? subscriptionId = null,
  }) {
    return _then(_value.copyWith(
      subscriptionId: null == subscriptionId
          ? _value.subscriptionId
          : subscriptionId // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SubscriptionResponseDtoImplCopyWith<$Res>
    implements $SubscriptionResponseDtoCopyWith<$Res> {
  factory _$$SubscriptionResponseDtoImplCopyWith(
          _$SubscriptionResponseDtoImpl value,
          $Res Function(_$SubscriptionResponseDtoImpl) then) =
      __$$SubscriptionResponseDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({@JsonKey(name: 'subscription_id') String subscriptionId});
}

/// @nodoc
class __$$SubscriptionResponseDtoImplCopyWithImpl<$Res>
    extends _$SubscriptionResponseDtoCopyWithImpl<$Res,
        _$SubscriptionResponseDtoImpl>
    implements _$$SubscriptionResponseDtoImplCopyWith<$Res> {
  __$$SubscriptionResponseDtoImplCopyWithImpl(
      _$SubscriptionResponseDtoImpl _value,
      $Res Function(_$SubscriptionResponseDtoImpl) _then)
      : super(_value, _then);

  /// Create a copy of SubscriptionResponseDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? subscriptionId = null,
  }) {
    return _then(_$SubscriptionResponseDtoImpl(
      subscriptionId: null == subscriptionId
          ? _value.subscriptionId
          : subscriptionId // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SubscriptionResponseDtoImpl implements _SubscriptionResponseDto {
  const _$SubscriptionResponseDtoImpl(
      {@JsonKey(name: 'subscription_id') required this.subscriptionId});

  factory _$SubscriptionResponseDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$SubscriptionResponseDtoImplFromJson(json);

  @override
  @JsonKey(name: 'subscription_id')
  final String subscriptionId;

  @override
  String toString() {
    return 'SubscriptionResponseDto(subscriptionId: $subscriptionId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SubscriptionResponseDtoImpl &&
            (identical(other.subscriptionId, subscriptionId) ||
                other.subscriptionId == subscriptionId));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, subscriptionId);

  /// Create a copy of SubscriptionResponseDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SubscriptionResponseDtoImplCopyWith<_$SubscriptionResponseDtoImpl>
      get copyWith => __$$SubscriptionResponseDtoImplCopyWithImpl<
          _$SubscriptionResponseDtoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SubscriptionResponseDtoImplToJson(
      this,
    );
  }
}

abstract class _SubscriptionResponseDto implements SubscriptionResponseDto {
  const factory _SubscriptionResponseDto(
      {@JsonKey(name: 'subscription_id')
      required final String subscriptionId}) = _$SubscriptionResponseDtoImpl;

  factory _SubscriptionResponseDto.fromJson(Map<String, dynamic> json) =
      _$SubscriptionResponseDtoImpl.fromJson;

  @override
  @JsonKey(name: 'subscription_id')
  String get subscriptionId;

  /// Create a copy of SubscriptionResponseDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SubscriptionResponseDtoImplCopyWith<_$SubscriptionResponseDtoImpl>
      get copyWith => throw _privateConstructorUsedError;
}
