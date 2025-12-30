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
  // Trade/International banking fields
  final String? beneficiaryName;
  final String? bankAddress;
  final String? swiftCode;
  final String? bankBranch;
  final String? accountType;

  UpdateCashLocationParams({
    required this.locationId,
    this.locationName,
    this.bankName,
    this.accountNumber,
    this.currencyId,
    this.locationInfo,
    // Trade fields
    this.beneficiaryName,
    this.bankAddress,
    this.swiftCode,
    this.bankBranch,
    this.accountType,
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
      // Trade fields
      beneficiaryName: params.beneficiaryName,
      bankAddress: params.bankAddress,
      swiftCode: params.swiftCode,
      bankBranch: params.bankBranch,
      accountType: params.accountType,
    );
  }
}
