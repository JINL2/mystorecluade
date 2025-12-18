// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'role_page_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$RolePageState {
  /// Current search query for filtering roles
  String get searchQuery => throw _privateConstructorUsedError;

  /// Whether the page is currently loading data
  bool get isLoading => throw _privateConstructorUsedError;

  /// Error message if any error occurred
  String? get errorMessage => throw _privateConstructorUsedError;

  /// Filtered roles based on search query
  List<Role> get filteredRoles => throw _privateConstructorUsedError;

  /// Create a copy of RolePageState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $RolePageStateCopyWith<RolePageState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RolePageStateCopyWith<$Res> {
  factory $RolePageStateCopyWith(
          RolePageState value, $Res Function(RolePageState) then) =
      _$RolePageStateCopyWithImpl<$Res, RolePageState>;
  @useResult
  $Res call(
      {String searchQuery,
      bool isLoading,
      String? errorMessage,
      List<Role> filteredRoles});
}

/// @nodoc
class _$RolePageStateCopyWithImpl<$Res, $Val extends RolePageState>
    implements $RolePageStateCopyWith<$Res> {
  _$RolePageStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of RolePageState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? searchQuery = null,
    Object? isLoading = null,
    Object? errorMessage = freezed,
    Object? filteredRoles = null,
  }) {
    return _then(_value.copyWith(
      searchQuery: null == searchQuery
          ? _value.searchQuery
          : searchQuery // ignore: cast_nullable_to_non_nullable
              as String,
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      errorMessage: freezed == errorMessage
          ? _value.errorMessage
          : errorMessage // ignore: cast_nullable_to_non_nullable
              as String?,
      filteredRoles: null == filteredRoles
          ? _value.filteredRoles
          : filteredRoles // ignore: cast_nullable_to_non_nullable
              as List<Role>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$RolePageStateImplCopyWith<$Res>
    implements $RolePageStateCopyWith<$Res> {
  factory _$$RolePageStateImplCopyWith(
          _$RolePageStateImpl value, $Res Function(_$RolePageStateImpl) then) =
      __$$RolePageStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String searchQuery,
      bool isLoading,
      String? errorMessage,
      List<Role> filteredRoles});
}

/// @nodoc
class __$$RolePageStateImplCopyWithImpl<$Res>
    extends _$RolePageStateCopyWithImpl<$Res, _$RolePageStateImpl>
    implements _$$RolePageStateImplCopyWith<$Res> {
  __$$RolePageStateImplCopyWithImpl(
      _$RolePageStateImpl _value, $Res Function(_$RolePageStateImpl) _then)
      : super(_value, _then);

  /// Create a copy of RolePageState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? searchQuery = null,
    Object? isLoading = null,
    Object? errorMessage = freezed,
    Object? filteredRoles = null,
  }) {
    return _then(_$RolePageStateImpl(
      searchQuery: null == searchQuery
          ? _value.searchQuery
          : searchQuery // ignore: cast_nullable_to_non_nullable
              as String,
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      errorMessage: freezed == errorMessage
          ? _value.errorMessage
          : errorMessage // ignore: cast_nullable_to_non_nullable
              as String?,
      filteredRoles: null == filteredRoles
          ? _value._filteredRoles
          : filteredRoles // ignore: cast_nullable_to_non_nullable
              as List<Role>,
    ));
  }
}

/// @nodoc

class _$RolePageStateImpl implements _RolePageState {
  const _$RolePageStateImpl(
      {this.searchQuery = '',
      this.isLoading = false,
      this.errorMessage,
      final List<Role> filteredRoles = const []})
      : _filteredRoles = filteredRoles;

  /// Current search query for filtering roles
  @override
  @JsonKey()
  final String searchQuery;

  /// Whether the page is currently loading data
  @override
  @JsonKey()
  final bool isLoading;

  /// Error message if any error occurred
  @override
  final String? errorMessage;

  /// Filtered roles based on search query
  final List<Role> _filteredRoles;

  /// Filtered roles based on search query
  @override
  @JsonKey()
  List<Role> get filteredRoles {
    if (_filteredRoles is EqualUnmodifiableListView) return _filteredRoles;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_filteredRoles);
  }

  @override
  String toString() {
    return 'RolePageState(searchQuery: $searchQuery, isLoading: $isLoading, errorMessage: $errorMessage, filteredRoles: $filteredRoles)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RolePageStateImpl &&
            (identical(other.searchQuery, searchQuery) ||
                other.searchQuery == searchQuery) &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            (identical(other.errorMessage, errorMessage) ||
                other.errorMessage == errorMessage) &&
            const DeepCollectionEquality()
                .equals(other._filteredRoles, _filteredRoles));
  }

  @override
  int get hashCode => Object.hash(runtimeType, searchQuery, isLoading,
      errorMessage, const DeepCollectionEquality().hash(_filteredRoles));

  /// Create a copy of RolePageState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$RolePageStateImplCopyWith<_$RolePageStateImpl> get copyWith =>
      __$$RolePageStateImplCopyWithImpl<_$RolePageStateImpl>(this, _$identity);
}

abstract class _RolePageState implements RolePageState {
  const factory _RolePageState(
      {final String searchQuery,
      final bool isLoading,
      final String? errorMessage,
      final List<Role> filteredRoles}) = _$RolePageStateImpl;

  /// Current search query for filtering roles
  @override
  String get searchQuery;

  /// Whether the page is currently loading data
  @override
  bool get isLoading;

  /// Error message if any error occurred
  @override
  String? get errorMessage;

  /// Filtered roles based on search query
  @override
  List<Role> get filteredRoles;

  /// Create a copy of RolePageState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$RolePageStateImplCopyWith<_$RolePageStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
