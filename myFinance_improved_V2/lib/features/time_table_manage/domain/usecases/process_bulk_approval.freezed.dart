// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'process_bulk_approval.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$ProcessBulkApprovalParams {
  List<String> get shiftRequestIds => throw _privateConstructorUsedError;
  List<bool> get approvalStates => throw _privateConstructorUsedError;

  /// Create a copy of ProcessBulkApprovalParams
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ProcessBulkApprovalParamsCopyWith<ProcessBulkApprovalParams> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ProcessBulkApprovalParamsCopyWith<$Res> {
  factory $ProcessBulkApprovalParamsCopyWith(ProcessBulkApprovalParams value,
          $Res Function(ProcessBulkApprovalParams) then) =
      _$ProcessBulkApprovalParamsCopyWithImpl<$Res, ProcessBulkApprovalParams>;
  @useResult
  $Res call({List<String> shiftRequestIds, List<bool> approvalStates});
}

/// @nodoc
class _$ProcessBulkApprovalParamsCopyWithImpl<$Res,
        $Val extends ProcessBulkApprovalParams>
    implements $ProcessBulkApprovalParamsCopyWith<$Res> {
  _$ProcessBulkApprovalParamsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ProcessBulkApprovalParams
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? shiftRequestIds = null,
    Object? approvalStates = null,
  }) {
    return _then(_value.copyWith(
      shiftRequestIds: null == shiftRequestIds
          ? _value.shiftRequestIds
          : shiftRequestIds // ignore: cast_nullable_to_non_nullable
              as List<String>,
      approvalStates: null == approvalStates
          ? _value.approvalStates
          : approvalStates // ignore: cast_nullable_to_non_nullable
              as List<bool>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ProcessBulkApprovalParamsImplCopyWith<$Res>
    implements $ProcessBulkApprovalParamsCopyWith<$Res> {
  factory _$$ProcessBulkApprovalParamsImplCopyWith(
          _$ProcessBulkApprovalParamsImpl value,
          $Res Function(_$ProcessBulkApprovalParamsImpl) then) =
      __$$ProcessBulkApprovalParamsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({List<String> shiftRequestIds, List<bool> approvalStates});
}

/// @nodoc
class __$$ProcessBulkApprovalParamsImplCopyWithImpl<$Res>
    extends _$ProcessBulkApprovalParamsCopyWithImpl<$Res,
        _$ProcessBulkApprovalParamsImpl>
    implements _$$ProcessBulkApprovalParamsImplCopyWith<$Res> {
  __$$ProcessBulkApprovalParamsImplCopyWithImpl(
      _$ProcessBulkApprovalParamsImpl _value,
      $Res Function(_$ProcessBulkApprovalParamsImpl) _then)
      : super(_value, _then);

  /// Create a copy of ProcessBulkApprovalParams
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? shiftRequestIds = null,
    Object? approvalStates = null,
  }) {
    return _then(_$ProcessBulkApprovalParamsImpl(
      shiftRequestIds: null == shiftRequestIds
          ? _value._shiftRequestIds
          : shiftRequestIds // ignore: cast_nullable_to_non_nullable
              as List<String>,
      approvalStates: null == approvalStates
          ? _value._approvalStates
          : approvalStates // ignore: cast_nullable_to_non_nullable
              as List<bool>,
    ));
  }
}

/// @nodoc

class _$ProcessBulkApprovalParamsImpl implements _ProcessBulkApprovalParams {
  const _$ProcessBulkApprovalParamsImpl(
      {required final List<String> shiftRequestIds,
      required final List<bool> approvalStates})
      : _shiftRequestIds = shiftRequestIds,
        _approvalStates = approvalStates;

  final List<String> _shiftRequestIds;
  @override
  List<String> get shiftRequestIds {
    if (_shiftRequestIds is EqualUnmodifiableListView) return _shiftRequestIds;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_shiftRequestIds);
  }

  final List<bool> _approvalStates;
  @override
  List<bool> get approvalStates {
    if (_approvalStates is EqualUnmodifiableListView) return _approvalStates;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_approvalStates);
  }

  @override
  String toString() {
    return 'ProcessBulkApprovalParams(shiftRequestIds: $shiftRequestIds, approvalStates: $approvalStates)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ProcessBulkApprovalParamsImpl &&
            const DeepCollectionEquality()
                .equals(other._shiftRequestIds, _shiftRequestIds) &&
            const DeepCollectionEquality()
                .equals(other._approvalStates, _approvalStates));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_shiftRequestIds),
      const DeepCollectionEquality().hash(_approvalStates));

  /// Create a copy of ProcessBulkApprovalParams
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ProcessBulkApprovalParamsImplCopyWith<_$ProcessBulkApprovalParamsImpl>
      get copyWith => __$$ProcessBulkApprovalParamsImplCopyWithImpl<
          _$ProcessBulkApprovalParamsImpl>(this, _$identity);
}

abstract class _ProcessBulkApprovalParams implements ProcessBulkApprovalParams {
  const factory _ProcessBulkApprovalParams(
          {required final List<String> shiftRequestIds,
          required final List<bool> approvalStates}) =
      _$ProcessBulkApprovalParamsImpl;

  @override
  List<String> get shiftRequestIds;
  @override
  List<bool> get approvalStates;

  /// Create a copy of ProcessBulkApprovalParams
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ProcessBulkApprovalParamsImplCopyWith<_$ProcessBulkApprovalParamsImpl>
      get copyWith => throw _privateConstructorUsedError;
}
