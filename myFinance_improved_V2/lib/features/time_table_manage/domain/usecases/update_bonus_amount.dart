import 'package:freezed_annotation/freezed_annotation.dart';

import '../repositories/time_table_repository.dart';
import 'base_usecase.dart';

part 'update_bonus_amount.freezed.dart';

/// Update Bonus Amount UseCase
///
/// Updates the bonus amount for a shift request.
class UpdateBonusAmount implements UseCase<void, UpdateBonusAmountParams> {
  final TimeTableRepository _repository;

  UpdateBonusAmount(this._repository);

  @override
  Future<void> call(UpdateBonusAmountParams params) async {
    if (params.shiftRequestId.isEmpty) {
      throw ArgumentError('Shift request ID cannot be empty');
    }

    if (params.bonusAmount < 0) {
      throw ArgumentError('Bonus amount cannot be negative');
    }

    return await _repository.updateBonusAmount(
      shiftRequestId: params.shiftRequestId,
      bonusAmount: params.bonusAmount,
    );
  }
}

/// Parameters for UpdateBonusAmount UseCase
@freezed
class UpdateBonusAmountParams with _$UpdateBonusAmountParams {
  const factory UpdateBonusAmountParams({
    required String shiftRequestId,
    required double bonusAmount,
  }) = _UpdateBonusAmountParams;
}
