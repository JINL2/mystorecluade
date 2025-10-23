import 'package:freezed_annotation/freezed_annotation.dart';

part 'role_management_state.freezed.dart';

/// Role Management State - UI state for role management sheet
///
/// Manages the state of the role management bottom sheet including:
/// - Role members list
/// - User role assignments
/// - Tab selection and loading states
@freezed
class RoleManagementState with _$RoleManagementState {
  const factory RoleManagementState({
    /// Currently selected tab index (0: Overview, 1: Members, 2: Permissions)
    @Default(0) int selectedTab,

    /// Whether currently loading members
    @Default(false) bool isLoadingMembers,

    /// Whether currently loading role assignments
    @Default(false) bool isLoadingRoleAssignments,

    /// List of role members with their details
    @Default([]) List<Map<String, dynamic>> members,

    /// Map of user ID to their current role ID assignments
    @Default({}) Map<String, String?> userRoleAssignments,

    /// Error message if any error occurred
    String? errorMessage,

    /// Company ID for fetching company-specific data
    String? companyId,
  }) = _RoleManagementState;

  /// Initial state factory
  factory RoleManagementState.initial() => const RoleManagementState();
}
