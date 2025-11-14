import '../entities/shift.dart';
import '../repositories/time_table_repository.dart';
import '../value_objects/create_shift_params.dart';
import 'base_usecase.dart';

/// Create Shift UseCase
///
/// Creates a new shift with the provided parameters.
class CreateShift implements UseCase<Shift, CreateShiftParams> {
  final TimeTableRepository _repository;

  CreateShift(this._repository);

  @override
  Future<Shift> call(CreateShiftParams params) async {
    // Additional business logic validation can be added here
    if (!params.isValid) {
      throw ArgumentError(
        'Invalid shift parameters: ${params.validationErrors.join(", ")}',
      );
    }

    return await _repository.createShift(params: params);
  }
}
