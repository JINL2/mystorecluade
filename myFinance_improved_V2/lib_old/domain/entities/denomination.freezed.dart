// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'denomination.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Denomination _$DenominationFromJson(Map<String, dynamic> json) {
  return _Denomination.fromJson(json);
}

/// @nodoc
mixin _$Denomination {
  String get id => throw _privateConstructorUsedError;
  String get companyId => throw _privateConstructorUsedError;
  String get currencyId => throw _privateConstructorUsedError;
  double get value => throw _privateConstructorUsedError;
  DenominationType get type => throw _privateConstructorUsedError;
  String get displayName => throw _privateConstructorUsedError;
  String get emoji => throw _privateConstructorUsedError;
  bool get isActive => throw _privateConstructorUsedError;
  DateTime? get createdAt => throw _privateConstructorUsedError;
  DateTime? get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this Denomination to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Denomination
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $DenominationCopyWith<Denomination> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DenominationCopyWith<$Res> {
  factory $DenominationCopyWith(
          Denomination value, $Res Function(Denomination) then) =
      _$DenominationCopyWithImpl<$Res, Denomination>;
  @useResult
  $Res call(
      {String id,
      String companyId,
      String currencyId,
      double value,
      DenominationType type,
      String displayName,
      String emoji,
      bool isActive,
      DateTime? createdAt,
      DateTime? updatedAt});
}

/// @nodoc
class _$DenominationCopyWithImpl<$Res, $Val extends Denomination>
    implements $DenominationCopyWith<$Res> {
  _$DenominationCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Denomination
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? companyId = null,
    Object? currencyId = null,
    Object? value = null,
    Object? type = null,
    Object? displayName = null,
    Object? emoji = null,
    Object? isActive = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      companyId: null == companyId
          ? _value.companyId
          : companyId // ignore: cast_nullable_to_non_nullable
              as String,
      currencyId: null == currencyId
          ? _value.currencyId
          : currencyId // ignore: cast_nullable_to_non_nullable
              as String,
      value: null == value
          ? _value.value
          : value // ignore: cast_nullable_to_non_nullable
              as double,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as DenominationType,
      displayName: null == displayName
          ? _value.displayName
          : displayName // ignore: cast_nullable_to_non_nullable
              as String,
      emoji: null == emoji
          ? _value.emoji
          : emoji // ignore: cast_nullable_to_non_nullable
              as String,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$DenominationImplCopyWith<$Res>
    implements $DenominationCopyWith<$Res> {
  factory _$$DenominationImplCopyWith(
          _$DenominationImpl value, $Res Function(_$DenominationImpl) then) =
      __$$DenominationImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String companyId,
      String currencyId,
      double value,
      DenominationType type,
      String displayName,
      String emoji,
      bool isActive,
      DateTime? createdAt,
      DateTime? updatedAt});
}

