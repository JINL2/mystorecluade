// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'notification_payload.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

NotificationPayload _$NotificationPayloadFromJson(Map<String, dynamic> json) {
  return _NotificationPayload.fromJson(json);
}

/// @nodoc
mixin _$NotificationPayload {
  String get id => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String get body => throw _privateConstructorUsedError;
  String? get category => throw _privateConstructorUsedError;
  Map<String, dynamic>? get data => throw _privateConstructorUsedError;
  String? get imageUrl => throw _privateConstructorUsedError;
  String? get actionUrl => throw _privateConstructorUsedError;
  DateTime? get scheduledTime => throw _privateConstructorUsedError;
  bool get isRead => throw _privateConstructorUsedError;
  DateTime? get createdAt => throw _privateConstructorUsedError;
  DateTime? get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this NotificationPayload to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of NotificationPayload
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $NotificationPayloadCopyWith<NotificationPayload> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $NotificationPayloadCopyWith<$Res> {
  factory $NotificationPayloadCopyWith(
          NotificationPayload value, $Res Function(NotificationPayload) then) =
      _$NotificationPayloadCopyWithImpl<$Res, NotificationPayload>;
  @useResult
  $Res call(
      {String id,
      String title,
      String body,
      String? category,
      Map<String, dynamic>? data,
      String? imageUrl,
      String? actionUrl,
      DateTime? scheduledTime,
      bool isRead,
      DateTime? createdAt,
      DateTime? updatedAt});
}

/// @nodoc
class _$NotificationPayloadCopyWithImpl<$Res, $Val extends NotificationPayload>
    implements $NotificationPayloadCopyWith<$Res> {
  _$NotificationPayloadCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of NotificationPayload
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? body = null,
    Object? category = freezed,
    Object? data = freezed,
    Object? imageUrl = freezed,
    Object? actionUrl = freezed,
    Object? scheduledTime = freezed,
    Object? isRead = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      body: null == body
          ? _value.body
          : body // ignore: cast_nullable_to_non_nullable
              as String,
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
      scheduledTime: freezed == scheduledTime
          ? _value.scheduledTime
          : scheduledTime // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      isRead: null == isRead
          ? _value.isRead
          : isRead // ignore: cast_nullable_to_non_nullable
              as bool,
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
abstract class _$$NotificationPayloadImplCopyWith<$Res>
    implements $NotificationPayloadCopyWith<$Res> {
  factory _$$NotificationPayloadImplCopyWith(_$NotificationPayloadImpl value,
          $Res Function(_$NotificationPayloadImpl) then) =
      __$$NotificationPayloadImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String title,
      String body,
      String? category,
      Map<String, dynamic>? data,
      String? imageUrl,
      String? actionUrl,
      DateTime? scheduledTime,
      bool isRead,
      DateTime? createdAt,
      DateTime? updatedAt});
}

