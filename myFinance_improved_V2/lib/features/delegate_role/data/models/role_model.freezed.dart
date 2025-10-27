// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'role_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$RoleModel {
  String get roleId => throw _privateConstructorUsedError;
  String get companyId => throw _privateConstructorUsedError;
  String get roleName => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  String get roleType => throw _privateConstructorUsedError;
  List<String> get tags => throw _privateConstructorUsedError;
  List<String> get permissions => throw _privateConstructorUsedError;
  int get memberCount => throw _privateConstructorUsedError;
  bool get canEdit => throw _privateConstructorUsedError;
  bool get canDelegate => throw _privateConstructorUsedError;
  DateTime? get createdAt => throw _privateConstructorUsedError;
  DateTime? get updatedAt => throw _privateConstructorUsedError;

  /// Create a copy of RoleModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $RoleModelCopyWith<RoleModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RoleModelCopyWith<$Res> {
  factory $RoleModelCopyWith(RoleModel value, $Res Function(RoleModel) then) =
      _$RoleModelCopyWithImpl<$Res, RoleModel>;
  @useResult
  $Res call(
      {String roleId,
      String companyId,
      String roleName,
      String? description,
      String roleType,
      List<String> tags,
      List<String> permissions,
      int memberCount,
      bool canEdit,
      bool canDelegate,
      DateTime? createdAt,
      DateTime? updatedAt});
}

/// @nodoc
class _$RoleModelCopyWithImpl<$Res, $Val extends RoleModel>
    implements $RoleModelCopyWith<$Res> {
  _$RoleModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of RoleModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? roleId = null,
    Object? companyId = null,
    Object? roleName = null,
    Object? description = freezed,
    Object? roleType = null,
    Object? tags = null,
    Object? permissions = null,
    Object? memberCount = null,
    Object? canEdit = null,
    Object? canDelegate = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_value.copyWith(
      roleId: null == roleId
          ? _value.roleId
          : roleId // ignore: cast_nullable_to_non_nullable
              as String,
      companyId: null == companyId
          ? _value.companyId
          : companyId // ignore: cast_nullable_to_non_nullable
              as String,
      roleName: null == roleName
          ? _value.roleName
          : roleName // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      roleType: null == roleType
          ? _value.roleType
          : roleType // ignore: cast_nullable_to_non_nullable
              as String,
      tags: null == tags
          ? _value.tags
          : tags // ignore: cast_nullable_to_non_nullable
              as List<String>,
      permissions: null == permissions
          ? _value.permissions
          : permissions // ignore: cast_nullable_to_non_nullable
              as List<String>,
      memberCount: null == memberCount
          ? _value.memberCount
          : memberCount // ignore: cast_nullable_to_non_nullable
              as int,
      canEdit: null == canEdit
          ? _value.canEdit
          : canEdit // ignore: cast_nullable_to_non_nullable
              as bool,
      canDelegate: null == canDelegate
          ? _value.canDelegate
          : canDelegate // ignore: cast_nullable_to_non_nullable
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
abstract class _$$RoleModelImplCopyWith<$Res>
    implements $RoleModelCopyWith<$Res> {
  factory _$$RoleModelImplCopyWith(
          _$RoleModelImpl value, $Res Function(_$RoleModelImpl) then) =
      __$$RoleModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String roleId,
      String companyId,
      String roleName,
      String? description,
      String roleType,
      List<String> tags,
      List<String> permissions,
      int memberCount,
      bool canEdit,
      bool canDelegate,
      DateTime? createdAt,
      DateTime? updatedAt});
}