/// @nodoc
class __$$DenominationImplCopyWithImpl<$Res>
    extends _$DenominationCopyWithImpl<$Res, _$DenominationImpl>
    implements _$$DenominationImplCopyWith<$Res> {
  __$$DenominationImplCopyWithImpl(
      _$DenominationImpl _value, $Res Function(_$DenominationImpl) _then)
      : super(_value, _then);

  /// Create a copy of Denomination
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? companyId = null,
    Object? currencyId = null,
    Object? value = null,
    Object? type = null,
    Object? displayName = null,
    Object? emoji = null,
    Object? isActive = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_$DenominationImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      companyId: null == companyId
          ? _value.companyId
          : companyId // ignore: cast_nullable_to_non_nullable
              as String,
      currencyId: null == currencyId
          ? _value.currencyId
          : currencyId // ignore: cast_nullable_to_non_nullable
              as String,
      value: null == value
          ? _value.value
          : value // ignore: cast_nullable_to_non_nullable
              as double,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as DenominationType,
      displayName: null == displayName
          ? _value.displayName
          : displayName // ignore: cast_nullable_to_non_nullable
              as String,
      emoji: null == emoji
          ? _value.emoji
          : emoji // ignore: cast_nullable_to_non_nullable
              as String,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$DenominationImpl implements _Denomination {
  const _$DenominationImpl(
      {required this.id,
      required this.companyId,
      required this.currencyId,
      required this.value,
      required this.type,
      required this.displayName,
      required this.emoji,
      this.isActive = true,
      this.createdAt,
      this.updatedAt});

  factory _$DenominationImpl.fromJson(Map<String, dynamic> json) =>
      _$$DenominationImplFromJson(json);

  @override
  final String id;
  @override
  final String companyId;
  @override
  final String currencyId;
  @override
  final double value;
  @override
  final DenominationType type;
  @override
  final String displayName;
  @override
  final String emoji;
  @override
  @JsonKey()
  final bool isActive;
  @override
  final DateTime? createdAt;
  @override
  final DateTime? updatedAt;

  @override
  String toString() {
    return 'Denomination(id: $id, companyId: $companyId, currencyId: $currencyId, value: $value, type: $type, displayName: $displayName, emoji: $emoji, isActive: $isActive, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DenominationImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.companyId, companyId) ||
                other.companyId == companyId) &&
            (identical(other.currencyId, currencyId) ||
                other.currencyId == currencyId) &&
            (identical(other.value, value) || other.value == value) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.displayName, displayName) ||
                other.displayName == displayName) &&
            (identical(other.emoji, emoji) || other.emoji == emoji) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, companyId, currencyId, value,
      type, displayName, emoji, isActive, createdAt, updatedAt);

  /// Create a copy of Denomination
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DenominationImplCopyWith<_$DenominationImpl> get copyWith =>
      __$$DenominationImplCopyWithImpl<_$DenominationImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$DenominationImplToJson(
      this,
    );
  }
}

abstract class _Denomination implements Denomination {
  const factory _Denomination(
      {required final String id,
      required final String companyId,
      required final String currencyId,
      required final double value,
      required final DenominationType type,
      required final String displayName,
      required final String emoji,
      final bool isActive,
      final DateTime? createdAt,
      final DateTime? updatedAt}) = _$DenominationImpl;

  factory _Denomination.fromJson(Map<String, dynamic> json) =
      _$DenominationImpl.fromJson;

  @override
  String get id;
  @override
  String get companyId;
  @override
  String get currencyId;
  @override
  double get value;
  @override
  DenominationType get type;
  @override
  String get displayName;
  @override
  String get emoji;
  @override
  bool get isActive;
  @override
  DateTime? get createdAt;
  @override
  DateTime? get updatedAt;

