// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'subscription_limit_check.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$SubscriptionLimitCheck {
  /// Whether the user can add more resources
  bool get canAdd => throw _privateConstructorUsedError;

  /// The user's current plan name ('free', 'basic', 'pro')
  String get planName => throw _privateConstructorUsedError;

  /// Maximum allowed count (null = unlimited for Pro plan)
  int? get maxLimit => throw _privateConstructorUsedError;

  /// Current count of the resource
  int get currentCount => throw _privateConstructorUsedError;

  /// Type of resource being checked ('company', 'store', 'employee')
  String get checkType => throw _privateConstructorUsedError;

  /// Create a copy of SubscriptionLimitCheck
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SubscriptionLimitCheckCopyWith<SubscriptionLimitCheck> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SubscriptionLimitCheckCopyWith<$Res> {
  factory $SubscriptionLimitCheckCopyWith(SubscriptionLimitCheck value,
          $Res Function(SubscriptionLimitCheck) then) =
      _$SubscriptionLimitCheckCopyWithImpl<$Res, SubscriptionLimitCheck>;
  @useResult
  $Res call(
      {bool canAdd,
      String planName,
      int? maxLimit,
      int currentCount,
      String checkType});
}

/// @nodoc
class _$SubscriptionLimitCheckCopyWithImpl<$Res,
        $Val extends SubscriptionLimitCheck>
    implements $SubscriptionLimitCheckCopyWith<$Res> {
  _$SubscriptionLimitCheckCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SubscriptionLimitCheck
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? canAdd = null,
    Object? planName = null,
    Object? maxLimit = freezed,
    Object? currentCount = null,
    Object? checkType = null,
  }) {
    return _then(_value.copyWith(
      canAdd: null == canAdd
          ? _value.canAdd
          : canAdd // ignore: cast_nullable_to_non_nullable
              as bool,
      planName: null == planName
          ? _value.planName
          : planName // ignore: cast_nullable_to_non_nullable
              as String,
      maxLimit: freezed == maxLimit
          ? _value.maxLimit
          : maxLimit // ignore: cast_nullable_to_non_nullable
              as int?,
      currentCount: null == currentCount
          ? _value.currentCount
          : currentCount // ignore: cast_nullable_to_non_nullable
              as int,
      checkType: null == checkType
          ? _value.checkType
          : checkType // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SubscriptionLimitCheckImplCopyWith<$Res>
    implements $SubscriptionLimitCheckCopyWith<$Res> {
  factory _$$SubscriptionLimitCheckImplCopyWith(
          _$SubscriptionLimitCheckImpl value,
          $Res Function(_$SubscriptionLimitCheckImpl) then) =
      __$$SubscriptionLimitCheckImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {bool canAdd,
      String planName,
      int? maxLimit,
      int currentCount,
      String checkType});
}

/// @nodoc
class __$$SubscriptionLimitCheckImplCopyWithImpl<$Res>
    extends _$SubscriptionLimitCheckCopyWithImpl<$Res,
        _$SubscriptionLimitCheckImpl>
    implements _$$SubscriptionLimitCheckImplCopyWith<$Res> {
  __$$SubscriptionLimitCheckImplCopyWithImpl(
      _$SubscriptionLimitCheckImpl _value,
      $Res Function(_$SubscriptionLimitCheckImpl) _then)
      : super(_value, _then);

  /// Create a copy of SubscriptionLimitCheck
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? canAdd = null,
    Object? planName = null,
    Object? maxLimit = freezed,
    Object? currentCount = null,
    Object? checkType = null,
  }) {
    return _then(_$SubscriptionLimitCheckImpl(
      canAdd: null == canAdd
          ? _value.canAdd
          : canAdd // ignore: cast_nullable_to_non_nullable
              as bool,
      planName: null == planName
          ? _value.planName
          : planName // ignore: cast_nullable_to_non_nullable
              as String,
      maxLimit: freezed == maxLimit
          ? _value.maxLimit
          : maxLimit // ignore: cast_nullable_to_non_nullable
              as int?,
      currentCount: null == currentCount
          ? _value.currentCount
          : currentCount // ignore: cast_nullable_to_non_nullable
              as int,
      checkType: null == checkType
          ? _value.checkType
          : checkType // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$SubscriptionLimitCheckImpl extends _SubscriptionLimitCheck {
  const _$SubscriptionLimitCheckImpl(
      {required this.canAdd,
      required this.planName,
      this.maxLimit,
      required this.currentCount,
      this.checkType = ''})
      : super._();

  /// Whether the user can add more resources
  @override
  final bool canAdd;

  /// The user's current plan name ('free', 'basic', 'pro')
  @override
  final String planName;

  /// Maximum allowed count (null = unlimited for Pro plan)
  @override
  final int? maxLimit;

  /// Current count of the resource
  @override
  final int currentCount;

  /// Type of resource being checked ('company', 'store', 'employee')
  @override
  @JsonKey()
  final String checkType;

  @override
  String toString() {
    return 'SubscriptionLimitCheck(canAdd: $canAdd, planName: $planName, maxLimit: $maxLimit, currentCount: $currentCount, checkType: $checkType)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SubscriptionLimitCheckImpl &&
            (identical(other.canAdd, canAdd) || other.canAdd == canAdd) &&
            (identical(other.planName, planName) ||
                other.planName == planName) &&
            (identical(other.maxLimit, maxLimit) ||
                other.maxLimit == maxLimit) &&
            (identical(other.currentCount, currentCount) ||
                other.currentCount == currentCount) &&
            (identical(other.checkType, checkType) ||
                other.checkType == checkType));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, canAdd, planName, maxLimit, currentCount, checkType);

  /// Create a copy of SubscriptionLimitCheck
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SubscriptionLimitCheckImplCopyWith<_$SubscriptionLimitCheckImpl>
      get copyWith => __$$SubscriptionLimitCheckImplCopyWithImpl<
          _$SubscriptionLimitCheckImpl>(this, _$identity);
}

abstract class _SubscriptionLimitCheck extends SubscriptionLimitCheck {
  const factory _SubscriptionLimitCheck(
      {required final bool canAdd,
      required final String planName,
      final int? maxLimit,
      required final int currentCount,
      final String checkType}) = _$SubscriptionLimitCheckImpl;
  const _SubscriptionLimitCheck._() : super._();

  /// Whether the user can add more resources
  @override
  bool get canAdd;

  /// The user's current plan name ('free', 'basic', 'pro')
  @override
  String get planName;

  /// Maximum allowed count (null = unlimited for Pro plan)
  @override
  int? get maxLimit;

  /// Current count of the resource
  @override
  int get currentCount;

  /// Type of resource being checked ('company', 'store', 'employee')
  @override
  String get checkType;

  /// Create a copy of SubscriptionLimitCheck
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SubscriptionLimitCheckImplCopyWith<_$SubscriptionLimitCheckImpl>
      get copyWith => throw _privateConstructorUsedError;
}
