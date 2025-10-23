import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../app/providers/app_state_provider.dart';

/// Provider for getting the currency symbol from company data
final currencyProvider = Provider<String>((ref) {
  final appState = ref.watch(appStateProvider);

  // Try to get currency from selected company
  if (appState.companyChoosen.isNotEmpty && appState.user.isNotEmpty) {
    try {
      // Get companies from user data
      final companies = appState.user['companies'] as List<dynamic>?;
      if (companies != null && companies.isNotEmpty) {
        // Find selected company
        final selectedCompany = companies.firstWhere(
          (company) => company['company_id'] == appState.companyChoosen,
          orElse: () => null,
        );

        if (selectedCompany != null) {
          // Check if company has currency_symbol field
          final currencySymbol = selectedCompany['currency_symbol'] as String?;
          if (currencySymbol != null && currencySymbol.isNotEmpty) {
            return currencySymbol;
          }

          // Check for currency field
          final currency = selectedCompany['currency'] as String?;
          if (currency != null && currency.isNotEmpty) {
            return currency;
          }
        }
      }
    } catch (e) {
      // If any error occurs, fall through to default
    }
  }

  // Fallback to Vietnamese Dong as default
  return '₫';
});

/// Enhanced currency provider for debt control
/// In the future, this could check debt metadata if available
final debtCurrencyProvider = Provider<String>((ref) {
  return ref.watch(currencyProvider);
});
