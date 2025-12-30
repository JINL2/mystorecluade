// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'template_usage_response_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

TemplateUsageResponseDto _$TemplateUsageResponseDtoFromJson(
    Map<String, dynamic> json) {
  return _TemplateUsageResponseDto.fromJson(json);
}

/// @nodoc
mixin _$TemplateUsageResponseDto {
  /// Whether the RPC call was successful
  bool get success => throw _privateConstructorUsedError;

  /// Error type if failed (e.g., 'not_found', 'database_error')
  String? get error => throw _privateConstructorUsedError;

  /// Error message if failed
  String? get message => throw _privateConstructorUsedError;

  /// Template data section
  TemplateDataDto? get template => throw _privateConstructorUsedError;

  /// Analysis results section
  TemplateAnalysisDto? get analysis => throw _privateConstructorUsedError;

  /// UI configuration section
  @JsonKey(name: 'ui_config')
  TemplateUiConfigDto? get uiConfig => throw _privateConstructorUsedError;

  /// Default values section
  TemplateDefaultsDto? get defaults => throw _privateConstructorUsedError;

  /// Display info section
  @JsonKey(name: 'display_info')
  TemplateDisplayInfoDto? get displayInfo => throw _privateConstructorUsedError;

  /// Serializes this TemplateUsageResponseDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of TemplateUsageResponseDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TemplateUsageResponseDtoCopyWith<TemplateUsageResponseDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TemplateUsageResponseDtoCopyWith<$Res> {
  factory $TemplateUsageResponseDtoCopyWith(TemplateUsageResponseDto value,
          $Res Function(TemplateUsageResponseDto) then) =
      _$TemplateUsageResponseDtoCopyWithImpl<$Res, TemplateUsageResponseDto>;
  @useResult
  $Res call(
      {bool success,
      String? error,
      String? message,
      TemplateDataDto? template,
      TemplateAnalysisDto? analysis,
      @JsonKey(name: 'ui_config') TemplateUiConfigDto? uiConfig,
      TemplateDefaultsDto? defaults,
      @JsonKey(name: 'display_info') TemplateDisplayInfoDto? displayInfo});

  $TemplateDataDtoCopyWith<$Res>? get template;
  $TemplateAnalysisDtoCopyWith<$Res>? get analysis;
  $TemplateUiConfigDtoCopyWith<$Res>? get uiConfig;
  $TemplateDefaultsDtoCopyWith<$Res>? get defaults;
  $TemplateDisplayInfoDtoCopyWith<$Res>? get displayInfo;
}

