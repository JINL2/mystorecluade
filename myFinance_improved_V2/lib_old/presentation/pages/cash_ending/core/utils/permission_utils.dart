import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Permission utility functions for Cash Ending page
/// FROM PRODUCTION LINES 527-556
class PermissionUtils {
  
  /// Check if user has permission for Bank and Vault tabs
  /// FROM PRODUCTION LINES 527-556
  static bool hasVaultBankPermission(WidgetRef ref, dynamic appStateProvider) {
    // Check if user has permission for Bank and Vault tabs
    final appState = ref.read(appStateProvider);
    final userData = appState.user;
    
    if (userData == null || userData['companies'] == null) {
      return false;
    }
    
    final companies = userData['companies'] as List<dynamic>;
    final selectedCompanyId = appState.companyChoosen;
    
    // Find the selected company
    final selectedCompany = companies.firstWhere(
      (company) => company['company_id'] == selectedCompanyId,
      orElse: () => null,
    );
    
    if (selectedCompany == null) {
      return false;
    }
    
    // Check if user has the required permission
    final role = selectedCompany['role'] as Map<String, dynamic>?;
    final permissions = role?['permissions'] as List<dynamic>? ?? [];
    
    // Check for the specific permission ID for Bank/Vault access
    const requiredPermission = 'b478a1ca-ba8e-4b55-949a-053f44ea2e36';
    return permissions.contains(requiredPermission);
  }
}