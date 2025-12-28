// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'trade_alert_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

TradeAlertModel _$TradeAlertModelFromJson(Map<String, dynamic> json) {
  return _TradeAlertModel.fromJson(json);
}

/// @nodoc
mixin _$TradeAlertModel {
  @JsonKey(name: 'alert_id')
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'company_id')
  String get companyId => throw _privateConstructorUsedError;
  @JsonKey(name: 'entity_type')
  String get entityType => throw _privateConstructorUsedError;
  @JsonKey(name: 'entity_id')
  String get entityId => throw _privateConstructorUsedError;
  @JsonKey(name: 'entity_number')
  String? get entityNumber => throw _privateConstructorUsedError;
  @JsonKey(name: 'alert_type')
  String get alertType => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String? get message => throw _privateConstructorUsedError;
  @JsonKey(name: 'action_url')
  String? get actionUrl => throw _privateConstructorUsedError;
  @JsonKey(name: 'due_date')
  DateTime? get dueDate => throw _privateConstructorUsedError;
  @JsonKey(name: 'days_before_due')
  int? get daysBeforeDue => throw _privateConstructorUsedError;
  String get priority => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_read')
  bool get isRead => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_dismissed')
  bool get isDismissed => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_resolved')
  bool get isResolved => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_system_generated')
  bool get isSystemGenerated => throw _privateConstructorUsedError;
  @JsonKey(name: 'assigned_to')
  String? get assignedTo => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  DateTime get createdAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'read_at')
  DateTime? get readAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'dismissed_at')
  DateTime? get dismissedAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'resolved_at')
  DateTime? get resolvedAt => throw _privateConstructorUsedError;

  /// Serializes this TradeAlertModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of TradeAlertModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TradeAlertModelCopyWith<TradeAlertModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TradeAlertModelCopyWith<$Res> {
  factory $TradeAlertModelCopyWith(
          TradeAlertModel value, $Res Function(TradeAlertModel) then) =
      _$TradeAlertModelCopyWithImpl<$Res, TradeAlertModel>;
  @useResult
  $Res call(
      {@JsonKey(name: 'alert_id') String id,
      @JsonKey(name: 'company_id') String companyId,
      @JsonKey(name: 'entity_type') String entityType,
      @JsonKey(name: 'entity_id') String entityId,
      @JsonKey(name: 'entity_number') String? entityNumber,
      @JsonKey(name: 'alert_type') String alertType,
      String title,
      String? message,
      @JsonKey(name: 'action_url') String? actionUrl,
      @JsonKey(name: 'due_date') DateTime? dueDate,
      @JsonKey(name: 'days_before_due') int? daysBeforeDue,
      String priority,
      @JsonKey(name: 'is_read') bool isRead,
      @JsonKey(name: 'is_dismissed') bool isDismissed,
      @JsonKey(name: 'is_resolved') bool isResolved,
      @JsonKey(name: 'is_system_generated') bool isSystemGenerated,
      @JsonKey(name: 'assigned_to') String? assignedTo,
      @JsonKey(name: 'created_at') DateTime createdAt,
      @JsonKey(name: 'read_at') DateTime? readAt,
      @JsonKey(name: 'dismissed_at') DateTime? dismissedAt,
      @JsonKey(name: 'resolved_at') DateTime? resolvedAt});
}

