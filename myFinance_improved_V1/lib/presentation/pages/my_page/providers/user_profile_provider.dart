import 'dart:typed_data';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../domain/entities/user_profile.dart';
import '../../../../data/repositories/supabase_user_repository.dart';
import '../../../providers/auth_provider.dart';

/// State for managing user profile operations
class UserProfileState {
  final UserProfile? profile;
  final bool isLoading;
  final String? error;
  final bool isUpdating;

  UserProfileState({
    this.profile,
    this.isLoading = false,
    this.error,
    this.isUpdating = false,
  });

  UserProfileState copyWith({
    UserProfile? profile,
    bool? isLoading,
    String? error,
    bool? isUpdating,
  }) {
    return UserProfileState(
      profile: profile ?? this.profile,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      isUpdating: isUpdating ?? this.isUpdating,
    );
  }
}

/// State notifier for user profile management
class UserProfileNotifier extends StateNotifier<UserProfileState> {
  final UserRepository _repository;
  final Ref _ref;

  UserProfileNotifier(this._repository, this._ref) : super(UserProfileState()) {
    // Load profile on initialization if user is authenticated
    _loadProfile();
  }

  /// Load user profile from Supabase
  Future<void> _loadProfile() async {
    final currentUser = _ref.read(authStateProvider);
    if (currentUser == null) {
      state = UserProfileState(error: 'User not authenticated');
      return;
    }

    state = state.copyWith(isLoading: true, error: null);

    try {
      final profile = await _repository.getUserProfile(currentUser.id);
      
      if (profile != null) {
        state = UserProfileState(profile: profile);
      } else {
        // If no profile exists in users table, create a basic one from auth data
        final basicProfile = UserProfile(
          userId: currentUser.id,
          email: currentUser.email ?? '',
          firstName: currentUser.userMetadata?['full_name']?.split(' ').first,
          lastName: currentUser.userMetadata?['full_name']?.split(' ').skip(1).join(' '),
          createdAt: DateTime.now(),
        );
        state = UserProfileState(profile: basicProfile);
      }
    } catch (e) {
      state = UserProfileState(error: e.toString());
    }
  }

  /// Refresh profile data
  Future<void> refreshProfile() async {
    await _loadProfile();
  }

  /// Update user profile
  Future<bool> updateProfile({
    String? firstName,
    String? lastName,
    String? profileImage,
  }) async {
    if (state.profile == null) return false;

    state = state.copyWith(isUpdating: true, error: null);

    try {
      final updatedProfile = await _repository.updateUserProfile(
        userId: state.profile!.userId,
        firstName: firstName,
        lastName: lastName,
        profileImage: profileImage,
      );

      if (updatedProfile != null) {
        state = UserProfileState(profile: updatedProfile);
        return true;
      } else {
        state = state.copyWith(
          isUpdating: false,
          error: 'Failed to update profile',
        );
        return false;
      }
    } catch (e) {
      state = state.copyWith(
        isUpdating: false,
        error: e.toString(),
      );
      return false;
    }
  }

  /// Upload profile image
  Future<bool> uploadProfileImage({
    required Uint8List imageBytes,
    required String fileName,
  }) async {
    if (state.profile == null) return false;

    state = state.copyWith(isUpdating: true, error: null);

    try {
      final imageUrl = await _repository.uploadProfileImage(
        userId: state.profile!.userId,
        imageBytes: imageBytes,
        fileName: fileName,
      );

      if (imageUrl != null) {
        return await updateProfile(profileImage: imageUrl);
      } else {
        state = state.copyWith(
          isUpdating: false,
          error: 'Failed to upload image',
        );
        return false;
      }
    } catch (e) {
      state = state.copyWith(
        isUpdating: false,
        error: e.toString(),
      );
      return false;
    }
  }

  /// Clear error message
  void clearError() {
    state = state.copyWith(error: null);
  }
}

/// Provider for user profile state
final userProfileProvider = StateNotifierProvider<UserProfileNotifier, UserProfileState>((ref) {
  final repository = ref.watch(userRepositoryProvider);
  return UserProfileNotifier(repository, ref);
});

/// Computed provider for current user profile
final currentUserProfileProvider = Provider<UserProfile?>((ref) {
  return ref.watch(userProfileProvider).profile;
});

/// Computed provider for profile loading state
final isProfileLoadingProvider = Provider<bool>((ref) {
  return ref.watch(userProfileProvider).isLoading;
});

/// Computed provider for profile error state
final profileErrorProvider = Provider<String?>((ref) {
  return ref.watch(userProfileProvider).error;
});

/// Computed provider for profile updating state
final isProfileUpdatingProvider = Provider<bool>((ref) {
  return ref.watch(userProfileProvider).isUpdating;
});