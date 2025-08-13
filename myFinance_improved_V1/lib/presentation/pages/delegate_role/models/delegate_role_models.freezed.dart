// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'delegate_role_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

RoleDelegation _$RoleDelegationFromJson(Map<String, dynamic> json) {
  return _RoleDelegation.fromJson(json);
}

/// @nodoc
mixin _$RoleDelegation {
  String get id => throw _privateConstructorUsedError;
  String get delegatorId => throw _privateConstructorUsedError;
  String get delegateId => throw _privateConstructorUsedError;
  String get companyId => throw _privateConstructorUsedError;
  String get roleId => throw _privateConstructorUsedError;
  String get roleName => throw _privateConstructorUsedError;
  Map<String, dynamic> get delegateUser => throw _privateConstructorUsedError;
  List<String> get permissions => throw _privateConstructorUsedError;
  DateTime get startDate => throw _privateConstructorUsedError;
  DateTime get endDate => throw _privateConstructorUsedError;
  bool get isActive => throw _privateConstructorUsedError;
  DateTime? get createdAt => throw _privateConstructorUsedError;
  DateTime? get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this RoleDelegation to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of RoleDelegation
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $RoleDelegationCopyWith<RoleDelegation> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RoleDelegationCopyWith<$Res> {
  factory $RoleDelegationCopyWith(
          RoleDelegation value, $Res Function(RoleDelegation) then) =
      _$RoleDelegationCopyWithImpl<$Res, RoleDelegation>;
  @useResult
  $Res call(
      {String id,
      String delegatorId,
      String delegateId,
      String companyId,
      String roleId,
      String roleName,
      Map<String, dynamic> delegateUser,
      List<String> permissions,
      DateTime startDate,
      DateTime endDate,
      bool isActive,
      DateTime? createdAt,
      DateTime? updatedAt});
}

/// @nodoc
class _$RoleDelegationCopyWithImpl<$Res, $Val extends RoleDelegation>
    implements $RoleDelegationCopyWith<$Res> {
  _$RoleDelegationCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of RoleDelegation
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? delegatorId = null,
    Object? delegateId = null,
    Object? companyId = null,
    Object? roleId = null,
    Object? roleName = null,
    Object? delegateUser = null,
    Object? permissions = null,
    Object? startDate = null,
    Object? endDate = null,
    Object? isActive = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      delegatorId: null == delegatorId
          ? _value.delegatorId
          : delegatorId // ignore: cast_nullable_to_non_nullable
              as String,
      delegateId: null == delegateId
          ? _value.delegateId
          : delegateId // ignore: cast_nullable_to_non_nullable
              as String,
      companyId: null == companyId
          ? _value.companyId
          : companyId // ignore: cast_nullable_to_non_nullable
              as String,
      roleId: null == roleId
          ? _value.roleId
          : roleId // ignore: cast_nullable_to_non_nullable
              as String,
      roleName: null == roleName
          ? _value.roleName
          : roleName // ignore: cast_nullable_to_non_nullable
              as String,
      delegateUser: null == delegateUser
          ? _value.delegateUser
          : delegateUser // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
      permissions: null == permissions
          ? _value.permissions
          : permissions // ignore: cast_nullable_to_non_nullable
              as List<String>,
      startDate: null == startDate
          ? _value.startDate
          : startDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      endDate: null == endDate
          ? _value.endDate
          : endDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
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
abstract class _$$RoleDelegationImplCopyWith<$Res>
    implements $RoleDelegationCopyWith<$Res> {
  factory _$$RoleDelegationImplCopyWith(_$RoleDelegationImpl value,
          $Res Function(_$RoleDelegationImpl) then) =
      __$$RoleDelegationImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String delegatorId,
      String delegateId,
      String companyId,
      String roleId,
      String roleName,
      Map<String, dynamic> delegateUser,
      List<String> permissions,
      DateTime startDate,
      DateTime endDate,
      bool isActive,
      DateTime? createdAt,
      DateTime? updatedAt});
}

