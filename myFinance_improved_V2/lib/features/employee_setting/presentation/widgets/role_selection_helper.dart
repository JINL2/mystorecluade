import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myfinance_improved/shared/widgets/common/toss_success_error_dialog.dart';
import 'package:myfinance_improved/shared/widgets/toss/toss_selection_bottom_sheet.dart';

import '../providers/employee_providers.dart';

/// Employee Setting feature role selection helper
///
/// Provides a standardized role selection UI using TossSelectionBottomSheet
class RoleSelectionHelper {
  /// Show role selector bottom sheet
  static Future<bool?> showRoleSelector({
    required BuildContext context,
    required WidgetRef ref,
    required String userId,
    required String? currentRoleName,
    required void Function(String?) onRoleUpdated,
  }) async {
    final rolesAsync = ref.read(rolesProvider);

    return rolesAsync.when(
      data: (roles) async {
        // Filter out current role from available options
        final availableRoles = roles.where((role) {
          return role.roleName != currentRoleName;
        }).toList();

        if (availableRoles.isEmpty) {
          await TossDialogs.showValidationError(
            context: context,
            title: 'No Roles Available',
            message: 'No other roles available to assign',
          );
          return false;
        }

        // Convert roles to TossSelectionItem
        final items = availableRoles.map((role) => TossSelectionItem(
          id: role.roleId,
          title: role.roleName,
          subtitle: role.description,
          icon: Icons.person_outline,
        ),).toList();

        // Show selection bottom sheet
        final selectedItem = await TossSelectionBottomSheet.show<TossSelectionItem>(
          context: context,
          title: 'Manage Role',
          items: items,
          selectedId: null, // No pre-selection since we filtered out current role
          showSearch: true,
          enableHapticFeedback: true,
          maxHeightFraction: 0.8,
        );

        if (selectedItem == null) {
          // User cancelled
          return false;
        }

        // Find the selected role name
        final selectedRole = roles.firstWhere(
          (role) => role.roleId == selectedItem.id,
        );

        // Perform role update
        HapticFeedback.mediumImpact();

        try {
          // Update role in database
          final roleRepository = ref.read(roleRepositoryProvider);
          await roleRepository.updateUserRole(userId, selectedItem.id).timeout(
            const Duration(seconds: 10),
            onTimeout: () {
              throw Exception('Request timed out. Please check your connection and try again.');
            },
          );

          // Callback to update local state
          onRoleUpdated(selectedRole.roleName);

          // Refresh employees data
          await refreshEmployees(ref);

          // Show success dialog
          if (context.mounted) {
            await TossDialogs.showCashEndingSaved(
              context: context,
              message: 'Role updated successfully',
            );
          }

          return true;
        } catch (e) {
          // Show error dialog
          if (context.mounted) {
            await TossDialogs.showValidationError(
              context: context,
              title: 'Failed to Update Role',
              message: e.toString().replaceAll('Exception:', '').trim(),
            );
          }
          return false;
        }
      },
      loading: () async {
        await TossDialogs.showValidationError(
          context: context,
          title: 'Loading',
          message: 'Loading roles...',
        );
        return false;
      },
      error: (error, stack) async {
        await TossDialogs.showValidationError(
          context: context,
          title: 'Error Loading Roles',
          message: 'Failed to load roles: ${error.toString()}',
        );
        return false;
      },
    );
  }
}
