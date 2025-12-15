// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'join_result_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

JoinResultModel _$JoinResultModelFromJson(Map<String, dynamic> json) {
  return _JoinResultModel.fromJson(json);
}

/// @nodoc
mixin _$JoinResultModel {
  bool get success => throw _privateConstructorUsedError;
  String? get type => throw _privateConstructorUsedError;
  String? get message => throw _privateConstructorUsedError;
  @JsonKey(name: 'company_id')
  String? get companyId => throw _privateConstructorUsedError;
  @JsonKey(name: 'company_name')
  String? get companyName => throw _privateConstructorUsedError;
  @JsonKey(name: 'store_id')
  String? get storeId => throw _privateConstructorUsedError;
  @JsonKey(name: 'store_name')
  String? get storeName => throw _privateConstructorUsedError;
  @JsonKey(name: 'role_assigned')
  bool get roleAssignedFlag => throw _privateConstructorUsedError;

  /// Serializes this JoinResultModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of JoinResultModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $JoinResultModelCopyWith<JoinResultModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $JoinResultModelCopyWith<$Res> {
  factory $JoinResultModelCopyWith(
          JoinResultModel value, $Res Function(JoinResultModel) then) =
      _$JoinResultModelCopyWithImpl<$Res, JoinResultModel>;
  @useResult
  $Res call(
      {bool success,
      String? type,
      String? message,
      @JsonKey(name: 'company_id') String? companyId,
      @JsonKey(name: 'company_name') String? companyName,
      @JsonKey(name: 'store_id') String? storeId,
      @JsonKey(name: 'store_name') String? storeName,
      @JsonKey(name: 'role_assigned') bool roleAssignedFlag});
}

