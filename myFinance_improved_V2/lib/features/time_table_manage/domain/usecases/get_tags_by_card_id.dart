import 'package:freezed_annotation/freezed_annotation.dart';

import '../entities/tag.dart';
import '../repositories/time_table_repository.dart';
import 'base_usecase.dart';

part 'get_tags_by_card_id.freezed.dart';

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
@freezed
class GetTagsByCardIdParams with _$GetTagsByCardIdParams {
  const factory GetTagsByCardIdParams({
    required String cardId,
  }) = _GetTagsByCardIdParams;
}
