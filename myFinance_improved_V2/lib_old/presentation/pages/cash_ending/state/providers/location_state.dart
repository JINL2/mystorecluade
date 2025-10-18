/// Location-related state variables
/// FROM PRODUCTION LINES 61-67, 95-97, 100-101, 119
class LocationState {
  // Cash locations from Supabase (Lines 61-62)
  final List<Map<String, dynamic>> cashLocations;
  final bool isLoadingCashLocations;
  
  // Bank locations from Supabase (Lines 65-67)
  final List<Map<String, dynamic>> bankLocations;
  final bool isLoadingBankLocations;
  final String? selectedBankLocationId;
  
  // Vault locations from Supabase (Lines 95-97)
  final List<Map<String, dynamic>> vaultLocations;
  final bool isLoadingVaultLocations;
  final String? selectedVaultLocationId;
  
  // Stores from Supabase (Lines 100-101)
  final List<Map<String, dynamic>> stores;
  final bool isLoadingStores;
  
  // Selected cash location for flow (Line 119)
  final String? selectedCashLocationIdForFlow;

  LocationState({
    this.cashLocations = const [],
    this.isLoadingCashLocations = false,
    this.bankLocations = const [],
    this.isLoadingBankLocations = false,
    this.selectedBankLocationId,
    this.vaultLocations = const [],
    this.isLoadingVaultLocations = false,
    this.selectedVaultLocationId,
    this.stores = const [],
    this.isLoadingStores = true,
    this.selectedCashLocationIdForFlow,
  });

  LocationState copyWith({
    List<Map<String, dynamic>>? cashLocations,
    bool? isLoadingCashLocations,
    List<Map<String, dynamic>>? bankLocations,
    bool? isLoadingBankLocations,
    String? selectedBankLocationId,
    List<Map<String, dynamic>>? vaultLocations,
    bool? isLoadingVaultLocations,
    String? selectedVaultLocationId,
    List<Map<String, dynamic>>? stores,
    bool? isLoadingStores,
    String? selectedCashLocationIdForFlow,
  }) {
    return LocationState(
      cashLocations: cashLocations ?? this.cashLocations,
      isLoadingCashLocations: isLoadingCashLocations ?? this.isLoadingCashLocations,
      bankLocations: bankLocations ?? this.bankLocations,
      isLoadingBankLocations: isLoadingBankLocations ?? this.isLoadingBankLocations,
      selectedBankLocationId: selectedBankLocationId ?? this.selectedBankLocationId,
      vaultLocations: vaultLocations ?? this.vaultLocations,
      isLoadingVaultLocations: isLoadingVaultLocations ?? this.isLoadingVaultLocations,
      selectedVaultLocationId: selectedVaultLocationId ?? this.selectedVaultLocationId,
      stores: stores ?? this.stores,
      isLoadingStores: isLoadingStores ?? this.isLoadingStores,
      selectedCashLocationIdForFlow: selectedCashLocationIdForFlow ?? this.selectedCashLocationIdForFlow,
    );
  }
}