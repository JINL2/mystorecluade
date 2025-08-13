import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'providers/delegate_role_providers.dart';
import 'widgets/delegation_list_item.dart';
import 'widgets/create_delegation_bottom_sheet.dart';
import 'widgets/role_delegation_summary.dart';
import 'widgets/role_card.dart';
import 'widgets/role_management_sheet.dart';
import '../../providers/app_state_provider.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/common/toss_scaffold.dart';
import '../../widgets/common/toss_app_bar.dart';
import '../../widgets/common/toss_loading_view.dart';
import '../../widgets/common/toss_error_view.dart';
import '../../widgets/common/toss_empty_view.dart';
import '../../../core/themes/toss_colors.dart';
import '../../../core/themes/toss_text_styles.dart';
import '../../../core/themes/toss_spacing.dart';
import '../../../core/themes/toss_border_radius.dart';

class DelegateRolePage extends ConsumerStatefulWidget {
  const DelegateRolePage({super.key});

  @override
  ConsumerState<DelegateRolePage> createState() => _DelegateRolePageState();
}

class _DelegateRolePageState extends ConsumerState<DelegateRolePage> with WidgetsBindingObserver {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text.toLowerCase();
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // Handle app lifecycle changes if needed
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    // Watch the app state and providers
    final allRolesAsync = ref.watch(allCompanyRolesProvider);
    final appState = ref.watch(appStateProvider);
    
    // Check if company is selected
    if (appState.companyChoosen.isEmpty) {
      return TossScaffold(
        appBar: const TossAppBar(title: 'Role Delegation'),
        body: Center(
          child: TossEmptyView(
            icon: Icon(
              Icons.business_outlined,
              size: 64,
              color: TossColors.gray400,
            ),
            title: 'No company selected',
            description: 'Please select a company to manage role delegations',
            action: ElevatedButton(
              onPressed: () => context.go('/'),
              style: ElevatedButton.styleFrom(
                backgroundColor: TossColors.primary,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(
                  horizontal: TossSpacing.space5,
                  vertical: TossSpacing.space3,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(TossBorderRadius.lg),
                ),
              ),
              child: const Text('Go to Home'),
            ),
          ),
        ),
      );
    }

