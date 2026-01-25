import 'package:dartz/dartz.dart';

import '../../../../../core/errors/failures.dart';
import '../../domain/entities/sales_dashboard.dart';
import '../../domain/entities/bcg_category.dart';
import '../../domain/entities/sales_analytics.dart';
import '../../domain/repositories/sales_repository.dart';
import '../datasources/sales_datasource.dart';

/// Sales Repository Implementation
class SalesRepositoryImpl implements SalesRepository {
  final SalesDatasource _datasource;

  SalesRepositoryImpl(this._datasource);

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
    } catch (e) {
      return Left(ServerFailure(message: e.toString(), code: 'SALES_DASHBOARD_ERROR'));
    }
  }

  // ═══════════════════════════════════════════════════════════════
  // V2 Analytics Methods (2025)
  // ═══════════════════════════════════════════════════════════════

  @override
  Future<Either<Failure, SalesAnalyticsResponse>> getSalesAnalytics(
    SalesAnalyticsParams params,
  ) async {
    try {
      final dto = await _datasource.getSalesAnalytics(params);
      return Right(dto.toEntity());
    } catch (e) {
      return Left(ServerFailure(
        message: e.toString(),
        code: 'SALES_ANALYTICS_ERROR',
      ));
    }
  }

  @override
  Future<Either<Failure, DrillDownResponse>> getDrillDownAnalytics(
    DrillDownParams params,
  ) async {
    try {
      final dto = await _datasource.getDrillDownAnalytics(params);
      return Right(dto.toEntity());
    } catch (e) {
      return Left(ServerFailure(
        message: e.toString(),
        code: 'DRILL_DOWN_ERROR',
      ));
    }
  }

  @override
  Future<Either<Failure, BcgMatrix>> getBcgMatrixV2({
    required String companyId,
    required DateTime startDate,
    required DateTime endDate,
    String? storeId,
  }) async {
    try {
      final matrix = await _datasource.getBcgMatrixV2(
        companyId: companyId,
        startDate: startDate,
        endDate: endDate,
        storeId: storeId,
      );
      return Right(matrix);
    } catch (e) {
      return Left(ServerFailure(
        message: e.toString(),
        code: 'BCG_MATRIX_V2_ERROR',
      ));
    }
  }

  @override
  Future<Either<Failure, String>> getCurrencySymbol({
    required String companyId,
  }) async {
    try {
      final symbol = await _datasource.getCurrencySymbol(companyId);
      return Right(symbol);
    } catch (e) {
      return Left(ServerFailure(
        message: e.toString(),
        code: 'CURRENCY_ERROR',
      ));
    }
  }
}
