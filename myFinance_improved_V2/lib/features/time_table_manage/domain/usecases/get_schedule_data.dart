import '../entities/schedule_data.dart';
import '../repositories/time_table_repository.dart';
import 'base_usecase.dart';

/// Get Schedule Data UseCase
///
/// Retrieves complete schedule data (employees and shifts) for a store.
class GetScheduleData implements UseCase<ScheduleData, GetScheduleDataParams> {
  final TimeTableRepository _repository;

  GetScheduleData(this._repository);

  @override
  Future<ScheduleData> call(GetScheduleDataParams params) async {
    if (params.storeId.isEmpty) {
      throw ArgumentError('Store ID cannot be empty');
    }

    return await _repository.getScheduleData(storeId: params.storeId);
  }
}

/// Parameters for GetScheduleData UseCase
class GetScheduleDataParams {
  final String storeId;

  const GetScheduleDataParams({
    required this.storeId,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is GetScheduleDataParams && other.storeId == storeId;
  }

  @override
  int get hashCode => storeId.hashCode;
}
