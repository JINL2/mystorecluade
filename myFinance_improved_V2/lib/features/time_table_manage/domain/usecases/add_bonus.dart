import 'package:freezed_annotation/freezed_annotation.dart';

import '../entities/operation_result.dart';
import '../repositories/time_table_repository.dart';
import 'base_usecase.dart';

part 'add_bonus.freezed.dart';

/// Add Bonus UseCase
///
/// Adds a bonus to a shift request with amount and reason.
class AddBonus implements UseCase<OperationResult, AddBonusParams> {
  final TimeTableRepository _repository;

  AddBonus(this._repository);

  @override
  Future<OperationResult> call(AddBonusParams params) async {
    if (params.shiftRequestId.isEmpty) {
      throw ArgumentError('Shift request ID cannot be empty');
    }

    if (params.bonusAmount <= 0) {
      throw ArgumentError('Bonus amount must be greater than 0');
    }

    if (params.bonusReason.isEmpty) {
      throw ArgumentError('Bonus reason cannot be empty');
    }

    return await _repository.addBonus(
      shiftRequestId: params.shiftRequestId,
      bonusAmount: params.bonusAmount,
      bonusReason: params.bonusReason,
    );
  }
}

/// Parameters for AddBonus UseCase
@freezed
class AddBonusParams with _$AddBonusParams {
  const factory AddBonusParams({
    required String shiftRequestId,
    required double bonusAmount,
    required String bonusReason,
  }) = _AddBonusParams;
}
