import 'package:dartz/dartz.dart';

import '../../../../../core/errors/failures.dart';
import '../entities/discrepancy_overview.dart';

/// Discrepancy Analytics Repository Interface
///
/// Clean Architecture's Domain Layer interface for
/// inventory discrepancy analysis data retrieval.
abstract class DiscrepancyRepository {
  /// Get discrepancy overview data
  /// RPC: get_discrepancy_overview
  ///
  /// [companyId] Company ID (required)
  /// [period] Period filter ('7d', '30d', 'all') (optional)
  Future<Either<Failure, DiscrepancyOverview>> getDiscrepancyOverview({
    required String companyId,
    String? period,
  });
}
