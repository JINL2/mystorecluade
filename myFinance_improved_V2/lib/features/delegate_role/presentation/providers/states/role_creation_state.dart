import 'package:freezed_annotation/freezed_annotation.dart';

part 'role_creation_state.freezed.dart';

/// Role Creation State - UI state for role creation modal
///
/// Manages the multi-step role creation process including:
/// - Current step tracking (Basic Info -> Permissions -> Tags)
/// - Form data and validation
/// - Loading and error states
@freezed
class RoleCreationState with _$RoleCreationState {
  const factory RoleCreationState({
    /// Current step in the creation wizard (0: Basic Info, 1: Permissions, 2: Tags)
    @Default(0) int currentStep,

    /// Whether currently creating the role
    @Default(false) bool isCreating,

    /// Whether user is currently editing text fields
    @Default(false) bool isEditingText,

    /// Selected permission IDs
    @Default({}) Set<String> selectedPermissions,

    /// Expanded category IDs for permission tree
    @Default({}) Set<String> expandedCategories,

    /// Selected role tags
    @Default([]) List<String> selectedTags,

    /// Error message if creation failed
    String? errorMessage,

    /// Field-specific validation errors
    @Default({}) Map<String, String> fieldErrors,

    /// Created role ID after successful creation
    String? createdRoleId,
  }) = _RoleCreationState;

  /// Initial state factory
  factory RoleCreationState.initial() => const RoleCreationState();
}
