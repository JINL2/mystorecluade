import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/supply_chain_models.dart';
import '../../../../core/themes/toss_colors.dart';

// Current user persona provider
final currentPersonaProvider = StateProvider<UserPersona>((ref) {
  // Default to CEO persona
  return UserPersona(
    role: UserRole.ceo,
    koreanLabel: 'CEO',
    priorityKPIs: [KPIType.critical, KPIType.valueAtRisk],
    primaryActions: [
      ActionType.escalateIssue,
      ActionType.requestTransfer,
      ActionType.updateForecast,
    ],
    themeColor: TossColors.primary,
    updateFrequencyMinutes: 1440, // Daily
  );
});

// Available personas provider
final availablePersonasProvider = Provider<List<UserPersona>>((ref) {
  return [
    // CEO Persona - Strategic oversight
    UserPersona(
      role: UserRole.ceo,
      koreanLabel: 'CEO',
      priorityKPIs: [KPIType.critical, KPIType.valueAtRisk],
      primaryActions: [
        ActionType.escalateIssue,
        ActionType.requestTransfer,
        ActionType.updateForecast,
      ],
      themeColor: TossColors.primary,
      updateFrequencyMinutes: 1440, // Daily
    ),
    
    // Purchasing Manager Persona - Supplier focus
    UserPersona(
      role: UserRole.purchasingManager,
      koreanLabel: 'Purchasing Manager',
      priorityKPIs: [KPIType.critical, KPIType.warning, KPIType.valueAtRisk],
      primaryActions: [
        ActionType.contactSupplier,
        ActionType.expediteOrder,
        ActionType.findAlternative,
        ActionType.negotiateTerms,
        ActionType.trackShipment,
      ],
      themeColor: TossColors.warning,
      updateFrequencyMinutes: 1, // Real-time
    ),
    
    // Store Manager Persona - Inventory focus
    UserPersona(
      role: UserRole.storeManager,
      koreanLabel: 'Store Manager',
      priorityKPIs: [KPIType.warning, KPIType.normal],
      primaryActions: [
        ActionType.createPromotion,
        ActionType.requestTransfer,
        ActionType.qualityCheck,
        ActionType.updateForecast,
      ],
      themeColor: TossColors.success,
      updateFrequencyMinutes: 60, // Hourly
    ),
    
    // Analyst Persona - Deep analysis
    UserPersona(
      role: UserRole.analyst,
      koreanLabel: 'Analyst',
      priorityKPIs: [KPIType.critical, KPIType.warning, KPIType.normal, KPIType.valueAtRisk],
      primaryActions: [
        ActionType.updateForecast,
        ActionType.escalateIssue,
        ActionType.qualityCheck,
      ],
      themeColor: TossColors.info,
      updateFrequencyMinutes: 30, // Every 30 minutes
    ),
  ];
});

// Persona-specific dashboard configuration
class PersonaDashboardConfig {
  final UserRole role;
  final int maxKPICards;
  final int maxPriorityProblems;
  final bool showDetailedMetrics;
  final bool showPredictiveAnalytics;
  final bool showCollaborationFeatures;
  final List<SupplyChainStage> focusStages;
  final String dashboardTitle;
  final String subtitle;

  const PersonaDashboardConfig({
    required this.role,
    required this.maxKPICards,
    required this.maxPriorityProblems,
    required this.showDetailedMetrics,
    required this.showPredictiveAnalytics,
    required this.showCollaborationFeatures,
    required this.focusStages,
    required this.dashboardTitle,
    required this.subtitle,
  });
}

