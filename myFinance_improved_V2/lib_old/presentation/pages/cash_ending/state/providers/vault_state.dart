/// Vault balance state variables
/// FROM PRODUCTION LINES 88-92
class VaultState {
  // Vault balance state variables (Lines 88-89)
  final Map<String, dynamic>? vaultBalanceData; // Line 88
  final bool isLoadingVaultBalance; // Line 89
  
  // Vault transaction type (Lines 92)
  final String? vaultTransactionType; // 'debit' (In) or 'credit' (Out) (Line 92)

  VaultState({
    this.vaultBalanceData,
    this.isLoadingVaultBalance = false,
    this.vaultTransactionType,
  });

  VaultState copyWith({
    Map<String, dynamic>? vaultBalanceData,
    bool? isLoadingVaultBalance,
    String? vaultTransactionType,
  }) {
    return VaultState(
      vaultBalanceData: vaultBalanceData ?? this.vaultBalanceData,
      isLoadingVaultBalance: isLoadingVaultBalance ?? this.isLoadingVaultBalance,
      vaultTransactionType: vaultTransactionType ?? this.vaultTransactionType,
    );
  }
}