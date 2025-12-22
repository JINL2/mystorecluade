// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'repository_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$supabaseClientHash() => r'36e9cae00709545a85bfe4a5a2cb98d8686a01ea';

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
String _$attendanceDatasourceHash() =>
    r'575125fbe007c91948a303b06ff28878b3c19582';

/// Attendance datasource provider
///
/// Copied from [attendanceDatasource].
@ProviderFor(attendanceDatasource)
final attendanceDatasourceProvider =
    AutoDisposeProvider<AttendanceDatasource>.internal(
  attendanceDatasource,
  name: r'attendanceDatasourceProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$attendanceDatasourceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef AttendanceDatasourceRef = AutoDisposeProviderRef<AttendanceDatasource>;
String _$attendanceRepositoryHash() =>
    r'0eaeaca95b99860072a9d8b12fa8668feea39ffe';

/// Attendance repository provider
///
/// Provides the concrete implementation of AttendanceRepository.
/// Presentation layer accesses this through the interface type.
///
/// Copied from [attendanceRepository].
@ProviderFor(attendanceRepository)
final attendanceRepositoryProvider =
    AutoDisposeProvider<AttendanceRepository>.internal(
  attendanceRepository,
  name: r'attendanceRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$attendanceRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef AttendanceRepositoryRef = AutoDisposeProviderRef<AttendanceRepository>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
