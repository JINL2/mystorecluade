// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'shift_audit_log_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ShiftAuditLogDto _$ShiftAuditLogDtoFromJson(Map<String, dynamic> json) {
  return _ShiftAuditLogDto.fromJson(json);
}

/// @nodoc
mixin _$ShiftAuditLogDto {
  /// Unique identifier
  @JsonKey(name: 'audit_id')
  String get auditId => throw _privateConstructorUsedError;

  /// The shift request this log belongs to
  @JsonKey(name: 'shift_request_id')
  String get shiftRequestId => throw _privateConstructorUsedError;

  /// Operation type: INSERT, UPDATE, DELETE
  @JsonKey(name: 'operation')
  String get operation => throw _privateConstructorUsedError;

  /// Action type: CHECKIN, CHECKOUT, REPORT, MANAGER_EDIT, etc.
  @JsonKey(name: 'action_type')
  String get actionType => throw _privateConstructorUsedError;

  /// Event type: employee_checked_in, employee_late, shift_reported, etc.
  @JsonKey(name: 'event_type')
  String? get eventType => throw _privateConstructorUsedError;

  /// Changed column names array
  @JsonKey(name: 'changed_columns')
  List<String>? get changedColumns => throw _privateConstructorUsedError;

  /// Detailed change information (field -> {from, to})
  @JsonKey(name: 'change_details')
  Map<String, dynamic>? get changeDetails => throw _privateConstructorUsedError;

  /// User ID who made the change
  @JsonKey(name: 'changed_by')
  String? get changedBy => throw _privateConstructorUsedError;

  /// Display name of user who made the change (from RPC join)
  @JsonKey(name: 'changed_by_name')
  String? get changedByName => throw _privateConstructorUsedError;

  /// Profile image URL of user who made the change (from RPC join)
  @JsonKey(name: 'changed_by_profile_image')
  String? get changedByProfileImage => throw _privateConstructorUsedError;

  /// When the change was made (UTC timestamp string)
  @JsonKey(name: 'changed_at')
  String? get changedAt => throw _privateConstructorUsedError;

  /// Reason for the change
  @JsonKey(name: 'reason')
  String? get reason => throw _privateConstructorUsedError;

  /// New data after the change (full snapshot)
  @JsonKey(name: 'new_data')
  Map<String, dynamic>? get newData => throw _privateConstructorUsedError;

  /// Old data before the change (full snapshot)
  @JsonKey(name: 'old_data')
  Map<String, dynamic>? get oldData => throw _privateConstructorUsedError;

  /// Profile information (joined from profiles table)
  /// Structure: {"display_name": "John"}
  @JsonKey(name: 'profiles')
  Map<String, dynamic>? get profiles => throw _privateConstructorUsedError;

  /// Event-specific data (contains employee_name, store_name, etc.)
  @JsonKey(name: 'event_data')
  Map<String, dynamic>? get eventData => throw _privateConstructorUsedError;

  /// Serializes this ShiftAuditLogDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ShiftAuditLogDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ShiftAuditLogDtoCopyWith<ShiftAuditLogDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ShiftAuditLogDtoCopyWith<$Res> {
  factory $ShiftAuditLogDtoCopyWith(
          ShiftAuditLogDto value, $Res Function(ShiftAuditLogDto) then) =
      _$ShiftAuditLogDtoCopyWithImpl<$Res, ShiftAuditLogDto>;
  @useResult
  $Res call(
      {@JsonKey(name: 'audit_id') String auditId,
      @JsonKey(name: 'shift_request_id') String shiftRequestId,
      @JsonKey(name: 'operation') String operation,
      @JsonKey(name: 'action_type') String actionType,
      @JsonKey(name: 'event_type') String? eventType,
      @JsonKey(name: 'changed_columns') List<String>? changedColumns,
      @JsonKey(name: 'change_details') Map<String, dynamic>? changeDetails,
      @JsonKey(name: 'changed_by') String? changedBy,
      @JsonKey(name: 'changed_by_name') String? changedByName,
      @JsonKey(name: 'changed_by_profile_image') String? changedByProfileImage,
      @JsonKey(name: 'changed_at') String? changedAt,
      @JsonKey(name: 'reason') String? reason,
      @JsonKey(name: 'new_data') Map<String, dynamic>? newData,
      @JsonKey(name: 'old_data') Map<String, dynamic>? oldData,
      @JsonKey(name: 'profiles') Map<String, dynamic>? profiles,
      @JsonKey(name: 'event_data') Map<String, dynamic>? eventData});
}

