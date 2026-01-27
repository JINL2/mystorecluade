import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:myfinance_improved/shared/widgets/index.dart';

import '../../../../app/providers/app_state_provider.dart';
import '../../data/repositories/repository_providers.dart';
import '../../domain/entities/role.dart';
import '../providers/employee_providers.dart';

/// Employee Setting feature role selection helper
///
/// Provides a standardized role selection UI using SelectionBottomSheetCommon
class RoleSelectionHelper {
  /// Show role selector bottom sheet
  static Future<bool?> showRoleSelector({
    required BuildContext context,
    required WidgetRef ref,
    required String userId,
    required String? currentRoleName,
    required void Function(String?) onRoleUpdated,
  }) async {
    // Show loading dialog while fetching roles
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: TossLoadingView(),
      ),
    );

    try {
      // Wait for roles to load from unified provider
      final settingData = await ref.read(
        employeeSettingDataProvider(const EmployeeSettingDataParams()).future,
      );
      final roles = settingData.roles;

      // Close loading dialog
      if (context.mounted) {
        context.pop();
      }

      if (!context.mounted) return false;

      return await _showRoleSelectionSheet(
        context: context,
        ref: ref,
        userId: userId,
        currentRoleName: currentRoleName,
        onRoleUpdated: onRoleUpdated,
        roles: roles,
      );
    } catch (error) {
      // Close loading dialog
      if (context.mounted) {
        context.pop();
      }

      // Show error dialog
      if (context.mounted) {
        await TossDialogs.showValidationError(
          context: context,
          title: 'Error Loading Roles',
          message: 'Failed to load roles: ${error.toString()}',
        );
      }
      return false;
    }
  }

  static Future<bool?> _showRoleSelectionSheet({
    required BuildContext context,
    required WidgetRef ref,
    required String userId,
    required String? currentRoleName,
    required void Function(String?) onRoleUpdated,
    required List<Role> roles,
  }) async {
    // Filter out current role and Owner role from available options
    final availableRoles = roles.where((role) {
      // Exclude current role
      if (role.roleName == currentRoleName) return false;
      // Exclude Owner role - Owner cannot be assigned through UI
      if (role.roleType.toLowerCase() == 'owner') return false;
      return true;
    }).toList();

    if (availableRoles.isEmpty) {
      await TossDialogs.showValidationError(
        context: context,
        title: 'No Roles Available',
        message: 'No other roles available to assign',
      );
      return false;
    }

    // Convert roles to SelectionItem
    final items = availableRoles.map((role) => SelectionItem(
      id: role.roleId,
      title: role.roleName,
      subtitle: role.description,
      icon: Icons.person_outline,
    ),).toList();

    // Show selection bottom sheet
    SelectionItem? selectedItem;
    await SelectionBottomSheetCommon.show<void>(
      context: context,
      title: 'Manage Role',
      showSearch: true,
      maxHeightRatio: 0.8,
      itemCount: items.length,
      itemBuilder: (ctx, index) {
        final item = items[index];
        return SelectionListItem(
          item: item,
          isSelected: false, // No pre-selection since we filtered out current role
          variant: SelectionItemVariant.standard,
          enableHaptic: true,
          onTap: () {
            selectedItem = item;
            Navigator.pop(ctx);
          },
        );
      },
    );

    if (selectedItem == null) {
      // User cancelled
      return false;
    }

    // Find the selected role name
    final selectedRole = roles.firstWhere(
      (role) => role.roleId == selectedItem!.id,
    );

    // Perform role update
    HapticFeedback.mediumImpact();

    try {
      // Show loading dialog
      if (!context.mounted) return false;
      showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(
          child: TossLoadingView(),
        ),
      );

      // Get companyId from app state
      final appState = ref.read(appStateProvider);
      final companyId = appState.companyChoosen;

      if (companyId.isEmpty) {
        throw Exception('No company selected. Please select a company first.');
      }

      // Update role in database using unified RPC
      final roleRepository = ref.read(roleRepositoryProvider);
      await roleRepository
          .updateUserRole(
            companyId: companyId,
            userId: userId,
            roleId: selectedItem!.id,
          )
          .timeout(
            const Duration(seconds: 10),
            onTimeout: () {
              throw Exception(
                'Request timed out. Please check your connection and try again.',
              );
            },
          );

      // Close loading dialog
      if (!context.mounted) return false;
      context.pop();

      // Optimistic Update: Update mutableEmployeeListProvider directly for instant UI refresh
      // This is the 2025+ Riverpod best practice - no need to invalidate/refresh entire list
      onRoleUpdated(selectedRole.roleName);

      // Show success dialog
      if (!context.mounted) return false;
      await TossDialogs.showCashEndingSaved(
        context: context,
        message: 'Role updated successfully',
      );

      return true;
    } catch (e) {
      // Close loading dialog
      if (!context.mounted) return false;
      context.pop();

      // Show error dialog
      if (!context.mounted) return false;
      await TossDialogs.showValidationError(
        context: context,
        title: 'Failed to Update Role',
        message: e.toString().replaceAll('Exception:', '').trim(),
      );
      return false;
    }
  }
}
