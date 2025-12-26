// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'journal_result.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$JournalResult {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String journalId, String? message,
            Map<String, dynamic>? additionalData)
        success,
    required TResult Function(
            String error, String? errorCode, Map<String, dynamic>? errorDetails)
        failure,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String journalId, String? message,
            Map<String, dynamic>? additionalData)?
        success,
    TResult? Function(String error, String? errorCode,
            Map<String, dynamic>? errorDetails)?
        failure,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String journalId, String? message,
            Map<String, dynamic>? additionalData)?
        success,
    TResult Function(String error, String? errorCode,
            Map<String, dynamic>? errorDetails)?
        failure,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(JournalSuccess value) success,
    required TResult Function(JournalFailure value) failure,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(JournalSuccess value)? success,
    TResult? Function(JournalFailure value)? failure,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(JournalSuccess value)? success,
    TResult Function(JournalFailure value)? failure,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $JournalResultCopyWith<$Res> {
  factory $JournalResultCopyWith(
          JournalResult value, $Res Function(JournalResult) then) =
      _$JournalResultCopyWithImpl<$Res, JournalResult>;
}

/// @nodoc
class _$JournalResultCopyWithImpl<$Res, $Val extends JournalResult>
    implements $JournalResultCopyWith<$Res> {
  _$JournalResultCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of JournalResult
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
abstract class _$$JournalSuccessImplCopyWith<$Res> {
  factory _$$JournalSuccessImplCopyWith(_$JournalSuccessImpl value,
          $Res Function(_$JournalSuccessImpl) then) =
      __$$JournalSuccessImplCopyWithImpl<$Res>;
  @useResult
  $Res call(
      {String journalId,
      String? message,
      Map<String, dynamic>? additionalData});
}

/// @nodoc
class __$$JournalSuccessImplCopyWithImpl<$Res>
    extends _$JournalResultCopyWithImpl<$Res, _$JournalSuccessImpl>
    implements _$$JournalSuccessImplCopyWith<$Res> {
  __$$JournalSuccessImplCopyWithImpl(
      _$JournalSuccessImpl _value, $Res Function(_$JournalSuccessImpl) _then)
      : super(_value, _then);

  /// Create a copy of JournalResult
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? journalId = null,
    Object? message = freezed,
    Object? additionalData = freezed,
  }) {
    return _then(_$JournalSuccessImpl(
      journalId: null == journalId
          ? _value.journalId
          : journalId // ignore: cast_nullable_to_non_nullable
              as String,
      message: freezed == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String?,
      additionalData: freezed == additionalData
          ? _value._additionalData
          : additionalData // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
    ));
  }
}

/// @nodoc

class _$JournalSuccessImpl implements JournalSuccess {
  const _$JournalSuccessImpl(
      {required this.journalId,
      this.message,
      final Map<String, dynamic>? additionalData})
      : _additionalData = additionalData;

  @override
  final String journalId;
  @override
  final String? message;
  final Map<String, dynamic>? _additionalData;
  @override
  Map<String, dynamic>? get additionalData {
    final value = _additionalData;
    if (value == null) return null;
    if (_additionalData is EqualUnmodifiableMapView) return _additionalData;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  String toString() {
    return 'JournalResult.success(journalId: $journalId, message: $message, additionalData: $additionalData)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$JournalSuccessImpl &&
            (identical(other.journalId, journalId) ||
                other.journalId == journalId) &&
            (identical(other.message, message) || other.message == message) &&
            const DeepCollectionEquality()
                .equals(other._additionalData, _additionalData));
  }

  @override
  int get hashCode => Object.hash(runtimeType, journalId, message,
      const DeepCollectionEquality().hash(_additionalData));

  /// Create a copy of JournalResult
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$JournalSuccessImplCopyWith<_$JournalSuccessImpl> get copyWith =>
      __$$JournalSuccessImplCopyWithImpl<_$JournalSuccessImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String journalId, String? message,
            Map<String, dynamic>? additionalData)
        success,
    required TResult Function(
            String error, String? errorCode, Map<String, dynamic>? errorDetails)
        failure,
  }) {
    return success(journalId, message, additionalData);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String journalId, String? message,
            Map<String, dynamic>? additionalData)?
        success,
    TResult? Function(String error, String? errorCode,
            Map<String, dynamic>? errorDetails)?
        failure,
  }) {
    return success?.call(journalId, message, additionalData);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String journalId, String? message,
            Map<String, dynamic>? additionalData)?
        success,
    TResult Function(String error, String? errorCode,
            Map<String, dynamic>? errorDetails)?
        failure,
    required TResult orElse(),
  }) {
    if (success != null) {
      return success(journalId, message, additionalData);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(JournalSuccess value) success,
    required TResult Function(JournalFailure value) failure,
  }) {
    return success(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(JournalSuccess value)? success,
    TResult? Function(JournalFailure value)? failure,
  }) {
    return success?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(JournalSuccess value)? success,
    TResult Function(JournalFailure value)? failure,
    required TResult orElse(),
  }) {
    if (success != null) {
      return success(this);
    }
    return orElse();
  }
}