/// @nodoc
class _$ShiftAuditLogDtoCopyWithImpl<$Res, $Val extends ShiftAuditLogDto>
    implements $ShiftAuditLogDtoCopyWith<$Res> {
  _$ShiftAuditLogDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ShiftAuditLogDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? auditId = null,
    Object? shiftRequestId = null,
    Object? operation = null,
    Object? actionType = null,
    Object? eventType = freezed,
    Object? changedColumns = freezed,
    Object? changeDetails = freezed,
    Object? changedBy = freezed,
    Object? changedByName = freezed,
    Object? changedByProfileImage = freezed,
    Object? changedAt = freezed,
    Object? reason = freezed,
    Object? newData = freezed,
    Object? oldData = freezed,
    Object? profiles = freezed,
    Object? eventData = freezed,
  }) {
    return _then(_value.copyWith(
      auditId: null == auditId
          ? _value.auditId
          : auditId // ignore: cast_nullable_to_non_nullable
              as String,
      shiftRequestId: null == shiftRequestId
          ? _value.shiftRequestId
          : shiftRequestId // ignore: cast_nullable_to_non_nullable
              as String,
      operation: null == operation
          ? _value.operation
          : operation // ignore: cast_nullable_to_non_nullable
              as String,
      actionType: null == actionType
          ? _value.actionType
          : actionType // ignore: cast_nullable_to_non_nullable
              as String,
      eventType: freezed == eventType
          ? _value.eventType
          : eventType // ignore: cast_nullable_to_non_nullable
              as String?,
      changedColumns: freezed == changedColumns
          ? _value.changedColumns
          : changedColumns // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      changeDetails: freezed == changeDetails
          ? _value.changeDetails
          : changeDetails // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      changedBy: freezed == changedBy
          ? _value.changedBy
          : changedBy // ignore: cast_nullable_to_non_nullable
              as String?,
      changedByName: freezed == changedByName
          ? _value.changedByName
          : changedByName // ignore: cast_nullable_to_non_nullable
              as String?,
      changedByProfileImage: freezed == changedByProfileImage
          ? _value.changedByProfileImage
          : changedByProfileImage // ignore: cast_nullable_to_non_nullable
              as String?,
      changedAt: freezed == changedAt
          ? _value.changedAt
          : changedAt // ignore: cast_nullable_to_non_nullable
              as String?,
      reason: freezed == reason
          ? _value.reason
          : reason // ignore: cast_nullable_to_non_nullable
              as String?,
      newData: freezed == newData
          ? _value.newData
          : newData // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      oldData: freezed == oldData
          ? _value.oldData
          : oldData // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      profiles: freezed == profiles
          ? _value.profiles
          : profiles // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      eventData: freezed == eventData
          ? _value.eventData
          : eventData // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ShiftAuditLogDtoImplCopyWith<$Res>
    implements $ShiftAuditLogDtoCopyWith<$Res> {
  factory _$$ShiftAuditLogDtoImplCopyWith(_$ShiftAuditLogDtoImpl value,
          $Res Function(_$ShiftAuditLogDtoImpl) then) =
      __$$ShiftAuditLogDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'audit_id') String auditId,
      @JsonKey(name: 'shift_request_id') String shiftRequestId,
      @JsonKey(name: 'operation') String operation,
      @JsonKey(name: 'action_type') String actionType,
      @JsonKey(name: 'event_type') String? eventType,
      @JsonKey(name: 'changed_columns') List<String>? changedColumns,
      @JsonKey(name: 'change_details') Map<String, dynamic>? changeDetails,
      @JsonKey(name: 'changed_by') String? changedBy,
      @JsonKey(name: 'changed_by_name') String? changedByName,
      @JsonKey(name: 'changed_by_profile_image') String? changedByProfileImage,
      @JsonKey(name: 'changed_at') String? changedAt,
      @JsonKey(name: 'reason') String? reason,
      @JsonKey(name: 'new_data') Map<String, dynamic>? newData,
      @JsonKey(name: 'old_data') Map<String, dynamic>? oldData,
      @JsonKey(name: 'profiles') Map<String, dynamic>? profiles,
      @JsonKey(name: 'event_data') Map<String, dynamic>? eventData});
}

