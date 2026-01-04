/// Shift Audit Logs Provider for Attendance Feature
///
/// Re-exports the shift audit logs provider from time_table_manage feature.
/// This allows the attendance feature to use the same RPC and UI components.
library;

// Re-export the provider from time_table_manage
export '../../../time_table_manage/presentation/providers/state/shift_audit_logs_provider.dart';
