// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'critical_alert.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$CriticalAlert {
  String get id => throw _privateConstructorUsedError;
  String get type => throw _privateConstructorUsedError;
  String get message => throw _privateConstructorUsedError;
  int get count => throw _privateConstructorUsedError;
  String get severity => throw _privateConstructorUsedError;
  bool get isRead => throw _privateConstructorUsedError;
  DateTime? get createdAt => throw _privateConstructorUsedError;

  /// Create a copy of CriticalAlert
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CriticalAlertCopyWith<CriticalAlert> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CriticalAlertCopyWith<$Res> {
  factory $CriticalAlertCopyWith(
          CriticalAlert value, $Res Function(CriticalAlert) then) =
      _$CriticalAlertCopyWithImpl<$Res, CriticalAlert>;
  @useResult
  $Res call(
      {String id,
      String type,
      String message,
      int count,
      String severity,
      bool isRead,
      DateTime? createdAt});
}

/// @nodoc
class _$CriticalAlertCopyWithImpl<$Res, $Val extends CriticalAlert>
    implements $CriticalAlertCopyWith<$Res> {
  _$CriticalAlertCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CriticalAlert
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? type = null,
    Object? message = null,
    Object? count = null,
    Object? severity = null,
    Object? isRead = null,
    Object? createdAt = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
      count: null == count
          ? _value.count
          : count // ignore: cast_nullable_to_non_nullable
              as int,
      severity: null == severity
          ? _value.severity
          : severity // ignore: cast_nullable_to_non_nullable
              as String,
      isRead: null == isRead
          ? _value.isRead
          : isRead // ignore: cast_nullable_to_non_nullable
              as bool,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CriticalAlertImplCopyWith<$Res>
    implements $CriticalAlertCopyWith<$Res> {
  factory _$$CriticalAlertImplCopyWith(
          _$CriticalAlertImpl value, $Res Function(_$CriticalAlertImpl) then) =
      __$$CriticalAlertImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String type,
      String message,
      int count,
      String severity,
      bool isRead,
      DateTime? createdAt});
}

/// @nodoc
class __$$CriticalAlertImplCopyWithImpl<$Res>
    extends _$CriticalAlertCopyWithImpl<$Res, _$CriticalAlertImpl>
    implements _$$CriticalAlertImplCopyWith<$Res> {
  __$$CriticalAlertImplCopyWithImpl(
      _$CriticalAlertImpl _value, $Res Function(_$CriticalAlertImpl) _then)
      : super(_value, _then);

  /// Create a copy of CriticalAlert
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? type = null,
    Object? message = null,
    Object? count = null,
    Object? severity = null,
    Object? isRead = null,
    Object? createdAt = freezed,
  }) {
    return _then(_$CriticalAlertImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
      count: null == count
          ? _value.count
          : count // ignore: cast_nullable_to_non_nullable
              as int,
      severity: null == severity
          ? _value.severity
          : severity // ignore: cast_nullable_to_non_nullable
              as String,
      isRead: null == isRead
          ? _value.isRead
          : isRead // ignore: cast_nullable_to_non_nullable
              as bool,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc

class _$CriticalAlertImpl extends _CriticalAlert {
  const _$CriticalAlertImpl(
      {required this.id,
      required this.type,
      required this.message,
      required this.count,
      required this.severity,
      this.isRead = false,
      this.createdAt})
      : super._();

  @override
  final String id;
  @override
  final String type;
  @override
  final String message;
  @override
  final int count;
  @override
  final String severity;
  @override
  @JsonKey()
  final bool isRead;
  @override
  final DateTime? createdAt;

  @override
  String toString() {
    return 'CriticalAlert(id: $id, type: $type, message: $message, count: $count, severity: $severity, isRead: $isRead, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CriticalAlertImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.message, message) || other.message == message) &&
            (identical(other.count, count) || other.count == count) &&
            (identical(other.severity, severity) ||
                other.severity == severity) &&
            (identical(other.isRead, isRead) || other.isRead == isRead) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, id, type, message, count, severity, isRead, createdAt);

  /// Create a copy of CriticalAlert
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CriticalAlertImplCopyWith<_$CriticalAlertImpl> get copyWith =>
      __$$CriticalAlertImplCopyWithImpl<_$CriticalAlertImpl>(this, _$identity);
}

abstract class _CriticalAlert extends CriticalAlert {
  const factory _CriticalAlert(
      {required final String id,
      required final String type,
      required final String message,
      required final int count,
      required final String severity,
      final bool isRead,
      final DateTime? createdAt}) = _$CriticalAlertImpl;
  const _CriticalAlert._() : super._();

  @override
  String get id;
  @override
  String get type;
  @override
  String get message;
  @override
  int get count;
  @override
  String get severity;
  @override
  bool get isRead;
  @override
  DateTime? get createdAt;

  /// Create a copy of CriticalAlert
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CriticalAlertImplCopyWith<_$CriticalAlertImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
