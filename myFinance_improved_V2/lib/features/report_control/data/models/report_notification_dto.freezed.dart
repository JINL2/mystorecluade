// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'report_notification_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ReportNotificationDto _$ReportNotificationDtoFromJson(
    Map<String, dynamic> json) {
  return _ReportNotificationDto.fromJson(json);
}

/// @nodoc
mixin _$ReportNotificationDto {
  @JsonKey(name: 'notification_id')
  String get notificationId => throw _privateConstructorUsedError;
  @JsonKey(name: 'title')
  String get title => throw _privateConstructorUsedError;
  @JsonKey(name: 'body')
  String get body => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_read')
  bool get isRead => throw _privateConstructorUsedError;
  @JsonKey(name: 'sent_at')
  DateTime? get sentAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  DateTime get createdAt =>
      throw _privateConstructorUsedError; // Report details
  @JsonKey(name: 'report_date')
  DateTime get reportDate => throw _privateConstructorUsedError;
  @JsonKey(name: 'session_id')
  String? get sessionId => throw _privateConstructorUsedError;
  @JsonKey(name: 'template_id')
  String? get templateId => throw _privateConstructorUsedError;
  @JsonKey(name: 'subscription_id')
  String? get subscriptionId =>
      throw _privateConstructorUsedError; // Template info (nullable - may not exist if template was deleted)
  @JsonKey(name: 'template_name')
  String? get templateName => throw _privateConstructorUsedError;
  @JsonKey(name: 'template_code')
  String? get templateCode => throw _privateConstructorUsedError;
  @JsonKey(name: 'template_icon')
  String? get templateIcon => throw _privateConstructorUsedError;
  @JsonKey(name: 'template_frequency')
  String? get templateFrequency =>
      throw _privateConstructorUsedError; // Category info
  @JsonKey(name: 'category_id')
  String? get categoryId => throw _privateConstructorUsedError;
  @JsonKey(name: 'category_name')
  String? get categoryName =>
      throw _privateConstructorUsedError; // Session status (nullable - may not exist for old reports)
  @JsonKey(name: 'session_status')
  String? get sessionStatus => throw _privateConstructorUsedError;
  @JsonKey(name: 'session_started_at')
  DateTime? get sessionStartedAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'session_completed_at')
  DateTime? get sessionCompletedAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'session_error_message')
  String? get sessionErrorMessage => throw _privateConstructorUsedError;
  @JsonKey(name: 'processing_time_ms')
  int? get processingTimeMs =>
      throw _privateConstructorUsedError; // Subscription info
  @JsonKey(name: 'subscription_enabled')
  bool? get subscriptionEnabled => throw _privateConstructorUsedError;
  @JsonKey(name: 'subscription_schedule_time')
  String? get subscriptionScheduleTime => throw _privateConstructorUsedError;
  @JsonKey(name: 'subscription_schedule_days')
  List<int>? get subscriptionScheduleDays =>
      throw _privateConstructorUsedError; // Store info
  @JsonKey(name: 'store_id')
  String? get storeId => throw _privateConstructorUsedError;
  @JsonKey(name: 'store_name')
  String? get storeName => throw _privateConstructorUsedError; // Company info
  @JsonKey(name: 'company_id')
  String? get companyId => throw _privateConstructorUsedError;

  /// Serializes this ReportNotificationDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ReportNotificationDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ReportNotificationDtoCopyWith<ReportNotificationDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ReportNotificationDtoCopyWith<$Res> {
  factory $ReportNotificationDtoCopyWith(ReportNotificationDto value,
          $Res Function(ReportNotificationDto) then) =
      _$ReportNotificationDtoCopyWithImpl<$Res, ReportNotificationDto>;
  @useResult
  $Res call(
      {@JsonKey(name: 'notification_id') String notificationId,
      @JsonKey(name: 'title') String title,
      @JsonKey(name: 'body') String body,
      @JsonKey(name: 'is_read') bool isRead,
      @JsonKey(name: 'sent_at') DateTime? sentAt,
      @JsonKey(name: 'created_at') DateTime createdAt,
      @JsonKey(name: 'report_date') DateTime reportDate,
      @JsonKey(name: 'session_id') String? sessionId,
      @JsonKey(name: 'template_id') String? templateId,
      @JsonKey(name: 'subscription_id') String? subscriptionId,
      @JsonKey(name: 'template_name') String? templateName,
      @JsonKey(name: 'template_code') String? templateCode,
      @JsonKey(name: 'template_icon') String? templateIcon,
      @JsonKey(name: 'template_frequency') String? templateFrequency,
      @JsonKey(name: 'category_id') String? categoryId,
      @JsonKey(name: 'category_name') String? categoryName,
      @JsonKey(name: 'session_status') String? sessionStatus,
      @JsonKey(name: 'session_started_at') DateTime? sessionStartedAt,
      @JsonKey(name: 'session_completed_at') DateTime? sessionCompletedAt,
      @JsonKey(name: 'session_error_message') String? sessionErrorMessage,
      @JsonKey(name: 'processing_time_ms') int? processingTimeMs,
      @JsonKey(name: 'subscription_enabled') bool? subscriptionEnabled,
      @JsonKey(name: 'subscription_schedule_time')
      String? subscriptionScheduleTime,
      @JsonKey(name: 'subscription_schedule_days')
      List<int>? subscriptionScheduleDays,
      @JsonKey(name: 'store_id') String? storeId,
      @JsonKey(name: 'store_name') String? storeName,
      @JsonKey(name: 'company_id') String? companyId});
}

