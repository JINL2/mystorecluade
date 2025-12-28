// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'monthly_attendance_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$monthlyAttendanceDataSourceHash() =>
    r'3ca9089f9a40a5a1d1248f823ecc066e0dc87aeb';

/// Monthly Attendance DataSource Provider
///
/// Copied from [monthlyAttendanceDataSource].
@ProviderFor(monthlyAttendanceDataSource)
final monthlyAttendanceDataSourceProvider =
    AutoDisposeProvider<MonthlyAttendanceDataSource>.internal(
  monthlyAttendanceDataSource,
  name: r'monthlyAttendanceDataSourceProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$monthlyAttendanceDataSourceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef MonthlyAttendanceDataSourceRef
    = AutoDisposeProviderRef<MonthlyAttendanceDataSource>;
String _$monthlyAttendanceRepositoryHash() =>
    r'9f381da474faa5f481872ced0e0cff82a919da74';

/// Monthly Attendance Repository Provider
///
/// Copied from [monthlyAttendanceRepository].
@ProviderFor(monthlyAttendanceRepository)
final monthlyAttendanceRepositoryProvider =
    AutoDisposeProvider<MonthlyAttendanceRepository>.internal(
  monthlyAttendanceRepository,
  name: r'monthlyAttendanceRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$monthlyAttendanceRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef MonthlyAttendanceRepositoryRef
    = AutoDisposeProviderRef<MonthlyAttendanceRepository>;
String _$userSalaryTypeHash() => r'359a8b5a8821628988e4e325bfe19e823cc824c9';

/// 현재 사용자의 급여 타입 조회
///
/// Returns: 'monthly' | 'hourly' | null
///
/// user_salaries 테이블에서 조회
///
/// Copied from [userSalaryType].
@ProviderFor(userSalaryType)
final userSalaryTypeProvider = AutoDisposeFutureProvider<String?>.internal(
  userSalaryType,
  name: r'userSalaryTypeProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$userSalaryTypeHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef UserSalaryTypeRef = AutoDisposeFutureProviderRef<String?>;
String _$isMonthlyEmployeeHash() => r'4ab47fc449aade5b241a006dca49242ae5622706';

/// 현재 사용자가 Monthly 직원인지 확인
///
/// Copied from [isMonthlyEmployee].
@ProviderFor(isMonthlyEmployee)
final isMonthlyEmployeeProvider = AutoDisposeFutureProvider<bool>.internal(
  isMonthlyEmployee,
  name: r'isMonthlyEmployeeProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$isMonthlyEmployeeHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef IsMonthlyEmployeeRef = AutoDisposeFutureProviderRef<bool>;
String _$todayMonthlyAttendanceHash() =>
    r'0938a7ee95cfbdd0c3743c4e6232fc4ece8236c8';

/// 오늘 출석 정보 조회
///
/// Copied from [todayMonthlyAttendance].
@ProviderFor(todayMonthlyAttendance)
final todayMonthlyAttendanceProvider =
    AutoDisposeFutureProvider<MonthlyAttendance?>.internal(
  todayMonthlyAttendance,
  name: r'todayMonthlyAttendanceProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$todayMonthlyAttendanceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef TodayMonthlyAttendanceRef
    = AutoDisposeFutureProviderRef<MonthlyAttendance?>;
String _$monthlyAttendanceStatsHash() =>
    r'2a0f73181e698af6850b2916860193399112bf29';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

/// 월간 출석 통계 조회
///
/// Parameter: "2025-12" 형식
///
/// Copied from [monthlyAttendanceStats].
@ProviderFor(monthlyAttendanceStats)
const monthlyAttendanceStatsProvider = MonthlyAttendanceStatsFamily();

/// 월간 출석 통계 조회
///
/// Parameter: "2025-12" 형식
///
/// Copied from [monthlyAttendanceStats].
class MonthlyAttendanceStatsFamily
    extends Family<AsyncValue<MonthlyAttendanceStats?>> {
  /// 월간 출석 통계 조회
  ///
  /// Parameter: "2025-12" 형식
  ///
  /// Copied from [monthlyAttendanceStats].
  const MonthlyAttendanceStatsFamily();

  /// 월간 출석 통계 조회
  ///
  /// Parameter: "2025-12" 형식
  ///
  /// Copied from [monthlyAttendanceStats].
  MonthlyAttendanceStatsProvider call(
    String yearMonth,
  ) {
    return MonthlyAttendanceStatsProvider(
      yearMonth,
    );
  }

  @override
  MonthlyAttendanceStatsProvider getProviderOverride(
    covariant MonthlyAttendanceStatsProvider provider,
  ) {
    return call(
      provider.yearMonth,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'monthlyAttendanceStatsProvider';
}

/// 월간 출석 통계 조회
///
/// Parameter: "2025-12" 형식
///
/// Copied from [monthlyAttendanceStats].
class MonthlyAttendanceStatsProvider
    extends AutoDisposeFutureProvider<MonthlyAttendanceStats?> {
  /// 월간 출석 통계 조회
  ///
  /// Parameter: "2025-12" 형식
  ///
  /// Copied from [monthlyAttendanceStats].
  MonthlyAttendanceStatsProvider(
    String yearMonth,
  ) : this._internal(
          (ref) => monthlyAttendanceStats(
            ref as MonthlyAttendanceStatsRef,
            yearMonth,
          ),
          from: monthlyAttendanceStatsProvider,
          name: r'monthlyAttendanceStatsProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$monthlyAttendanceStatsHash,
          dependencies: MonthlyAttendanceStatsFamily._dependencies,
          allTransitiveDependencies:
              MonthlyAttendanceStatsFamily._allTransitiveDependencies,
          yearMonth: yearMonth,
        );

  MonthlyAttendanceStatsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.yearMonth,
  }) : super.internal();

  final String yearMonth;

  @override
  Override overrideWith(
    FutureOr<MonthlyAttendanceStats?> Function(
            MonthlyAttendanceStatsRef provider)
        create,
  ) {
    return ProviderOverride(
      origin: this,
      override: MonthlyAttendanceStatsProvider._internal(
        (ref) => create(ref as MonthlyAttendanceStatsRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        yearMonth: yearMonth,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<MonthlyAttendanceStats?> createElement() {
    return _MonthlyAttendanceStatsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is MonthlyAttendanceStatsProvider &&
        other.yearMonth == yearMonth;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, yearMonth.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin MonthlyAttendanceStatsRef
    on AutoDisposeFutureProviderRef<MonthlyAttendanceStats?> {
  /// The parameter `yearMonth` of this provider.
  String get yearMonth;
}

class _MonthlyAttendanceStatsProviderElement
    extends AutoDisposeFutureProviderElement<MonthlyAttendanceStats?>
    with MonthlyAttendanceStatsRef {
  _MonthlyAttendanceStatsProviderElement(super.provider);

  @override
  String get yearMonth => (origin as MonthlyAttendanceStatsProvider).yearMonth;
}

String _$currentMonthlyStatsHash() =>
    r'248998a30331038393d8c613cf8ae368c528627e';

/// 현재 월 출석 통계 조회 (간편 버전)
///
/// Copied from [currentMonthlyStats].
@ProviderFor(currentMonthlyStats)
final currentMonthlyStatsProvider =
    AutoDisposeFutureProvider<MonthlyAttendanceStats?>.internal(
  currentMonthlyStats,
  name: r'currentMonthlyStatsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$currentMonthlyStatsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef CurrentMonthlyStatsRef
    = AutoDisposeFutureProviderRef<MonthlyAttendanceStats?>;
String _$monthlyAttendanceListHash() =>
    r'015d869ca040122eccc65a68320b19769f93d2dd';

/// 월간 출석 목록 조회 (캘린더용)
///
/// Parameter: "2025-12" 형식
///
/// Copied from [monthlyAttendanceList].
@ProviderFor(monthlyAttendanceList)
const monthlyAttendanceListProvider = MonthlyAttendanceListFamily();

/// 월간 출석 목록 조회 (캘린더용)
///
/// Parameter: "2025-12" 형식
///
/// Copied from [monthlyAttendanceList].
class MonthlyAttendanceListFamily
    extends Family<AsyncValue<List<MonthlyAttendance>>> {
  /// 월간 출석 목록 조회 (캘린더용)
  ///
  /// Parameter: "2025-12" 형식
  ///
  /// Copied from [monthlyAttendanceList].
  const MonthlyAttendanceListFamily();

  /// 월간 출석 목록 조회 (캘린더용)
  ///
  /// Parameter: "2025-12" 형식
  ///
  /// Copied from [monthlyAttendanceList].
  MonthlyAttendanceListProvider call(
    String yearMonth,
  ) {
    return MonthlyAttendanceListProvider(
      yearMonth,
    );
  }

  @override
  MonthlyAttendanceListProvider getProviderOverride(
    covariant MonthlyAttendanceListProvider provider,
  ) {
    return call(
      provider.yearMonth,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'monthlyAttendanceListProvider';
}

/// 월간 출석 목록 조회 (캘린더용)
///
/// Parameter: "2025-12" 형식
///
/// Copied from [monthlyAttendanceList].
class MonthlyAttendanceListProvider
    extends AutoDisposeFutureProvider<List<MonthlyAttendance>> {
  /// 월간 출석 목록 조회 (캘린더용)
  ///
  /// Parameter: "2025-12" 형식
  ///
  /// Copied from [monthlyAttendanceList].
  MonthlyAttendanceListProvider(
    String yearMonth,
  ) : this._internal(
          (ref) => monthlyAttendanceList(
            ref as MonthlyAttendanceListRef,
            yearMonth,
          ),
          from: monthlyAttendanceListProvider,
          name: r'monthlyAttendanceListProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$monthlyAttendanceListHash,
          dependencies: MonthlyAttendanceListFamily._dependencies,
          allTransitiveDependencies:
              MonthlyAttendanceListFamily._allTransitiveDependencies,
          yearMonth: yearMonth,
        );

  MonthlyAttendanceListProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.yearMonth,
  }) : super.internal();

  final String yearMonth;

  @override
  Override overrideWith(
    FutureOr<List<MonthlyAttendance>> Function(
            MonthlyAttendanceListRef provider)
        create,
  ) {
    return ProviderOverride(
      origin: this,
      override: MonthlyAttendanceListProvider._internal(
        (ref) => create(ref as MonthlyAttendanceListRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        yearMonth: yearMonth,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<MonthlyAttendance>> createElement() {
    return _MonthlyAttendanceListProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is MonthlyAttendanceListProvider &&
        other.yearMonth == yearMonth;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, yearMonth.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin MonthlyAttendanceListRef
    on AutoDisposeFutureProviderRef<List<MonthlyAttendance>> {
  /// The parameter `yearMonth` of this provider.
  String get yearMonth;
}

class _MonthlyAttendanceListProviderElement
    extends AutoDisposeFutureProviderElement<List<MonthlyAttendance>>
    with MonthlyAttendanceListRef {
  _MonthlyAttendanceListProviderElement(super.provider);

  @override
  String get yearMonth => (origin as MonthlyAttendanceListProvider).yearMonth;
}

String _$monthlyCheckNotifierHash() =>
    r'e2998906eea22e28236cf3155798c33f7936948e';

/// Monthly 체크인/체크아웃 Notifier
///
/// 사용법:
/// ```dart
/// final notifier = ref.read(monthlyCheckNotifierProvider.notifier);
/// final result = await notifier.checkIn(storeId: storeId);
/// ```
///
/// Copied from [MonthlyCheckNotifier].
@ProviderFor(MonthlyCheckNotifier)
final monthlyCheckNotifierProvider = AutoDisposeNotifierProvider<
    MonthlyCheckNotifier, AsyncValue<MonthlyCheckResult?>>.internal(
  MonthlyCheckNotifier.new,
  name: r'monthlyCheckNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$monthlyCheckNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$MonthlyCheckNotifier
    = AutoDisposeNotifier<AsyncValue<MonthlyCheckResult?>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
