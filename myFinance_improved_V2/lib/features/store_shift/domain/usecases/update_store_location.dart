import '../repositories/store_shift_repository.dart';
import '../value_objects/shift_params.dart';
import 'base_usecase.dart';

class UpdateStoreLocation implements UseCase<void, UpdateStoreLocationParams> {
  final StoreShiftRepository _repository;

  UpdateStoreLocation(this._repository);

  @override
  Future<void> call(UpdateStoreLocationParams params) async {
    return await _repository.updateStoreLocation(
      storeId: params.storeId,
      latitude: params.latitude,
      longitude: params.longitude,
      address: params.address,
    );
  }
}
