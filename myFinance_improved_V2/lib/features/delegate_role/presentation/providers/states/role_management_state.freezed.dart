// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'role_management_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$RoleManagementState {
  /// Currently selected tab index (0: Overview, 1: Members, 2: Permissions)
  int get selectedTab => throw _privateConstructorUsedError;

  /// Whether currently loading members
  bool get isLoadingMembers => throw _privateConstructorUsedError;

  /// Whether currently loading role assignments
  bool get isLoadingRoleAssignments => throw _privateConstructorUsedError;

  /// List of role members with their details
  List<Map<String, dynamic>> get members => throw _privateConstructorUsedError;

  /// Map of user ID to their current role ID assignments
  Map<String, String?> get userRoleAssignments =>
      throw _privateConstructorUsedError;

  /// Error message if any error occurred
  String? get errorMessage => throw _privateConstructorUsedError;

  /// Company ID for fetching company-specific data
  String? get companyId => throw _privateConstructorUsedError;

  /// Create a copy of RoleManagementState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $RoleManagementStateCopyWith<RoleManagementState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RoleManagementStateCopyWith<$Res> {
  factory $RoleManagementStateCopyWith(
          RoleManagementState value, $Res Function(RoleManagementState) then) =
      _$RoleManagementStateCopyWithImpl<$Res, RoleManagementState>;
  @useResult
  $Res call(
      {int selectedTab,
      bool isLoadingMembers,
      bool isLoadingRoleAssignments,
      List<Map<String, dynamic>> members,
      Map<String, String?> userRoleAssignments,
      String? errorMessage,
      String? companyId});
}

