import 'use_case.dart';
import '../repositories/cash_location_repository.dart';

/// Parameters for updating a cash location
class UpdateCashLocationParams {
  final String locationId;
  final String? locationName;
  final String? bankName;
  final String? accountNumber;
  final String? currencyId;
  final String? locationInfo;

  UpdateCashLocationParams({
    required this.locationId,
    this.locationName,
    this.bankName,
    this.accountNumber,
    this.currencyId,
    this.locationInfo,
  });
}

/// UseCase for updating cash location information
///
/// Handles:
/// - Updating location name
/// - Updating bank information (for bank accounts)
/// - Updating currency
/// - Updating location metadata
class UpdateCashLocationUseCase
    implements UseCase<void, UpdateCashLocationParams> {
  final CashLocationRepository repository;

  UpdateCashLocationUseCase(this.repository);

  @override
  Future<void> call(UpdateCashLocationParams params) async {
    return repository.updateCashLocation(
      locationId: params.locationId,
      name: params.locationName ?? '',
      note: params.locationInfo,
      description: params.locationInfo,
      bankName: params.bankName,
      accountNumber: params.accountNumber,
    );
  }
}
