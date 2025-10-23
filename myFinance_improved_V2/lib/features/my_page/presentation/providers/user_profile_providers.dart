import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../data/datasources/profile_image_datasource.dart';
import '../../data/datasources/user_profile_datasource.dart';
import '../../data/repositories/user_profile_repository_impl.dart';
import '../../domain/entities/business_dashboard.dart';
import '../../domain/entities/user_profile.dart';
import '../../domain/repositories/user_profile_repository.dart';

// DataSource providers
final userProfileDataSourceProvider = Provider<UserProfileDataSource>((ref) {
  return UserProfileDataSource();
});

final profileImageDataSourceProvider = Provider<ProfileImageDataSource>((ref) {
  return ProfileImageDataSource();
});

// Repository provider
final userProfileRepositoryProvider = Provider<UserProfileRepository>((ref) {
  return UserProfileRepositoryImpl(
    userProfileDataSource: ref.watch(userProfileDataSourceProvider),
    profileImageDataSource: ref.watch(profileImageDataSourceProvider),
  );
});

// Auth state provider (watches Supabase auth)
final authStateProvider = StreamProvider<User?>((ref) {
  return Supabase.instance.client.auth.onAuthStateChange.map((event) => event.session?.user);
});

// Current user profile provider
final currentUserProfileProvider = FutureProvider<UserProfile?>((ref) async {
  final authState = await ref.watch(authStateProvider.future);

  if (authState == null) return null;

  try {
    final repository = ref.watch(userProfileRepositoryProvider);
    final profile = await repository.getUserProfile(authState.id);

    if (profile == null) {
      // Return minimal profile if not found
      return UserProfile(
        userId: authState.id,
        email: authState.email ?? '',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
    }

    return profile;
  } catch (e) {
    return null;
  }
});

// Business dashboard provider
final businessDashboardProvider = FutureProvider<BusinessDashboard?>((ref) async {
  final authState = await ref.watch(authStateProvider.future);

  if (authState == null) return null;

  try {
    final repository = ref.watch(userProfileRepositoryProvider);
    return await repository.getBusinessDashboard(authState.id);
  } catch (e) {
    return null;
  }
});

// User profile service provider for update operations
final userProfileServiceProvider = StateNotifierProvider<UserProfileServiceNotifier, AsyncValue<void>>((ref) {
  return UserProfileServiceNotifier(
    repository: ref.watch(userProfileRepositoryProvider),
  );
});

class UserProfileServiceNotifier extends StateNotifier<AsyncValue<void>> {
  final UserProfileRepository repository;

  UserProfileServiceNotifier({required this.repository}) : super(const AsyncValue.data(null));

  Future<void> updateProfile({
    String? firstName,
    String? lastName,
    String? phoneNumber,
    String? bankName,
    String? bankAccountNumber,
    String? profileImage,
  }) async {
    state = const AsyncValue.loading();

    try {
      final userId = Supabase.instance.client.auth.currentUser?.id;
      if (userId == null) throw Exception('User not authenticated');

      await repository.updateUserProfile(
        userId: userId,
        firstName: firstName,
        lastName: lastName,
        phoneNumber: phoneNumber,
        bankName: bankName,
        bankAccountNumber: bankAccountNumber,
        profileImage: profileImage,
      );

      state = const AsyncValue.data(null);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<String> uploadProfileImage(String filePath) async {
    state = const AsyncValue.loading();

    try {
      final userId = Supabase.instance.client.auth.currentUser?.id;
      if (userId == null) throw Exception('User not authenticated');

      final publicUrl = await repository.uploadProfileImage(userId, filePath);

      state = const AsyncValue.data(null);
      return publicUrl;
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
      rethrow;
    }
  }

  Future<void> removeProfileImage() async {
    state = const AsyncValue.loading();

    try {
      final userId = Supabase.instance.client.auth.currentUser?.id;
      if (userId == null) throw Exception('User not authenticated');

      await repository.removeProfileImage(userId);

      state = const AsyncValue.data(null);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }
}
