// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'template_with_subscription_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

TemplateWithSubscriptionDto _$TemplateWithSubscriptionDtoFromJson(
    Map<String, dynamic> json) {
  return _TemplateWithSubscriptionDto.fromJson(json);
}

/// @nodoc
mixin _$TemplateWithSubscriptionDto {
// Template fields
  @JsonKey(name: 'template_id')
  String get templateId => throw _privateConstructorUsedError;
  @JsonKey(name: 'template_name')
  String get templateName => throw _privateConstructorUsedError;
  @JsonKey(name: 'template_code')
  String get templateCode => throw _privateConstructorUsedError;
  @JsonKey(name: 'description')
  String? get description => throw _privateConstructorUsedError;
  @JsonKey(name: 'frequency')
  String get frequency => throw _privateConstructorUsedError;
  @JsonKey(name: 'icon')
  String? get icon => throw _privateConstructorUsedError;
  @JsonKey(name: 'display_order')
  int? get displayOrder => throw _privateConstructorUsedError;
  @JsonKey(name: 'default_schedule_time')
  String? get defaultScheduleTime => throw _privateConstructorUsedError;
  @JsonKey(name: 'default_schedule_days')
  List<int>? get defaultScheduleDays => throw _privateConstructorUsedError;
  @JsonKey(name: 'default_monthly_day')
  int? get defaultMonthlyDay => throw _privateConstructorUsedError;
  @JsonKey(name: 'category_id')
  String? get categoryId => throw _privateConstructorUsedError;
  @JsonKey(name: 'category_name')
  String? get categoryName =>
      throw _privateConstructorUsedError; // Subscription status
  @JsonKey(name: 'is_subscribed')
  bool get isSubscribed => throw _privateConstructorUsedError;
  @JsonKey(name: 'subscription_id')
  String? get subscriptionId => throw _privateConstructorUsedError;
  @JsonKey(name: 'subscription_enabled')
  bool? get subscriptionEnabled => throw _privateConstructorUsedError;
  @JsonKey(name: 'subscription_schedule_time')
  String? get subscriptionScheduleTime => throw _privateConstructorUsedError;
  @JsonKey(name: 'subscription_schedule_days')
  List<int>? get subscriptionScheduleDays => throw _privateConstructorUsedError;
  @JsonKey(name: 'subscription_monthly_send_day')
  int? get subscriptionMonthlySendDay => throw _privateConstructorUsedError;
  @JsonKey(name: 'subscription_timezone')
  String? get subscriptionTimezone => throw _privateConstructorUsedError;
  @JsonKey(name: 'subscription_last_sent_at')
  DateTime? get subscriptionLastSentAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'subscription_next_scheduled_at')
  DateTime? get subscriptionNextScheduledAt =>
      throw _privateConstructorUsedError;
  @JsonKey(name: 'subscription_created_at')
  DateTime? get subscriptionCreatedAt =>
      throw _privateConstructorUsedError; // Store info
  @JsonKey(name: 'store_id')
  String? get storeId => throw _privateConstructorUsedError;
  @JsonKey(name: 'store_name')
  String? get storeName => throw _privateConstructorUsedError; // Recent stats
  @JsonKey(name: 'recent_reports_count')
  int get recentReportsCount => throw _privateConstructorUsedError;
  @JsonKey(name: 'last_report_date')
  DateTime? get lastReportDate => throw _privateConstructorUsedError;
  @JsonKey(name: 'last_report_status')
  String? get lastReportStatus => throw _privateConstructorUsedError;

  /// Serializes this TemplateWithSubscriptionDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of TemplateWithSubscriptionDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TemplateWithSubscriptionDtoCopyWith<TemplateWithSubscriptionDto>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TemplateWithSubscriptionDtoCopyWith<$Res> {
  factory $TemplateWithSubscriptionDtoCopyWith(
          TemplateWithSubscriptionDto value,
          $Res Function(TemplateWithSubscriptionDto) then) =
      _$TemplateWithSubscriptionDtoCopyWithImpl<$Res,
          TemplateWithSubscriptionDto>;
  @useResult
  $Res call(
      {@JsonKey(name: 'template_id') String templateId,
      @JsonKey(name: 'template_name') String templateName,
      @JsonKey(name: 'template_code') String templateCode,
      @JsonKey(name: 'description') String? description,
      @JsonKey(name: 'frequency') String frequency,
      @JsonKey(name: 'icon') String? icon,
      @JsonKey(name: 'display_order') int? displayOrder,
      @JsonKey(name: 'default_schedule_time') String? defaultScheduleTime,
      @JsonKey(name: 'default_schedule_days') List<int>? defaultScheduleDays,
      @JsonKey(name: 'default_monthly_day') int? defaultMonthlyDay,
      @JsonKey(name: 'category_id') String? categoryId,
      @JsonKey(name: 'category_name') String? categoryName,
      @JsonKey(name: 'is_subscribed') bool isSubscribed,
      @JsonKey(name: 'subscription_id') String? subscriptionId,
      @JsonKey(name: 'subscription_enabled') bool? subscriptionEnabled,
      @JsonKey(name: 'subscription_schedule_time')
      String? subscriptionScheduleTime,
      @JsonKey(name: 'subscription_schedule_days')
      List<int>? subscriptionScheduleDays,
      @JsonKey(name: 'subscription_monthly_send_day')
      int? subscriptionMonthlySendDay,
      @JsonKey(name: 'subscription_timezone') String? subscriptionTimezone,
      @JsonKey(name: 'subscription_last_sent_at')
      DateTime? subscriptionLastSentAt,
      @JsonKey(name: 'subscription_next_scheduled_at')
      DateTime? subscriptionNextScheduledAt,
      @JsonKey(name: 'subscription_created_at') DateTime? subscriptionCreatedAt,
      @JsonKey(name: 'store_id') String? storeId,
      @JsonKey(name: 'store_name') String? storeName,
      @JsonKey(name: 'recent_reports_count') int recentReportsCount,
      @JsonKey(name: 'last_report_date') DateTime? lastReportDate,
      @JsonKey(name: 'last_report_status') String? lastReportStatus});
}

