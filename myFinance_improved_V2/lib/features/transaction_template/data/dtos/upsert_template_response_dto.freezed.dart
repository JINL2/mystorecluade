// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'upsert_template_response_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

UpsertTemplateResponseDto _$UpsertTemplateResponseDtoFromJson(
    Map<String, dynamic> json) {
  return _UpsertTemplateResponseDto.fromJson(json);
}

/// @nodoc
mixin _$UpsertTemplateResponseDto {
  /// Whether the RPC call was successful
  bool get success => throw _privateConstructorUsedError;

  /// Response data containing created/updated template
  UpsertTemplateDataDto? get data => throw _privateConstructorUsedError;

  /// Error code if failed
  String? get error => throw _privateConstructorUsedError;

  /// Human-readable message
  String? get message => throw _privateConstructorUsedError;

  /// Serializes this UpsertTemplateResponseDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of UpsertTemplateResponseDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $UpsertTemplateResponseDtoCopyWith<UpsertTemplateResponseDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UpsertTemplateResponseDtoCopyWith<$Res> {
  factory $UpsertTemplateResponseDtoCopyWith(UpsertTemplateResponseDto value,
          $Res Function(UpsertTemplateResponseDto) then) =
      _$UpsertTemplateResponseDtoCopyWithImpl<$Res, UpsertTemplateResponseDto>;
  @useResult
  $Res call(
      {bool success,
      UpsertTemplateDataDto? data,
      String? error,
      String? message});

  $UpsertTemplateDataDtoCopyWith<$Res>? get data;
}

