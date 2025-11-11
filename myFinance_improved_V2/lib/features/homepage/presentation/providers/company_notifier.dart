import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myfinance_improved/features/homepage/domain/usecases/create_company.dart';
import 'package:myfinance_improved/features/homepage/presentation/providers/states/company_state.dart';
import 'package:myfinance_improved/features/homepage/core/homepage_logger.dart';

/// StateNotifier for managing Company creation state
class CompanyNotifier extends StateNotifier<CompanyState> {
  CompanyNotifier(this._createCompany) : super(const CompanyState.initial());

  final CreateCompany _createCompany;

  /// Create a new company
  Future<void> createCompany({
    required String companyName,
    required String companyTypeId,
    required String baseCurrencyId,
  }) async {
    homepageLogger.d('createCompany called - companyName: $companyName, companyTypeId: $companyTypeId, baseCurrencyId: $baseCurrencyId');

    state = const CompanyState.loading();
    homepageLogger.d('State set to CompanyLoading');

    final result = await _createCompany(CreateCompanyParams(
      companyName: companyName,
      companyTypeId: companyTypeId,
      baseCurrencyId: baseCurrencyId,
    ));

    homepageLogger.d('Result received from use case');
    result.fold(
      (failure) {
        homepageLogger.e('Error: ${failure.message}');
        state = CompanyState.error(failure.message, failure.code);
      },
      (company) {
        homepageLogger.i('Success: Company created with ID ${company.id}');
        state = CompanyState.created(company);
      },
    );
  }

  /// Reset state to initial
  void reset() {
    state = const CompanyState.initial();
  }
}