/// @nodoc
class _$TemplateUsageResponseDtoCopyWithImpl<$Res,
        $Val extends TemplateUsageResponseDto>
    implements $TemplateUsageResponseDtoCopyWith<$Res> {
  _$TemplateUsageResponseDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TemplateUsageResponseDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? success = null,
    Object? error = freezed,
    Object? message = freezed,
    Object? template = freezed,
    Object? analysis = freezed,
    Object? uiConfig = freezed,
    Object? defaults = freezed,
    Object? displayInfo = freezed,
  }) {
    return _then(_value.copyWith(
      success: null == success
          ? _value.success
          : success // ignore: cast_nullable_to_non_nullable
              as bool,
      error: freezed == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as String?,
      message: freezed == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String?,
      template: freezed == template
          ? _value.template
          : template // ignore: cast_nullable_to_non_nullable
              as TemplateDataDto?,
      analysis: freezed == analysis
          ? _value.analysis
          : analysis // ignore: cast_nullable_to_non_nullable
              as TemplateAnalysisDto?,
      uiConfig: freezed == uiConfig
          ? _value.uiConfig
          : uiConfig // ignore: cast_nullable_to_non_nullable
              as TemplateUiConfigDto?,
      defaults: freezed == defaults
          ? _value.defaults
          : defaults // ignore: cast_nullable_to_non_nullable
              as TemplateDefaultsDto?,
      displayInfo: freezed == displayInfo
          ? _value.displayInfo
          : displayInfo // ignore: cast_nullable_to_non_nullable
              as TemplateDisplayInfoDto?,
    ) as $Val);
  }

  /// Create a copy of TemplateUsageResponseDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $TemplateDataDtoCopyWith<$Res>? get template {
    if (_value.template == null) {
      return null;
    }

    return $TemplateDataDtoCopyWith<$Res>(_value.template!, (value) {
      return _then(_value.copyWith(template: value) as $Val);
    });
  }

  /// Create a copy of TemplateUsageResponseDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $TemplateAnalysisDtoCopyWith<$Res>? get analysis {
    if (_value.analysis == null) {
      return null;
    }

    return $TemplateAnalysisDtoCopyWith<$Res>(_value.analysis!, (value) {
      return _then(_value.copyWith(analysis: value) as $Val);
    });
  }

  /// Create a copy of TemplateUsageResponseDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $TemplateUiConfigDtoCopyWith<$Res>? get uiConfig {
    if (_value.uiConfig == null) {
      return null;
    }

    return $TemplateUiConfigDtoCopyWith<$Res>(_value.uiConfig!, (value) {
      return _then(_value.copyWith(uiConfig: value) as $Val);
    });
  }

  /// Create a copy of TemplateUsageResponseDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $TemplateDefaultsDtoCopyWith<$Res>? get defaults {
    if (_value.defaults == null) {
      return null;
    }

    return $TemplateDefaultsDtoCopyWith<$Res>(_value.defaults!, (value) {
      return _then(_value.copyWith(defaults: value) as $Val);
    });
  }

  /// Create a copy of TemplateUsageResponseDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $TemplateDisplayInfoDtoCopyWith<$Res>? get displayInfo {
    if (_value.displayInfo == null) {
      return null;
    }

    return $TemplateDisplayInfoDtoCopyWith<$Res>(_value.displayInfo!, (value) {
      return _then(_value.copyWith(displayInfo: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$TemplateUsageResponseDtoImplCopyWith<$Res>
    implements $TemplateUsageResponseDtoCopyWith<$Res> {
  factory _$$TemplateUsageResponseDtoImplCopyWith(
          _$TemplateUsageResponseDtoImpl value,
          $Res Function(_$TemplateUsageResponseDtoImpl) then) =
      __$$TemplateUsageResponseDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {bool success,
      String? error,
      String? message,
      TemplateDataDto? template,
      TemplateAnalysisDto? analysis,
      @JsonKey(name: 'ui_config') TemplateUiConfigDto? uiConfig,
      TemplateDefaultsDto? defaults,
      @JsonKey(name: 'display_info') TemplateDisplayInfoDto? displayInfo});

  @override
  $TemplateDataDtoCopyWith<$Res>? get template;
  @override
  $TemplateAnalysisDtoCopyWith<$Res>? get analysis;
  @override
  $TemplateUiConfigDtoCopyWith<$Res>? get uiConfig;
  @override
  $TemplateDefaultsDtoCopyWith<$Res>? get defaults;
  @override
  $TemplateDisplayInfoDtoCopyWith<$Res>? get displayInfo;
}

/// @nodoc
class __$$TemplateUsageResponseDtoImplCopyWithImpl<$Res>
    extends _$TemplateUsageResponseDtoCopyWithImpl<$Res,
        _$TemplateUsageResponseDtoImpl>
    implements _$$TemplateUsageResponseDtoImplCopyWith<$Res> {
  __$$TemplateUsageResponseDtoImplCopyWithImpl(
      _$TemplateUsageResponseDtoImpl _value,
      $Res Function(_$TemplateUsageResponseDtoImpl) _then)
      : super(_value, _then);

  /// Create a copy of TemplateUsageResponseDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? success = null,
    Object? error = freezed,
    Object? message = freezed,
    Object? template = freezed,
    Object? analysis = freezed,
    Object? uiConfig = freezed,
    Object? defaults = freezed,
    Object? displayInfo = freezed,
  }) {
    return _then(_$TemplateUsageResponseDtoImpl(
      success: null == success
          ? _value.success
          : success // ignore: cast_nullable_to_non_nullable
              as bool,
      error: freezed == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as String?,
      message: freezed == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String?,
      template: freezed == template
          ? _value.template
          : template // ignore: cast_nullable_to_non_nullable
              as TemplateDataDto?,
      analysis: freezed == analysis
          ? _value.analysis
          : analysis // ignore: cast_nullable_to_non_nullable
              as TemplateAnalysisDto?,
      uiConfig: freezed == uiConfig
          ? _value.uiConfig
          : uiConfig // ignore: cast_nullable_to_non_nullable
              as TemplateUiConfigDto?,
      defaults: freezed == defaults
          ? _value.defaults
          : defaults // ignore: cast_nullable_to_non_nullable
              as TemplateDefaultsDto?,
      displayInfo: freezed == displayInfo
          ? _value.displayInfo
          : displayInfo // ignore: cast_nullable_to_non_nullable
              as TemplateDisplayInfoDto?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$TemplateUsageResponseDtoImpl implements _TemplateUsageResponseDto {
  const _$TemplateUsageResponseDtoImpl(
      {required this.success,
      this.error,
      this.message,
      this.template,
      this.analysis,
      @JsonKey(name: 'ui_config') this.uiConfig,
      this.defaults,
      @JsonKey(name: 'display_info') this.displayInfo});

  factory _$TemplateUsageResponseDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$TemplateUsageResponseDtoImplFromJson(json);

  /// Whether the RPC call was successful
  @override
  final bool success;

  /// Error type if failed (e.g., 'not_found', 'database_error')
  @override
  final String? error;

  /// Error message if failed
  @override
  final String? message;

  /// Template data section
  @override
  final TemplateDataDto? template;

  /// Analysis results section
  @override
  final TemplateAnalysisDto? analysis;

  /// UI configuration section
  @override
  @JsonKey(name: 'ui_config')
  final TemplateUiConfigDto? uiConfig;

  /// Default values section
  @override
  final TemplateDefaultsDto? defaults;

  /// Display info section
  @override
  @JsonKey(name: 'display_info')
  final TemplateDisplayInfoDto? displayInfo;

  @override
  String toString() {
    return 'TemplateUsageResponseDto(success: $success, error: $error, message: $message, template: $template, analysis: $analysis, uiConfig: $uiConfig, defaults: $defaults, displayInfo: $displayInfo)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TemplateUsageResponseDtoImpl &&
            (identical(other.success, success) || other.success == success) &&
            (identical(other.error, error) || other.error == error) &&
            (identical(other.message, message) || other.message == message) &&
            (identical(other.template, template) ||
                other.template == template) &&
            (identical(other.analysis, analysis) ||
                other.analysis == analysis) &&
            (identical(other.uiConfig, uiConfig) ||
                other.uiConfig == uiConfig) &&
            (identical(other.defaults, defaults) ||
                other.defaults == defaults) &&
            (identical(other.displayInfo, displayInfo) ||
                other.displayInfo == displayInfo));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, success, error, message,
      template, analysis, uiConfig, defaults, displayInfo);

  /// Create a copy of TemplateUsageResponseDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TemplateUsageResponseDtoImplCopyWith<_$TemplateUsageResponseDtoImpl>
      get copyWith => __$$TemplateUsageResponseDtoImplCopyWithImpl<
          _$TemplateUsageResponseDtoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TemplateUsageResponseDtoImplToJson(
      this,
    );
  }
}

abstract class _TemplateUsageResponseDto implements TemplateUsageResponseDto {
  const factory _TemplateUsageResponseDto(
          {required final bool success,
          final String? error,
          final String? message,
          final TemplateDataDto? template,
          final TemplateAnalysisDto? analysis,
          @JsonKey(name: 'ui_config') final TemplateUiConfigDto? uiConfig,
          final TemplateDefaultsDto? defaults,
          @JsonKey(name: 'display_info')
          final TemplateDisplayInfoDto? displayInfo}) =
      _$TemplateUsageResponseDtoImpl;

  factory _TemplateUsageResponseDto.fromJson(Map<String, dynamic> json) =
      _$TemplateUsageResponseDtoImpl.fromJson;

  /// Whether the RPC call was successful
  @override
  bool get success;

  /// Error type if failed (e.g., 'not_found', 'database_error')
  @override
  String? get error;

  /// Error message if failed
  @override
  String? get message;

  /// Template data section
  @override
  TemplateDataDto? get template;

  /// Analysis results section
  @override
  TemplateAnalysisDto? get analysis;

  /// UI configuration section
  @override
  @JsonKey(name: 'ui_config')
  TemplateUiConfigDto? get uiConfig;

  /// Default values section
  @override
  TemplateDefaultsDto? get defaults;

  /// Display info section
  @override
  @JsonKey(name: 'display_info')
  TemplateDisplayInfoDto? get displayInfo;

  /// Create a copy of TemplateUsageResponseDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TemplateUsageResponseDtoImplCopyWith<_$TemplateUsageResponseDtoImpl>
      get copyWith => throw _privateConstructorUsedError;
}

TemplateDataDto _$TemplateDataDtoFromJson(Map<String, dynamic> json) {
  return _TemplateDataDto.fromJson(json);
}

/// @nodoc
mixin _$TemplateDataDto {
  @JsonKey(name: 'template_id')
  String get templateId => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  @JsonKey(name: 'required_attachment')
  bool get requiredAttachment => throw _privateConstructorUsedError;
  List<Map<String, dynamic>> get data => throw _privateConstructorUsedError;
  Map<String, dynamic> get tags => throw _privateConstructorUsedError;

  /// Serializes this TemplateDataDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of TemplateDataDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TemplateDataDtoCopyWith<TemplateDataDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TemplateDataDtoCopyWith<$Res> {
  factory $TemplateDataDtoCopyWith(
          TemplateDataDto value, $Res Function(TemplateDataDto) then) =
      _$TemplateDataDtoCopyWithImpl<$Res, TemplateDataDto>;
  @useResult
  $Res call(
      {@JsonKey(name: 'template_id') String templateId,
      String name,
      String? description,
      @JsonKey(name: 'required_attachment') bool requiredAttachment,
      List<Map<String, dynamic>> data,
      Map<String, dynamic> tags});
}

/// @nodoc
class _$TemplateDataDtoCopyWithImpl<$Res, $Val extends TemplateDataDto>
    implements $TemplateDataDtoCopyWith<$Res> {
  _$TemplateDataDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TemplateDataDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? templateId = null,
    Object? name = null,
    Object? description = freezed,
    Object? requiredAttachment = null,
    Object? data = null,
    Object? tags = null,
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
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      requiredAttachment: null == requiredAttachment
          ? _value.requiredAttachment
          : requiredAttachment // ignore: cast_nullable_to_non_nullable
              as bool,
      data: null == data
          ? _value.data
          : data // ignore: cast_nullable_to_non_nullable
              as List<Map<String, dynamic>>,
      tags: null == tags
          ? _value.tags
          : tags // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$TemplateDataDtoImplCopyWith<$Res>
    implements $TemplateDataDtoCopyWith<$Res> {
  factory _$$TemplateDataDtoImplCopyWith(_$TemplateDataDtoImpl value,
          $Res Function(_$TemplateDataDtoImpl) then) =
      __$$TemplateDataDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'template_id') String templateId,
      String name,
      String? description,
      @JsonKey(name: 'required_attachment') bool requiredAttachment,
      List<Map<String, dynamic>> data,
      Map<String, dynamic> tags});
}

/// @nodoc
class __$$TemplateDataDtoImplCopyWithImpl<$Res>
    extends _$TemplateDataDtoCopyWithImpl<$Res, _$TemplateDataDtoImpl>
    implements _$$TemplateDataDtoImplCopyWith<$Res> {
  __$$TemplateDataDtoImplCopyWithImpl(
      _$TemplateDataDtoImpl _value, $Res Function(_$TemplateDataDtoImpl) _then)
      : super(_value, _then);

  /// Create a copy of TemplateDataDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? templateId = null,
    Object? name = null,
    Object? description = freezed,
    Object? requiredAttachment = null,
    Object? data = null,
    Object? tags = null,
  }) {
    return _then(_$TemplateDataDtoImpl(
      templateId: null == templateId
          ? _value.templateId
          : templateId // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      requiredAttachment: null == requiredAttachment
          ? _value.requiredAttachment
          : requiredAttachment // ignore: cast_nullable_to_non_nullable
              as bool,
      data: null == data
          ? _value._data
          : data // ignore: cast_nullable_to_non_nullable
              as List<Map<String, dynamic>>,
      tags: null == tags
          ? _value._tags
          : tags // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$TemplateDataDtoImpl implements _TemplateDataDto {
  const _$TemplateDataDtoImpl(
      {@JsonKey(name: 'template_id') required this.templateId,
      required this.name,
      this.description,
      @JsonKey(name: 'required_attachment') this.requiredAttachment = false,
      final List<Map<String, dynamic>> data = const [],
      final Map<String, dynamic> tags = const {}})
      : _data = data,
        _tags = tags;

  factory _$TemplateDataDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$TemplateDataDtoImplFromJson(json);

  @override
  @JsonKey(name: 'template_id')
  final String templateId;
  @override
  final String name;
  @override
  final String? description;
  @override
  @JsonKey(name: 'required_attachment')
  final bool requiredAttachment;
  final List<Map<String, dynamic>> _data;
  @override
  @JsonKey()
  List<Map<String, dynamic>> get data {
    if (_data is EqualUnmodifiableListView) return _data;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_data);
  }

  final Map<String, dynamic> _tags;
  @override
  @JsonKey()
  Map<String, dynamic> get tags {
    if (_tags is EqualUnmodifiableMapView) return _tags;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_tags);
  }

  @override
  String toString() {
    return 'TemplateDataDto(templateId: $templateId, name: $name, description: $description, requiredAttachment: $requiredAttachment, data: $data, tags: $tags)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TemplateDataDtoImpl &&
            (identical(other.templateId, templateId) ||
                other.templateId == templateId) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.requiredAttachment, requiredAttachment) ||
                other.requiredAttachment == requiredAttachment) &&
            const DeepCollectionEquality().equals(other._data, _data) &&
            const DeepCollectionEquality().equals(other._tags, _tags));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      templateId,
      name,
      description,
      requiredAttachment,
      const DeepCollectionEquality().hash(_data),
      const DeepCollectionEquality().hash(_tags));

  /// Create a copy of TemplateDataDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TemplateDataDtoImplCopyWith<_$TemplateDataDtoImpl> get copyWith =>
      __$$TemplateDataDtoImplCopyWithImpl<_$TemplateDataDtoImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TemplateDataDtoImplToJson(
      this,
    );
  }
}

