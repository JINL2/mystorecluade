import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myfinance_improved/features/homepage/domain/usecases/create_company.dart';
import 'package:myfinance_improved/features/homepage/presentation/providers/company_state.dart';

/// StateNotifier for managing Company creation state
class CompanyNotifier extends StateNotifier<CompanyState> {
  CompanyNotifier(this._createCompany) : super(const CompanyInitial());

  final CreateCompany _createCompany;

  /// Create a new company
  Future<void> createCompany({
    required String companyName,
    required String companyTypeId,
    required String baseCurrencyId,
  }) async {
    print('🔵 [CompanyNotifier] createCompany called');
    print('🔵 [CompanyNotifier] companyName: $companyName');
    print('🔵 [CompanyNotifier] companyTypeId: $companyTypeId');
    print('🔵 [CompanyNotifier] baseCurrencyId: $baseCurrencyId');

    state = const CompanyLoading();
    print('🔵 [CompanyNotifier] State set to CompanyLoading');

    final result = await _createCompany(CreateCompanyParams(
      companyName: companyName,
      companyTypeId: companyTypeId,
      baseCurrencyId: baseCurrencyId,
    ));

    print('🔵 [CompanyNotifier] Result received from use case');
    result.fold(
      (failure) {
        print('🔴 [CompanyNotifier] Error: ${failure.message}');
        state = CompanyError(failure.message, failure.code);
      },
      (company) {
        print('✅ [CompanyNotifier] Success: Company created with ID ${company.id}');
        state = CompanyCreated(company);
      },
    );
  }

  /// Reset state to initial
  void reset() {
    state = const CompanyInitial();
  }
}