/// @nodoc
class _$TradeAlertModelCopyWithImpl<$Res, $Val extends TradeAlertModel>
    implements $TradeAlertModelCopyWith<$Res> {
  _$TradeAlertModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TradeAlertModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? companyId = null,
    Object? entityType = null,
    Object? entityId = null,
    Object? entityNumber = freezed,
    Object? alertType = null,
    Object? title = null,
    Object? message = freezed,
    Object? actionUrl = freezed,
    Object? dueDate = freezed,
    Object? daysBeforeDue = freezed,
    Object? priority = null,
    Object? isRead = null,
    Object? isDismissed = null,
    Object? isResolved = null,
    Object? isSystemGenerated = null,
    Object? assignedTo = freezed,
    Object? createdAt = null,
    Object? readAt = freezed,
    Object? dismissedAt = freezed,
    Object? resolvedAt = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      companyId: null == companyId
          ? _value.companyId
          : companyId // ignore: cast_nullable_to_non_nullable
              as String,
      entityType: null == entityType
          ? _value.entityType
          : entityType // ignore: cast_nullable_to_non_nullable
              as String,
      entityId: null == entityId
          ? _value.entityId
          : entityId // ignore: cast_nullable_to_non_nullable
              as String,
      entityNumber: freezed == entityNumber
          ? _value.entityNumber
          : entityNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      alertType: null == alertType
          ? _value.alertType
          : alertType // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      message: freezed == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String?,
      actionUrl: freezed == actionUrl
          ? _value.actionUrl
          : actionUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      dueDate: freezed == dueDate
          ? _value.dueDate
          : dueDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      daysBeforeDue: freezed == daysBeforeDue
          ? _value.daysBeforeDue
          : daysBeforeDue // ignore: cast_nullable_to_non_nullable
              as int?,
      priority: null == priority
          ? _value.priority
          : priority // ignore: cast_nullable_to_non_nullable
              as String,
      isRead: null == isRead
          ? _value.isRead
          : isRead // ignore: cast_nullable_to_non_nullable
              as bool,
      isDismissed: null == isDismissed
          ? _value.isDismissed
          : isDismissed // ignore: cast_nullable_to_non_nullable
              as bool,
      isResolved: null == isResolved
          ? _value.isResolved
          : isResolved // ignore: cast_nullable_to_non_nullable
              as bool,
      isSystemGenerated: null == isSystemGenerated
          ? _value.isSystemGenerated
          : isSystemGenerated // ignore: cast_nullable_to_non_nullable
              as bool,
      assignedTo: freezed == assignedTo
          ? _value.assignedTo
          : assignedTo // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      readAt: freezed == readAt
          ? _value.readAt
          : readAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      dismissedAt: freezed == dismissedAt
          ? _value.dismissedAt
          : dismissedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      resolvedAt: freezed == resolvedAt
          ? _value.resolvedAt
          : resolvedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$TradeAlertModelImplCopyWith<$Res>
    implements $TradeAlertModelCopyWith<$Res> {
  factory _$$TradeAlertModelImplCopyWith(_$TradeAlertModelImpl value,
          $Res Function(_$TradeAlertModelImpl) then) =
      __$$TradeAlertModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'alert_id') String id,
      @JsonKey(name: 'company_id') String companyId,
      @JsonKey(name: 'entity_type') String entityType,
      @JsonKey(name: 'entity_id') String entityId,
      @JsonKey(name: 'entity_number') String? entityNumber,
      @JsonKey(name: 'alert_type') String alertType,
      String title,
      String? message,
      @JsonKey(name: 'action_url') String? actionUrl,
      @JsonKey(name: 'due_date') DateTime? dueDate,
      @JsonKey(name: 'days_before_due') int? daysBeforeDue,
      String priority,
      @JsonKey(name: 'is_read') bool isRead,
      @JsonKey(name: 'is_dismissed') bool isDismissed,
      @JsonKey(name: 'is_resolved') bool isResolved,
      @JsonKey(name: 'is_system_generated') bool isSystemGenerated,
      @JsonKey(name: 'assigned_to') String? assignedTo,
      @JsonKey(name: 'created_at') DateTime createdAt,
      @JsonKey(name: 'read_at') DateTime? readAt,
      @JsonKey(name: 'dismissed_at') DateTime? dismissedAt,
      @JsonKey(name: 'resolved_at') DateTime? resolvedAt});
}

