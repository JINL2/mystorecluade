import 'package:dartz/dartz.dart';

import '../../../../../core/errors/failures.dart';
import '../entities/analytics_hub.dart';

/// Hub Repository Interface
///
/// Clean Architecture의 Domain Layer에 위치하며,
/// 4개의 분석 시스템 데이터를 통합 조회합니다.
abstract class HubRepository {
  /// Hub 통합 데이터 조회
  /// 4개의 분석 시스템 결과를 병렬로 조회하여 결합
  ///
  /// [companyId] 회사 ID (필수)
  /// [storeId] 매장 ID (선택)
  Future<Either<Failure, AnalyticsHubData>> getHubData({
    required String companyId,
    String? storeId,
  });
}