abstract class _TemplateDataDto implements TemplateDataDto {
  const factory _TemplateDataDto(
      {@JsonKey(name: 'template_id') required final String templateId,
      required final String name,
      final String? description,
      @JsonKey(name: 'required_attachment') final bool requiredAttachment,
      final List<Map<String, dynamic>> data,
      final Map<String, dynamic> tags}) = _$TemplateDataDtoImpl;

  factory _TemplateDataDto.fromJson(Map<String, dynamic> json) =
      _$TemplateDataDtoImpl.fromJson;

  @override
  @JsonKey(name: 'template_id')
  String get templateId;
  @override
  String get name;
  @override
  String? get description;
  @override
  @JsonKey(name: 'required_attachment')
  bool get requiredAttachment;
  @override
  List<Map<String, dynamic>> get data;
  @override
  Map<String, dynamic> get tags;

  /// Create a copy of TemplateDataDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TemplateDataDtoImplCopyWith<_$TemplateDataDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

TemplateAnalysisDto _$TemplateAnalysisDtoFromJson(Map<String, dynamic> json) {
  return _TemplateAnalysisDto.fromJson(json);
}

/// @nodoc
mixin _$TemplateAnalysisDto {
  /// Template complexity: 'simple' | 'withCash' | 'withCounterparty' | 'complex'
  String get complexity => throw _privateConstructorUsedError;

  /// List of missing items that need user input
  @JsonKey(name: 'missing_items')
  List<String> get missingItems => throw _privateConstructorUsedError;

  /// Whether template is ready to use (no missing items)
  @JsonKey(name: 'is_ready')
  bool get isReady => throw _privateConstructorUsedError;

  /// Completeness score (0-100)
  @JsonKey(name: 'completeness_score')
  int get completenessScore => throw _privateConstructorUsedError;

  /// Serializes this TemplateAnalysisDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of TemplateAnalysisDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TemplateAnalysisDtoCopyWith<TemplateAnalysisDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TemplateAnalysisDtoCopyWith<$Res> {
  factory $TemplateAnalysisDtoCopyWith(
          TemplateAnalysisDto value, $Res Function(TemplateAnalysisDto) then) =
      _$TemplateAnalysisDtoCopyWithImpl<$Res, TemplateAnalysisDto>;
  @useResult
  $Res call(
      {String complexity,
      @JsonKey(name: 'missing_items') List<String> missingItems,
      @JsonKey(name: 'is_ready') bool isReady,
      @JsonKey(name: 'completeness_score') int completenessScore});
}

/// @nodoc
class _$TemplateAnalysisDtoCopyWithImpl<$Res, $Val extends TemplateAnalysisDto>
    implements $TemplateAnalysisDtoCopyWith<$Res> {
  _$TemplateAnalysisDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TemplateAnalysisDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? complexity = null,
    Object? missingItems = null,
    Object? isReady = null,
    Object? completenessScore = null,
  }) {
    return _then(_value.copyWith(
      complexity: null == complexity
          ? _value.complexity
          : complexity // ignore: cast_nullable_to_non_nullable
              as String,
      missingItems: null == missingItems
          ? _value.missingItems
          : missingItems // ignore: cast_nullable_to_non_nullable
              as List<String>,
      isReady: null == isReady
          ? _value.isReady
          : isReady // ignore: cast_nullable_to_non_nullable
              as bool,
      completenessScore: null == completenessScore
          ? _value.completenessScore
          : completenessScore // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$TemplateAnalysisDtoImplCopyWith<$Res>
    implements $TemplateAnalysisDtoCopyWith<$Res> {
  factory _$$TemplateAnalysisDtoImplCopyWith(_$TemplateAnalysisDtoImpl value,
          $Res Function(_$TemplateAnalysisDtoImpl) then) =
      __$$TemplateAnalysisDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String complexity,
      @JsonKey(name: 'missing_items') List<String> missingItems,
      @JsonKey(name: 'is_ready') bool isReady,
      @JsonKey(name: 'completeness_score') int completenessScore});
}

/// @nodoc
class __$$TemplateAnalysisDtoImplCopyWithImpl<$Res>
    extends _$TemplateAnalysisDtoCopyWithImpl<$Res, _$TemplateAnalysisDtoImpl>
    implements _$$TemplateAnalysisDtoImplCopyWith<$Res> {
  __$$TemplateAnalysisDtoImplCopyWithImpl(_$TemplateAnalysisDtoImpl _value,
      $Res Function(_$TemplateAnalysisDtoImpl) _then)
      : super(_value, _then);

  /// Create a copy of TemplateAnalysisDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? complexity = null,
    Object? missingItems = null,
    Object? isReady = null,
    Object? completenessScore = null,
  }) {
    return _then(_$TemplateAnalysisDtoImpl(
      complexity: null == complexity
          ? _value.complexity
          : complexity // ignore: cast_nullable_to_non_nullable
              as String,
      missingItems: null == missingItems
          ? _value._missingItems
          : missingItems // ignore: cast_nullable_to_non_nullable
              as List<String>,
      isReady: null == isReady
          ? _value.isReady
          : isReady // ignore: cast_nullable_to_non_nullable
              as bool,
      completenessScore: null == completenessScore
          ? _value.completenessScore
          : completenessScore // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$TemplateAnalysisDtoImpl implements _TemplateAnalysisDto {
  const _$TemplateAnalysisDtoImpl(
      {required this.complexity,
      @JsonKey(name: 'missing_items')
      final List<String> missingItems = const [],
      @JsonKey(name: 'is_ready') this.isReady = false,
      @JsonKey(name: 'completeness_score') this.completenessScore = 100})
      : _missingItems = missingItems;

  factory _$TemplateAnalysisDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$TemplateAnalysisDtoImplFromJson(json);

  /// Template complexity: 'simple' | 'withCash' | 'withCounterparty' | 'complex'
  @override
  final String complexity;

  /// List of missing items that need user input
  final List<String> _missingItems;

  /// List of missing items that need user input
  @override
  @JsonKey(name: 'missing_items')
  List<String> get missingItems {
    if (_missingItems is EqualUnmodifiableListView) return _missingItems;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_missingItems);
  }

  /// Whether template is ready to use (no missing items)
  @override
  @JsonKey(name: 'is_ready')
  final bool isReady;

  /// Completeness score (0-100)
  @override
  @JsonKey(name: 'completeness_score')
  final int completenessScore;

  @override
  String toString() {
    return 'TemplateAnalysisDto(complexity: $complexity, missingItems: $missingItems, isReady: $isReady, completenessScore: $completenessScore)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TemplateAnalysisDtoImpl &&
            (identical(other.complexity, complexity) ||
                other.complexity == complexity) &&
            const DeepCollectionEquality()
                .equals(other._missingItems, _missingItems) &&
            (identical(other.isReady, isReady) || other.isReady == isReady) &&
            (identical(other.completenessScore, completenessScore) ||
                other.completenessScore == completenessScore));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      complexity,
      const DeepCollectionEquality().hash(_missingItems),
      isReady,
      completenessScore);

  /// Create a copy of TemplateAnalysisDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TemplateAnalysisDtoImplCopyWith<_$TemplateAnalysisDtoImpl> get copyWith =>
      __$$TemplateAnalysisDtoImplCopyWithImpl<_$TemplateAnalysisDtoImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TemplateAnalysisDtoImplToJson(
      this,
    );
  }
}