/// @nodoc
class _$ReportNotificationDtoCopyWithImpl<$Res,
        $Val extends ReportNotificationDto>
    implements $ReportNotificationDtoCopyWith<$Res> {
  _$ReportNotificationDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ReportNotificationDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? notificationId = null,
    Object? title = null,
    Object? body = null,
    Object? isRead = null,
    Object? sentAt = freezed,
    Object? createdAt = null,
    Object? reportDate = null,
    Object? sessionId = freezed,
    Object? templateId = freezed,
    Object? subscriptionId = freezed,
    Object? templateName = freezed,
    Object? templateCode = freezed,
    Object? templateIcon = freezed,
    Object? templateFrequency = freezed,
    Object? categoryId = freezed,
    Object? categoryName = freezed,
    Object? sessionStatus = freezed,
    Object? sessionStartedAt = freezed,
    Object? sessionCompletedAt = freezed,
    Object? sessionErrorMessage = freezed,
    Object? processingTimeMs = freezed,
    Object? subscriptionEnabled = freezed,
    Object? subscriptionScheduleTime = freezed,
    Object? subscriptionScheduleDays = freezed,
    Object? storeId = freezed,
    Object? storeName = freezed,
    Object? companyId = freezed,
  }) {
    return _then(_value.copyWith(
      notificationId: null == notificationId
          ? _value.notificationId
          : notificationId // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      body: null == body
          ? _value.body
          : body // ignore: cast_nullable_to_non_nullable
              as String,
      isRead: null == isRead
          ? _value.isRead
          : isRead // ignore: cast_nullable_to_non_nullable
              as bool,
      sentAt: freezed == sentAt
          ? _value.sentAt
          : sentAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      reportDate: null == reportDate
          ? _value.reportDate
          : reportDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      sessionId: freezed == sessionId
          ? _value.sessionId
          : sessionId // ignore: cast_nullable_to_non_nullable
              as String?,
      templateId: freezed == templateId
          ? _value.templateId
          : templateId // ignore: cast_nullable_to_non_nullable
              as String?,
      subscriptionId: freezed == subscriptionId
          ? _value.subscriptionId
          : subscriptionId // ignore: cast_nullable_to_non_nullable
              as String?,
      templateName: freezed == templateName
          ? _value.templateName
          : templateName // ignore: cast_nullable_to_non_nullable
              as String?,
      templateCode: freezed == templateCode
          ? _value.templateCode
          : templateCode // ignore: cast_nullable_to_non_nullable
              as String?,
      templateIcon: freezed == templateIcon
          ? _value.templateIcon
          : templateIcon // ignore: cast_nullable_to_non_nullable
              as String?,
      templateFrequency: freezed == templateFrequency
          ? _value.templateFrequency
          : templateFrequency // ignore: cast_nullable_to_non_nullable
              as String?,
      categoryId: freezed == categoryId
          ? _value.categoryId
          : categoryId // ignore: cast_nullable_to_non_nullable
              as String?,
      categoryName: freezed == categoryName
          ? _value.categoryName
          : categoryName // ignore: cast_nullable_to_non_nullable
              as String?,
      sessionStatus: freezed == sessionStatus
          ? _value.sessionStatus
          : sessionStatus // ignore: cast_nullable_to_non_nullable
              as String?,
      sessionStartedAt: freezed == sessionStartedAt
          ? _value.sessionStartedAt
          : sessionStartedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      sessionCompletedAt: freezed == sessionCompletedAt
          ? _value.sessionCompletedAt
          : sessionCompletedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      sessionErrorMessage: freezed == sessionErrorMessage
          ? _value.sessionErrorMessage
          : sessionErrorMessage // ignore: cast_nullable_to_non_nullable
              as String?,
      processingTimeMs: freezed == processingTimeMs
          ? _value.processingTimeMs
          : processingTimeMs // ignore: cast_nullable_to_non_nullable
              as int?,
      subscriptionEnabled: freezed == subscriptionEnabled
          ? _value.subscriptionEnabled
          : subscriptionEnabled // ignore: cast_nullable_to_non_nullable
              as bool?,
      subscriptionScheduleTime: freezed == subscriptionScheduleTime
          ? _value.subscriptionScheduleTime
          : subscriptionScheduleTime // ignore: cast_nullable_to_non_nullable
              as String?,
      subscriptionScheduleDays: freezed == subscriptionScheduleDays
          ? _value.subscriptionScheduleDays
          : subscriptionScheduleDays // ignore: cast_nullable_to_non_nullable
              as List<int>?,
      storeId: freezed == storeId
          ? _value.storeId
          : storeId // ignore: cast_nullable_to_non_nullable
              as String?,
      storeName: freezed == storeName
          ? _value.storeName
          : storeName // ignore: cast_nullable_to_non_nullable
              as String?,
      companyId: freezed == companyId
          ? _value.companyId
          : companyId // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ReportNotificationDtoImplCopyWith<$Res>
    implements $ReportNotificationDtoCopyWith<$Res> {
  factory _$$ReportNotificationDtoImplCopyWith(
          _$ReportNotificationDtoImpl value,
          $Res Function(_$ReportNotificationDtoImpl) then) =
      __$$ReportNotificationDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'notification_id') String notificationId,
      @JsonKey(name: 'title') String title,
      @JsonKey(name: 'body') String body,
      @JsonKey(name: 'is_read') bool isRead,
      @JsonKey(name: 'sent_at') DateTime? sentAt,
      @JsonKey(name: 'created_at') DateTime createdAt,
      @JsonKey(name: 'report_date') DateTime reportDate,
      @JsonKey(name: 'session_id') String? sessionId,
      @JsonKey(name: 'template_id') String? templateId,
      @JsonKey(name: 'subscription_id') String? subscriptionId,
      @JsonKey(name: 'template_name') String? templateName,
      @JsonKey(name: 'template_code') String? templateCode,
      @JsonKey(name: 'template_icon') String? templateIcon,
      @JsonKey(name: 'template_frequency') String? templateFrequency,
      @JsonKey(name: 'category_id') String? categoryId,
      @JsonKey(name: 'category_name') String? categoryName,
      @JsonKey(name: 'session_status') String? sessionStatus,
      @JsonKey(name: 'session_started_at') DateTime? sessionStartedAt,
      @JsonKey(name: 'session_completed_at') DateTime? sessionCompletedAt,
      @JsonKey(name: 'session_error_message') String? sessionErrorMessage,
      @JsonKey(name: 'processing_time_ms') int? processingTimeMs,
      @JsonKey(name: 'subscription_enabled') bool? subscriptionEnabled,
      @JsonKey(name: 'subscription_schedule_time')
      String? subscriptionScheduleTime,
      @JsonKey(name: 'subscription_schedule_days')
      List<int>? subscriptionScheduleDays,
      @JsonKey(name: 'store_id') String? storeId,
      @JsonKey(name: 'store_name') String? storeName,
      @JsonKey(name: 'company_id') String? companyId});
}

