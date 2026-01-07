// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'analytics_hub_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$AnalyticsHubState {
  bool get isLoading => throw _privateConstructorUsedError;
  bool get isRefreshing => throw _privateConstructorUsedError;
  AnalyticsHubData? get data => throw _privateConstructorUsedError;
  String? get errorMessage => throw _privateConstructorUsedError;

  /// Create a copy of AnalyticsHubState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AnalyticsHubStateCopyWith<AnalyticsHubState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AnalyticsHubStateCopyWith<$Res> {
  factory $AnalyticsHubStateCopyWith(
          AnalyticsHubState value, $Res Function(AnalyticsHubState) then) =
      _$AnalyticsHubStateCopyWithImpl<$Res, AnalyticsHubState>;
  @useResult
  $Res call(
      {bool isLoading,
      bool isRefreshing,
      AnalyticsHubData? data,
      String? errorMessage});

  $AnalyticsHubDataCopyWith<$Res>? get data;
}

/// @nodoc
class _$AnalyticsHubStateCopyWithImpl<$Res, $Val extends AnalyticsHubState>
    implements $AnalyticsHubStateCopyWith<$Res> {
  _$AnalyticsHubStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AnalyticsHubState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isLoading = null,
    Object? isRefreshing = null,
    Object? data = freezed,
    Object? errorMessage = freezed,
  }) {
    return _then(_value.copyWith(
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      isRefreshing: null == isRefreshing
          ? _value.isRefreshing
          : isRefreshing // ignore: cast_nullable_to_non_nullable
              as bool,
      data: freezed == data
          ? _value.data
          : data // ignore: cast_nullable_to_non_nullable
              as AnalyticsHubData?,
      errorMessage: freezed == errorMessage
          ? _value.errorMessage
          : errorMessage // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }

  /// Create a copy of AnalyticsHubState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $AnalyticsHubDataCopyWith<$Res>? get data {
    if (_value.data == null) {
      return null;
    }

    return $AnalyticsHubDataCopyWith<$Res>(_value.data!, (value) {
      return _then(_value.copyWith(data: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$AnalyticsHubStateImplCopyWith<$Res>
    implements $AnalyticsHubStateCopyWith<$Res> {
  factory _$$AnalyticsHubStateImplCopyWith(_$AnalyticsHubStateImpl value,
          $Res Function(_$AnalyticsHubStateImpl) then) =
      __$$AnalyticsHubStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {bool isLoading,
      bool isRefreshing,
      AnalyticsHubData? data,
      String? errorMessage});

  @override
  $AnalyticsHubDataCopyWith<$Res>? get data;
}

/// @nodoc
class __$$AnalyticsHubStateImplCopyWithImpl<$Res>
    extends _$AnalyticsHubStateCopyWithImpl<$Res, _$AnalyticsHubStateImpl>
    implements _$$AnalyticsHubStateImplCopyWith<$Res> {
  __$$AnalyticsHubStateImplCopyWithImpl(_$AnalyticsHubStateImpl _value,
      $Res Function(_$AnalyticsHubStateImpl) _then)
      : super(_value, _then);

  /// Create a copy of AnalyticsHubState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isLoading = null,
    Object? isRefreshing = null,
    Object? data = freezed,
    Object? errorMessage = freezed,
  }) {
    return _then(_$AnalyticsHubStateImpl(
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      isRefreshing: null == isRefreshing
          ? _value.isRefreshing
          : isRefreshing // ignore: cast_nullable_to_non_nullable
              as bool,
      data: freezed == data
          ? _value.data
          : data // ignore: cast_nullable_to_non_nullable
              as AnalyticsHubData?,
      errorMessage: freezed == errorMessage
          ? _value.errorMessage
          : errorMessage // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$AnalyticsHubStateImpl extends _AnalyticsHubState {
  const _$AnalyticsHubStateImpl(
      {this.isLoading = false,
      this.isRefreshing = false,
      this.data,
      this.errorMessage})
      : super._();

  @override
  @JsonKey()
  final bool isLoading;
  @override
  @JsonKey()
  final bool isRefreshing;
  @override
  final AnalyticsHubData? data;
  @override
  final String? errorMessage;

  @override
  String toString() {
    return 'AnalyticsHubState(isLoading: $isLoading, isRefreshing: $isRefreshing, data: $data, errorMessage: $errorMessage)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AnalyticsHubStateImpl &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            (identical(other.isRefreshing, isRefreshing) ||
                other.isRefreshing == isRefreshing) &&
            (identical(other.data, data) || other.data == data) &&
            (identical(other.errorMessage, errorMessage) ||
                other.errorMessage == errorMessage));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, isLoading, isRefreshing, data, errorMessage);

  /// Create a copy of AnalyticsHubState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AnalyticsHubStateImplCopyWith<_$AnalyticsHubStateImpl> get copyWith =>
      __$$AnalyticsHubStateImplCopyWithImpl<_$AnalyticsHubStateImpl>(
          this, _$identity);
}

abstract class _AnalyticsHubState extends AnalyticsHubState {
  const factory _AnalyticsHubState(
      {final bool isLoading,
      final bool isRefreshing,
      final AnalyticsHubData? data,
      final String? errorMessage}) = _$AnalyticsHubStateImpl;
  const _AnalyticsHubState._() : super._();

  @override
  bool get isLoading;
  @override
  bool get isRefreshing;
  @override
  AnalyticsHubData? get data;
  @override
  String? get errorMessage;

  /// Create a copy of AnalyticsHubState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AnalyticsHubStateImplCopyWith<_$AnalyticsHubStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
