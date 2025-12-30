// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'lc_type.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

LCType _$LCTypeFromJson(Map<String, dynamic> json) {
  return _LCType.fromJson(json);
}

/// @nodoc
mixin _$LCType {
  @JsonKey(name: 'lc_type_id')
  String get lcTypeId => throw _privateConstructorUsedError;
  String get code => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_revocable')
  bool get isRevocable => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_confirmed')
  bool get isConfirmed => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_transferable')
  bool get isTransferable => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_revolving')
  bool get isRevolving => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_standby')
  bool get isStandby => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_active')
  bool get isActive => throw _privateConstructorUsedError;
  @JsonKey(name: 'display_order')
  int? get displayOrder => throw _privateConstructorUsedError;

  /// Serializes this LCType to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of LCType
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $LCTypeCopyWith<LCType> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LCTypeCopyWith<$Res> {
  factory $LCTypeCopyWith(LCType value, $Res Function(LCType) then) =
      _$LCTypeCopyWithImpl<$Res, LCType>;
  @useResult
  $Res call(
      {@JsonKey(name: 'lc_type_id') String lcTypeId,
      String code,
      String name,
      String? description,
      @JsonKey(name: 'is_revocable') bool isRevocable,
      @JsonKey(name: 'is_confirmed') bool isConfirmed,
      @JsonKey(name: 'is_transferable') bool isTransferable,
      @JsonKey(name: 'is_revolving') bool isRevolving,
      @JsonKey(name: 'is_standby') bool isStandby,
      @JsonKey(name: 'is_active') bool isActive,
      @JsonKey(name: 'display_order') int? displayOrder});
}

/// @nodoc
class _$LCTypeCopyWithImpl<$Res, $Val extends LCType>
    implements $LCTypeCopyWith<$Res> {
  _$LCTypeCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of LCType
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? lcTypeId = null,
    Object? code = null,
    Object? name = null,
    Object? description = freezed,
    Object? isRevocable = null,
    Object? isConfirmed = null,
    Object? isTransferable = null,
    Object? isRevolving = null,
    Object? isStandby = null,
    Object? isActive = null,
    Object? displayOrder = freezed,
  }) {
    return _then(_value.copyWith(
      lcTypeId: null == lcTypeId
          ? _value.lcTypeId
          : lcTypeId // ignore: cast_nullable_to_non_nullable
              as String,
      code: null == code
          ? _value.code
          : code // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      isRevocable: null == isRevocable
          ? _value.isRevocable
          : isRevocable // ignore: cast_nullable_to_non_nullable
              as bool,
      isConfirmed: null == isConfirmed
          ? _value.isConfirmed
          : isConfirmed // ignore: cast_nullable_to_non_nullable
              as bool,
      isTransferable: null == isTransferable
          ? _value.isTransferable
          : isTransferable // ignore: cast_nullable_to_non_nullable
              as bool,
      isRevolving: null == isRevolving
          ? _value.isRevolving
          : isRevolving // ignore: cast_nullable_to_non_nullable
              as bool,
      isStandby: null == isStandby
          ? _value.isStandby
          : isStandby // ignore: cast_nullable_to_non_nullable
              as bool,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
      displayOrder: freezed == displayOrder
          ? _value.displayOrder
          : displayOrder // ignore: cast_nullable_to_non_nullable
              as int?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$LCTypeImplCopyWith<$Res> implements $LCTypeCopyWith<$Res> {
  factory _$$LCTypeImplCopyWith(
          _$LCTypeImpl value, $Res Function(_$LCTypeImpl) then) =
      __$$LCTypeImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'lc_type_id') String lcTypeId,
      String code,
      String name,
      String? description,
      @JsonKey(name: 'is_revocable') bool isRevocable,
      @JsonKey(name: 'is_confirmed') bool isConfirmed,
      @JsonKey(name: 'is_transferable') bool isTransferable,
      @JsonKey(name: 'is_revolving') bool isRevolving,
      @JsonKey(name: 'is_standby') bool isStandby,
      @JsonKey(name: 'is_active') bool isActive,
      @JsonKey(name: 'display_order') int? displayOrder});
}

