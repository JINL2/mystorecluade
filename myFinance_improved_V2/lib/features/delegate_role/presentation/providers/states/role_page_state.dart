import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../domain/entities/role.dart';

part 'role_page_state.freezed.dart';

/// Role Page State - UI state for delegate role page
///
/// Manages the state of the role list page including:
/// - Search query and filtering
/// - Loading states
/// - Error handling
@freezed
class RolePageState with _$RolePageState {
  const factory RolePageState({
    /// Current search query for filtering roles
    @Default('') String searchQuery,

    /// Whether the page is currently loading data
    @Default(false) bool isLoading,

    /// Error message if any error occurred
    String? errorMessage,

    /// Filtered roles based on search query
    @Default([]) List<Role> filteredRoles,
  }) = _RolePageState;

  /// Initial state factory
  factory RolePageState.initial() => const RolePageState();
}
