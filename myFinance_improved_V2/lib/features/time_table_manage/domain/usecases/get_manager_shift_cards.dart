import 'package:freezed_annotation/freezed_annotation.dart';

import '../entities/manager_shift_cards.dart';
import '../repositories/time_table_repository.dart';
import 'base_usecase.dart';

part 'get_manager_shift_cards.freezed.dart';

/// Get Manager Shift Cards UseCase
///
/// Retrieves shift cards for manager employee view.
class GetManagerShiftCards
    implements UseCase<ManagerShiftCards, GetManagerShiftCardsParams> {
  final TimeTableRepository _repository;

  GetManagerShiftCards(this._repository);

  @override
  Future<ManagerShiftCards> call(GetManagerShiftCardsParams params) async {
    return await _repository.getManagerShiftCards(
      startDate: params.startDate,
      endDate: params.endDate,
      companyId: params.companyId,
      storeId: params.storeId,
    );
  }
}

/// Parameters for GetManagerShiftCards UseCase
@freezed
class GetManagerShiftCardsParams with _$GetManagerShiftCardsParams {
  const factory GetManagerShiftCardsParams({
    required String startDate,
    required String endDate,
    required String companyId,
    required String storeId,
  }) = _GetManagerShiftCardsParams;
}