/// @nodoc
class __$$NotificationPayloadImplCopyWithImpl<$Res>
    extends _$NotificationPayloadCopyWithImpl<$Res, _$NotificationPayloadImpl>
    implements _$$NotificationPayloadImplCopyWith<$Res> {
  __$$NotificationPayloadImplCopyWithImpl(_$NotificationPayloadImpl _value,
      $Res Function(_$NotificationPayloadImpl) _then)
      : super(_value, _then);

  /// Create a copy of NotificationPayload
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? body = null,
    Object? category = freezed,
    Object? data = freezed,
    Object? imageUrl = freezed,
    Object? actionUrl = freezed,
    Object? scheduledTime = freezed,
    Object? isRead = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_$NotificationPayloadImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      body: null == body
          ? _value.body
          : body // ignore: cast_nullable_to_non_nullable
              as String,
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
      scheduledTime: freezed == scheduledTime
          ? _value.scheduledTime
          : scheduledTime // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      isRead: null == isRead
          ? _value.isRead
          : isRead // ignore: cast_nullable_to_non_nullable
              as bool,
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
class _$NotificationPayloadImpl implements _NotificationPayload {
  const _$NotificationPayloadImpl(
      {required this.id,
      required this.title,
      required this.body,
      this.category,
      final Map<String, dynamic>? data,
      this.imageUrl,
      this.actionUrl,
      this.scheduledTime,
      this.isRead = false,
      this.createdAt,
      this.updatedAt})
      : _data = data;

  factory _$NotificationPayloadImpl.fromJson(Map<String, dynamic> json) =>
      _$$NotificationPayloadImplFromJson(json);

  @override
  final String id;
  @override
  final String title;
  @override
  final String body;
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
  final String? imageUrl;
  @override
  final String? actionUrl;
  @override
  final DateTime? scheduledTime;
  @override
  @JsonKey()
  final bool isRead;
  @override
  final DateTime? createdAt;
  @override
  final DateTime? updatedAt;

  @override
  String toString() {
    return 'NotificationPayload(id: $id, title: $title, body: $body, category: $category, data: $data, imageUrl: $imageUrl, actionUrl: $actionUrl, scheduledTime: $scheduledTime, isRead: $isRead, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$NotificationPayloadImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.body, body) || other.body == body) &&
            (identical(other.category, category) ||
                other.category == category) &&
            const DeepCollectionEquality().equals(other._data, _data) &&
            (identical(other.imageUrl, imageUrl) ||
                other.imageUrl == imageUrl) &&
            (identical(other.actionUrl, actionUrl) ||
                other.actionUrl == actionUrl) &&
            (identical(other.scheduledTime, scheduledTime) ||
                other.scheduledTime == scheduledTime) &&
            (identical(other.isRead, isRead) || other.isRead == isRead) &&
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
      title,
      body,
      category,
      const DeepCollectionEquality().hash(_data),
      imageUrl,
      actionUrl,
      scheduledTime,
      isRead,
      createdAt,
      updatedAt);

  /// Create a copy of NotificationPayload
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$NotificationPayloadImplCopyWith<_$NotificationPayloadImpl> get copyWith =>
      __$$NotificationPayloadImplCopyWithImpl<_$NotificationPayloadImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$NotificationPayloadImplToJson(
      this,
    );
  }
}

abstract class _NotificationPayload implements NotificationPayload {
  const factory _NotificationPayload(
      {required final String id,
      required final String title,
      required final String body,
      final String? category,
      final Map<String, dynamic>? data,
      final String? imageUrl,
      final String? actionUrl,
      final DateTime? scheduledTime,
      final bool isRead,
      final DateTime? createdAt,
      final DateTime? updatedAt}) = _$NotificationPayloadImpl;

  factory _NotificationPayload.fromJson(Map<String, dynamic> json) =
      _$NotificationPayloadImpl.fromJson;

  @override
  String get id;
  @override
  String get title;
  @override
  String get body;
  @override
  String? get category;
  @override
  Map<String, dynamic>? get data;
  @override
  String? get imageUrl;
  @override
  String? get actionUrl;
  @override
  DateTime? get scheduledTime;
  @override
  bool get isRead;
  @override
  DateTime? get createdAt;
  @override
  DateTime? get updatedAt;