/// @nodoc
class _$TemplateWithSubscriptionDtoCopyWithImpl<$Res,
        $Val extends TemplateWithSubscriptionDto>
    implements $TemplateWithSubscriptionDtoCopyWith<$Res> {
  _$TemplateWithSubscriptionDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TemplateWithSubscriptionDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? templateId = null,
    Object? templateName = null,
    Object? templateCode = null,
    Object? description = freezed,
    Object? frequency = null,
    Object? icon = freezed,
    Object? displayOrder = freezed,
    Object? defaultScheduleTime = freezed,
    Object? defaultScheduleDays = freezed,
    Object? defaultMonthlyDay = freezed,
    Object? categoryId = freezed,
    Object? categoryName = freezed,
    Object? isSubscribed = null,
    Object? subscriptionId = freezed,
    Object? subscriptionEnabled = freezed,
    Object? subscriptionScheduleTime = freezed,
    Object? subscriptionScheduleDays = freezed,
    Object? subscriptionMonthlySendDay = freezed,
    Object? subscriptionTimezone = freezed,
    Object? subscriptionLastSentAt = freezed,
    Object? subscriptionNextScheduledAt = freezed,
    Object? subscriptionCreatedAt = freezed,
    Object? storeId = freezed,
    Object? storeName = freezed,
    Object? recentReportsCount = null,
    Object? lastReportDate = freezed,
    Object? lastReportStatus = freezed,
  }) {
    return _then(_value.copyWith(
      templateId: null == templateId
          ? _value.templateId
          : templateId // ignore: cast_nullable_to_non_nullable
              as String,
      templateName: null == templateName
          ? _value.templateName
          : templateName // ignore: cast_nullable_to_non_nullable
              as String,
      templateCode: null == templateCode
          ? _value.templateCode
          : templateCode // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      frequency: null == frequency
          ? _value.frequency
          : frequency // ignore: cast_nullable_to_non_nullable
              as String,
      icon: freezed == icon
          ? _value.icon
          : icon // ignore: cast_nullable_to_non_nullable
              as String?,
      displayOrder: freezed == displayOrder
          ? _value.displayOrder
          : displayOrder // ignore: cast_nullable_to_non_nullable
              as int?,
      defaultScheduleTime: freezed == defaultScheduleTime
          ? _value.defaultScheduleTime
          : defaultScheduleTime // ignore: cast_nullable_to_non_nullable
              as String?,
      defaultScheduleDays: freezed == defaultScheduleDays
          ? _value.defaultScheduleDays
          : defaultScheduleDays // ignore: cast_nullable_to_non_nullable
              as List<int>?,
      defaultMonthlyDay: freezed == defaultMonthlyDay
          ? _value.defaultMonthlyDay
          : defaultMonthlyDay // ignore: cast_nullable_to_non_nullable
              as int?,
      categoryId: freezed == categoryId
          ? _value.categoryId
          : categoryId // ignore: cast_nullable_to_non_nullable
              as String?,
      categoryName: freezed == categoryName
          ? _value.categoryName
          : categoryName // ignore: cast_nullable_to_non_nullable
              as String?,
      isSubscribed: null == isSubscribed
          ? _value.isSubscribed
          : isSubscribed // ignore: cast_nullable_to_non_nullable
              as bool,
      subscriptionId: freezed == subscriptionId
          ? _value.subscriptionId
          : subscriptionId // ignore: cast_nullable_to_non_nullable
              as String?,
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
      subscriptionMonthlySendDay: freezed == subscriptionMonthlySendDay
          ? _value.subscriptionMonthlySendDay
          : subscriptionMonthlySendDay // ignore: cast_nullable_to_non_nullable
              as int?,
      subscriptionTimezone: freezed == subscriptionTimezone
          ? _value.subscriptionTimezone
          : subscriptionTimezone // ignore: cast_nullable_to_non_nullable
              as String?,
      subscriptionLastSentAt: freezed == subscriptionLastSentAt
          ? _value.subscriptionLastSentAt
          : subscriptionLastSentAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      subscriptionNextScheduledAt: freezed == subscriptionNextScheduledAt
          ? _value.subscriptionNextScheduledAt
          : subscriptionNextScheduledAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      subscriptionCreatedAt: freezed == subscriptionCreatedAt
          ? _value.subscriptionCreatedAt
          : subscriptionCreatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      storeId: freezed == storeId
          ? _value.storeId
          : storeId // ignore: cast_nullable_to_non_nullable
              as String?,
      storeName: freezed == storeName
          ? _value.storeName
          : storeName // ignore: cast_nullable_to_non_nullable
              as String?,
      recentReportsCount: null == recentReportsCount
          ? _value.recentReportsCount
          : recentReportsCount // ignore: cast_nullable_to_non_nullable
              as int,
      lastReportDate: freezed == lastReportDate
          ? _value.lastReportDate
          : lastReportDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      lastReportStatus: freezed == lastReportStatus
          ? _value.lastReportStatus
          : lastReportStatus // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$TemplateWithSubscriptionDtoImplCopyWith<$Res>
    implements $TemplateWithSubscriptionDtoCopyWith<$Res> {
  factory _$$TemplateWithSubscriptionDtoImplCopyWith(
          _$TemplateWithSubscriptionDtoImpl value,
          $Res Function(_$TemplateWithSubscriptionDtoImpl) then) =
      __$$TemplateWithSubscriptionDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'template_id') String templateId,
      @JsonKey(name: 'template_name') String templateName,
      @JsonKey(name: 'template_code') String templateCode,
      @JsonKey(name: 'description') String? description,
      @JsonKey(name: 'frequency') String frequency,
      @JsonKey(name: 'icon') String? icon,
      @JsonKey(name: 'display_order') int? displayOrder,
      @JsonKey(name: 'default_schedule_time') String? defaultScheduleTime,
      @JsonKey(name: 'default_schedule_days') List<int>? defaultScheduleDays,
      @JsonKey(name: 'default_monthly_day') int? defaultMonthlyDay,
      @JsonKey(name: 'category_id') String? categoryId,
      @JsonKey(name: 'category_name') String? categoryName,
      @JsonKey(name: 'is_subscribed') bool isSubscribed,
      @JsonKey(name: 'subscription_id') String? subscriptionId,
      @JsonKey(name: 'subscription_enabled') bool? subscriptionEnabled,
      @JsonKey(name: 'subscription_schedule_time')
      String? subscriptionScheduleTime,
      @JsonKey(name: 'subscription_schedule_days')
      List<int>? subscriptionScheduleDays,
      @JsonKey(name: 'subscription_monthly_send_day')
      int? subscriptionMonthlySendDay,
      @JsonKey(name: 'subscription_timezone') String? subscriptionTimezone,
      @JsonKey(name: 'subscription_last_sent_at')
      DateTime? subscriptionLastSentAt,
      @JsonKey(name: 'subscription_next_scheduled_at')
      DateTime? subscriptionNextScheduledAt,
      @JsonKey(name: 'subscription_created_at') DateTime? subscriptionCreatedAt,
      @JsonKey(name: 'store_id') String? storeId,
      @JsonKey(name: 'store_name') String? storeName,
      @JsonKey(name: 'recent_reports_count') int recentReportsCount,
      @JsonKey(name: 'last_report_date') DateTime? lastReportDate,
      @JsonKey(name: 'last_report_status') String? lastReportStatus});
}

