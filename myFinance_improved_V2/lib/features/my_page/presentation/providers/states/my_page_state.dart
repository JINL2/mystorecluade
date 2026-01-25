import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../domain/entities/user_profile.dart';

part 'my_page_state.freezed.dart';

/// My Page State - UI state for my page
///
/// Note: Role/Company/Store info는 AppState에서 가져옴 (RPC로 이미 로드됨)
@freezed
class MyPageState with _$MyPageState {
  const factory MyPageState({
    UserProfile? userProfile,
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