  /// Create a copy of NotificationPayload
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$NotificationPayloadImplCopyWith<_$NotificationPayloadImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

UserNotificationSettings _$UserNotificationSettingsFromJson(
    Map<String, dynamic> json) {
  return _UserNotificationSettings.fromJson(json);
}

/// @nodoc
mixin _$UserNotificationSettings {
  String get userId => throw _privateConstructorUsedError;
  bool get pushEnabled => throw _privateConstructorUsedError;
  bool get emailEnabled => throw _privateConstructorUsedError;
  bool get transactionAlerts => throw _privateConstructorUsedError;
  bool get reminders => throw _privateConstructorUsedError;
  bool get marketingMessages => throw _privateConstructorUsedError;
  String get soundPreference => throw _privateConstructorUsedError;
  bool get vibrationEnabled => throw _privateConstructorUsedError;
  Map<String, bool>? get categoryPreferences =>
      throw _privateConstructorUsedError;

  /// Serializes this UserNotificationSettings to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of UserNotificationSettings
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $UserNotificationSettingsCopyWith<UserNotificationSettings> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserNotificationSettingsCopyWith<$Res> {
  factory $UserNotificationSettingsCopyWith(UserNotificationSettings value,
          $Res Function(UserNotificationSettings) then) =
      _$UserNotificationSettingsCopyWithImpl<$Res, UserNotificationSettings>;
  @useResult
  $Res call(
      {String userId,
      bool pushEnabled,
      bool emailEnabled,
      bool transactionAlerts,
      bool reminders,
      bool marketingMessages,
      String soundPreference,
      bool vibrationEnabled,
      Map<String, bool>? categoryPreferences});
}

/// @nodoc
class _$UserNotificationSettingsCopyWithImpl<$Res,
        $Val extends UserNotificationSettings>
    implements $UserNotificationSettingsCopyWith<$Res> {
  _$UserNotificationSettingsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of UserNotificationSettings
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = null,
    Object? pushEnabled = null,
    Object? emailEnabled = null,
    Object? transactionAlerts = null,
    Object? reminders = null,
    Object? marketingMessages = null,
    Object? soundPreference = null,
    Object? vibrationEnabled = null,
    Object? categoryPreferences = freezed,
  }) {
    return _then(_value.copyWith(
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
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
      categoryPreferences: freezed == categoryPreferences
          ? _value.categoryPreferences
          : categoryPreferences // ignore: cast_nullable_to_non_nullable
              as Map<String, bool>?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$UserNotificationSettingsImplCopyWith<$Res>
    implements $UserNotificationSettingsCopyWith<$Res> {
  factory _$$UserNotificationSettingsImplCopyWith(
          _$UserNotificationSettingsImpl value,
          $Res Function(_$UserNotificationSettingsImpl) then) =
      __$$UserNotificationSettingsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String userId,
      bool pushEnabled,
      bool emailEnabled,
      bool transactionAlerts,
      bool reminders,
      bool marketingMessages,
      String soundPreference,
      bool vibrationEnabled,
      Map<String, bool>? categoryPreferences});
}

/// @nodoc
class __$$UserNotificationSettingsImplCopyWithImpl<$Res>
    extends _$UserNotificationSettingsCopyWithImpl<$Res,
        _$UserNotificationSettingsImpl>
    implements _$$UserNotificationSettingsImplCopyWith<$Res> {
  __$$UserNotificationSettingsImplCopyWithImpl(
      _$UserNotificationSettingsImpl _value,
      $Res Function(_$UserNotificationSettingsImpl) _then)
      : super(_value, _then);

  /// Create a copy of UserNotificationSettings
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = null,
    Object? pushEnabled = null,
    Object? emailEnabled = null,
    Object? transactionAlerts = null,
    Object? reminders = null,
    Object? marketingMessages = null,
    Object? soundPreference = null,
    Object? vibrationEnabled = null,
    Object? categoryPreferences = freezed,
  }) {
    return _then(_$UserNotificationSettingsImpl(
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
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
      categoryPreferences: freezed == categoryPreferences
          ? _value._categoryPreferences
          : categoryPreferences // ignore: cast_nullable_to_non_nullable
              as Map<String, bool>?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$UserNotificationSettingsImpl implements _UserNotificationSettings {
  const _$UserNotificationSettingsImpl(
      {required this.userId,
      this.pushEnabled = true,
      this.emailEnabled = true,
      this.transactionAlerts = true,
      this.reminders = true,
      this.marketingMessages = true,
      this.soundPreference = 'default',
      this.vibrationEnabled = true,
      final Map<String, bool>? categoryPreferences})
      : _categoryPreferences = categoryPreferences;

  factory _$UserNotificationSettingsImpl.fromJson(Map<String, dynamic> json) =>
      _$$UserNotificationSettingsImplFromJson(json);

  @override
  final String userId;
  @override
  @JsonKey()
  final bool pushEnabled;
  @override
  @JsonKey()
  final bool emailEnabled;
  @override
  @JsonKey()
  final bool transactionAlerts;
  @override
  @JsonKey()
  final bool reminders;
  @override
  @JsonKey()
  final bool marketingMessages;
  @override
  @JsonKey()
  final String soundPreference;
  @override
  @JsonKey()
  final bool vibrationEnabled;
  final Map<String, bool>? _categoryPreferences;
  @override
  Map<String, bool>? get categoryPreferences {
    final value = _categoryPreferences;
    if (value == null) return null;
    if (_categoryPreferences is EqualUnmodifiableMapView)
      return _categoryPreferences;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  String toString() {
    return 'UserNotificationSettings(userId: $userId, pushEnabled: $pushEnabled, emailEnabled: $emailEnabled, transactionAlerts: $transactionAlerts, reminders: $reminders, marketingMessages: $marketingMessages, soundPreference: $soundPreference, vibrationEnabled: $vibrationEnabled, categoryPreferences: $categoryPreferences)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserNotificationSettingsImpl &&
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
                .equals(other._categoryPreferences, _categoryPreferences));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      userId,
      pushEnabled,
      emailEnabled,
      transactionAlerts,
      reminders,
      marketingMessages,
      soundPreference,
      vibrationEnabled,
      const DeepCollectionEquality().hash(_categoryPreferences));

  /// Create a copy of UserNotificationSettings
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UserNotificationSettingsImplCopyWith<_$UserNotificationSettingsImpl>
      get copyWith => __$$UserNotificationSettingsImplCopyWithImpl<
          _$UserNotificationSettingsImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UserNotificationSettingsImplToJson(
      this,
    );
  }
}

abstract class _UserNotificationSettings implements UserNotificationSettings {
  const factory _UserNotificationSettings(
          {required final String userId,
          final bool pushEnabled,
          final bool emailEnabled,
          final bool transactionAlerts,
          final bool reminders,
          final bool marketingMessages,
          final String soundPreference,
          final bool vibrationEnabled,
          final Map<String, bool>? categoryPreferences}) =
      _$UserNotificationSettingsImpl;

  factory _UserNotificationSettings.fromJson(Map<String, dynamic> json) =
      _$UserNotificationSettingsImpl.fromJson;

  @override
  String get userId;
  @override
  bool get pushEnabled;
  @override
  bool get emailEnabled;
  @override
  bool get transactionAlerts;
  @override
  bool get reminders;
  @override
  bool get marketingMessages;
  @override
  String get soundPreference;
  @override
  bool get vibrationEnabled;
  @override
  Map<String, bool>? get categoryPreferences;

  /// Create a copy of UserNotificationSettings
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UserNotificationSettingsImplCopyWith<_$UserNotificationSettingsImpl>
      get copyWith => throw _privateConstructorUsedError;
}

FcmToken _$FcmTokenFromJson(Map<String, dynamic> json) {
  return _FcmToken.fromJson(json);
}

/// @nodoc
mixin _$FcmToken {
  String get token => throw _privateConstructorUsedError;
  String get userId => throw _privateConstructorUsedError;
  String get platform => throw _privateConstructorUsedError;
  String? get deviceId => throw _privateConstructorUsedError;
  String? get deviceModel => throw _privateConstructorUsedError;
  String? get appVersion => throw _privateConstructorUsedError;
  DateTime? get createdAt => throw _privateConstructorUsedError;
  DateTime? get updatedAt => throw _privateConstructorUsedError;
  DateTime? get lastUsedAt => throw _privateConstructorUsedError;
  bool get isActive => throw _privateConstructorUsedError;

  /// Serializes this FcmToken to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of FcmToken
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $FcmTokenCopyWith<FcmToken> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FcmTokenCopyWith<$Res> {
  factory $FcmTokenCopyWith(FcmToken value, $Res Function(FcmToken) then) =
      _$FcmTokenCopyWithImpl<$Res, FcmToken>;
  @useResult
  $Res call(
      {String token,
      String userId,
      String platform,
      String? deviceId,
      String? deviceModel,
      String? appVersion,
      DateTime? createdAt,
      DateTime? updatedAt,
      DateTime? lastUsedAt,
      bool isActive});
}

/// @nodoc
class _$FcmTokenCopyWithImpl<$Res, $Val extends FcmToken>
    implements $FcmTokenCopyWith<$Res> {
  _$FcmTokenCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of FcmToken
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? token = null,
    Object? userId = null,
    Object? platform = null,
    Object? deviceId = freezed,
    Object? deviceModel = freezed,
    Object? appVersion = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
    Object? lastUsedAt = freezed,
    Object? isActive = null,
  }) {
    return _then(_value.copyWith(
      token: null == token
          ? _value.token
          : token // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      platform: null == platform
          ? _value.platform
          : platform // ignore: cast_nullable_to_non_nullable
              as String,
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
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$FcmTokenImplCopyWith<$Res>
    implements $FcmTokenCopyWith<$Res> {
  factory _$$FcmTokenImplCopyWith(
          _$FcmTokenImpl value, $Res Function(_$FcmTokenImpl) then) =
      __$$FcmTokenImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String token,
      String userId,
      String platform,
      String? deviceId,
      String? deviceModel,
      String? appVersion,
      DateTime? createdAt,
      DateTime? updatedAt,
      DateTime? lastUsedAt,
      bool isActive});
}

/// @nodoc
class __$$FcmTokenImplCopyWithImpl<$Res>
    extends _$FcmTokenCopyWithImpl<$Res, _$FcmTokenImpl>
    implements _$$FcmTokenImplCopyWith<$Res> {
  __$$FcmTokenImplCopyWithImpl(
      _$FcmTokenImpl _value, $Res Function(_$FcmTokenImpl) _then)
      : super(_value, _then);

  /// Create a copy of FcmToken
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? token = null,
    Object? userId = null,
    Object? platform = null,
    Object? deviceId = freezed,
    Object? deviceModel = freezed,
    Object? appVersion = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
    Object? lastUsedAt = freezed,
    Object? isActive = null,
  }) {
    return _then(_$FcmTokenImpl(
      token: null == token
          ? _value.token
          : token // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      platform: null == platform
          ? _value.platform
          : platform // ignore: cast_nullable_to_non_nullable
              as String,
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
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$FcmTokenImpl implements _FcmToken {
  const _$FcmTokenImpl(
      {required this.token,
      required this.userId,
      required this.platform,
      this.deviceId,
      this.deviceModel,
      this.appVersion,
      this.createdAt,
      this.updatedAt,
      this.lastUsedAt,
      this.isActive = true});

  factory _$FcmTokenImpl.fromJson(Map<String, dynamic> json) =>
      _$$FcmTokenImplFromJson(json);

  @override
  final String token;
  @override
  final String userId;
  @override
  final String platform;
  @override
  final String? deviceId;
  @override
  final String? deviceModel;
  @override
  final String? appVersion;
  @override
  final DateTime? createdAt;
  @override
  final DateTime? updatedAt;
  @override
  final DateTime? lastUsedAt;
  @override
  @JsonKey()
  final bool isActive;

  @override
  String toString() {
    return 'FcmToken(token: $token, userId: $userId, platform: $platform, deviceId: $deviceId, deviceModel: $deviceModel, appVersion: $appVersion, createdAt: $createdAt, updatedAt: $updatedAt, lastUsedAt: $lastUsedAt, isActive: $isActive)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FcmTokenImpl &&
            (identical(other.token, token) || other.token == token) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.platform, platform) ||
                other.platform == platform) &&
            (identical(other.deviceId, deviceId) ||
                other.deviceId == deviceId) &&
            (identical(other.deviceModel, deviceModel) ||
                other.deviceModel == deviceModel) &&
            (identical(other.appVersion, appVersion) ||
                other.appVersion == appVersion) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.lastUsedAt, lastUsedAt) ||
                other.lastUsedAt == lastUsedAt) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      token,
      userId,
      platform,
      deviceId,
      deviceModel,
      appVersion,
      createdAt,
      updatedAt,
      lastUsedAt,
      isActive);

  /// Create a copy of FcmToken
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$FcmTokenImplCopyWith<_$FcmTokenImpl> get copyWith =>
      __$$FcmTokenImplCopyWithImpl<_$FcmTokenImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$FcmTokenImplToJson(
      this,
    );
  }
}

abstract class _FcmToken implements FcmToken {
  const factory _FcmToken(
      {required final String token,
      required final String userId,
      required final String platform,
      final String? deviceId,
      final String? deviceModel,
      final String? appVersion,
      final DateTime? createdAt,
      final DateTime? updatedAt,
      final DateTime? lastUsedAt,
      final bool isActive}) = _$FcmTokenImpl;

  factory _FcmToken.fromJson(Map<String, dynamic> json) =
      _$FcmTokenImpl.fromJson;

  @override
  String get token;
  @override
  String get userId;
  @override
  String get platform;
  @override
  String? get deviceId;
  @override
  String? get deviceModel;
  @override
  String? get appVersion;
  @override
  DateTime? get createdAt;
  @override
  DateTime? get updatedAt;
  @override
  DateTime? get lastUsedAt;
  @override
  bool get isActive;

  /// Create a copy of FcmToken
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$FcmTokenImplCopyWith<_$FcmTokenImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
