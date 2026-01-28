import 'package:supabase_flutter/supabase_flutter.dart';

import 'employee_datasource.dart';
import 'manager_card_datasource.dart';
import 'schedule_datasource.dart';
import 'shift_datasource.dart';

/// Time Table Data Source (Facade)
///
/// Unified interface for all time table management operations.
/// Delegates to specialized datasources for better maintainability:
/// - [ShiftDatasource]: Shift metadata, status, approval, deletion
/// - [ScheduleDatasource]: Schedule insert and retrieve operations
/// - [EmployeeDatasource]: Employee info, reliability, monthly detail, audit logs
/// - [ManagerCardDatasource]: Manager overview, cards, input card, bonus
///
/// This class maintains backward compatibility with existing code
/// while internally using the split datasources.
class TimeTableDatasource {
  final SupabaseClient _supabase;

  // Specialized datasources (lazy initialization)
  late final ShiftDatasource _shiftDatasource;
  late final ScheduleDatasource _scheduleDatasource;
  late final EmployeeDatasource _employeeDatasource;
  late final ManagerCardDatasource _managerCardDatasource;

  TimeTableDatasource(this._supabase) {
    _shiftDatasource = ShiftDatasource(_supabase);
    _scheduleDatasource = ScheduleDatasource(_supabase);
    _employeeDatasource = EmployeeDatasource(_supabase);
    _managerCardDatasource = ManagerCardDatasource(_supabase);
  }

  // ===========================================================================
  // Shift Operations (delegated to ShiftDatasource)
  // ===========================================================================

  /// Fetch shift metadata from Supabase RPC
  Future<dynamic> getShiftMetadata({
    required String storeId,
    required String timezone,
  }) => _shiftDatasource.getShiftMetadata(storeId: storeId, timezone: timezone);

  /// Fetch monthly shift status for manager from Supabase RPC
  Future<List<dynamic>> getMonthlyShiftStatus({
    required String requestTime,
    required String storeId,
    required String timezone,
  }) => _shiftDatasource.getMonthlyShiftStatus(
        requestTime: requestTime,
        storeId: storeId,
        timezone: timezone,
      );

  /// Toggle shift request approval status
  Future<void> toggleShiftApproval({
    required List<String> shiftRequestIds,
    required String userId,
  }) => _shiftDatasource.toggleShiftApproval(
        shiftRequestIds: shiftRequestIds,
        userId: userId,
      );

  /// Delete a shift tag
  Future<Map<String, dynamic>> deleteShiftTag({
    required String tagId,
    required String userId,
  }) => _shiftDatasource.deleteShiftTag(tagId: tagId, userId: userId);

  /// Process bulk shift approval
  Future<Map<String, dynamic>> processBulkApproval({
    required List<String> shiftRequestIds,
    required List<bool> approvalStates,
  }) => _shiftDatasource.processBulkApproval(
        shiftRequestIds: shiftRequestIds,
        approvalStates: approvalStates,
      );

  // ===========================================================================
  // Schedule Operations (delegated to ScheduleDatasource)
  // ===========================================================================

  /// Insert new schedule (assign employee to shift)
  Future<Map<String, dynamic>> insertSchedule({
    required String userId,
    required String shiftId,
    required String storeId,
    required String startTime,
    required String endTime,
    required String approvedBy,
    required String timezone,
  }) => _scheduleDatasource.insertSchedule(
        userId: userId,
        shiftId: shiftId,
        storeId: storeId,
        startTime: startTime,
        endTime: endTime,
        approvedBy: approvedBy,
        timezone: timezone,
      );

  /// Get schedule data (employees and shifts)
  Future<Map<String, dynamic>> getScheduleData({
    required String storeId,
    required String timezone,
  }) => _scheduleDatasource.getScheduleData(storeId: storeId, timezone: timezone);

  // ===========================================================================
  // Employee Operations (delegated to EmployeeDatasource)
  // ===========================================================================

  /// Get reliability score data for stats tab
  Future<Map<String, dynamic>> getReliabilityScore({
    required String companyId,
    required String storeId,
    required String time,
    required String timezone,
  }) => _employeeDatasource.getReliabilityScore(
        companyId: companyId,
        storeId: storeId,
        time: time,
        timezone: timezone,
      );

  /// Get employee info for a specific store
  Future<List<dynamic>> getStoreEmployees({
    required String companyId,
    required String storeId,
  }) => _employeeDatasource.getStoreEmployees(
        companyId: companyId,
        storeId: storeId,
      );

  /// Get employee monthly detail log
  Future<Map<String, dynamic>> getEmployeeMonthlyDetailLog({
    required String userId,
    required String companyId,
    required String yearMonth,
    required String timezone,
  }) => _employeeDatasource.getEmployeeMonthlyDetailLog(
        userId: userId,
        companyId: companyId,
        yearMonth: yearMonth,
        timezone: timezone,
      );

  /// Get shift audit logs for a specific shift request
  Future<List<dynamic>> getShiftAuditLogs({
    required String shiftRequestId,
  }) => _employeeDatasource.getShiftAuditLogs(shiftRequestId: shiftRequestId);

  // ===========================================================================
  // Manager Card Operations (delegated to ManagerCardDatasource)
  // ===========================================================================

  /// Fetch manager overview data from Supabase RPC
  Future<Map<String, dynamic>> getManagerOverview({
    required String startDate,
    required String endDate,
    required String companyId,
    required String storeId,
    required String timezone,
  }) => _managerCardDatasource.getManagerOverview(
        startDate: startDate,
        endDate: endDate,
        companyId: companyId,
        storeId: storeId,
        timezone: timezone,
      );

  /// Fetch manager shift cards from Supabase RPC
  Future<Map<String, dynamic>> getManagerShiftCards({
    required String startDate,
    required String endDate,
    required String companyId,
    required String storeId,
    required String timezone,
  }) => _managerCardDatasource.getManagerShiftCards(
        startDate: startDate,
        endDate: endDate,
        companyId: companyId,
        storeId: storeId,
        timezone: timezone,
      );

  /// Input card data (manager updates shift)
  Future<Map<String, dynamic>> inputCardV5({
    required String managerId,
    required String shiftRequestId,
    String? confirmStartTime,
    String? confirmEndTime,
    bool? isProblemSolved,
    bool? isReportedSolved,
    double? bonusAmount,
    String? managerMemo,
    required String timezone,
  }) => _managerCardDatasource.inputCardV5(
        managerId: managerId,
        shiftRequestId: shiftRequestId,
        confirmStartTime: confirmStartTime,
        confirmEndTime: confirmEndTime,
        isProblemSolved: isProblemSolved,
        isReportedSolved: isReportedSolved,
        bonusAmount: bonusAmount,
        managerMemo: managerMemo,
        timezone: timezone,
      );
}
