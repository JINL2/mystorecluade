import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/services/supabase_service.dart';
import '../../data/datasources/store_shift_data_source.dart';
import '../../data/repositories/store_shift_repository_impl.dart';
import '../../domain/repositories/store_shift_repository.dart';

/// ========================================
/// Store Shift Feature DI Providers
/// ========================================
///
/// Clean Architecture DI 구성:
/// - Presentation 레이어에서 DI 관리 (Riverpod이 DI 역할)
/// - Domain은 인터페이스만 정의
/// - Data는 구현체만 제공
///
/// 의존성 흐름:
/// DataSource → Repository Impl → Repository Interface (Domain)
///                                       ↑
///                              Presentation에서 사용

/// DataSource Provider (내부용)
///
/// Supabase 서비스를 주입받아 DataSource 생성
final _storeShiftDataSourceProvider = Provider<StoreShiftDataSource>((ref) {
  final supabaseService = ref.watch(supabaseServiceProvider);
  return StoreShiftDataSource(supabaseService);
});

/// Repository Provider
///
/// Domain의 StoreShiftRepository 인터페이스를 구현한 Impl을 제공
/// Presentation 레이어에서 이 provider를 통해 Repository 접근
///
/// 사용 예:
/// ```dart
/// final repository = ref.watch(storeShiftRepositoryProvider);
/// final shifts = await repository.getShiftsByStoreId(storeId);
/// ```
final storeShiftRepositoryProvider = Provider<StoreShiftRepository>((ref) {
  final dataSource = ref.watch(_storeShiftDataSourceProvider);
  return StoreShiftRepositoryImpl(dataSource);
});