/// @nodoc
class __$$RoleDelegationImplCopyWithImpl<$Res>
    extends _$RoleDelegationCopyWithImpl<$Res, _$RoleDelegationImpl>
    implements _$$RoleDelegationImplCopyWith<$Res> {
  __$$RoleDelegationImplCopyWithImpl(
      _$RoleDelegationImpl _value, $Res Function(_$RoleDelegationImpl) _then)
      : super(_value, _then);

  /// Create a copy of RoleDelegation
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? delegatorId = null,
    Object? delegateId = null,
    Object? companyId = null,
    Object? roleId = null,
    Object? roleName = null,
    Object? delegateUser = null,
    Object? permissions = null,
    Object? startDate = null,
    Object? endDate = null,
    Object? isActive = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_$RoleDelegationImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      delegatorId: null == delegatorId
          ? _value.delegatorId
          : delegatorId // ignore: cast_nullable_to_non_nullable
              as String,
      delegateId: null == delegateId
          ? _value.delegateId
          : delegateId // ignore: cast_nullable_to_non_nullable
              as String,
      companyId: null == companyId
          ? _value.companyId
          : companyId // ignore: cast_nullable_to_non_nullable
              as String,
      roleId: null == roleId
          ? _value.roleId
          : roleId // ignore: cast_nullable_to_non_nullable
              as String,
      roleName: null == roleName
          ? _value.roleName
          : roleName // ignore: cast_nullable_to_non_nullable
              as String,
      delegateUser: null == delegateUser
          ? _value._delegateUser
          : delegateUser // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
      permissions: null == permissions
          ? _value._permissions
          : permissions // ignore: cast_nullable_to_non_nullable
              as List<String>,
      startDate: null == startDate
          ? _value.startDate
          : startDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      endDate: null == endDate
          ? _value.endDate
          : endDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
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
class _$RoleDelegationImpl implements _RoleDelegation {
  const _$RoleDelegationImpl(
      {required this.id,
      required this.delegatorId,
      required this.delegateId,
      required this.companyId,
      required this.roleId,
      required this.roleName,
      required final Map<String, dynamic> delegateUser,
      required final List<String> permissions,
      required this.startDate,
      required this.endDate,
      required this.isActive,
      this.createdAt,
      this.updatedAt})
      : _delegateUser = delegateUser,
        _permissions = permissions;

  factory _$RoleDelegationImpl.fromJson(Map<String, dynamic> json) =>
      _$$RoleDelegationImplFromJson(json);

  @override
  final String id;
  @override
  final String delegatorId;
  @override
  final String delegateId;
  @override
  final String companyId;
  @override
  final String roleId;
  @override
  final String roleName;
  final Map<String, dynamic> _delegateUser;
  @override
  Map<String, dynamic> get delegateUser {
    if (_delegateUser is EqualUnmodifiableMapView) return _delegateUser;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_delegateUser);
  }

  final List<String> _permissions;
  @override
  List<String> get permissions {
    if (_permissions is EqualUnmodifiableListView) return _permissions;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_permissions);
  }

  @override
  final DateTime startDate;
  @override
  final DateTime endDate;
  @override
  final bool isActive;
  @override
  final DateTime? createdAt;
  @override
  final DateTime? updatedAt;

  @override
  String toString() {
    return 'RoleDelegation(id: $id, delegatorId: $delegatorId, delegateId: $delegateId, companyId: $companyId, roleId: $roleId, roleName: $roleName, delegateUser: $delegateUser, permissions: $permissions, startDate: $startDate, endDate: $endDate, isActive: $isActive, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RoleDelegationImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.delegatorId, delegatorId) ||
                other.delegatorId == delegatorId) &&
            (identical(other.delegateId, delegateId) ||
                other.delegateId == delegateId) &&
            (identical(other.companyId, companyId) ||
                other.companyId == companyId) &&
            (identical(other.roleId, roleId) || other.roleId == roleId) &&
            (identical(other.roleName, roleName) ||
                other.roleName == roleName) &&
            const DeepCollectionEquality()
                .equals(other._delegateUser, _delegateUser) &&
            const DeepCollectionEquality()
                .equals(other._permissions, _permissions) &&
            (identical(other.startDate, startDate) ||
                other.startDate == startDate) &&
            (identical(other.endDate, endDate) || other.endDate == endDate) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      delegatorId,
      delegateId,
      companyId,
      roleId,
      roleName,
      const DeepCollectionEquality().hash(_delegateUser),
      const DeepCollectionEquality().hash(_permissions),
      startDate,
      endDate,
      isActive,
      createdAt,
      updatedAt);

  /// Create a copy of RoleDelegation
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$RoleDelegationImplCopyWith<_$RoleDelegationImpl> get copyWith =>
      __$$RoleDelegationImplCopyWithImpl<_$RoleDelegationImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$RoleDelegationImplToJson(
      this,
    );
  }
}

