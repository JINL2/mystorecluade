import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../providers/app_state_provider.dart';

/// Provider for getting the currency symbol from company data or debt metadata
final currencyProvider = Provider<String>((ref) {
  // Try to get currency from selected company
  final selectedCompany = ref.read(appStateProvider.notifier).selectedCompany;
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
  
  // Fallback to Vietnamese Dong as default
  return '₫';
});

/// Enhanced currency provider that tries to get from debt metadata first
final debtCurrencyProvider = Provider<String>((ref) {
  // For now, use the company currency
  // In the future, this could check the debt metadata if available
  return ref.watch(currencyProvider);
});