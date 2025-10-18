import '../../data/services/stock_flow_service.dart';

/// Stock flow data state for Real/Journal tabs
/// FROM PRODUCTION LINES 112-120
class FlowState {
  // Stock flow data for Real/Journal tabs (Lines 112-118)
  final List<JournalFlow> journalFlows; // Line 112
  final List<ActualFlow> actualFlows; // Line 113
  final LocationSummary? locationSummary; // Line 114
  final bool isLoadingFlows; // Line 115
  final int flowsOffset; // Line 116
  final int flowsLimit; // Line 117
  final bool hasMoreFlows; // Line 118
  
  // Filter selection (Line 120)
  final String selectedFilter; // Line 120

  FlowState({
    this.journalFlows = const [],
    this.actualFlows = const [],
    this.locationSummary,
    this.isLoadingFlows = false,
    this.flowsOffset = 0,
    this.flowsLimit = 20,
    this.hasMoreFlows = false,
    this.selectedFilter = 'All',
  });

  FlowState copyWith({
    List<JournalFlow>? journalFlows,
    List<ActualFlow>? actualFlows,
    LocationSummary? locationSummary,
    bool? isLoadingFlows,
    int? flowsOffset,
    int? flowsLimit,
    bool? hasMoreFlows,
    String? selectedFilter,
  }) {
    return FlowState(
      journalFlows: journalFlows ?? this.journalFlows,
      actualFlows: actualFlows ?? this.actualFlows,
      locationSummary: locationSummary ?? this.locationSummary,
      isLoadingFlows: isLoadingFlows ?? this.isLoadingFlows,
      flowsOffset: flowsOffset ?? this.flowsOffset,
      flowsLimit: flowsLimit ?? this.flowsLimit,
      hasMoreFlows: hasMoreFlows ?? this.hasMoreFlows,
      selectedFilter: selectedFilter ?? this.selectedFilter,
    );
  }
}