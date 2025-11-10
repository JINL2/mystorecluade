import '../repositories/time_table_repository.dart';
import 'base_usecase.dart';

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
class UpdateBonusAmountParams {
  final String shiftRequestId;
  final double bonusAmount;

  const UpdateBonusAmountParams({
    required this.shiftRequestId,
    required this.bonusAmount,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is UpdateBonusAmountParams &&
        other.shiftRequestId == shiftRequestId &&
        other.bonusAmount == bonusAmount;
  }

  @override
  int get hashCode => shiftRequestId.hashCode ^ bonusAmount.hashCode;
}