// Dashboard configuration provider
final dashboardConfigProvider = Provider<PersonaDashboardConfig>((ref) {
  final currentPersona = ref.watch(currentPersonaProvider);
  
  switch (currentPersona.role) {
    case UserRole.ceo:
      return PersonaDashboardConfig(
        role: UserRole.ceo,
        maxKPICards: 4,
        maxPriorityProblems: 5,
        showDetailedMetrics: false,
        showPredictiveAnalytics: true,
        showCollaborationFeatures: true,
        focusStages: SupplyChainStage.values,
        dashboardTitle: 'Executive Overview',
        subtitle: 'Strategic supply chain intelligence',
      );
      
    case UserRole.purchasingManager:
      return PersonaDashboardConfig(
        role: UserRole.purchasingManager,
        maxKPICards: 6,
        maxPriorityProblems: 10,
        showDetailedMetrics: true,
        showPredictiveAnalytics: true,
        showCollaborationFeatures: true,
        focusStages: [SupplyChainStage.order, SupplyChainStage.send],
        dashboardTitle: 'Purchasing Control Center',
        subtitle: 'Supplier performance and procurement optimization',
      );
      
    case UserRole.storeManager:
      return PersonaDashboardConfig(
        role: UserRole.storeManager,
        maxKPICards: 5,
        maxPriorityProblems: 8,
        showDetailedMetrics: true,
        showPredictiveAnalytics: false,
        showCollaborationFeatures: false,
        focusStages: [SupplyChainStage.receive, SupplyChainStage.sell],
        dashboardTitle: 'Store Operations',
        subtitle: 'Inventory optimization and sales enablement',
      );
      
    case UserRole.analyst:
      return PersonaDashboardConfig(
        role: UserRole.analyst,
        maxKPICards: 8,
        maxPriorityProblems: 15,
        showDetailedMetrics: true,
        showPredictiveAnalytics: true,
        showCollaborationFeatures: true,
        focusStages: SupplyChainStage.values,
        dashboardTitle: 'Analytics Workbench',
        subtitle: 'Comprehensive supply chain analysis',
      );
  }
});

// Persona-specific KPI filtering
final personaKPIsProvider = Provider<List<SupplyChainKPI>>((ref) {
  final config = ref.watch(dashboardConfigProvider);
  final allKPIs = ref.watch(supplyChainKPIsProvider);
  
  // Filter KPIs based on persona priorities
  final currentPersona = ref.watch(currentPersonaProvider);
  final priorityTypes = currentPersona.priorityKPIs;
  
  return allKPIs
      .where((kpi) => priorityTypes.contains(kpi.type))
      .take(config.maxKPICards)
      .toList();
});

// Persona-specific problem filtering
final personaProblemsProvider = Provider<List<SupplyChainProblem>>((ref) {
  final config = ref.watch(dashboardConfigProvider);
  final allProblems = ref.watch(supplyChainProblemsProvider);
  
  // Filter problems based on focus stages
  final focusStages = config.focusStages;
  
  return allProblems
      .where((problem) => focusStages.contains(problem.stage.stage))
      .take(config.maxPriorityProblems)
      .toList();
});

// Data providers for Supply Chain Analytics (replace with real implementations)
final supplyChainHealthProvider = Provider<SupplyChainHealth>((ref) {
  // TODO: Replace with actual health data from backend
  return SupplyChainHealth(
    currentScore: 0,
    trend: HealthTrend.stable,
    changePercent: 0,
    benchmarkScore: 0,
    metrics: [],
    lastUpdated: DateTime.now(),
  );
});

final integralChartDataProvider = Provider<List<IntegralDataPoint>>((ref) {
  // TODO: Replace with actual chart data from backend
  return [];
});

final stagePerformanceProvider = Provider<List<StagePerformance>>((ref) {
  // TODO: Replace with actual stage performance data from backend
  return [];
});

final supplyChainKPIsProvider = Provider<List<SupplyChainKPI>>((ref) {
  // TODO: Replace with actual KPI data from backend analytics service
  return [];
});

final supplyChainProblemsProvider = Provider<List<SupplyChainProblem>>((ref) {
  // TODO: Replace with actual problems data from backend
  return [];
});


// Persona selection notifier
class PersonaNotifier extends StateNotifier<UserPersona> {
  PersonaNotifier(UserPersona initialPersona) : super(initialPersona);
  
  void selectPersona(UserPersona persona) {
    state = persona;
  }
  
  void updatePersonaPreferences({
    List<KPIType>? priorityKPIs,
    List<ActionType>? primaryActions,
    Color? themeColor,
    int? updateFrequencyMinutes,
  }) {
    state = state.copyWith(
      priorityKPIs: priorityKPIs,
      primaryActions: primaryActions,
      themeColor: themeColor,
      updateFrequencyMinutes: updateFrequencyMinutes,
    );
  }
}

final personaNotifierProvider = StateNotifierProvider<PersonaNotifier, UserPersona>((ref) {
  final defaultPersona = ref.read(availablePersonasProvider).first;
  return PersonaNotifier(defaultPersona);
});