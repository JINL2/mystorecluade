import 'use_case.dart';
import '../repositories/cash_location_repository.dart';

/// Parameters for updating main account status
class UpdateMainAccountStatusParams {
  final String locationId;
  final bool isMainAccount;
  final String companyId;
  final String storeId;
  final String locationType;

  UpdateMainAccountStatusParams({
    required this.locationId,
    required this.isMainAccount,
    required this.companyId,
    required this.storeId,
    required this.locationType,
  });
}

/// UseCase for marking a cash location as main/default account
///
/// Business rules:
/// - Only one location per store can be marked as main account
/// - When setting a location as main, other locations should be unmarked
/// - Main account is used as default for transactions
class UpdateMainAccountStatusUseCase
    implements UseCase<void, UpdateMainAccountStatusParams> {
  final CashLocationRepository repository;

  UpdateMainAccountStatusUseCase(this.repository);

  @override
  Future<void> call(UpdateMainAccountStatusParams params) async {
    return repository.updateMainAccountStatus(
      locationId: params.locationId,
      isMain: params.isMainAccount,
      companyId: params.companyId,
      storeId: params.storeId,
      locationType: params.locationType,
    );
  }
}
