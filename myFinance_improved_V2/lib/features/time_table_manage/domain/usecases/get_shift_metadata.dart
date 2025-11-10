import 'package:freezed_annotation/freezed_annotation.dart';

import '../entities/shift_metadata.dart';
import '../repositories/time_table_repository.dart';
import 'base_usecase.dart';

part 'get_shift_metadata.freezed.dart';

/// Get Shift Metadata UseCase
///
/// Retrieves shift metadata for a store including available tags and settings.
class GetShiftMetadata implements UseCase<ShiftMetadata, GetShiftMetadataParams> {
  final TimeTableRepository _repository;

  GetShiftMetadata(this._repository);

  @override
  Future<ShiftMetadata> call(GetShiftMetadataParams params) async {
    return await _repository.getShiftMetadata(storeId: params.storeId);
  }
}

/// Parameters for GetShiftMetadata UseCase
@freezed
class GetShiftMetadataParams with _$GetShiftMetadataParams {
  const factory GetShiftMetadataParams({
    required String storeId,
  }) = _GetShiftMetadataParams;
}