abstract class _TemplateAnalysisDto implements TemplateAnalysisDto {
  const factory _TemplateAnalysisDto(
          {required final String complexity,
          @JsonKey(name: 'missing_items') final List<String> missingItems,
          @JsonKey(name: 'is_ready') final bool isReady,
          @JsonKey(name: 'completeness_score') final int completenessScore}) =
      _$TemplateAnalysisDtoImpl;

  factory _TemplateAnalysisDto.fromJson(Map<String, dynamic> json) =
      _$TemplateAnalysisDtoImpl.fromJson;

  /// Template complexity: 'simple' | 'withCash' | 'withCounterparty' | 'complex'
  @override
  String get complexity;

  /// List of missing items that need user input
  @override
  @JsonKey(name: 'missing_items')
  List<String> get missingItems;

  /// Whether template is ready to use (no missing items)
  @override
  @JsonKey(name: 'is_ready')
  bool get isReady;

  /// Completeness score (0-100)
  @override
  @JsonKey(name: 'completeness_score')
  int get completenessScore;

  /// Create a copy of TemplateAnalysisDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TemplateAnalysisDtoImplCopyWith<_$TemplateAnalysisDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

TemplateUiConfigDto _$TemplateUiConfigDtoFromJson(Map<String, dynamic> json) {
  return _TemplateUiConfigDto.fromJson(json);
}

/// @nodoc
mixin _$TemplateUiConfigDto {
  /// Whether to show cash location selector
  @JsonKey(name: 'show_cash_location_selector')
  bool get showCashLocationSelector => throw _privateConstructorUsedError;

  /// Whether to show counterparty selector
  @JsonKey(name: 'show_counterparty_selector')
  bool get showCounterpartySelector => throw _privateConstructorUsedError;

  /// Whether to show counterparty store selector (internal counterparty)
  @JsonKey(name: 'show_counterparty_store_selector')
  bool get showCounterpartyStoreSelector => throw _privateConstructorUsedError;

  /// Whether to show counterparty cash location selector (internal counterparty)
  @JsonKey(name: 'show_counterparty_cash_location_selector')
  bool get showCounterpartyCashLocationSelector =>
      throw _privateConstructorUsedError;

  /// Whether counterparty is locked (internal counterparty)
  @JsonKey(name: 'counterparty_is_locked')
  bool get counterpartyIsLocked => throw _privateConstructorUsedError;

  /// Locked counterparty name for display
  @JsonKey(name: 'locked_counterparty_name')
  String? get lockedCounterpartyName => throw _privateConstructorUsedError;

  /// Linked company ID for internal counterparty
  @JsonKey(name: 'linked_company_id')
  String? get linkedCompanyId => throw _privateConstructorUsedError;

  /// Serializes this TemplateUiConfigDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of TemplateUiConfigDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TemplateUiConfigDtoCopyWith<TemplateUiConfigDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TemplateUiConfigDtoCopyWith<$Res> {
  factory $TemplateUiConfigDtoCopyWith(
          TemplateUiConfigDto value, $Res Function(TemplateUiConfigDto) then) =
      _$TemplateUiConfigDtoCopyWithImpl<$Res, TemplateUiConfigDto>;
  @useResult
  $Res call(
      {@JsonKey(name: 'show_cash_location_selector')
      bool showCashLocationSelector,
      @JsonKey(name: 'show_counterparty_selector')
      bool showCounterpartySelector,
      @JsonKey(name: 'show_counterparty_store_selector')
      bool showCounterpartyStoreSelector,
      @JsonKey(name: 'show_counterparty_cash_location_selector')
      bool showCounterpartyCashLocationSelector,
      @JsonKey(name: 'counterparty_is_locked') bool counterpartyIsLocked,
      @JsonKey(name: 'locked_counterparty_name') String? lockedCounterpartyName,
      @JsonKey(name: 'linked_company_id') String? linkedCompanyId});
}

/// @nodoc
class _$TemplateUiConfigDtoCopyWithImpl<$Res, $Val extends TemplateUiConfigDto>
    implements $TemplateUiConfigDtoCopyWith<$Res> {
  _$TemplateUiConfigDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TemplateUiConfigDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? showCashLocationSelector = null,
    Object? showCounterpartySelector = null,
    Object? showCounterpartyStoreSelector = null,
    Object? showCounterpartyCashLocationSelector = null,
    Object? counterpartyIsLocked = null,
    Object? lockedCounterpartyName = freezed,
    Object? linkedCompanyId = freezed,
  }) {
    return _then(_value.copyWith(
      showCashLocationSelector: null == showCashLocationSelector
          ? _value.showCashLocationSelector
          : showCashLocationSelector // ignore: cast_nullable_to_non_nullable
              as bool,
      showCounterpartySelector: null == showCounterpartySelector
          ? _value.showCounterpartySelector
          : showCounterpartySelector // ignore: cast_nullable_to_non_nullable
              as bool,
      showCounterpartyStoreSelector: null == showCounterpartyStoreSelector
          ? _value.showCounterpartyStoreSelector
          : showCounterpartyStoreSelector // ignore: cast_nullable_to_non_nullable
              as bool,
      showCounterpartyCashLocationSelector: null ==
              showCounterpartyCashLocationSelector
          ? _value.showCounterpartyCashLocationSelector
          : showCounterpartyCashLocationSelector // ignore: cast_nullable_to_non_nullable
              as bool,
      counterpartyIsLocked: null == counterpartyIsLocked
          ? _value.counterpartyIsLocked
          : counterpartyIsLocked // ignore: cast_nullable_to_non_nullable
              as bool,
      lockedCounterpartyName: freezed == lockedCounterpartyName
          ? _value.lockedCounterpartyName
          : lockedCounterpartyName // ignore: cast_nullable_to_non_nullable
              as String?,
      linkedCompanyId: freezed == linkedCompanyId
          ? _value.linkedCompanyId
          : linkedCompanyId // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$TemplateUiConfigDtoImplCopyWith<$Res>
    implements $TemplateUiConfigDtoCopyWith<$Res> {
  factory _$$TemplateUiConfigDtoImplCopyWith(_$TemplateUiConfigDtoImpl value,
          $Res Function(_$TemplateUiConfigDtoImpl) then) =
      __$$TemplateUiConfigDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'show_cash_location_selector')
      bool showCashLocationSelector,
      @JsonKey(name: 'show_counterparty_selector')
      bool showCounterpartySelector,
      @JsonKey(name: 'show_counterparty_store_selector')
      bool showCounterpartyStoreSelector,
      @JsonKey(name: 'show_counterparty_cash_location_selector')
      bool showCounterpartyCashLocationSelector,
      @JsonKey(name: 'counterparty_is_locked') bool counterpartyIsLocked,
      @JsonKey(name: 'locked_counterparty_name') String? lockedCounterpartyName,
      @JsonKey(name: 'linked_company_id') String? linkedCompanyId});
}

