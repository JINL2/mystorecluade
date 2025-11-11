import '../entities/monthly_shift_status.dart';
import '../repositories/time_table_repository.dart';
import 'base_usecase.dart';

/// Get Monthly Shift Status UseCase
///
/// Retrieves monthly shift status for manager view.
class GetMonthlyShiftStatus
    implements UseCase<List<MonthlyShiftStatus>, GetMonthlyShiftStatusParams> {
  final TimeTableRepository _repository;

  GetMonthlyShiftStatus(this._repository);

  @override
  Future<List<MonthlyShiftStatus>> call(
      GetMonthlyShiftStatusParams params,) async {
    return await _repository.getMonthlyShiftStatus(
      requestDate: params.requestDate,
      companyId: params.companyId,
      storeId: params.storeId,
    );
  }
}

/// Parameters for GetMonthlyShiftStatus UseCase
class GetMonthlyShiftStatusParams {
  final String requestDate;
  final String companyId;
  final String storeId;

  const GetMonthlyShiftStatusParams({
    required this.requestDate,
    required this.companyId,
    required this.storeId,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is GetMonthlyShiftStatusParams &&
        other.requestDate == requestDate &&
        other.companyId == companyId &&
        other.storeId == storeId;
  }

  @override
  int get hashCode =>
      requestDate.hashCode ^ companyId.hashCode ^ storeId.hashCode;
}