/// @nodoc
class __$$RoleModelImplCopyWithImpl<$Res>
    extends _$RoleModelCopyWithImpl<$Res, _$RoleModelImpl>
    implements _$$RoleModelImplCopyWith<$Res> {
  __$$RoleModelImplCopyWithImpl(
      _$RoleModelImpl _value, $Res Function(_$RoleModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of RoleModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? roleId = null,
    Object? companyId = null,
    Object? roleName = null,
    Object? description = freezed,
    Object? roleType = null,
    Object? tags = null,
    Object? permissions = null,
    Object? memberCount = null,
    Object? canEdit = null,
    Object? canDelegate = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_$RoleModelImpl(
      roleId: null == roleId
          ? _value.roleId
          : roleId // ignore: cast_nullable_to_non_nullable
              as String,
      companyId: null == companyId
          ? _value.companyId
          : companyId // ignore: cast_nullable_to_non_nullable
              as String,
      roleName: null == roleName
          ? _value.roleName
          : roleName // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      roleType: null == roleType
          ? _value.roleType
          : roleType // ignore: cast_nullable_to_non_nullable
              as String,
      tags: null == tags
          ? _value._tags
          : tags // ignore: cast_nullable_to_non_nullable
              as List<String>,
      permissions: null == permissions
          ? _value._permissions
          : permissions // ignore: cast_nullable_to_non_nullable
              as List<String>,
      memberCount: null == memberCount
          ? _value.memberCount
          : memberCount // ignore: cast_nullable_to_non_nullable
              as int,
      canEdit: null == canEdit
          ? _value.canEdit
          : canEdit // ignore: cast_nullable_to_non_nullable
              as bool,
      canDelegate: null == canDelegate
          ? _value.canDelegate
          : canDelegate // ignore: cast_nullable_to_non_nullable
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

class _$RoleModelImpl extends _RoleModel {
  const _$RoleModelImpl(
      {required this.roleId,
      required this.companyId,
      required this.roleName,
      this.description,
      required this.roleType,
      required final List<String> tags,
      required final List<String> permissions,
      required this.memberCount,
      required this.canEdit,
      required this.canDelegate,
      this.createdAt,
      this.updatedAt})
      : _tags = tags,
        _permissions = permissions,
        super._();

  @override
  final String roleId;
  @override
  final String companyId;
  @override
  final String roleName;
  @override
  final String? description;
  @override
  final String roleType;
  final List<String> _tags;
  @override
  List<String> get tags {
    if (_tags is EqualUnmodifiableListView) return _tags;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_tags);
  }

  final List<String> _permissions;
  @override
  List<String> get permissions {
    if (_permissions is EqualUnmodifiableListView) return _permissions;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_permissions);
  }

  @override
  final int memberCount;
  @override
  final bool canEdit;
  @override
  final bool canDelegate;
  @override
  final DateTime? createdAt;
  @override
  final DateTime? updatedAt;

  @override
  String toString() {
    return 'RoleModel(roleId: $roleId, companyId: $companyId, roleName: $roleName, description: $description, roleType: $roleType, tags: $tags, permissions: $permissions, memberCount: $memberCount, canEdit: $canEdit, canDelegate: $canDelegate, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RoleModelImpl &&
            (identical(other.roleId, roleId) || other.roleId == roleId) &&
            (identical(other.companyId, companyId) ||
                other.companyId == companyId) &&
            (identical(other.roleName, roleName) ||
                other.roleName == roleName) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.roleType, roleType) ||
                other.roleType == roleType) &&
            const DeepCollectionEquality().equals(other._tags, _tags) &&
            const DeepCollectionEquality()
                .equals(other._permissions, _permissions) &&
            (identical(other.memberCount, memberCount) ||
                other.memberCount == memberCount) &&
            (identical(other.canEdit, canEdit) || other.canEdit == canEdit) &&
            (identical(other.canDelegate, canDelegate) ||
                other.canDelegate == canDelegate) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      roleId,
      companyId,
      roleName,
      description,
      roleType,
      const DeepCollectionEquality().hash(_tags),
      const DeepCollectionEquality().hash(_permissions),
      memberCount,
      canEdit,
      canDelegate,
      createdAt,
      updatedAt);

  /// Create a copy of RoleModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$RoleModelImplCopyWith<_$RoleModelImpl> get copyWith =>
      __$$RoleModelImplCopyWithImpl<_$RoleModelImpl>(this, _$identity);
}

abstract class _RoleModel extends RoleModel {
  const factory _RoleModel(
      {required final String roleId,
      required final String companyId,
      required final String roleName,
      final String? description,
      required final String roleType,
      required final List<String> tags,
      required final List<String> permissions,
      required final int memberCount,
      required final bool canEdit,
      required final bool canDelegate,
      final DateTime? createdAt,
      final DateTime? updatedAt}) = _$RoleModelImpl;
  const _RoleModel._() : super._();

  @override
  String get roleId;
  @override
  String get companyId;
  @override
  String get roleName;
  @override
  String? get description;
  @override
  String get roleType;
  @override
  List<String> get tags;
  @override
  List<String> get permissions;
  @override
  int get memberCount;
  @override
  bool get canEdit;
  @override
  bool get canDelegate;
  @override
  DateTime? get createdAt;
  @override
  DateTime? get updatedAt;

  /// Create a copy of RoleModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$RoleModelImplCopyWith<_$RoleModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
