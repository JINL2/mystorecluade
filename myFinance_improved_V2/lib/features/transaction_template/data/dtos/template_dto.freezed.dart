// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'template_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

TemplateDto _$TemplateDtoFromJson(Map<String, dynamic> json) {
  return _TemplateDto.fromJson(json);
}

/// @nodoc
mixin _$TemplateDto {
  /// Unique template identifier (DB: template_id)
  @JsonKey(name: 'template_id')
  String get templateId => throw _privateConstructorUsedError;

  /// Template display name (DB: name)
  String get name => throw _privateConstructorUsedError;

  /// Optional description (DB: template_description)
  @JsonKey(name: 'template_description')
  String? get templateDescription => throw _privateConstructorUsedError;

  /// 🚨 CRITICAL: JSONB transaction data array (DB: data)
  /// Each line: {account_id, debit, credit, description, cash?, debt?, fix_asset?}
  List<Map<String, dynamic>> get data => throw _privateConstructorUsedError;

  /// Template categorization tags (DB: tags)
  Map<String, dynamic> get tags => throw _privateConstructorUsedError;

  /// Template visibility level (DB: visibility_level)
  @JsonKey(name: 'visibility_level')
  String get visibilityLevel => throw _privateConstructorUsedError;

  /// Template permission level (DB: permission)
  String get permission => throw _privateConstructorUsedError;

  /// Company identifier (DB: company_id)
  @JsonKey(name: 'company_id')
  String get companyId => throw _privateConstructorUsedError;

  /// Store identifier - can be null in DB (DB: store_id)
  @JsonKey(name: 'store_id')
  String? get storeId => throw _privateConstructorUsedError;

  /// Single counterparty ID for template (DB: counterparty_id)
  @JsonKey(name: 'counterparty_id')
  String? get counterpartyId => throw _privateConstructorUsedError;

  /// Counterparty cash location for internal transactions (DB: counterparty_cash_location_id)
  @JsonKey(name: 'counterparty_cash_location_id')
  String? get counterpartyCashLocationId => throw _privateConstructorUsedError;

  /// Template creator (DB: created_by) - nullable because DB may not have this field
  @JsonKey(name: 'created_by')
  String? get createdBy => throw _privateConstructorUsedError;

  /// Creation timestamp as ISO string (DB: created_at)
  @JsonKey(name: 'created_at')
  String get createdAt => throw _privateConstructorUsedError;

  /// Last update timestamp as ISO string (DB: updated_at)
  @JsonKey(name: 'updated_at')
  String get updatedAt => throw _privateConstructorUsedError;

  /// Last updater (DB: updated_by)
  @JsonKey(name: 'updated_by')
  String? get updatedBy => throw _privateConstructorUsedError;

  /// Active status flag (DB: is_active)
  @JsonKey(name: 'is_active')
  bool get isActive => throw _privateConstructorUsedError;

  /// Whether attachment is required when using this template (DB: required_attachment)
  @JsonKey(name: 'required_attachment')
  bool get requiredAttachment => throw _privateConstructorUsedError;

  /// Serializes this TemplateDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of TemplateDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TemplateDtoCopyWith<TemplateDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TemplateDtoCopyWith<$Res> {
  factory $TemplateDtoCopyWith(
          TemplateDto value, $Res Function(TemplateDto) then) =
      _$TemplateDtoCopyWithImpl<$Res, TemplateDto>;
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
class _$TemplateDtoCopyWithImpl<$Res, $Val extends TemplateDto>
    implements $TemplateDtoCopyWith<$Res> {
  _$TemplateDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TemplateDto
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
abstract class _$$TemplateDtoImplCopyWith<$Res>
    implements $TemplateDtoCopyWith<$Res> {
  factory _$$TemplateDtoImplCopyWith(
          _$TemplateDtoImpl value, $Res Function(_$TemplateDtoImpl) then) =
      __$$TemplateDtoImplCopyWithImpl<$Res>;
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
class __$$TemplateDtoImplCopyWithImpl<$Res>
    extends _$TemplateDtoCopyWithImpl<$Res, _$TemplateDtoImpl>
    implements _$$TemplateDtoImplCopyWith<$Res> {
  __$$TemplateDtoImplCopyWithImpl(
      _$TemplateDtoImpl _value, $Res Function(_$TemplateDtoImpl) _then)
      : super(_value, _then);

  /// Create a copy of TemplateDto
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
    return _then(_$TemplateDtoImpl(
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
class _$TemplateDtoImpl implements _TemplateDto {
  const _$TemplateDtoImpl(
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

  factory _$TemplateDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$TemplateDtoImplFromJson(json);

  /// Unique template identifier (DB: template_id)
  @override
  @JsonKey(name: 'template_id')
  final String templateId;

  /// Template display name (DB: name)
  @override
  final String name;

  /// Optional description (DB: template_description)
  @override
  @JsonKey(name: 'template_description')
  final String? templateDescription;

  /// 🚨 CRITICAL: JSONB transaction data array (DB: data)
  /// Each line: {account_id, debit, credit, description, cash?, debt?, fix_asset?}
  final List<Map<String, dynamic>> _data;

  /// 🚨 CRITICAL: JSONB transaction data array (DB: data)
  /// Each line: {account_id, debit, credit, description, cash?, debt?, fix_asset?}
  @override
  @JsonKey()
  List<Map<String, dynamic>> get data {
    if (_data is EqualUnmodifiableListView) return _data;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_data);
  }

  /// Template categorization tags (DB: tags)
  final Map<String, dynamic> _tags;

  /// Template categorization tags (DB: tags)
  @override
  @JsonKey()
  Map<String, dynamic> get tags {
    if (_tags is EqualUnmodifiableMapView) return _tags;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_tags);
  }

  /// Template visibility level (DB: visibility_level)
  @override
  @JsonKey(name: 'visibility_level')
  final String visibilityLevel;

  /// Template permission level (DB: permission)
  @override
  final String permission;

  /// Company identifier (DB: company_id)
  @override
  @JsonKey(name: 'company_id')
  final String companyId;

  /// Store identifier - can be null in DB (DB: store_id)
  @override
  @JsonKey(name: 'store_id')
  final String? storeId;

  /// Single counterparty ID for template (DB: counterparty_id)
  @override
  @JsonKey(name: 'counterparty_id')
  final String? counterpartyId;

  /// Counterparty cash location for internal transactions (DB: counterparty_cash_location_id)
  @override
  @JsonKey(name: 'counterparty_cash_location_id')
  final String? counterpartyCashLocationId;

  /// Template creator (DB: created_by) - nullable because DB may not have this field
  @override
  @JsonKey(name: 'created_by')
  final String? createdBy;

  /// Creation timestamp as ISO string (DB: created_at)
  @override
  @JsonKey(name: 'created_at')
  final String createdAt;

  /// Last update timestamp as ISO string (DB: updated_at)
  @override
  @JsonKey(name: 'updated_at')
  final String updatedAt;

  /// Last updater (DB: updated_by)
  @override
  @JsonKey(name: 'updated_by')
  final String? updatedBy;

  /// Active status flag (DB: is_active)
  @override
  @JsonKey(name: 'is_active')
  final bool isActive;

  /// Whether attachment is required when using this template (DB: required_attachment)
  @override
  @JsonKey(name: 'required_attachment')
  final bool requiredAttachment;

  @override
  String toString() {
    return 'TemplateDto(templateId: $templateId, name: $name, templateDescription: $templateDescription, data: $data, tags: $tags, visibilityLevel: $visibilityLevel, permission: $permission, companyId: $companyId, storeId: $storeId, counterpartyId: $counterpartyId, counterpartyCashLocationId: $counterpartyCashLocationId, createdBy: $createdBy, createdAt: $createdAt, updatedAt: $updatedAt, updatedBy: $updatedBy, isActive: $isActive, requiredAttachment: $requiredAttachment)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TemplateDtoImpl &&
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

  /// Create a copy of TemplateDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TemplateDtoImplCopyWith<_$TemplateDtoImpl> get copyWith =>
      __$$TemplateDtoImplCopyWithImpl<_$TemplateDtoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TemplateDtoImplToJson(
      this,
    );
  }
}

abstract class _TemplateDto implements TemplateDto {
  const factory _TemplateDto(
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
      final bool requiredAttachment}) = _$TemplateDtoImpl;

  factory _TemplateDto.fromJson(Map<String, dynamic> json) =
      _$TemplateDtoImpl.fromJson;

  /// Unique template identifier (DB: template_id)
  @override
  @JsonKey(name: 'template_id')
  String get templateId;

  /// Template display name (DB: name)
  @override
  String get name;

  /// Optional description (DB: template_description)
  @override
  @JsonKey(name: 'template_description')
  String? get templateDescription;

  /// 🚨 CRITICAL: JSONB transaction data array (DB: data)
  /// Each line: {account_id, debit, credit, description, cash?, debt?, fix_asset?}
  @override
  List<Map<String, dynamic>> get data;

  /// Template categorization tags (DB: tags)
  @override
  Map<String, dynamic> get tags;

  /// Template visibility level (DB: visibility_level)
  @override
  @JsonKey(name: 'visibility_level')
  String get visibilityLevel;

  /// Template permission level (DB: permission)
  @override
  String get permission;

  /// Company identifier (DB: company_id)
  @override
  @JsonKey(name: 'company_id')
  String get companyId;

  /// Store identifier - can be null in DB (DB: store_id)
  @override
  @JsonKey(name: 'store_id')
  String? get storeId;

  /// Single counterparty ID for template (DB: counterparty_id)
  @override
  @JsonKey(name: 'counterparty_id')
  String? get counterpartyId;

  /// Counterparty cash location for internal transactions (DB: counterparty_cash_location_id)
  @override
  @JsonKey(name: 'counterparty_cash_location_id')
  String? get counterpartyCashLocationId;

  /// Template creator (DB: created_by) - nullable because DB may not have this field
  @override
  @JsonKey(name: 'created_by')
  String? get createdBy;

  /// Creation timestamp as ISO string (DB: created_at)
  @override
  @JsonKey(name: 'created_at')
  String get createdAt;

  /// Last update timestamp as ISO string (DB: updated_at)
  @override
  @JsonKey(name: 'updated_at')
  String get updatedAt;

  /// Last updater (DB: updated_by)
  @override
  @JsonKey(name: 'updated_by')
  String? get updatedBy;

  /// Active status flag (DB: is_active)
  @override
  @JsonKey(name: 'is_active')
  bool get isActive;

  /// Whether attachment is required when using this template (DB: required_attachment)
  @override
  @JsonKey(name: 'required_attachment')
  bool get requiredAttachment;

  /// Create a copy of TemplateDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TemplateDtoImplCopyWith<_$TemplateDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
