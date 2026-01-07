import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../domain/entities/analytics_entities.dart';
import '../../domain/exceptions/analytics_exceptions.dart';
import '../../domain/repositories/inventory_analytics_repository.dart';
import '../datasources/inventory_analytics_datasource.dart';

/// Inventory Analytics Repository Implementation
///
/// Domain Layer의 Repository Interface를 구현하며,
/// Data Layer의 Datasource를 통해 실제 데이터를 가져옵니다.
class InventoryAnalyticsRepositoryImpl implements InventoryAnalyticsRepository {
  final InventoryAnalyticsDatasource _datasource;

  InventoryAnalyticsRepositoryImpl(this._datasource);

  @override
  Future<Either<Failure, SalesDashboard>> getSalesDashboard({
    required String companyId,
    String? storeId,
  }) async {
    try {
      final model = await _datasource.getSalesDashboard(
        companyId: companyId,
        storeId: storeId,
      );
      return Right(model.toEntity());
    } on AnalyticsConnectionException catch (e) {
      return Left(ServerFailure(message: e.message, code: 'NETWORK_ERROR'));
    } on AnalyticsException catch (e) {
      return Left(ServerFailure(message: e.message, code: 'INVENTORY_ERROR'));
    } catch (e) {
      return Left(ServerFailure(message: 'Unexpected error: $e', code: 'UNKNOWN_ERROR'));
    }
  }

  @override
  Future<Either<Failure, BcgMatrix>> getBcgMatrix({
    required String companyId,
    DateTime? month,
    String? storeId,
  }) async {
    try {
      final model = await _datasource.getBcgMatrix(
        companyId: companyId,
        month: month,
        storeId: storeId,
      );
      return Right(model.toEntity());
    } on AnalyticsConnectionException catch (e) {
      return Left(ServerFailure(message: e.message, code: 'NETWORK_ERROR'));
    } on AnalyticsException catch (e) {
      return Left(ServerFailure(message: e.message, code: 'INVENTORY_ERROR'));
    } catch (e) {
      return Left(ServerFailure(message: 'Unexpected error: $e', code: 'UNKNOWN_ERROR'));
    }
  }

  @override
  Future<Either<Failure, CategoryDetail>> getCategoryDetail({
    required String companyId,
    required String categoryId,
    DateTime? month,
  }) async {
    try {
      final model = await _datasource.getCategoryDetail(
        companyId: companyId,
        categoryId: categoryId,
        month: month,
      );
      return Right(model.toEntity());
    } on AnalyticsConnectionException catch (e) {
      return Left(ServerFailure(message: e.message, code: 'NETWORK_ERROR'));
    } on AnalyticsException catch (e) {
      return Left(ServerFailure(message: e.message, code: 'INVENTORY_ERROR'));
    } catch (e) {
      return Left(ServerFailure(message: 'Unexpected error: $e', code: 'UNKNOWN_ERROR'));
    }
  }

  @override
  Future<Either<Failure, SupplyChainStatus>> getSupplyChainStatus({
    required String companyId,
  }) async {
    try {
      final model = await _datasource.getSupplyChainStatus(
        companyId: companyId,
      );
      return Right(model.toEntity());
    } on AnalyticsConnectionException catch (e) {
      return Left(ServerFailure(message: e.message, code: 'NETWORK_ERROR'));
    } on AnalyticsException catch (e) {
      return Left(ServerFailure(message: e.message, code: 'INVENTORY_ERROR'));
    } catch (e) {
      return Left(ServerFailure(message: 'Unexpected error: $e', code: 'UNKNOWN_ERROR'));
    }
  }

  @override
  Future<Either<Failure, DiscrepancyOverview>> getDiscrepancyOverview({
    required String companyId,
    String? period,
  }) async {
    try {
      final model = await _datasource.getDiscrepancyOverview(
        companyId: companyId,
        period: period,
      );
      return Right(model.toEntity());
    } on AnalyticsConnectionException catch (e) {
      return Left(ServerFailure(message: e.message, code: 'NETWORK_ERROR'));
    } on AnalyticsException catch (e) {
      return Left(ServerFailure(message: e.message, code: 'INVENTORY_ERROR'));
    } catch (e) {
      return Left(ServerFailure(message: 'Unexpected error: $e', code: 'UNKNOWN_ERROR'));
    }
  }

  @override
  Future<Either<Failure, InventoryOptimization>> getInventoryOptimizationDashboard({
    required String companyId,
  }) async {
    try {
      final model = await _datasource.getInventoryOptimizationDashboard(
        companyId: companyId,
      );
      return Right(model.toEntity());
    } on AnalyticsConnectionException catch (e) {
      return Left(ServerFailure(message: e.message, code: 'NETWORK_ERROR'));
    } on AnalyticsException catch (e) {
      return Left(ServerFailure(message: e.message, code: 'INVENTORY_ERROR'));
    } catch (e) {
      return Left(ServerFailure(message: 'Unexpected error: $e', code: 'UNKNOWN_ERROR'));
    }
  }

  @override
  Future<Either<Failure, List<ReorderProduct>>> getReorderList({
    required String companyId,
    String? priority,
    int? limit,
  }) async {
    try {
      final models = await _datasource.getReorderList(
        companyId: companyId,
        priority: priority,
        limit: limit,
      );
      return Right(models.map((m) => m.toEntity()).toList());
    } on AnalyticsConnectionException catch (e) {
      return Left(ServerFailure(message: e.message, code: 'NETWORK_ERROR'));
    } on AnalyticsException catch (e) {
      return Left(ServerFailure(message: e.message, code: 'INVENTORY_ERROR'));
    } catch (e) {
      return Left(ServerFailure(message: 'Unexpected error: $e', code: 'UNKNOWN_ERROR'));
    }
  }

  @override
  Future<Either<Failure, AnalyticsHubData>> getHubData({
    required String companyId,
    String? storeId,
  }) async {
    try {
      // 4개의 RPC를 병렬로 호출
      final results = await Future.wait([
        _safeFetch(() => _datasource.getSalesDashboard(
              companyId: companyId,
              storeId: storeId,
            )),
        _safeFetch(() => _datasource.getInventoryOptimizationDashboard(
              companyId: companyId,
            )),
        _safeFetch(() => _datasource.getSupplyChainStatus(
              companyId: companyId,
            )),
        _safeFetch(() => _datasource.getDiscrepancyOverview(
              companyId: companyId,
            )),
      ]);

      final salesDashboard = results[0] as dynamic;
      final optimization = results[1] as dynamic;
      final supplyChain = results[2] as dynamic;
      final discrepancy = results[3] as dynamic;

      return Right(AnalyticsHubData(
        salesDashboard: salesDashboard?.toEntity(),
        inventoryOptimization: optimization?.toEntity(),
        supplyChainStatus: supplyChain?.toEntity(),
        discrepancyOverview: discrepancy?.toEntity(),
      ));
    } on AnalyticsConnectionException catch (e) {
      return Left(ServerFailure(message: e.message, code: 'NETWORK_ERROR'));
    } on AnalyticsException catch (e) {
      return Left(ServerFailure(message: e.message, code: 'INVENTORY_ERROR'));
    } catch (e) {
      return Left(ServerFailure(message: 'Unexpected error: $e', code: 'UNKNOWN_ERROR'));
    }
  }

  /// 개별 RPC 호출 실패를 null로 처리하는 헬퍼
  Future<T?> _safeFetch<T>(Future<T> Function() fetch) async {
    try {
      return await fetch();
    } catch (_) {
      return null;
    }
  }
}
