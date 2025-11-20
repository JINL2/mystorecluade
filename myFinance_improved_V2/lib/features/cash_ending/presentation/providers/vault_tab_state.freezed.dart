// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'vault_tab_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$VaultTabState {
// Stock flow data
  List<ActualFlow> get stockFlows => throw _privateConstructorUsedError;
  LocationSummary? get locationSummary =>
      throw _privateConstructorUsedError; // Loading states
  bool get isLoadingFlows => throw _privateConstructorUsedError;
  bool get isSaving => throw _privateConstructorUsedError; // Pagination
  int get flowsOffset => throw _privateConstructorUsedError;
  bool get hasMoreFlows => throw _privateConstructorUsedError; // Error handling
  String? get errorMessage => throw _privateConstructorUsedError;

  /// Create a copy of VaultTabState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $VaultTabStateCopyWith<VaultTabState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $VaultTabStateCopyWith<$Res> {
  factory $VaultTabStateCopyWith(
          VaultTabState value, $Res Function(VaultTabState) then) =
      _$VaultTabStateCopyWithImpl<$Res, VaultTabState>;
  @useResult
  $Res call(
      {List<ActualFlow> stockFlows,
      LocationSummary? locationSummary,
      bool isLoadingFlows,
      bool isSaving,
      int flowsOffset,
      bool hasMoreFlows,
      String? errorMessage});
}