/// @nodoc
class __$$TemplateWithSubscriptionDtoImplCopyWithImpl<$Res>
    extends _$TemplateWithSubscriptionDtoCopyWithImpl<$Res,
        _$TemplateWithSubscriptionDtoImpl>
    implements _$$TemplateWithSubscriptionDtoImplCopyWith<$Res> {
  __$$TemplateWithSubscriptionDtoImplCopyWithImpl(
      _$TemplateWithSubscriptionDtoImpl _value,
      $Res Function(_$TemplateWithSubscriptionDtoImpl) _then)
      : super(_value, _then);

  /// Create a copy of TemplateWithSubscriptionDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? templateId = null,
    Object? templateName = null,
    Object? templateCode = null,
    Object? description = freezed,
    Object? frequency = null,
    Object? icon = freezed,
    Object? displayOrder = freezed,
    Object? defaultScheduleTime = freezed,
    Object? defaultScheduleDays = freezed,
    Object? defaultMonthlyDay = freezed,
    Object? categoryId = freezed,
    Object? categoryName = freezed,
    Object? isSubscribed = null,
    Object? subscriptionId = freezed,
    Object? subscriptionEnabled = freezed,
    Object? subscriptionScheduleTime = freezed,
    Object? subscriptionScheduleDays = freezed,
    Object? subscriptionMonthlySendDay = freezed,
    Object? subscriptionTimezone = freezed,
    Object? subscriptionLastSentAt = freezed,
    Object? subscriptionNextScheduledAt = freezed,
    Object? subscriptionCreatedAt = freezed,
    Object? storeId = freezed,
    Object? storeName = freezed,
    Object? recentReportsCount = null,
    Object? lastReportDate = freezed,
    Object? lastReportStatus = freezed,
  }) {
    return _then(_$TemplateWithSubscriptionDtoImpl(
      templateId: null == templateId
          ? _value.templateId
          : templateId // ignore: cast_nullable_to_non_nullable
              as String,
      templateName: null == templateName
          ? _value.templateName
          : templateName // ignore: cast_nullable_to_non_nullable
              as String,
      templateCode: null == templateCode
          ? _value.templateCode
          : templateCode // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      frequency: null == frequency
          ? _value.frequency
          : frequency // ignore: cast_nullable_to_non_nullable
              as String,
      icon: freezed == icon
          ? _value.icon
          : icon // ignore: cast_nullable_to_non_nullable
              as String?,
      displayOrder: freezed == displayOrder
          ? _value.displayOrder
          : displayOrder // ignore: cast_nullable_to_non_nullable
              as int?,
      defaultScheduleTime: freezed == defaultScheduleTime
          ? _value.defaultScheduleTime
          : defaultScheduleTime // ignore: cast_nullable_to_non_nullable
              as String?,
      defaultScheduleDays: freezed == defaultScheduleDays
          ? _value._defaultScheduleDays
          : defaultScheduleDays // ignore: cast_nullable_to_non_nullable
              as List<int>?,
      defaultMonthlyDay: freezed == defaultMonthlyDay
          ? _value.defaultMonthlyDay
          : defaultMonthlyDay // ignore: cast_nullable_to_non_nullable
              as int?,
      categoryId: freezed == categoryId
          ? _value.categoryId
          : categoryId // ignore: cast_nullable_to_non_nullable
              as String?,
      categoryName: freezed == categoryName
          ? _value.categoryName
          : categoryName // ignore: cast_nullable_to_non_nullable
              as String?,
      isSubscribed: null == isSubscribed
          ? _value.isSubscribed
          : isSubscribed // ignore: cast_nullable_to_non_nullable
              as bool,
      subscriptionId: freezed == subscriptionId
          ? _value.subscriptionId
          : subscriptionId // ignore: cast_nullable_to_non_nullable
              as String?,
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
      subscriptionMonthlySendDay: freezed == subscriptionMonthlySendDay
          ? _value.subscriptionMonthlySendDay
          : subscriptionMonthlySendDay // ignore: cast_nullable_to_non_nullable
              as int?,
      subscriptionTimezone: freezed == subscriptionTimezone
          ? _value.subscriptionTimezone
          : subscriptionTimezone // ignore: cast_nullable_to_non_nullable
              as String?,
      subscriptionLastSentAt: freezed == subscriptionLastSentAt
          ? _value.subscriptionLastSentAt
          : subscriptionLastSentAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      subscriptionNextScheduledAt: freezed == subscriptionNextScheduledAt
          ? _value.subscriptionNextScheduledAt
          : subscriptionNextScheduledAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      subscriptionCreatedAt: freezed == subscriptionCreatedAt
          ? _value.subscriptionCreatedAt
          : subscriptionCreatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      storeId: freezed == storeId
          ? _value.storeId
          : storeId // ignore: cast_nullable_to_non_nullable
              as String?,
      storeName: freezed == storeName
          ? _value.storeName
          : storeName // ignore: cast_nullable_to_non_nullable
              as String?,
      recentReportsCount: null == recentReportsCount
          ? _value.recentReportsCount
          : recentReportsCount // ignore: cast_nullable_to_non_nullable
              as int,
      lastReportDate: freezed == lastReportDate
          ? _value.lastReportDate
          : lastReportDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      lastReportStatus: freezed == lastReportStatus
          ? _value.lastReportStatus
          : lastReportStatus // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$TemplateWithSubscriptionDtoImpl extends _TemplateWithSubscriptionDto {
  const _$TemplateWithSubscriptionDtoImpl(
      {@JsonKey(name: 'template_id') required this.templateId,
      @JsonKey(name: 'template_name') required this.templateName,
      @JsonKey(name: 'template_code') required this.templateCode,
      @JsonKey(name: 'description') this.description,
      @JsonKey(name: 'frequency') required this.frequency,
      @JsonKey(name: 'icon') this.icon,
      @JsonKey(name: 'display_order') this.displayOrder,
      @JsonKey(name: 'default_schedule_time') this.defaultScheduleTime,
      @JsonKey(name: 'default_schedule_days')
      final List<int>? defaultScheduleDays,
      @JsonKey(name: 'default_monthly_day') this.defaultMonthlyDay,
      @JsonKey(name: 'category_id') this.categoryId,
      @JsonKey(name: 'category_name') this.categoryName,
      @JsonKey(name: 'is_subscribed') required this.isSubscribed,
      @JsonKey(name: 'subscription_id') this.subscriptionId,
      @JsonKey(name: 'subscription_enabled') this.subscriptionEnabled,
      @JsonKey(name: 'subscription_schedule_time')
      this.subscriptionScheduleTime,
      @JsonKey(name: 'subscription_schedule_days')
      final List<int>? subscriptionScheduleDays,
      @JsonKey(name: 'subscription_monthly_send_day')
      this.subscriptionMonthlySendDay,
      @JsonKey(name: 'subscription_timezone') this.subscriptionTimezone,
      @JsonKey(name: 'subscription_last_sent_at') this.subscriptionLastSentAt,
      @JsonKey(name: 'subscription_next_scheduled_at')
      this.subscriptionNextScheduledAt,
      @JsonKey(name: 'subscription_created_at') this.subscriptionCreatedAt,
      @JsonKey(name: 'store_id') this.storeId,
      @JsonKey(name: 'store_name') this.storeName,
      @JsonKey(name: 'recent_reports_count') this.recentReportsCount = 0,
      @JsonKey(name: 'last_report_date') this.lastReportDate,
      @JsonKey(name: 'last_report_status') this.lastReportStatus})
      : _defaultScheduleDays = defaultScheduleDays,
        _subscriptionScheduleDays = subscriptionScheduleDays,
        super._();

  factory _$TemplateWithSubscriptionDtoImpl.fromJson(
          Map<String, dynamic> json) =>
      _$$TemplateWithSubscriptionDtoImplFromJson(json);

// Template fields
  @override
  @JsonKey(name: 'template_id')
  final String templateId;
  @override
  @JsonKey(name: 'template_name')
  final String templateName;
  @override
  @JsonKey(name: 'template_code')
  final String templateCode;
  @override
  @JsonKey(name: 'description')
  final String? description;
  @override
  @JsonKey(name: 'frequency')
  final String frequency;
  @override
  @JsonKey(name: 'icon')
  final String? icon;
  @override
  @JsonKey(name: 'display_order')
  final int? displayOrder;
  @override
  @JsonKey(name: 'default_schedule_time')
  final String? defaultScheduleTime;
  final List<int>? _defaultScheduleDays;
  @override
  @JsonKey(name: 'default_schedule_days')
  List<int>? get defaultScheduleDays {
    final value = _defaultScheduleDays;
    if (value == null) return null;
    if (_defaultScheduleDays is EqualUnmodifiableListView)
      return _defaultScheduleDays;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  @JsonKey(name: 'default_monthly_day')
  final int? defaultMonthlyDay;
  @override
  @JsonKey(name: 'category_id')
  final String? categoryId;
  @override
  @JsonKey(name: 'category_name')
  final String? categoryName;
// Subscription status
  @override
  @JsonKey(name: 'is_subscribed')
  final bool isSubscribed;
  @override
  @JsonKey(name: 'subscription_id')
  final String? subscriptionId;
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

  @override
  @JsonKey(name: 'subscription_monthly_send_day')
  final int? subscriptionMonthlySendDay;
  @override
  @JsonKey(name: 'subscription_timezone')
  final String? subscriptionTimezone;
  @override
  @JsonKey(name: 'subscription_last_sent_at')
  final DateTime? subscriptionLastSentAt;
  @override
  @JsonKey(name: 'subscription_next_scheduled_at')
  final DateTime? subscriptionNextScheduledAt;
  @override
  @JsonKey(name: 'subscription_created_at')
  final DateTime? subscriptionCreatedAt;
// Store info
  @override
  @JsonKey(name: 'store_id')
  final String? storeId;
  @override
  @JsonKey(name: 'store_name')
  final String? storeName;
// Recent stats
  @override
  @JsonKey(name: 'recent_reports_count')
  final int recentReportsCount;
  @override
  @JsonKey(name: 'last_report_date')
  final DateTime? lastReportDate;
  @override
  @JsonKey(name: 'last_report_status')
  final String? lastReportStatus;

  @override
  String toString() {
    return 'TemplateWithSubscriptionDto(templateId: $templateId, templateName: $templateName, templateCode: $templateCode, description: $description, frequency: $frequency, icon: $icon, displayOrder: $displayOrder, defaultScheduleTime: $defaultScheduleTime, defaultScheduleDays: $defaultScheduleDays, defaultMonthlyDay: $defaultMonthlyDay, categoryId: $categoryId, categoryName: $categoryName, isSubscribed: $isSubscribed, subscriptionId: $subscriptionId, subscriptionEnabled: $subscriptionEnabled, subscriptionScheduleTime: $subscriptionScheduleTime, subscriptionScheduleDays: $subscriptionScheduleDays, subscriptionMonthlySendDay: $subscriptionMonthlySendDay, subscriptionTimezone: $subscriptionTimezone, subscriptionLastSentAt: $subscriptionLastSentAt, subscriptionNextScheduledAt: $subscriptionNextScheduledAt, subscriptionCreatedAt: $subscriptionCreatedAt, storeId: $storeId, storeName: $storeName, recentReportsCount: $recentReportsCount, lastReportDate: $lastReportDate, lastReportStatus: $lastReportStatus)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TemplateWithSubscriptionDtoImpl &&
            (identical(other.templateId, templateId) ||
                other.templateId == templateId) &&
            (identical(other.templateName, templateName) ||
                other.templateName == templateName) &&
            (identical(other.templateCode, templateCode) ||
                other.templateCode == templateCode) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.frequency, frequency) ||
                other.frequency == frequency) &&
            (identical(other.icon, icon) || other.icon == icon) &&
            (identical(other.displayOrder, displayOrder) ||
                other.displayOrder == displayOrder) &&
            (identical(other.defaultScheduleTime, defaultScheduleTime) ||
                other.defaultScheduleTime == defaultScheduleTime) &&
            const DeepCollectionEquality()
                .equals(other._defaultScheduleDays, _defaultScheduleDays) &&
            (identical(other.defaultMonthlyDay, defaultMonthlyDay) ||
                other.defaultMonthlyDay == defaultMonthlyDay) &&
            (identical(other.categoryId, categoryId) ||
                other.categoryId == categoryId) &&
            (identical(other.categoryName, categoryName) ||
                other.categoryName == categoryName) &&
            (identical(other.isSubscribed, isSubscribed) ||
                other.isSubscribed == isSubscribed) &&
            (identical(other.subscriptionId, subscriptionId) ||
                other.subscriptionId == subscriptionId) &&
            (identical(other.subscriptionEnabled, subscriptionEnabled) ||
                other.subscriptionEnabled == subscriptionEnabled) &&
            (identical(
                    other.subscriptionScheduleTime, subscriptionScheduleTime) ||
                other.subscriptionScheduleTime == subscriptionScheduleTime) &&
            const DeepCollectionEquality().equals(
                other._subscriptionScheduleDays, _subscriptionScheduleDays) &&
            (identical(other.subscriptionMonthlySendDay,
                    subscriptionMonthlySendDay) ||
                other.subscriptionMonthlySendDay ==
                    subscriptionMonthlySendDay) &&
            (identical(other.subscriptionTimezone, subscriptionTimezone) ||
                other.subscriptionTimezone == subscriptionTimezone) &&
            (identical(other.subscriptionLastSentAt, subscriptionLastSentAt) ||
                other.subscriptionLastSentAt == subscriptionLastSentAt) &&
            (identical(other.subscriptionNextScheduledAt,
                    subscriptionNextScheduledAt) ||
                other.subscriptionNextScheduledAt ==
                    subscriptionNextScheduledAt) &&
            (identical(other.subscriptionCreatedAt, subscriptionCreatedAt) ||
                other.subscriptionCreatedAt == subscriptionCreatedAt) &&
            (identical(other.storeId, storeId) || other.storeId == storeId) &&
            (identical(other.storeName, storeName) ||
                other.storeName == storeName) &&
            (identical(other.recentReportsCount, recentReportsCount) ||
                other.recentReportsCount == recentReportsCount) &&
            (identical(other.lastReportDate, lastReportDate) ||
                other.lastReportDate == lastReportDate) &&
            (identical(other.lastReportStatus, lastReportStatus) ||
                other.lastReportStatus == lastReportStatus));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        templateId,
        templateName,
        templateCode,
        description,
        frequency,
        icon,
        displayOrder,
        defaultScheduleTime,
        const DeepCollectionEquality().hash(_defaultScheduleDays),
        defaultMonthlyDay,
        categoryId,
        categoryName,
        isSubscribed,
        subscriptionId,
        subscriptionEnabled,
        subscriptionScheduleTime,
        const DeepCollectionEquality().hash(_subscriptionScheduleDays),
        subscriptionMonthlySendDay,
        subscriptionTimezone,
        subscriptionLastSentAt,
        subscriptionNextScheduledAt,
        subscriptionCreatedAt,
        storeId,
        storeName,
        recentReportsCount,
        lastReportDate,
        lastReportStatus
      ]);

  /// Create a copy of TemplateWithSubscriptionDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TemplateWithSubscriptionDtoImplCopyWith<_$TemplateWithSubscriptionDtoImpl>
      get copyWith => __$$TemplateWithSubscriptionDtoImplCopyWithImpl<
          _$TemplateWithSubscriptionDtoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TemplateWithSubscriptionDtoImplToJson(
      this,
    );
  }
}