/// @nodoc
class __$$ReportNotificationDtoImplCopyWithImpl<$Res>
    extends _$ReportNotificationDtoCopyWithImpl<$Res,
        _$ReportNotificationDtoImpl>
    implements _$$ReportNotificationDtoImplCopyWith<$Res> {
  __$$ReportNotificationDtoImplCopyWithImpl(_$ReportNotificationDtoImpl _value,
      $Res Function(_$ReportNotificationDtoImpl) _then)
      : super(_value, _then);

  /// Create a copy of ReportNotificationDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? notificationId = null,
    Object? title = null,
    Object? body = null,
    Object? isRead = null,
    Object? sentAt = freezed,
    Object? createdAt = null,
    Object? reportDate = null,
    Object? sessionId = freezed,
    Object? templateId = freezed,
    Object? subscriptionId = freezed,
    Object? templateName = freezed,
    Object? templateCode = freezed,
    Object? templateIcon = freezed,
    Object? templateFrequency = freezed,
    Object? categoryId = freezed,
    Object? categoryName = freezed,
    Object? sessionStatus = freezed,
    Object? sessionStartedAt = freezed,
    Object? sessionCompletedAt = freezed,
    Object? sessionErrorMessage = freezed,
    Object? processingTimeMs = freezed,
    Object? subscriptionEnabled = freezed,
    Object? subscriptionScheduleTime = freezed,
    Object? subscriptionScheduleDays = freezed,
    Object? storeId = freezed,
    Object? storeName = freezed,
    Object? companyId = freezed,
  }) {
    return _then(_$ReportNotificationDtoImpl(
      notificationId: null == notificationId
          ? _value.notificationId
          : notificationId // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      body: null == body
          ? _value.body
          : body // ignore: cast_nullable_to_non_nullable
              as String,
      isRead: null == isRead
          ? _value.isRead
          : isRead // ignore: cast_nullable_to_non_nullable
              as bool,
      sentAt: freezed == sentAt
          ? _value.sentAt
          : sentAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      reportDate: null == reportDate
          ? _value.reportDate
          : reportDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      sessionId: freezed == sessionId
          ? _value.sessionId
          : sessionId // ignore: cast_nullable_to_non_nullable
              as String?,
      templateId: freezed == templateId
          ? _value.templateId
          : templateId // ignore: cast_nullable_to_non_nullable
              as String?,
      subscriptionId: freezed == subscriptionId
          ? _value.subscriptionId
          : subscriptionId // ignore: cast_nullable_to_non_nullable
              as String?,
      templateName: freezed == templateName
          ? _value.templateName
          : templateName // ignore: cast_nullable_to_non_nullable
              as String?,
      templateCode: freezed == templateCode
          ? _value.templateCode
          : templateCode // ignore: cast_nullable_to_non_nullable
              as String?,
      templateIcon: freezed == templateIcon
          ? _value.templateIcon
          : templateIcon // ignore: cast_nullable_to_non_nullable
              as String?,
      templateFrequency: freezed == templateFrequency
          ? _value.templateFrequency
          : templateFrequency // ignore: cast_nullable_to_non_nullable
              as String?,
      categoryId: freezed == categoryId
          ? _value.categoryId
          : categoryId // ignore: cast_nullable_to_non_nullable
              as String?,
      categoryName: freezed == categoryName
          ? _value.categoryName
          : categoryName // ignore: cast_nullable_to_non_nullable
              as String?,
      sessionStatus: freezed == sessionStatus
          ? _value.sessionStatus
          : sessionStatus // ignore: cast_nullable_to_non_nullable
              as String?,
      sessionStartedAt: freezed == sessionStartedAt
          ? _value.sessionStartedAt
          : sessionStartedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      sessionCompletedAt: freezed == sessionCompletedAt
          ? _value.sessionCompletedAt
          : sessionCompletedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      sessionErrorMessage: freezed == sessionErrorMessage
          ? _value.sessionErrorMessage
          : sessionErrorMessage // ignore: cast_nullable_to_non_nullable
              as String?,
      processingTimeMs: freezed == processingTimeMs
          ? _value.processingTimeMs
          : processingTimeMs // ignore: cast_nullable_to_non_nullable
              as int?,
      subscriptionEnabled: freezed == subscriptionEnabled
          ? _value.subscriptionEnabled
          : subscriptionEnabled // ignore: cast_nullable_to_non_nullable
              as bool?,
      subscriptionScheduleTime: freezed == subscriptionScheduleTime
          ? _value.subscriptionScheduleTime
          : subscriptionScheduleTime // ignore: cast_nullable_to_non_nullable
              as String?,
      subscriptionScheduleDays: freezed == subscriptionScheduleDays
          ? _value._subscriptionScheduleDays
          : subscriptionScheduleDays // ignore: cast_nullable_to_non_nullable
              as List<int>?,
      storeId: freezed == storeId
          ? _value.storeId
          : storeId // ignore: cast_nullable_to_non_nullable
              as String?,
      storeName: freezed == storeName
          ? _value.storeName
          : storeName // ignore: cast_nullable_to_non_nullable
              as String?,
      companyId: freezed == companyId
          ? _value.companyId
          : companyId // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ReportNotificationDtoImpl extends _ReportNotificationDto {
  const _$ReportNotificationDtoImpl(
      {@JsonKey(name: 'notification_id') required this.notificationId,
      @JsonKey(name: 'title') required this.title,
      @JsonKey(name: 'body') required this.body,
      @JsonKey(name: 'is_read') required this.isRead,
      @JsonKey(name: 'sent_at') this.sentAt,
      @JsonKey(name: 'created_at') required this.createdAt,
      @JsonKey(name: 'report_date') required this.reportDate,
      @JsonKey(name: 'session_id') this.sessionId,
      @JsonKey(name: 'template_id') this.templateId,
      @JsonKey(name: 'subscription_id') this.subscriptionId,
      @JsonKey(name: 'template_name') this.templateName,
      @JsonKey(name: 'template_code') this.templateCode,
      @JsonKey(name: 'template_icon') this.templateIcon,
      @JsonKey(name: 'template_frequency') this.templateFrequency,
      @JsonKey(name: 'category_id') this.categoryId,
      @JsonKey(name: 'category_name') this.categoryName,
      @JsonKey(name: 'session_status') this.sessionStatus,
      @JsonKey(name: 'session_started_at') this.sessionStartedAt,
      @JsonKey(name: 'session_completed_at') this.sessionCompletedAt,
      @JsonKey(name: 'session_error_message') this.sessionErrorMessage,
      @JsonKey(name: 'processing_time_ms') this.processingTimeMs,
      @JsonKey(name: 'subscription_enabled') this.subscriptionEnabled,
      @JsonKey(name: 'subscription_schedule_time')
      this.subscriptionScheduleTime,
      @JsonKey(name: 'subscription_schedule_days')
      final List<int>? subscriptionScheduleDays,
      @JsonKey(name: 'store_id') this.storeId,
      @JsonKey(name: 'store_name') this.storeName,
      @JsonKey(name: 'company_id') this.companyId})
      : _subscriptionScheduleDays = subscriptionScheduleDays,
        super._();

  factory _$ReportNotificationDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$ReportNotificationDtoImplFromJson(json);

  @override
  @JsonKey(name: 'notification_id')
  final String notificationId;
  @override
  @JsonKey(name: 'title')
  final String title;
  @override
  @JsonKey(name: 'body')
  final String body;
  @override
  @JsonKey(name: 'is_read')
  final bool isRead;
  @override
  @JsonKey(name: 'sent_at')
  final DateTime? sentAt;
  @override
  @JsonKey(name: 'created_at')
  final DateTime createdAt;
// Report details
  @override
  @JsonKey(name: 'report_date')
  final DateTime reportDate;
  @override
  @JsonKey(name: 'session_id')
  final String? sessionId;
  @override
  @JsonKey(name: 'template_id')
  final String? templateId;
  @override
  @JsonKey(name: 'subscription_id')
  final String? subscriptionId;
// Template info (nullable - may not exist if template was deleted)
  @override
  @JsonKey(name: 'template_name')
  final String? templateName;
  @override
  @JsonKey(name: 'template_code')
  final String? templateCode;
  @override
  @JsonKey(name: 'template_icon')
  final String? templateIcon;
  @override
  @JsonKey(name: 'template_frequency')
  final String? templateFrequency;
// Category info
  @override
  @JsonKey(name: 'category_id')
  final String? categoryId;
  @override
  @JsonKey(name: 'category_name')
  final String? categoryName;
// Session status (nullable - may not exist for old reports)
  @override
  @JsonKey(name: 'session_status')
  final String? sessionStatus;
  @override
  @JsonKey(name: 'session_started_at')
  final DateTime? sessionStartedAt;
  @override
  @JsonKey(name: 'session_completed_at')
  final DateTime? sessionCompletedAt;
  @override
  @JsonKey(name: 'session_error_message')
  final String? sessionErrorMessage;
  @override
  @JsonKey(name: 'processing_time_ms')
  final int? processingTimeMs;
// Subscription info
  @override
  @JsonKey(name: 'subscription_enabled')
  final bool? subscriptionEnabled;
  @override
  @JsonKey(name: 'subscription_schedule_time')
  final String? subscriptionScheduleTime;
  final List<int>? _subscriptionScheduleDays;
  @override
  @JsonKey(name: 'subscription_schedule_days')
  List<int>? get subscriptionScheduleDays {
    final value = _subscriptionScheduleDays;
    if (value == null) return null;
    if (_subscriptionScheduleDays is EqualUnmodifiableListView)
      return _subscriptionScheduleDays;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

// Store info
  @override
  @JsonKey(name: 'store_id')
  final String? storeId;
  @override
  @JsonKey(name: 'store_name')
  final String? storeName;
// Company info
  @override
  @JsonKey(name: 'company_id')
  final String? companyId;

  @override
  String toString() {
    return 'ReportNotificationDto(notificationId: $notificationId, title: $title, body: $body, isRead: $isRead, sentAt: $sentAt, createdAt: $createdAt, reportDate: $reportDate, sessionId: $sessionId, templateId: $templateId, subscriptionId: $subscriptionId, templateName: $templateName, templateCode: $templateCode, templateIcon: $templateIcon, templateFrequency: $templateFrequency, categoryId: $categoryId, categoryName: $categoryName, sessionStatus: $sessionStatus, sessionStartedAt: $sessionStartedAt, sessionCompletedAt: $sessionCompletedAt, sessionErrorMessage: $sessionErrorMessage, processingTimeMs: $processingTimeMs, subscriptionEnabled: $subscriptionEnabled, subscriptionScheduleTime: $subscriptionScheduleTime, subscriptionScheduleDays: $subscriptionScheduleDays, storeId: $storeId, storeName: $storeName, companyId: $companyId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ReportNotificationDtoImpl &&
            (identical(other.notificationId, notificationId) ||
                other.notificationId == notificationId) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.body, body) || other.body == body) &&
            (identical(other.isRead, isRead) || other.isRead == isRead) &&
            (identical(other.sentAt, sentAt) || other.sentAt == sentAt) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.reportDate, reportDate) ||
                other.reportDate == reportDate) &&
            (identical(other.sessionId, sessionId) ||
                other.sessionId == sessionId) &&
            (identical(other.templateId, templateId) ||
                other.templateId == templateId) &&
            (identical(other.subscriptionId, subscriptionId) ||
                other.subscriptionId == subscriptionId) &&
            (identical(other.templateName, templateName) ||
                other.templateName == templateName) &&
            (identical(other.templateCode, templateCode) ||
                other.templateCode == templateCode) &&
            (identical(other.templateIcon, templateIcon) ||
                other.templateIcon == templateIcon) &&
            (identical(other.templateFrequency, templateFrequency) ||
                other.templateFrequency == templateFrequency) &&
            (identical(other.categoryId, categoryId) ||
                other.categoryId == categoryId) &&
            (identical(other.categoryName, categoryName) ||
                other.categoryName == categoryName) &&
            (identical(other.sessionStatus, sessionStatus) ||
                other.sessionStatus == sessionStatus) &&
            (identical(other.sessionStartedAt, sessionStartedAt) ||
                other.sessionStartedAt == sessionStartedAt) &&
            (identical(other.sessionCompletedAt, sessionCompletedAt) ||
                other.sessionCompletedAt == sessionCompletedAt) &&
            (identical(other.sessionErrorMessage, sessionErrorMessage) ||
                other.sessionErrorMessage == sessionErrorMessage) &&
            (identical(other.processingTimeMs, processingTimeMs) ||
                other.processingTimeMs == processingTimeMs) &&
            (identical(other.subscriptionEnabled, subscriptionEnabled) ||
                other.subscriptionEnabled == subscriptionEnabled) &&
            (identical(
                    other.subscriptionScheduleTime, subscriptionScheduleTime) ||
                other.subscriptionScheduleTime == subscriptionScheduleTime) &&
            const DeepCollectionEquality().equals(
                other._subscriptionScheduleDays, _subscriptionScheduleDays) &&
            (identical(other.storeId, storeId) || other.storeId == storeId) &&
            (identical(other.storeName, storeName) ||
                other.storeName == storeName) &&
            (identical(other.companyId, companyId) ||
                other.companyId == companyId));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        notificationId,
        title,
        body,
        isRead,
        sentAt,
        createdAt,
        reportDate,
        sessionId,
        templateId,
        subscriptionId,
        templateName,
        templateCode,
        templateIcon,
        templateFrequency,
        categoryId,
        categoryName,
        sessionStatus,
        sessionStartedAt,
        sessionCompletedAt,
        sessionErrorMessage,
        processingTimeMs,
        subscriptionEnabled,
        subscriptionScheduleTime,
        const DeepCollectionEquality().hash(_subscriptionScheduleDays),
        storeId,
        storeName,
        companyId
      ]);

  /// Create a copy of ReportNotificationDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ReportNotificationDtoImplCopyWith<_$ReportNotificationDtoImpl>
      get copyWith => __$$ReportNotificationDtoImplCopyWithImpl<
          _$ReportNotificationDtoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ReportNotificationDtoImplToJson(
      this,
    );
  }
}

