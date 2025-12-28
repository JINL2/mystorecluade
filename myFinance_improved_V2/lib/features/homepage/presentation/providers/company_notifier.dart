import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../core/homepage_logger.dart';
import '../../domain/usecases/create_company.dart';
import 'states/company_state.dart';
import 'usecase_providers.dart';

part 'company_notifier.g.dart';

/// Notifier for managing Company creation state
///
/// Migrated from StateNotifier to @riverpod Notifier pattern.
/// Uses CompanyState (freezed) for type-safe state management.
@riverpod
class CompanyNotifier extends _$CompanyNotifier {
  @override
  CompanyState build() => const CompanyState.initial();

  /// Create a new company
  Future<void> createCompany({
    required String companyName,
    required String companyTypeId,
    required String baseCurrencyId,
  }) async {
    final createCompany = ref.read(createCompanyUseCaseProvider);

    homepageLogger.d(
      'createCompany called - companyName: $companyName, '
      'companyTypeId: $companyTypeId, baseCurrencyId: $baseCurrencyId',
    );

    state = const CompanyState.loading();
    homepageLogger.d('State set to CompanyLoading');

    final result = await createCompany(
      CreateCompanyParams(
        companyName: companyName,
        companyTypeId: companyTypeId,
        baseCurrencyId: baseCurrencyId,
      ),
    );

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