abstract class _TemplateWithSubscriptionDto
    extends TemplateWithSubscriptionDto {
  const factory _TemplateWithSubscriptionDto(
      {@JsonKey(name: 'template_id') required final String templateId,
      @JsonKey(name: 'template_name') required final String templateName,
      @JsonKey(name: 'template_code') required final String templateCode,
      @JsonKey(name: 'description') final String? description,
      @JsonKey(name: 'frequency') required final String frequency,
      @JsonKey(name: 'icon') final String? icon,
      @JsonKey(name: 'display_order') final int? displayOrder,
      @JsonKey(name: 'default_schedule_time') final String? defaultScheduleTime,
      @JsonKey(name: 'default_schedule_days')
      final List<int>? defaultScheduleDays,
      @JsonKey(name: 'default_monthly_day') final int? defaultMonthlyDay,
      @JsonKey(name: 'category_id') final String? categoryId,
      @JsonKey(name: 'category_name') final String? categoryName,
      @JsonKey(name: 'is_subscribed') required final bool isSubscribed,
      @JsonKey(name: 'subscription_id') final String? subscriptionId,
      @JsonKey(name: 'subscription_enabled') final bool? subscriptionEnabled,
      @JsonKey(name: 'subscription_schedule_time')
      final String? subscriptionScheduleTime,
      @JsonKey(name: 'subscription_schedule_days')
      final List<int>? subscriptionScheduleDays,
      @JsonKey(name: 'subscription_monthly_send_day')
      final int? subscriptionMonthlySendDay,
      @JsonKey(name: 'subscription_timezone')
      final String? subscriptionTimezone,
      @JsonKey(name: 'subscription_last_sent_at')
      final DateTime? subscriptionLastSentAt,
      @JsonKey(name: 'subscription_next_scheduled_at')
      final DateTime? subscriptionNextScheduledAt,
      @JsonKey(name: 'subscription_created_at')
      final DateTime? subscriptionCreatedAt,
      @JsonKey(name: 'store_id') final String? storeId,
      @JsonKey(name: 'store_name') final String? storeName,
      @JsonKey(name: 'recent_reports_count') final int recentReportsCount,
      @JsonKey(name: 'last_report_date') final DateTime? lastReportDate,
      @JsonKey(name: 'last_report_status')
      final String? lastReportStatus}) = _$TemplateWithSubscriptionDtoImpl;
  const _TemplateWithSubscriptionDto._() : super._();

  factory _TemplateWithSubscriptionDto.fromJson(Map<String, dynamic> json) =
      _$TemplateWithSubscriptionDtoImpl.fromJson;

// Template fields
  @override
  @JsonKey(name: 'template_id')
  String get templateId;
  @override
  @JsonKey(name: 'template_name')
  String get templateName;
  @override
  @JsonKey(name: 'template_code')
  String get templateCode;
  @override
  @JsonKey(name: 'description')
  String? get description;
  @override
  @JsonKey(name: 'frequency')
  String get frequency;
  @override
  @JsonKey(name: 'icon')
  String? get icon;
  @override
  @JsonKey(name: 'display_order')
  int? get displayOrder;
  @override
  @JsonKey(name: 'default_schedule_time')
  String? get defaultScheduleTime;
  @override
  @JsonKey(name: 'default_schedule_days')
  List<int>? get defaultScheduleDays;
  @override
  @JsonKey(name: 'default_monthly_day')
  int? get defaultMonthlyDay;
  @override
  @JsonKey(name: 'category_id')
  String? get categoryId;
  @override
  @JsonKey(name: 'category_name')
  String? get categoryName; // Subscription status
  @override
  @JsonKey(name: 'is_subscribed')
  bool get isSubscribed;
  @override
  @JsonKey(name: 'subscription_id')
  String? get subscriptionId;
  @override
  @JsonKey(name: 'subscription_enabled')
  bool? get subscriptionEnabled;
  @override
  @JsonKey(name: 'subscription_schedule_time')
  String? get subscriptionScheduleTime;
  @override
  @JsonKey(name: 'subscription_schedule_days')
  List<int>? get subscriptionScheduleDays;
  @override
  @JsonKey(name: 'subscription_monthly_send_day')
  int? get subscriptionMonthlySendDay;
  @override
  @JsonKey(name: 'subscription_timezone')
  String? get subscriptionTimezone;
  @override
  @JsonKey(name: 'subscription_last_sent_at')
  DateTime? get subscriptionLastSentAt;
  @override
  @JsonKey(name: 'subscription_next_scheduled_at')
  DateTime? get subscriptionNextScheduledAt;
  @override
  @JsonKey(name: 'subscription_created_at')
  DateTime? get subscriptionCreatedAt; // Store info
  @override
  @JsonKey(name: 'store_id')
  String? get storeId;
  @override
  @JsonKey(name: 'store_name')
  String? get storeName; // Recent stats
  @override
  @JsonKey(name: 'recent_reports_count')
  int get recentReportsCount;
  @override
  @JsonKey(name: 'last_report_date')
  DateTime? get lastReportDate;
  @override
  @JsonKey(name: 'last_report_status')
  String? get lastReportStatus;

  /// Create a copy of TemplateWithSubscriptionDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TemplateWithSubscriptionDtoImplCopyWith<_$TemplateWithSubscriptionDtoImpl>
      get copyWith => throw _privateConstructorUsedError;
}
