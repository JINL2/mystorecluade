// lib/features/debt_control/di/injection.dart
//
// Dependency Injection Container for Debt Control Feature
//
// This file is in a separate DI layer to maintain Clean Architecture:
// - Presentation should NOT import Data layer directly
// - This file handles the wiring of implementations to interfaces

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/datasources/supabase_debt_data_source.dart';
import '../data/repositories/debt_repository_impl.dart';
import '../domain/repositories/debt_repository.dart';
import '../domain/services/debt_risk_assessment_service.dart';

// ============================================================================
// SERVICES
// ============================================================================

/// Provider for DebtRiskAssessmentService
final debtRiskAssessmentServiceProvider = Provider<DebtRiskAssessmentService>((ref) {
  return DebtRiskAssessmentService();
});

// ============================================================================
// DATA SOURCES
// ============================================================================

/// Provider for Supabase Debt Data Source
final debtDataSourceProvider = Provider<SupabaseDebtDataSource>((ref) {
  final riskService = ref.watch(debtRiskAssessmentServiceProvider);
  return SupabaseDebtDataSource(riskService: riskService);
});

// ============================================================================
// REPOSITORIES (Domain Interfaces → Data Implementations)
// ============================================================================

/// Provider for Debt Repository
/// This is the single source of truth for all debt-related data operations
final debtRepositoryProvider = Provider<DebtRepository>((ref) {
  final dataSource = ref.watch(debtDataSourceProvider);
  return DebtRepositoryImpl(dataSource: dataSource);
});