/// @nodoc
class _$JoinResultModelCopyWithImpl<$Res, $Val extends JoinResultModel>
    implements $JoinResultModelCopyWith<$Res> {
  _$JoinResultModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of JoinResultModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? success = null,
    Object? type = freezed,
    Object? message = freezed,
    Object? companyId = freezed,
    Object? companyName = freezed,
    Object? storeId = freezed,
    Object? storeName = freezed,
    Object? roleAssignedFlag = null,
  }) {
    return _then(_value.copyWith(
      success: null == success
          ? _value.success
          : success // ignore: cast_nullable_to_non_nullable
              as bool,
      type: freezed == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String?,
      message: freezed == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String?,
      companyId: freezed == companyId
          ? _value.companyId
          : companyId // ignore: cast_nullable_to_non_nullable
              as String?,
      companyName: freezed == companyName
          ? _value.companyName
          : companyName // ignore: cast_nullable_to_non_nullable
              as String?,
      storeId: freezed == storeId
          ? _value.storeId
          : storeId // ignore: cast_nullable_to_non_nullable
              as String?,
      storeName: freezed == storeName
          ? _value.storeName
          : storeName // ignore: cast_nullable_to_non_nullable
              as String?,
      roleAssignedFlag: null == roleAssignedFlag
          ? _value.roleAssignedFlag
          : roleAssignedFlag // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$JoinResultModelImplCopyWith<$Res>
    implements $JoinResultModelCopyWith<$Res> {
  factory _$$JoinResultModelImplCopyWith(_$JoinResultModelImpl value,
          $Res Function(_$JoinResultModelImpl) then) =
      __$$JoinResultModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {bool success,
      String? type,
      String? message,
      @JsonKey(name: 'company_id') String? companyId,
      @JsonKey(name: 'company_name') String? companyName,
      @JsonKey(name: 'store_id') String? storeId,
      @JsonKey(name: 'store_name') String? storeName,
      @JsonKey(name: 'role_assigned') bool roleAssignedFlag});
}

/// @nodoc
class __$$JoinResultModelImplCopyWithImpl<$Res>
    extends _$JoinResultModelCopyWithImpl<$Res, _$JoinResultModelImpl>
    implements _$$JoinResultModelImplCopyWith<$Res> {
  __$$JoinResultModelImplCopyWithImpl(
      _$JoinResultModelImpl _value, $Res Function(_$JoinResultModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of JoinResultModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? success = null,
    Object? type = freezed,
    Object? message = freezed,
    Object? companyId = freezed,
    Object? companyName = freezed,
    Object? storeId = freezed,
    Object? storeName = freezed,
    Object? roleAssignedFlag = null,
  }) {
    return _then(_$JoinResultModelImpl(
      success: null == success
          ? _value.success
          : success // ignore: cast_nullable_to_non_nullable
              as bool,
      type: freezed == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String?,
      message: freezed == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String?,
      companyId: freezed == companyId
          ? _value.companyId
          : companyId // ignore: cast_nullable_to_non_nullable
              as String?,
      companyName: freezed == companyName
          ? _value.companyName
          : companyName // ignore: cast_nullable_to_non_nullable
              as String?,
      storeId: freezed == storeId
          ? _value.storeId
          : storeId // ignore: cast_nullable_to_non_nullable
              as String?,
      storeName: freezed == storeName
          ? _value.storeName
          : storeName // ignore: cast_nullable_to_non_nullable
              as String?,
      roleAssignedFlag: null == roleAssignedFlag
          ? _value.roleAssignedFlag
          : roleAssignedFlag // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$JoinResultModelImpl extends _JoinResultModel {
  const _$JoinResultModelImpl(
      {this.success = false,
      this.type,
      this.message,
      @JsonKey(name: 'company_id') this.companyId,
      @JsonKey(name: 'company_name') this.companyName,
      @JsonKey(name: 'store_id') this.storeId,
      @JsonKey(name: 'store_name') this.storeName,
      @JsonKey(name: 'role_assigned') this.roleAssignedFlag = false})
      : super._();

  factory _$JoinResultModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$JoinResultModelImplFromJson(json);

  @override
  @JsonKey()
  final bool success;
  @override
  final String? type;
  @override
  final String? message;
  @override
  @JsonKey(name: 'company_id')
  final String? companyId;
  @override
  @JsonKey(name: 'company_name')
  final String? companyName;
  @override
  @JsonKey(name: 'store_id')
  final String? storeId;
  @override
  @JsonKey(name: 'store_name')
  final String? storeName;
  @override
  @JsonKey(name: 'role_assigned')
  final bool roleAssignedFlag;

  @override
  String toString() {
    return 'JoinResultModel(success: $success, type: $type, message: $message, companyId: $companyId, companyName: $companyName, storeId: $storeId, storeName: $storeName, roleAssignedFlag: $roleAssignedFlag)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$JoinResultModelImpl &&
            (identical(other.success, success) || other.success == success) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.message, message) || other.message == message) &&
            (identical(other.companyId, companyId) ||
                other.companyId == companyId) &&
            (identical(other.companyName, companyName) ||
                other.companyName == companyName) &&
            (identical(other.storeId, storeId) || other.storeId == storeId) &&
            (identical(other.storeName, storeName) ||
                other.storeName == storeName) &&
            (identical(other.roleAssignedFlag, roleAssignedFlag) ||
                other.roleAssignedFlag == roleAssignedFlag));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, success, type, message,
      companyId, companyName, storeId, storeName, roleAssignedFlag);

  /// Create a copy of JoinResultModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$JoinResultModelImplCopyWith<_$JoinResultModelImpl> get copyWith =>
      __$$JoinResultModelImplCopyWithImpl<_$JoinResultModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$JoinResultModelImplToJson(
      this,
    );
  }
}

abstract class _JoinResultModel extends JoinResultModel {
  const factory _JoinResultModel(
          {final bool success,
          final String? type,
          final String? message,
          @JsonKey(name: 'company_id') final String? companyId,
          @JsonKey(name: 'company_name') final String? companyName,
          @JsonKey(name: 'store_id') final String? storeId,
          @JsonKey(name: 'store_name') final String? storeName,
          @JsonKey(name: 'role_assigned') final bool roleAssignedFlag}) =
      _$JoinResultModelImpl;
  const _JoinResultModel._() : super._();

  factory _JoinResultModel.fromJson(Map<String, dynamic> json) =
      _$JoinResultModelImpl.fromJson;

  @override
  bool get success;
  @override
  String? get type;
  @override
  String? get message;
  @override
  @JsonKey(name: 'company_id')
  String? get companyId;
  @override
  @JsonKey(name: 'company_name')
  String? get companyName;
  @override
  @JsonKey(name: 'store_id')
  String? get storeId;
  @override
  @JsonKey(name: 'store_name')
  String? get storeName;
  @override
  @JsonKey(name: 'role_assigned')
  bool get roleAssignedFlag;

  /// Create a copy of JoinResultModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$JoinResultModelImplCopyWith<_$JoinResultModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
