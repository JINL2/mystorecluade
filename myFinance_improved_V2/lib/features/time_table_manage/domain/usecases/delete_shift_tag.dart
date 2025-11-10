import 'package:freezed_annotation/freezed_annotation.dart';

import '../entities/operation_result.dart';
import '../repositories/time_table_repository.dart';
import 'base_usecase.dart';

part 'delete_shift_tag.freezed.dart';

/// Delete Shift Tag UseCase
///
/// Deletes a shift tag by its ID.
class DeleteShiftTag implements UseCase<OperationResult, DeleteShiftTagParams> {
  final TimeTableRepository _repository;

  DeleteShiftTag(this._repository);

  @override
  Future<OperationResult> call(DeleteShiftTagParams params) async {
    if (params.tagId.isEmpty) {
      throw ArgumentError('Tag ID cannot be empty');
    }

    if (params.userId.isEmpty) {
      throw ArgumentError('User ID cannot be empty');
    }

    return await _repository.deleteShiftTag(
      tagId: params.tagId,
      userId: params.userId,
    );
  }
}

/// Parameters for DeleteShiftTag UseCase
@freezed
class DeleteShiftTagParams with _$DeleteShiftTagParams {
  const factory DeleteShiftTagParams({
    required String tagId,
    required String userId,
  }) = _DeleteShiftTagParams;
}
