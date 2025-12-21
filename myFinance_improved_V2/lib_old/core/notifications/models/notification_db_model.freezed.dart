// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'notification_db_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

NotificationDbModel _$NotificationDbModelFromJson(Map<String, dynamic> json) {
  return _NotificationDbModel.fromJson(json);
}

/// @nodoc
mixin _$NotificationDbModel {
  String? get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'user_id')
  String? get userId => throw _privateConstructorUsedError;
  String? get title => throw _privateConstructorUsedError;
  String? get body => throw _privateConstructorUsedError;
  String? get category => throw _privateConstructorUsedError;
  Map<String, dynamic>? get data => throw _privateConstructorUsedError;
  @JsonKey(name: 'image_url')
  String? get imageUrl => throw _privateConstructorUsedError;
  @JsonKey(name: 'action_url')
  String? get actionUrl => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_read')
  bool get isRead => throw _privateConstructorUsedError;
  @JsonKey(name: 'scheduled_time')
  DateTime? get scheduledTime => throw _privateConstructorUsedError;
  @JsonKey(name: 'sent_at')
  DateTime? get sentAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'read_at')
  DateTime? get readAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  DateTime? get createdAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'updated_at')
  DateTime? get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this NotificationDbModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of NotificationDbModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $NotificationDbModelCopyWith<NotificationDbModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $NotificationDbModelCopyWith<$Res> {
  factory $NotificationDbModelCopyWith(
          NotificationDbModel value, $Res Function(NotificationDbModel) then) =
      _$NotificationDbModelCopyWithImpl<$Res, NotificationDbModel>;
  @useResult
  $Res call(
      {String? id,
      @JsonKey(name: 'user_id') String? userId,
      String? title,
      String? body,
      String? category,
      Map<String, dynamic>? data,
      @JsonKey(name: 'image_url') String? imageUrl,
      @JsonKey(name: 'action_url') String? actionUrl,
      @JsonKey(name: 'is_read') bool isRead,
      @JsonKey(name: 'scheduled_time') DateTime? scheduledTime,
      @JsonKey(name: 'sent_at') DateTime? sentAt,
      @JsonKey(name: 'read_at') DateTime? readAt,
      @JsonKey(name: 'created_at') DateTime? createdAt,
      @JsonKey(name: 'updated_at') DateTime? updatedAt});
}

/// @nodoc
class _$NotificationDbModelCopyWithImpl<$Res, $Val extends NotificationDbModel>
    implements $NotificationDbModelCopyWith<$Res> {
  _$NotificationDbModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of NotificationDbModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? userId = freezed,
    Object? title = freezed,
    Object? body = freezed,
    Object? category = freezed,
    Object? data = freezed,
    Object? imageUrl = freezed,
    Object? actionUrl = freezed,
    Object? isRead = null,
    Object? scheduledTime = freezed,
    Object? sentAt = freezed,
    Object? readAt = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_value.copyWith(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
      userId: freezed == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String?,
      title: freezed == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String?,
      body: freezed == body
          ? _value.body
          : body // ignore: cast_nullable_to_non_nullable
              as String?,
      category: freezed == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as String?,
      data: freezed == data
          ? _value.data
          : data // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      imageUrl: freezed == imageUrl
          ? _value.imageUrl
          : imageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      actionUrl: freezed == actionUrl
          ? _value.actionUrl
          : actionUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      isRead: null == isRead
          ? _value.isRead
          : isRead // ignore: cast_nullable_to_non_nullable
              as bool,
      scheduledTime: freezed == scheduledTime
          ? _value.scheduledTime
          : scheduledTime // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      sentAt: freezed == sentAt
          ? _value.sentAt
          : sentAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      readAt: freezed == readAt
          ? _value.readAt
          : readAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$NotificationDbModelImplCopyWith<$Res>
    implements $NotificationDbModelCopyWith<$Res> {
  factory _$$NotificationDbModelImplCopyWith(_$NotificationDbModelImpl value,
          $Res Function(_$NotificationDbModelImpl) then) =
      __$$NotificationDbModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String? id,
      @JsonKey(name: 'user_id') String? userId,
      String? title,
      String? body,
      String? category,
      Map<String, dynamic>? data,
      @JsonKey(name: 'image_url') String? imageUrl,
      @JsonKey(name: 'action_url') String? actionUrl,
      @JsonKey(name: 'is_read') bool isRead,
      @JsonKey(name: 'scheduled_time') DateTime? scheduledTime,
      @JsonKey(name: 'sent_at') DateTime? sentAt,
      @JsonKey(name: 'read_at') DateTime? readAt,
      @JsonKey(name: 'created_at') DateTime? createdAt,
      @JsonKey(name: 'updated_at') DateTime? updatedAt});
}

