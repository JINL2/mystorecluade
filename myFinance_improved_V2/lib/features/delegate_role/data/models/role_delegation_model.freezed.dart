// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'role_delegation_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

RoleDelegationModel _$RoleDelegationModelFromJson(Map<String, dynamic> json) {
  return _RoleDelegationModel.fromJson(json);
}

/// @nodoc
mixin _$RoleDelegationModel {
  String get id => throw _privateConstructorUsedError;
  String get delegatorId => throw _privateConstructorUsedError;
  String get delegateId => throw _privateConstructorUsedError;
  String get companyId => throw _privateConstructorUsedError;
  String get roleId => throw _privateConstructorUsedError;
  String get roleName => throw _privateConstructorUsedError;
  Map<String, dynamic> get delegateUser => throw _privateConstructorUsedError;
  List<String> get permissions => throw _privateConstructorUsedError;
  @_DateTimeConverter()
  DateTime get startDate => throw _privateConstructorUsedError;
  @_DateTimeConverter()
  DateTime get endDate => throw _privateConstructorUsedError;
  bool get isActive => throw _privateConstructorUsedError;
  @_NullableDateTimeConverter()
  DateTime? get createdAt => throw _privateConstructorUsedError;
  @_NullableDateTimeConverter()
  DateTime? get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this RoleDelegationModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of RoleDelegationModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $RoleDelegationModelCopyWith<RoleDelegationModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RoleDelegationModelCopyWith<$Res> {
  factory $RoleDelegationModelCopyWith(
          RoleDelegationModel value, $Res Function(RoleDelegationModel) then) =
      _$RoleDelegationModelCopyWithImpl<$Res, RoleDelegationModel>;
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
      @_DateTimeConverter() DateTime startDate,
      @_DateTimeConverter() DateTime endDate,
      bool isActive,
      @_NullableDateTimeConverter() DateTime? createdAt,
      @_NullableDateTimeConverter() DateTime? updatedAt});
}

/// @nodoc
class _$RoleDelegationModelCopyWithImpl<$Res, $Val extends RoleDelegationModel>
    implements $RoleDelegationModelCopyWith<$Res> {
  _$RoleDelegationModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of RoleDelegationModel
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
abstract class _$$RoleDelegationModelImplCopyWith<$Res>
    implements $RoleDelegationModelCopyWith<$Res> {
  factory _$$RoleDelegationModelImplCopyWith(_$RoleDelegationModelImpl value,
          $Res Function(_$RoleDelegationModelImpl) then) =
      __$$RoleDelegationModelImplCopyWithImpl<$Res>;
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
      @_DateTimeConverter() DateTime startDate,
      @_DateTimeConverter() DateTime endDate,
      bool isActive,
      @_NullableDateTimeConverter() DateTime? createdAt,
      @_NullableDateTimeConverter() DateTime? updatedAt});
}

/// @nodoc
class __$$RoleDelegationModelImplCopyWithImpl<$Res>
    extends _$RoleDelegationModelCopyWithImpl<$Res, _$RoleDelegationModelImpl>
    implements _$$RoleDelegationModelImplCopyWith<$Res> {
  __$$RoleDelegationModelImplCopyWithImpl(_$RoleDelegationModelImpl _value,
      $Res Function(_$RoleDelegationModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of RoleDelegationModel
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
    return _then(_$RoleDelegationModelImpl(
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
class _$RoleDelegationModelImpl extends _RoleDelegationModel {
  const _$RoleDelegationModelImpl(
      {required this.id,
      required this.delegatorId,
      required this.delegateId,
      required this.companyId,
      required this.roleId,
      required this.roleName,
      required final Map<String, dynamic> delegateUser,
      required final List<String> permissions,
      @_DateTimeConverter() required this.startDate,
      @_DateTimeConverter() required this.endDate,
      required this.isActive,
      @_NullableDateTimeConverter() this.createdAt,
      @_NullableDateTimeConverter() this.updatedAt})
      : _delegateUser = delegateUser,
        _permissions = permissions,
        super._();

  factory _$RoleDelegationModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$RoleDelegationModelImplFromJson(json);

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
  @_DateTimeConverter()
  final DateTime startDate;
  @override
  @_DateTimeConverter()
  final DateTime endDate;
  @override
  final bool isActive;
  @override
  @_NullableDateTimeConverter()
  final DateTime? createdAt;
  @override
  @_NullableDateTimeConverter()
  final DateTime? updatedAt;

  @override
  String toString() {
    return 'RoleDelegationModel(id: $id, delegatorId: $delegatorId, delegateId: $delegateId, companyId: $companyId, roleId: $roleId, roleName: $roleName, delegateUser: $delegateUser, permissions: $permissions, startDate: $startDate, endDate: $endDate, isActive: $isActive, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RoleDelegationModelImpl &&
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

  /// Create a copy of RoleDelegationModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$RoleDelegationModelImplCopyWith<_$RoleDelegationModelImpl> get copyWith =>
      __$$RoleDelegationModelImplCopyWithImpl<_$RoleDelegationModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$RoleDelegationModelImplToJson(
      this,
    );
  }
}

abstract class _RoleDelegationModel extends RoleDelegationModel {
  const factory _RoleDelegationModel(
          {required final String id,
          required final String delegatorId,
          required final String delegateId,
          required final String companyId,
          required final String roleId,
          required final String roleName,
          required final Map<String, dynamic> delegateUser,
          required final List<String> permissions,
          @_DateTimeConverter() required final DateTime startDate,
          @_DateTimeConverter() required final DateTime endDate,
          required final bool isActive,
          @_NullableDateTimeConverter() final DateTime? createdAt,
          @_NullableDateTimeConverter() final DateTime? updatedAt}) =
      _$RoleDelegationModelImpl;
  const _RoleDelegationModel._() : super._();

  factory _RoleDelegationModel.fromJson(Map<String, dynamic> json) =
      _$RoleDelegationModelImpl.fromJson;

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
  @_DateTimeConverter()
  DateTime get startDate;
  @override
  @_DateTimeConverter()
  DateTime get endDate;
  @override
  bool get isActive;
  @override
  @_NullableDateTimeConverter()
  DateTime? get createdAt;
  @override
  @_NullableDateTimeConverter()
  DateTime? get updatedAt;

  /// Create a copy of RoleDelegationModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$RoleDelegationModelImplCopyWith<_$RoleDelegationModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
