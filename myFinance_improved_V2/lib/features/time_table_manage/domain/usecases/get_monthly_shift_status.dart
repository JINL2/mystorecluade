import 'package:freezed_annotation/freezed_annotation.dart';

import '../entities/monthly_shift_status.dart';
import '../repositories/time_table_repository.dart';
import 'base_usecase.dart';

part 'get_monthly_shift_status.freezed.dart';

/// Get Monthly Shift Status UseCase
///
/// Retrieves monthly shift status for manager view.
class GetMonthlyShiftStatus
    implements UseCase<List<MonthlyShiftStatus>, GetMonthlyShiftStatusParams> {
  final TimeTableRepository _repository;

  GetMonthlyShiftStatus(this._repository);

  @override
  Future<List<MonthlyShiftStatus>> call(
      GetMonthlyShiftStatusParams params) async {
    return await _repository.getMonthlyShiftStatus(
      requestDate: params.requestDate,
      companyId: params.companyId,
      storeId: params.storeId,
    );
  }
}

/// Parameters for GetMonthlyShiftStatus UseCase
@freezed
class GetMonthlyShiftStatusParams with _$GetMonthlyShiftStatusParams {
  const factory GetMonthlyShiftStatusParams({
    required String requestDate,
    required String companyId,
    required String storeId,
  }) = _GetMonthlyShiftStatusParams;
}