/// @nodoc
class _$RoleManagementStateCopyWithImpl<$Res, $Val extends RoleManagementState>
    implements $RoleManagementStateCopyWith<$Res> {
  _$RoleManagementStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of RoleManagementState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? selectedTab = null,
    Object? isLoadingMembers = null,
    Object? isLoadingRoleAssignments = null,
    Object? members = null,
    Object? userRoleAssignments = null,
    Object? errorMessage = freezed,
    Object? companyId = freezed,
  }) {
    return _then(_value.copyWith(
      selectedTab: null == selectedTab
          ? _value.selectedTab
          : selectedTab // ignore: cast_nullable_to_non_nullable
              as int,
      isLoadingMembers: null == isLoadingMembers
          ? _value.isLoadingMembers
          : isLoadingMembers // ignore: cast_nullable_to_non_nullable
              as bool,
      isLoadingRoleAssignments: null == isLoadingRoleAssignments
          ? _value.isLoadingRoleAssignments
          : isLoadingRoleAssignments // ignore: cast_nullable_to_non_nullable
              as bool,
      members: null == members
          ? _value.members
          : members // ignore: cast_nullable_to_non_nullable
              as List<Map<String, dynamic>>,
      userRoleAssignments: null == userRoleAssignments
          ? _value.userRoleAssignments
          : userRoleAssignments // ignore: cast_nullable_to_non_nullable
              as Map<String, String?>,
      errorMessage: freezed == errorMessage
          ? _value.errorMessage
          : errorMessage // ignore: cast_nullable_to_non_nullable
              as String?,
      companyId: freezed == companyId
          ? _value.companyId
          : companyId // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$RoleManagementStateImplCopyWith<$Res>
    implements $RoleManagementStateCopyWith<$Res> {
  factory _$$RoleManagementStateImplCopyWith(_$RoleManagementStateImpl value,
          $Res Function(_$RoleManagementStateImpl) then) =
      __$$RoleManagementStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int selectedTab,
      bool isLoadingMembers,
      bool isLoadingRoleAssignments,
      List<Map<String, dynamic>> members,
      Map<String, String?> userRoleAssignments,
      String? errorMessage,
      String? companyId});
}

/// @nodoc
class __$$RoleManagementStateImplCopyWithImpl<$Res>
    extends _$RoleManagementStateCopyWithImpl<$Res, _$RoleManagementStateImpl>
    implements _$$RoleManagementStateImplCopyWith<$Res> {
  __$$RoleManagementStateImplCopyWithImpl(_$RoleManagementStateImpl _value,
      $Res Function(_$RoleManagementStateImpl) _then)
      : super(_value, _then);

  /// Create a copy of RoleManagementState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? selectedTab = null,
    Object? isLoadingMembers = null,
    Object? isLoadingRoleAssignments = null,
    Object? members = null,
    Object? userRoleAssignments = null,
    Object? errorMessage = freezed,
    Object? companyId = freezed,
  }) {
    return _then(_$RoleManagementStateImpl(
      selectedTab: null == selectedTab
          ? _value.selectedTab
          : selectedTab // ignore: cast_nullable_to_non_nullable
              as int,
      isLoadingMembers: null == isLoadingMembers
          ? _value.isLoadingMembers
          : isLoadingMembers // ignore: cast_nullable_to_non_nullable
              as bool,
      isLoadingRoleAssignments: null == isLoadingRoleAssignments
          ? _value.isLoadingRoleAssignments
          : isLoadingRoleAssignments // ignore: cast_nullable_to_non_nullable
              as bool,
      members: null == members
          ? _value._members
          : members // ignore: cast_nullable_to_non_nullable
              as List<Map<String, dynamic>>,
      userRoleAssignments: null == userRoleAssignments
          ? _value._userRoleAssignments
          : userRoleAssignments // ignore: cast_nullable_to_non_nullable
              as Map<String, String?>,
      errorMessage: freezed == errorMessage
          ? _value.errorMessage
          : errorMessage // ignore: cast_nullable_to_non_nullable
              as String?,
      companyId: freezed == companyId
          ? _value.companyId
          : companyId // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$RoleManagementStateImpl implements _RoleManagementState {
  const _$RoleManagementStateImpl(
      {this.selectedTab = 0,
      this.isLoadingMembers = false,
      this.isLoadingRoleAssignments = false,
      final List<Map<String, dynamic>> members = const [],
      final Map<String, String?> userRoleAssignments = const {},
      this.errorMessage,
      this.companyId})
      : _members = members,
        _userRoleAssignments = userRoleAssignments;

  /// Currently selected tab index (0: Overview, 1: Members, 2: Permissions)
  @override
  @JsonKey()
  final int selectedTab;

  /// Whether currently loading members
  @override
  @JsonKey()
  final bool isLoadingMembers;

  /// Whether currently loading role assignments
  @override
  @JsonKey()
  final bool isLoadingRoleAssignments;

  /// List of role members with their details
  final List<Map<String, dynamic>> _members;

  /// List of role members with their details
  @override
  @JsonKey()
  List<Map<String, dynamic>> get members {
    if (_members is EqualUnmodifiableListView) return _members;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_members);
  }

  /// Map of user ID to their current role ID assignments
  final Map<String, String?> _userRoleAssignments;

  /// Map of user ID to their current role ID assignments
  @override
  @JsonKey()
  Map<String, String?> get userRoleAssignments {
    if (_userRoleAssignments is EqualUnmodifiableMapView)
      return _userRoleAssignments;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_userRoleAssignments);
  }

  /// Error message if any error occurred
  @override
  final String? errorMessage;

  /// Company ID for fetching company-specific data
  @override
  final String? companyId;

  @override
  String toString() {
    return 'RoleManagementState(selectedTab: $selectedTab, isLoadingMembers: $isLoadingMembers, isLoadingRoleAssignments: $isLoadingRoleAssignments, members: $members, userRoleAssignments: $userRoleAssignments, errorMessage: $errorMessage, companyId: $companyId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RoleManagementStateImpl &&
            (identical(other.selectedTab, selectedTab) ||
                other.selectedTab == selectedTab) &&
            (identical(other.isLoadingMembers, isLoadingMembers) ||
                other.isLoadingMembers == isLoadingMembers) &&
            (identical(
                    other.isLoadingRoleAssignments, isLoadingRoleAssignments) ||
                other.isLoadingRoleAssignments == isLoadingRoleAssignments) &&
            const DeepCollectionEquality().equals(other._members, _members) &&
            const DeepCollectionEquality()
                .equals(other._userRoleAssignments, _userRoleAssignments) &&
            (identical(other.errorMessage, errorMessage) ||
                other.errorMessage == errorMessage) &&
            (identical(other.companyId, companyId) ||
                other.companyId == companyId));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      selectedTab,
      isLoadingMembers,
      isLoadingRoleAssignments,
      const DeepCollectionEquality().hash(_members),
      const DeepCollectionEquality().hash(_userRoleAssignments),
      errorMessage,
      companyId);

  /// Create a copy of RoleManagementState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$RoleManagementStateImplCopyWith<_$RoleManagementStateImpl> get copyWith =>
      __$$RoleManagementStateImplCopyWithImpl<_$RoleManagementStateImpl>(
          this, _$identity);
}

abstract class _RoleManagementState implements RoleManagementState {
  const factory _RoleManagementState(
      {final int selectedTab,
      final bool isLoadingMembers,
      final bool isLoadingRoleAssignments,
      final List<Map<String, dynamic>> members,
      final Map<String, String?> userRoleAssignments,
      final String? errorMessage,
      final String? companyId}) = _$RoleManagementStateImpl;

  /// Currently selected tab index (0: Overview, 1: Members, 2: Permissions)
  @override
  int get selectedTab;

  /// Whether currently loading members
  @override
  bool get isLoadingMembers;

  /// Whether currently loading role assignments
  @override
  bool get isLoadingRoleAssignments;

  /// List of role members with their details
  @override
  List<Map<String, dynamic>> get members;

  /// Map of user ID to their current role ID assignments
  @override
  Map<String, String?> get userRoleAssignments;

  /// Error message if any error occurred
  @override
  String? get errorMessage;

  /// Company ID for fetching company-specific data
  @override
  String? get companyId;

  /// Create a copy of RoleManagementState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$RoleManagementStateImplCopyWith<_$RoleManagementStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
