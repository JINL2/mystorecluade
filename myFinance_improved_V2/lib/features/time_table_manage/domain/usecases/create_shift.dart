import '../entities/shift.dart';
import '../exceptions/time_table_exceptions.dart';
import '../repositories/time_table_repository.dart';
import '../value_objects/create_shift_params.dart';
import 'base_usecase.dart';

/// Create Shift UseCase
///
/// Creates a new shift with the provided parameters.
/// Validates parameters before calling repository.
class CreateShift implements UseCase<Shift, CreateShiftParams> {
  final TimeTableRepository _repository;

  CreateShift(this._repository);

  @override
  Future<Shift> call(CreateShiftParams params) async {
    // Validate parameters (business logic validation)
    if (!params.isValid) {
      throw InvalidShiftParametersException(
        'Invalid shift parameters: ${params.validationErrors.join(", ")}',
      );
    }

    // Call repository to perform data operation
    return await _repository.createShift(params: params);
  }
}
