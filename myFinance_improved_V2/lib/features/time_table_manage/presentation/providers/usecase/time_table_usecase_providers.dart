/// UseCase Providers for Time Table Feature
///
/// This file contains all UseCase providers (Domain layer logic).
/// Each provider creates a UseCase instance with injected Repository.
///
/// Total: 13 UseCase Providers
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../di/dependency_injection.dart';
import '../../../domain/usecases/delete_shift_tag.dart';
import '../../../domain/usecases/get_manager_overview.dart';
import '../../../domain/usecases/get_manager_shift_cards.dart';
import '../../../domain/usecases/get_monthly_shift_status.dart';
import '../../../domain/usecases/get_reliability_score.dart';
import '../../../domain/usecases/get_schedule_data.dart';
import '../../../domain/usecases/get_shift_metadata.dart';
import '../../../domain/usecases/input_card.dart';
import '../../../domain/usecases/input_card_v4.dart';
import '../../../domain/usecases/insert_schedule.dart';
import '../../../domain/usecases/process_bulk_approval.dart';
import '../../../domain/usecases/toggle_shift_approval.dart';
import '../../../domain/usecases/update_bonus_amount.dart';

// ============================================================================
// Metadata & Status UseCases
// ============================================================================

/// Get Shift Metadata UseCase Provider
final getShiftMetadataUseCaseProvider = Provider<GetShiftMetadata>((ref) {
  final repository = ref.watch(timeTableRepositoryProvider);
  return GetShiftMetadata(repository);
});

/// Get Monthly Shift Status UseCase Provider
final getMonthlyShiftStatusUseCaseProvider =
    Provider<GetMonthlyShiftStatus>((ref) {
  final repository = ref.watch(timeTableRepositoryProvider);
  return GetMonthlyShiftStatus(repository);
});

// ============================================================================
// Manager Overview & Cards UseCases
// ============================================================================

/// Get Manager Overview UseCase Provider
final getManagerOverviewUseCaseProvider = Provider<GetManagerOverview>((ref) {
  final repository = ref.watch(timeTableRepositoryProvider);
  return GetManagerOverview(repository);
});

/// Get Manager Shift Cards UseCase Provider
final getManagerShiftCardsUseCaseProvider =
    Provider<GetManagerShiftCards>((ref) {
  final repository = ref.watch(timeTableRepositoryProvider);
  return GetManagerShiftCards(repository);
});

// ============================================================================
// Approval UseCases
// ============================================================================

/// Toggle Shift Approval UseCase Provider
final toggleShiftApprovalUseCaseProvider =
    Provider<ToggleShiftApproval>((ref) {
  final repository = ref.watch(timeTableRepositoryProvider);
  return ToggleShiftApproval(repository);
});

/// Process Bulk Approval UseCase Provider
final processBulkApprovalUseCaseProvider =
    Provider<ProcessBulkApproval>((ref) {
  final repository = ref.watch(timeTableRepositoryProvider);
  return ProcessBulkApproval(repository);
});

// ============================================================================
// Schedule UseCases
// ============================================================================

/// Get Schedule Data UseCase Provider
final getScheduleDataUseCaseProvider = Provider<GetScheduleData>((ref) {
  final repository = ref.watch(timeTableRepositoryProvider);
  return GetScheduleData(repository);
});

/// Insert Schedule UseCase Provider
final insertScheduleUseCaseProvider = Provider<InsertSchedule>((ref) {
  final repository = ref.watch(timeTableRepositoryProvider);
  return InsertSchedule(repository);
});

// ============================================================================
// Card & Tag UseCases
// ============================================================================

/// Input Card UseCase Provider
final inputCardUseCaseProvider = Provider<InputCard>((ref) {
  final repository = ref.watch(timeTableRepositoryProvider);
  return InputCard(repository);
});

/// Input Card V4 UseCase Provider
///
/// Uses manager_shift_input_card_v4 RPC for updating shift cards
/// with confirmed times, problem solved status, and bonus amount.
final inputCardV4UseCaseProvider = Provider<InputCardV4>((ref) {
  final repository = ref.watch(timeTableRepositoryProvider);
  return InputCardV4(repository);
});

/// Delete Shift Tag UseCase Provider
final deleteShiftTagUseCaseProvider = Provider<DeleteShiftTag>((ref) {
  final repository = ref.watch(timeTableRepositoryProvider);
  return DeleteShiftTag(repository);
});

// ============================================================================
// Bonus UseCases
// ============================================================================

/// Update Bonus Amount UseCase Provider
final updateBonusAmountUseCaseProvider = Provider<UpdateBonusAmount>((ref) {
  final repository = ref.watch(timeTableRepositoryProvider);
  return UpdateBonusAmount(repository);
});

// ============================================================================
// Stats UseCases
// ============================================================================

/// Get Reliability Score UseCase Provider
final getReliabilityScoreUseCaseProvider = Provider<GetReliabilityScore>((ref) {
  final repository = ref.watch(timeTableRepositoryProvider);
  return GetReliabilityScore(repository);
});