/// @nodoc
class __$$TemplateUiConfigDtoImplCopyWithImpl<$Res>
    extends _$TemplateUiConfigDtoCopyWithImpl<$Res, _$TemplateUiConfigDtoImpl>
    implements _$$TemplateUiConfigDtoImplCopyWith<$Res> {
  __$$TemplateUiConfigDtoImplCopyWithImpl(_$TemplateUiConfigDtoImpl _value,
      $Res Function(_$TemplateUiConfigDtoImpl) _then)
      : super(_value, _then);

  /// Create a copy of TemplateUiConfigDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? showCashLocationSelector = null,
    Object? showCounterpartySelector = null,
    Object? showCounterpartyStoreSelector = null,
    Object? showCounterpartyCashLocationSelector = null,
    Object? counterpartyIsLocked = null,
    Object? lockedCounterpartyName = freezed,
    Object? linkedCompanyId = freezed,
  }) {
    return _then(_$TemplateUiConfigDtoImpl(
      showCashLocationSelector: null == showCashLocationSelector
          ? _value.showCashLocationSelector
          : showCashLocationSelector // ignore: cast_nullable_to_non_nullable
              as bool,
      showCounterpartySelector: null == showCounterpartySelector
          ? _value.showCounterpartySelector
          : showCounterpartySelector // ignore: cast_nullable_to_non_nullable
              as bool,
      showCounterpartyStoreSelector: null == showCounterpartyStoreSelector
          ? _value.showCounterpartyStoreSelector
          : showCounterpartyStoreSelector // ignore: cast_nullable_to_non_nullable
              as bool,
      showCounterpartyCashLocationSelector: null ==
              showCounterpartyCashLocationSelector
          ? _value.showCounterpartyCashLocationSelector
          : showCounterpartyCashLocationSelector // ignore: cast_nullable_to_non_nullable
              as bool,
      counterpartyIsLocked: null == counterpartyIsLocked
          ? _value.counterpartyIsLocked
          : counterpartyIsLocked // ignore: cast_nullable_to_non_nullable
              as bool,
      lockedCounterpartyName: freezed == lockedCounterpartyName
          ? _value.lockedCounterpartyName
          : lockedCounterpartyName // ignore: cast_nullable_to_non_nullable
              as String?,
      linkedCompanyId: freezed == linkedCompanyId
          ? _value.linkedCompanyId
          : linkedCompanyId // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$TemplateUiConfigDtoImpl implements _TemplateUiConfigDto {
  const _$TemplateUiConfigDtoImpl(
      {@JsonKey(name: 'show_cash_location_selector')
      this.showCashLocationSelector = false,
      @JsonKey(name: 'show_counterparty_selector')
      this.showCounterpartySelector = false,
      @JsonKey(name: 'show_counterparty_store_selector')
      this.showCounterpartyStoreSelector = false,
      @JsonKey(name: 'show_counterparty_cash_location_selector')
      this.showCounterpartyCashLocationSelector = false,
      @JsonKey(name: 'counterparty_is_locked')
      this.counterpartyIsLocked = false,
      @JsonKey(name: 'locked_counterparty_name') this.lockedCounterpartyName,
      @JsonKey(name: 'linked_company_id') this.linkedCompanyId});

  factory _$TemplateUiConfigDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$TemplateUiConfigDtoImplFromJson(json);

  /// Whether to show cash location selector
  @override
  @JsonKey(name: 'show_cash_location_selector')
  final bool showCashLocationSelector;

  /// Whether to show counterparty selector
  @override
  @JsonKey(name: 'show_counterparty_selector')
  final bool showCounterpartySelector;

  /// Whether to show counterparty store selector (internal counterparty)
  @override
  @JsonKey(name: 'show_counterparty_store_selector')
  final bool showCounterpartyStoreSelector;

  /// Whether to show counterparty cash location selector (internal counterparty)
  @override
  @JsonKey(name: 'show_counterparty_cash_location_selector')
  final bool showCounterpartyCashLocationSelector;

  /// Whether counterparty is locked (internal counterparty)
  @override
  @JsonKey(name: 'counterparty_is_locked')
  final bool counterpartyIsLocked;

  /// Locked counterparty name for display
  @override
  @JsonKey(name: 'locked_counterparty_name')
  final String? lockedCounterpartyName;

  /// Linked company ID for internal counterparty
  @override
  @JsonKey(name: 'linked_company_id')
  final String? linkedCompanyId;

  @override
  String toString() {
    return 'TemplateUiConfigDto(showCashLocationSelector: $showCashLocationSelector, showCounterpartySelector: $showCounterpartySelector, showCounterpartyStoreSelector: $showCounterpartyStoreSelector, showCounterpartyCashLocationSelector: $showCounterpartyCashLocationSelector, counterpartyIsLocked: $counterpartyIsLocked, lockedCounterpartyName: $lockedCounterpartyName, linkedCompanyId: $linkedCompanyId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TemplateUiConfigDtoImpl &&
            (identical(
                    other.showCashLocationSelector, showCashLocationSelector) ||
                other.showCashLocationSelector == showCashLocationSelector) &&
            (identical(
                    other.showCounterpartySelector, showCounterpartySelector) ||
                other.showCounterpartySelector == showCounterpartySelector) &&
            (identical(other.showCounterpartyStoreSelector,
                    showCounterpartyStoreSelector) ||
                other.showCounterpartyStoreSelector ==
                    showCounterpartyStoreSelector) &&
            (identical(other.showCounterpartyCashLocationSelector,
                    showCounterpartyCashLocationSelector) ||
                other.showCounterpartyCashLocationSelector ==
                    showCounterpartyCashLocationSelector) &&
            (identical(other.counterpartyIsLocked, counterpartyIsLocked) ||
                other.counterpartyIsLocked == counterpartyIsLocked) &&
            (identical(other.lockedCounterpartyName, lockedCounterpartyName) ||
                other.lockedCounterpartyName == lockedCounterpartyName) &&
            (identical(other.linkedCompanyId, linkedCompanyId) ||
                other.linkedCompanyId == linkedCompanyId));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      showCashLocationSelector,
      showCounterpartySelector,
      showCounterpartyStoreSelector,
      showCounterpartyCashLocationSelector,
      counterpartyIsLocked,
      lockedCounterpartyName,
      linkedCompanyId);

  /// Create a copy of TemplateUiConfigDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TemplateUiConfigDtoImplCopyWith<_$TemplateUiConfigDtoImpl> get copyWith =>
      __$$TemplateUiConfigDtoImplCopyWithImpl<_$TemplateUiConfigDtoImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TemplateUiConfigDtoImplToJson(
      this,
    );
  }
}

