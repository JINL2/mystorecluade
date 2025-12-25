// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'counterparty.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$Counterparty {
  String get counterpartyId => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String? get type => throw _privateConstructorUsedError;
  bool get isInternal => throw _privateConstructorUsedError;
  String? get linkedCompanyId => throw _privateConstructorUsedError;

  /// Create a copy of Counterparty
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CounterpartyCopyWith<Counterparty> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CounterpartyCopyWith<$Res> {
  factory $CounterpartyCopyWith(
          Counterparty value, $Res Function(Counterparty) then) =
      _$CounterpartyCopyWithImpl<$Res, Counterparty>;
  @useResult
  $Res call(
      {String counterpartyId,
      String name,
      String? type,
      bool isInternal,
      String? linkedCompanyId});
}

/// @nodoc
class _$CounterpartyCopyWithImpl<$Res, $Val extends Counterparty>
    implements $CounterpartyCopyWith<$Res> {
  _$CounterpartyCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Counterparty
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? counterpartyId = null,
    Object? name = null,
    Object? type = freezed,
    Object? isInternal = null,
    Object? linkedCompanyId = freezed,
  }) {
    return _then(_value.copyWith(
      counterpartyId: null == counterpartyId
          ? _value.counterpartyId
          : counterpartyId // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      type: freezed == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String?,
      isInternal: null == isInternal
          ? _value.isInternal
          : isInternal // ignore: cast_nullable_to_non_nullable
              as bool,
      linkedCompanyId: freezed == linkedCompanyId
          ? _value.linkedCompanyId
          : linkedCompanyId // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CounterpartyImplCopyWith<$Res>
    implements $CounterpartyCopyWith<$Res> {
  factory _$$CounterpartyImplCopyWith(
          _$CounterpartyImpl value, $Res Function(_$CounterpartyImpl) then) =
      __$$CounterpartyImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String counterpartyId,
      String name,
      String? type,
      bool isInternal,
      String? linkedCompanyId});
}

/// @nodoc
class __$$CounterpartyImplCopyWithImpl<$Res>
    extends _$CounterpartyCopyWithImpl<$Res, _$CounterpartyImpl>
    implements _$$CounterpartyImplCopyWith<$Res> {
  __$$CounterpartyImplCopyWithImpl(
      _$CounterpartyImpl _value, $Res Function(_$CounterpartyImpl) _then)
      : super(_value, _then);

  /// Create a copy of Counterparty
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? counterpartyId = null,
    Object? name = null,
    Object? type = freezed,
    Object? isInternal = null,
    Object? linkedCompanyId = freezed,
  }) {
    return _then(_$CounterpartyImpl(
      counterpartyId: null == counterpartyId
          ? _value.counterpartyId
          : counterpartyId // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      type: freezed == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String?,
      isInternal: null == isInternal
          ? _value.isInternal
          : isInternal // ignore: cast_nullable_to_non_nullable
              as bool,
      linkedCompanyId: freezed == linkedCompanyId
          ? _value.linkedCompanyId
          : linkedCompanyId // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$CounterpartyImpl extends _Counterparty {
  const _$CounterpartyImpl(
      {required this.counterpartyId,
      required this.name,
      this.type,
      this.isInternal = false,
      this.linkedCompanyId})
      : super._();

  @override
  final String counterpartyId;
  @override
  final String name;
  @override
  final String? type;
  @override
  @JsonKey()
  final bool isInternal;
  @override
  final String? linkedCompanyId;

  @override
  String toString() {
    return 'Counterparty(counterpartyId: $counterpartyId, name: $name, type: $type, isInternal: $isInternal, linkedCompanyId: $linkedCompanyId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CounterpartyImpl &&
            (identical(other.counterpartyId, counterpartyId) ||
                other.counterpartyId == counterpartyId) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.isInternal, isInternal) ||
                other.isInternal == isInternal) &&
            (identical(other.linkedCompanyId, linkedCompanyId) ||
                other.linkedCompanyId == linkedCompanyId));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, counterpartyId, name, type, isInternal, linkedCompanyId);

  /// Create a copy of Counterparty
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CounterpartyImplCopyWith<_$CounterpartyImpl> get copyWith =>
      __$$CounterpartyImplCopyWithImpl<_$CounterpartyImpl>(this, _$identity);
}

abstract class _Counterparty extends Counterparty {
  const factory _Counterparty(
      {required final String counterpartyId,
      required final String name,
      final String? type,
      final bool isInternal,
      final String? linkedCompanyId}) = _$CounterpartyImpl;
  const _Counterparty._() : super._();

  @override
  String get counterpartyId;
  @override
  String get name;
  @override
  String? get type;
  @override
  bool get isInternal;
  @override
  String? get linkedCompanyId;

  /// Create a copy of Counterparty
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CounterpartyImplCopyWith<_$CounterpartyImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