abstract class _ReportNotificationDto extends ReportNotificationDto {
  const factory _ReportNotificationDto(
      {@JsonKey(name: 'notification_id') required final String notificationId,
      @JsonKey(name: 'title') required final String title,
      @JsonKey(name: 'body') required final String body,
      @JsonKey(name: 'is_read') required final bool isRead,
      @JsonKey(name: 'sent_at') final DateTime? sentAt,
      @JsonKey(name: 'created_at') required final DateTime createdAt,
      @JsonKey(name: 'report_date') required final DateTime reportDate,
      @JsonKey(name: 'session_id') final String? sessionId,
      @JsonKey(name: 'template_id') final String? templateId,
      @JsonKey(name: 'subscription_id') final String? subscriptionId,
      @JsonKey(name: 'template_name') final String? templateName,
      @JsonKey(name: 'template_code') final String? templateCode,
      @JsonKey(name: 'template_icon') final String? templateIcon,
      @JsonKey(name: 'template_frequency') final String? templateFrequency,
      @JsonKey(name: 'category_id') final String? categoryId,
      @JsonKey(name: 'category_name') final String? categoryName,
      @JsonKey(name: 'session_status') final String? sessionStatus,
      @JsonKey(name: 'session_started_at') final DateTime? sessionStartedAt,
      @JsonKey(name: 'session_completed_at') final DateTime? sessionCompletedAt,
      @JsonKey(name: 'session_error_message') final String? sessionErrorMessage,
      @JsonKey(name: 'processing_time_ms') final int? processingTimeMs,
      @JsonKey(name: 'subscription_enabled') final bool? subscriptionEnabled,
      @JsonKey(name: 'subscription_schedule_time')
      final String? subscriptionScheduleTime,
      @JsonKey(name: 'subscription_schedule_days')
      final List<int>? subscriptionScheduleDays,
      @JsonKey(name: 'store_id') final String? storeId,
      @JsonKey(name: 'store_name') final String? storeName,
      @JsonKey(name: 'company_id')
      final String? companyId}) = _$ReportNotificationDtoImpl;
  const _ReportNotificationDto._() : super._();

