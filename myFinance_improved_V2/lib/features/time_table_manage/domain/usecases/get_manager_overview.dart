import 'package:freezed_annotation/freezed_annotation.dart';

import '../entities/manager_overview.dart';
import '../repositories/time_table_repository.dart';
import 'base_usecase.dart';

part 'get_manager_overview.freezed.dart';

/// Get Manager Overview UseCase
///
/// Retrieves manager overview statistics for a date range.
class GetManagerOverview
    implements UseCase<ManagerOverview, GetManagerOverviewParams> {
  final TimeTableRepository _repository;

  GetManagerOverview(this._repository);

  @override
  Future<ManagerOverview> call(GetManagerOverviewParams params) async {
    return await _repository.getManagerOverview(
      startDate: params.startDate,
      endDate: params.endDate,
      companyId: params.companyId,
      storeId: params.storeId,
    );
  }
}

/// Parameters for GetManagerOverview UseCase
@freezed
class GetManagerOverviewParams with _$GetManagerOverviewParams {
  const factory GetManagerOverviewParams({
    required String startDate,
    required String endDate,
    required String companyId,
    required String storeId,
  }) = _GetManagerOverviewParams;
}
