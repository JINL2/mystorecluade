// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'denomination_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

DenominationDto _$DenominationDtoFromJson(Map<String, dynamic> json) {
  return _DenominationDto.fromJson(json);
}

/// @nodoc
mixin _$DenominationDto {
  @JsonKey(name: 'denomination_id')
  String get denominationId => throw _privateConstructorUsedError;
  @JsonKey(name: 'currency_id')
  String? get currencyId =>
      throw _privateConstructorUsedError; // Optional: not in RPC JSONB
  @JsonKey(name: 'value')
  double get value => throw _privateConstructorUsedError;
  @JsonKey(name: 'quantity')
  int get quantity => throw _privateConstructorUsedError;
  @JsonKey(name: 'type')
  String? get type => throw _privateConstructorUsedError;

  /// Serializes this DenominationDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of DenominationDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $DenominationDtoCopyWith<DenominationDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DenominationDtoCopyWith<$Res> {
  factory $DenominationDtoCopyWith(
          DenominationDto value, $Res Function(DenominationDto) then) =
      _$DenominationDtoCopyWithImpl<$Res, DenominationDto>;
  @useResult
  $Res call(
      {@JsonKey(name: 'denomination_id') String denominationId,
      @JsonKey(name: 'currency_id') String? currencyId,
      @JsonKey(name: 'value') double value,
      @JsonKey(name: 'quantity') int quantity,
      @JsonKey(name: 'type') String? type});
}

/// @nodoc
class _$DenominationDtoCopyWithImpl<$Res, $Val extends DenominationDto>
    implements $DenominationDtoCopyWith<$Res> {
  _$DenominationDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of DenominationDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? denominationId = null,
    Object? currencyId = freezed,
    Object? value = null,
    Object? quantity = null,
    Object? type = freezed,
  }) {
    return _then(_value.copyWith(
      denominationId: null == denominationId
          ? _value.denominationId
          : denominationId // ignore: cast_nullable_to_non_nullable
              as String,
      currencyId: freezed == currencyId
          ? _value.currencyId
          : currencyId // ignore: cast_nullable_to_non_nullable
              as String?,
      value: null == value
          ? _value.value
          : value // ignore: cast_nullable_to_non_nullable
              as double,
      quantity: null == quantity
          ? _value.quantity
          : quantity // ignore: cast_nullable_to_non_nullable
              as int,
      type: freezed == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$DenominationDtoImplCopyWith<$Res>
    implements $DenominationDtoCopyWith<$Res> {
  factory _$$DenominationDtoImplCopyWith(_$DenominationDtoImpl value,
          $Res Function(_$DenominationDtoImpl) then) =
      __$$DenominationDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'denomination_id') String denominationId,
      @JsonKey(name: 'currency_id') String? currencyId,
      @JsonKey(name: 'value') double value,
      @JsonKey(name: 'quantity') int quantity,
      @JsonKey(name: 'type') String? type});
}

/// @nodoc
class __$$DenominationDtoImplCopyWithImpl<$Res>
    extends _$DenominationDtoCopyWithImpl<$Res, _$DenominationDtoImpl>
    implements _$$DenominationDtoImplCopyWith<$Res> {
  __$$DenominationDtoImplCopyWithImpl(
      _$DenominationDtoImpl _value, $Res Function(_$DenominationDtoImpl) _then)
      : super(_value, _then);

  /// Create a copy of DenominationDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? denominationId = null,
    Object? currencyId = freezed,
    Object? value = null,
    Object? quantity = null,
    Object? type = freezed,
  }) {
    return _then(_$DenominationDtoImpl(
      denominationId: null == denominationId
          ? _value.denominationId
          : denominationId // ignore: cast_nullable_to_non_nullable
              as String,
      currencyId: freezed == currencyId
          ? _value.currencyId
          : currencyId // ignore: cast_nullable_to_non_nullable
              as String?,
      value: null == value
          ? _value.value
          : value // ignore: cast_nullable_to_non_nullable
              as double,
      quantity: null == quantity
          ? _value.quantity
          : quantity // ignore: cast_nullable_to_non_nullable
              as int,
      type: freezed == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$DenominationDtoImpl extends _DenominationDto {
  const _$DenominationDtoImpl(
      {@JsonKey(name: 'denomination_id') required this.denominationId,
      @JsonKey(name: 'currency_id') this.currencyId,
      @JsonKey(name: 'value') required this.value,
      @JsonKey(name: 'quantity') this.quantity = 0,
      @JsonKey(name: 'type') this.type})
      : super._();

  factory _$DenominationDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$DenominationDtoImplFromJson(json);

  @override
  @JsonKey(name: 'denomination_id')
  final String denominationId;
  @override
  @JsonKey(name: 'currency_id')
  final String? currencyId;
// Optional: not in RPC JSONB
  @override
  @JsonKey(name: 'value')
  final double value;
  @override
  @JsonKey(name: 'quantity')
  final int quantity;
  @override
  @JsonKey(name: 'type')
  final String? type;

  @override
  String toString() {
    return 'DenominationDto(denominationId: $denominationId, currencyId: $currencyId, value: $value, quantity: $quantity, type: $type)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DenominationDtoImpl &&
            (identical(other.denominationId, denominationId) ||
                other.denominationId == denominationId) &&
            (identical(other.currencyId, currencyId) ||
                other.currencyId == currencyId) &&
            (identical(other.value, value) || other.value == value) &&
            (identical(other.quantity, quantity) ||
                other.quantity == quantity) &&
            (identical(other.type, type) || other.type == type));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, denominationId, currencyId, value, quantity, type);

  /// Create a copy of DenominationDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DenominationDtoImplCopyWith<_$DenominationDtoImpl> get copyWith =>
      __$$DenominationDtoImplCopyWithImpl<_$DenominationDtoImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$DenominationDtoImplToJson(
      this,
    );
  }
}

abstract class _DenominationDto extends DenominationDto {
  const factory _DenominationDto(
      {@JsonKey(name: 'denomination_id') required final String denominationId,
      @JsonKey(name: 'currency_id') final String? currencyId,
      @JsonKey(name: 'value') required final double value,
      @JsonKey(name: 'quantity') final int quantity,
      @JsonKey(name: 'type') final String? type}) = _$DenominationDtoImpl;
  const _DenominationDto._() : super._();

  factory _DenominationDto.fromJson(Map<String, dynamic> json) =
      _$DenominationDtoImpl.fromJson;

  @override
  @JsonKey(name: 'denomination_id')
  String get denominationId;
  @override
  @JsonKey(name: 'currency_id')
  String? get currencyId; // Optional: not in RPC JSONB
  @override
  @JsonKey(name: 'value')
  double get value;
  @override
  @JsonKey(name: 'quantity')
  int get quantity;
  @override
  @JsonKey(name: 'type')
  String? get type;

  /// Create a copy of DenominationDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DenominationDtoImplCopyWith<_$DenominationDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
