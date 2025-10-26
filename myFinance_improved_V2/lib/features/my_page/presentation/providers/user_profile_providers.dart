import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../data/datasources/profile_image_datasource.dart';
import '../../data/datasources/user_profile_datasource.dart';
import '../../data/repositories/user_profile_repository_impl.dart';
import '../../domain/repositories/user_profile_repository.dart';
import 'my_page_notifier.dart';
import 'states/my_page_state.dart';

/// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
/// 🎯 DataSource & Repository Providers (DI)
/// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

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

/// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
/// 🎯 State Providers (Freezed State + StateNotifier Pattern)
/// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

/// My Page Provider - 메인 페이지 상태 관리
///
/// Flutter 표준 구조: Freezed State + StateNotifier
final myPageProvider = StateNotifierProvider<MyPageNotifier, MyPageState>((ref) {
  return MyPageNotifier(
    repository: ref.read(userProfileRepositoryProvider),
  );
});

/// Profile Edit Provider - 프로필 편집 전용 상태 관리
///
/// Flutter 표준 구조: Freezed State + StateNotifier
final profileEditProvider = StateNotifierProvider<ProfileEditNotifier, ProfileEditState>((ref) {
  return ProfileEditNotifier(
    repository: ref.read(userProfileRepositoryProvider),
  );
});

/// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
/// 🎯 Helper Providers (Auth & Computed)
/// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

// Auth state provider (watches Supabase auth)
final authStateProvider = StreamProvider<User?>((ref) {
  return Supabase.instance.client.auth.onAuthStateChange.map((event) => event.session?.user);
});

/// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
/// 🎯 Computed Providers (UI Helper Providers)
/// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

/// Current User Profile Provider - MyPageState에서 userProfile 추출
///
/// 기존 FutureProvider와 호환성을 위한 computed provider
final currentUserProfileProvider = Provider.autoDispose((ref) {
  final myPageState = ref.watch(myPageProvider);
  return myPageState.userProfile;
});

/// Business Dashboard Provider - MyPageState에서 businessDashboard 추출
///
/// 기존 FutureProvider와 호환성을 위한 computed provider
final businessDashboardProvider = Provider.autoDispose((ref) {
  final myPageState = ref.watch(myPageProvider);
  return myPageState.businessDashboard;
});

/// Refresh User Data Provider - 사용자 데이터 새로고침 함수
///
/// UI에서 pull-to-refresh 등에 사용할 수 있는 새로고침 함수 제공
final refreshUserDataProvider = Provider<Future<void> Function()>((ref) {
  return () async {
    final authState = await ref.read(authStateProvider.future);
    if (authState == null) return;

    final notifier = ref.read(myPageProvider.notifier);
    await notifier.loadUserData(authState.id);
  };
});