abstract class JournalSuccess implements JournalResult {
  const factory JournalSuccess(
      {required final String journalId,
      final String? message,
      final Map<String, dynamic>? additionalData}) = _$JournalSuccessImpl;

  String get journalId;
  String? get message;
  Map<String, dynamic>? get additionalData;

  /// Create a copy of JournalResult
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$JournalSuccessImplCopyWith<_$JournalSuccessImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$JournalFailureImplCopyWith<$Res> {
  factory _$$JournalFailureImplCopyWith(_$JournalFailureImpl value,
          $Res Function(_$JournalFailureImpl) then) =
      __$$JournalFailureImplCopyWithImpl<$Res>;
  @useResult
  $Res call(
      {String error, String? errorCode, Map<String, dynamic>? errorDetails});
}

/// @nodoc
class __$$JournalFailureImplCopyWithImpl<$Res>
    extends _$JournalResultCopyWithImpl<$Res, _$JournalFailureImpl>
    implements _$$JournalFailureImplCopyWith<$Res> {
  __$$JournalFailureImplCopyWithImpl(
      _$JournalFailureImpl _value, $Res Function(_$JournalFailureImpl) _then)
      : super(_value, _then);

  /// Create a copy of JournalResult
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? error = null,
    Object? errorCode = freezed,
    Object? errorDetails = freezed,
  }) {
    return _then(_$JournalFailureImpl(
      error: null == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as String,
      errorCode: freezed == errorCode
          ? _value.errorCode
          : errorCode // ignore: cast_nullable_to_non_nullable
              as String?,
      errorDetails: freezed == errorDetails
          ? _value._errorDetails
          : errorDetails // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
    ));
  }
}

/// @nodoc

class _$JournalFailureImpl implements JournalFailure {
  const _$JournalFailureImpl(
      {required this.error,
      this.errorCode,
      final Map<String, dynamic>? errorDetails})
      : _errorDetails = errorDetails;

  @override
  final String error;
  @override
  final String? errorCode;
  final Map<String, dynamic>? _errorDetails;
  @override
  Map<String, dynamic>? get errorDetails {
    final value = _errorDetails;
    if (value == null) return null;
    if (_errorDetails is EqualUnmodifiableMapView) return _errorDetails;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  String toString() {
    return 'JournalResult.failure(error: $error, errorCode: $errorCode, errorDetails: $errorDetails)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$JournalFailureImpl &&
            (identical(other.error, error) || other.error == error) &&
            (identical(other.errorCode, errorCode) ||
                other.errorCode == errorCode) &&
            const DeepCollectionEquality()
                .equals(other._errorDetails, _errorDetails));
  }

  @override
  int get hashCode => Object.hash(runtimeType, error, errorCode,
      const DeepCollectionEquality().hash(_errorDetails));

  /// Create a copy of JournalResult
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$JournalFailureImplCopyWith<_$JournalFailureImpl> get copyWith =>
      __$$JournalFailureImplCopyWithImpl<_$JournalFailureImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String journalId, String? message,
            Map<String, dynamic>? additionalData)
        success,
    required TResult Function(
            String error, String? errorCode, Map<String, dynamic>? errorDetails)
        failure,
  }) {
    return failure(error, errorCode, errorDetails);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String journalId, String? message,
            Map<String, dynamic>? additionalData)?
        success,
    TResult? Function(String error, String? errorCode,
            Map<String, dynamic>? errorDetails)?
        failure,
  }) {
    return failure?.call(error, errorCode, errorDetails);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String journalId, String? message,
            Map<String, dynamic>? additionalData)?
        success,
    TResult Function(String error, String? errorCode,
            Map<String, dynamic>? errorDetails)?
        failure,
    required TResult orElse(),
  }) {
    if (failure != null) {
      return failure(error, errorCode, errorDetails);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(JournalSuccess value) success,
    required TResult Function(JournalFailure value) failure,
  }) {
    return failure(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(JournalSuccess value)? success,
    TResult? Function(JournalFailure value)? failure,
  }) {
    return failure?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(JournalSuccess value)? success,
    TResult Function(JournalFailure value)? failure,
    required TResult orElse(),
  }) {
    if (failure != null) {
      return failure(this);
    }
    return orElse();
  }
}

abstract class JournalFailure implements JournalResult {
  const factory JournalFailure(
      {required final String error,
      final String? errorCode,
      final Map<String, dynamic>? errorDetails}) = _$JournalFailureImpl;

  String get error;
  String? get errorCode;
  Map<String, dynamic>? get errorDetails;

  /// Create a copy of JournalResult
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$JournalFailureImplCopyWith<_$JournalFailureImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
