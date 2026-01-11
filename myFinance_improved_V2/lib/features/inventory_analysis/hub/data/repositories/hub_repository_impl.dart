import 'package:dartz/dartz.dart';

import '../../../../../core/errors/failures.dart';
import '../../../discrepancy/domain/repositories/discrepancy_repository.dart';
import '../../../optimization/domain/repositories/optimization_repository.dart';
import '../../../sales/domain/repositories/sales_repository.dart';
import '../../../supply_chain/domain/repositories/supply_chain_repository.dart';
import '../../domain/entities/analytics_hub.dart';
import '../../domain/repositories/hub_repository.dart';

/// Hub Repository Implementation
///
/// 4개의 분석 시스템 repository를 조합하여 Hub 데이터를 제공합니다.
class HubRepositoryImpl implements HubRepository {
  final SalesRepository _salesRepository;
  final OptimizationRepository _optimizationRepository;
  final SupplyChainRepository _supplyChainRepository;
  final DiscrepancyRepository _discrepancyRepository;

  HubRepositoryImpl({
    required SalesRepository salesRepository,
    required OptimizationRepository optimizationRepository,
    required SupplyChainRepository supplyChainRepository,
    required DiscrepancyRepository discrepancyRepository,
  })  : _salesRepository = salesRepository,
        _optimizationRepository = optimizationRepository,
        _supplyChainRepository = supplyChainRepository,
        _discrepancyRepository = discrepancyRepository;

  @override
  Future<Either<Failure, AnalyticsHubData>> getHubData({
    required String companyId,
    String? storeId,
  }) async {
    try {
      // 4개 API 병렬 호출
      final salesFuture = _salesRepository.getSalesDashboard(
        companyId: companyId,
        storeId: storeId,
      );
      final optimizationFuture = _optimizationRepository
          .getInventoryOptimizationDashboard(companyId: companyId);
      final supplyChainFuture =
          _supplyChainRepository.getSupplyChainStatus(companyId: companyId);
      final discrepancyFuture =
          _discrepancyRepository.getDiscrepancyOverview(companyId: companyId);

      // 병렬 실행 후 결과 취합
      final salesResult = await salesFuture;
      final optimizationResult = await optimizationFuture;
      final supplyChainResult = await supplyChainFuture;
      final discrepancyResult = await discrepancyFuture;

      // 결과 추출 (실패해도 null로 처리)
      final hubData = AnalyticsHubData(
        salesDashboard: salesResult.fold((_) => null, (data) => data),
        inventoryOptimization:
            optimizationResult.fold((_) => null, (data) => data),
        supplyChainStatus: supplyChainResult.fold((_) => null, (data) => data),
        discrepancyOverview:
            discrepancyResult.fold((_) => null, (data) => data),
      );

      return Right(hubData);
    } catch (e) {
      return Left(ServerFailure(
        message: e.toString(),
        code: 'HUB_DATA_ERROR',
      ),);
    }
  }
}
