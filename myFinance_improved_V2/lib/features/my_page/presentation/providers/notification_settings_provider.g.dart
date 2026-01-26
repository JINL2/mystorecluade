// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_settings_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$notificationSettingsDataSourceHash() =>
    r'2a81aeffd86e2cbeddcaca37abb2f887e9276ec7';

/// NotificationSettingsDataSource Provider
///
/// Copied from [notificationSettingsDataSource].
@ProviderFor(notificationSettingsDataSource)
final notificationSettingsDataSourceProvider =
    Provider<NotificationSettingsDataSource>.internal(
  notificationSettingsDataSource,
  name: r'notificationSettingsDataSourceProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$notificationSettingsDataSourceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef NotificationSettingsDataSourceRef
    = ProviderRef<NotificationSettingsDataSource>;
String _$notificationSettingsNotifierHash() =>
    r'aaab70dab7238810a98d1f19302fbc48968aa2ca';

/// Notification Settings Notifier (메인 화면)
///
/// Copied from [NotificationSettingsNotifier].
@ProviderFor(NotificationSettingsNotifier)
final notificationSettingsNotifierProvider = AutoDisposeNotifierProvider<
    NotificationSettingsNotifier, NotificationSettingsState>.internal(
  NotificationSettingsNotifier.new,
  name: r'notificationSettingsNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$notificationSettingsNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$NotificationSettingsNotifier
    = AutoDisposeNotifier<NotificationSettingsState>;
String _$storeSettingsNotifierHash() =>
    r'703546eae92d7b0e1a53aa4fdd0c81a74bff824e';

/// Store 상세 설정 Notifier
///
/// Copied from [StoreSettingsNotifier].
@ProviderFor(StoreSettingsNotifier)
final storeSettingsNotifierProvider = AutoDisposeNotifierProvider<
    StoreSettingsNotifier, StoreSettingsState>.internal(
  StoreSettingsNotifier.new,
  name: r'storeSettingsNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$storeSettingsNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$StoreSettingsNotifier = AutoDisposeNotifier<StoreSettingsState>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
