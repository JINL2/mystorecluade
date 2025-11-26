import '../entities/manager_shift_cards.dart';
import '../repositories/time_table_repository.dart';
import 'base_usecase.dart';

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
      timezone: params.timezone,
    );
  }
}

/// Parameters for GetManagerShiftCards UseCase
class GetManagerShiftCardsParams {
  final String startDate;
  final String endDate;
  final String companyId;
  final String storeId;
  final String timezone;

  const GetManagerShiftCardsParams({
    required this.startDate,
    required this.endDate,
    required this.companyId,
    required this.storeId,
    required this.timezone,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is GetManagerShiftCardsParams &&
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
