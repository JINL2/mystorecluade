// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'template_list_response_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

TemplateListResponseDto _$TemplateListResponseDtoFromJson(
    Map<String, dynamic> json) {
  return _TemplateListResponseDto.fromJson(json);
}

/// @nodoc
mixin _$TemplateListResponseDto {
  /// Whether the RPC call was successful
  bool get success => throw _privateConstructorUsedError;

  /// Response data containing templates and pagination
  TemplateListDataDto? get data => throw _privateConstructorUsedError;

  /// Error message if failed
  String? get error => throw _privateConstructorUsedError;

  /// Serializes this TemplateListResponseDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of TemplateListResponseDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TemplateListResponseDtoCopyWith<TemplateListResponseDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TemplateListResponseDtoCopyWith<$Res> {
  factory $TemplateListResponseDtoCopyWith(TemplateListResponseDto value,
          $Res Function(TemplateListResponseDto) then) =
      _$TemplateListResponseDtoCopyWithImpl<$Res, TemplateListResponseDto>;
  @useResult
  $Res call({bool success, TemplateListDataDto? data, String? error});

  $TemplateListDataDtoCopyWith<$Res>? get data;
}

/// @nodoc
class _$TemplateListResponseDtoCopyWithImpl<$Res,
        $Val extends TemplateListResponseDto>
    implements $TemplateListResponseDtoCopyWith<$Res> {
  _$TemplateListResponseDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TemplateListResponseDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? success = null,
    Object? data = freezed,
    Object? error = freezed,
  }) {
    return _then(_value.copyWith(
      success: null == success
          ? _value.success
          : success // ignore: cast_nullable_to_non_nullable
              as bool,
      data: freezed == data
          ? _value.data
          : data // ignore: cast_nullable_to_non_nullable
              as TemplateListDataDto?,
      error: freezed == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }

  /// Create a copy of TemplateListResponseDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $TemplateListDataDtoCopyWith<$Res>? get data {
    if (_value.data == null) {
      return null;
    }

    return $TemplateListDataDtoCopyWith<$Res>(_value.data!, (value) {
      return _then(_value.copyWith(data: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$TemplateListResponseDtoImplCopyWith<$Res>
    implements $TemplateListResponseDtoCopyWith<$Res> {
  factory _$$TemplateListResponseDtoImplCopyWith(
          _$TemplateListResponseDtoImpl value,
          $Res Function(_$TemplateListResponseDtoImpl) then) =
      __$$TemplateListResponseDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({bool success, TemplateListDataDto? data, String? error});

  @override
  $TemplateListDataDtoCopyWith<$Res>? get data;
}

/// @nodoc
class __$$TemplateListResponseDtoImplCopyWithImpl<$Res>
    extends _$TemplateListResponseDtoCopyWithImpl<$Res,
        _$TemplateListResponseDtoImpl>
    implements _$$TemplateListResponseDtoImplCopyWith<$Res> {
  __$$TemplateListResponseDtoImplCopyWithImpl(
      _$TemplateListResponseDtoImpl _value,
      $Res Function(_$TemplateListResponseDtoImpl) _then)
      : super(_value, _then);

  /// Create a copy of TemplateListResponseDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? success = null,
    Object? data = freezed,
    Object? error = freezed,
  }) {
    return _then(_$TemplateListResponseDtoImpl(
      success: null == success
          ? _value.success
          : success // ignore: cast_nullable_to_non_nullable
              as bool,
      data: freezed == data
          ? _value.data
          : data // ignore: cast_nullable_to_non_nullable
              as TemplateListDataDto?,
      error: freezed == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$TemplateListResponseDtoImpl implements _TemplateListResponseDto {
  const _$TemplateListResponseDtoImpl(
      {required this.success, this.data, this.error});

  factory _$TemplateListResponseDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$TemplateListResponseDtoImplFromJson(json);

  /// Whether the RPC call was successful
  @override
  final bool success;

  /// Response data containing templates and pagination
  @override
  final TemplateListDataDto? data;

  /// Error message if failed
  @override
  final String? error;

  @override
  String toString() {
    return 'TemplateListResponseDto(success: $success, data: $data, error: $error)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TemplateListResponseDtoImpl &&
            (identical(other.success, success) || other.success == success) &&
            (identical(other.data, data) || other.data == data) &&
            (identical(other.error, error) || other.error == error));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, success, data, error);

  /// Create a copy of TemplateListResponseDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TemplateListResponseDtoImplCopyWith<_$TemplateListResponseDtoImpl>
      get copyWith => __$$TemplateListResponseDtoImplCopyWithImpl<
          _$TemplateListResponseDtoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TemplateListResponseDtoImplToJson(
      this,
    );
  }
}

abstract class _TemplateListResponseDto implements TemplateListResponseDto {
  const factory _TemplateListResponseDto(
      {required final bool success,
      final TemplateListDataDto? data,
      final String? error}) = _$TemplateListResponseDtoImpl;

  factory _TemplateListResponseDto.fromJson(Map<String, dynamic> json) =
      _$TemplateListResponseDtoImpl.fromJson;

  /// Whether the RPC call was successful
  @override
  bool get success;

  /// Response data containing templates and pagination
  @override
  TemplateListDataDto? get data;

  /// Error message if failed
  @override
  String? get error;

  /// Create a copy of TemplateListResponseDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TemplateListResponseDtoImplCopyWith<_$TemplateListResponseDtoImpl>
      get copyWith => throw _privateConstructorUsedError;
}

TemplateListDataDto _$TemplateListDataDtoFromJson(Map<String, dynamic> json) {
  return _TemplateListDataDto.fromJson(json);
}

/// @nodoc
mixin _$TemplateListDataDto {
  /// List of templates
  List<TemplateListItemDto> get templates => throw _privateConstructorUsedError;

  /// Total count of matching templates (for pagination)
  @JsonKey(name: 'total_count')
  int get totalCount => throw _privateConstructorUsedError;

  /// Whether there are more templates to load
  @JsonKey(name: 'has_more')
  bool get hasMore => throw _privateConstructorUsedError;

  /// Serializes this TemplateListDataDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of TemplateListDataDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TemplateListDataDtoCopyWith<TemplateListDataDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TemplateListDataDtoCopyWith<$Res> {
  factory $TemplateListDataDtoCopyWith(
          TemplateListDataDto value, $Res Function(TemplateListDataDto) then) =
      _$TemplateListDataDtoCopyWithImpl<$Res, TemplateListDataDto>;
  @useResult
  $Res call(
      {List<TemplateListItemDto> templates,
      @JsonKey(name: 'total_count') int totalCount,
      @JsonKey(name: 'has_more') bool hasMore});
}

/// @nodoc
class _$TemplateListDataDtoCopyWithImpl<$Res, $Val extends TemplateListDataDto>
    implements $TemplateListDataDtoCopyWith<$Res> {
  _$TemplateListDataDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TemplateListDataDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? templates = null,
    Object? totalCount = null,
    Object? hasMore = null,
  }) {
    return _then(_value.copyWith(
      templates: null == templates
          ? _value.templates
          : templates // ignore: cast_nullable_to_non_nullable
              as List<TemplateListItemDto>,
      totalCount: null == totalCount
          ? _value.totalCount
          : totalCount // ignore: cast_nullable_to_non_nullable
              as int,
      hasMore: null == hasMore
          ? _value.hasMore
          : hasMore // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$TemplateListDataDtoImplCopyWith<$Res>
    implements $TemplateListDataDtoCopyWith<$Res> {
  factory _$$TemplateListDataDtoImplCopyWith(_$TemplateListDataDtoImpl value,
          $Res Function(_$TemplateListDataDtoImpl) then) =
      __$$TemplateListDataDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {List<TemplateListItemDto> templates,
      @JsonKey(name: 'total_count') int totalCount,
      @JsonKey(name: 'has_more') bool hasMore});
}

/// @nodoc
class __$$TemplateListDataDtoImplCopyWithImpl<$Res>
    extends _$TemplateListDataDtoCopyWithImpl<$Res, _$TemplateListDataDtoImpl>
    implements _$$TemplateListDataDtoImplCopyWith<$Res> {
  __$$TemplateListDataDtoImplCopyWithImpl(_$TemplateListDataDtoImpl _value,
      $Res Function(_$TemplateListDataDtoImpl) _then)
      : super(_value, _then);

  /// Create a copy of TemplateListDataDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? templates = null,
    Object? totalCount = null,
    Object? hasMore = null,
  }) {
    return _then(_$TemplateListDataDtoImpl(
      templates: null == templates
          ? _value._templates
          : templates // ignore: cast_nullable_to_non_nullable
              as List<TemplateListItemDto>,
      totalCount: null == totalCount
          ? _value.totalCount
          : totalCount // ignore: cast_nullable_to_non_nullable
              as int,
      hasMore: null == hasMore
          ? _value.hasMore
          : hasMore // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$TemplateListDataDtoImpl implements _TemplateListDataDto {
  const _$TemplateListDataDtoImpl(
      {final List<TemplateListItemDto> templates = const [],
      @JsonKey(name: 'total_count') this.totalCount = 0,
      @JsonKey(name: 'has_more') this.hasMore = false})
      : _templates = templates;

  factory _$TemplateListDataDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$TemplateListDataDtoImplFromJson(json);

  /// List of templates
  final List<TemplateListItemDto> _templates;

  /// List of templates
  @override
  @JsonKey()
  List<TemplateListItemDto> get templates {
    if (_templates is EqualUnmodifiableListView) return _templates;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_templates);
  }

  /// Total count of matching templates (for pagination)
  @override
  @JsonKey(name: 'total_count')
  final int totalCount;

  /// Whether there are more templates to load
  @override
  @JsonKey(name: 'has_more')
  final bool hasMore;

  @override
  String toString() {
    return 'TemplateListDataDto(templates: $templates, totalCount: $totalCount, hasMore: $hasMore)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TemplateListDataDtoImpl &&
            const DeepCollectionEquality()
                .equals(other._templates, _templates) &&
            (identical(other.totalCount, totalCount) ||
                other.totalCount == totalCount) &&
            (identical(other.hasMore, hasMore) || other.hasMore == hasMore));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType,
      const DeepCollectionEquality().hash(_templates), totalCount, hasMore);

  /// Create a copy of TemplateListDataDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TemplateListDataDtoImplCopyWith<_$TemplateListDataDtoImpl> get copyWith =>
      __$$TemplateListDataDtoImplCopyWithImpl<_$TemplateListDataDtoImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TemplateListDataDtoImplToJson(
      this,
    );
  }
}

abstract class _TemplateListDataDto implements TemplateListDataDto {
  const factory _TemplateListDataDto(
          {final List<TemplateListItemDto> templates,
          @JsonKey(name: 'total_count') final int totalCount,
          @JsonKey(name: 'has_more') final bool hasMore}) =
      _$TemplateListDataDtoImpl;

  factory _TemplateListDataDto.fromJson(Map<String, dynamic> json) =
      _$TemplateListDataDtoImpl.fromJson;

  /// List of templates
  @override
  List<TemplateListItemDto> get templates;

  /// Total count of matching templates (for pagination)
  @override
  @JsonKey(name: 'total_count')
  int get totalCount;

  /// Whether there are more templates to load
  @override
  @JsonKey(name: 'has_more')
  bool get hasMore;

  /// Create a copy of TemplateListDataDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TemplateListDataDtoImplCopyWith<_$TemplateListDataDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

TemplateListItemDto _$TemplateListItemDtoFromJson(Map<String, dynamic> json) {
  return _TemplateListItemDto.fromJson(json);
}

/// @nodoc
mixin _$TemplateListItemDto {
  /// Unique template identifier
  @JsonKey(name: 'template_id')
  String get templateId => throw _privateConstructorUsedError;

  /// Template display name
  String get name => throw _privateConstructorUsedError;

  /// Optional description
  @JsonKey(name: 'template_description')
  String? get templateDescription => throw _privateConstructorUsedError;

  /// JSONB transaction data array
  List<Map<String, dynamic>> get data => throw _privateConstructorUsedError;

  /// Template categorization tags
  Map<String, dynamic> get tags => throw _privateConstructorUsedError;

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

  /// Counterparty ID
  @JsonKey(name: 'counterparty_id')
  String? get counterpartyId => throw _privateConstructorUsedError;

  /// Counterparty cash location ID
  @JsonKey(name: 'counterparty_cash_location_id')
  String? get counterpartyCashLocationId => throw _privateConstructorUsedError;

  /// Template creator
  @JsonKey(name: 'created_by')
  String? get createdBy => throw _privateConstructorUsedError;

  /// Creation timestamp (local time converted from UTC)
  @JsonKey(name: 'created_at')
  String get createdAt => throw _privateConstructorUsedError;

  /// Last update timestamp (local time converted from UTC)
  @JsonKey(name: 'updated_at')
  String get updatedAt => throw _privateConstructorUsedError;

  /// Last updater
  @JsonKey(name: 'updated_by')
  String? get updatedBy => throw _privateConstructorUsedError;

  /// Active status flag
  @JsonKey(name: 'is_active')
  bool get isActive => throw _privateConstructorUsedError;

  /// Whether attachment is required
  @JsonKey(name: 'required_attachment')
  bool get requiredAttachment => throw _privateConstructorUsedError;

  /// Serializes this TemplateListItemDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of TemplateListItemDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TemplateListItemDtoCopyWith<TemplateListItemDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TemplateListItemDtoCopyWith<$Res> {
  factory $TemplateListItemDtoCopyWith(
          TemplateListItemDto value, $Res Function(TemplateListItemDto) then) =
      _$TemplateListItemDtoCopyWithImpl<$Res, TemplateListItemDto>;
  @useResult
  $Res call(
      {@JsonKey(name: 'template_id') String templateId,
      String name,
      @JsonKey(name: 'template_description') String? templateDescription,
      List<Map<String, dynamic>> data,
      Map<String, dynamic> tags,
      @JsonKey(name: 'visibility_level') String visibilityLevel,
      String permission,
      @JsonKey(name: 'company_id') String companyId,
      @JsonKey(name: 'store_id') String? storeId,
      @JsonKey(name: 'counterparty_id') String? counterpartyId,
      @JsonKey(name: 'counterparty_cash_location_id')
      String? counterpartyCashLocationId,
      @JsonKey(name: 'created_by') String? createdBy,
      @JsonKey(name: 'created_at') String createdAt,
      @JsonKey(name: 'updated_at') String updatedAt,
      @JsonKey(name: 'updated_by') String? updatedBy,
      @JsonKey(name: 'is_active') bool isActive,
      @JsonKey(name: 'required_attachment') bool requiredAttachment});
}

/// @nodoc
class _$TemplateListItemDtoCopyWithImpl<$Res, $Val extends TemplateListItemDto>
    implements $TemplateListItemDtoCopyWith<$Res> {
  _$TemplateListItemDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TemplateListItemDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? templateId = null,
    Object? name = null,
    Object? templateDescription = freezed,
    Object? data = null,
    Object? tags = null,
    Object? visibilityLevel = null,
    Object? permission = null,
    Object? companyId = null,
    Object? storeId = freezed,
    Object? counterpartyId = freezed,
    Object? counterpartyCashLocationId = freezed,
    Object? createdBy = freezed,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? updatedBy = freezed,
    Object? isActive = null,
    Object? requiredAttachment = null,
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
      data: null == data
          ? _value.data
          : data // ignore: cast_nullable_to_non_nullable
              as List<Map<String, dynamic>>,
      tags: null == tags
          ? _value.tags
          : tags // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
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
      counterpartyId: freezed == counterpartyId
          ? _value.counterpartyId
          : counterpartyId // ignore: cast_nullable_to_non_nullable
              as String?,
      counterpartyCashLocationId: freezed == counterpartyCashLocationId
          ? _value.counterpartyCashLocationId
          : counterpartyCashLocationId // ignore: cast_nullable_to_non_nullable
              as String?,
      createdBy: freezed == createdBy
          ? _value.createdBy
          : createdBy // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as String,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as String,
      updatedBy: freezed == updatedBy
          ? _value.updatedBy
          : updatedBy // ignore: cast_nullable_to_non_nullable
              as String?,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
      requiredAttachment: null == requiredAttachment
          ? _value.requiredAttachment
          : requiredAttachment // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$TemplateListItemDtoImplCopyWith<$Res>
    implements $TemplateListItemDtoCopyWith<$Res> {
  factory _$$TemplateListItemDtoImplCopyWith(_$TemplateListItemDtoImpl value,
          $Res Function(_$TemplateListItemDtoImpl) then) =
      __$$TemplateListItemDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'template_id') String templateId,
      String name,
      @JsonKey(name: 'template_description') String? templateDescription,
      List<Map<String, dynamic>> data,
      Map<String, dynamic> tags,
      @JsonKey(name: 'visibility_level') String visibilityLevel,
      String permission,
      @JsonKey(name: 'company_id') String companyId,
      @JsonKey(name: 'store_id') String? storeId,
      @JsonKey(name: 'counterparty_id') String? counterpartyId,
      @JsonKey(name: 'counterparty_cash_location_id')
      String? counterpartyCashLocationId,
      @JsonKey(name: 'created_by') String? createdBy,
      @JsonKey(name: 'created_at') String createdAt,
      @JsonKey(name: 'updated_at') String updatedAt,
      @JsonKey(name: 'updated_by') String? updatedBy,
      @JsonKey(name: 'is_active') bool isActive,
      @JsonKey(name: 'required_attachment') bool requiredAttachment});
}

/// @nodoc
class __$$TemplateListItemDtoImplCopyWithImpl<$Res>
    extends _$TemplateListItemDtoCopyWithImpl<$Res, _$TemplateListItemDtoImpl>
    implements _$$TemplateListItemDtoImplCopyWith<$Res> {
  __$$TemplateListItemDtoImplCopyWithImpl(_$TemplateListItemDtoImpl _value,
      $Res Function(_$TemplateListItemDtoImpl) _then)
      : super(_value, _then);

  /// Create a copy of TemplateListItemDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? templateId = null,
    Object? name = null,
    Object? templateDescription = freezed,
    Object? data = null,
    Object? tags = null,
    Object? visibilityLevel = null,
    Object? permission = null,
    Object? companyId = null,
    Object? storeId = freezed,
    Object? counterpartyId = freezed,
    Object? counterpartyCashLocationId = freezed,
    Object? createdBy = freezed,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? updatedBy = freezed,
    Object? isActive = null,
    Object? requiredAttachment = null,
  }) {
    return _then(_$TemplateListItemDtoImpl(
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
      data: null == data
          ? _value._data
          : data // ignore: cast_nullable_to_non_nullable
              as List<Map<String, dynamic>>,
      tags: null == tags
          ? _value._tags
          : tags // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
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
      counterpartyId: freezed == counterpartyId
          ? _value.counterpartyId
          : counterpartyId // ignore: cast_nullable_to_non_nullable
              as String?,
      counterpartyCashLocationId: freezed == counterpartyCashLocationId
          ? _value.counterpartyCashLocationId
          : counterpartyCashLocationId // ignore: cast_nullable_to_non_nullable
              as String?,
      createdBy: freezed == createdBy
          ? _value.createdBy
          : createdBy // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as String,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as String,
      updatedBy: freezed == updatedBy
          ? _value.updatedBy
          : updatedBy // ignore: cast_nullable_to_non_nullable
              as String?,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
      requiredAttachment: null == requiredAttachment
          ? _value.requiredAttachment
          : requiredAttachment // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$TemplateListItemDtoImpl implements _TemplateListItemDto {
  const _$TemplateListItemDtoImpl(
      {@JsonKey(name: 'template_id') required this.templateId,
      required this.name,
      @JsonKey(name: 'template_description') this.templateDescription,
      final List<Map<String, dynamic>> data = const [],
      final Map<String, dynamic> tags = const {},
      @JsonKey(name: 'visibility_level') required this.visibilityLevel,
      required this.permission,
      @JsonKey(name: 'company_id') required this.companyId,
      @JsonKey(name: 'store_id') this.storeId,
      @JsonKey(name: 'counterparty_id') this.counterpartyId,
      @JsonKey(name: 'counterparty_cash_location_id')
      this.counterpartyCashLocationId,
      @JsonKey(name: 'created_by') this.createdBy,
      @JsonKey(name: 'created_at') required this.createdAt,
      @JsonKey(name: 'updated_at') required this.updatedAt,
      @JsonKey(name: 'updated_by') this.updatedBy,
      @JsonKey(name: 'is_active') this.isActive = true,
      @JsonKey(name: 'required_attachment') this.requiredAttachment = false})
      : _data = data,
        _tags = tags;

  factory _$TemplateListItemDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$TemplateListItemDtoImplFromJson(json);

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

  /// JSONB transaction data array
  final List<Map<String, dynamic>> _data;

  /// JSONB transaction data array
  @override
  @JsonKey()
  List<Map<String, dynamic>> get data {
    if (_data is EqualUnmodifiableListView) return _data;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_data);
  }

  /// Template categorization tags
  final Map<String, dynamic> _tags;

  /// Template categorization tags
  @override
  @JsonKey()
  Map<String, dynamic> get tags {
    if (_tags is EqualUnmodifiableMapView) return _tags;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_tags);
  }

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

  /// Counterparty ID
  @override
  @JsonKey(name: 'counterparty_id')
  final String? counterpartyId;

  /// Counterparty cash location ID
  @override
  @JsonKey(name: 'counterparty_cash_location_id')
  final String? counterpartyCashLocationId;

  /// Template creator
  @override
  @JsonKey(name: 'created_by')
  final String? createdBy;

  /// Creation timestamp (local time converted from UTC)
  @override
  @JsonKey(name: 'created_at')
  final String createdAt;

  /// Last update timestamp (local time converted from UTC)
  @override
  @JsonKey(name: 'updated_at')
  final String updatedAt;

  /// Last updater
  @override
  @JsonKey(name: 'updated_by')
  final String? updatedBy;

  /// Active status flag
  @override
  @JsonKey(name: 'is_active')
  final bool isActive;

  /// Whether attachment is required
  @override
  @JsonKey(name: 'required_attachment')
  final bool requiredAttachment;

  @override
  String toString() {
    return 'TemplateListItemDto(templateId: $templateId, name: $name, templateDescription: $templateDescription, data: $data, tags: $tags, visibilityLevel: $visibilityLevel, permission: $permission, companyId: $companyId, storeId: $storeId, counterpartyId: $counterpartyId, counterpartyCashLocationId: $counterpartyCashLocationId, createdBy: $createdBy, createdAt: $createdAt, updatedAt: $updatedAt, updatedBy: $updatedBy, isActive: $isActive, requiredAttachment: $requiredAttachment)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TemplateListItemDtoImpl &&
            (identical(other.templateId, templateId) ||
                other.templateId == templateId) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.templateDescription, templateDescription) ||
                other.templateDescription == templateDescription) &&
            const DeepCollectionEquality().equals(other._data, _data) &&
            const DeepCollectionEquality().equals(other._tags, _tags) &&
            (identical(other.visibilityLevel, visibilityLevel) ||
                other.visibilityLevel == visibilityLevel) &&
            (identical(other.permission, permission) ||
                other.permission == permission) &&
            (identical(other.companyId, companyId) ||
                other.companyId == companyId) &&
            (identical(other.storeId, storeId) || other.storeId == storeId) &&
            (identical(other.counterpartyId, counterpartyId) ||
                other.counterpartyId == counterpartyId) &&
            (identical(other.counterpartyCashLocationId,
                    counterpartyCashLocationId) ||
                other.counterpartyCashLocationId ==
                    counterpartyCashLocationId) &&
            (identical(other.createdBy, createdBy) ||
                other.createdBy == createdBy) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.updatedBy, updatedBy) ||
                other.updatedBy == updatedBy) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive) &&
            (identical(other.requiredAttachment, requiredAttachment) ||
                other.requiredAttachment == requiredAttachment));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      templateId,
      name,
      templateDescription,
      const DeepCollectionEquality().hash(_data),
      const DeepCollectionEquality().hash(_tags),
      visibilityLevel,
      permission,
      companyId,
      storeId,
      counterpartyId,
      counterpartyCashLocationId,
      createdBy,
      createdAt,
      updatedAt,
      updatedBy,
      isActive,
      requiredAttachment);

  /// Create a copy of TemplateListItemDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TemplateListItemDtoImplCopyWith<_$TemplateListItemDtoImpl> get copyWith =>
      __$$TemplateListItemDtoImplCopyWithImpl<_$TemplateListItemDtoImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TemplateListItemDtoImplToJson(
      this,
    );
  }
}

