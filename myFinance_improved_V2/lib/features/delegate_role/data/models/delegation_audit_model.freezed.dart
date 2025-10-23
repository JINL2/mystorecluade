// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'delegation_audit_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

DelegationAuditModel _$DelegationAuditModelFromJson(Map<String, dynamic> json) {
  return _DelegationAuditModel.fromJson(json);
}

/// @nodoc
mixin _$DelegationAuditModel {
  String get id => throw _privateConstructorUsedError;
  String get delegationId => throw _privateConstructorUsedError;
  String get action => throw _privateConstructorUsedError;
  String get performedBy => throw _privateConstructorUsedError;
  Map<String, dynamic> get performedByUser =>
      throw _privateConstructorUsedError;
  Map<String, dynamic> get details => throw _privateConstructorUsedError;
  DateTime get timestamp => throw _privateConstructorUsedError;

  /// Serializes this DelegationAuditModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of DelegationAuditModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $DelegationAuditModelCopyWith<DelegationAuditModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DelegationAuditModelCopyWith<$Res> {
  factory $DelegationAuditModelCopyWith(DelegationAuditModel value,
          $Res Function(DelegationAuditModel) then) =
      _$DelegationAuditModelCopyWithImpl<$Res, DelegationAuditModel>;
  @useResult
  $Res call(
      {String id,
      String delegationId,
      String action,
      String performedBy,
      Map<String, dynamic> performedByUser,
      Map<String, dynamic> details,
      DateTime timestamp});
}

/// @nodoc
class _$DelegationAuditModelCopyWithImpl<$Res,
        $Val extends DelegationAuditModel>
    implements $DelegationAuditModelCopyWith<$Res> {
  _$DelegationAuditModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of DelegationAuditModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? delegationId = null,
    Object? action = null,
    Object? performedBy = null,
    Object? performedByUser = null,
    Object? details = null,
    Object? timestamp = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      delegationId: null == delegationId
          ? _value.delegationId
          : delegationId // ignore: cast_nullable_to_non_nullable
              as String,
      action: null == action
          ? _value.action
          : action // ignore: cast_nullable_to_non_nullable
              as String,
      performedBy: null == performedBy
          ? _value.performedBy
          : performedBy // ignore: cast_nullable_to_non_nullable
              as String,
      performedByUser: null == performedByUser
          ? _value.performedByUser
          : performedByUser // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
      details: null == details
          ? _value.details
          : details // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
      timestamp: null == timestamp
          ? _value.timestamp
          : timestamp // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$DelegationAuditModelImplCopyWith<$Res>
    implements $DelegationAuditModelCopyWith<$Res> {
  factory _$$DelegationAuditModelImplCopyWith(_$DelegationAuditModelImpl value,
          $Res Function(_$DelegationAuditModelImpl) then) =
      __$$DelegationAuditModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String delegationId,
      String action,
      String performedBy,
      Map<String, dynamic> performedByUser,
      Map<String, dynamic> details,
      DateTime timestamp});
}

/// @nodoc
class __$$DelegationAuditModelImplCopyWithImpl<$Res>
    extends _$DelegationAuditModelCopyWithImpl<$Res, _$DelegationAuditModelImpl>
    implements _$$DelegationAuditModelImplCopyWith<$Res> {
  __$$DelegationAuditModelImplCopyWithImpl(_$DelegationAuditModelImpl _value,
      $Res Function(_$DelegationAuditModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of DelegationAuditModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? delegationId = null,
    Object? action = null,
    Object? performedBy = null,
    Object? performedByUser = null,
    Object? details = null,
    Object? timestamp = null,
  }) {
    return _then(_$DelegationAuditModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      delegationId: null == delegationId
          ? _value.delegationId
          : delegationId // ignore: cast_nullable_to_non_nullable
              as String,
      action: null == action
          ? _value.action
          : action // ignore: cast_nullable_to_non_nullable
              as String,
      performedBy: null == performedBy
          ? _value.performedBy
          : performedBy // ignore: cast_nullable_to_non_nullable
              as String,
      performedByUser: null == performedByUser
          ? _value._performedByUser
          : performedByUser // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
      details: null == details
          ? _value._details
          : details // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
      timestamp: null == timestamp
          ? _value.timestamp
          : timestamp // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$DelegationAuditModelImpl extends _DelegationAuditModel {
  const _$DelegationAuditModelImpl(
      {required this.id,
      required this.delegationId,
      required this.action,
      required this.performedBy,
      required final Map<String, dynamic> performedByUser,
      required final Map<String, dynamic> details,
      required this.timestamp})
      : _performedByUser = performedByUser,
        _details = details,
        super._();

  factory _$DelegationAuditModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$DelegationAuditModelImplFromJson(json);

  @override
  final String id;
  @override
  final String delegationId;
  @override
  final String action;
  @override
  final String performedBy;
  final Map<String, dynamic> _performedByUser;
  @override
  Map<String, dynamic> get performedByUser {
    if (_performedByUser is EqualUnmodifiableMapView) return _performedByUser;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_performedByUser);
  }

  final Map<String, dynamic> _details;
  @override
  Map<String, dynamic> get details {
    if (_details is EqualUnmodifiableMapView) return _details;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_details);
  }

  @override
  final DateTime timestamp;

  @override
  String toString() {
    return 'DelegationAuditModel(id: $id, delegationId: $delegationId, action: $action, performedBy: $performedBy, performedByUser: $performedByUser, details: $details, timestamp: $timestamp)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DelegationAuditModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.delegationId, delegationId) ||
                other.delegationId == delegationId) &&
            (identical(other.action, action) || other.action == action) &&
            (identical(other.performedBy, performedBy) ||
                other.performedBy == performedBy) &&
            const DeepCollectionEquality()
                .equals(other._performedByUser, _performedByUser) &&
            const DeepCollectionEquality().equals(other._details, _details) &&
            (identical(other.timestamp, timestamp) ||
                other.timestamp == timestamp));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      delegationId,
      action,
      performedBy,
      const DeepCollectionEquality().hash(_performedByUser),
      const DeepCollectionEquality().hash(_details),
      timestamp);

  /// Create a copy of DelegationAuditModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DelegationAuditModelImplCopyWith<_$DelegationAuditModelImpl>
      get copyWith =>
          __$$DelegationAuditModelImplCopyWithImpl<_$DelegationAuditModelImpl>(
              this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$DelegationAuditModelImplToJson(
      this,
    );
  }
}

abstract class _DelegationAuditModel extends DelegationAuditModel {
  const factory _DelegationAuditModel(
      {required final String id,
      required final String delegationId,
      required final String action,
      required final String performedBy,
      required final Map<String, dynamic> performedByUser,
      required final Map<String, dynamic> details,
      required final DateTime timestamp}) = _$DelegationAuditModelImpl;
  const _DelegationAuditModel._() : super._();

  factory _DelegationAuditModel.fromJson(Map<String, dynamic> json) =
      _$DelegationAuditModelImpl.fromJson;

  @override
  String get id;
  @override
  String get delegationId;
  @override
  String get action;
  @override
  String get performedBy;
  @override
  Map<String, dynamic> get performedByUser;
  @override
  Map<String, dynamic> get details;
  @override
  DateTime get timestamp;

  /// Create a copy of DelegationAuditModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DelegationAuditModelImplCopyWith<_$DelegationAuditModelImpl>
      get copyWith => throw _privateConstructorUsedError;
}
