import '../entities/shift_metadata.dart';
import '../repositories/time_table_repository.dart';
import 'base_usecase.dart';

/// Get Shift Metadata UseCase
///
/// Retrieves shift metadata for a store including available tags and settings.
class GetShiftMetadata implements UseCase<ShiftMetadata, GetShiftMetadataParams> {
  final TimeTableRepository _repository;

  GetShiftMetadata(this._repository);

  @override
  Future<ShiftMetadata> call(GetShiftMetadataParams params) async {
    return await _repository.getShiftMetadata(
      storeId: params.storeId,
      timezone: params.timezone,
    );
  }
}

/// Parameters for GetShiftMetadata UseCase
class GetShiftMetadataParams {
  final String storeId;
  final String timezone;

  const GetShiftMetadataParams({
    required this.storeId,
    required this.timezone,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is GetShiftMetadataParams &&
        other.storeId == storeId &&
        other.timezone == timezone;
  }

  @override
  int get hashCode => storeId.hashCode ^ timezone.hashCode;
}
