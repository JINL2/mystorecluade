
/// Main cash ending state variables
/// FROM PRODUCTION LINES 43-48
class CashEndingState {
  // TabController is managed in the main page widget
  // late TabController _tabController; (Line 42 - stays in main page)
  
  // Store and location selection
  final String? selectedStoreId; // Line 43
  final String? selectedLocationId; // Line 44
  
  // Recent cash endings data
  final List<Map<String, dynamic>> recentCashEndings; // Line 47
  final bool isLoadingRecentEndings; // Line 48

  CashEndingState({
    this.selectedStoreId,
    this.selectedLocationId,
    this.recentCashEndings = const [],
    this.isLoadingRecentEndings = false,
  });

  CashEndingState copyWith({
    String? selectedStoreId,
    String? selectedLocationId,
    List<Map<String, dynamic>>? recentCashEndings,
    bool? isLoadingRecentEndings,
  }) {
    return CashEndingState(
      selectedStoreId: selectedStoreId ?? this.selectedStoreId,
      selectedLocationId: selectedLocationId ?? this.selectedLocationId,
      recentCashEndings: recentCashEndings ?? this.recentCashEndings,
      isLoadingRecentEndings: isLoadingRecentEndings ?? this.isLoadingRecentEndings,
    );
  }
}