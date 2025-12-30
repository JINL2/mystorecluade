// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'template_rpc_result.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

TemplateRpcResult _$TemplateRpcResultFromJson(Map<String, dynamic> json) {
  switch (json['runtimeType']) {
    case 'success':
      return TemplateRpcResultSuccess.fromJson(json);
    case 'failure':
      return TemplateRpcResultFailure.fromJson(json);

    default:
      throw CheckedFromJsonException(json, 'runtimeType', 'TemplateRpcResult',
          'Invalid union type "${json['runtimeType']}"!');
  }
}

/// @nodoc
mixin _$TemplateRpcResult {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(
            String journalId, String? message, DateTime? createdAt)
        success,
    required TResult Function(
            String errorCode,
            String errorMessage,
            List<FieldError> fieldErrors,
            bool isRecoverable,
            String? technicalDetails)
        failure,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String journalId, String? message, DateTime? createdAt)?
        success,
    TResult? Function(
            String errorCode,
            String errorMessage,
            List<FieldError> fieldErrors,
            bool isRecoverable,
            String? technicalDetails)?
        failure,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String journalId, String? message, DateTime? createdAt)?
        success,
    TResult Function(
            String errorCode,
            String errorMessage,
            List<FieldError> fieldErrors,
            bool isRecoverable,
            String? technicalDetails)?
        failure,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(TemplateRpcResultSuccess value) success,
    required TResult Function(TemplateRpcResultFailure value) failure,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(TemplateRpcResultSuccess value)? success,
    TResult? Function(TemplateRpcResultFailure value)? failure,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(TemplateRpcResultSuccess value)? success,
    TResult Function(TemplateRpcResultFailure value)? failure,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;

  /// Serializes this TemplateRpcResult to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TemplateRpcResultCopyWith<$Res> {
  factory $TemplateRpcResultCopyWith(
          TemplateRpcResult value, $Res Function(TemplateRpcResult) then) =
      _$TemplateRpcResultCopyWithImpl<$Res, TemplateRpcResult>;
}

/// @nodoc
class _$TemplateRpcResultCopyWithImpl<$Res, $Val extends TemplateRpcResult>
    implements $TemplateRpcResultCopyWith<$Res> {
  _$TemplateRpcResultCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TemplateRpcResult
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
abstract class _$$TemplateRpcResultSuccessImplCopyWith<$Res> {
  factory _$$TemplateRpcResultSuccessImplCopyWith(
          _$TemplateRpcResultSuccessImpl value,
          $Res Function(_$TemplateRpcResultSuccessImpl) then) =
      __$$TemplateRpcResultSuccessImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String journalId, String? message, DateTime? createdAt});
}