/// @nodoc
class __$$LCTypeImplCopyWithImpl<$Res>
    extends _$LCTypeCopyWithImpl<$Res, _$LCTypeImpl>
    implements _$$LCTypeImplCopyWith<$Res> {
  __$$LCTypeImplCopyWithImpl(
      _$LCTypeImpl _value, $Res Function(_$LCTypeImpl) _then)
      : super(_value, _then);

  /// Create a copy of LCType
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? lcTypeId = null,
    Object? code = null,
    Object? name = null,
    Object? description = freezed,
    Object? isRevocable = null,
    Object? isConfirmed = null,
    Object? isTransferable = null,
    Object? isRevolving = null,
    Object? isStandby = null,
    Object? isActive = null,
    Object? displayOrder = freezed,
  }) {
    return _then(_$LCTypeImpl(
      lcTypeId: null == lcTypeId
          ? _value.lcTypeId
          : lcTypeId // ignore: cast_nullable_to_non_nullable
              as String,
      code: null == code
          ? _value.code
          : code // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      isRevocable: null == isRevocable
          ? _value.isRevocable
          : isRevocable // ignore: cast_nullable_to_non_nullable
              as bool,
      isConfirmed: null == isConfirmed
          ? _value.isConfirmed
          : isConfirmed // ignore: cast_nullable_to_non_nullable
              as bool,
      isTransferable: null == isTransferable
          ? _value.isTransferable
          : isTransferable // ignore: cast_nullable_to_non_nullable
              as bool,
      isRevolving: null == isRevolving
          ? _value.isRevolving
          : isRevolving // ignore: cast_nullable_to_non_nullable
              as bool,
      isStandby: null == isStandby
          ? _value.isStandby
          : isStandby // ignore: cast_nullable_to_non_nullable
              as bool,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
      displayOrder: freezed == displayOrder
          ? _value.displayOrder
          : displayOrder // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$LCTypeImpl implements _LCType {
  const _$LCTypeImpl(
      {@JsonKey(name: 'lc_type_id') required this.lcTypeId,
      required this.code,
      required this.name,
      this.description,
      @JsonKey(name: 'is_revocable') this.isRevocable = false,
      @JsonKey(name: 'is_confirmed') this.isConfirmed = false,
      @JsonKey(name: 'is_transferable') this.isTransferable = false,
      @JsonKey(name: 'is_revolving') this.isRevolving = false,
      @JsonKey(name: 'is_standby') this.isStandby = false,
      @JsonKey(name: 'is_active') this.isActive = true,
      @JsonKey(name: 'display_order') this.displayOrder});

  factory _$LCTypeImpl.fromJson(Map<String, dynamic> json) =>
      _$$LCTypeImplFromJson(json);

  @override
  @JsonKey(name: 'lc_type_id')
  final String lcTypeId;
  @override
  final String code;
  @override
  final String name;
  @override
  final String? description;
  @override
  @JsonKey(name: 'is_revocable')
  final bool isRevocable;
  @override
  @JsonKey(name: 'is_confirmed')
  final bool isConfirmed;
  @override
  @JsonKey(name: 'is_transferable')
  final bool isTransferable;
  @override
  @JsonKey(name: 'is_revolving')
  final bool isRevolving;
  @override
  @JsonKey(name: 'is_standby')
  final bool isStandby;
  @override
  @JsonKey(name: 'is_active')
  final bool isActive;
  @override
  @JsonKey(name: 'display_order')
  final int? displayOrder;

  @override
  String toString() {
    return 'LCType(lcTypeId: $lcTypeId, code: $code, name: $name, description: $description, isRevocable: $isRevocable, isConfirmed: $isConfirmed, isTransferable: $isTransferable, isRevolving: $isRevolving, isStandby: $isStandby, isActive: $isActive, displayOrder: $displayOrder)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LCTypeImpl &&
            (identical(other.lcTypeId, lcTypeId) ||
                other.lcTypeId == lcTypeId) &&
            (identical(other.code, code) || other.code == code) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.isRevocable, isRevocable) ||
                other.isRevocable == isRevocable) &&
            (identical(other.isConfirmed, isConfirmed) ||
                other.isConfirmed == isConfirmed) &&
            (identical(other.isTransferable, isTransferable) ||
                other.isTransferable == isTransferable) &&
            (identical(other.isRevolving, isRevolving) ||
                other.isRevolving == isRevolving) &&
            (identical(other.isStandby, isStandby) ||
                other.isStandby == isStandby) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive) &&
            (identical(other.displayOrder, displayOrder) ||
                other.displayOrder == displayOrder));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      lcTypeId,
      code,
      name,
      description,
      isRevocable,
      isConfirmed,
      isTransferable,
      isRevolving,
      isStandby,
      isActive,
      displayOrder);

  /// Create a copy of LCType
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$LCTypeImplCopyWith<_$LCTypeImpl> get copyWith =>
      __$$LCTypeImplCopyWithImpl<_$LCTypeImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$LCTypeImplToJson(
      this,
    );
  }
}