abstract class _RoleDelegation implements RoleDelegation {
  const factory _RoleDelegation(
      {required final String id,
      required final String delegatorId,
      required final String delegateId,
      required final String companyId,
      required final String roleId,
      required final String roleName,
      required final Map<String, dynamic> delegateUser,
      required final List<String> permissions,
      required final DateTime startDate,
      required final DateTime endDate,
      required final bool isActive,
      final DateTime? createdAt,
      final DateTime? updatedAt}) = _$RoleDelegationImpl;

  factory _RoleDelegation.fromJson(Map<String, dynamic> json) =
      _$RoleDelegationImpl.fromJson;

  @override
  String get id;
  @override
  String get delegatorId;
  @override
  String get delegateId;
  @override
  String get companyId;
  @override
  String get roleId;
  @override
  String get roleName;
  @override
  Map<String, dynamic> get delegateUser;
  @override
  List<String> get permissions;
  @override
  DateTime get startDate;
  @override
  DateTime get endDate;
  @override
  bool get isActive;
  @override
  DateTime? get createdAt;
  @override
  DateTime? get updatedAt;

  /// Create a copy of RoleDelegation
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$RoleDelegationImplCopyWith<_$RoleDelegationImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

DelegationAudit _$DelegationAuditFromJson(Map<String, dynamic> json) {
  return _DelegationAudit.fromJson(json);
}

/// @nodoc
mixin _$DelegationAudit {
  String get id => throw _privateConstructorUsedError;
  String get delegationId => throw _privateConstructorUsedError;
  String get action =>
      throw _privateConstructorUsedError; // granted, revoked, modified
  String get performedBy => throw _privateConstructorUsedError;
  Map<String, dynamic> get performedByUser =>
      throw _privateConstructorUsedError;
  Map<String, dynamic> get details => throw _privateConstructorUsedError;
  DateTime get timestamp => throw _privateConstructorUsedError;

  /// Serializes this DelegationAudit to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of DelegationAudit
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $DelegationAuditCopyWith<DelegationAudit> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DelegationAuditCopyWith<$Res> {
  factory $DelegationAuditCopyWith(
          DelegationAudit value, $Res Function(DelegationAudit) then) =
      _$DelegationAuditCopyWithImpl<$Res, DelegationAudit>;
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
class _$DelegationAuditCopyWithImpl<$Res, $Val extends DelegationAudit>
    implements $DelegationAuditCopyWith<$Res> {
  _$DelegationAuditCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of DelegationAudit
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
abstract class _$$DelegationAuditImplCopyWith<$Res>
    implements $DelegationAuditCopyWith<$Res> {
  factory _$$DelegationAuditImplCopyWith(_$DelegationAuditImpl value,
          $Res Function(_$DelegationAuditImpl) then) =
      __$$DelegationAuditImplCopyWithImpl<$Res>;
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
class __$$DelegationAuditImplCopyWithImpl<$Res>
    extends _$DelegationAuditCopyWithImpl<$Res, _$DelegationAuditImpl>
    implements _$$DelegationAuditImplCopyWith<$Res> {
  __$$DelegationAuditImplCopyWithImpl(
      _$DelegationAuditImpl _value, $Res Function(_$DelegationAuditImpl) _then)
      : super(_value, _then);

  /// Create a copy of DelegationAudit
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
    return _then(_$DelegationAuditImpl(
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
class _$DelegationAuditImpl implements _DelegationAudit {
  const _$DelegationAuditImpl(
      {required this.id,
      required this.delegationId,
      required this.action,
      required this.performedBy,
      required final Map<String, dynamic> performedByUser,
      required final Map<String, dynamic> details,
      required this.timestamp})
      : _performedByUser = performedByUser,
        _details = details;

  factory _$DelegationAuditImpl.fromJson(Map<String, dynamic> json) =>
      _$$DelegationAuditImplFromJson(json);

  @override
  final String id;
  @override
  final String delegationId;
  @override
  final String action;
// granted, revoked, modified
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
    return 'DelegationAudit(id: $id, delegationId: $delegationId, action: $action, performedBy: $performedBy, performedByUser: $performedByUser, details: $details, timestamp: $timestamp)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DelegationAuditImpl &&
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

  /// Create a copy of DelegationAudit
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DelegationAuditImplCopyWith<_$DelegationAuditImpl> get copyWith =>
      __$$DelegationAuditImplCopyWithImpl<_$DelegationAuditImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$DelegationAuditImplToJson(
      this,
    );
  }
}

abstract class _DelegationAudit implements DelegationAudit {
  const factory _DelegationAudit(
      {required final String id,
      required final String delegationId,
      required final String action,
      required final String performedBy,
      required final Map<String, dynamic> performedByUser,
      required final Map<String, dynamic> details,
      required final DateTime timestamp}) = _$DelegationAuditImpl;

  factory _DelegationAudit.fromJson(Map<String, dynamic> json) =
      _$DelegationAuditImpl.fromJson;

  @override
  String get id;
  @override
  String get delegationId;
  @override
  String get action; // granted, revoked, modified
  @override
  String get performedBy;
  @override
  Map<String, dynamic> get performedByUser;
  @override
  Map<String, dynamic> get details;
  @override
  DateTime get timestamp;

  /// Create a copy of DelegationAudit
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DelegationAuditImplCopyWith<_$DelegationAuditImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

DelegatableRole _$DelegatableRoleFromJson(Map<String, dynamic> json) {
  return _DelegatableRole.fromJson(json);
}

/// @nodoc
mixin _$DelegatableRole {
  String get roleId => throw _privateConstructorUsedError;
  String get roleName => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  List<String> get permissions => throw _privateConstructorUsedError;
  bool get canDelegate => throw _privateConstructorUsedError;

  /// Serializes this DelegatableRole to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of DelegatableRole
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $DelegatableRoleCopyWith<DelegatableRole> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DelegatableRoleCopyWith<$Res> {
  factory $DelegatableRoleCopyWith(
          DelegatableRole value, $Res Function(DelegatableRole) then) =
      _$DelegatableRoleCopyWithImpl<$Res, DelegatableRole>;
  @useResult
  $Res call(
      {String roleId,
      String roleName,
      String description,
      List<String> permissions,
      bool canDelegate});
}

/// @nodoc
class _$DelegatableRoleCopyWithImpl<$Res, $Val extends DelegatableRole>
    implements $DelegatableRoleCopyWith<$Res> {
  _$DelegatableRoleCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of DelegatableRole
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? roleId = null,
    Object? roleName = null,
    Object? description = null,
    Object? permissions = null,
    Object? canDelegate = null,
  }) {
    return _then(_value.copyWith(
      roleId: null == roleId
          ? _value.roleId
          : roleId // ignore: cast_nullable_to_non_nullable
              as String,
      roleName: null == roleName
          ? _value.roleName
          : roleName // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      permissions: null == permissions
          ? _value.permissions
          : permissions // ignore: cast_nullable_to_non_nullable
              as List<String>,
      canDelegate: null == canDelegate
          ? _value.canDelegate
          : canDelegate // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$DelegatableRoleImplCopyWith<$Res>
    implements $DelegatableRoleCopyWith<$Res> {
  factory _$$DelegatableRoleImplCopyWith(_$DelegatableRoleImpl value,
          $Res Function(_$DelegatableRoleImpl) then) =
      __$$DelegatableRoleImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String roleId,
      String roleName,
      String description,
      List<String> permissions,
      bool canDelegate});
}

/// @nodoc
class __$$DelegatableRoleImplCopyWithImpl<$Res>
    extends _$DelegatableRoleCopyWithImpl<$Res, _$DelegatableRoleImpl>
    implements _$$DelegatableRoleImplCopyWith<$Res> {
  __$$DelegatableRoleImplCopyWithImpl(
      _$DelegatableRoleImpl _value, $Res Function(_$DelegatableRoleImpl) _then)
      : super(_value, _then);

  /// Create a copy of DelegatableRole
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? roleId = null,
    Object? roleName = null,
    Object? description = null,
    Object? permissions = null,
    Object? canDelegate = null,
  }) {
    return _then(_$DelegatableRoleImpl(
      roleId: null == roleId
          ? _value.roleId
          : roleId // ignore: cast_nullable_to_non_nullable
              as String,
      roleName: null == roleName
          ? _value.roleName
          : roleName // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      permissions: null == permissions
          ? _value._permissions
          : permissions // ignore: cast_nullable_to_non_nullable
              as List<String>,
      canDelegate: null == canDelegate
          ? _value.canDelegate
          : canDelegate // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$DelegatableRoleImpl implements _DelegatableRole {
  const _$DelegatableRoleImpl(
      {required this.roleId,
      required this.roleName,
      required this.description,
      required final List<String> permissions,
      required this.canDelegate})
      : _permissions = permissions;

  factory _$DelegatableRoleImpl.fromJson(Map<String, dynamic> json) =>
      _$$DelegatableRoleImplFromJson(json);

  @override
  final String roleId;
  @override
  final String roleName;
  @override
  final String description;
  final List<String> _permissions;
  @override
  List<String> get permissions {
    if (_permissions is EqualUnmodifiableListView) return _permissions;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_permissions);
  }

  @override
  final bool canDelegate;

  @override
  String toString() {
    return 'DelegatableRole(roleId: $roleId, roleName: $roleName, description: $description, permissions: $permissions, canDelegate: $canDelegate)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DelegatableRoleImpl &&
            (identical(other.roleId, roleId) || other.roleId == roleId) &&
            (identical(other.roleName, roleName) ||
                other.roleName == roleName) &&
            (identical(other.description, description) ||
                other.description == description) &&
            const DeepCollectionEquality()
                .equals(other._permissions, _permissions) &&
            (identical(other.canDelegate, canDelegate) ||
                other.canDelegate == canDelegate));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, roleId, roleName, description,
      const DeepCollectionEquality().hash(_permissions), canDelegate);

  /// Create a copy of DelegatableRole
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DelegatableRoleImplCopyWith<_$DelegatableRoleImpl> get copyWith =>
      __$$DelegatableRoleImplCopyWithImpl<_$DelegatableRoleImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$DelegatableRoleImplToJson(
      this,
    );
  }
}

abstract class _DelegatableRole implements DelegatableRole {
  const factory _DelegatableRole(
      {required final String roleId,
      required final String roleName,
      required final String description,
      required final List<String> permissions,
      required final bool canDelegate}) = _$DelegatableRoleImpl;

  factory _DelegatableRole.fromJson(Map<String, dynamic> json) =
      _$DelegatableRoleImpl.fromJson;

  @override
  String get roleId;
  @override
  String get roleName;
  @override
  String get description;
  @override
  List<String> get permissions;
  @override
  bool get canDelegate;

  /// Create a copy of DelegatableRole
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DelegatableRoleImplCopyWith<_$DelegatableRoleImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

CreateDelegationRequest _$CreateDelegationRequestFromJson(
    Map<String, dynamic> json) {
  return _CreateDelegationRequest.fromJson(json);
}

/// @nodoc
mixin _$CreateDelegationRequest {
  String get delegateId => throw _privateConstructorUsedError;
  String get roleId => throw _privateConstructorUsedError;
  List<String> get permissions => throw _privateConstructorUsedError;
  DateTime get startDate => throw _privateConstructorUsedError;
  DateTime get endDate => throw _privateConstructorUsedError;

  /// Serializes this CreateDelegationRequest to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CreateDelegationRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CreateDelegationRequestCopyWith<CreateDelegationRequest> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CreateDelegationRequestCopyWith<$Res> {
  factory $CreateDelegationRequestCopyWith(CreateDelegationRequest value,
          $Res Function(CreateDelegationRequest) then) =
      _$CreateDelegationRequestCopyWithImpl<$Res, CreateDelegationRequest>;
  @useResult
  $Res call(
      {String delegateId,
      String roleId,
      List<String> permissions,
      DateTime startDate,
      DateTime endDate});
}

/// @nodoc
class _$CreateDelegationRequestCopyWithImpl<$Res,
        $Val extends CreateDelegationRequest>
    implements $CreateDelegationRequestCopyWith<$Res> {
  _$CreateDelegationRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CreateDelegationRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? delegateId = null,
    Object? roleId = null,
    Object? permissions = null,
    Object? startDate = null,
    Object? endDate = null,
  }) {
    return _then(_value.copyWith(
      delegateId: null == delegateId
          ? _value.delegateId
          : delegateId // ignore: cast_nullable_to_non_nullable
              as String,
      roleId: null == roleId
          ? _value.roleId
          : roleId // ignore: cast_nullable_to_non_nullable
              as String,
      permissions: null == permissions
          ? _value.permissions
          : permissions // ignore: cast_nullable_to_non_nullable
              as List<String>,
      startDate: null == startDate
          ? _value.startDate
          : startDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      endDate: null == endDate
          ? _value.endDate
          : endDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CreateDelegationRequestImplCopyWith<$Res>
    implements $CreateDelegationRequestCopyWith<$Res> {
  factory _$$CreateDelegationRequestImplCopyWith(
          _$CreateDelegationRequestImpl value,
          $Res Function(_$CreateDelegationRequestImpl) then) =
      __$$CreateDelegationRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String delegateId,
      String roleId,
      List<String> permissions,
      DateTime startDate,
      DateTime endDate});
}

/// @nodoc
class __$$CreateDelegationRequestImplCopyWithImpl<$Res>
    extends _$CreateDelegationRequestCopyWithImpl<$Res,
        _$CreateDelegationRequestImpl>
    implements _$$CreateDelegationRequestImplCopyWith<$Res> {
  __$$CreateDelegationRequestImplCopyWithImpl(
      _$CreateDelegationRequestImpl _value,
      $Res Function(_$CreateDelegationRequestImpl) _then)
      : super(_value, _then);

  /// Create a copy of CreateDelegationRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? delegateId = null,
    Object? roleId = null,
    Object? permissions = null,
    Object? startDate = null,
    Object? endDate = null,
  }) {
    return _then(_$CreateDelegationRequestImpl(
      delegateId: null == delegateId
          ? _value.delegateId
          : delegateId // ignore: cast_nullable_to_non_nullable
              as String,
      roleId: null == roleId
          ? _value.roleId
          : roleId // ignore: cast_nullable_to_non_nullable
              as String,
      permissions: null == permissions
          ? _value._permissions
          : permissions // ignore: cast_nullable_to_non_nullable
              as List<String>,
      startDate: null == startDate
          ? _value.startDate
          : startDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      endDate: null == endDate
          ? _value.endDate
          : endDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CreateDelegationRequestImpl implements _CreateDelegationRequest {
  const _$CreateDelegationRequestImpl(
      {required this.delegateId,
      required this.roleId,
      required final List<String> permissions,
      required this.startDate,
      required this.endDate})
      : _permissions = permissions;

  factory _$CreateDelegationRequestImpl.fromJson(Map<String, dynamic> json) =>
      _$$CreateDelegationRequestImplFromJson(json);

  @override
  final String delegateId;
  @override
  final String roleId;
  final List<String> _permissions;
  @override
  List<String> get permissions {
    if (_permissions is EqualUnmodifiableListView) return _permissions;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_permissions);
  }

  @override
  final DateTime startDate;
  @override
  final DateTime endDate;

  @override
  String toString() {
    return 'CreateDelegationRequest(delegateId: $delegateId, roleId: $roleId, permissions: $permissions, startDate: $startDate, endDate: $endDate)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CreateDelegationRequestImpl &&
            (identical(other.delegateId, delegateId) ||
                other.delegateId == delegateId) &&
            (identical(other.roleId, roleId) || other.roleId == roleId) &&
            const DeepCollectionEquality()
                .equals(other._permissions, _permissions) &&
            (identical(other.startDate, startDate) ||
                other.startDate == startDate) &&
            (identical(other.endDate, endDate) || other.endDate == endDate));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, delegateId, roleId,
      const DeepCollectionEquality().hash(_permissions), startDate, endDate);

  /// Create a copy of CreateDelegationRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CreateDelegationRequestImplCopyWith<_$CreateDelegationRequestImpl>
      get copyWith => __$$CreateDelegationRequestImplCopyWithImpl<
          _$CreateDelegationRequestImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CreateDelegationRequestImplToJson(
      this,
    );
  }
}

abstract class _CreateDelegationRequest implements CreateDelegationRequest {
  const factory _CreateDelegationRequest(
      {required final String delegateId,
      required final String roleId,
      required final List<String> permissions,
      required final DateTime startDate,
      required final DateTime endDate}) = _$CreateDelegationRequestImpl;

  factory _CreateDelegationRequest.fromJson(Map<String, dynamic> json) =
      _$CreateDelegationRequestImpl.fromJson;

  @override
  String get delegateId;
  @override
  String get roleId;
  @override
  List<String> get permissions;
  @override
  DateTime get startDate;
  @override
  DateTime get endDate;

  /// Create a copy of CreateDelegationRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CreateDelegationRequestImplCopyWith<_$CreateDelegationRequestImpl>
      get copyWith => throw _privateConstructorUsedError;
}
