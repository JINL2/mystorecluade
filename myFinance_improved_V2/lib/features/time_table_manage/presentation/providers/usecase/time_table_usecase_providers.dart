/// UseCase Providers for Time Table Feature
///
/// This file contains all UseCase providers (Domain layer logic).
/// Each provider creates a UseCase instance with injected Repository.
///
/// Total: 17 UseCase Providers
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../di/dependency_injection.dart';
import '../../../domain/usecases/add_bonus.dart';
import '../../../domain/usecases/create_shift.dart';
import '../../../domain/usecases/delete_shift.dart';
import '../../../domain/usecases/delete_shift_tag.dart';
import '../../../domain/usecases/get_available_employees.dart';
import '../../../domain/usecases/get_manager_overview.dart';
import '../../../domain/usecases/get_manager_shift_cards.dart';
import '../../../domain/usecases/get_monthly_shift_status.dart';
import '../../../domain/usecases/get_schedule_data.dart';
import '../../../domain/usecases/get_shift_metadata.dart';
import '../../../domain/usecases/get_tags_by_card_id.dart';
import '../../../domain/usecases/input_card.dart';
import '../../../domain/usecases/insert_schedule.dart';
import '../../../domain/usecases/process_bulk_approval.dart';
import '../../../domain/usecases/toggle_shift_approval.dart';
import '../../../domain/usecases/update_bonus_amount.dart';
import '../../../domain/usecases/update_shift.dart';

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
// Shift CRUD UseCases
// ============================================================================

/// Create Shift UseCase Provider
final createShiftUseCaseProvider = Provider<CreateShift>((ref) {
  final repository = ref.watch(timeTableRepositoryProvider);
  return CreateShift(repository);
});

/// Update Shift UseCase Provider
final updateShiftUseCaseProvider = Provider<UpdateShift>((ref) {
  final repository = ref.watch(timeTableRepositoryProvider);
  return UpdateShift(repository);
});

/// Delete Shift UseCase Provider
final deleteShiftUseCaseProvider = Provider<DeleteShift>((ref) {
  final repository = ref.watch(timeTableRepositoryProvider);
  return DeleteShift(repository);
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

/// Get Available Employees UseCase Provider
final getAvailableEmployeesUseCaseProvider =
    Provider<GetAvailableEmployees>((ref) {
  final repository = ref.watch(timeTableRepositoryProvider);
  return GetAvailableEmployees(repository);
});

// ============================================================================
// Card & Tag UseCases
// ============================================================================

/// Input Card UseCase Provider
final inputCardUseCaseProvider = Provider<InputCard>((ref) {
  final repository = ref.watch(timeTableRepositoryProvider);
  return InputCard(repository);
});

/// Get Tags By Card ID UseCase Provider
final getTagsByCardIdUseCaseProvider = Provider<GetTagsByCardId>((ref) {
  final repository = ref.watch(timeTableRepositoryProvider);
  return GetTagsByCardId(repository);
});

/// Delete Shift Tag UseCase Provider
final deleteShiftTagUseCaseProvider = Provider<DeleteShiftTag>((ref) {
  final repository = ref.watch(timeTableRepositoryProvider);
  return DeleteShiftTag(repository);
});

// ============================================================================
// Bonus UseCases
// ============================================================================

/// Add Bonus UseCase Provider
final addBonusUseCaseProvider = Provider<AddBonus>((ref) {
  final repository = ref.watch(timeTableRepositoryProvider);
  return AddBonus(repository);
});

/// Update Bonus Amount UseCase Provider
final updateBonusAmountUseCaseProvider = Provider<UpdateBonusAmount>((ref) {
  final repository = ref.watch(timeTableRepositoryProvider);
  return UpdateBonusAmount(repository);
});
