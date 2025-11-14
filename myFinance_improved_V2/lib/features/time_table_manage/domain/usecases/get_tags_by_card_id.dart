import '../entities/tag.dart';
import '../repositories/time_table_repository.dart';
import 'base_usecase.dart';

/// Get Tags By Card ID UseCase
///
/// Retrieves all tags associated with a specific card.
class GetTagsByCardId implements UseCase<List<Tag>, GetTagsByCardIdParams> {
  final TimeTableRepository _repository;

  GetTagsByCardId(this._repository);

  @override
  Future<List<Tag>> call(GetTagsByCardIdParams params) async {
    if (params.cardId.isEmpty) {
      throw ArgumentError('Card ID cannot be empty');
    }

    return await _repository.getTagsByCardId(cardId: params.cardId);
  }
}

/// Parameters for GetTagsByCardId UseCase
class GetTagsByCardIdParams {
  final String cardId;

  const GetTagsByCardIdParams({
    required this.cardId,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is GetTagsByCardIdParams && other.cardId == cardId;
  }

  @override
  int get hashCode => cardId.hashCode;
}
