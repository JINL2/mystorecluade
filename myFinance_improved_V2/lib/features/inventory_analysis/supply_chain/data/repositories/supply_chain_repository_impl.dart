import 'package:dartz/dartz.dart';

import '../../../../../core/errors/failures.dart';
import '../../domain/entities/supply_chain_status.dart';
import '../../domain/repositories/supply_chain_repository.dart';
import '../datasources/supply_chain_datasource.dart';

/// Supply Chain Repository Implementation
class SupplyChainRepositoryImpl implements SupplyChainRepository {
  final SupplyChainDatasource _datasource;

  SupplyChainRepositoryImpl(this._datasource);

  @override
  Future<Either<Failure, SupplyChainStatus>> getSupplyChainStatus({
    required String companyId,
  }) async {
    try {
      final model = await _datasource.getSupplyChainStatus(
        companyId: companyId,
      );
      return Right(model.toEntity());
    } catch (e) {
      return Left(ServerFailure(message: e.toString(), code: 'SUPPLY_CHAIN_STATUS_ERROR'));
    }
  }
}
