// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'delegatable_role.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$DelegatableRole {
  String get roleId => throw _privateConstructorUsedError;
  String get roleName => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  List<String> get permissions => throw _privateConstructorUsedError;
  bool get canDelegate => throw _privateConstructorUsedError;

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

class _$DelegatableRoleImpl implements _DelegatableRole {
  const _$DelegatableRoleImpl(
      {required this.roleId,
      required this.roleName,
      required this.description,
      required final List<String> permissions,
      required this.canDelegate})
      : _permissions = permissions;

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
}

abstract class _DelegatableRole implements DelegatableRole {
  const factory _DelegatableRole(
      {required final String roleId,
      required final String roleName,
      required final String description,
      required final List<String> permissions,
      required final bool canDelegate}) = _$DelegatableRoleImpl;

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
