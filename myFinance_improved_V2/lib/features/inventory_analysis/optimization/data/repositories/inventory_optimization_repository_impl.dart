import 'package:dartz/dartz.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../../core/errors/failures.dart';
import '../../domain/entities/category_summary.dart';
import '../../domain/entities/inventory_dashboard.dart';
import '../../domain/entities/inventory_health_dashboard.dart';
import '../../domain/entities/paginated_products.dart';
import '../../domain/repositories/inventory_optimization_repository.dart';
import '../datasources/inventory_optimization_datasource.dart';

/// Inventory Optimization Repository Implementation
/// Either<Failure, T> 패턴으로 에러 처리
class InventoryOptimizationRepositoryImpl
    implements InventoryOptimizationRepository {
  final InventoryOptimizationDatasource _datasource;

  InventoryOptimizationRepositoryImpl(this._datasource);

  @override
  Future<Either<Failure, InventoryDashboard>> getDashboard({
    required String companyId,
  }) async {
    try {
      final dto = await _datasource.getDashboard(companyId: companyId);
      return Right(dto.toEntity());
    } on PostgrestException catch (e) {
      return Left(ServerFailure(
        message: e.message,
        code: e.code ?? 'DASHBOARD_ERROR',
      ));
    } catch (e) {
      return Left(ServerFailure(
        message: e.toString(),
        code: 'DASHBOARD_ERROR',
      ));
    }
  }

  @override
  Future<Either<Failure, List<CategorySummary>>> getCategorySummaries({
    required String companyId,
  }) async {
    try {
      final dtos = await _datasource.getCategorySummaries(companyId: companyId);
      return Right(dtos.map((e) => e.toEntity()).toList());
    } on PostgrestException catch (e) {
      return Left(ServerFailure(
        message: e.message,
        code: e.code ?? 'CATEGORY_ERROR',
      ));
    } catch (e) {
      return Left(ServerFailure(
        message: e.toString(),
        code: 'CATEGORY_ERROR',
      ));
    }
  }

  @override
  Future<Either<Failure, PaginatedProducts>> getProductsPaged({
    required String companyId,
    String? categoryId,
    String? statusFilter,
    int page = 0,
    int pageSize = 20,
  }) async {
    try {
      final dto = await _datasource.getProductsPaged(
        companyId: companyId,
        categoryId: categoryId,
        statusFilter: statusFilter,
        page: page,
        pageSize: pageSize,
      );
      return Right(dto.toEntity());
    } on PostgrestException catch (e) {
      return Left(ServerFailure(
        message: e.message,
        code: e.code ?? 'PRODUCTS_ERROR',
      ));
    } catch (e) {
      return Left(ServerFailure(
        message: e.toString(),
        code: 'PRODUCTS_ERROR',
      ));
    }
  }

  @override
  Future<Either<Failure, void>> refreshViews() async {
    try {
      await _datasource.refreshViews();
      return const Right(null);
    } on PostgrestException catch (e) {
      return Left(ServerFailure(
        message: e.message,
        code: e.code ?? 'REFRESH_ERROR',
      ));
    } catch (e) {
      return Left(ServerFailure(
        message: e.toString(),
        code: 'REFRESH_ERROR',
      ));
    }
  }

  @override
  Future<Either<Failure, InventoryHealthDashboard>> getHealthDashboard({
    required String companyId,
    String? storeId,
    double urgentThreshold = 1.0,
    int limit = 10,
  }) async {
    try {
      final dto = await _datasource.getHealthDashboard(
        companyId: companyId,
        storeId: storeId,
        urgentThreshold: urgentThreshold,
        limit: limit,
      );
      return Right(dto.toEntity());
    } on PostgrestException catch (e) {
      return Left(ServerFailure(
        message: e.message,
        code: e.code ?? 'HEALTH_DASHBOARD_ERROR',
      ));
    } catch (e) {
      return Left(ServerFailure(
        message: e.toString(),
        code: 'HEALTH_DASHBOARD_ERROR',
      ));
    }
  }
}