abstract class _TemplateListItemDto implements TemplateListItemDto {
  const factory _TemplateListItemDto(
      {@JsonKey(name: 'template_id') required final String templateId,
      required final String name,
      @JsonKey(name: 'template_description') final String? templateDescription,
      final List<Map<String, dynamic>> data,
      final Map<String, dynamic> tags,
      @JsonKey(name: 'visibility_level') required final String visibilityLevel,
      required final String permission,
      @JsonKey(name: 'company_id') required final String companyId,
      @JsonKey(name: 'store_id') final String? storeId,
      @JsonKey(name: 'counterparty_id') final String? counterpartyId,
      @JsonKey(name: 'counterparty_cash_location_id')
      final String? counterpartyCashLocationId,
      @JsonKey(name: 'created_by') final String? createdBy,
      @JsonKey(name: 'created_at') required final String createdAt,
      @JsonKey(name: 'updated_at') required final String updatedAt,
      @JsonKey(name: 'updated_by') final String? updatedBy,
      @JsonKey(name: 'is_active') final bool isActive,
      @JsonKey(name: 'required_attachment')
      final bool requiredAttachment}) = _$TemplateListItemDtoImpl;

  factory _TemplateListItemDto.fromJson(Map<String, dynamic> json) =
      _$TemplateListItemDtoImpl.fromJson;

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

  /// JSONB transaction data array
  @override
  List<Map<String, dynamic>> get data;

  /// Template categorization tags
  @override
  Map<String, dynamic> get tags;

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

  /// Counterparty ID
  @override
  @JsonKey(name: 'counterparty_id')
  String? get counterpartyId;

  /// Counterparty cash location ID
  @override
  @JsonKey(name: 'counterparty_cash_location_id')
  String? get counterpartyCashLocationId;

  /// Template creator
  @override
  @JsonKey(name: 'created_by')
  String? get createdBy;

  /// Creation timestamp (local time converted from UTC)
  @override
  @JsonKey(name: 'created_at')
  String get createdAt;

  /// Last update timestamp (local time converted from UTC)
  @override
  @JsonKey(name: 'updated_at')
  String get updatedAt;

  /// Last updater
  @override
  @JsonKey(name: 'updated_by')
  String? get updatedBy;

  /// Active status flag
  @override
  @JsonKey(name: 'is_active')
  bool get isActive;

  /// Whether attachment is required
  @override
  @JsonKey(name: 'required_attachment')
  bool get requiredAttachment;

  /// Create a copy of TemplateListItemDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TemplateListItemDtoImplCopyWith<_$TemplateListItemDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