/// @nodoc
class _$UpsertTemplateResponseDtoCopyWithImpl<$Res,
        $Val extends UpsertTemplateResponseDto>
    implements $UpsertTemplateResponseDtoCopyWith<$Res> {
  _$UpsertTemplateResponseDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of UpsertTemplateResponseDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? success = null,
    Object? data = freezed,
    Object? error = freezed,
    Object? message = freezed,
  }) {
    return _then(_value.copyWith(
      success: null == success
          ? _value.success
          : success // ignore: cast_nullable_to_non_nullable
              as bool,
      data: freezed == data
          ? _value.data
          : data // ignore: cast_nullable_to_non_nullable
              as UpsertTemplateDataDto?,
      error: freezed == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as String?,
      message: freezed == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }

  /// Create a copy of UpsertTemplateResponseDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $UpsertTemplateDataDtoCopyWith<$Res>? get data {
    if (_value.data == null) {
      return null;
    }

    return $UpsertTemplateDataDtoCopyWith<$Res>(_value.data!, (value) {
      return _then(_value.copyWith(data: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$UpsertTemplateResponseDtoImplCopyWith<$Res>
    implements $UpsertTemplateResponseDtoCopyWith<$Res> {
  factory _$$UpsertTemplateResponseDtoImplCopyWith(
          _$UpsertTemplateResponseDtoImpl value,
          $Res Function(_$UpsertTemplateResponseDtoImpl) then) =
      __$$UpsertTemplateResponseDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {bool success,
      UpsertTemplateDataDto? data,
      String? error,
      String? message});

  @override
  $UpsertTemplateDataDtoCopyWith<$Res>? get data;
}

/// @nodoc
class __$$UpsertTemplateResponseDtoImplCopyWithImpl<$Res>
    extends _$UpsertTemplateResponseDtoCopyWithImpl<$Res,
        _$UpsertTemplateResponseDtoImpl>
    implements _$$UpsertTemplateResponseDtoImplCopyWith<$Res> {
  __$$UpsertTemplateResponseDtoImplCopyWithImpl(
      _$UpsertTemplateResponseDtoImpl _value,
      $Res Function(_$UpsertTemplateResponseDtoImpl) _then)
      : super(_value, _then);

  /// Create a copy of UpsertTemplateResponseDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? success = null,
    Object? data = freezed,
    Object? error = freezed,
    Object? message = freezed,
  }) {
    return _then(_$UpsertTemplateResponseDtoImpl(
      success: null == success
          ? _value.success
          : success // ignore: cast_nullable_to_non_nullable
              as bool,
      data: freezed == data
          ? _value.data
          : data // ignore: cast_nullable_to_non_nullable
              as UpsertTemplateDataDto?,
      error: freezed == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as String?,
      message: freezed == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$UpsertTemplateResponseDtoImpl implements _UpsertTemplateResponseDto {
  const _$UpsertTemplateResponseDtoImpl(
      {required this.success, this.data, this.error, this.message});

  factory _$UpsertTemplateResponseDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$UpsertTemplateResponseDtoImplFromJson(json);

  /// Whether the RPC call was successful
  @override
  final bool success;

  /// Response data containing created/updated template
  @override
  final UpsertTemplateDataDto? data;

  /// Error code if failed
  @override
  final String? error;

  /// Human-readable message
  @override
  final String? message;

  @override
  String toString() {
    return 'UpsertTemplateResponseDto(success: $success, data: $data, error: $error, message: $message)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UpsertTemplateResponseDtoImpl &&
            (identical(other.success, success) || other.success == success) &&
            (identical(other.data, data) || other.data == data) &&
            (identical(other.error, error) || other.error == error) &&
            (identical(other.message, message) || other.message == message));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, success, data, error, message);

  /// Create a copy of UpsertTemplateResponseDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UpsertTemplateResponseDtoImplCopyWith<_$UpsertTemplateResponseDtoImpl>
      get copyWith => __$$UpsertTemplateResponseDtoImplCopyWithImpl<
          _$UpsertTemplateResponseDtoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UpsertTemplateResponseDtoImplToJson(
      this,
    );
  }
}

abstract class _UpsertTemplateResponseDto implements UpsertTemplateResponseDto {
  const factory _UpsertTemplateResponseDto(
      {required final bool success,
      final UpsertTemplateDataDto? data,
      final String? error,
      final String? message}) = _$UpsertTemplateResponseDtoImpl;

  factory _UpsertTemplateResponseDto.fromJson(Map<String, dynamic> json) =
      _$UpsertTemplateResponseDtoImpl.fromJson;

  /// Whether the RPC call was successful
  @override
  bool get success;

  /// Response data containing created/updated template
  @override
  UpsertTemplateDataDto? get data;

  /// Error code if failed
  @override
  String? get error;

  /// Human-readable message
  @override
  String? get message;

  /// Create a copy of UpsertTemplateResponseDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UpsertTemplateResponseDtoImplCopyWith<_$UpsertTemplateResponseDtoImpl>
      get copyWith => throw _privateConstructorUsedError;
}

UpsertTemplateDataDto _$UpsertTemplateDataDtoFromJson(
    Map<String, dynamic> json) {
  return _UpsertTemplateDataDto.fromJson(json);
}

/// @nodoc
mixin _$UpsertTemplateDataDto {
  /// Unique template identifier
  @JsonKey(name: 'template_id')
  String get templateId => throw _privateConstructorUsedError;

  /// Template display name
  String get name => throw _privateConstructorUsedError;

  /// Optional description
  @JsonKey(name: 'template_description')
  String? get templateDescription => throw _privateConstructorUsedError;

  /// Template visibility level
  @JsonKey(name: 'visibility_level')
  String get visibilityLevel => throw _privateConstructorUsedError;

  /// Template permission level
  String get permission => throw _privateConstructorUsedError;

  /// Company identifier
  @JsonKey(name: 'company_id')
  String get companyId => throw _privateConstructorUsedError;

  /// Store identifier (nullable)
  @JsonKey(name: 'store_id')
  String? get storeId => throw _privateConstructorUsedError;

  /// Active status flag
  @JsonKey(name: 'is_active')
  bool get isActive => throw _privateConstructorUsedError;

  /// Whether attachment is required
  @JsonKey(name: 'required_attachment')
  bool get requiredAttachment => throw _privateConstructorUsedError;

  /// Creation timestamp (local time)
  @JsonKey(name: 'created_at')
  String get createdAt => throw _privateConstructorUsedError;

  /// Last update timestamp (local time)
  @JsonKey(name: 'updated_at')
  String get updatedAt => throw _privateConstructorUsedError;

  /// Template creator
  @JsonKey(name: 'created_by')
  String? get createdBy => throw _privateConstructorUsedError;

  /// Last updater
  @JsonKey(name: 'updated_by')
  String? get updatedBy => throw _privateConstructorUsedError;

  /// Serializes this UpsertTemplateDataDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of UpsertTemplateDataDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $UpsertTemplateDataDtoCopyWith<UpsertTemplateDataDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UpsertTemplateDataDtoCopyWith<$Res> {
  factory $UpsertTemplateDataDtoCopyWith(UpsertTemplateDataDto value,
          $Res Function(UpsertTemplateDataDto) then) =
      _$UpsertTemplateDataDtoCopyWithImpl<$Res, UpsertTemplateDataDto>;
  @useResult
  $Res call(
      {@JsonKey(name: 'template_id') String templateId,
      String name,
      @JsonKey(name: 'template_description') String? templateDescription,
      @JsonKey(name: 'visibility_level') String visibilityLevel,
      String permission,
      @JsonKey(name: 'company_id') String companyId,
      @JsonKey(name: 'store_id') String? storeId,
      @JsonKey(name: 'is_active') bool isActive,
      @JsonKey(name: 'required_attachment') bool requiredAttachment,
      @JsonKey(name: 'created_at') String createdAt,
      @JsonKey(name: 'updated_at') String updatedAt,
      @JsonKey(name: 'created_by') String? createdBy,
      @JsonKey(name: 'updated_by') String? updatedBy});
}

/// @nodoc
class _$UpsertTemplateDataDtoCopyWithImpl<$Res,
        $Val extends UpsertTemplateDataDto>
    implements $UpsertTemplateDataDtoCopyWith<$Res> {
  _$UpsertTemplateDataDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of UpsertTemplateDataDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? templateId = null,
    Object? name = null,
    Object? templateDescription = freezed,
    Object? visibilityLevel = null,
    Object? permission = null,
    Object? companyId = null,
    Object? storeId = freezed,
    Object? isActive = null,
    Object? requiredAttachment = null,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? createdBy = freezed,
    Object? updatedBy = freezed,
  }) {
    return _then(_value.copyWith(
      templateId: null == templateId
          ? _value.templateId
          : templateId // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      templateDescription: freezed == templateDescription
          ? _value.templateDescription
          : templateDescription // ignore: cast_nullable_to_non_nullable
              as String?,
      visibilityLevel: null == visibilityLevel
          ? _value.visibilityLevel
          : visibilityLevel // ignore: cast_nullable_to_non_nullable
              as String,
      permission: null == permission
          ? _value.permission
          : permission // ignore: cast_nullable_to_non_nullable
              as String,
      companyId: null == companyId
          ? _value.companyId
          : companyId // ignore: cast_nullable_to_non_nullable
              as String,
      storeId: freezed == storeId
          ? _value.storeId
          : storeId // ignore: cast_nullable_to_non_nullable
              as String?,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
      requiredAttachment: null == requiredAttachment
          ? _value.requiredAttachment
          : requiredAttachment // ignore: cast_nullable_to_non_nullable
              as bool,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as String,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as String,
      createdBy: freezed == createdBy
          ? _value.createdBy
          : createdBy // ignore: cast_nullable_to_non_nullable
              as String?,
      updatedBy: freezed == updatedBy
          ? _value.updatedBy
          : updatedBy // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$UpsertTemplateDataDtoImplCopyWith<$Res>
    implements $UpsertTemplateDataDtoCopyWith<$Res> {
  factory _$$UpsertTemplateDataDtoImplCopyWith(
          _$UpsertTemplateDataDtoImpl value,
          $Res Function(_$UpsertTemplateDataDtoImpl) then) =
      __$$UpsertTemplateDataDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'template_id') String templateId,
      String name,
      @JsonKey(name: 'template_description') String? templateDescription,
      @JsonKey(name: 'visibility_level') String visibilityLevel,
      String permission,
      @JsonKey(name: 'company_id') String companyId,
      @JsonKey(name: 'store_id') String? storeId,
      @JsonKey(name: 'is_active') bool isActive,
      @JsonKey(name: 'required_attachment') bool requiredAttachment,
      @JsonKey(name: 'created_at') String createdAt,
      @JsonKey(name: 'updated_at') String updatedAt,
      @JsonKey(name: 'created_by') String? createdBy,
      @JsonKey(name: 'updated_by') String? updatedBy});
}

/// @nodoc
class __$$UpsertTemplateDataDtoImplCopyWithImpl<$Res>
    extends _$UpsertTemplateDataDtoCopyWithImpl<$Res,
        _$UpsertTemplateDataDtoImpl>
    implements _$$UpsertTemplateDataDtoImplCopyWith<$Res> {
  __$$UpsertTemplateDataDtoImplCopyWithImpl(_$UpsertTemplateDataDtoImpl _value,
      $Res Function(_$UpsertTemplateDataDtoImpl) _then)
      : super(_value, _then);

  /// Create a copy of UpsertTemplateDataDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? templateId = null,
    Object? name = null,
    Object? templateDescription = freezed,
    Object? visibilityLevel = null,
    Object? permission = null,
    Object? companyId = null,
    Object? storeId = freezed,
    Object? isActive = null,
    Object? requiredAttachment = null,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? createdBy = freezed,
    Object? updatedBy = freezed,
  }) {
    return _then(_$UpsertTemplateDataDtoImpl(
      templateId: null == templateId
          ? _value.templateId
          : templateId // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      templateDescription: freezed == templateDescription
          ? _value.templateDescription
          : templateDescription // ignore: cast_nullable_to_non_nullable
              as String?,
      visibilityLevel: null == visibilityLevel
          ? _value.visibilityLevel
          : visibilityLevel // ignore: cast_nullable_to_non_nullable
              as String,
      permission: null == permission
          ? _value.permission
          : permission // ignore: cast_nullable_to_non_nullable
              as String,
      companyId: null == companyId
          ? _value.companyId
          : companyId // ignore: cast_nullable_to_non_nullable
              as String,
      storeId: freezed == storeId
          ? _value.storeId
          : storeId // ignore: cast_nullable_to_non_nullable
              as String?,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
      requiredAttachment: null == requiredAttachment
          ? _value.requiredAttachment
          : requiredAttachment // ignore: cast_nullable_to_non_nullable
              as bool,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as String,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as String,
      createdBy: freezed == createdBy
          ? _value.createdBy
          : createdBy // ignore: cast_nullable_to_non_nullable
              as String?,
      updatedBy: freezed == updatedBy
          ? _value.updatedBy
          : updatedBy // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$UpsertTemplateDataDtoImpl implements _UpsertTemplateDataDto {
  const _$UpsertTemplateDataDtoImpl(
      {@JsonKey(name: 'template_id') required this.templateId,
      required this.name,
      @JsonKey(name: 'template_description') this.templateDescription,
      @JsonKey(name: 'visibility_level') required this.visibilityLevel,
      required this.permission,
      @JsonKey(name: 'company_id') required this.companyId,
      @JsonKey(name: 'store_id') this.storeId,
      @JsonKey(name: 'is_active') this.isActive = true,
      @JsonKey(name: 'required_attachment') this.requiredAttachment = false,
      @JsonKey(name: 'created_at') required this.createdAt,
      @JsonKey(name: 'updated_at') required this.updatedAt,
      @JsonKey(name: 'created_by') this.createdBy,
      @JsonKey(name: 'updated_by') this.updatedBy});

  factory _$UpsertTemplateDataDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$UpsertTemplateDataDtoImplFromJson(json);

  /// Unique template identifier
  @override
  @JsonKey(name: 'template_id')
  final String templateId;

  /// Template display name
  @override
  final String name;

  /// Optional description
  @override
  @JsonKey(name: 'template_description')
  final String? templateDescription;

  /// Template visibility level
  @override
  @JsonKey(name: 'visibility_level')
  final String visibilityLevel;

  /// Template permission level
  @override
  final String permission;

  /// Company identifier
  @override
  @JsonKey(name: 'company_id')
  final String companyId;

  /// Store identifier (nullable)
  @override
  @JsonKey(name: 'store_id')
  final String? storeId;

  /// Active status flag
  @override
  @JsonKey(name: 'is_active')
  final bool isActive;

  /// Whether attachment is required
  @override
  @JsonKey(name: 'required_attachment')
  final bool requiredAttachment;

  /// Creation timestamp (local time)
  @override
  @JsonKey(name: 'created_at')
  final String createdAt;

  /// Last update timestamp (local time)
  @override
  @JsonKey(name: 'updated_at')
  final String updatedAt;

  /// Template creator
  @override
  @JsonKey(name: 'created_by')
  final String? createdBy;

  /// Last updater
  @override
  @JsonKey(name: 'updated_by')
  final String? updatedBy;

  @override
  String toString() {
    return 'UpsertTemplateDataDto(templateId: $templateId, name: $name, templateDescription: $templateDescription, visibilityLevel: $visibilityLevel, permission: $permission, companyId: $companyId, storeId: $storeId, isActive: $isActive, requiredAttachment: $requiredAttachment, createdAt: $createdAt, updatedAt: $updatedAt, createdBy: $createdBy, updatedBy: $updatedBy)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UpsertTemplateDataDtoImpl &&
            (identical(other.templateId, templateId) ||
                other.templateId == templateId) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.templateDescription, templateDescription) ||
                other.templateDescription == templateDescription) &&
            (identical(other.visibilityLevel, visibilityLevel) ||
                other.visibilityLevel == visibilityLevel) &&
            (identical(other.permission, permission) ||
                other.permission == permission) &&
            (identical(other.companyId, companyId) ||
                other.companyId == companyId) &&
            (identical(other.storeId, storeId) || other.storeId == storeId) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive) &&
            (identical(other.requiredAttachment, requiredAttachment) ||
                other.requiredAttachment == requiredAttachment) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.createdBy, createdBy) ||
                other.createdBy == createdBy) &&
            (identical(other.updatedBy, updatedBy) ||
                other.updatedBy == updatedBy));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      templateId,
      name,
      templateDescription,
      visibilityLevel,
      permission,
      companyId,
      storeId,
      isActive,
      requiredAttachment,
      createdAt,
      updatedAt,
      createdBy,
      updatedBy);

  /// Create a copy of UpsertTemplateDataDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UpsertTemplateDataDtoImplCopyWith<_$UpsertTemplateDataDtoImpl>
      get copyWith => __$$UpsertTemplateDataDtoImplCopyWithImpl<
          _$UpsertTemplateDataDtoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UpsertTemplateDataDtoImplToJson(
      this,
    );
  }
}

