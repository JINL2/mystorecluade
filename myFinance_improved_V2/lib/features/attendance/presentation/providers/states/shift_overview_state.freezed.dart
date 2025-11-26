// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'shift_overview_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$ShiftOverviewState {
  ShiftOverview get overview => throw _privateConstructorUsedError;
  bool get isLoading => throw _privateConstructorUsedError;
  String? get error => throw _privateConstructorUsedError;

  /// Create a copy of ShiftOverviewState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ShiftOverviewStateCopyWith<ShiftOverviewState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ShiftOverviewStateCopyWith<$Res> {
  factory $ShiftOverviewStateCopyWith(
          ShiftOverviewState value, $Res Function(ShiftOverviewState) then) =
      _$ShiftOverviewStateCopyWithImpl<$Res, ShiftOverviewState>;
  @useResult
  $Res call({ShiftOverview overview, bool isLoading, String? error});
}

/// @nodoc
class _$ShiftOverviewStateCopyWithImpl<$Res, $Val extends ShiftOverviewState>
    implements $ShiftOverviewStateCopyWith<$Res> {
  _$ShiftOverviewStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ShiftOverviewState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? overview = null,
    Object? isLoading = null,
    Object? error = freezed,
  }) {
    return _then(_value.copyWith(
      overview: null == overview
          ? _value.overview
          : overview // ignore: cast_nullable_to_non_nullable
              as ShiftOverview,
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      error: freezed == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ShiftOverviewStateImplCopyWith<$Res>
    implements $ShiftOverviewStateCopyWith<$Res> {
  factory _$$ShiftOverviewStateImplCopyWith(_$ShiftOverviewStateImpl value,
          $Res Function(_$ShiftOverviewStateImpl) then) =
      __$$ShiftOverviewStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({ShiftOverview overview, bool isLoading, String? error});
}

/// @nodoc
class __$$ShiftOverviewStateImplCopyWithImpl<$Res>
    extends _$ShiftOverviewStateCopyWithImpl<$Res, _$ShiftOverviewStateImpl>
    implements _$$ShiftOverviewStateImplCopyWith<$Res> {
  __$$ShiftOverviewStateImplCopyWithImpl(_$ShiftOverviewStateImpl _value,
      $Res Function(_$ShiftOverviewStateImpl) _then)
      : super(_value, _then);

  /// Create a copy of ShiftOverviewState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? overview = null,
    Object? isLoading = null,
    Object? error = freezed,
  }) {
    return _then(_$ShiftOverviewStateImpl(
      overview: null == overview
          ? _value.overview
          : overview // ignore: cast_nullable_to_non_nullable
              as ShiftOverview,
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      error: freezed == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$ShiftOverviewStateImpl implements _ShiftOverviewState {
  const _$ShiftOverviewStateImpl(
      {required this.overview, this.isLoading = false, this.error});

  @override
  final ShiftOverview overview;
  @override
  @JsonKey()
  final bool isLoading;
  @override
  final String? error;

  @override
  String toString() {
    return 'ShiftOverviewState(overview: $overview, isLoading: $isLoading, error: $error)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ShiftOverviewStateImpl &&
            (identical(other.overview, overview) ||
                other.overview == overview) &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            (identical(other.error, error) || other.error == error));
  }

  @override
  int get hashCode => Object.hash(runtimeType, overview, isLoading, error);

  /// Create a copy of ShiftOverviewState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ShiftOverviewStateImplCopyWith<_$ShiftOverviewStateImpl> get copyWith =>
      __$$ShiftOverviewStateImplCopyWithImpl<_$ShiftOverviewStateImpl>(
          this, _$identity);
}

abstract class _ShiftOverviewState implements ShiftOverviewState {
  const factory _ShiftOverviewState(
      {required final ShiftOverview overview,
      final bool isLoading,
      final String? error}) = _$ShiftOverviewStateImpl;

  @override
  ShiftOverview get overview;
  @override
  bool get isLoading;
  @override
  String? get error;

  /// Create a copy of ShiftOverviewState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ShiftOverviewStateImplCopyWith<_$ShiftOverviewStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
