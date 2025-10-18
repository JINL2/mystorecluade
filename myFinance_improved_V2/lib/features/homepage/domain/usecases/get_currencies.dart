import 'package:dartz/dartz.dart';
import 'package:myfinance_improved/core/errors/failures.dart';
import 'package:myfinance_improved/features/homepage/domain/entities/currency.dart';
import 'package:myfinance_improved/features/homepage/domain/repositories/company_repository.dart';

/// Use case for fetching all available currencies
///
/// Used to populate the currency dropdown in the UI
class GetCurrencies {
  const GetCurrencies(this.repository);

  final CompanyRepository repository;

  /// Execute the use case
  ///
  /// Returns [Right<List<Currency>>] on success
  /// Returns [Left<Failure>] on error
  Future<Either<Failure, List<Currency>>> call() async {
    return await repository.getCurrencies();
  }
}
