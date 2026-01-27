import 'package:dartz/dartz.dart';
import 'package:myfinance_improved/core/errors/failures.dart';
import 'package:myfinance_improved/features/homepage/domain/entities/company_type.dart';
import 'package:myfinance_improved/features/homepage/domain/entities/currency.dart';
import 'package:myfinance_improved/features/homepage/domain/repositories/company_repository.dart';

/// Use case for fetching all available company types and currencies
///
/// Used to populate dropdowns in the company creation form.
/// Fetches both data types in a single RPC call for efficiency.
class GetCompanyCurrencyTypes {
  const GetCompanyCurrencyTypes(this.repository);

  final CompanyRepository repository;

  /// Execute the use case
  ///
  /// Returns [Right<(List<CompanyType>, List<Currency>)>] on success
  /// Returns [Left<Failure>] on error
  Future<Either<Failure, (List<CompanyType>, List<Currency>)>> call() async {
    return await repository.getCompanyCurrencyTypes();
  }
}
