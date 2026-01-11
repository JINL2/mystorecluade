import 'package:dartz/dartz.dart';

import '../../../../../core/errors/failures.dart';
import '../../domain/entities/discrepancy_overview.dart';
import '../../domain/repositories/discrepancy_repository.dart';
import '../datasources/discrepancy_datasource.dart';

/// Discrepancy Repository Implementation
class DiscrepancyRepositoryImpl implements DiscrepancyRepository {
  final DiscrepancyDatasource _datasource;

  DiscrepancyRepositoryImpl(this._datasource);

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
    } catch (e) {
      return Left(ServerFailure(
        message: e.toString(),
        code: 'DISCREPANCY_OVERVIEW_ERROR',
      ));
    }
  }
}
