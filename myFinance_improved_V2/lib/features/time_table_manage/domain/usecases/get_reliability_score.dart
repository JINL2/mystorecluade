import '../entities/reliability_score.dart';
import '../repositories/time_table_repository.dart';
import 'base_usecase.dart';

/// Get Reliability Score UseCase
///
/// Retrieves store health metrics for the stats tab.
class GetReliabilityScore
    implements UseCase<ReliabilityScore, GetReliabilityScoreParams> {
  final TimeTableRepository _repository;

  GetReliabilityScore(this._repository);

  @override
  Future<ReliabilityScore> call(GetReliabilityScoreParams params) async {
    return await _repository.getReliabilityScore(
      companyId: params.companyId,
      storeId: params.storeId,
      time: params.time,
      timezone: params.timezone,
    );
  }
}

/// Parameters for GetReliabilityScore UseCase
class GetReliabilityScoreParams {
  final String companyId;
  final String storeId;
  final String time;
  final String timezone;

  const GetReliabilityScoreParams({
    required this.companyId,
    required this.storeId,
    required this.time,
    required this.timezone,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is GetReliabilityScoreParams &&
        other.companyId == companyId &&
        other.storeId == storeId &&
        other.time == time &&
        other.timezone == timezone;
  }

  @override
  int get hashCode =>
      companyId.hashCode ^ storeId.hashCode ^ time.hashCode ^ timezone.hashCode;
}
