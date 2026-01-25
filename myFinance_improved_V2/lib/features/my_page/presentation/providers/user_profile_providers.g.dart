// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_profile_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$userProfileDataSourceHash() =>
    r'bdefa51d6e4c5b3c1aaf2d3a5bb1c9f73dc50565';

/// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
/// DataSource & Repository Providers (DI)
/// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
/// DataSource provider for user profile
///
/// Copied from [userProfileDataSource].
@ProviderFor(userProfileDataSource)
final userProfileDataSourceProvider = Provider<UserProfileDataSource>.internal(
  userProfileDataSource,
  name: r'userProfileDataSourceProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$userProfileDataSourceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef UserProfileDataSourceRef = ProviderRef<UserProfileDataSource>;
String _$profileImageDataSourceHash() =>
    r'cf12ba96acb4e58d56f367c1b0de706462b6c80b';

/// DataSource provider for profile image
///
/// Copied from [profileImageDataSource].
@ProviderFor(profileImageDataSource)
final profileImageDataSourceProvider =
    Provider<ProfileImageDataSource>.internal(
  profileImageDataSource,
  name: r'profileImageDataSourceProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$profileImageDataSourceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ProfileImageDataSourceRef = ProviderRef<ProfileImageDataSource>;
String _$userProfileRepositoryHash() =>
    r'219a26678a9869ec281578f3f928c1ad326bb311';

/// Repository provider for user profile
///
/// Copied from [userProfileRepository].
@ProviderFor(userProfileRepository)
final userProfileRepositoryProvider = Provider<UserProfileRepository>.internal(
  userProfileRepository,
  name: r'userProfileRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$userProfileRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef UserProfileRepositoryRef = ProviderRef<UserProfileRepository>;
String _$currentUserProfileHash() =>
    r'59d9916378725046e03b12e4c7f01ef329c9bed9';

/// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
/// Computed Providers (UI Helper Providers)
/// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
///
/// Note: authStateProvider is imported from app/providers/auth_providers.dart
/// Current User Profile Provider - MyPageState에서 userProfile 추출
///
/// 기존 FutureProvider와 호환성을 위한 computed provider
///
/// Copied from [currentUserProfile].
@ProviderFor(currentUserProfile)
final currentUserProfileProvider = AutoDisposeProvider<dynamic>.internal(
  currentUserProfile,
  name: r'currentUserProfileProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$currentUserProfileHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef CurrentUserProfileRef = AutoDisposeProviderRef<dynamic>;
String _$refreshUserDataHash() => r'20815889039f2cdbd75e07467aa5239803936770';

/// Refresh User Data Provider - 사용자 데이터 새로고침 함수
///
/// UI에서 pull-to-refresh 등에 사용할 수 있는 새로고침 함수 제공
///
/// Copied from [refreshUserData].
@ProviderFor(refreshUserData)
final refreshUserDataProvider =
    AutoDisposeProvider<Future<void> Function()>.internal(
  refreshUserData,
  name: r'refreshUserDataProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$refreshUserDataHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef RefreshUserDataRef = AutoDisposeProviderRef<Future<void> Function()>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
