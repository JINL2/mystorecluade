import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../domain/entities/user_profile.dart';
import '../../../domain/entities/business_dashboard.dart';

part 'my_page_state.freezed.dart';

/// My Page State - UI state for my page
///
/// Centralized state for user profile and business dashboard
@freezed
class MyPageState with _$MyPageState {
  const factory MyPageState({
    UserProfile? userProfile,
    BusinessDashboard? businessDashboard,
    @Default(false) bool isLoading,
    @Default(false) bool isUpdating,
    String? errorMessage,
  }) = _MyPageState;
}

/// Profile Edit State - UI state for profile editing
///
/// Tracks profile editing flow and validation
@freezed
class ProfileEditState with _$ProfileEditState {
  const factory ProfileEditState({
    @Default(false) bool isEditing,
    @Default(false) bool isSaving,
    @Default(false) bool isUploadingImage,
    String? errorMessage,
    @Default({}) Map<String, String> fieldErrors,
  }) = _ProfileEditState;
}