abstract class _LCType implements LCType {
  const factory _LCType(
      {@JsonKey(name: 'lc_type_id') required final String lcTypeId,
      required final String code,
      required final String name,
      final String? description,
      @JsonKey(name: 'is_revocable') final bool isRevocable,
      @JsonKey(name: 'is_confirmed') final bool isConfirmed,
      @JsonKey(name: 'is_transferable') final bool isTransferable,
      @JsonKey(name: 'is_revolving') final bool isRevolving,
      @JsonKey(name: 'is_standby') final bool isStandby,
      @JsonKey(name: 'is_active') final bool isActive,
      @JsonKey(name: 'display_order') final int? displayOrder}) = _$LCTypeImpl;

  factory _LCType.fromJson(Map<String, dynamic> json) = _$LCTypeImpl.fromJson;

  @override
  @JsonKey(name: 'lc_type_id')
  String get lcTypeId;
  @override
  String get code;
  @override
  String get name;
  @override
  String? get description;
  @override
  @JsonKey(name: 'is_revocable')
  bool get isRevocable;
  @override
  @JsonKey(name: 'is_confirmed')
  bool get isConfirmed;
  @override
  @JsonKey(name: 'is_transferable')
  bool get isTransferable;
  @override
  @JsonKey(name: 'is_revolving')
  bool get isRevolving;
  @override
  @JsonKey(name: 'is_standby')
  bool get isStandby;
  @override
  @JsonKey(name: 'is_active')
  bool get isActive;
  @override
  @JsonKey(name: 'display_order')
  int? get displayOrder;