/// @nodoc
class __$$TradeAlertModelImplCopyWithImpl<$Res>
    extends _$TradeAlertModelCopyWithImpl<$Res, _$TradeAlertModelImpl>
    implements _$$TradeAlertModelImplCopyWith<$Res> {
  __$$TradeAlertModelImplCopyWithImpl(
      _$TradeAlertModelImpl _value, $Res Function(_$TradeAlertModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of TradeAlertModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? companyId = null,
    Object? entityType = null,
    Object? entityId = null,
    Object? entityNumber = freezed,
    Object? alertType = null,
    Object? title = null,
    Object? message = freezed,
    Object? actionUrl = freezed,
    Object? dueDate = freezed,
    Object? daysBeforeDue = freezed,
    Object? priority = null,
    Object? isRead = null,
    Object? isDismissed = null,
    Object? isResolved = null,
    Object? isSystemGenerated = null,
    Object? assignedTo = freezed,
    Object? createdAt = null,
    Object? readAt = freezed,
    Object? dismissedAt = freezed,
    Object? resolvedAt = freezed,
  }) {
    return _then(_$TradeAlertModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      companyId: null == companyId
          ? _value.companyId
          : companyId // ignore: cast_nullable_to_non_nullable
              as String,
      entityType: null == entityType
          ? _value.entityType
          : entityType // ignore: cast_nullable_to_non_nullable
              as String,
      entityId: null == entityId
          ? _value.entityId
          : entityId // ignore: cast_nullable_to_non_nullable
              as String,
      entityNumber: freezed == entityNumber
          ? _value.entityNumber
          : entityNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      alertType: null == alertType
          ? _value.alertType
          : alertType // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      message: freezed == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String?,
      actionUrl: freezed == actionUrl
          ? _value.actionUrl
          : actionUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      dueDate: freezed == dueDate
          ? _value.dueDate
          : dueDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      daysBeforeDue: freezed == daysBeforeDue
          ? _value.daysBeforeDue
          : daysBeforeDue // ignore: cast_nullable_to_non_nullable
              as int?,
      priority: null == priority
          ? _value.priority
          : priority // ignore: cast_nullable_to_non_nullable
              as String,
      isRead: null == isRead
          ? _value.isRead
          : isRead // ignore: cast_nullable_to_non_nullable
              as bool,
      isDismissed: null == isDismissed
          ? _value.isDismissed
          : isDismissed // ignore: cast_nullable_to_non_nullable
              as bool,
      isResolved: null == isResolved
          ? _value.isResolved
          : isResolved // ignore: cast_nullable_to_non_nullable
              as bool,
      isSystemGenerated: null == isSystemGenerated
          ? _value.isSystemGenerated
          : isSystemGenerated // ignore: cast_nullable_to_non_nullable
              as bool,
      assignedTo: freezed == assignedTo
          ? _value.assignedTo
          : assignedTo // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      readAt: freezed == readAt
          ? _value.readAt
          : readAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      dismissedAt: freezed == dismissedAt
          ? _value.dismissedAt
          : dismissedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      resolvedAt: freezed == resolvedAt
          ? _value.resolvedAt
          : resolvedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$TradeAlertModelImpl extends _TradeAlertModel {
  const _$TradeAlertModelImpl(
      {@JsonKey(name: 'alert_id') required this.id,
      @JsonKey(name: 'company_id') required this.companyId,
      @JsonKey(name: 'entity_type') required this.entityType,
      @JsonKey(name: 'entity_id') required this.entityId,
      @JsonKey(name: 'entity_number') this.entityNumber,
      @JsonKey(name: 'alert_type') required this.alertType,
      required this.title,
      this.message,
      @JsonKey(name: 'action_url') this.actionUrl,
      @JsonKey(name: 'due_date') this.dueDate,
      @JsonKey(name: 'days_before_due') this.daysBeforeDue,
      this.priority = 'medium',
      @JsonKey(name: 'is_read') this.isRead = false,
      @JsonKey(name: 'is_dismissed') this.isDismissed = false,
      @JsonKey(name: 'is_resolved') this.isResolved = false,
      @JsonKey(name: 'is_system_generated') this.isSystemGenerated = true,
      @JsonKey(name: 'assigned_to') this.assignedTo,
      @JsonKey(name: 'created_at') required this.createdAt,
      @JsonKey(name: 'read_at') this.readAt,
      @JsonKey(name: 'dismissed_at') this.dismissedAt,
      @JsonKey(name: 'resolved_at') this.resolvedAt})
      : super._();

  factory _$TradeAlertModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$TradeAlertModelImplFromJson(json);

  @override
  @JsonKey(name: 'alert_id')
  final String id;
  @override
  @JsonKey(name: 'company_id')
  final String companyId;
  @override
  @JsonKey(name: 'entity_type')
  final String entityType;
  @override
  @JsonKey(name: 'entity_id')
  final String entityId;
  @override
  @JsonKey(name: 'entity_number')
  final String? entityNumber;
  @override
  @JsonKey(name: 'alert_type')
  final String alertType;
  @override
  final String title;
  @override
  final String? message;
  @override
  @JsonKey(name: 'action_url')
  final String? actionUrl;
  @override
  @JsonKey(name: 'due_date')
  final DateTime? dueDate;
  @override
  @JsonKey(name: 'days_before_due')
  final int? daysBeforeDue;
  @override
  @JsonKey()
  final String priority;
  @override
  @JsonKey(name: 'is_read')
  final bool isRead;
  @override
  @JsonKey(name: 'is_dismissed')
  final bool isDismissed;
  @override
  @JsonKey(name: 'is_resolved')
  final bool isResolved;
  @override
  @JsonKey(name: 'is_system_generated')
  final bool isSystemGenerated;
  @override
  @JsonKey(name: 'assigned_to')
  final String? assignedTo;
  @override
  @JsonKey(name: 'created_at')
  final DateTime createdAt;
  @override
  @JsonKey(name: 'read_at')
  final DateTime? readAt;
  @override
  @JsonKey(name: 'dismissed_at')
  final DateTime? dismissedAt;
  @override
  @JsonKey(name: 'resolved_at')
  final DateTime? resolvedAt;

  @override
  String toString() {
    return 'TradeAlertModel(id: $id, companyId: $companyId, entityType: $entityType, entityId: $entityId, entityNumber: $entityNumber, alertType: $alertType, title: $title, message: $message, actionUrl: $actionUrl, dueDate: $dueDate, daysBeforeDue: $daysBeforeDue, priority: $priority, isRead: $isRead, isDismissed: $isDismissed, isResolved: $isResolved, isSystemGenerated: $isSystemGenerated, assignedTo: $assignedTo, createdAt: $createdAt, readAt: $readAt, dismissedAt: $dismissedAt, resolvedAt: $resolvedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TradeAlertModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.companyId, companyId) ||
                other.companyId == companyId) &&
            (identical(other.entityType, entityType) ||
                other.entityType == entityType) &&
            (identical(other.entityId, entityId) ||
                other.entityId == entityId) &&
            (identical(other.entityNumber, entityNumber) ||
                other.entityNumber == entityNumber) &&
            (identical(other.alertType, alertType) ||
                other.alertType == alertType) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.message, message) || other.message == message) &&
            (identical(other.actionUrl, actionUrl) ||
                other.actionUrl == actionUrl) &&
            (identical(other.dueDate, dueDate) || other.dueDate == dueDate) &&
            (identical(other.daysBeforeDue, daysBeforeDue) ||
                other.daysBeforeDue == daysBeforeDue) &&
            (identical(other.priority, priority) ||
                other.priority == priority) &&
            (identical(other.isRead, isRead) || other.isRead == isRead) &&
            (identical(other.isDismissed, isDismissed) ||
                other.isDismissed == isDismissed) &&
            (identical(other.isResolved, isResolved) ||
                other.isResolved == isResolved) &&
            (identical(other.isSystemGenerated, isSystemGenerated) ||
                other.isSystemGenerated == isSystemGenerated) &&
            (identical(other.assignedTo, assignedTo) ||
                other.assignedTo == assignedTo) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.readAt, readAt) || other.readAt == readAt) &&
            (identical(other.dismissedAt, dismissedAt) ||
                other.dismissedAt == dismissedAt) &&
            (identical(other.resolvedAt, resolvedAt) ||
                other.resolvedAt == resolvedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        id,
        companyId,
        entityType,
        entityId,
        entityNumber,
        alertType,
        title,
        message,
        actionUrl,
        dueDate,
        daysBeforeDue,
        priority,
        isRead,
        isDismissed,
        isResolved,
        isSystemGenerated,
        assignedTo,
        createdAt,
        readAt,
        dismissedAt,
        resolvedAt
      ]);

  /// Create a copy of TradeAlertModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TradeAlertModelImplCopyWith<_$TradeAlertModelImpl> get copyWith =>
      __$$TradeAlertModelImplCopyWithImpl<_$TradeAlertModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TradeAlertModelImplToJson(
      this,
    );
  }
}