abstract class _TemplateUiConfigDto implements TemplateUiConfigDto {
  const factory _TemplateUiConfigDto(
      {@JsonKey(name: 'show_cash_location_selector')
      final bool showCashLocationSelector,
      @JsonKey(name: 'show_counterparty_selector')
      final bool showCounterpartySelector,
      @JsonKey(name: 'show_counterparty_store_selector')
      final bool showCounterpartyStoreSelector,
      @JsonKey(name: 'show_counterparty_cash_location_selector')
      final bool showCounterpartyCashLocationSelector,
      @JsonKey(name: 'counterparty_is_locked') final bool counterpartyIsLocked,
      @JsonKey(name: 'locked_counterparty_name')
      final String? lockedCounterpartyName,
      @JsonKey(name: 'linked_company_id')
      final String? linkedCompanyId}) = _$TemplateUiConfigDtoImpl;

  factory _TemplateUiConfigDto.fromJson(Map<String, dynamic> json) =
      _$TemplateUiConfigDtoImpl.fromJson;

  /// Whether to show cash location selector
  @override
  @JsonKey(name: 'show_cash_location_selector')
  bool get showCashLocationSelector;

  /// Whether to show counterparty selector
  @override
  @JsonKey(name: 'show_counterparty_selector')
  bool get showCounterpartySelector;

  /// Whether to show counterparty store selector (internal counterparty)
  @override
  @JsonKey(name: 'show_counterparty_store_selector')
  bool get showCounterpartyStoreSelector;

  /// Whether to show counterparty cash location selector (internal counterparty)
  @override
  @JsonKey(name: 'show_counterparty_cash_location_selector')
  bool get showCounterpartyCashLocationSelector;

  /// Whether counterparty is locked (internal counterparty)
  @override
  @JsonKey(name: 'counterparty_is_locked')
  bool get counterpartyIsLocked;

  /// Locked counterparty name for display
  @override
  @JsonKey(name: 'locked_counterparty_name')
  String? get lockedCounterpartyName;

  /// Linked company ID for internal counterparty
  @override
  @JsonKey(name: 'linked_company_id')
  String? get linkedCompanyId;

  /// Create a copy of TemplateUiConfigDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TemplateUiConfigDtoImplCopyWith<_$TemplateUiConfigDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

TemplateDefaultsDto _$TemplateDefaultsDtoFromJson(Map<String, dynamic> json) {
  return _TemplateDefaultsDto.fromJson(json);
}

/// @nodoc
mixin _$TemplateDefaultsDto {
  /// Default cash location ID
  @JsonKey(name: 'cash_location_id')
  String? get cashLocationId => throw _privateConstructorUsedError;

  /// Default cash location name
  @JsonKey(name: 'cash_location_name')
  String? get cashLocationName => throw _privateConstructorUsedError;

  /// Default counterparty ID
  @JsonKey(name: 'counterparty_id')
  String? get counterpartyId => throw _privateConstructorUsedError;

  /// Default counterparty name
  @JsonKey(name: 'counterparty_name')
  String? get counterpartyName => throw _privateConstructorUsedError;

  /// Default counterparty store ID (internal)
  @JsonKey(name: 'counterparty_store_id')
  String? get counterpartyStoreId => throw _privateConstructorUsedError;

  /// Default counterparty store name (internal)
  @JsonKey(name: 'counterparty_store_name')
  String? get counterpartyStoreName => throw _privateConstructorUsedError;

  /// Default counterparty cash location ID
  @JsonKey(name: 'counterparty_cash_location_id')
  String? get counterpartyCashLocationId => throw _privateConstructorUsedError;

  /// Whether counterparty is internal
  @JsonKey(name: 'is_internal_counterparty')
  bool get isInternalCounterparty => throw _privateConstructorUsedError;

  /// Serializes this TemplateDefaultsDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of TemplateDefaultsDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TemplateDefaultsDtoCopyWith<TemplateDefaultsDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TemplateDefaultsDtoCopyWith<$Res> {
  factory $TemplateDefaultsDtoCopyWith(
          TemplateDefaultsDto value, $Res Function(TemplateDefaultsDto) then) =
      _$TemplateDefaultsDtoCopyWithImpl<$Res, TemplateDefaultsDto>;
  @useResult
  $Res call(
      {@JsonKey(name: 'cash_location_id') String? cashLocationId,
      @JsonKey(name: 'cash_location_name') String? cashLocationName,
      @JsonKey(name: 'counterparty_id') String? counterpartyId,
      @JsonKey(name: 'counterparty_name') String? counterpartyName,
      @JsonKey(name: 'counterparty_store_id') String? counterpartyStoreId,
      @JsonKey(name: 'counterparty_store_name') String? counterpartyStoreName,
      @JsonKey(name: 'counterparty_cash_location_id')
      String? counterpartyCashLocationId,
      @JsonKey(name: 'is_internal_counterparty') bool isInternalCounterparty});
}

/// @nodoc
class _$TemplateDefaultsDtoCopyWithImpl<$Res, $Val extends TemplateDefaultsDto>
    implements $TemplateDefaultsDtoCopyWith<$Res> {
  _$TemplateDefaultsDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TemplateDefaultsDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? cashLocationId = freezed,
    Object? cashLocationName = freezed,
    Object? counterpartyId = freezed,
    Object? counterpartyName = freezed,
    Object? counterpartyStoreId = freezed,
    Object? counterpartyStoreName = freezed,
    Object? counterpartyCashLocationId = freezed,
    Object? isInternalCounterparty = null,
  }) {
    return _then(_value.copyWith(
      cashLocationId: freezed == cashLocationId
          ? _value.cashLocationId
          : cashLocationId // ignore: cast_nullable_to_non_nullable
              as String?,
      cashLocationName: freezed == cashLocationName
          ? _value.cashLocationName
          : cashLocationName // ignore: cast_nullable_to_non_nullable
              as String?,
      counterpartyId: freezed == counterpartyId
          ? _value.counterpartyId
          : counterpartyId // ignore: cast_nullable_to_non_nullable
              as String?,
      counterpartyName: freezed == counterpartyName
          ? _value.counterpartyName
          : counterpartyName // ignore: cast_nullable_to_non_nullable
              as String?,
      counterpartyStoreId: freezed == counterpartyStoreId
          ? _value.counterpartyStoreId
          : counterpartyStoreId // ignore: cast_nullable_to_non_nullable
              as String?,
      counterpartyStoreName: freezed == counterpartyStoreName
          ? _value.counterpartyStoreName
          : counterpartyStoreName // ignore: cast_nullable_to_non_nullable
              as String?,
      counterpartyCashLocationId: freezed == counterpartyCashLocationId
          ? _value.counterpartyCashLocationId
          : counterpartyCashLocationId // ignore: cast_nullable_to_non_nullable
              as String?,
      isInternalCounterparty: null == isInternalCounterparty
          ? _value.isInternalCounterparty
          : isInternalCounterparty // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$TemplateDefaultsDtoImplCopyWith<$Res>
    implements $TemplateDefaultsDtoCopyWith<$Res> {
  factory _$$TemplateDefaultsDtoImplCopyWith(_$TemplateDefaultsDtoImpl value,
          $Res Function(_$TemplateDefaultsDtoImpl) then) =
      __$$TemplateDefaultsDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'cash_location_id') String? cashLocationId,
      @JsonKey(name: 'cash_location_name') String? cashLocationName,
      @JsonKey(name: 'counterparty_id') String? counterpartyId,
      @JsonKey(name: 'counterparty_name') String? counterpartyName,
      @JsonKey(name: 'counterparty_store_id') String? counterpartyStoreId,
      @JsonKey(name: 'counterparty_store_name') String? counterpartyStoreName,
      @JsonKey(name: 'counterparty_cash_location_id')
      String? counterpartyCashLocationId,
      @JsonKey(name: 'is_internal_counterparty') bool isInternalCounterparty});
}

