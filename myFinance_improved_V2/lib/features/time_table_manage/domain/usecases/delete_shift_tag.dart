import '../entities/operation_result.dart';
import '../repositories/time_table_repository.dart';
import 'base_usecase.dart';

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
class DeleteShiftTagParams {
  final String tagId;
  final String userId;

  const DeleteShiftTagParams({
    required this.tagId,
    required this.userId,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is DeleteShiftTagParams &&
        other.tagId == tagId &&
        other.userId == userId;
  }

  @override
  int get hashCode => tagId.hashCode ^ userId.hashCode;
}
