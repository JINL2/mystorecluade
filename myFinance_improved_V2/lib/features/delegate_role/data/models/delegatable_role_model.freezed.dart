// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'delegatable_role_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

DelegatableRoleModel _$DelegatableRoleModelFromJson(Map<String, dynamic> json) {
  return _DelegatableRoleModel.fromJson(json);
}

/// @nodoc
mixin _$DelegatableRoleModel {
  String get roleId => throw _privateConstructorUsedError;
  String get roleName => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  List<String> get permissions => throw _privateConstructorUsedError;
  bool get canDelegate => throw _privateConstructorUsedError;

  /// Serializes this DelegatableRoleModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of DelegatableRoleModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $DelegatableRoleModelCopyWith<DelegatableRoleModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DelegatableRoleModelCopyWith<$Res> {
  factory $DelegatableRoleModelCopyWith(DelegatableRoleModel value,
          $Res Function(DelegatableRoleModel) then) =
      _$DelegatableRoleModelCopyWithImpl<$Res, DelegatableRoleModel>;
  @useResult
  $Res call(
      {String roleId,
      String roleName,
      String description,
      List<String> permissions,
      bool canDelegate});
}

/// @nodoc
class _$DelegatableRoleModelCopyWithImpl<$Res,
        $Val extends DelegatableRoleModel>
    implements $DelegatableRoleModelCopyWith<$Res> {
  _$DelegatableRoleModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of DelegatableRoleModel
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
abstract class _$$DelegatableRoleModelImplCopyWith<$Res>
    implements $DelegatableRoleModelCopyWith<$Res> {
  factory _$$DelegatableRoleModelImplCopyWith(_$DelegatableRoleModelImpl value,
          $Res Function(_$DelegatableRoleModelImpl) then) =
      __$$DelegatableRoleModelImplCopyWithImpl<$Res>;
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
class __$$DelegatableRoleModelImplCopyWithImpl<$Res>
    extends _$DelegatableRoleModelCopyWithImpl<$Res, _$DelegatableRoleModelImpl>
    implements _$$DelegatableRoleModelImplCopyWith<$Res> {
  __$$DelegatableRoleModelImplCopyWithImpl(_$DelegatableRoleModelImpl _value,
      $Res Function(_$DelegatableRoleModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of DelegatableRoleModel
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
    return _then(_$DelegatableRoleModelImpl(
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
class _$DelegatableRoleModelImpl extends _DelegatableRoleModel {
  const _$DelegatableRoleModelImpl(
      {required this.roleId,
      required this.roleName,
      required this.description,
      required final List<String> permissions,
      required this.canDelegate})
      : _permissions = permissions,
        super._();

  factory _$DelegatableRoleModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$DelegatableRoleModelImplFromJson(json);

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
    return 'DelegatableRoleModel(roleId: $roleId, roleName: $roleName, description: $description, permissions: $permissions, canDelegate: $canDelegate)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DelegatableRoleModelImpl &&
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

  /// Create a copy of DelegatableRoleModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DelegatableRoleModelImplCopyWith<_$DelegatableRoleModelImpl>
      get copyWith =>
          __$$DelegatableRoleModelImplCopyWithImpl<_$DelegatableRoleModelImpl>(
              this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$DelegatableRoleModelImplToJson(
      this,
    );
  }
}

abstract class _DelegatableRoleModel extends DelegatableRoleModel {
  const factory _DelegatableRoleModel(
      {required final String roleId,
      required final String roleName,
      required final String description,
      required final List<String> permissions,
      required final bool canDelegate}) = _$DelegatableRoleModelImpl;
  const _DelegatableRoleModel._() : super._();

  factory _DelegatableRoleModel.fromJson(Map<String, dynamic> json) =
      _$DelegatableRoleModelImpl.fromJson;

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

  /// Create a copy of DelegatableRoleModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DelegatableRoleModelImplCopyWith<_$DelegatableRoleModelImpl>
      get copyWith => throw _privateConstructorUsedError;
}