/// @nodoc
class __$$TemplateDefaultsDtoImplCopyWithImpl<$Res>
    extends _$TemplateDefaultsDtoCopyWithImpl<$Res, _$TemplateDefaultsDtoImpl>
    implements _$$TemplateDefaultsDtoImplCopyWith<$Res> {
  __$$TemplateDefaultsDtoImplCopyWithImpl(_$TemplateDefaultsDtoImpl _value,
      $Res Function(_$TemplateDefaultsDtoImpl) _then)
      : super(_value, _then);

  /// Create a copy of TemplateDefaultsDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? cashLocationId = freezed,
    Object? cashLocationName = freezed,
    Object? counterpartyId = freezed,
    Object? counterpartyName = freezed,
    Object? counterpartyStoreId = freezed,
    Object? counterpartyStoreName = freezed,
    Object? counterpartyCashLocationId = freezed,
    Object? isInternalCounterparty = null,
  }) {
    return _then(_$TemplateDefaultsDtoImpl(
      cashLocationId: freezed == cashLocationId
          ? _value.cashLocationId
          : cashLocationId // ignore: cast_nullable_to_non_nullable
              as String?,
      cashLocationName: freezed == cashLocationName
          ? _value.cashLocationName
          : cashLocationName // ignore: cast_nullable_to_non_nullable
              as String?,
      counterpartyId: freezed == counterpartyId
          ? _value.counterpartyId
          : counterpartyId // ignore: cast_nullable_to_non_nullable
              as String?,
      counterpartyName: freezed == counterpartyName
          ? _value.counterpartyName
          : counterpartyName // ignore: cast_nullable_to_non_nullable
              as String?,
      counterpartyStoreId: freezed == counterpartyStoreId
          ? _value.counterpartyStoreId
          : counterpartyStoreId // ignore: cast_nullable_to_non_nullable
              as String?,
      counterpartyStoreName: freezed == counterpartyStoreName
          ? _value.counterpartyStoreName
          : counterpartyStoreName // ignore: cast_nullable_to_non_nullable
              as String?,
      counterpartyCashLocationId: freezed == counterpartyCashLocationId
          ? _value.counterpartyCashLocationId
          : counterpartyCashLocationId // ignore: cast_nullable_to_non_nullable
              as String?,
      isInternalCounterparty: null == isInternalCounterparty
          ? _value.isInternalCounterparty
          : isInternalCounterparty // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$TemplateDefaultsDtoImpl implements _TemplateDefaultsDto {
  const _$TemplateDefaultsDtoImpl(
      {@JsonKey(name: 'cash_location_id') this.cashLocationId,
      @JsonKey(name: 'cash_location_name') this.cashLocationName,
      @JsonKey(name: 'counterparty_id') this.counterpartyId,
      @JsonKey(name: 'counterparty_name') this.counterpartyName,
      @JsonKey(name: 'counterparty_store_id') this.counterpartyStoreId,
      @JsonKey(name: 'counterparty_store_name') this.counterpartyStoreName,
      @JsonKey(name: 'counterparty_cash_location_id')
      this.counterpartyCashLocationId,
      @JsonKey(name: 'is_internal_counterparty')
      this.isInternalCounterparty = false});

  factory _$TemplateDefaultsDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$TemplateDefaultsDtoImplFromJson(json);

  /// Default cash location ID
  @override
  @JsonKey(name: 'cash_location_id')
  final String? cashLocationId;

  /// Default cash location name
  @override
  @JsonKey(name: 'cash_location_name')
  final String? cashLocationName;

  /// Default counterparty ID
  @override
  @JsonKey(name: 'counterparty_id')
  final String? counterpartyId;

  /// Default counterparty name
  @override
  @JsonKey(name: 'counterparty_name')
  final String? counterpartyName;

  /// Default counterparty store ID (internal)
  @override
  @JsonKey(name: 'counterparty_store_id')
  final String? counterpartyStoreId;

  /// Default counterparty store name (internal)
  @override
  @JsonKey(name: 'counterparty_store_name')
  final String? counterpartyStoreName;

  /// Default counterparty cash location ID
  @override
  @JsonKey(name: 'counterparty_cash_location_id')
  final String? counterpartyCashLocationId;

  /// Whether counterparty is internal
  @override
  @JsonKey(name: 'is_internal_counterparty')
  final bool isInternalCounterparty;

  @override
  String toString() {
    return 'TemplateDefaultsDto(cashLocationId: $cashLocationId, cashLocationName: $cashLocationName, counterpartyId: $counterpartyId, counterpartyName: $counterpartyName, counterpartyStoreId: $counterpartyStoreId, counterpartyStoreName: $counterpartyStoreName, counterpartyCashLocationId: $counterpartyCashLocationId, isInternalCounterparty: $isInternalCounterparty)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TemplateDefaultsDtoImpl &&
            (identical(other.cashLocationId, cashLocationId) ||
                other.cashLocationId == cashLocationId) &&
            (identical(other.cashLocationName, cashLocationName) ||
                other.cashLocationName == cashLocationName) &&
            (identical(other.counterpartyId, counterpartyId) ||
                other.counterpartyId == counterpartyId) &&
            (identical(other.counterpartyName, counterpartyName) ||
                other.counterpartyName == counterpartyName) &&
            (identical(other.counterpartyStoreId, counterpartyStoreId) ||
                other.counterpartyStoreId == counterpartyStoreId) &&
            (identical(other.counterpartyStoreName, counterpartyStoreName) ||
                other.counterpartyStoreName == counterpartyStoreName) &&
            (identical(other.counterpartyCashLocationId,
                    counterpartyCashLocationId) ||
                other.counterpartyCashLocationId ==
                    counterpartyCashLocationId) &&
            (identical(other.isInternalCounterparty, isInternalCounterparty) ||
                other.isInternalCounterparty == isInternalCounterparty));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      cashLocationId,
      cashLocationName,
      counterpartyId,
      counterpartyName,
      counterpartyStoreId,
      counterpartyStoreName,
      counterpartyCashLocationId,
      isInternalCounterparty);

  /// Create a copy of TemplateDefaultsDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TemplateDefaultsDtoImplCopyWith<_$TemplateDefaultsDtoImpl> get copyWith =>
      __$$TemplateDefaultsDtoImplCopyWithImpl<_$TemplateDefaultsDtoImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TemplateDefaultsDtoImplToJson(
      this,
    );
  }
}

abstract class _TemplateDefaultsDto implements TemplateDefaultsDto {
  const factory _TemplateDefaultsDto(
      {@JsonKey(name: 'cash_location_id') final String? cashLocationId,
      @JsonKey(name: 'cash_location_name') final String? cashLocationName,
      @JsonKey(name: 'counterparty_id') final String? counterpartyId,
      @JsonKey(name: 'counterparty_name') final String? counterpartyName,
      @JsonKey(name: 'counterparty_store_id') final String? counterpartyStoreId,
      @JsonKey(name: 'counterparty_store_name')
      final String? counterpartyStoreName,
      @JsonKey(name: 'counterparty_cash_location_id')
      final String? counterpartyCashLocationId,
      @JsonKey(name: 'is_internal_counterparty')
      final bool isInternalCounterparty}) = _$TemplateDefaultsDtoImpl;

  factory _TemplateDefaultsDto.fromJson(Map<String, dynamic> json) =
      _$TemplateDefaultsDtoImpl.fromJson;

  /// Default cash location ID
  @override
  @JsonKey(name: 'cash_location_id')
  String? get cashLocationId;

  /// Default cash location name
  @override
  @JsonKey(name: 'cash_location_name')
  String? get cashLocationName;