/// @nodoc
class _$VaultTabStateCopyWithImpl<$Res, $Val extends VaultTabState>
    implements $VaultTabStateCopyWith<$Res> {
  _$VaultTabStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of VaultTabState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? stockFlows = null,
    Object? locationSummary = freezed,
    Object? isLoadingFlows = null,
    Object? isSaving = null,
    Object? flowsOffset = null,
    Object? hasMoreFlows = null,
    Object? errorMessage = freezed,
  }) {
    return _then(_value.copyWith(
      stockFlows: null == stockFlows
          ? _value.stockFlows
          : stockFlows // ignore: cast_nullable_to_non_nullable
              as List<ActualFlow>,
      locationSummary: freezed == locationSummary
          ? _value.locationSummary
          : locationSummary // ignore: cast_nullable_to_non_nullable
              as LocationSummary?,
      isLoadingFlows: null == isLoadingFlows
          ? _value.isLoadingFlows
          : isLoadingFlows // ignore: cast_nullable_to_non_nullable
              as bool,
      isSaving: null == isSaving
          ? _value.isSaving
          : isSaving // ignore: cast_nullable_to_non_nullable
              as bool,
      flowsOffset: null == flowsOffset
          ? _value.flowsOffset
          : flowsOffset // ignore: cast_nullable_to_non_nullable
              as int,
      hasMoreFlows: null == hasMoreFlows
          ? _value.hasMoreFlows
          : hasMoreFlows // ignore: cast_nullable_to_non_nullable
              as bool,
      errorMessage: freezed == errorMessage
          ? _value.errorMessage
          : errorMessage // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$VaultTabStateImplCopyWith<$Res>
    implements $VaultTabStateCopyWith<$Res> {
  factory _$$VaultTabStateImplCopyWith(
          _$VaultTabStateImpl value, $Res Function(_$VaultTabStateImpl) then) =
      __$$VaultTabStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {List<ActualFlow> stockFlows,
      LocationSummary? locationSummary,
      bool isLoadingFlows,
      bool isSaving,
      int flowsOffset,
      bool hasMoreFlows,
      String? errorMessage});
}

/// @nodoc
class __$$VaultTabStateImplCopyWithImpl<$Res>
    extends _$VaultTabStateCopyWithImpl<$Res, _$VaultTabStateImpl>
    implements _$$VaultTabStateImplCopyWith<$Res> {
  __$$VaultTabStateImplCopyWithImpl(
      _$VaultTabStateImpl _value, $Res Function(_$VaultTabStateImpl) _then)
      : super(_value, _then);

  /// Create a copy of VaultTabState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? stockFlows = null,
    Object? locationSummary = freezed,
    Object? isLoadingFlows = null,
    Object? isSaving = null,
    Object? flowsOffset = null,
    Object? hasMoreFlows = null,
    Object? errorMessage = freezed,
  }) {
    return _then(_$VaultTabStateImpl(
      stockFlows: null == stockFlows
          ? _value._stockFlows
          : stockFlows // ignore: cast_nullable_to_non_nullable
              as List<ActualFlow>,
      locationSummary: freezed == locationSummary
          ? _value.locationSummary
          : locationSummary // ignore: cast_nullable_to_non_nullable
              as LocationSummary?,
      isLoadingFlows: null == isLoadingFlows
          ? _value.isLoadingFlows
          : isLoadingFlows // ignore: cast_nullable_to_non_nullable
              as bool,
      isSaving: null == isSaving
          ? _value.isSaving
          : isSaving // ignore: cast_nullable_to_non_nullable
              as bool,
      flowsOffset: null == flowsOffset
          ? _value.flowsOffset
          : flowsOffset // ignore: cast_nullable_to_non_nullable
              as int,
      hasMoreFlows: null == hasMoreFlows
          ? _value.hasMoreFlows
          : hasMoreFlows // ignore: cast_nullable_to_non_nullable
              as bool,
      errorMessage: freezed == errorMessage
          ? _value.errorMessage
          : errorMessage // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$VaultTabStateImpl implements _VaultTabState {
  const _$VaultTabStateImpl(
      {final List<ActualFlow> stockFlows = const [],
      this.locationSummary,
      this.isLoadingFlows = false,
      this.isSaving = false,
      this.flowsOffset = 0,
      this.hasMoreFlows = false,
      this.errorMessage})
      : _stockFlows = stockFlows;

// Stock flow data
  final List<ActualFlow> _stockFlows;
// Stock flow data
  @override
  @JsonKey()
  List<ActualFlow> get stockFlows {
    if (_stockFlows is EqualUnmodifiableListView) return _stockFlows;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_stockFlows);
  }

  @override
  final LocationSummary? locationSummary;
// Loading states
  @override
  @JsonKey()
  final bool isLoadingFlows;
  @override
  @JsonKey()
  final bool isSaving;
// Pagination
  @override
  @JsonKey()
  final int flowsOffset;
  @override
  @JsonKey()
  final bool hasMoreFlows;
// Error handling
  @override
  final String? errorMessage;

  @override
  String toString() {
    return 'VaultTabState(stockFlows: $stockFlows, locationSummary: $locationSummary, isLoadingFlows: $isLoadingFlows, isSaving: $isSaving, flowsOffset: $flowsOffset, hasMoreFlows: $hasMoreFlows, errorMessage: $errorMessage)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$VaultTabStateImpl &&
            const DeepCollectionEquality()
                .equals(other._stockFlows, _stockFlows) &&
            (identical(other.locationSummary, locationSummary) ||
                other.locationSummary == locationSummary) &&
            (identical(other.isLoadingFlows, isLoadingFlows) ||
                other.isLoadingFlows == isLoadingFlows) &&
            (identical(other.isSaving, isSaving) ||
                other.isSaving == isSaving) &&
            (identical(other.flowsOffset, flowsOffset) ||
                other.flowsOffset == flowsOffset) &&
            (identical(other.hasMoreFlows, hasMoreFlows) ||
                other.hasMoreFlows == hasMoreFlows) &&
            (identical(other.errorMessage, errorMessage) ||
                other.errorMessage == errorMessage));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_stockFlows),
      locationSummary,
      isLoadingFlows,
      isSaving,
      flowsOffset,
      hasMoreFlows,
      errorMessage);

  /// Create a copy of VaultTabState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$VaultTabStateImplCopyWith<_$VaultTabStateImpl> get copyWith =>
      __$$VaultTabStateImplCopyWithImpl<_$VaultTabStateImpl>(this, _$identity);
}

abstract class _VaultTabState implements VaultTabState {
  const factory _VaultTabState(
      {final List<ActualFlow> stockFlows,
      final LocationSummary? locationSummary,
      final bool isLoadingFlows,
      final bool isSaving,
      final int flowsOffset,
      final bool hasMoreFlows,
      final String? errorMessage}) = _$VaultTabStateImpl;

// Stock flow data
  @override
  List<ActualFlow> get stockFlows;
  @override
  LocationSummary? get locationSummary; // Loading states
  @override
  bool get isLoadingFlows;
  @override
  bool get isSaving; // Pagination
  @override
  int get flowsOffset;
  @override
  bool get hasMoreFlows; // Error handling
  @override
  String? get errorMessage;

  /// Create a copy of VaultTabState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$VaultTabStateImplCopyWith<_$VaultTabStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