/// @nodoc
class __$$TemplateRpcResultSuccessImplCopyWithImpl<$Res>
    extends _$TemplateRpcResultCopyWithImpl<$Res,
        _$TemplateRpcResultSuccessImpl>
    implements _$$TemplateRpcResultSuccessImplCopyWith<$Res> {
  __$$TemplateRpcResultSuccessImplCopyWithImpl(
      _$TemplateRpcResultSuccessImpl _value,
      $Res Function(_$TemplateRpcResultSuccessImpl) _then)
      : super(_value, _then);

  /// Create a copy of TemplateRpcResult
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? journalId = null,
    Object? message = freezed,
    Object? createdAt = freezed,
  }) {
    return _then(_$TemplateRpcResultSuccessImpl(
      journalId: null == journalId
          ? _value.journalId
          : journalId // ignore: cast_nullable_to_non_nullable
              as String,
      message: freezed == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$TemplateRpcResultSuccessImpl extends TemplateRpcResultSuccess {
  const _$TemplateRpcResultSuccessImpl(
      {required this.journalId,
      this.message,
      this.createdAt,
      final String? $type})
      : $type = $type ?? 'success',
        super._();

  factory _$TemplateRpcResultSuccessImpl.fromJson(Map<String, dynamic> json) =>
      _$$TemplateRpcResultSuccessImplFromJson(json);

  /// Created journal entry ID
  @override
  final String journalId;

  /// Optional message from RPC
  @override
  final String? message;

  /// Timestamp of creation (UTC)
  @override
  final DateTime? createdAt;

  @JsonKey(name: 'runtimeType')
  final String $type;

  @override
  String toString() {
    return 'TemplateRpcResult.success(journalId: $journalId, message: $message, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TemplateRpcResultSuccessImpl &&
            (identical(other.journalId, journalId) ||
                other.journalId == journalId) &&
            (identical(other.message, message) || other.message == message) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, journalId, message, createdAt);

  /// Create a copy of TemplateRpcResult
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TemplateRpcResultSuccessImplCopyWith<_$TemplateRpcResultSuccessImpl>
      get copyWith => __$$TemplateRpcResultSuccessImplCopyWithImpl<
          _$TemplateRpcResultSuccessImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(
            String journalId, String? message, DateTime? createdAt)
        success,
    required TResult Function(
            String errorCode,
            String errorMessage,
            List<FieldError> fieldErrors,
            bool isRecoverable,
            String? technicalDetails)
        failure,
  }) {
    return success(journalId, message, createdAt);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String journalId, String? message, DateTime? createdAt)?
        success,
    TResult? Function(
            String errorCode,
            String errorMessage,
            List<FieldError> fieldErrors,
            bool isRecoverable,
            String? technicalDetails)?
        failure,
  }) {
    return success?.call(journalId, message, createdAt);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String journalId, String? message, DateTime? createdAt)?
        success,
    TResult Function(
            String errorCode,
            String errorMessage,
            List<FieldError> fieldErrors,
            bool isRecoverable,
            String? technicalDetails)?
        failure,
    required TResult orElse(),
  }) {
    if (success != null) {
      return success(journalId, message, createdAt);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(TemplateRpcResultSuccess value) success,
    required TResult Function(TemplateRpcResultFailure value) failure,
  }) {
    return success(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(TemplateRpcResultSuccess value)? success,
    TResult? Function(TemplateRpcResultFailure value)? failure,
  }) {
    return success?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(TemplateRpcResultSuccess value)? success,
    TResult Function(TemplateRpcResultFailure value)? failure,
    required TResult orElse(),
  }) {
    if (success != null) {
      return success(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$TemplateRpcResultSuccessImplToJson(
      this,
    );
  }
}

abstract class TemplateRpcResultSuccess extends TemplateRpcResult {
  const factory TemplateRpcResultSuccess(
      {required final String journalId,
      final String? message,
      final DateTime? createdAt}) = _$TemplateRpcResultSuccessImpl;
  const TemplateRpcResultSuccess._() : super._();

  factory TemplateRpcResultSuccess.fromJson(Map<String, dynamic> json) =
      _$TemplateRpcResultSuccessImpl.fromJson;

  /// Created journal entry ID
  String get journalId;

  /// Optional message from RPC
  String? get message;

  /// Timestamp of creation (UTC)
  DateTime? get createdAt;

  /// Create a copy of TemplateRpcResult
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TemplateRpcResultSuccessImplCopyWith<_$TemplateRpcResultSuccessImpl>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$TemplateRpcResultFailureImplCopyWith<$Res> {
  factory _$$TemplateRpcResultFailureImplCopyWith(
          _$TemplateRpcResultFailureImpl value,
          $Res Function(_$TemplateRpcResultFailureImpl) then) =
      __$$TemplateRpcResultFailureImplCopyWithImpl<$Res>;
  @useResult
  $Res call(
      {String errorCode,
      String errorMessage,
      List<FieldError> fieldErrors,
      bool isRecoverable,
      String? technicalDetails});
}

/// @nodoc
class __$$TemplateRpcResultFailureImplCopyWithImpl<$Res>
    extends _$TemplateRpcResultCopyWithImpl<$Res,
        _$TemplateRpcResultFailureImpl>
    implements _$$TemplateRpcResultFailureImplCopyWith<$Res> {
  __$$TemplateRpcResultFailureImplCopyWithImpl(
      _$TemplateRpcResultFailureImpl _value,
      $Res Function(_$TemplateRpcResultFailureImpl) _then)
      : super(_value, _then);

  /// Create a copy of TemplateRpcResult
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? errorCode = null,
    Object? errorMessage = null,
    Object? fieldErrors = null,
    Object? isRecoverable = null,
    Object? technicalDetails = freezed,
  }) {
    return _then(_$TemplateRpcResultFailureImpl(
      errorCode: null == errorCode
          ? _value.errorCode
          : errorCode // ignore: cast_nullable_to_non_nullable
              as String,
      errorMessage: null == errorMessage
          ? _value.errorMessage
          : errorMessage // ignore: cast_nullable_to_non_nullable
              as String,
      fieldErrors: null == fieldErrors
          ? _value._fieldErrors
          : fieldErrors // ignore: cast_nullable_to_non_nullable
              as List<FieldError>,
      isRecoverable: null == isRecoverable
          ? _value.isRecoverable
          : isRecoverable // ignore: cast_nullable_to_non_nullable
              as bool,
      technicalDetails: freezed == technicalDetails
          ? _value.technicalDetails
          : technicalDetails // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$TemplateRpcResultFailureImpl extends TemplateRpcResultFailure {
  const _$TemplateRpcResultFailureImpl(
      {required this.errorCode,
      required this.errorMessage,
      final List<FieldError> fieldErrors = const [],
      this.isRecoverable = true,
      this.technicalDetails,
      final String? $type})
      : _fieldErrors = fieldErrors,
        $type = $type ?? 'failure',
        super._();

  factory _$TemplateRpcResultFailureImpl.fromJson(Map<String, dynamic> json) =>
      _$$TemplateRpcResultFailureImplFromJson(json);

  /// Error code from RPC or application
  @override
  final String errorCode;

  /// Human-readable error message
  @override
  final String errorMessage;

  /// Optional field-level validation errors
  final List<FieldError> _fieldErrors;

  /// Optional field-level validation errors
  @override
  @JsonKey()
  List<FieldError> get fieldErrors {
    if (_fieldErrors is EqualUnmodifiableListView) return _fieldErrors;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_fieldErrors);
  }

  /// Whether this error is recoverable (user can fix and retry)
  @override
  @JsonKey()
  final bool isRecoverable;

  /// Original exception details (for logging)
  @override
  final String? technicalDetails;

  @JsonKey(name: 'runtimeType')
  final String $type;

  @override
  String toString() {
    return 'TemplateRpcResult.failure(errorCode: $errorCode, errorMessage: $errorMessage, fieldErrors: $fieldErrors, isRecoverable: $isRecoverable, technicalDetails: $technicalDetails)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TemplateRpcResultFailureImpl &&
            (identical(other.errorCode, errorCode) ||
                other.errorCode == errorCode) &&
            (identical(other.errorMessage, errorMessage) ||
                other.errorMessage == errorMessage) &&
            const DeepCollectionEquality()
                .equals(other._fieldErrors, _fieldErrors) &&
            (identical(other.isRecoverable, isRecoverable) ||
                other.isRecoverable == isRecoverable) &&
            (identical(other.technicalDetails, technicalDetails) ||
                other.technicalDetails == technicalDetails));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      errorCode,
      errorMessage,
      const DeepCollectionEquality().hash(_fieldErrors),
      isRecoverable,
      technicalDetails);

  /// Create a copy of TemplateRpcResult
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TemplateRpcResultFailureImplCopyWith<_$TemplateRpcResultFailureImpl>
      get copyWith => __$$TemplateRpcResultFailureImplCopyWithImpl<
          _$TemplateRpcResultFailureImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(
            String journalId, String? message, DateTime? createdAt)
        success,
    required TResult Function(
            String errorCode,
            String errorMessage,
            List<FieldError> fieldErrors,
            bool isRecoverable,
            String? technicalDetails)
        failure,
  }) {
    return failure(
        errorCode, errorMessage, fieldErrors, isRecoverable, technicalDetails);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String journalId, String? message, DateTime? createdAt)?
        success,
    TResult? Function(
            String errorCode,
            String errorMessage,
            List<FieldError> fieldErrors,
            bool isRecoverable,
            String? technicalDetails)?
        failure,
  }) {
    return failure?.call(
        errorCode, errorMessage, fieldErrors, isRecoverable, technicalDetails);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String journalId, String? message, DateTime? createdAt)?
        success,
    TResult Function(
            String errorCode,
            String errorMessage,
            List<FieldError> fieldErrors,
            bool isRecoverable,
            String? technicalDetails)?
        failure,
    required TResult orElse(),
  }) {
    if (failure != null) {
      return failure(errorCode, errorMessage, fieldErrors, isRecoverable,
          technicalDetails);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(TemplateRpcResultSuccess value) success,
    required TResult Function(TemplateRpcResultFailure value) failure,
  }) {
    return failure(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(TemplateRpcResultSuccess value)? success,
    TResult? Function(TemplateRpcResultFailure value)? failure,
  }) {
    return failure?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(TemplateRpcResultSuccess value)? success,
    TResult Function(TemplateRpcResultFailure value)? failure,
    required TResult orElse(),
  }) {
    if (failure != null) {
      return failure(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$TemplateRpcResultFailureImplToJson(
      this,
    );
  }
}

abstract class TemplateRpcResultFailure extends TemplateRpcResult {
  const factory TemplateRpcResultFailure(
      {required final String errorCode,
      required final String errorMessage,
      final List<FieldError> fieldErrors,
      final bool isRecoverable,
      final String? technicalDetails}) = _$TemplateRpcResultFailureImpl;
  const TemplateRpcResultFailure._() : super._();

  factory TemplateRpcResultFailure.fromJson(Map<String, dynamic> json) =
      _$TemplateRpcResultFailureImpl.fromJson;

  /// Error code from RPC or application
  String get errorCode;

  /// Human-readable error message
  String get errorMessage;

  /// Optional field-level validation errors
  List<FieldError> get fieldErrors;

  /// Whether this error is recoverable (user can fix and retry)
  bool get isRecoverable;

  /// Original exception details (for logging)
  String? get technicalDetails;

  /// Create a copy of TemplateRpcResult
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TemplateRpcResultFailureImplCopyWith<_$TemplateRpcResultFailureImpl>
      get copyWith => throw _privateConstructorUsedError;
}

FieldError _$FieldErrorFromJson(Map<String, dynamic> json) {
  return _FieldError.fromJson(json);
}

/// @nodoc
mixin _$FieldError {
  /// Name of the field that failed validation
  String get fieldName => throw _privateConstructorUsedError;

  /// Error message for this field
  String get message => throw _privateConstructorUsedError;

  /// Optional: The invalid value that was provided
  String? get invalidValue => throw _privateConstructorUsedError;

  /// Optional: Suggestion for valid value
  String? get suggestion => throw _privateConstructorUsedError;

  /// Serializes this FieldError to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of FieldError
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $FieldErrorCopyWith<FieldError> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FieldErrorCopyWith<$Res> {
  factory $FieldErrorCopyWith(
          FieldError value, $Res Function(FieldError) then) =
      _$FieldErrorCopyWithImpl<$Res, FieldError>;
  @useResult
  $Res call(
      {String fieldName,
      String message,
      String? invalidValue,
      String? suggestion});
}

/// @nodoc
class _$FieldErrorCopyWithImpl<$Res, $Val extends FieldError>
    implements $FieldErrorCopyWith<$Res> {
  _$FieldErrorCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of FieldError
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? fieldName = null,
    Object? message = null,
    Object? invalidValue = freezed,
    Object? suggestion = freezed,
  }) {
    return _then(_value.copyWith(
      fieldName: null == fieldName
          ? _value.fieldName
          : fieldName // ignore: cast_nullable_to_non_nullable
              as String,
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
      invalidValue: freezed == invalidValue
          ? _value.invalidValue
          : invalidValue // ignore: cast_nullable_to_non_nullable
              as String?,
      suggestion: freezed == suggestion
          ? _value.suggestion
          : suggestion // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$FieldErrorImplCopyWith<$Res>
    implements $FieldErrorCopyWith<$Res> {
  factory _$$FieldErrorImplCopyWith(
          _$FieldErrorImpl value, $Res Function(_$FieldErrorImpl) then) =
      __$$FieldErrorImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String fieldName,
      String message,
      String? invalidValue,
      String? suggestion});
}

/// @nodoc
class __$$FieldErrorImplCopyWithImpl<$Res>
    extends _$FieldErrorCopyWithImpl<$Res, _$FieldErrorImpl>
    implements _$$FieldErrorImplCopyWith<$Res> {
  __$$FieldErrorImplCopyWithImpl(
      _$FieldErrorImpl _value, $Res Function(_$FieldErrorImpl) _then)
      : super(_value, _then);

  /// Create a copy of FieldError
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? fieldName = null,
    Object? message = null,
    Object? invalidValue = freezed,
    Object? suggestion = freezed,
  }) {
    return _then(_$FieldErrorImpl(
      fieldName: null == fieldName
          ? _value.fieldName
          : fieldName // ignore: cast_nullable_to_non_nullable
              as String,
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
      invalidValue: freezed == invalidValue
          ? _value.invalidValue
          : invalidValue // ignore: cast_nullable_to_non_nullable
              as String?,
      suggestion: freezed == suggestion
          ? _value.suggestion
          : suggestion // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$FieldErrorImpl implements _FieldError {
  const _$FieldErrorImpl(
      {required this.fieldName,
      required this.message,
      this.invalidValue,
      this.suggestion});

  factory _$FieldErrorImpl.fromJson(Map<String, dynamic> json) =>
      _$$FieldErrorImplFromJson(json);

  /// Name of the field that failed validation
  @override
  final String fieldName;

  /// Error message for this field
  @override
  final String message;

  /// Optional: The invalid value that was provided
  @override
  final String? invalidValue;

  /// Optional: Suggestion for valid value
  @override
  final String? suggestion;

  @override
  String toString() {
    return 'FieldError(fieldName: $fieldName, message: $message, invalidValue: $invalidValue, suggestion: $suggestion)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FieldErrorImpl &&
            (identical(other.fieldName, fieldName) ||
                other.fieldName == fieldName) &&
            (identical(other.message, message) || other.message == message) &&
            (identical(other.invalidValue, invalidValue) ||
                other.invalidValue == invalidValue) &&
            (identical(other.suggestion, suggestion) ||
                other.suggestion == suggestion));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, fieldName, message, invalidValue, suggestion);

  /// Create a copy of FieldError
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$FieldErrorImplCopyWith<_$FieldErrorImpl> get copyWith =>
      __$$FieldErrorImplCopyWithImpl<_$FieldErrorImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$FieldErrorImplToJson(
      this,
    );
  }
}

abstract class _FieldError implements FieldError {
  const factory _FieldError(
      {required final String fieldName,
      required final String message,
      final String? invalidValue,
      final String? suggestion}) = _$FieldErrorImpl;

  factory _FieldError.fromJson(Map<String, dynamic> json) =
      _$FieldErrorImpl.fromJson;

  /// Name of the field that failed validation
  @override
  String get fieldName;

  /// Error message for this field
  @override
  String get message;

  /// Optional: The invalid value that was provided
  @override
  String? get invalidValue;

  /// Optional: Suggestion for valid value
  @override
  String? get suggestion;

  /// Create a copy of FieldError
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$FieldErrorImplCopyWith<_$FieldErrorImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
