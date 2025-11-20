import '../repositories/store_shift_repository.dart';
import '../value_objects/shift_params.dart';
import 'base_usecase.dart';

class UpdateOperationalSettings implements UseCase<void, UpdateOperationalSettingsParams> {
  final StoreShiftRepository _repository;

  UpdateOperationalSettings(this._repository);

  @override
  Future<void> call(UpdateOperationalSettingsParams params) async {
    return await _repository.updateOperationalSettings(
      storeId: params.storeId,
      huddleTime: params.huddleTime,
      paymentTime: params.paymentTime,
      allowedDistance: params.allowedDistance,
    );
  }
}
