/// Shift Audit Logs Provider
///
/// Provides shift audit log data for a specific shift request.
/// Uses FutureProvider.family for caching by shiftRequestId.
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../domain/entities/shift_audit_log.dart';
import '../repository_providers.dart';

/// Shift Audit Logs Provider
///
/// Fetches audit logs for a specific shift request ID.
/// Returns empty list if shiftRequestId is null or empty.
///
/// Uses shared repository provider for Clean Architecture compliance.
///
/// Usage:
/// ```dart
/// final logsAsync = ref.watch(shiftAuditLogsProvider(shiftRequestId));
/// logsAsync.when(
///   data: (logs) => ...,
///   loading: () => ...,
///   error: (e, st) => ...,
/// );
/// ```
final shiftAuditLogsProvider = FutureProvider.family
    .autoDispose<List<ShiftAuditLog>, String?>((ref, shiftRequestId) async {
  if (shiftRequestId == null || shiftRequestId.isEmpty) {
    return [];
  }

  final repository = ref.watch(timeTableRepositoryProvider);

  return repository.getShiftAuditLogs(
    shiftRequestId: shiftRequestId,
  );
});