  /// Create a copy of LCType
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$LCTypeImplCopyWith<_$LCTypeImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

LCPaymentTerm _$LCPaymentTermFromJson(Map<String, dynamic> json) {
  return _LCPaymentTerm.fromJson(json);
}

/// @nodoc
mixin _$LCPaymentTerm {
  @JsonKey(name: 'payment_term_id')
  String get paymentTermId => throw _privateConstructorUsedError;
  String get code => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  @JsonKey(name: 'requires_lc')
  bool get requiresLc => throw _privateConstructorUsedError;
  @JsonKey(name: 'requires_advance')
  bool get requiresAdvance => throw _privateConstructorUsedError;
  @JsonKey(name: 'advance_percent')
  double? get advancePercent => throw _privateConstructorUsedError;
  @JsonKey(name: 'credit_days')
  int? get creditDays => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_active')
  bool get isActive => throw _privateConstructorUsedError;
  @JsonKey(name: 'display_order')
  int? get displayOrder => throw _privateConstructorUsedError;

  /// Serializes this LCPaymentTerm to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of LCPaymentTerm
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $LCPaymentTermCopyWith<LCPaymentTerm> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LCPaymentTermCopyWith<$Res> {
  factory $LCPaymentTermCopyWith(
          LCPaymentTerm value, $Res Function(LCPaymentTerm) then) =
      _$LCPaymentTermCopyWithImpl<$Res, LCPaymentTerm>;
  @useResult
  $Res call(
      {@JsonKey(name: 'payment_term_id') String paymentTermId,
      String code,
      String name,
      String? description,
      @JsonKey(name: 'requires_lc') bool requiresLc,
      @JsonKey(name: 'requires_advance') bool requiresAdvance,
      @JsonKey(name: 'advance_percent') double? advancePercent,
      @JsonKey(name: 'credit_days') int? creditDays,
      @JsonKey(name: 'is_active') bool isActive,
      @JsonKey(name: 'display_order') int? displayOrder});
}

/// @nodoc
class _$LCPaymentTermCopyWithImpl<$Res, $Val extends LCPaymentTerm>
    implements $LCPaymentTermCopyWith<$Res> {
  _$LCPaymentTermCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of LCPaymentTerm
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? paymentTermId = null,
    Object? code = null,
    Object? name = null,
    Object? description = freezed,
    Object? requiresLc = null,
    Object? requiresAdvance = null,
    Object? advancePercent = freezed,
    Object? creditDays = freezed,
    Object? isActive = null,
    Object? displayOrder = freezed,
  }) {
    return _then(_value.copyWith(
      paymentTermId: null == paymentTermId
          ? _value.paymentTermId
          : paymentTermId // ignore: cast_nullable_to_non_nullable
              as String,
      code: null == code
          ? _value.code
          : code // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      requiresLc: null == requiresLc
          ? _value.requiresLc
          : requiresLc // ignore: cast_nullable_to_non_nullable
              as bool,
      requiresAdvance: null == requiresAdvance
          ? _value.requiresAdvance
          : requiresAdvance // ignore: cast_nullable_to_non_nullable
              as bool,
      advancePercent: freezed == advancePercent
          ? _value.advancePercent
          : advancePercent // ignore: cast_nullable_to_non_nullable
              as double?,
      creditDays: freezed == creditDays
          ? _value.creditDays
          : creditDays // ignore: cast_nullable_to_non_nullable
              as int?,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
      displayOrder: freezed == displayOrder
          ? _value.displayOrder
          : displayOrder // ignore: cast_nullable_to_non_nullable
              as int?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$LCPaymentTermImplCopyWith<$Res>
    implements $LCPaymentTermCopyWith<$Res> {
  factory _$$LCPaymentTermImplCopyWith(
          _$LCPaymentTermImpl value, $Res Function(_$LCPaymentTermImpl) then) =
      __$$LCPaymentTermImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'payment_term_id') String paymentTermId,
      String code,
      String name,
      String? description,
      @JsonKey(name: 'requires_lc') bool requiresLc,
      @JsonKey(name: 'requires_advance') bool requiresAdvance,
      @JsonKey(name: 'advance_percent') double? advancePercent,
      @JsonKey(name: 'credit_days') int? creditDays,
      @JsonKey(name: 'is_active') bool isActive,
      @JsonKey(name: 'display_order') int? displayOrder});
}

/// @nodoc
class __$$LCPaymentTermImplCopyWithImpl<$Res>
    extends _$LCPaymentTermCopyWithImpl<$Res, _$LCPaymentTermImpl>
    implements _$$LCPaymentTermImplCopyWith<$Res> {
  __$$LCPaymentTermImplCopyWithImpl(
      _$LCPaymentTermImpl _value, $Res Function(_$LCPaymentTermImpl) _then)
      : super(_value, _then);

  /// Create a copy of LCPaymentTerm
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? paymentTermId = null,
    Object? code = null,
    Object? name = null,
    Object? description = freezed,
    Object? requiresLc = null,
    Object? requiresAdvance = null,
    Object? advancePercent = freezed,
    Object? creditDays = freezed,
    Object? isActive = null,
    Object? displayOrder = freezed,
  }) {
    return _then(_$LCPaymentTermImpl(
      paymentTermId: null == paymentTermId
          ? _value.paymentTermId
          : paymentTermId // ignore: cast_nullable_to_non_nullable
              as String,
      code: null == code
          ? _value.code
          : code // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      requiresLc: null == requiresLc
          ? _value.requiresLc
          : requiresLc // ignore: cast_nullable_to_non_nullable
              as bool,
      requiresAdvance: null == requiresAdvance
          ? _value.requiresAdvance
          : requiresAdvance // ignore: cast_nullable_to_non_nullable
              as bool,
      advancePercent: freezed == advancePercent
          ? _value.advancePercent
          : advancePercent // ignore: cast_nullable_to_non_nullable
              as double?,
      creditDays: freezed == creditDays
          ? _value.creditDays
          : creditDays // ignore: cast_nullable_to_non_nullable
              as int?,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
      displayOrder: freezed == displayOrder
          ? _value.displayOrder
          : displayOrder // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$LCPaymentTermImpl implements _LCPaymentTerm {
  const _$LCPaymentTermImpl(
      {@JsonKey(name: 'payment_term_id') required this.paymentTermId,
      required this.code,
      required this.name,
      this.description,
      @JsonKey(name: 'requires_lc') this.requiresLc = false,
      @JsonKey(name: 'requires_advance') this.requiresAdvance = false,
      @JsonKey(name: 'advance_percent') this.advancePercent,
      @JsonKey(name: 'credit_days') this.creditDays,
      @JsonKey(name: 'is_active') this.isActive = true,
      @JsonKey(name: 'display_order') this.displayOrder});

  factory _$LCPaymentTermImpl.fromJson(Map<String, dynamic> json) =>
      _$$LCPaymentTermImplFromJson(json);

  @override
  @JsonKey(name: 'payment_term_id')
  final String paymentTermId;
  @override
  final String code;
  @override
  final String name;
  @override
  final String? description;
  @override
  @JsonKey(name: 'requires_lc')
  final bool requiresLc;
  @override
  @JsonKey(name: 'requires_advance')
  final bool requiresAdvance;
  @override
  @JsonKey(name: 'advance_percent')
  final double? advancePercent;
  @override
  @JsonKey(name: 'credit_days')
  final int? creditDays;
  @override
  @JsonKey(name: 'is_active')
  final bool isActive;
  @override
  @JsonKey(name: 'display_order')
  final int? displayOrder;

  @override
  String toString() {
    return 'LCPaymentTerm(paymentTermId: $paymentTermId, code: $code, name: $name, description: $description, requiresLc: $requiresLc, requiresAdvance: $requiresAdvance, advancePercent: $advancePercent, creditDays: $creditDays, isActive: $isActive, displayOrder: $displayOrder)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LCPaymentTermImpl &&
            (identical(other.paymentTermId, paymentTermId) ||
                other.paymentTermId == paymentTermId) &&
            (identical(other.code, code) || other.code == code) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.requiresLc, requiresLc) ||
                other.requiresLc == requiresLc) &&
            (identical(other.requiresAdvance, requiresAdvance) ||
                other.requiresAdvance == requiresAdvance) &&
            (identical(other.advancePercent, advancePercent) ||
                other.advancePercent == advancePercent) &&
            (identical(other.creditDays, creditDays) ||
                other.creditDays == creditDays) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive) &&
            (identical(other.displayOrder, displayOrder) ||
                other.displayOrder == displayOrder));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      paymentTermId,
      code,
      name,
      description,
      requiresLc,
      requiresAdvance,
      advancePercent,
      creditDays,
      isActive,
      displayOrder);

  /// Create a copy of LCPaymentTerm
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$LCPaymentTermImplCopyWith<_$LCPaymentTermImpl> get copyWith =>
      __$$LCPaymentTermImplCopyWithImpl<_$LCPaymentTermImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$LCPaymentTermImplToJson(
      this,
    );
  }
}

