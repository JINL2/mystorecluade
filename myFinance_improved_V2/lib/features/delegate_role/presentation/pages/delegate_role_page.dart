import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:myfinance_improved/app/providers/app_state_provider.dart';
import 'package:myfinance_improved/features/delegate_role/domain/entities/role.dart';
import 'package:myfinance_improved/features/delegate_role/presentation/providers/state/state_providers.dart';
import 'package:myfinance_improved/features/delegate_role/presentation/widgets/create_role_sheet/create_role_sheet.dart';
import 'package:myfinance_improved/features/delegate_role/presentation/widgets/role_card_widget.dart';
import 'package:myfinance_improved/features/delegate_role/presentation/widgets/role_management_sheet.dart';
import 'package:myfinance_improved/features/delegate_role/presentation/widgets/role_stats_header.dart';
import 'package:myfinance_improved/shared/themes/toss_border_radius.dart';
import 'package:myfinance_improved/shared/themes/toss_colors.dart';
import 'package:myfinance_improved/shared/themes/toss_spacing.dart';
import 'package:myfinance_improved/shared/themes/toss_text_styles.dart';
import 'package:myfinance_improved/shared/widgets/common/toss_app_bar_1.dart';
import 'package:myfinance_improved/shared/widgets/common/toss_empty_view.dart';
import 'package:myfinance_improved/shared/widgets/common/toss_error_view.dart';
import 'package:myfinance_improved/shared/widgets/common/toss_loading_view.dart';
import 'package:myfinance_improved/shared/widgets/common/toss_scaffold.dart';
import 'package:myfinance_improved/shared/widgets/common/toss_success_error_dialog.dart';
import 'package:myfinance_improved/shared/widgets/toss/toss_primary_button.dart';

/// Delegate Role Page - Modern UI
///
/// Features:
/// - Modern role cards with stats badges
/// - Clean header with search
/// - Smooth animations and interactions
/// - Multi-step role creation flow

class DelegateRolePage extends ConsumerStatefulWidget {
  const DelegateRolePage({super.key});

  @override
  ConsumerState<DelegateRolePage> createState() => _DelegateRolePageState();
}

