// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'report_notification.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$ReportNotification {
  String get notificationId => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String get body =>
      throw _privateConstructorUsedError; // Full report content in markdown
  bool get isRead => throw _privateConstructorUsedError;
  DateTime? get sentAt => throw _privateConstructorUsedError;
  DateTime get createdAt =>
      throw _privateConstructorUsedError; // Report details
  DateTime get reportDate => throw _privateConstructorUsedError;
  String get sessionId => throw _privateConstructorUsedError;
  String get templateId => throw _privateConstructorUsedError;
  String? get subscriptionId =>
      throw _privateConstructorUsedError; // Template info
  String get templateName => throw _privateConstructorUsedError;
  String get templateCode => throw _privateConstructorUsedError;
  String? get templateIcon => throw _privateConstructorUsedError;
  String get templateFrequency =>
      throw _privateConstructorUsedError; // Category info
  String? get categoryId => throw _privateConstructorUsedError;
  String? get categoryName =>
      throw _privateConstructorUsedError; // Session status
  String get sessionStatus =>
      throw _privateConstructorUsedError; // 'pending', 'processing', 'completed', 'failed'
  DateTime? get sessionStartedAt => throw _privateConstructorUsedError;
  DateTime? get sessionCompletedAt => throw _privateConstructorUsedError;
  String? get sessionErrorMessage => throw _privateConstructorUsedError;
  int? get processingTimeMs =>
      throw _privateConstructorUsedError; // Subscription info
  bool? get subscriptionEnabled => throw _privateConstructorUsedError;
  String? get subscriptionScheduleTime => throw _privateConstructorUsedError;
  List<int>? get subscriptionScheduleDays =>
      throw _privateConstructorUsedError; // Store info
  String? get storeId => throw _privateConstructorUsedError;
  String? get storeName => throw _privateConstructorUsedError; // Company info
  String? get companyId => throw _privateConstructorUsedError;

  /// Create a copy of ReportNotification
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ReportNotificationCopyWith<ReportNotification> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ReportNotificationCopyWith<$Res> {
  factory $ReportNotificationCopyWith(
          ReportNotification value, $Res Function(ReportNotification) then) =
      _$ReportNotificationCopyWithImpl<$Res, ReportNotification>;
  @useResult
  $Res call(
      {String notificationId,
      String title,
      String body,
      bool isRead,
      DateTime? sentAt,
      DateTime createdAt,
      DateTime reportDate,
      String sessionId,
      String templateId,
      String? subscriptionId,
      String templateName,
      String templateCode,
      String? templateIcon,
      String templateFrequency,
      String? categoryId,
      String? categoryName,
      String sessionStatus,
      DateTime? sessionStartedAt,
      DateTime? sessionCompletedAt,
      String? sessionErrorMessage,
      int? processingTimeMs,
      bool? subscriptionEnabled,
      String? subscriptionScheduleTime,
      List<int>? subscriptionScheduleDays,
      String? storeId,
      String? storeName,
      String? companyId});
}

/// @nodoc
class _$ReportNotificationCopyWithImpl<$Res, $Val extends ReportNotification>
    implements $ReportNotificationCopyWith<$Res> {
  _$ReportNotificationCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ReportNotification
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
    Object? sessionId = null,
    Object? templateId = null,
    Object? subscriptionId = freezed,
    Object? templateName = null,
    Object? templateCode = null,
    Object? templateIcon = freezed,
    Object? templateFrequency = null,
    Object? categoryId = freezed,
    Object? categoryName = freezed,
    Object? sessionStatus = null,
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
      sessionId: null == sessionId
          ? _value.sessionId
          : sessionId // ignore: cast_nullable_to_non_nullable
              as String,
      templateId: null == templateId
          ? _value.templateId
          : templateId // ignore: cast_nullable_to_non_nullable
              as String,
      subscriptionId: freezed == subscriptionId
          ? _value.subscriptionId
          : subscriptionId // ignore: cast_nullable_to_non_nullable
              as String?,
      templateName: null == templateName
          ? _value.templateName
          : templateName // ignore: cast_nullable_to_non_nullable
              as String,
      templateCode: null == templateCode
          ? _value.templateCode
          : templateCode // ignore: cast_nullable_to_non_nullable
              as String,
      templateIcon: freezed == templateIcon
          ? _value.templateIcon
          : templateIcon // ignore: cast_nullable_to_non_nullable
              as String?,
      templateFrequency: null == templateFrequency
          ? _value.templateFrequency
          : templateFrequency // ignore: cast_nullable_to_non_nullable
              as String,
      categoryId: freezed == categoryId
          ? _value.categoryId
          : categoryId // ignore: cast_nullable_to_non_nullable
              as String?,
      categoryName: freezed == categoryName
          ? _value.categoryName
          : categoryName // ignore: cast_nullable_to_non_nullable
              as String?,
      sessionStatus: null == sessionStatus
          ? _value.sessionStatus
          : sessionStatus // ignore: cast_nullable_to_non_nullable
              as String,
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
abstract class _$$ReportNotificationImplCopyWith<$Res>
    implements $ReportNotificationCopyWith<$Res> {
  factory _$$ReportNotificationImplCopyWith(_$ReportNotificationImpl value,
          $Res Function(_$ReportNotificationImpl) then) =
      __$$ReportNotificationImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String notificationId,
      String title,
      String body,
      bool isRead,
      DateTime? sentAt,
      DateTime createdAt,
      DateTime reportDate,
      String sessionId,
      String templateId,
      String? subscriptionId,
      String templateName,
      String templateCode,
      String? templateIcon,
      String templateFrequency,
      String? categoryId,
      String? categoryName,
      String sessionStatus,
      DateTime? sessionStartedAt,
      DateTime? sessionCompletedAt,
      String? sessionErrorMessage,
      int? processingTimeMs,
      bool? subscriptionEnabled,
      String? subscriptionScheduleTime,
      List<int>? subscriptionScheduleDays,
      String? storeId,
      String? storeName,
      String? companyId});
}

