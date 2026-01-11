import 'package:dartz/dartz.dart';

import '../../../../../core/errors/failures.dart';
import '../../domain/entities/inventory_optimization.dart';
import '../../domain/repositories/optimization_repository.dart';
import '../datasources/optimization_datasource.dart';

/// Optimization Repository Implementation
class OptimizationRepositoryImpl implements OptimizationRepository {
  final OptimizationDatasource _datasource;

  OptimizationRepositoryImpl(this._datasource);

  @override
  Future<Either<Failure, InventoryOptimization>> getInventoryOptimizationDashboard({
    required String companyId,
  }) async {
    try {
      final model = await _datasource.getInventoryOptimizationDashboard(
        companyId: companyId,
      );
      return Right(model.toEntity());
    } catch (e) {
      return Left(ServerFailure(message: e.toString(), code: 'OPTIMIZATION_DASHBOARD_ERROR'));
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
    } catch (e) {
      return Left(ServerFailure(message: e.toString(), code: 'REORDER_LIST_ERROR'));
    }
  }
}