/// @nodoc
class __$$ShiftAuditLogDtoImplCopyWithImpl<$Res>
    extends _$ShiftAuditLogDtoCopyWithImpl<$Res, _$ShiftAuditLogDtoImpl>
    implements _$$ShiftAuditLogDtoImplCopyWith<$Res> {
  __$$ShiftAuditLogDtoImplCopyWithImpl(_$ShiftAuditLogDtoImpl _value,
      $Res Function(_$ShiftAuditLogDtoImpl) _then)
      : super(_value, _then);

  /// Create a copy of ShiftAuditLogDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? auditId = null,
    Object? shiftRequestId = null,
    Object? operation = null,
    Object? actionType = null,
    Object? eventType = freezed,
    Object? changedColumns = freezed,
    Object? changeDetails = freezed,
    Object? changedBy = freezed,
    Object? changedByName = freezed,
    Object? changedByProfileImage = freezed,
    Object? changedAt = freezed,
    Object? reason = freezed,
    Object? newData = freezed,
    Object? oldData = freezed,
    Object? profiles = freezed,
    Object? eventData = freezed,
  }) {
    return _then(_$ShiftAuditLogDtoImpl(
      auditId: null == auditId
          ? _value.auditId
          : auditId // ignore: cast_nullable_to_non_nullable
              as String,
      shiftRequestId: null == shiftRequestId
          ? _value.shiftRequestId
          : shiftRequestId // ignore: cast_nullable_to_non_nullable
              as String,
      operation: null == operation
          ? _value.operation
          : operation // ignore: cast_nullable_to_non_nullable
              as String,
      actionType: null == actionType
          ? _value.actionType
          : actionType // ignore: cast_nullable_to_non_nullable
              as String,
      eventType: freezed == eventType
          ? _value.eventType
          : eventType // ignore: cast_nullable_to_non_nullable
              as String?,
      changedColumns: freezed == changedColumns
          ? _value._changedColumns
          : changedColumns // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      changeDetails: freezed == changeDetails
          ? _value._changeDetails
          : changeDetails // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      changedBy: freezed == changedBy
          ? _value.changedBy
          : changedBy // ignore: cast_nullable_to_non_nullable
              as String?,
      changedByName: freezed == changedByName
          ? _value.changedByName
          : changedByName // ignore: cast_nullable_to_non_nullable
              as String?,
      changedByProfileImage: freezed == changedByProfileImage
          ? _value.changedByProfileImage
          : changedByProfileImage // ignore: cast_nullable_to_non_nullable
              as String?,
      changedAt: freezed == changedAt
          ? _value.changedAt
          : changedAt // ignore: cast_nullable_to_non_nullable
              as String?,
      reason: freezed == reason
          ? _value.reason
          : reason // ignore: cast_nullable_to_non_nullable
              as String?,
      newData: freezed == newData
          ? _value._newData
          : newData // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      oldData: freezed == oldData
          ? _value._oldData
          : oldData // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      profiles: freezed == profiles
          ? _value._profiles
          : profiles // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      eventData: freezed == eventData
          ? _value._eventData
          : eventData // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ShiftAuditLogDtoImpl implements _ShiftAuditLogDto {
  const _$ShiftAuditLogDtoImpl(
      {@JsonKey(name: 'audit_id') this.auditId = '',
      @JsonKey(name: 'shift_request_id') this.shiftRequestId = '',
      @JsonKey(name: 'operation') this.operation = '',
      @JsonKey(name: 'action_type') this.actionType = '',
      @JsonKey(name: 'event_type') this.eventType,
      @JsonKey(name: 'changed_columns') final List<String>? changedColumns,
      @JsonKey(name: 'change_details')
      final Map<String, dynamic>? changeDetails,
      @JsonKey(name: 'changed_by') this.changedBy,
      @JsonKey(name: 'changed_by_name') this.changedByName,
      @JsonKey(name: 'changed_by_profile_image') this.changedByProfileImage,
      @JsonKey(name: 'changed_at') this.changedAt,
      @JsonKey(name: 'reason') this.reason,
      @JsonKey(name: 'new_data') final Map<String, dynamic>? newData,
      @JsonKey(name: 'old_data') final Map<String, dynamic>? oldData,
      @JsonKey(name: 'profiles') final Map<String, dynamic>? profiles,
      @JsonKey(name: 'event_data') final Map<String, dynamic>? eventData})
      : _changedColumns = changedColumns,
        _changeDetails = changeDetails,
        _newData = newData,
        _oldData = oldData,
        _profiles = profiles,
        _eventData = eventData;

  factory _$ShiftAuditLogDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$ShiftAuditLogDtoImplFromJson(json);

  /// Unique identifier
  @override
  @JsonKey(name: 'audit_id')
  final String auditId;

  /// The shift request this log belongs to
  @override
  @JsonKey(name: 'shift_request_id')
  final String shiftRequestId;

  /// Operation type: INSERT, UPDATE, DELETE
  @override
  @JsonKey(name: 'operation')
  final String operation;

  /// Action type: CHECKIN, CHECKOUT, REPORT, MANAGER_EDIT, etc.
  @override
  @JsonKey(name: 'action_type')
  final String actionType;

  /// Event type: employee_checked_in, employee_late, shift_reported, etc.
  @override
  @JsonKey(name: 'event_type')
  final String? eventType;

  /// Changed column names array
  final List<String>? _changedColumns;

  /// Changed column names array
  @override
  @JsonKey(name: 'changed_columns')
  List<String>? get changedColumns {
    final value = _changedColumns;
    if (value == null) return null;
    if (_changedColumns is EqualUnmodifiableListView) return _changedColumns;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  /// Detailed change information (field -> {from, to})
  final Map<String, dynamic>? _changeDetails;

  /// Detailed change information (field -> {from, to})
  @override
  @JsonKey(name: 'change_details')
  Map<String, dynamic>? get changeDetails {
    final value = _changeDetails;
    if (value == null) return null;
    if (_changeDetails is EqualUnmodifiableMapView) return _changeDetails;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  /// User ID who made the change
  @override
  @JsonKey(name: 'changed_by')
  final String? changedBy;

  /// Display name of user who made the change (from RPC join)
  @override
  @JsonKey(name: 'changed_by_name')
  final String? changedByName;

  /// Profile image URL of user who made the change (from RPC join)
  @override
  @JsonKey(name: 'changed_by_profile_image')
  final String? changedByProfileImage;

  /// When the change was made (UTC timestamp string)
  @override
  @JsonKey(name: 'changed_at')
  final String? changedAt;

  /// Reason for the change
  @override
  @JsonKey(name: 'reason')
  final String? reason;

  /// New data after the change (full snapshot)
  final Map<String, dynamic>? _newData;

  /// New data after the change (full snapshot)
  @override
  @JsonKey(name: 'new_data')
  Map<String, dynamic>? get newData {
    final value = _newData;
    if (value == null) return null;
    if (_newData is EqualUnmodifiableMapView) return _newData;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  /// Old data before the change (full snapshot)
  final Map<String, dynamic>? _oldData;

  /// Old data before the change (full snapshot)
  @override
  @JsonKey(name: 'old_data')
  Map<String, dynamic>? get oldData {
    final value = _oldData;
    if (value == null) return null;
    if (_oldData is EqualUnmodifiableMapView) return _oldData;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  /// Profile information (joined from profiles table)
  /// Structure: {"display_name": "John"}
  final Map<String, dynamic>? _profiles;

  /// Profile information (joined from profiles table)
  /// Structure: {"display_name": "John"}
  @override
  @JsonKey(name: 'profiles')
  Map<String, dynamic>? get profiles {
    final value = _profiles;
    if (value == null) return null;
    if (_profiles is EqualUnmodifiableMapView) return _profiles;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  /// Event-specific data (contains employee_name, store_name, etc.)
  final Map<String, dynamic>? _eventData;

  /// Event-specific data (contains employee_name, store_name, etc.)
  @override
  @JsonKey(name: 'event_data')
  Map<String, dynamic>? get eventData {
    final value = _eventData;
    if (value == null) return null;
    if (_eventData is EqualUnmodifiableMapView) return _eventData;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  String toString() {
    return 'ShiftAuditLogDto(auditId: $auditId, shiftRequestId: $shiftRequestId, operation: $operation, actionType: $actionType, eventType: $eventType, changedColumns: $changedColumns, changeDetails: $changeDetails, changedBy: $changedBy, changedByName: $changedByName, changedByProfileImage: $changedByProfileImage, changedAt: $changedAt, reason: $reason, newData: $newData, oldData: $oldData, profiles: $profiles, eventData: $eventData)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ShiftAuditLogDtoImpl &&
            (identical(other.auditId, auditId) || other.auditId == auditId) &&
            (identical(other.shiftRequestId, shiftRequestId) ||
                other.shiftRequestId == shiftRequestId) &&
            (identical(other.operation, operation) ||
                other.operation == operation) &&
            (identical(other.actionType, actionType) ||
                other.actionType == actionType) &&
            (identical(other.eventType, eventType) ||
                other.eventType == eventType) &&
            const DeepCollectionEquality()
                .equals(other._changedColumns, _changedColumns) &&
            const DeepCollectionEquality()
                .equals(other._changeDetails, _changeDetails) &&
            (identical(other.changedBy, changedBy) ||
                other.changedBy == changedBy) &&
            (identical(other.changedByName, changedByName) ||
                other.changedByName == changedByName) &&
            (identical(other.changedByProfileImage, changedByProfileImage) ||
                other.changedByProfileImage == changedByProfileImage) &&
            (identical(other.changedAt, changedAt) ||
                other.changedAt == changedAt) &&
            (identical(other.reason, reason) || other.reason == reason) &&
            const DeepCollectionEquality().equals(other._newData, _newData) &&
            const DeepCollectionEquality().equals(other._oldData, _oldData) &&
            const DeepCollectionEquality().equals(other._profiles, _profiles) &&
            const DeepCollectionEquality().equals(other._eventData, _eventData));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      auditId,
      shiftRequestId,
      operation,
      actionType,
      eventType,
      const DeepCollectionEquality().hash(_changedColumns),
      const DeepCollectionEquality().hash(_changeDetails),
      changedBy,
      changedByName,
      changedByProfileImage,
      changedAt,
      reason,
      const DeepCollectionEquality().hash(_newData),
      const DeepCollectionEquality().hash(_oldData),
      const DeepCollectionEquality().hash(_profiles),
      const DeepCollectionEquality().hash(_eventData));

  /// Create a copy of ShiftAuditLogDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ShiftAuditLogDtoImplCopyWith<_$ShiftAuditLogDtoImpl> get copyWith =>
      __$$ShiftAuditLogDtoImplCopyWithImpl<_$ShiftAuditLogDtoImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ShiftAuditLogDtoImplToJson(
      this,
    );
  }
}

abstract class _ShiftAuditLogDto implements ShiftAuditLogDto {
  const factory _ShiftAuditLogDto(
          {@JsonKey(name: 'audit_id') final String auditId,
          @JsonKey(name: 'shift_request_id') final String shiftRequestId,
          @JsonKey(name: 'operation') final String operation,
          @JsonKey(name: 'action_type') final String actionType,
          @JsonKey(name: 'event_type') final String? eventType,
          @JsonKey(name: 'changed_columns') final List<String>? changedColumns,
          @JsonKey(name: 'change_details')
          final Map<String, dynamic>? changeDetails,
          @JsonKey(name: 'changed_by') final String? changedBy,
          @JsonKey(name: 'changed_by_name') final String? changedByName,
          @JsonKey(name: 'changed_by_profile_image') final String? changedByProfileImage,
          @JsonKey(name: 'changed_at') final String? changedAt,
          @JsonKey(name: 'reason') final String? reason,
          @JsonKey(name: 'new_data') final Map<String, dynamic>? newData,
          @JsonKey(name: 'old_data') final Map<String, dynamic>? oldData,
          @JsonKey(name: 'profiles') final Map<String, dynamic>? profiles,
          @JsonKey(name: 'event_data') final Map<String, dynamic>? eventData}) =
      _$ShiftAuditLogDtoImpl;

  factory _ShiftAuditLogDto.fromJson(Map<String, dynamic> json) =
      _$ShiftAuditLogDtoImpl.fromJson;

  /// Unique identifier
  @override
  @JsonKey(name: 'audit_id')
  String get auditId;

  /// The shift request this log belongs to
  @override
  @JsonKey(name: 'shift_request_id')
  String get shiftRequestId;

  /// Operation type: INSERT, UPDATE, DELETE
  @override
  @JsonKey(name: 'operation')
  String get operation;

  /// Action type: CHECKIN, CHECKOUT, REPORT, MANAGER_EDIT, etc.
  @override
  @JsonKey(name: 'action_type')
  String get actionType;

  /// Event type: employee_checked_in, employee_late, shift_reported, etc.
  @override
  @JsonKey(name: 'event_type')
  String? get eventType;

  /// Changed column names array
  @override
  @JsonKey(name: 'changed_columns')
  List<String>? get changedColumns;

  /// Detailed change information (field -> {from, to})
  @override
  @JsonKey(name: 'change_details')
  Map<String, dynamic>? get changeDetails;

  /// User ID who made the change
  @override
  @JsonKey(name: 'changed_by')
  String? get changedBy;

  /// Display name of user who made the change (from RPC join)
  @override
  @JsonKey(name: 'changed_by_name')
  String? get changedByName;

  /// Profile image URL of user who made the change (from RPC join)
  @override
  @JsonKey(name: 'changed_by_profile_image')
  String? get changedByProfileImage;

  /// When the change was made (UTC timestamp string)
  @override
  @JsonKey(name: 'changed_at')
  String? get changedAt;

  /// Reason for the change
  @override
  @JsonKey(name: 'reason')
  String? get reason;

  /// New data after the change (full snapshot)
  @override
  @JsonKey(name: 'new_data')
  Map<String, dynamic>? get newData;

  /// Old data before the change (full snapshot)
  @override
  @JsonKey(name: 'old_data')
  Map<String, dynamic>? get oldData;

  /// Profile information (joined from profiles table)
  /// Structure: {"display_name": "John"}
  @override
  @JsonKey(name: 'profiles')
  Map<String, dynamic>? get profiles;

  /// Event-specific data (contains employee_name, store_name, etc.)
  @override
  @JsonKey(name: 'event_data')
  Map<String, dynamic>? get eventData;

  /// Create a copy of ShiftAuditLogDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ShiftAuditLogDtoImplCopyWith<_$ShiftAuditLogDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
