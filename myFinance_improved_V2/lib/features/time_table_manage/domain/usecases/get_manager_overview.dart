import '../entities/manager_overview.dart';
import '../repositories/time_table_repository.dart';
import 'base_usecase.dart';

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
      timezone: params.timezone,
    );
  }
}

/// Parameters for GetManagerOverview UseCase
class GetManagerOverviewParams {
  final String startDate;
  final String endDate;
  final String companyId;
  final String storeId;
  final String timezone;

  const GetManagerOverviewParams({
    required this.startDate,
    required this.endDate,
    required this.companyId,
    required this.storeId,
    required this.timezone,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is GetManagerOverviewParams &&
        other.startDate == startDate &&
        other.endDate == endDate &&
        other.companyId == companyId &&
        other.storeId == storeId &&
        other.timezone == timezone;
  }

  @override
  int get hashCode =>
      startDate.hashCode ^
      endDate.hashCode ^
      companyId.hashCode ^
      storeId.hashCode ^
      timezone.hashCode;
}