abstract class _TradeAlertModel extends TradeAlertModel {
  const factory _TradeAlertModel(
          {@JsonKey(name: 'alert_id') required final String id,
          @JsonKey(name: 'company_id') required final String companyId,
          @JsonKey(name: 'entity_type') required final String entityType,
          @JsonKey(name: 'entity_id') required final String entityId,
          @JsonKey(name: 'entity_number') final String? entityNumber,
          @JsonKey(name: 'alert_type') required final String alertType,
          required final String title,
          final String? message,
          @JsonKey(name: 'action_url') final String? actionUrl,
          @JsonKey(name: 'due_date') final DateTime? dueDate,
          @JsonKey(name: 'days_before_due') final int? daysBeforeDue,
          final String priority,
          @JsonKey(name: 'is_read') final bool isRead,
          @JsonKey(name: 'is_dismissed') final bool isDismissed,
          @JsonKey(name: 'is_resolved') final bool isResolved,
          @JsonKey(name: 'is_system_generated') final bool isSystemGenerated,
          @JsonKey(name: 'assigned_to') final String? assignedTo,
          @JsonKey(name: 'created_at') required final DateTime createdAt,
          @JsonKey(name: 'read_at') final DateTime? readAt,
          @JsonKey(name: 'dismissed_at') final DateTime? dismissedAt,
          @JsonKey(name: 'resolved_at') final DateTime? resolvedAt}) =
      _$TradeAlertModelImpl;
  const _TradeAlertModel._() : super._();