  factory _ReportNotificationDto.fromJson(Map<String, dynamic> json) =
      _$ReportNotificationDtoImpl.fromJson;

  @override
  @JsonKey(name: 'notification_id')
  String get notificationId;
  @override
  @JsonKey(name: 'title')
  String get title;
  @override
  @JsonKey(name: 'body')
  String get body;
  @override
  @JsonKey(name: 'is_read')
  bool get isRead;
  @override
  @JsonKey(name: 'sent_at')
  DateTime? get sentAt;
  @override
  @JsonKey(name: 'created_at')
  DateTime get createdAt; // Report details
  @override
  @JsonKey(name: 'report_date')
  DateTime get reportDate;
  @override
  @JsonKey(name: 'session_id')
  String? get sessionId;
  @override
  @JsonKey(name: 'template_id')
  String? get templateId;
  @override
  @JsonKey(name: 'subscription_id')
  String?
      get subscriptionId; // Template info (nullable - may not exist if template was deleted)
  @override
  @JsonKey(name: 'template_name')
  String? get templateName;
  @override
  @JsonKey(name: 'template_code')
  String? get templateCode;
  @override
  @JsonKey(name: 'template_icon')
  String? get templateIcon;
  @override
  @JsonKey(name: 'template_frequency')
  String? get templateFrequency; // Category info
  @override
  @JsonKey(name: 'category_id')
  String? get categoryId;
  @override
  @JsonKey(name: 'category_name')
  String?
      get categoryName; // Session status (nullable - may not exist for old reports)
  @override
  @JsonKey(name: 'session_status')
  String? get sessionStatus;
  @override
  @JsonKey(name: 'session_started_at')
  DateTime? get sessionStartedAt;
  @override
  @JsonKey(name: 'session_completed_at')
  DateTime? get sessionCompletedAt;
  @override
  @JsonKey(name: 'session_error_message')
  String? get sessionErrorMessage;
  @override
  @JsonKey(name: 'processing_time_ms')
  int? get processingTimeMs; // Subscription info
  @override
  @JsonKey(name: 'subscription_enabled')
  bool? get subscriptionEnabled;
  @override
  @JsonKey(name: 'subscription_schedule_time')
  String? get subscriptionScheduleTime;
  @override
  @JsonKey(name: 'subscription_schedule_days')
  List<int>? get subscriptionScheduleDays; // Store info
  @override
  @JsonKey(name: 'store_id')
  String? get storeId;
  @override
  @JsonKey(name: 'store_name')
  String? get storeName; // Company info
  @override
  @JsonKey(name: 'company_id')
  String? get companyId;

  /// Create a copy of ReportNotificationDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ReportNotificationDtoImplCopyWith<_$ReportNotificationDtoImpl>
      get copyWith => throw _privateConstructorUsedError;
}