    return TossScaffold(
      key: _scaffoldKey,
      appBar: TossAppBar(
        title: 'Team Roles',
        actions: [
          IconButton(
            icon: const Icon(Icons.add_circle_outline),
            onPressed: () => CreateDelegationBottomSheet.show(context),
            tooltip: 'Delegate Role',
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () => _handleRefresh(ref),
        color: TossColors.primary,
        child: allRolesAsync.when(
          data: (roles) {
            if (roles.isEmpty) {
              return Center(
                child: Padding(
                  padding: EdgeInsets.all(TossSpacing.space10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          color: TossColors.gray100,
                          borderRadius: BorderRadius.circular(TossBorderRadius.xl),
                        ),
                        child: Icon(
                          Icons.people_outline,
                          size: 40,
                          color: TossColors.gray400,
                        ),
                      ),
                      SizedBox(height: TossSpacing.space6),
                      Text(
                        'No team roles yet',
                        style: TossTextStyles.h3.copyWith(
                          color: TossColors.gray900,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: TossSpacing.space2),
                      Text(
                        'Roles will appear here once they\'re created\nfor your company',
                        textAlign: TextAlign.center,
                        style: TossTextStyles.body.copyWith(
                          color: TossColors.gray600,
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }
            
            // Filter roles based on search query
            final filteredRoles = _searchQuery.isEmpty 
                ? roles 
                : roles.where((role) => 
                    role['roleName'].toString().toLowerCase().contains(_searchQuery)
                  ).toList();

            return Column(
              children: [
                // Page header with context and search
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(TossSpacing.space5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Manage your team\'s access',
                        style: TossTextStyles.h3.copyWith(
                          color: TossColors.gray900,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: TossSpacing.space1),
                      Text(
                        'Delegate roles to team members and manage permissions',
                        style: TossTextStyles.bodySmall.copyWith(
                          color: TossColors.gray600,
                        ),
                      ),
                      
                      // Search bar
                      SizedBox(height: TossSpacing.space4),
                      Container(
                        decoration: BoxDecoration(
                          color: TossColors.gray50,
                          borderRadius: BorderRadius.circular(TossBorderRadius.md),
                          border: Border.all(color: TossColors.gray200),
                        ),
                        child: TextField(
                          controller: _searchController,
                          style: TossTextStyles.body,
                          decoration: InputDecoration(
                            hintText: 'Search roles...',
                            hintStyle: TossTextStyles.body.copyWith(
                              color: TossColors.gray400,
                            ),
                            prefixIcon: Icon(
                              Icons.search,
                              color: TossColors.gray400,
                              size: 20,
                            ),
                            suffixIcon: _searchQuery.isNotEmpty
                                ? IconButton(
                                    icon: Icon(
                                      Icons.clear,
                                      color: TossColors.gray400,
                                      size: 20,
                                    ),
                                    onPressed: () {
                                      _searchController.clear();
                                    },
                                  )
                                : null,
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: TossSpacing.space4,
                              vertical: TossSpacing.space3,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                
                // Roles list
                Expanded(
                  child: filteredRoles.isEmpty && _searchQuery.isNotEmpty
                      ? Center(
                          child: Padding(
                            padding: EdgeInsets.all(TossSpacing.space10),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.search_off,
                                  size: 48,
                                  color: TossColors.gray400,
                                ),
                                SizedBox(height: TossSpacing.space4),
                                Text(
                                  'No roles found',
                                  style: TossTextStyles.h3.copyWith(
                                    color: TossColors.gray700,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                SizedBox(height: TossSpacing.space2),
                                Text(
                                  'Try a different search term',
                                  style: TossTextStyles.body.copyWith(
                                    color: TossColors.gray500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      : ListView.builder(
                          padding: EdgeInsets.only(
                            bottom: TossSpacing.space10,
                          ),
                          itemCount: filteredRoles.length,
                          itemBuilder: (context, index) {
                            final role = filteredRoles[index];
                            return RoleCard(
                              roleId: role['roleId'],
                              roleName: role['roleName'],
                              permissions: List<String>.from(role['permissions']),
                              memberCount: role['memberCount'] ?? 0,
                              canEdit: role['canEdit'],
                              canDelegate: role['canDelegate'],
                              onTap: () => _openRoleManagement(role),
                            );
                          },
                        ),
                ),
              ],
            );
          },
          loading: () => const TossLoadingView(
            message: 'Loading roles...',
          ),
          error: (error, stack) => TossErrorView(
            error: error,
            title: 'Failed to load roles',
            onRetry: () => ref.invalidate(allCompanyRolesProvider),
          ),
        ),
      ),
    );
  }

  Future<void> _handleRefresh(WidgetRef ref) async {
    try {
      // Invalidate providers to refresh data
      ref.invalidate(allCompanyRolesProvider);
      ref.invalidate(activeDelegationsProvider);
      
      // Show success feedback
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Roles refreshed'),
            backgroundColor: TossColors.success,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(TossBorderRadius.sm),
            ),
          ),
        );
      }
    } catch (e) {
      // Show error feedback
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to refresh: ${e.toString()}'),
            backgroundColor: TossColors.error,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(TossBorderRadius.sm),
            ),
          ),
        );
      }
    }
  }

  void _openRoleManagement(Map<String, dynamic> role) {
    RoleManagementSheet.show(
      context,
      roleId: role['roleId'],
      roleName: role['roleName'],
      permissions: List<String>.from(role['permissions']),
      memberCount: role['memberCount'] ?? 0,
      canEdit: role['canEdit'],
      canDelegate: role['canDelegate'],
    );
  }

  void _revokeDelegation(delegation) async {
    // Show confirmation dialog
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Revoke Delegation?',
          style: TossTextStyles.h3,
        ),
        content: Text(
          'Are you sure you want to revoke this delegation? This action cannot be undone.',
          style: TossTextStyles.body,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(TossBorderRadius.lg),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(
              'Cancel',
              style: TossTextStyles.label.copyWith(
                color: TossColors.gray600,
              ),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(
              'Revoke',
              style: TossTextStyles.label.copyWith(
                color: TossColors.error,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
    
    if (confirmed == true) {
      try {
        final revokeDelegation = ref.read(revokeDelegationProvider);
        await revokeDelegation(delegation.id);
        
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Delegation revoked successfully'),
              backgroundColor: TossColors.success,
            ),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed to revoke: ${e.toString()}'),
              backgroundColor: TossColors.error,
            ),
          );
        }
      }
    }
  }
}