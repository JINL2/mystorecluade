import 'package:dartz/dartz.dart';
import 'package:myfinance_improved/core/errors/failures.dart';
import 'package:myfinance_improved/features/homepage/domain/entities/company_type.dart';
import 'package:myfinance_improved/features/homepage/domain/repositories/company_repository.dart';

/// Use case for fetching all available company types
///
/// Used to populate the company type dropdown in the UI
class GetCompanyTypes {
  const GetCompanyTypes(this.repository);

  final CompanyRepository repository;

  /// Execute the use case
  ///
  /// Returns [Right<List<CompanyType>>] on success
  /// Returns [Left<Failure>] on error
  Future<Either<Failure, List<CompanyType>>> call() async {
    return await repository.getCompanyTypes();
  }
}
