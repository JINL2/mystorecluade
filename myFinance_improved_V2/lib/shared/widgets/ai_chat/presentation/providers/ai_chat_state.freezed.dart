// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'ai_chat_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$AiChatState {
  List<ChatMessage> get messages => throw _privateConstructorUsedError;
  bool get isLoading => throw _privateConstructorUsedError;
  String get streamingText => throw _privateConstructorUsedError;
  List<Map<String, dynamic>>? get currentResultData =>
      throw _privateConstructorUsedError;
  String? get sessionId => throw _privateConstructorUsedError;
  bool get hasUnreadResponse => throw _privateConstructorUsedError;
  String? get error => throw _privateConstructorUsedError;

  /// Create a copy of AiChatState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AiChatStateCopyWith<AiChatState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AiChatStateCopyWith<$Res> {
  factory $AiChatStateCopyWith(
          AiChatState value, $Res Function(AiChatState) then) =
      _$AiChatStateCopyWithImpl<$Res, AiChatState>;
  @useResult
  $Res call(
      {List<ChatMessage> messages,
      bool isLoading,
      String streamingText,
      List<Map<String, dynamic>>? currentResultData,
      String? sessionId,
      bool hasUnreadResponse,
      String? error});
}

/// @nodoc
class _$AiChatStateCopyWithImpl<$Res, $Val extends AiChatState>
    implements $AiChatStateCopyWith<$Res> {
  _$AiChatStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AiChatState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? messages = null,
    Object? isLoading = null,
    Object? streamingText = null,
    Object? currentResultData = freezed,
    Object? sessionId = freezed,
    Object? hasUnreadResponse = null,
    Object? error = freezed,
  }) {
    return _then(_value.copyWith(
      messages: null == messages
          ? _value.messages
          : messages // ignore: cast_nullable_to_non_nullable
              as List<ChatMessage>,
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      streamingText: null == streamingText
          ? _value.streamingText
          : streamingText // ignore: cast_nullable_to_non_nullable
              as String,
      currentResultData: freezed == currentResultData
          ? _value.currentResultData
          : currentResultData // ignore: cast_nullable_to_non_nullable
              as List<Map<String, dynamic>>?,
      sessionId: freezed == sessionId
          ? _value.sessionId
          : sessionId // ignore: cast_nullable_to_non_nullable
              as String?,
      hasUnreadResponse: null == hasUnreadResponse
          ? _value.hasUnreadResponse
          : hasUnreadResponse // ignore: cast_nullable_to_non_nullable
              as bool,
      error: freezed == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$AiChatStateImplCopyWith<$Res>
    implements $AiChatStateCopyWith<$Res> {
  factory _$$AiChatStateImplCopyWith(
          _$AiChatStateImpl value, $Res Function(_$AiChatStateImpl) then) =
      __$$AiChatStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {List<ChatMessage> messages,
      bool isLoading,
      String streamingText,
      List<Map<String, dynamic>>? currentResultData,
      String? sessionId,
      bool hasUnreadResponse,
      String? error});
}

/// @nodoc
class __$$AiChatStateImplCopyWithImpl<$Res>
    extends _$AiChatStateCopyWithImpl<$Res, _$AiChatStateImpl>
    implements _$$AiChatStateImplCopyWith<$Res> {
  __$$AiChatStateImplCopyWithImpl(
      _$AiChatStateImpl _value, $Res Function(_$AiChatStateImpl) _then)
      : super(_value, _then);

  /// Create a copy of AiChatState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? messages = null,
    Object? isLoading = null,
    Object? streamingText = null,
    Object? currentResultData = freezed,
    Object? sessionId = freezed,
    Object? hasUnreadResponse = null,
    Object? error = freezed,
  }) {
    return _then(_$AiChatStateImpl(
      messages: null == messages
          ? _value._messages
          : messages // ignore: cast_nullable_to_non_nullable
              as List<ChatMessage>,
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      streamingText: null == streamingText
          ? _value.streamingText
          : streamingText // ignore: cast_nullable_to_non_nullable
              as String,
      currentResultData: freezed == currentResultData
          ? _value._currentResultData
          : currentResultData // ignore: cast_nullable_to_non_nullable
              as List<Map<String, dynamic>>?,
      sessionId: freezed == sessionId
          ? _value.sessionId
          : sessionId // ignore: cast_nullable_to_non_nullable
              as String?,
      hasUnreadResponse: null == hasUnreadResponse
          ? _value.hasUnreadResponse
          : hasUnreadResponse // ignore: cast_nullable_to_non_nullable
              as bool,
      error: freezed == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$AiChatStateImpl implements _AiChatState {
  const _$AiChatStateImpl(
      {final List<ChatMessage> messages = const [],
      this.isLoading = false,
      this.streamingText = '',
      final List<Map<String, dynamic>>? currentResultData,
      this.sessionId,
      this.hasUnreadResponse = false,
      this.error})
      : _messages = messages,
        _currentResultData = currentResultData;

  final List<ChatMessage> _messages;
  @override
  @JsonKey()
  List<ChatMessage> get messages {
    if (_messages is EqualUnmodifiableListView) return _messages;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_messages);
  }

  @override
  @JsonKey()
  final bool isLoading;
  @override
  @JsonKey()
  final String streamingText;
  final List<Map<String, dynamic>>? _currentResultData;
  @override
  List<Map<String, dynamic>>? get currentResultData {
    final value = _currentResultData;
    if (value == null) return null;
    if (_currentResultData is EqualUnmodifiableListView)
      return _currentResultData;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  final String? sessionId;
  @override
  @JsonKey()
  final bool hasUnreadResponse;
  @override
  final String? error;

  @override
  String toString() {
    return 'AiChatState(messages: $messages, isLoading: $isLoading, streamingText: $streamingText, currentResultData: $currentResultData, sessionId: $sessionId, hasUnreadResponse: $hasUnreadResponse, error: $error)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AiChatStateImpl &&
            const DeepCollectionEquality().equals(other._messages, _messages) &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            (identical(other.streamingText, streamingText) ||
                other.streamingText == streamingText) &&
            const DeepCollectionEquality()
                .equals(other._currentResultData, _currentResultData) &&
            (identical(other.sessionId, sessionId) ||
                other.sessionId == sessionId) &&
            (identical(other.hasUnreadResponse, hasUnreadResponse) ||
                other.hasUnreadResponse == hasUnreadResponse) &&
            (identical(other.error, error) || other.error == error));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_messages),
      isLoading,
      streamingText,
      const DeepCollectionEquality().hash(_currentResultData),
      sessionId,
      hasUnreadResponse,
      error);

  /// Create a copy of AiChatState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AiChatStateImplCopyWith<_$AiChatStateImpl> get copyWith =>
      __$$AiChatStateImplCopyWithImpl<_$AiChatStateImpl>(this, _$identity);
}

abstract class _AiChatState implements AiChatState {
  const factory _AiChatState(
      {final List<ChatMessage> messages,
      final bool isLoading,
      final String streamingText,
      final List<Map<String, dynamic>>? currentResultData,
      final String? sessionId,
      final bool hasUnreadResponse,
      final String? error}) = _$AiChatStateImpl;

  @override
  List<ChatMessage> get messages;
  @override
  bool get isLoading;
  @override
  String get streamingText;
  @override
  List<Map<String, dynamic>>? get currentResultData;
  @override
  String? get sessionId;
  @override
  bool get hasUnreadResponse;
  @override
  String? get error;

  /// Create a copy of AiChatState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AiChatStateImplCopyWith<_$AiChatStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