  factory _TradeAlertModel.fromJson(Map<String, dynamic> json) =
      _$TradeAlertModelImpl.fromJson;

  @override
  @JsonKey(name: 'alert_id')
  String get id;
  @override
  @JsonKey(name: 'company_id')
  String get companyId;
  @override
  @JsonKey(name: 'entity_type')
  String get entityType;
  @override
  @JsonKey(name: 'entity_id')
  String get entityId;
  @override
  @JsonKey(name: 'entity_number')
  String? get entityNumber;
  @override
  @JsonKey(name: 'alert_type')
  String get alertType;
  @override
  String get title;
  @override
  String? get message;
  @override
  @JsonKey(name: 'action_url')
  String? get actionUrl;
  @override
  @JsonKey(name: 'due_date')
  DateTime? get dueDate;
  @override
  @JsonKey(name: 'days_before_due')
  int? get daysBeforeDue;
  @override
  String get priority;
  @override
  @JsonKey(name: 'is_read')
  bool get isRead;
  @override
  @JsonKey(name: 'is_dismissed')
  bool get isDismissed;
  @override
  @JsonKey(name: 'is_resolved')
  bool get isResolved;
  @override
  @JsonKey(name: 'is_system_generated')
  bool get isSystemGenerated;
  @override
  @JsonKey(name: 'assigned_to')
  String? get assignedTo;
  @override
  @JsonKey(name: 'created_at')
  DateTime get createdAt;
  @override
  @JsonKey(name: 'read_at')
  DateTime? get readAt;
  @override
  @JsonKey(name: 'dismissed_at')
  DateTime? get dismissedAt;
  @override
  @JsonKey(name: 'resolved_at')
  DateTime? get resolvedAt;

  /// Create a copy of TradeAlertModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TradeAlertModelImplCopyWith<_$TradeAlertModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$TradeAlertListResponse {
  List<TradeAlertModel> get alerts => throw _privateConstructorUsedError;
  PaginationInfo get pagination => throw _privateConstructorUsedError;
  int get unreadCount => throw _privateConstructorUsedError;

  /// Create a copy of TradeAlertListResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TradeAlertListResponseCopyWith<TradeAlertListResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TradeAlertListResponseCopyWith<$Res> {
  factory $TradeAlertListResponseCopyWith(TradeAlertListResponse value,
          $Res Function(TradeAlertListResponse) then) =
      _$TradeAlertListResponseCopyWithImpl<$Res, TradeAlertListResponse>;
  @useResult
  $Res call(
      {List<TradeAlertModel> alerts,
      PaginationInfo pagination,
      int unreadCount});

  $PaginationInfoCopyWith<$Res> get pagination;
}

