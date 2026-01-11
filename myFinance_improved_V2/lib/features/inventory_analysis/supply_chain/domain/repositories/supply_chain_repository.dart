import 'package:dartz/dartz.dart';

import '../../../../../core/errors/failures.dart';
import '../entities/supply_chain_status.dart';

/// Supply Chain Repository Interface
///
/// Clean Architecture의 Domain Layer에 위치하며,
/// 공급망 분석 관련 데이터 조회를 담당합니다.
abstract class SupplyChainRepository {
  /// 공급망 상태 데이터 조회
  /// RPC: get_supply_chain_status
  ///
  /// [companyId] 회사 ID (필수)
  Future<Either<Failure, SupplyChainStatus>> getSupplyChainStatus({
    required String companyId,
  });
}