/// @nodoc
class __$$ReportNotificationImplCopyWithImpl<$Res>
    extends _$ReportNotificationCopyWithImpl<$Res, _$ReportNotificationImpl>
    implements _$$ReportNotificationImplCopyWith<$Res> {
  __$$ReportNotificationImplCopyWithImpl(_$ReportNotificationImpl _value,
      $Res Function(_$ReportNotificationImpl) _then)
      : super(_value, _then);

  /// Create a copy of ReportNotification
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
    Object? sessionId = null,
    Object? templateId = null,
    Object? subscriptionId = freezed,
    Object? templateName = null,
    Object? templateCode = null,
    Object? templateIcon = freezed,
    Object? templateFrequency = null,
    Object? categoryId = freezed,
    Object? categoryName = freezed,
    Object? sessionStatus = null,
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
    return _then(_$ReportNotificationImpl(
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
      sessionId: null == sessionId
          ? _value.sessionId
          : sessionId // ignore: cast_nullable_to_non_nullable
              as String,
      templateId: null == templateId
          ? _value.templateId
          : templateId // ignore: cast_nullable_to_non_nullable
              as String,
      subscriptionId: freezed == subscriptionId
          ? _value.subscriptionId
          : subscriptionId // ignore: cast_nullable_to_non_nullable
              as String?,
      templateName: null == templateName
          ? _value.templateName
          : templateName // ignore: cast_nullable_to_non_nullable
              as String,
      templateCode: null == templateCode
          ? _value.templateCode
          : templateCode // ignore: cast_nullable_to_non_nullable
              as String,
      templateIcon: freezed == templateIcon
          ? _value.templateIcon
          : templateIcon // ignore: cast_nullable_to_non_nullable
              as String?,
      templateFrequency: null == templateFrequency
          ? _value.templateFrequency
          : templateFrequency // ignore: cast_nullable_to_non_nullable
              as String,
      categoryId: freezed == categoryId
          ? _value.categoryId
          : categoryId // ignore: cast_nullable_to_non_nullable
              as String?,
      categoryName: freezed == categoryName
          ? _value.categoryName
          : categoryName // ignore: cast_nullable_to_non_nullable
              as String?,
      sessionStatus: null == sessionStatus
          ? _value.sessionStatus
          : sessionStatus // ignore: cast_nullable_to_non_nullable
              as String,
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

class _$ReportNotificationImpl extends _ReportNotification {
  const _$ReportNotificationImpl(
      {required this.notificationId,
      required this.title,
      required this.body,
      required this.isRead,
      this.sentAt,
      required this.createdAt,
      required this.reportDate,
      required this.sessionId,
      required this.templateId,
      this.subscriptionId,
      required this.templateName,
      required this.templateCode,
      this.templateIcon,
      required this.templateFrequency,
      this.categoryId,
      this.categoryName,
      required this.sessionStatus,
      this.sessionStartedAt,
      this.sessionCompletedAt,
      this.sessionErrorMessage,
      this.processingTimeMs,
      this.subscriptionEnabled,
      this.subscriptionScheduleTime,
      final List<int>? subscriptionScheduleDays,
      this.storeId,
      this.storeName,
      this.companyId})
      : _subscriptionScheduleDays = subscriptionScheduleDays,
        super._();

  @override
  final String notificationId;
  @override
  final String title;
  @override
  final String body;
// Full report content in markdown
  @override
  final bool isRead;
  @override
  final DateTime? sentAt;
  @override
  final DateTime createdAt;
// Report details
  @override
  final DateTime reportDate;
  @override
  final String sessionId;
  @override
  final String templateId;
  @override
  final String? subscriptionId;
// Template info
  @override
  final String templateName;
  @override
  final String templateCode;
  @override
  final String? templateIcon;
  @override
  final String templateFrequency;
// Category info
  @override
  final String? categoryId;
  @override
  final String? categoryName;
// Session status
  @override
  final String sessionStatus;
// 'pending', 'processing', 'completed', 'failed'
  @override
  final DateTime? sessionStartedAt;
  @override
  final DateTime? sessionCompletedAt;
  @override
  final String? sessionErrorMessage;
  @override
  final int? processingTimeMs;
// Subscription info
  @override
  final bool? subscriptionEnabled;
  @override
  final String? subscriptionScheduleTime;
  final List<int>? _subscriptionScheduleDays;
  @override
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
  final String? storeId;
  @override
  final String? storeName;
// Company info
  @override
  final String? companyId;

  @override
  String toString() {
    return 'ReportNotification(notificationId: $notificationId, title: $title, body: $body, isRead: $isRead, sentAt: $sentAt, createdAt: $createdAt, reportDate: $reportDate, sessionId: $sessionId, templateId: $templateId, subscriptionId: $subscriptionId, templateName: $templateName, templateCode: $templateCode, templateIcon: $templateIcon, templateFrequency: $templateFrequency, categoryId: $categoryId, categoryName: $categoryName, sessionStatus: $sessionStatus, sessionStartedAt: $sessionStartedAt, sessionCompletedAt: $sessionCompletedAt, sessionErrorMessage: $sessionErrorMessage, processingTimeMs: $processingTimeMs, subscriptionEnabled: $subscriptionEnabled, subscriptionScheduleTime: $subscriptionScheduleTime, subscriptionScheduleDays: $subscriptionScheduleDays, storeId: $storeId, storeName: $storeName, companyId: $companyId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ReportNotificationImpl &&
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

  /// Create a copy of ReportNotification
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ReportNotificationImplCopyWith<_$ReportNotificationImpl> get copyWith =>
      __$$ReportNotificationImplCopyWithImpl<_$ReportNotificationImpl>(
          this, _$identity);
}

abstract class _ReportNotification extends ReportNotification {
  const factory _ReportNotification(
      {required final String notificationId,
      required final String title,
      required final String body,
      required final bool isRead,
      final DateTime? sentAt,
      required final DateTime createdAt,
      required final DateTime reportDate,
      required final String sessionId,
      required final String templateId,
      final String? subscriptionId,
      required final String templateName,
      required final String templateCode,
      final String? templateIcon,
      required final String templateFrequency,
      final String? categoryId,
      final String? categoryName,
      required final String sessionStatus,
      final DateTime? sessionStartedAt,
      final DateTime? sessionCompletedAt,
      final String? sessionErrorMessage,
      final int? processingTimeMs,
      final bool? subscriptionEnabled,
      final String? subscriptionScheduleTime,
      final List<int>? subscriptionScheduleDays,
      final String? storeId,
      final String? storeName,
      final String? companyId}) = _$ReportNotificationImpl;
  const _ReportNotification._() : super._();

  @override
  String get notificationId;
  @override
  String get title;
  @override
  String get body; // Full report content in markdown
  @override
  bool get isRead;
  @override
  DateTime? get sentAt;
  @override
  DateTime get createdAt; // Report details
  @override
  DateTime get reportDate;
  @override
  String get sessionId;
  @override
  String get templateId;
  @override
  String? get subscriptionId; // Template info
  @override
  String get templateName;
  @override
  String get templateCode;
  @override
  String? get templateIcon;
  @override
  String get templateFrequency; // Category info
  @override
  String? get categoryId;
  @override
  String? get categoryName; // Session status
  @override
  String get sessionStatus; // 'pending', 'processing', 'completed', 'failed'
  @override
  DateTime? get sessionStartedAt;
  @override
  DateTime? get sessionCompletedAt;
  @override
  String? get sessionErrorMessage;
  @override
  int? get processingTimeMs; // Subscription info
  @override
  bool? get subscriptionEnabled;
  @override
  String? get subscriptionScheduleTime;
  @override
  List<int>? get subscriptionScheduleDays; // Store info
  @override
  String? get storeId;
  @override
  String? get storeName; // Company info
  @override
  String? get companyId;

  /// Create a copy of ReportNotification
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ReportNotificationImplCopyWith<_$ReportNotificationImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
