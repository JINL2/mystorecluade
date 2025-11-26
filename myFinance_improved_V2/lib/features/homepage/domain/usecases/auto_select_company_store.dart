import 'package:equatable/equatable.dart';

import '../../../../core/domain/entities/company.dart';
import '../../../../core/domain/entities/store.dart';
import '../entities/user_with_companies.dart';

/// Use case for automatically selecting a company and store
///
/// Business rules:
/// 1. Try to restore last selected company/store from cache
/// 2. If cached company not found, use first company
/// 3. If cached store not found, use first store in selected company
/// 4. Return empty selection if user has no companies
class AutoSelectCompanyStore {
  /// Execute the use case
  ///
  /// Returns [CompanyStoreSelection] with selected company and store
  CompanyStoreSelection call(AutoSelectParams params) {
    final companies = params.userEntity.companies;

    // No companies available
    if (companies.isEmpty) {
      return CompanyStoreSelection.empty();
    }

    // Try to find last selected company
    Company? selectedCompany = _findLastSelectedCompany(
      companies,
      params.lastCompanyId,
    );

    // Fallback: use first company
    selectedCompany ??= companies.first;

    // Try to find last selected store in this company
    Store? selectedStore = _findLastSelectedStore(
      selectedCompany.stores,
      params.lastStoreId,
    );

    // Fallback: use first store if available
    selectedStore ??= selectedCompany.stores.isNotEmpty
        ? selectedCompany.stores.first
        : null;

    return CompanyStoreSelection(
      company: selectedCompany,
      store: selectedStore,
    );
  }

  /// Find company by ID from list
  ///
  /// Returns null if not found or ID is invalid
  Company? _findLastSelectedCompany(
    List<Company> companies,
    String? lastCompanyId,
  ) {
    if (lastCompanyId == null || lastCompanyId.isEmpty) {
      return null;
    }

    try {
      return companies.firstWhere((c) => c.id == lastCompanyId);
    } catch (_) {
      // Company not found (may have been deleted)
      return null;
    }
  }

  /// Find store by ID from list
  ///
  /// Returns null if not found or ID is invalid
  Store? _findLastSelectedStore(
    List<Store> stores,
    String? lastStoreId,
  ) {
    if (lastStoreId == null || lastStoreId.isEmpty) {
      return null;
    }

    try {
      return stores.firstWhere((s) => s.id == lastStoreId);
    } catch (_) {
      // Store not found (may have been deleted)
      return null;
    }
  }
}

/// Parameters for auto-select use case
class AutoSelectParams extends Equatable {
  const AutoSelectParams({
    required this.userEntity,
    this.lastCompanyId,
    this.lastStoreId,
  });

  final UserWithCompanies userEntity;
  final String? lastCompanyId;
  final String? lastStoreId;

  @override
  List<Object?> get props => [userEntity, lastCompanyId, lastStoreId];
}

/// Result of auto-select operation
class CompanyStoreSelection extends Equatable {
  const CompanyStoreSelection({
    required this.company,
    this.store,
  });

  /// Create empty selection (no companies)
  const CompanyStoreSelection.empty()
      : company = null,
        store = null;

  final Company? company;
  final Store? store;

  bool get hasSelection => company != null;
  bool get isEmpty => company == null;

  @override
  List<Object?> get props => [company, store];
}
