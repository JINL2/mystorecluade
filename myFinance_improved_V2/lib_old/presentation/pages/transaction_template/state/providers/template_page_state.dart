/// Template Page State - Page-specific state management for transaction templates
///
/// Purpose: Manages page-specific state and business logic for transaction templates:
/// - Template-specific user permissions and role checks
/// - Template creation/editing/deletion permission logic
/// - Page-specific user context aggregation
/// - Template feature availability based on user role
///
/// Note: This file contains ONLY page-specific logic. For global app state 
/// (user authentication, company/store selection, etc.), use the global 
/// providers from ../../../../providers/app_state_provider.dart
///
/// Usage: ref.watch(canCreateTemplatesProvider), ref.watch(templateUserPermissionsProvider)
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../providers/app_state_provider.dart';

// Page-specific provider to get current user permissions for template operations
final templateUserPermissionsProvider = Provider<List<String>>((ref) {
  final appStateNotifier = ref.read(appStateProvider.notifier);
  
  final selectedCompany = appStateNotifier.selectedCompany;
  if (selectedCompany == null) return [];
  
  final userRole = selectedCompany['role'];
  final permissions = userRole['permissions'] as List<dynamic>? ?? [];
  
  return permissions.cast<String>();
});

// Page-specific provider to check if user has specific permission for template operations
final templateHasPermissionProvider = Provider.family<bool, String>((ref, permissionId) {
  final permissions = ref.watch(templateUserPermissionsProvider);
  return permissions.contains(permissionId);
});

// Page-specific provider to get user role information for template context
final templateUserRoleProvider = Provider<Map<String, dynamic>?>((ref) {
  final appStateNotifier = ref.read(appStateProvider.notifier);
  final selectedCompany = appStateNotifier.selectedCompany;
  
  if (selectedCompany == null) return null;
  
  return selectedCompany['role'] as Map<String, dynamic>?;
});

// Template-specific permission: Check if user can create templates
final canCreateTemplatesProvider = Provider<bool>((ref) {
  // Check if user has Manager permission (original UUID-based approach)
  return ref.watch(templateHasPermissionProvider('c6bc2fc2-e4fc-4893-a7ed-a1afb4202d14'));
});

// Template-specific permission: Check if user can edit templates
final canEditTemplatesProvider = Provider<bool>((ref) {
  // Check if user has Manager permission (original UUID-based approach)
  return ref.watch(templateHasPermissionProvider('c6bc2fc2-e4fc-4893-a7ed-a1afb4202d14'));
});

// Template-specific permission: Check if user can delete templates
final canDeleteTemplatesProvider = Provider<bool>((ref) {
  // Check if user has Manager permission (original UUID-based approach)
  return ref.watch(templateHasPermissionProvider('c6bc2fc2-e4fc-4893-a7ed-a1afb4202d14'));
});

// Page-specific provider for template user context summary
final templateUserContextProvider = Provider<Map<String, dynamic>>((ref) {
  final appState = ref.watch(appStateProvider);
  final userRole = ref.watch(templateUserRoleProvider);
  final permissions = ref.watch(templateUserPermissionsProvider);
  
  return {
    'company_id': appState.companyChoosen,
    'store_id': appState.storeChoosen,
    'user_role': userRole?['role_name'] ?? 'Unknown',
    'permissions_count': permissions.length,
    'can_create_templates': ref.watch(canCreateTemplatesProvider),
    'can_edit_templates': ref.watch(canEditTemplatesProvider),
    'can_delete_templates': ref.watch(canDeleteTemplatesProvider),
  };
});

// Template-specific provider: Check if user has admin permission for template management
final templateHasAdminPermissionProvider = Provider<bool>((ref) {
  return ref.watch(templateHasPermissionProvider('c6bc2fc2-e4fc-4893-a7ed-a1afb4202d14'));
});

// Template-specific provider: Get permission level for template visibility
final templatePermissionLevelProvider = Provider<String>((ref) {
  final hasAdmin = ref.watch(templateHasAdminPermissionProvider);
  return hasAdmin ? 'admin' : 'user';
});

// Template-specific provider: Check if user can access admin templates
final canAccessAdminTemplatesProvider = Provider<bool>((ref) {
  return ref.watch(templateHasAdminPermissionProvider);
});