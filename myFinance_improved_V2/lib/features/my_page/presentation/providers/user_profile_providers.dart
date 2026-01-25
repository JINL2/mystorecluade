import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../app/providers/auth_providers.dart';
import '../../data/datasources/profile_image_datasource.dart';
import '../../data/datasources/user_profile_datasource.dart';
import '../../data/repositories/user_profile_repository_impl.dart';
import '../../domain/repositories/user_profile_repository.dart';
import 'my_page_notifier.dart';

part 'user_profile_providers.g.dart';

/// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
/// DataSource & Repository Providers (DI)
/// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

/// DataSource provider for user profile
@Riverpod(keepAlive: true)
UserProfileDataSource userProfileDataSource(Ref ref) {
  return UserProfileDataSource();
}

/// DataSource provider for profile image
@Riverpod(keepAlive: true)
ProfileImageDataSource profileImageDataSource(Ref ref) {
  return ProfileImageDataSource();
}

/// Repository provider for user profile
@Riverpod(keepAlive: true)
UserProfileRepository userProfileRepository(Ref ref) {
  return UserProfileRepositoryImpl(
    userProfileDataSource: ref.watch(userProfileDataSourceProvider),
    profileImageDataSource: ref.watch(profileImageDataSourceProvider),
  );
}

/// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
/// Computed Providers (UI Helper Providers)
/// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
///
/// Note: authStateProvider is imported from app/providers/auth_providers.dart

/// Current User Profile Provider - MyPageState에서 userProfile 추출
///
/// 기존 FutureProvider와 호환성을 위한 computed provider
@riverpod
dynamic currentUserProfile(Ref ref) {
  final myPageState = ref.watch(myPageNotifierProvider);
  return myPageState.userProfile;
}

/// Refresh User Data Provider - 사용자 데이터 새로고침 함수
///
/// UI에서 pull-to-refresh 등에 사용할 수 있는 새로고침 함수 제공
@riverpod
Future<void> Function() refreshUserData(Ref ref) {
  return () async {
    final authState = await ref.read(authStateProvider.future);
    if (authState == null) return;

    final notifier = ref.read(myPageNotifierProvider.notifier);
    await notifier.loadUserData(authState.id);
  };
}
