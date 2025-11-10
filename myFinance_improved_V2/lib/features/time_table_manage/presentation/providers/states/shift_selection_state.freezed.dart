// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'shift_selection_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$ShiftSelectionState {
  /// Set of selected shift keys (shift_id + user_name combination)
  Set<String> get selectedShiftKeys => throw _privateConstructorUsedError;

  /// Map of shift key to approval state
  Map<String, bool> get approvalStates => throw _privateConstructorUsedError;

  /// Map of shift key to actual shift_request_id for RPC calls
  Map<String, String> get shiftRequestIds => throw _privateConstructorUsedError;

  /// Create a copy of ShiftSelectionState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ShiftSelectionStateCopyWith<ShiftSelectionState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ShiftSelectionStateCopyWith<$Res> {
  factory $ShiftSelectionStateCopyWith(
          ShiftSelectionState value, $Res Function(ShiftSelectionState) then) =
      _$ShiftSelectionStateCopyWithImpl<$Res, ShiftSelectionState>;
  @useResult
  $Res call(
      {Set<String> selectedShiftKeys,
      Map<String, bool> approvalStates,
      Map<String, String> shiftRequestIds});
}

/// @nodoc
class _$ShiftSelectionStateCopyWithImpl<$Res, $Val extends ShiftSelectionState>
    implements $ShiftSelectionStateCopyWith<$Res> {
  _$ShiftSelectionStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ShiftSelectionState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? selectedShiftKeys = null,
    Object? approvalStates = null,
    Object? shiftRequestIds = null,
  }) {
    return _then(_value.copyWith(
      selectedShiftKeys: null == selectedShiftKeys
          ? _value.selectedShiftKeys
          : selectedShiftKeys // ignore: cast_nullable_to_non_nullable
              as Set<String>,
      approvalStates: null == approvalStates
          ? _value.approvalStates
          : approvalStates // ignore: cast_nullable_to_non_nullable
              as Map<String, bool>,
      shiftRequestIds: null == shiftRequestIds
          ? _value.shiftRequestIds
          : shiftRequestIds // ignore: cast_nullable_to_non_nullable
              as Map<String, String>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ShiftSelectionStateImplCopyWith<$Res>
    implements $ShiftSelectionStateCopyWith<$Res> {
  factory _$$ShiftSelectionStateImplCopyWith(_$ShiftSelectionStateImpl value,
          $Res Function(_$ShiftSelectionStateImpl) then) =
      __$$ShiftSelectionStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {Set<String> selectedShiftKeys,
      Map<String, bool> approvalStates,
      Map<String, String> shiftRequestIds});
}

/// @nodoc
class __$$ShiftSelectionStateImplCopyWithImpl<$Res>
    extends _$ShiftSelectionStateCopyWithImpl<$Res, _$ShiftSelectionStateImpl>
    implements _$$ShiftSelectionStateImplCopyWith<$Res> {
  __$$ShiftSelectionStateImplCopyWithImpl(_$ShiftSelectionStateImpl _value,
      $Res Function(_$ShiftSelectionStateImpl) _then)
      : super(_value, _then);

  /// Create a copy of ShiftSelectionState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? selectedShiftKeys = null,
    Object? approvalStates = null,
    Object? shiftRequestIds = null,
  }) {
    return _then(_$ShiftSelectionStateImpl(
      selectedShiftKeys: null == selectedShiftKeys
          ? _value._selectedShiftKeys
          : selectedShiftKeys // ignore: cast_nullable_to_non_nullable
              as Set<String>,
      approvalStates: null == approvalStates
          ? _value._approvalStates
          : approvalStates // ignore: cast_nullable_to_non_nullable
              as Map<String, bool>,
      shiftRequestIds: null == shiftRequestIds
          ? _value._shiftRequestIds
          : shiftRequestIds // ignore: cast_nullable_to_non_nullable
              as Map<String, String>,
    ));
  }
}

/// @nodoc

class _$ShiftSelectionStateImpl extends _ShiftSelectionState {
  const _$ShiftSelectionStateImpl(
      {final Set<String> selectedShiftKeys = const {},
      final Map<String, bool> approvalStates = const {},
      final Map<String, String> shiftRequestIds = const {}})
      : _selectedShiftKeys = selectedShiftKeys,
        _approvalStates = approvalStates,
        _shiftRequestIds = shiftRequestIds,
        super._();

  /// Set of selected shift keys (shift_id + user_name combination)
  final Set<String> _selectedShiftKeys;

  /// Set of selected shift keys (shift_id + user_name combination)
  @override
  @JsonKey()
  Set<String> get selectedShiftKeys {
    if (_selectedShiftKeys is EqualUnmodifiableSetView)
      return _selectedShiftKeys;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableSetView(_selectedShiftKeys);
  }

  /// Map of shift key to approval state
  final Map<String, bool> _approvalStates;

  /// Map of shift key to approval state
  @override
  @JsonKey()
  Map<String, bool> get approvalStates {
    if (_approvalStates is EqualUnmodifiableMapView) return _approvalStates;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_approvalStates);
  }

  /// Map of shift key to actual shift_request_id for RPC calls
  final Map<String, String> _shiftRequestIds;

  /// Map of shift key to actual shift_request_id for RPC calls
  @override
  @JsonKey()
  Map<String, String> get shiftRequestIds {
    if (_shiftRequestIds is EqualUnmodifiableMapView) return _shiftRequestIds;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_shiftRequestIds);
  }

  @override
  String toString() {
    return 'ShiftSelectionState(selectedShiftKeys: $selectedShiftKeys, approvalStates: $approvalStates, shiftRequestIds: $shiftRequestIds)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ShiftSelectionStateImpl &&
            const DeepCollectionEquality()
                .equals(other._selectedShiftKeys, _selectedShiftKeys) &&
            const DeepCollectionEquality()
                .equals(other._approvalStates, _approvalStates) &&
            const DeepCollectionEquality()
                .equals(other._shiftRequestIds, _shiftRequestIds));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_selectedShiftKeys),
      const DeepCollectionEquality().hash(_approvalStates),
      const DeepCollectionEquality().hash(_shiftRequestIds));

  /// Create a copy of ShiftSelectionState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ShiftSelectionStateImplCopyWith<_$ShiftSelectionStateImpl> get copyWith =>
      __$$ShiftSelectionStateImplCopyWithImpl<_$ShiftSelectionStateImpl>(
          this, _$identity);
}

abstract class _ShiftSelectionState extends ShiftSelectionState {
  const factory _ShiftSelectionState(
      {final Set<String> selectedShiftKeys,
      final Map<String, bool> approvalStates,
      final Map<String, String> shiftRequestIds}) = _$ShiftSelectionStateImpl;
  const _ShiftSelectionState._() : super._();

  /// Set of selected shift keys (shift_id + user_name combination)
  @override
  Set<String> get selectedShiftKeys;

  /// Map of shift key to approval state
  @override
  Map<String, bool> get approvalStates;

  /// Map of shift key to actual shift_request_id for RPC calls
  @override
  Map<String, String> get shiftRequestIds;

  /// Create a copy of ShiftSelectionState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ShiftSelectionStateImplCopyWith<_$ShiftSelectionStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
