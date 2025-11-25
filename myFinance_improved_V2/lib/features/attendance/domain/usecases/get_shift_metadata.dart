import '../entities/shift_metadata.dart';
import '../repositories/attendance_repository.dart';

/// Get shift metadata for a store
///
/// Matches RPC: get_shift_metadata_v2
class GetShiftMetadata {
  final AttendanceRepository _repository;

  GetShiftMetadata(this._repository);

  Future<List<ShiftMetadata>> call({
    required String storeId,
    required String timezone,
  }) {
    return _repository.getShiftMetadata(
      storeId: storeId,
      timezone: timezone,
    );
  }
}
