// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dashboard_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$supabaseClientHash() => r'834a58d6ae4b94e36f4e04a10d8a7684b929310e';

/// Supabase client provider
///
/// Copied from [supabaseClient].
@ProviderFor(supabaseClient)
final supabaseClientProvider = AutoDisposeProvider<SupabaseClient>.internal(
  supabaseClient,
  name: r'supabaseClientProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$supabaseClientHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef SupabaseClientRef = AutoDisposeProviderRef<SupabaseClient>;
String _$dashboardRemoteDatasourceHash() =>
    r'1f769c85e55efd2b556bacfbadace51ebc0ef4d1';

/// Dashboard remote datasource provider
///
/// Copied from [dashboardRemoteDatasource].
@ProviderFor(dashboardRemoteDatasource)
final dashboardRemoteDatasourceProvider =
    AutoDisposeProvider<DashboardRemoteDatasource>.internal(
  dashboardRemoteDatasource,
  name: r'dashboardRemoteDatasourceProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$dashboardRemoteDatasourceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef DashboardRemoteDatasourceRef
    = AutoDisposeProviderRef<DashboardRemoteDatasource>;
String _$dashboardRepositoryHash() =>
    r'0a483620e6c3e3b586cfc94595508c078374318a';

/// Dashboard repository provider
///
/// Copied from [dashboardRepository].
@ProviderFor(dashboardRepository)
final dashboardRepositoryProvider =
    AutoDisposeProvider<DashboardRepository>.internal(
  dashboardRepository,
  name: r'dashboardRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$dashboardRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef DashboardRepositoryRef = AutoDisposeProviderRef<DashboardRepository>;
String _$dashboardSummaryNotifierHash() =>
    r'cdedaa82cee85208070f834043edcf4989cc14d8';

/// Dashboard summary notifier
///
/// Copied from [DashboardSummaryNotifier].
@ProviderFor(DashboardSummaryNotifier)
final dashboardSummaryNotifierProvider = AutoDisposeNotifierProvider<
    DashboardSummaryNotifier, DashboardSummaryState>.internal(
  DashboardSummaryNotifier.new,
  name: r'dashboardSummaryNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$dashboardSummaryNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$DashboardSummaryNotifier = AutoDisposeNotifier<DashboardSummaryState>;
String _$recentActivitiesNotifierHash() =>
    r'c5328949e882f33b655ffb0d6eae1337db94d369';

/// Recent activities notifier
///
/// Copied from [RecentActivitiesNotifier].
@ProviderFor(RecentActivitiesNotifier)
final recentActivitiesNotifierProvider = AutoDisposeNotifierProvider<
    RecentActivitiesNotifier, RecentActivitiesState>.internal(
  RecentActivitiesNotifier.new,
  name: r'recentActivitiesNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$recentActivitiesNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$RecentActivitiesNotifier = AutoDisposeNotifier<RecentActivitiesState>;
String _$dateRangeNotifierHash() => r'52cc57765bbdbdda2d6fb14c29e5d856f2790d1a';

/// Date range notifier
///
/// Copied from [DateRangeNotifier].
@ProviderFor(DateRangeNotifier)
final dateRangeNotifierProvider =
    AutoDisposeNotifierProvider<DateRangeNotifier, DateRangeState>.internal(
  DateRangeNotifier.new,
  name: r'dateRangeNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$dateRangeNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$DateRangeNotifier = AutoDisposeNotifier<DateRangeState>;
String _$tradeAlertsNotifierHash() =>
    r'7a87056ff0fcefe9f16ec3008ac22e679d9be93b';

/// Trade alerts notifier
///
/// Copied from [TradeAlertsNotifier].
@ProviderFor(TradeAlertsNotifier)
final tradeAlertsNotifierProvider =
    AutoDisposeNotifierProvider<TradeAlertsNotifier, TradeAlertsState>.internal(
  TradeAlertsNotifier.new,
  name: r'tradeAlertsNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$tradeAlertsNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$TradeAlertsNotifier = AutoDisposeNotifier<TradeAlertsState>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
