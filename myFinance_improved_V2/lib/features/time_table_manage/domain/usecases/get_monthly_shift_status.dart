import '../entities/monthly_shift_status.dart';
import '../repositories/time_table_repository.dart';
import 'base_usecase.dart';

/// Get Monthly Shift Status UseCase
///
/// Retrieves monthly shift status for manager view.
/// Matches RPC: get_monthly_shift_status_manager_v4
class GetMonthlyShiftStatus
    implements UseCase<List<MonthlyShiftStatus>, GetMonthlyShiftStatusParams> {
  final TimeTableRepository _repository;

  GetMonthlyShiftStatus(this._repository);

  @override
  Future<List<MonthlyShiftStatus>> call(
      GetMonthlyShiftStatusParams params,) async {
    return await _repository.getMonthlyShiftStatus(
      requestTime: params.requestTime,
      companyId: params.companyId,
      storeId: params.storeId,
      timezone: params.timezone,
    );
  }
}

/// Parameters for GetMonthlyShiftStatus UseCase
class GetMonthlyShiftStatusParams {
  final String requestTime;
  final String companyId;
  final String storeId;
  final String timezone;

  const GetMonthlyShiftStatusParams({
    required this.requestTime,
    required this.companyId,
    required this.storeId,
    required this.timezone,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is GetMonthlyShiftStatusParams &&
        other.requestTime == requestTime &&
        other.companyId == companyId &&
        other.storeId == storeId &&
        other.timezone == timezone;
  }

  @override
  int get hashCode =>
      requestTime.hashCode ^ companyId.hashCode ^ storeId.hashCode ^ timezone.hashCode;
}
