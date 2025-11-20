import '../entities/operation_result.dart';
import '../repositories/time_table_repository.dart';
import 'base_usecase.dart';

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
class AddBonusParams {
  final String shiftRequestId;
  final double bonusAmount;
  final String bonusReason;

  const AddBonusParams({
    required this.shiftRequestId,
    required this.bonusAmount,
    required this.bonusReason,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is AddBonusParams &&
        other.shiftRequestId == shiftRequestId &&
        other.bonusAmount == bonusAmount &&
        other.bonusReason == bonusReason;
  }

  @override
  int get hashCode =>
      shiftRequestId.hashCode ^ bonusAmount.hashCode ^ bonusReason.hashCode;
}