abstract class _UpsertTemplateDataDto implements UpsertTemplateDataDto {
  const factory _UpsertTemplateDataDto(
      {@JsonKey(name: 'template_id') required final String templateId,
      required final String name,
      @JsonKey(name: 'template_description') final String? templateDescription,
      @JsonKey(name: 'visibility_level') required final String visibilityLevel,
      required final String permission,
      @JsonKey(name: 'company_id') required final String companyId,
      @JsonKey(name: 'store_id') final String? storeId,
      @JsonKey(name: 'is_active') final bool isActive,
      @JsonKey(name: 'required_attachment') final bool requiredAttachment,
      @JsonKey(name: 'created_at') required final String createdAt,
      @JsonKey(name: 'updated_at') required final String updatedAt,
      @JsonKey(name: 'created_by') final String? createdBy,
      @JsonKey(name: 'updated_by')
      final String? updatedBy}) = _$UpsertTemplateDataDtoImpl;

  factory _UpsertTemplateDataDto.fromJson(Map<String, dynamic> json) =
      _$UpsertTemplateDataDtoImpl.fromJson;

  /// Unique template identifier
  @override
  @JsonKey(name: 'template_id')
  String get templateId;

  /// Template display name
  @override
  String get name;

  /// Optional description
  @override
  @JsonKey(name: 'template_description')
  String? get templateDescription;

  /// Template visibility level
  @override
  @JsonKey(name: 'visibility_level')
  String get visibilityLevel;

  /// Template permission level
  @override
  String get permission;

  /// Company identifier
  @override
  @JsonKey(name: 'company_id')
  String get companyId;

  /// Store identifier (nullable)
  @override
  @JsonKey(name: 'store_id')
  String? get storeId;

  /// Active status flag
  @override
  @JsonKey(name: 'is_active')
  bool get isActive;

  /// Whether attachment is required
  @override
  @JsonKey(name: 'required_attachment')
  bool get requiredAttachment;

  /// Creation timestamp (local time)
  @override
  @JsonKey(name: 'created_at')
  String get createdAt;

  /// Last update timestamp (local time)
  @override
  @JsonKey(name: 'updated_at')
  String get updatedAt;

  /// Template creator
  @override
  @JsonKey(name: 'created_by')
  String? get createdBy;

  /// Last updater
  @override
  @JsonKey(name: 'updated_by')
  String? get updatedBy;

  /// Create a copy of UpsertTemplateDataDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UpsertTemplateDataDtoImplCopyWith<_$UpsertTemplateDataDtoImpl>
      get copyWith => throw _privateConstructorUsedError;
}