/// @nodoc
class _$TradeAlertListResponseCopyWithImpl<$Res,
        $Val extends TradeAlertListResponse>
    implements $TradeAlertListResponseCopyWith<$Res> {
  _$TradeAlertListResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TradeAlertListResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? alerts = null,
    Object? pagination = null,
    Object? unreadCount = null,
  }) {
    return _then(_value.copyWith(
      alerts: null == alerts
          ? _value.alerts
          : alerts // ignore: cast_nullable_to_non_nullable
              as List<TradeAlertModel>,
      pagination: null == pagination
          ? _value.pagination
          : pagination // ignore: cast_nullable_to_non_nullable
              as PaginationInfo,
      unreadCount: null == unreadCount
          ? _value.unreadCount
          : unreadCount // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }

  /// Create a copy of TradeAlertListResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $PaginationInfoCopyWith<$Res> get pagination {
    return $PaginationInfoCopyWith<$Res>(_value.pagination, (value) {
      return _then(_value.copyWith(pagination: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$TradeAlertListResponseImplCopyWith<$Res>
    implements $TradeAlertListResponseCopyWith<$Res> {
  factory _$$TradeAlertListResponseImplCopyWith(
          _$TradeAlertListResponseImpl value,
          $Res Function(_$TradeAlertListResponseImpl) then) =
      __$$TradeAlertListResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {List<TradeAlertModel> alerts,
      PaginationInfo pagination,
      int unreadCount});

  @override
  $PaginationInfoCopyWith<$Res> get pagination;
}

/// @nodoc
class __$$TradeAlertListResponseImplCopyWithImpl<$Res>
    extends _$TradeAlertListResponseCopyWithImpl<$Res,
        _$TradeAlertListResponseImpl>
    implements _$$TradeAlertListResponseImplCopyWith<$Res> {
  __$$TradeAlertListResponseImplCopyWithImpl(
      _$TradeAlertListResponseImpl _value,
      $Res Function(_$TradeAlertListResponseImpl) _then)
      : super(_value, _then);

  /// Create a copy of TradeAlertListResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? alerts = null,
    Object? pagination = null,
    Object? unreadCount = null,
  }) {
    return _then(_$TradeAlertListResponseImpl(
      alerts: null == alerts
          ? _value._alerts
          : alerts // ignore: cast_nullable_to_non_nullable
              as List<TradeAlertModel>,
      pagination: null == pagination
          ? _value.pagination
          : pagination // ignore: cast_nullable_to_non_nullable
              as PaginationInfo,
      unreadCount: null == unreadCount
          ? _value.unreadCount
          : unreadCount // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc

class _$TradeAlertListResponseImpl extends _TradeAlertListResponse {
  const _$TradeAlertListResponseImpl(
      {required final List<TradeAlertModel> alerts,
      required this.pagination,
      this.unreadCount = 0})
      : _alerts = alerts,
        super._();

  final List<TradeAlertModel> _alerts;
  @override
  List<TradeAlertModel> get alerts {
    if (_alerts is EqualUnmodifiableListView) return _alerts;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_alerts);
  }

  @override
  final PaginationInfo pagination;
  @override
  @JsonKey()
  final int unreadCount;

  @override
  String toString() {
    return 'TradeAlertListResponse(alerts: $alerts, pagination: $pagination, unreadCount: $unreadCount)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TradeAlertListResponseImpl &&
            const DeepCollectionEquality().equals(other._alerts, _alerts) &&
            (identical(other.pagination, pagination) ||
                other.pagination == pagination) &&
            (identical(other.unreadCount, unreadCount) ||
                other.unreadCount == unreadCount));
  }

  @override
  int get hashCode => Object.hash(runtimeType,
      const DeepCollectionEquality().hash(_alerts), pagination, unreadCount);

  /// Create a copy of TradeAlertListResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TradeAlertListResponseImplCopyWith<_$TradeAlertListResponseImpl>
      get copyWith => __$$TradeAlertListResponseImplCopyWithImpl<
          _$TradeAlertListResponseImpl>(this, _$identity);
}

abstract class _TradeAlertListResponse extends TradeAlertListResponse {
  const factory _TradeAlertListResponse(
      {required final List<TradeAlertModel> alerts,
      required final PaginationInfo pagination,
      final int unreadCount}) = _$TradeAlertListResponseImpl;
  const _TradeAlertListResponse._() : super._();

  @override
  List<TradeAlertModel> get alerts;
  @override
  PaginationInfo get pagination;
  @override
  int get unreadCount;

  /// Create a copy of TradeAlertListResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TradeAlertListResponseImplCopyWith<_$TradeAlertListResponseImpl>
      get copyWith => throw _privateConstructorUsedError;
}

PaginationInfo _$PaginationInfoFromJson(Map<String, dynamic> json) {
  return _PaginationInfo.fromJson(json);
}

/// @nodoc
mixin _$PaginationInfo {
  int get page => throw _privateConstructorUsedError;
  @JsonKey(name: 'page_size')
  int get pageSize => throw _privateConstructorUsedError;
  @JsonKey(name: 'total_count')
  int get totalCount => throw _privateConstructorUsedError;
  @JsonKey(name: 'total_pages')
  int get totalPages => throw _privateConstructorUsedError;
  @JsonKey(name: 'has_next')
  bool get hasNext => throw _privateConstructorUsedError;
  @JsonKey(name: 'has_prev')
  bool get hasPrev => throw _privateConstructorUsedError;

  /// Serializes this PaginationInfo to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PaginationInfo
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PaginationInfoCopyWith<PaginationInfo> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PaginationInfoCopyWith<$Res> {
  factory $PaginationInfoCopyWith(
          PaginationInfo value, $Res Function(PaginationInfo) then) =
      _$PaginationInfoCopyWithImpl<$Res, PaginationInfo>;
  @useResult
  $Res call(
      {int page,
      @JsonKey(name: 'page_size') int pageSize,
      @JsonKey(name: 'total_count') int totalCount,
      @JsonKey(name: 'total_pages') int totalPages,
      @JsonKey(name: 'has_next') bool hasNext,
      @JsonKey(name: 'has_prev') bool hasPrev});
}

/// @nodoc
class _$PaginationInfoCopyWithImpl<$Res, $Val extends PaginationInfo>
    implements $PaginationInfoCopyWith<$Res> {
  _$PaginationInfoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PaginationInfo
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? page = null,
    Object? pageSize = null,
    Object? totalCount = null,
    Object? totalPages = null,
    Object? hasNext = null,
    Object? hasPrev = null,
  }) {
    return _then(_value.copyWith(
      page: null == page
          ? _value.page
          : page // ignore: cast_nullable_to_non_nullable
              as int,
      pageSize: null == pageSize
          ? _value.pageSize
          : pageSize // ignore: cast_nullable_to_non_nullable
              as int,
      totalCount: null == totalCount
          ? _value.totalCount
          : totalCount // ignore: cast_nullable_to_non_nullable
              as int,
      totalPages: null == totalPages
          ? _value.totalPages
          : totalPages // ignore: cast_nullable_to_non_nullable
              as int,
      hasNext: null == hasNext
          ? _value.hasNext
          : hasNext // ignore: cast_nullable_to_non_nullable
              as bool,
      hasPrev: null == hasPrev
          ? _value.hasPrev
          : hasPrev // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PaginationInfoImplCopyWith<$Res>
    implements $PaginationInfoCopyWith<$Res> {
  factory _$$PaginationInfoImplCopyWith(_$PaginationInfoImpl value,
          $Res Function(_$PaginationInfoImpl) then) =
      __$$PaginationInfoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int page,
      @JsonKey(name: 'page_size') int pageSize,
      @JsonKey(name: 'total_count') int totalCount,
      @JsonKey(name: 'total_pages') int totalPages,
      @JsonKey(name: 'has_next') bool hasNext,
      @JsonKey(name: 'has_prev') bool hasPrev});
}

/// @nodoc
class __$$PaginationInfoImplCopyWithImpl<$Res>
    extends _$PaginationInfoCopyWithImpl<$Res, _$PaginationInfoImpl>
    implements _$$PaginationInfoImplCopyWith<$Res> {
  __$$PaginationInfoImplCopyWithImpl(
      _$PaginationInfoImpl _value, $Res Function(_$PaginationInfoImpl) _then)
      : super(_value, _then);

  /// Create a copy of PaginationInfo
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? page = null,
    Object? pageSize = null,
    Object? totalCount = null,
    Object? totalPages = null,
    Object? hasNext = null,
    Object? hasPrev = null,
  }) {
    return _then(_$PaginationInfoImpl(
      page: null == page
          ? _value.page
          : page // ignore: cast_nullable_to_non_nullable
              as int,
      pageSize: null == pageSize
          ? _value.pageSize
          : pageSize // ignore: cast_nullable_to_non_nullable
              as int,
      totalCount: null == totalCount
          ? _value.totalCount
          : totalCount // ignore: cast_nullable_to_non_nullable
              as int,
      totalPages: null == totalPages
          ? _value.totalPages
          : totalPages // ignore: cast_nullable_to_non_nullable
              as int,
      hasNext: null == hasNext
          ? _value.hasNext
          : hasNext // ignore: cast_nullable_to_non_nullable
              as bool,
      hasPrev: null == hasPrev
          ? _value.hasPrev
          : hasPrev // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PaginationInfoImpl implements _PaginationInfo {
  const _$PaginationInfoImpl(
      {this.page = 1,
      @JsonKey(name: 'page_size') this.pageSize = 20,
      @JsonKey(name: 'total_count') this.totalCount = 0,
      @JsonKey(name: 'total_pages') this.totalPages = 0,
      @JsonKey(name: 'has_next') this.hasNext = false,
      @JsonKey(name: 'has_prev') this.hasPrev = false});

  factory _$PaginationInfoImpl.fromJson(Map<String, dynamic> json) =>
      _$$PaginationInfoImplFromJson(json);

  @override
  @JsonKey()
  final int page;
  @override
  @JsonKey(name: 'page_size')
  final int pageSize;
  @override
  @JsonKey(name: 'total_count')
  final int totalCount;
  @override
  @JsonKey(name: 'total_pages')
  final int totalPages;
  @override
  @JsonKey(name: 'has_next')
  final bool hasNext;
  @override
  @JsonKey(name: 'has_prev')
  final bool hasPrev;

  @override
  String toString() {
    return 'PaginationInfo(page: $page, pageSize: $pageSize, totalCount: $totalCount, totalPages: $totalPages, hasNext: $hasNext, hasPrev: $hasPrev)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PaginationInfoImpl &&
            (identical(other.page, page) || other.page == page) &&
            (identical(other.pageSize, pageSize) ||
                other.pageSize == pageSize) &&
            (identical(other.totalCount, totalCount) ||
                other.totalCount == totalCount) &&
            (identical(other.totalPages, totalPages) ||
                other.totalPages == totalPages) &&
            (identical(other.hasNext, hasNext) || other.hasNext == hasNext) &&
            (identical(other.hasPrev, hasPrev) || other.hasPrev == hasPrev));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, page, pageSize, totalCount, totalPages, hasNext, hasPrev);

  /// Create a copy of PaginationInfo
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PaginationInfoImplCopyWith<_$PaginationInfoImpl> get copyWith =>
      __$$PaginationInfoImplCopyWithImpl<_$PaginationInfoImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PaginationInfoImplToJson(
      this,
    );
  }
}

abstract class _PaginationInfo implements PaginationInfo {
  const factory _PaginationInfo(
      {final int page,
      @JsonKey(name: 'page_size') final int pageSize,
      @JsonKey(name: 'total_count') final int totalCount,
      @JsonKey(name: 'total_pages') final int totalPages,
      @JsonKey(name: 'has_next') final bool hasNext,
      @JsonKey(name: 'has_prev') final bool hasPrev}) = _$PaginationInfoImpl;

  factory _PaginationInfo.fromJson(Map<String, dynamic> json) =
      _$PaginationInfoImpl.fromJson;

  @override
  int get page;
  @override
  @JsonKey(name: 'page_size')
  int get pageSize;
  @override
  @JsonKey(name: 'total_count')
  int get totalCount;
  @override
  @JsonKey(name: 'total_pages')
  int get totalPages;
  @override
  @JsonKey(name: 'has_next')
  bool get hasNext;
  @override
  @JsonKey(name: 'has_prev')
  bool get hasPrev;

  /// Create a copy of PaginationInfo
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PaginationInfoImplCopyWith<_$PaginationInfoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