class _DelegateRolePageState extends ConsumerState<DelegateRolePage> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() => _searchQuery = _searchController.text.toLowerCase());
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appState = ref.watch(appStateProvider);

    if (appState.companyChoosen.isEmpty) {
      return _buildNoCompanyView();
    }

    final allRolesAsync = ref.watch(
      allCompanyRolesProvider(
        CompanyRolesParams(
          companyId: appState.companyChoosen,
          userId: appState.userId,
        ),
      ),
    );

    return TossScaffold(
      backgroundColor: TossColors.background,
      appBar: TossAppBar1(
        title: 'Team Roles',
        backgroundColor: TossColors.background,
        primaryActionText: 'Add',
        primaryActionIcon: Icons.add,
        onPrimaryAction: _showCreateRoleSheet,
      ),
      body: RefreshIndicator(
        onRefresh: () => _handleRefresh(ref),
        color: TossColors.primary,
        child: allRolesAsync.when(
          data: (roles) => _buildRolesContent(roles),
          loading: () => const TossLoadingView(message: 'Loading roles...'),
          error: (error, stack) => TossErrorView(
            error: error,
            title: 'Failed to load roles',
            onRetry: () => ref.invalidate(allCompanyRolesProvider),
          ),
        ),
      ),
    );
  }

  Widget _buildNoCompanyView() {
    return TossScaffold(
      appBar: const TossAppBar1(
        title: 'Role Delegation',
        backgroundColor: TossColors.background,
      ),
      body: Center(
        child: TossEmptyView(
          icon: const Icon(
            Icons.business_outlined,
            size: 64,
            color: TossColors.gray600,
          ),
          title: 'No company selected',
          description: 'Please select a company to manage role delegations',
          action: TossPrimaryButton(
            text: 'Go to Home',
            onPressed: () => context.go('/'),
          ),
        ),
      ),
    );
  }

  Widget _buildRolesContent(List<Role> roles) {
    if (roles.isEmpty) {
      return _buildEmptyState();
    }

    final filteredRoles = _searchQuery.isEmpty
        ? roles
        : roles.where((role) => role.roleName.toLowerCase().contains(_searchQuery)).toList();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(TossSpacing.space4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with search
          RoleStatsHeader(
            searchController: _searchController,
            onSearchChanged: (value) {
              setState(() => _searchQuery = value.toLowerCase());
            },
            onClear: () {
              setState(() => _searchQuery = '');
            },
            totalRoles: roles.length,
          ),
          const SizedBox(height: TossSpacing.space4),

          // Roles list
          if (filteredRoles.isEmpty && _searchQuery.isNotEmpty)
            _buildNoSearchResults()
          else
            _buildRolesList(filteredRoles),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(TossSpacing.space10),
        child: TossEmptyView(
          icon: const Icon(
            Icons.people_outline,
            size: 64,
            color: TossColors.gray600,
          ),
          title: 'No team roles yet',
          description: 'Roles will appear here once they\'re created\nfor your company',
        ),
      ),
    );
  }

  Widget _buildNoSearchResults() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(TossSpacing.space10),
        child: Column(
          children: [
            const Icon(
              Icons.search_off,
              size: 48,
              color: TossColors.gray500,
            ),
            const SizedBox(height: TossSpacing.space4),
            Text(
              'No roles found',
              style: TossTextStyles.h4.copyWith(
                color: TossColors.gray900,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: TossSpacing.space2),
            Text(
              'Try a different search term',
              style: TossTextStyles.body.copyWith(
                color: TossColors.gray600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRolesList(List<Role> roles) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Team Roles',
              style: TossTextStyles.body.copyWith(
                fontWeight: FontWeight.w600,
                color: TossColors.gray600,
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: TossSpacing.space3,
                vertical: TossSpacing.space2,
              ),
              decoration: BoxDecoration(
                color: TossColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(TossBorderRadius.full),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.group, size: 16, color: TossColors.primary),
                  const SizedBox(width: TossSpacing.space1),
                  Text(
                    roles.length.toString(),
                    style: TossTextStyles.bodyLarge.copyWith(
                      color: TossColors.primary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: TossSpacing.space3),
        ...roles.map((role) {
          final isOwnerRole = role.roleName.toLowerCase() == 'owner';
          return RoleCardWidget(
            role: role,
            isOwnerRole: isOwnerRole,
            onTap: isOwnerRole ? null : () => _openRoleManagement(role),
          );
        }),
      ],
    );
  }

  Future<void> _handleRefresh(WidgetRef ref) async {
    try {
      ref.invalidate(allCompanyRolesProvider);

      if (mounted) {
        await showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => TossDialog.success(
            title: 'Roles Refreshed!',
            message: 'All roles have been successfully refreshed',
            primaryButtonText: 'Done',
            onPrimaryPressed: () => context.pop(),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        await showDialog(
          context: context,
          barrierDismissible: true,
          builder: (context) => TossDialog.error(
            title: 'Failed to Refresh',
            message: 'Could not refresh roles: ${e.toString()}',
            primaryButtonText: 'OK',
            onPrimaryPressed: () => context.pop(),
          ),
        );
      }
    }
  }

  void _openRoleManagement(Role role) {
    final roleName = role.roleName.toLowerCase();
    final bool canEditPermissions = roleName != 'owner';

    RoleManagementSheet.show(
      context,
      roleId: role.roleId,
      roleName: role.roleName,
      description: role.description,
      tags: role.tags,
      permissions: role.permissions,
      memberCount: role.memberCount ?? 0,
      canEdit: canEditPermissions,
      canDelegate: role.canDelegate,
    );
  }

  void _showCreateRoleSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: TossColors.transparent,
      enableDrag: true,
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Container(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height -
                MediaQuery.of(context).viewInsets.bottom -
                MediaQuery.of(context).padding.top -
                100,
            minHeight: 300,
          ),
          child: const CreateRoleSheet(),
        ),
      ),
    );
  }
}
