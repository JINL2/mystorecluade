import 'dart:convert';
import '../repositories/cash_location_repository.dart';
import 'use_case.dart';

/// Parameters for creating a cash location
class CreateCashLocationParams {
  final String companyId;
  final String storeId;
  final String locationName;
  final String locationType;
  final String? bankName;
  final String? accountNumber;
  final String? currencyId;
  final String? description;

  // Trade/International banking fields (optional)
  final String? beneficiaryName;
  final String? bankAddress;
  final String? swiftCode;
  final String? bankBranch;
  final String? accountType;

  CreateCashLocationParams({
    required this.companyId,
    required this.storeId,
    required this.locationName,
    required this.locationType,
    this.bankName,
    this.accountNumber,
    this.currencyId,
    this.description,
    // Trade fields
    this.beneficiaryName,
    this.bankAddress,
    this.swiftCode,
    this.bankBranch,
    this.accountType,
  });
}

/// Use case for creating a new cash location
/// Handles the business logic for adding cash/bank/vault accounts
class CreateCashLocationUseCase implements UseCase<void, CreateCashLocationParams> {
  final CashLocationRepository repository;

  CreateCashLocationUseCase(this.repository);

  @override
  Future<void> call(CreateCashLocationParams params) async {
    // Prepare location_info JSON based on location type
    String? locationInfo;

    if (params.locationType == 'bank') {
      // For bank accounts, store bank-specific info
      locationInfo = jsonEncode({
        'bank_name': params.bankName ?? '',
        'account_number': params.accountNumber ?? '',
      });
    } else {
      // For cash/vault locations, store only description
      locationInfo = jsonEncode({
        'description': params.description ?? '',
      });
    }

    await repository.createCashLocation(
      companyId: params.companyId,
      storeId: params.storeId,
      locationName: params.locationName,
      locationType: params.locationType,
      bankName: params.bankName,
      accountNumber: params.accountNumber,
      currencyId: params.currencyId,
      locationInfo: locationInfo,
      // Trade fields
      beneficiaryName: params.beneficiaryName,
      bankAddress: params.bankAddress,
      swiftCode: params.swiftCode,
      bankBranch: params.bankBranch,
      accountType: params.accountType,
    );
  }
}