/// @nodoc
class __$$NotificationDbModelImplCopyWithImpl<$Res>
    extends _$NotificationDbModelCopyWithImpl<$Res, _$NotificationDbModelImpl>
    implements _$$NotificationDbModelImplCopyWith<$Res> {
  __$$NotificationDbModelImplCopyWithImpl(_$NotificationDbModelImpl _value,
      $Res Function(_$NotificationDbModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of NotificationDbModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? userId = freezed,
    Object? title = freezed,
    Object? body = freezed,
    Object? category = freezed,
    Object? data = freezed,
    Object? imageUrl = freezed,
    Object? actionUrl = freezed,
    Object? isRead = null,
    Object? scheduledTime = freezed,
    Object? sentAt = freezed,
    Object? readAt = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_$NotificationDbModelImpl(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
      userId: freezed == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String?,
      title: freezed == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String?,
      body: freezed == body
          ? _value.body
          : body // ignore: cast_nullable_to_non_nullable
              as String?,
      category: freezed == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as String?,
      data: freezed == data
          ? _value._data
          : data // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      imageUrl: freezed == imageUrl
          ? _value.imageUrl
          : imageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      actionUrl: freezed == actionUrl
          ? _value.actionUrl
          : actionUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      isRead: null == isRead
          ? _value.isRead
          : isRead // ignore: cast_nullable_to_non_nullable
              as bool,
      scheduledTime: freezed == scheduledTime
          ? _value.scheduledTime
          : scheduledTime // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      sentAt: freezed == sentAt
          ? _value.sentAt
          : sentAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      readAt: freezed == readAt
          ? _value.readAt
          : readAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$NotificationDbModelImpl implements _NotificationDbModel {
  const _$NotificationDbModelImpl(
      {this.id,
      @JsonKey(name: 'user_id') this.userId,
      this.title,
      this.body,
      this.category,
      final Map<String, dynamic>? data,
      @JsonKey(name: 'image_url') this.imageUrl,
      @JsonKey(name: 'action_url') this.actionUrl,
      @JsonKey(name: 'is_read') this.isRead = false,
      @JsonKey(name: 'scheduled_time') this.scheduledTime,
      @JsonKey(name: 'sent_at') this.sentAt,
      @JsonKey(name: 'read_at') this.readAt,
      @JsonKey(name: 'created_at') this.createdAt,
      @JsonKey(name: 'updated_at') this.updatedAt})
      : _data = data;

  factory _$NotificationDbModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$NotificationDbModelImplFromJson(json);

  @override
  final String? id;
  @override
  @JsonKey(name: 'user_id')
  final String? userId;
  @override
  final String? title;
  @override
  final String? body;
  @override
  final String? category;
  final Map<String, dynamic>? _data;
  @override
  Map<String, dynamic>? get data {
    final value = _data;
    if (value == null) return null;
    if (_data is EqualUnmodifiableMapView) return _data;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  @JsonKey(name: 'image_url')
  final String? imageUrl;
  @override
  @JsonKey(name: 'action_url')
  final String? actionUrl;
  @override
  @JsonKey(name: 'is_read')
  final bool isRead;
  @override
  @JsonKey(name: 'scheduled_time')
  final DateTime? scheduledTime;
  @override
  @JsonKey(name: 'sent_at')
  final DateTime? sentAt;
  @override
  @JsonKey(name: 'read_at')
  final DateTime? readAt;
  @override
  @JsonKey(name: 'created_at')
  final DateTime? createdAt;
  @override
  @JsonKey(name: 'updated_at')
  final DateTime? updatedAt;

  @override
  String toString() {
    return 'NotificationDbModel(id: $id, userId: $userId, title: $title, body: $body, category: $category, data: $data, imageUrl: $imageUrl, actionUrl: $actionUrl, isRead: $isRead, scheduledTime: $scheduledTime, sentAt: $sentAt, readAt: $readAt, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$NotificationDbModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.body, body) || other.body == body) &&
            (identical(other.category, category) ||
                other.category == category) &&
            const DeepCollectionEquality().equals(other._data, _data) &&
            (identical(other.imageUrl, imageUrl) ||
                other.imageUrl == imageUrl) &&
            (identical(other.actionUrl, actionUrl) ||
                other.actionUrl == actionUrl) &&
            (identical(other.isRead, isRead) || other.isRead == isRead) &&
            (identical(other.scheduledTime, scheduledTime) ||
                other.scheduledTime == scheduledTime) &&
            (identical(other.sentAt, sentAt) || other.sentAt == sentAt) &&
            (identical(other.readAt, readAt) || other.readAt == readAt) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      userId,
      title,
      body,
      category,
      const DeepCollectionEquality().hash(_data),
      imageUrl,
      actionUrl,
      isRead,
      scheduledTime,
      sentAt,
      readAt,
      createdAt,
      updatedAt);

  /// Create a copy of NotificationDbModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$NotificationDbModelImplCopyWith<_$NotificationDbModelImpl> get copyWith =>
      __$$NotificationDbModelImplCopyWithImpl<_$NotificationDbModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$NotificationDbModelImplToJson(
      this,
    );
  }
}

abstract class _NotificationDbModel implements NotificationDbModel {
  const factory _NotificationDbModel(
          {final String? id,
          @JsonKey(name: 'user_id') final String? userId,
          final String? title,
          final String? body,
          final String? category,
          final Map<String, dynamic>? data,
          @JsonKey(name: 'image_url') final String? imageUrl,
          @JsonKey(name: 'action_url') final String? actionUrl,
          @JsonKey(name: 'is_read') final bool isRead,
          @JsonKey(name: 'scheduled_time') final DateTime? scheduledTime,
          @JsonKey(name: 'sent_at') final DateTime? sentAt,
          @JsonKey(name: 'read_at') final DateTime? readAt,
          @JsonKey(name: 'created_at') final DateTime? createdAt,
          @JsonKey(name: 'updated_at') final DateTime? updatedAt}) =
      _$NotificationDbModelImpl;

  factory _NotificationDbModel.fromJson(Map<String, dynamic> json) =
      _$NotificationDbModelImpl.fromJson;

  @override
  String? get id;
  @override
  @JsonKey(name: 'user_id')
  String? get userId;
  @override
  String? get title;
  @override
  String? get body;
  @override
  String? get category;
  @override
  Map<String, dynamic>? get data;
  @override
  @JsonKey(name: 'image_url')
  String? get imageUrl;
  @override
  @JsonKey(name: 'action_url')
  String? get actionUrl;
  @override
  @JsonKey(name: 'is_read')
  bool get isRead;
  @override
  @JsonKey(name: 'scheduled_time')
  DateTime? get scheduledTime;
  @override
  @JsonKey(name: 'sent_at')
  DateTime? get sentAt;
  @override
  @JsonKey(name: 'read_at')
  DateTime? get readAt;
  @override
  @JsonKey(name: 'created_at')
  DateTime? get createdAt;
  @override
  @JsonKey(name: 'updated_at')
  DateTime? get updatedAt;

  /// Create a copy of NotificationDbModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$NotificationDbModelImplCopyWith<_$NotificationDbModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

UserFcmTokenModel _$UserFcmTokenModelFromJson(Map<String, dynamic> json) {
  return _UserFcmTokenModel.fromJson(json);
}

/// @nodoc
mixin _$UserFcmTokenModel {
  String? get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'user_id')
  String? get userId => throw _privateConstructorUsedError;
  String? get token => throw _privateConstructorUsedError;
  String? get platform => throw _privateConstructorUsedError; // ios/android/web
  @JsonKey(name: 'device_id')
  String? get deviceId => throw _privateConstructorUsedError;
  @JsonKey(name: 'device_model')
  String? get deviceModel => throw _privateConstructorUsedError;
  @JsonKey(name: 'app_version')
  String? get appVersion => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_active')
  bool get isActive => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  DateTime? get createdAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'updated_at')
  DateTime? get updatedAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'last_used_at')
  DateTime? get lastUsedAt => throw _privateConstructorUsedError;

  /// Serializes this UserFcmTokenModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of UserFcmTokenModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $UserFcmTokenModelCopyWith<UserFcmTokenModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserFcmTokenModelCopyWith<$Res> {
  factory $UserFcmTokenModelCopyWith(
          UserFcmTokenModel value, $Res Function(UserFcmTokenModel) then) =
      _$UserFcmTokenModelCopyWithImpl<$Res, UserFcmTokenModel>;
  @useResult
  $Res call(
      {String? id,
      @JsonKey(name: 'user_id') String? userId,
      String? token,
      String? platform,
      @JsonKey(name: 'device_id') String? deviceId,
      @JsonKey(name: 'device_model') String? deviceModel,
      @JsonKey(name: 'app_version') String? appVersion,
      @JsonKey(name: 'is_active') bool isActive,
      @JsonKey(name: 'created_at') DateTime? createdAt,
      @JsonKey(name: 'updated_at') DateTime? updatedAt,
      @JsonKey(name: 'last_used_at') DateTime? lastUsedAt});
}

/// @nodoc
class _$UserFcmTokenModelCopyWithImpl<$Res, $Val extends UserFcmTokenModel>
    implements $UserFcmTokenModelCopyWith<$Res> {
  _$UserFcmTokenModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of UserFcmTokenModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? userId = freezed,
    Object? token = freezed,
    Object? platform = freezed,
    Object? deviceId = freezed,
    Object? deviceModel = freezed,
    Object? appVersion = freezed,
    Object? isActive = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
    Object? lastUsedAt = freezed,
  }) {
    return _then(_value.copyWith(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
      userId: freezed == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String?,
      token: freezed == token
          ? _value.token
          : token // ignore: cast_nullable_to_non_nullable
              as String?,
      platform: freezed == platform
          ? _value.platform
          : platform // ignore: cast_nullable_to_non_nullable
              as String?,
      deviceId: freezed == deviceId
          ? _value.deviceId
          : deviceId // ignore: cast_nullable_to_non_nullable
              as String?,
      deviceModel: freezed == deviceModel
          ? _value.deviceModel
          : deviceModel // ignore: cast_nullable_to_non_nullable
              as String?,
      appVersion: freezed == appVersion
          ? _value.appVersion
          : appVersion // ignore: cast_nullable_to_non_nullable
              as String?,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      lastUsedAt: freezed == lastUsedAt
          ? _value.lastUsedAt
          : lastUsedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$UserFcmTokenModelImplCopyWith<$Res>
    implements $UserFcmTokenModelCopyWith<$Res> {
  factory _$$UserFcmTokenModelImplCopyWith(_$UserFcmTokenModelImpl value,
          $Res Function(_$UserFcmTokenModelImpl) then) =
      __$$UserFcmTokenModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String? id,
      @JsonKey(name: 'user_id') String? userId,
      String? token,
      String? platform,
      @JsonKey(name: 'device_id') String? deviceId,
      @JsonKey(name: 'device_model') String? deviceModel,
      @JsonKey(name: 'app_version') String? appVersion,
      @JsonKey(name: 'is_active') bool isActive,
      @JsonKey(name: 'created_at') DateTime? createdAt,
      @JsonKey(name: 'updated_at') DateTime? updatedAt,
      @JsonKey(name: 'last_used_at') DateTime? lastUsedAt});
}

/// @nodoc
class __$$UserFcmTokenModelImplCopyWithImpl<$Res>
    extends _$UserFcmTokenModelCopyWithImpl<$Res, _$UserFcmTokenModelImpl>
    implements _$$UserFcmTokenModelImplCopyWith<$Res> {
  __$$UserFcmTokenModelImplCopyWithImpl(_$UserFcmTokenModelImpl _value,
      $Res Function(_$UserFcmTokenModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of UserFcmTokenModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? userId = freezed,
    Object? token = freezed,
    Object? platform = freezed,
    Object? deviceId = freezed,
    Object? deviceModel = freezed,
    Object? appVersion = freezed,
    Object? isActive = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
    Object? lastUsedAt = freezed,
  }) {
    return _then(_$UserFcmTokenModelImpl(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
      userId: freezed == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String?,
      token: freezed == token
          ? _value.token
          : token // ignore: cast_nullable_to_non_nullable
              as String?,
      platform: freezed == platform
          ? _value.platform
          : platform // ignore: cast_nullable_to_non_nullable
              as String?,
      deviceId: freezed == deviceId
          ? _value.deviceId
          : deviceId // ignore: cast_nullable_to_non_nullable
              as String?,
      deviceModel: freezed == deviceModel
          ? _value.deviceModel
          : deviceModel // ignore: cast_nullable_to_non_nullable
              as String?,
      appVersion: freezed == appVersion
          ? _value.appVersion
          : appVersion // ignore: cast_nullable_to_non_nullable
              as String?,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      lastUsedAt: freezed == lastUsedAt
          ? _value.lastUsedAt
          : lastUsedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$UserFcmTokenModelImpl implements _UserFcmTokenModel {
  const _$UserFcmTokenModelImpl(
      {this.id,
      @JsonKey(name: 'user_id') this.userId,
      this.token,
      this.platform,
      @JsonKey(name: 'device_id') this.deviceId,
      @JsonKey(name: 'device_model') this.deviceModel,
      @JsonKey(name: 'app_version') this.appVersion,
      @JsonKey(name: 'is_active') this.isActive = true,
      @JsonKey(name: 'created_at') this.createdAt,
      @JsonKey(name: 'updated_at') this.updatedAt,
      @JsonKey(name: 'last_used_at') this.lastUsedAt});

  factory _$UserFcmTokenModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$UserFcmTokenModelImplFromJson(json);

  @override
  final String? id;
  @override
  @JsonKey(name: 'user_id')
  final String? userId;
  @override
  final String? token;
  @override
  final String? platform;
// ios/android/web
  @override
  @JsonKey(name: 'device_id')
  final String? deviceId;
  @override
  @JsonKey(name: 'device_model')
  final String? deviceModel;
  @override
  @JsonKey(name: 'app_version')
  final String? appVersion;
  @override
  @JsonKey(name: 'is_active')
  final bool isActive;
  @override
  @JsonKey(name: 'created_at')
  final DateTime? createdAt;
  @override
  @JsonKey(name: 'updated_at')
  final DateTime? updatedAt;
  @override
  @JsonKey(name: 'last_used_at')
  final DateTime? lastUsedAt;

  @override
  String toString() {
    return 'UserFcmTokenModel(id: $id, userId: $userId, token: $token, platform: $platform, deviceId: $deviceId, deviceModel: $deviceModel, appVersion: $appVersion, isActive: $isActive, createdAt: $createdAt, updatedAt: $updatedAt, lastUsedAt: $lastUsedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserFcmTokenModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.token, token) || other.token == token) &&
            (identical(other.platform, platform) ||
                other.platform == platform) &&
            (identical(other.deviceId, deviceId) ||
                other.deviceId == deviceId) &&
            (identical(other.deviceModel, deviceModel) ||
                other.deviceModel == deviceModel) &&
            (identical(other.appVersion, appVersion) ||
                other.appVersion == appVersion) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.lastUsedAt, lastUsedAt) ||
                other.lastUsedAt == lastUsedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      userId,
      token,
      platform,
      deviceId,
      deviceModel,
      appVersion,
      isActive,
      createdAt,
      updatedAt,
      lastUsedAt);

  /// Create a copy of UserFcmTokenModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UserFcmTokenModelImplCopyWith<_$UserFcmTokenModelImpl> get copyWith =>
      __$$UserFcmTokenModelImplCopyWithImpl<_$UserFcmTokenModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UserFcmTokenModelImplToJson(
      this,
    );
  }
}

abstract class _UserFcmTokenModel implements UserFcmTokenModel {
  const factory _UserFcmTokenModel(
          {final String? id,
          @JsonKey(name: 'user_id') final String? userId,
          final String? token,
          final String? platform,
          @JsonKey(name: 'device_id') final String? deviceId,
          @JsonKey(name: 'device_model') final String? deviceModel,
          @JsonKey(name: 'app_version') final String? appVersion,
          @JsonKey(name: 'is_active') final bool isActive,
          @JsonKey(name: 'created_at') final DateTime? createdAt,
          @JsonKey(name: 'updated_at') final DateTime? updatedAt,
          @JsonKey(name: 'last_used_at') final DateTime? lastUsedAt}) =
      _$UserFcmTokenModelImpl;

  factory _UserFcmTokenModel.fromJson(Map<String, dynamic> json) =
      _$UserFcmTokenModelImpl.fromJson;

  @override
  String? get id;
  @override
  @JsonKey(name: 'user_id')
  String? get userId;
  @override
  String? get token;
  @override
  String? get platform; // ios/android/web
  @override
  @JsonKey(name: 'device_id')
  String? get deviceId;
  @override
  @JsonKey(name: 'device_model')
  String? get deviceModel;
  @override
  @JsonKey(name: 'app_version')
  String? get appVersion;
  @override
  @JsonKey(name: 'is_active')
  bool get isActive;
  @override
  @JsonKey(name: 'created_at')
  DateTime? get createdAt;
  @override
  @JsonKey(name: 'updated_at')
  DateTime? get updatedAt;
  @override
  @JsonKey(name: 'last_used_at')
  DateTime? get lastUsedAt;

  /// Create a copy of UserFcmTokenModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UserFcmTokenModelImplCopyWith<_$UserFcmTokenModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

UserNotificationSettingsModel _$UserNotificationSettingsModelFromJson(
    Map<String, dynamic> json) {
  return _UserNotificationSettingsModel.fromJson(json);
}

/// @nodoc
mixin _$UserNotificationSettingsModel {
  String? get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'user_id')
  String? get userId => throw _privateConstructorUsedError;
  @JsonKey(name: 'push_enabled')
  bool get pushEnabled => throw _privateConstructorUsedError;
  @JsonKey(name: 'email_enabled')
  bool get emailEnabled => throw _privateConstructorUsedError;
  @JsonKey(name: 'transaction_alerts')
  bool get transactionAlerts => throw _privateConstructorUsedError;
  bool get reminders => throw _privateConstructorUsedError;
  @JsonKey(name: 'marketing_messages')
  bool get marketingMessages => throw _privateConstructorUsedError;
  @JsonKey(name: 'sound_preference')
  String get soundPreference => throw _privateConstructorUsedError;
  @JsonKey(name: 'vibration_enabled')
  bool get vibrationEnabled => throw _privateConstructorUsedError;
  @JsonKey(name: 'category_preferences')
  Map<String, dynamic> get categoryPreferences =>
      throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  DateTime? get createdAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'updated_at')
  DateTime? get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this UserNotificationSettingsModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of UserNotificationSettingsModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $UserNotificationSettingsModelCopyWith<UserNotificationSettingsModel>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserNotificationSettingsModelCopyWith<$Res> {
  factory $UserNotificationSettingsModelCopyWith(
          UserNotificationSettingsModel value,
          $Res Function(UserNotificationSettingsModel) then) =
      _$UserNotificationSettingsModelCopyWithImpl<$Res,
          UserNotificationSettingsModel>;
  @useResult
  $Res call(
      {String? id,
      @JsonKey(name: 'user_id') String? userId,
      @JsonKey(name: 'push_enabled') bool pushEnabled,
      @JsonKey(name: 'email_enabled') bool emailEnabled,
      @JsonKey(name: 'transaction_alerts') bool transactionAlerts,
      bool reminders,
      @JsonKey(name: 'marketing_messages') bool marketingMessages,
      @JsonKey(name: 'sound_preference') String soundPreference,
      @JsonKey(name: 'vibration_enabled') bool vibrationEnabled,
      @JsonKey(name: 'category_preferences')
      Map<String, dynamic> categoryPreferences,
      @JsonKey(name: 'created_at') DateTime? createdAt,
      @JsonKey(name: 'updated_at') DateTime? updatedAt});
}

/// @nodoc
class _$UserNotificationSettingsModelCopyWithImpl<$Res,
        $Val extends UserNotificationSettingsModel>
    implements $UserNotificationSettingsModelCopyWith<$Res> {
  _$UserNotificationSettingsModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of UserNotificationSettingsModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? userId = freezed,
    Object? pushEnabled = null,
    Object? emailEnabled = null,
    Object? transactionAlerts = null,
    Object? reminders = null,
    Object? marketingMessages = null,
    Object? soundPreference = null,
    Object? vibrationEnabled = null,
    Object? categoryPreferences = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_value.copyWith(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
      userId: freezed == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String?,
      pushEnabled: null == pushEnabled
          ? _value.pushEnabled
          : pushEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      emailEnabled: null == emailEnabled
          ? _value.emailEnabled
          : emailEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      transactionAlerts: null == transactionAlerts
          ? _value.transactionAlerts
          : transactionAlerts // ignore: cast_nullable_to_non_nullable
              as bool,
      reminders: null == reminders
          ? _value.reminders
          : reminders // ignore: cast_nullable_to_non_nullable
              as bool,
      marketingMessages: null == marketingMessages
          ? _value.marketingMessages
          : marketingMessages // ignore: cast_nullable_to_non_nullable
              as bool,
      soundPreference: null == soundPreference
          ? _value.soundPreference
          : soundPreference // ignore: cast_nullable_to_non_nullable
              as String,
      vibrationEnabled: null == vibrationEnabled
          ? _value.vibrationEnabled
          : vibrationEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      categoryPreferences: null == categoryPreferences
          ? _value.categoryPreferences
          : categoryPreferences // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$UserNotificationSettingsModelImplCopyWith<$Res>
    implements $UserNotificationSettingsModelCopyWith<$Res> {
  factory _$$UserNotificationSettingsModelImplCopyWith(
          _$UserNotificationSettingsModelImpl value,
          $Res Function(_$UserNotificationSettingsModelImpl) then) =
      __$$UserNotificationSettingsModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String? id,
      @JsonKey(name: 'user_id') String? userId,
      @JsonKey(name: 'push_enabled') bool pushEnabled,
      @JsonKey(name: 'email_enabled') bool emailEnabled,
      @JsonKey(name: 'transaction_alerts') bool transactionAlerts,
      bool reminders,
      @JsonKey(name: 'marketing_messages') bool marketingMessages,
      @JsonKey(name: 'sound_preference') String soundPreference,
      @JsonKey(name: 'vibration_enabled') bool vibrationEnabled,
      @JsonKey(name: 'category_preferences')
      Map<String, dynamic> categoryPreferences,
      @JsonKey(name: 'created_at') DateTime? createdAt,
      @JsonKey(name: 'updated_at') DateTime? updatedAt});
}

/// @nodoc
class __$$UserNotificationSettingsModelImplCopyWithImpl<$Res>
    extends _$UserNotificationSettingsModelCopyWithImpl<$Res,
        _$UserNotificationSettingsModelImpl>
    implements _$$UserNotificationSettingsModelImplCopyWith<$Res> {
  __$$UserNotificationSettingsModelImplCopyWithImpl(
      _$UserNotificationSettingsModelImpl _value,
      $Res Function(_$UserNotificationSettingsModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of UserNotificationSettingsModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? userId = freezed,
    Object? pushEnabled = null,
    Object? emailEnabled = null,
    Object? transactionAlerts = null,
    Object? reminders = null,
    Object? marketingMessages = null,
    Object? soundPreference = null,
    Object? vibrationEnabled = null,
    Object? categoryPreferences = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_$UserNotificationSettingsModelImpl(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
      userId: freezed == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String?,
      pushEnabled: null == pushEnabled
          ? _value.pushEnabled
          : pushEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      emailEnabled: null == emailEnabled
          ? _value.emailEnabled
          : emailEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      transactionAlerts: null == transactionAlerts
          ? _value.transactionAlerts
          : transactionAlerts // ignore: cast_nullable_to_non_nullable
              as bool,
      reminders: null == reminders
          ? _value.reminders
          : reminders // ignore: cast_nullable_to_non_nullable
              as bool,
      marketingMessages: null == marketingMessages
          ? _value.marketingMessages
          : marketingMessages // ignore: cast_nullable_to_non_nullable
              as bool,
      soundPreference: null == soundPreference
          ? _value.soundPreference
          : soundPreference // ignore: cast_nullable_to_non_nullable
              as String,
      vibrationEnabled: null == vibrationEnabled
          ? _value.vibrationEnabled
          : vibrationEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      categoryPreferences: null == categoryPreferences
          ? _value._categoryPreferences
          : categoryPreferences // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$UserNotificationSettingsModelImpl
    implements _UserNotificationSettingsModel {
  const _$UserNotificationSettingsModelImpl(
      {this.id,
      @JsonKey(name: 'user_id') this.userId,
      @JsonKey(name: 'push_enabled') this.pushEnabled = true,
      @JsonKey(name: 'email_enabled') this.emailEnabled = true,
      @JsonKey(name: 'transaction_alerts') this.transactionAlerts = true,
      this.reminders = true,
      @JsonKey(name: 'marketing_messages') this.marketingMessages = true,
      @JsonKey(name: 'sound_preference') this.soundPreference = 'default',
      @JsonKey(name: 'vibration_enabled') this.vibrationEnabled = true,
      @JsonKey(name: 'category_preferences')
      final Map<String, dynamic> categoryPreferences = const {},
      @JsonKey(name: 'created_at') this.createdAt,
      @JsonKey(name: 'updated_at') this.updatedAt})
      : _categoryPreferences = categoryPreferences;

  factory _$UserNotificationSettingsModelImpl.fromJson(
          Map<String, dynamic> json) =>
      _$$UserNotificationSettingsModelImplFromJson(json);

  @override
  final String? id;
  @override
  @JsonKey(name: 'user_id')
  final String? userId;
  @override
  @JsonKey(name: 'push_enabled')
  final bool pushEnabled;
  @override
  @JsonKey(name: 'email_enabled')
  final bool emailEnabled;
  @override
  @JsonKey(name: 'transaction_alerts')
  final bool transactionAlerts;
  @override
  @JsonKey()
  final bool reminders;
  @override
  @JsonKey(name: 'marketing_messages')
  final bool marketingMessages;
  @override
  @JsonKey(name: 'sound_preference')
  final String soundPreference;
  @override
  @JsonKey(name: 'vibration_enabled')
  final bool vibrationEnabled;
  final Map<String, dynamic> _categoryPreferences;
  @override
  @JsonKey(name: 'category_preferences')
  Map<String, dynamic> get categoryPreferences {
    if (_categoryPreferences is EqualUnmodifiableMapView)
      return _categoryPreferences;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_categoryPreferences);
  }

  @override
  @JsonKey(name: 'created_at')
  final DateTime? createdAt;
  @override
  @JsonKey(name: 'updated_at')
  final DateTime? updatedAt;

  @override
  String toString() {
    return 'UserNotificationSettingsModel(id: $id, userId: $userId, pushEnabled: $pushEnabled, emailEnabled: $emailEnabled, transactionAlerts: $transactionAlerts, reminders: $reminders, marketingMessages: $marketingMessages, soundPreference: $soundPreference, vibrationEnabled: $vibrationEnabled, categoryPreferences: $categoryPreferences, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserNotificationSettingsModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.pushEnabled, pushEnabled) ||
                other.pushEnabled == pushEnabled) &&
            (identical(other.emailEnabled, emailEnabled) ||
                other.emailEnabled == emailEnabled) &&
            (identical(other.transactionAlerts, transactionAlerts) ||
                other.transactionAlerts == transactionAlerts) &&
            (identical(other.reminders, reminders) ||
                other.reminders == reminders) &&
            (identical(other.marketingMessages, marketingMessages) ||
                other.marketingMessages == marketingMessages) &&
            (identical(other.soundPreference, soundPreference) ||
                other.soundPreference == soundPreference) &&
            (identical(other.vibrationEnabled, vibrationEnabled) ||
                other.vibrationEnabled == vibrationEnabled) &&
            const DeepCollectionEquality()
                .equals(other._categoryPreferences, _categoryPreferences) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      userId,
      pushEnabled,
      emailEnabled,
      transactionAlerts,
      reminders,
      marketingMessages,
      soundPreference,
      vibrationEnabled,
      const DeepCollectionEquality().hash(_categoryPreferences),
      createdAt,
      updatedAt);

  /// Create a copy of UserNotificationSettingsModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UserNotificationSettingsModelImplCopyWith<
          _$UserNotificationSettingsModelImpl>
      get copyWith => __$$UserNotificationSettingsModelImplCopyWithImpl<
          _$UserNotificationSettingsModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UserNotificationSettingsModelImplToJson(
      this,
    );
  }
}

abstract class _UserNotificationSettingsModel
    implements UserNotificationSettingsModel {
  const factory _UserNotificationSettingsModel(
          {final String? id,
          @JsonKey(name: 'user_id') final String? userId,
          @JsonKey(name: 'push_enabled') final bool pushEnabled,
          @JsonKey(name: 'email_enabled') final bool emailEnabled,
          @JsonKey(name: 'transaction_alerts') final bool transactionAlerts,
          final bool reminders,
          @JsonKey(name: 'marketing_messages') final bool marketingMessages,
          @JsonKey(name: 'sound_preference') final String soundPreference,
          @JsonKey(name: 'vibration_enabled') final bool vibrationEnabled,
          @JsonKey(name: 'category_preferences')
          final Map<String, dynamic> categoryPreferences,
          @JsonKey(name: 'created_at') final DateTime? createdAt,
          @JsonKey(name: 'updated_at') final DateTime? updatedAt}) =
      _$UserNotificationSettingsModelImpl;

  factory _UserNotificationSettingsModel.fromJson(Map<String, dynamic> json) =
      _$UserNotificationSettingsModelImpl.fromJson;

  @override
  String? get id;
  @override
  @JsonKey(name: 'user_id')
  String? get userId;
  @override
  @JsonKey(name: 'push_enabled')
  bool get pushEnabled;
  @override
  @JsonKey(name: 'email_enabled')
  bool get emailEnabled;
  @override
  @JsonKey(name: 'transaction_alerts')
  bool get transactionAlerts;
  @override
  bool get reminders;
  @override
  @JsonKey(name: 'marketing_messages')
  bool get marketingMessages;
  @override
  @JsonKey(name: 'sound_preference')
  String get soundPreference;
  @override
  @JsonKey(name: 'vibration_enabled')
  bool get vibrationEnabled;
  @override
  @JsonKey(name: 'category_preferences')
  Map<String, dynamic> get categoryPreferences;
  @override
  @JsonKey(name: 'created_at')
  DateTime? get createdAt;
  @override
  @JsonKey(name: 'updated_at')
  DateTime? get updatedAt;

  /// Create a copy of UserNotificationSettingsModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UserNotificationSettingsModelImplCopyWith<
          _$UserNotificationSettingsModelImpl>
      get copyWith => throw _privateConstructorUsedError;
}