abstract class _LCPaymentTerm implements LCPaymentTerm {
  const factory _LCPaymentTerm(
      {@JsonKey(name: 'payment_term_id') required final String paymentTermId,
      required final String code,
      required final String name,
      final String? description,
      @JsonKey(name: 'requires_lc') final bool requiresLc,
      @JsonKey(name: 'requires_advance') final bool requiresAdvance,
      @JsonKey(name: 'advance_percent') final double? advancePercent,
      @JsonKey(name: 'credit_days') final int? creditDays,
      @JsonKey(name: 'is_active') final bool isActive,
      @JsonKey(name: 'display_order')
      final int? displayOrder}) = _$LCPaymentTermImpl;

  factory _LCPaymentTerm.fromJson(Map<String, dynamic> json) =
      _$LCPaymentTermImpl.fromJson;

  @override
  @JsonKey(name: 'payment_term_id')
  String get paymentTermId;
  @override
  String get code;
  @override
  String get name;
  @override
  String? get description;
  @override
  @JsonKey(name: 'requires_lc')
  bool get requiresLc;
  @override
  @JsonKey(name: 'requires_advance')
  bool get requiresAdvance;
  @override
  @JsonKey(name: 'advance_percent')
  double? get advancePercent;
  @override
  @JsonKey(name: 'credit_days')
  int? get creditDays;
  @override
  @JsonKey(name: 'is_active')
  bool get isActive;
  @override
  @JsonKey(name: 'display_order')
  int? get displayOrder;

  /// Create a copy of LCPaymentTerm
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$LCPaymentTermImplCopyWith<_$LCPaymentTermImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
