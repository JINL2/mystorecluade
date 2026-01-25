// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'my_page_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$myPageNotifierHash() => r'e5f0933084d3fe591f18b8d9d3af0a582116f26a';

/// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
/// My Page Notifier - 상태 관리 + 비즈니스 로직 조율
/// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
///
/// Flutter 표준 구조: Notifier가 직접 Repository 호출
/// Controller 레이어 없이 Domain Layer와 직접 통신
///
/// Copied from [MyPageNotifier].
@ProviderFor(MyPageNotifier)
final myPageNotifierProvider =
    AutoDisposeNotifierProvider<MyPageNotifier, MyPageState>.internal(
  MyPageNotifier.new,
  name: r'myPageNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$myPageNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$MyPageNotifier = AutoDisposeNotifier<MyPageState>;
String _$profileEditNotifierHash() =>
    r'7490905fa6128df5777927043ae91bfdda6a0e73';

/// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
/// Profile Edit Notifier - 프로필 편집 전용 상태 관리
/// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
///
/// Copied from [ProfileEditNotifier].
@ProviderFor(ProfileEditNotifier)
final profileEditNotifierProvider =
    AutoDisposeNotifierProvider<ProfileEditNotifier, ProfileEditState>.internal(
  ProfileEditNotifier.new,
  name: r'profileEditNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$profileEditNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$ProfileEditNotifier = AutoDisposeNotifier<ProfileEditState>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