  /// Default counterparty ID
  @override
  @JsonKey(name: 'counterparty_id')
  String? get counterpartyId;

  /// Default counterparty name
  @override
  @JsonKey(name: 'counterparty_name')
  String? get counterpartyName;

  /// Default counterparty store ID (internal)
  @override
  @JsonKey(name: 'counterparty_store_id')
  String? get counterpartyStoreId;

  /// Default counterparty store name (internal)
  @override
  @JsonKey(name: 'counterparty_store_name')
  String? get counterpartyStoreName;

  /// Default counterparty cash location ID
  @override
  @JsonKey(name: 'counterparty_cash_location_id')
  String? get counterpartyCashLocationId;

  /// Whether counterparty is internal
  @override
  @JsonKey(name: 'is_internal_counterparty')
  bool get isInternalCounterparty;

  /// Create a copy of TemplateDefaultsDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TemplateDefaultsDtoImplCopyWith<_$TemplateDefaultsDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

TemplateDisplayInfoDto _$TemplateDisplayInfoDtoFromJson(
    Map<String, dynamic> json) {
  return _TemplateDisplayInfoDto.fromJson(json);
}

/// @nodoc
mixin _$TemplateDisplayInfoDto {
  /// Debit category display name (e.g., 'Receivable')
  @JsonKey(name: 'debit_category')
  String get debitCategory => throw _privateConstructorUsedError;

  /// Credit category display name (e.g., 'Cash')
  @JsonKey(name: 'credit_category')
  String get creditCategory => throw _privateConstructorUsedError;

  /// Transaction type display (e.g., 'Receivable → Cash')
  @JsonKey(name: 'transaction_type')
  String get transactionType => throw _privateConstructorUsedError;

  /// Serializes this TemplateDisplayInfoDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of TemplateDisplayInfoDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TemplateDisplayInfoDtoCopyWith<TemplateDisplayInfoDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TemplateDisplayInfoDtoCopyWith<$Res> {
  factory $TemplateDisplayInfoDtoCopyWith(TemplateDisplayInfoDto value,
          $Res Function(TemplateDisplayInfoDto) then) =
      _$TemplateDisplayInfoDtoCopyWithImpl<$Res, TemplateDisplayInfoDto>;
  @useResult
  $Res call(
      {@JsonKey(name: 'debit_category') String debitCategory,
      @JsonKey(name: 'credit_category') String creditCategory,
      @JsonKey(name: 'transaction_type') String transactionType});
}

/// @nodoc
class _$TemplateDisplayInfoDtoCopyWithImpl<$Res,
        $Val extends TemplateDisplayInfoDto>
    implements $TemplateDisplayInfoDtoCopyWith<$Res> {
  _$TemplateDisplayInfoDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TemplateDisplayInfoDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? debitCategory = null,
    Object? creditCategory = null,
    Object? transactionType = null,
  }) {
    return _then(_value.copyWith(
      debitCategory: null == debitCategory
          ? _value.debitCategory
          : debitCategory // ignore: cast_nullable_to_non_nullable
              as String,
      creditCategory: null == creditCategory
          ? _value.creditCategory
          : creditCategory // ignore: cast_nullable_to_non_nullable
              as String,
      transactionType: null == transactionType
          ? _value.transactionType
          : transactionType // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$TemplateDisplayInfoDtoImplCopyWith<$Res>
    implements $TemplateDisplayInfoDtoCopyWith<$Res> {
  factory _$$TemplateDisplayInfoDtoImplCopyWith(
          _$TemplateDisplayInfoDtoImpl value,
          $Res Function(_$TemplateDisplayInfoDtoImpl) then) =
      __$$TemplateDisplayInfoDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'debit_category') String debitCategory,
      @JsonKey(name: 'credit_category') String creditCategory,
      @JsonKey(name: 'transaction_type') String transactionType});
}

/// @nodoc
class __$$TemplateDisplayInfoDtoImplCopyWithImpl<$Res>
    extends _$TemplateDisplayInfoDtoCopyWithImpl<$Res,
        _$TemplateDisplayInfoDtoImpl>
    implements _$$TemplateDisplayInfoDtoImplCopyWith<$Res> {
  __$$TemplateDisplayInfoDtoImplCopyWithImpl(
      _$TemplateDisplayInfoDtoImpl _value,
      $Res Function(_$TemplateDisplayInfoDtoImpl) _then)
      : super(_value, _then);

  /// Create a copy of TemplateDisplayInfoDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? debitCategory = null,
    Object? creditCategory = null,
    Object? transactionType = null,
  }) {
    return _then(_$TemplateDisplayInfoDtoImpl(
      debitCategory: null == debitCategory
          ? _value.debitCategory
          : debitCategory // ignore: cast_nullable_to_non_nullable
              as String,
      creditCategory: null == creditCategory
          ? _value.creditCategory
          : creditCategory // ignore: cast_nullable_to_non_nullable
              as String,
      transactionType: null == transactionType
          ? _value.transactionType
          : transactionType // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$TemplateDisplayInfoDtoImpl implements _TemplateDisplayInfoDto {
  const _$TemplateDisplayInfoDtoImpl(
      {@JsonKey(name: 'debit_category') this.debitCategory = 'Other',
      @JsonKey(name: 'credit_category') this.creditCategory = 'Other',
      @JsonKey(name: 'transaction_type') this.transactionType = ''});

  factory _$TemplateDisplayInfoDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$TemplateDisplayInfoDtoImplFromJson(json);

  /// Debit category display name (e.g., 'Receivable')
  @override
  @JsonKey(name: 'debit_category')
  final String debitCategory;

  /// Credit category display name (e.g., 'Cash')
  @override
  @JsonKey(name: 'credit_category')
  final String creditCategory;

  /// Transaction type display (e.g., 'Receivable → Cash')
  @override
  @JsonKey(name: 'transaction_type')
  final String transactionType;

  @override
  String toString() {
    return 'TemplateDisplayInfoDto(debitCategory: $debitCategory, creditCategory: $creditCategory, transactionType: $transactionType)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TemplateDisplayInfoDtoImpl &&
            (identical(other.debitCategory, debitCategory) ||
                other.debitCategory == debitCategory) &&
            (identical(other.creditCategory, creditCategory) ||
                other.creditCategory == creditCategory) &&
            (identical(other.transactionType, transactionType) ||
                other.transactionType == transactionType));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, debitCategory, creditCategory, transactionType);

  /// Create a copy of TemplateDisplayInfoDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TemplateDisplayInfoDtoImplCopyWith<_$TemplateDisplayInfoDtoImpl>
      get copyWith => __$$TemplateDisplayInfoDtoImplCopyWithImpl<
          _$TemplateDisplayInfoDtoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TemplateDisplayInfoDtoImplToJson(
      this,
    );
  }
}

abstract class _TemplateDisplayInfoDto implements TemplateDisplayInfoDto {
  const factory _TemplateDisplayInfoDto(
          {@JsonKey(name: 'debit_category') final String debitCategory,
          @JsonKey(name: 'credit_category') final String creditCategory,
          @JsonKey(name: 'transaction_type') final String transactionType}) =
      _$TemplateDisplayInfoDtoImpl;

  factory _TemplateDisplayInfoDto.fromJson(Map<String, dynamic> json) =
      _$TemplateDisplayInfoDtoImpl.fromJson;

  /// Debit category display name (e.g., 'Receivable')
  @override
  @JsonKey(name: 'debit_category')
  String get debitCategory;

  /// Credit category display name (e.g., 'Cash')
  @override
  @JsonKey(name: 'credit_category')
  String get creditCategory;

  /// Transaction type display (e.g., 'Receivable → Cash')
  @override
  @JsonKey(name: 'transaction_type')
  String get transactionType;

  /// Create a copy of TemplateDisplayInfoDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TemplateDisplayInfoDtoImplCopyWith<_$TemplateDisplayInfoDtoImpl>
      get copyWith => throw _privateConstructorUsedError;
}