  /// Create a copy of Denomination
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DenominationImplCopyWith<_$DenominationImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

DenominationInput _$DenominationInputFromJson(Map<String, dynamic> json) {
  return _DenominationInput.fromJson(json);
}

/// @nodoc
mixin _$DenominationInput {
  String get companyId => throw _privateConstructorUsedError;
  String get currencyId => throw _privateConstructorUsedError;
  double get value => throw _privateConstructorUsedError;
  DenominationType get type => throw _privateConstructorUsedError;
  String? get displayName => throw _privateConstructorUsedError;
  String? get emoji => throw _privateConstructorUsedError;

  /// Serializes this DenominationInput to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of DenominationInput
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $DenominationInputCopyWith<DenominationInput> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DenominationInputCopyWith<$Res> {
  factory $DenominationInputCopyWith(
          DenominationInput value, $Res Function(DenominationInput) then) =
      _$DenominationInputCopyWithImpl<$Res, DenominationInput>;
  @useResult
  $Res call(
      {String companyId,
      String currencyId,
      double value,
      DenominationType type,
      String? displayName,
      String? emoji});
}

/// @nodoc
class _$DenominationInputCopyWithImpl<$Res, $Val extends DenominationInput>
    implements $DenominationInputCopyWith<$Res> {
  _$DenominationInputCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of DenominationInput
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? companyId = null,
    Object? currencyId = null,
    Object? value = null,
    Object? type = null,
    Object? displayName = freezed,
    Object? emoji = freezed,
  }) {
    return _then(_value.copyWith(
      companyId: null == companyId
          ? _value.companyId
          : companyId // ignore: cast_nullable_to_non_nullable
              as String,
      currencyId: null == currencyId
          ? _value.currencyId
          : currencyId // ignore: cast_nullable_to_non_nullable
              as String,
      value: null == value
          ? _value.value
          : value // ignore: cast_nullable_to_non_nullable
              as double,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as DenominationType,
      displayName: freezed == displayName
          ? _value.displayName
          : displayName // ignore: cast_nullable_to_non_nullable
              as String?,
      emoji: freezed == emoji
          ? _value.emoji
          : emoji // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$DenominationInputImplCopyWith<$Res>
    implements $DenominationInputCopyWith<$Res> {
  factory _$$DenominationInputImplCopyWith(_$DenominationInputImpl value,
          $Res Function(_$DenominationInputImpl) then) =
      __$$DenominationInputImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String companyId,
      String currencyId,
      double value,
      DenominationType type,
      String? displayName,
      String? emoji});
}

/// @nodoc
class __$$DenominationInputImplCopyWithImpl<$Res>
    extends _$DenominationInputCopyWithImpl<$Res, _$DenominationInputImpl>
    implements _$$DenominationInputImplCopyWith<$Res> {
  __$$DenominationInputImplCopyWithImpl(_$DenominationInputImpl _value,
      $Res Function(_$DenominationInputImpl) _then)
      : super(_value, _then);

  /// Create a copy of DenominationInput
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? companyId = null,
    Object? currencyId = null,
    Object? value = null,
    Object? type = null,
    Object? displayName = freezed,
    Object? emoji = freezed,
  }) {
    return _then(_$DenominationInputImpl(
      companyId: null == companyId
          ? _value.companyId
          : companyId // ignore: cast_nullable_to_non_nullable
              as String,
      currencyId: null == currencyId
          ? _value.currencyId
          : currencyId // ignore: cast_nullable_to_non_nullable
              as String,
      value: null == value
          ? _value.value
          : value // ignore: cast_nullable_to_non_nullable
              as double,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as DenominationType,
      displayName: freezed == displayName
          ? _value.displayName
          : displayName // ignore: cast_nullable_to_non_nullable
              as String?,
      emoji: freezed == emoji
          ? _value.emoji
          : emoji // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$DenominationInputImpl implements _DenominationInput {
  const _$DenominationInputImpl(
      {required this.companyId,
      required this.currencyId,
      required this.value,
      required this.type,
      this.displayName,
      this.emoji});

  factory _$DenominationInputImpl.fromJson(Map<String, dynamic> json) =>
      _$$DenominationInputImplFromJson(json);

  @override
  final String companyId;
  @override
  final String currencyId;
  @override
  final double value;
  @override
  final DenominationType type;
  @override
  final String? displayName;
  @override
  final String? emoji;

  @override
  String toString() {
    return 'DenominationInput(companyId: $companyId, currencyId: $currencyId, value: $value, type: $type, displayName: $displayName, emoji: $emoji)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DenominationInputImpl &&
            (identical(other.companyId, companyId) ||
                other.companyId == companyId) &&
            (identical(other.currencyId, currencyId) ||
                other.currencyId == currencyId) &&
            (identical(other.value, value) || other.value == value) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.displayName, displayName) ||
                other.displayName == displayName) &&
            (identical(other.emoji, emoji) || other.emoji == emoji));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, companyId, currencyId, value, type, displayName, emoji);

  /// Create a copy of DenominationInput
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DenominationInputImplCopyWith<_$DenominationInputImpl> get copyWith =>
      __$$DenominationInputImplCopyWithImpl<_$DenominationInputImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$DenominationInputImplToJson(
      this,
    );
  }
}

abstract class _DenominationInput implements DenominationInput {
  const factory _DenominationInput(
      {required final String companyId,
      required final String currencyId,
      required final double value,
      required final DenominationType type,
      final String? displayName,
      final String? emoji}) = _$DenominationInputImpl;

  factory _DenominationInput.fromJson(Map<String, dynamic> json) =
      _$DenominationInputImpl.fromJson;

  @override
  String get companyId;
  @override
  String get currencyId;
  @override
  double get value;
  @override
  DenominationType get type;
  @override
  String? get displayName;
  @override
  String? get emoji;

  /// Create a copy of DenominationInput
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DenominationInputImplCopyWith<_$DenominationInputImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
