import 'package:freezed_annotation/freezed_annotation.dart';

import '../entities/schedule_data.dart';
import '../repositories/time_table_repository.dart';
import 'base_usecase.dart';

part 'get_schedule_data.freezed.dart';

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
@freezed
class GetScheduleDataParams with _$GetScheduleDataParams {
  const factory GetScheduleDataParams({
    required String storeId,
  }) = _GetScheduleDataParams;
}
