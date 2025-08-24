import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import '../delegate_role/providers/delegate_role_providers.dart';
import '../delegate_role/widgets/role_management_sheet.dart';
import '../../providers/app_state_provider.dart';
import '../../widgets/common/toss_scaffold.dart';
import '../../widgets/common/toss_app_bar.dart';
import '../../widgets/common/toss_loading_view.dart';
import '../../widgets/common/toss_error_view.dart';
import '../../widgets/common/toss_empty_view.dart';
import '../../widgets/toss/toss_search_field.dart';
import '../../widgets/toss/toss_primary_button.dart';
import '../../widgets/toss/toss_secondary_button.dart';
import '../../widgets/toss/toss_text_field.dart';
import '../../widgets/toss/toss_checkbox.dart';
import '../../../core/themes/toss_colors.dart';
import '../../../core/themes/toss_text_styles.dart';
import '../../../core/themes/toss_spacing.dart';
import '../../../core/themes/toss_border_radius.dart';
import '../../../core/themes/toss_shadows.dart';
import '../../../core/themes/toss_animations.dart';

class RolePermissionPage extends ConsumerStatefulWidget {
  const RolePermissionPage({super.key});

  @override
  ConsumerState<RolePermissionPage> createState() => _RolePermissionPageState();
}

class _RolePermissionPageState extends ConsumerState<RolePermissionPage> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  String _searchQuery = '';
  List<Map<String, dynamic>> _reorderableRoles = [];

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text.toLowerCase();
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _deleteRole(Map<String, dynamic> role) async {
    final roleName = role['roleName']?.toString().toLowerCase() ?? '';
    
    // Prevent deleting Owner or Employee roles
    if (roleName == 'owner') {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Cannot delete the Owner role. This role always has full permissions.'),
          backgroundColor: TossColors.error,
        ),
      );
      return;
    }
    
    if (roleName == 'employee') {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Cannot delete the Employee role. This is a default system role.'),
          backgroundColor: TossColors.error,
        ),
      );
      return;
    }
    
    final memberCount = role['memberCount'] ?? 0;
    
    // Show confirmation dialog
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete Role'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Are you sure you want to delete "${role['roleName']}"?'),
            SizedBox(height: TossSpacing.space2),
            if (memberCount > 0) ...[
              Text(
                'This role has $memberCount user${memberCount > 1 ? 's' : ''} assigned. They will be reassigned to the "Employee" role.',
                style: TossTextStyles.caption.copyWith(
                  color: TossColors.warning,
                ),
              ),
              SizedBox(height: TossSpacing.space2),
            ],
            Text(
              'This action cannot be undone.',
              style: TossTextStyles.bodySmall.copyWith(
                color: TossColors.error,
              ),
            ),
          ],
        ),
        actions: [
          TossSecondaryButton(
            onPressed: () => Navigator.pop(context, false),
            text: 'Cancel',
          ),
          TossSecondaryButton(
            onPressed: () => Navigator.pop(context, true),
            text: 'Delete Role',
          ),
        ],
      ),
    );
    
    if (confirm == true) {
      // Remove from UI immediately
      setState(() {
        _reorderableRoles.removeWhere((r) => r['roleId'] == role['roleId']);
      });
      
      try {
        // Delete from database
        final deleteRole = ref.read(deleteRoleProvider);
        await deleteRole(role['roleId']);
        
        // Show success message
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Role "${role['roleName']}" deleted successfully'),
              backgroundColor: TossColors.primary,
            ),
          );
        }
      } catch (e) {
        // If deletion fails, restore the role in the UI
        if (mounted) {
          setState(() {
            _reorderableRoles.add(role);
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed to delete role: ${e.toString()}'),
              backgroundColor: TossColors.error,
            ),
          );
        }
      }
    }
  }




  @override
  Widget build(BuildContext context) {
    // Watch the app state and providers
    final allRolesAsync = ref.watch(allCompanyRolesProvider);
    final appState = ref.watch(appStateProvider);
    
    // Check if company is selected
    if (appState.companyChoosen.isEmpty) {
      return TossScaffold(
        backgroundColor: TossColors.gray100,
        body: SafeArea(
          child: Column(
            children: [
              // Header
              Container(
                height: 56,
                padding: EdgeInsets.symmetric(horizontal: TossSpacing.space2),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back_ios),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                    Expanded(
                      child: Text(
                        'Roles & Permissions',
                        style: TossTextStyles.h3,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(width: 48),
                  ],
                ),
              ),
              // Content
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          color: TossColors.gray100,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Icon(
                          Icons.business_outlined,
                          size: 40,
                          color: TossColors.textTertiary,
                        ),
                      ),
                      SizedBox(height: TossSpacing.space6),
                      Text(
                        'No company selected',
                        style: TossTextStyles.h3,
                      ),
                      SizedBox(height: TossSpacing.space2),
                      Text(
                        'Please select a company to\nmanage roles and permissions',
                        textAlign: TextAlign.center,
                        style: TossTextStyles.caption.copyWith(
                          color: TossColors.textSecondary,
                        ),
                      ),
                      SizedBox(height: TossSpacing.space6),
                      TossPrimaryButton(
                        onPressed: () => context.go('/'),
                        text: 'Go to Home',
                        fullWidth: true,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return TossScaffold(
      appBar: TossAppBar(
        title: 'Roles & Permissions',
        primaryActionText: 'Add',
        primaryActionIcon: Icons.add,
        onPrimaryAction: () => _showCreateRoleModal(context),
      ),
      body: Column(
        children: [
          // Content
          Expanded(
              child: RefreshIndicator(
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
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Icon(
                                  Icons.admin_panel_settings_outlined,
                                  size: 40,
                                  color: TossColors.textTertiary,
                                ),
                              ),
                              SizedBox(height: TossSpacing.space6),
                              Text(
                                'No roles created yet',
                                style: TossTextStyles.h3,
                              ),
                              SizedBox(height: TossSpacing.space2),
                              Text(
                                'Create roles and manage permissions\nfor your team members',
                                textAlign: TextAlign.center,
                                style: TossTextStyles.caption.copyWith(
                                  color: TossColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }
            
                    // Initialize reorderable roles if needed
                    if (_reorderableRoles.isEmpty || _reorderableRoles.length != roles.length) {
                      _reorderableRoles = List.from(roles);
                    }

                    // Filter roles based on search query
                    final filteredRoles = _searchQuery.isEmpty 
                        ? _reorderableRoles 
                        : _reorderableRoles.where((role) => 
                            role['roleName'].toString().toLowerCase().contains(_searchQuery)
                          ).toList();

                    return Column(
                      children: [
                        // Search bar using TossSearchField component
                        Container(
                          color: TossColors.gray100,
                          padding: EdgeInsets.symmetric(
                            horizontal: TossSpacing.space4,
                            vertical: TossSpacing.space3,
                          ),
                          child: TossSearchField(
                            hintText: 'Search roles...',
                            controller: _searchController,
                            prefixIcon: Icons.search,
                            onChanged: (value) {
                              setState(() {
                                _searchQuery = value;
                              });
                            },
                            onClear: () {
                              setState(() {
                                _searchQuery = '';
                              });
                            },
                          ),
                        ),
                        
                        SizedBox(height: TossSpacing.space3),
                
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
                                          color: TossColors.textTertiary,
                                        ),
                                        SizedBox(height: TossSpacing.space4),
                                        Text(
                                          'No roles found',
                                          style: TossTextStyles.h3,
                                        ),
                                        SizedBox(height: TossSpacing.space2),
                                        Text(
                                          'Try a different search term',
                                          style: TossTextStyles.caption.copyWith(
                                            color: TossColors.textSecondary,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                              : SingleChildScrollView(
                                      controller: _scrollController,
                                      physics: const AlwaysScrollableScrollPhysics(),
                                      padding: EdgeInsets.only(
                                        left: TossSpacing.space4,
                                        right: TossSpacing.space4,
                                        top: TossSpacing.space2,
                                        bottom: TossSpacing.space10,
                                      ),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: TossColors.surface,
                                          borderRadius: BorderRadius.circular(TossBorderRadius.lg),
                                          boxShadow: TossShadows.card,
                                        ),
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(TossBorderRadius.lg),
                                          child: Column(
                                            children: filteredRoles.map((role) {
                                              final roleId = role['roleId'] ?? '';
                                              final roleName = role['roleName']?.toString().toLowerCase() ?? '';
                                              final memberCount = role['memberCount'] ?? 0;
                                              final permissions = role['permissions'] as List? ?? [];
                                              final isLast = filteredRoles.last == role;
                                              
                                              // Check if role is protected (Owner or Employee cannot be deleted)
                                              final isProtected = roleName == 'owner' || roleName == 'employee';
                                              
                                              return Column(
                                                key: ValueKey(roleId),
                                                children: [
                                                  Slidable(
                                                    enabled: !isProtected, // Disable swipe for protected roles
                                                    endActionPane: !isProtected ? ActionPane(
                                                      motion: const DrawerMotion(),
                                                      extentRatio: 0.15,
                                                      children: [
                                                        CustomSlidableAction(
                                                          onPressed: (_) => _deleteRole(role),
                                                          backgroundColor: Colors.transparent,
                                                          child: Container(
                                                            alignment: Alignment.center,
                                                            child: Container(
                                                              width: 32,
                                                              height: 32,
                                                              decoration: BoxDecoration(
                                                                color: TossColors.error,
                                                                shape: BoxShape.circle,
                                                              ),
                                                              child: Icon(
                                                                Icons.remove,
                                                                color: TossColors.textInverse,
                                                                size: 20,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ) : null, // No swipe action for protected roles
                                                    child: Material(
                                                      color: TossColors.white,
                                                      child: InkWell(
                                                        onTap: roleName == 'owner' ? null : () => _openRoleManagement(role),
                                                        child: Container(
                                                          padding: EdgeInsets.symmetric(
                                                            horizontal: TossSpacing.space4,
                                                            vertical: TossSpacing.space3,
                                                          ),
                                                          child: Row(
                                                            children: [
                                                              // Content
                                                              Expanded(
                                                                child: Column(
                                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                                  children: [
                                                                    Text(
                                                                      role['roleName'],
                                                                      style: TossTextStyles.bodyLarge.copyWith(
                                                                        fontWeight: FontWeight.w600,
                                                                        color: roleName == 'owner' ? TossColors.textSecondary : TossColors.textPrimary,
                                                                      ),
                                                                    ),
                                                                    SizedBox(height: 2),
                                                                    Text(
                                                                      roleName == 'owner' 
                                                                          ? 'System administrator • Full permissions'
                                                                          : '$memberCount users • ${permissions.length} permissions',
                                                                      style: TossTextStyles.caption.copyWith(
                                                                        color: TossColors.textTertiary,
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                              // Chevron pointing left (hide for Owner and Employee)
                                                              if (roleName != 'owner' && roleName != 'employee')
                                                                Icon(
                                                                  Icons.chevron_left,
                                                                  color: TossColors.textTertiary,
                                                                  size: 22,
                                                                ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  if (!isLast)
                                                    Container(
                                                      margin: EdgeInsets.symmetric(horizontal: TossSpacing.space4),
                                                      height: 0.5,
                                                      color: TossColors.borderLight,
                                                    ),
                                                ],
                                              );
                                            }).toList(),
                                          ),
                                        ),
                                      ),
                                    ),
                        ),
                      ],
                    );
                  },
                  loading: () => const TossLoadingView(),
                  error: (error, stack) => Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Failed to load roles',
                          style: TossTextStyles.body.copyWith(
                            color: TossColors.textTertiary,
                          ),
                        ),
                        SizedBox(height: TossSpacing.space3),
                        TossSecondaryButton(
                          onPressed: () => ref.invalidate(allCompanyRolesProvider),
                          text: 'Retry',
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Future<void> _handleRefresh(WidgetRef ref) async {
    // Invalidate all relevant providers to force a refresh
    ref.invalidate(allCompanyRolesProvider);
    ref.invalidate(delegatableRolesProvider);
    ref.invalidate(activeDelegationsProvider);
  }

  void _openRoleManagement(Map<String, dynamic> role) {
    final roleName = role['roleName']?.toString().toLowerCase() ?? '';
    
    // For Owner role, allow user management but not permission editing
    final bool canEditPermissions = roleName != 'owner';
    
    RoleManagementSheet.show(
      context,
      roleId: role['roleId'],
      roleName: role['roleName'],
      description: role['description'],
      tags: List<String>.from(role['tags'] ?? []),
      permissions: List<String>.from(role['permissions']),
      memberCount: role['memberCount'] ?? 0,
      canEdit: canEditPermissions, // Owner can manage users but not permissions
      canDelegate: role['canDelegate'],
    );
  }


  void _showCreateRoleModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _CreateRoleBottomSheet(),
    );
  }
}

// Simple Create Role Bottom Sheet
class _CreateRoleBottomSheet extends ConsumerStatefulWidget {
  @override
  ConsumerState<_CreateRoleBottomSheet> createState() => _CreateRoleBottomSheetState();
}

class _CreateRoleBottomSheetState extends ConsumerState<_CreateRoleBottomSheet> {
  final TextEditingController _roleNameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  bool _isCreating = false;
  int _currentStep = 0; // 0: Basic Info, 1: Permissions
  final Set<String> _selectedPermissions = {};
  final Set<String> _expandedCategories = {};

  @override
  void dispose() {
    _roleNameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.8,
        minHeight: MediaQuery.of(context).size.height * 0.5,
      ),
      decoration: BoxDecoration(
        color: TossColors.white,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(TossBorderRadius.xxl),
        ),
      ),
      child: IntrinsicHeight(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle bar
            Container(
              margin: EdgeInsets.only(top: TossSpacing.space3),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: TossColors.border,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            
            // Header
            Padding(
              padding: EdgeInsets.all(TossSpacing.space5),
              child: Row(
                children: [
                  if (_currentStep > 0)
                    IconButton(
                      icon: Icon(Icons.arrow_back, color: TossColors.textSecondary),
                      onPressed: () {
                        setState(() {
                          _currentStep--;
                        });
                      },
                    ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _currentStep == 0 ? 'Create New Role' : 'Configure Permissions',
                          style: TossTextStyles.h3,
                        ),
                        SizedBox(height: TossSpacing.space1),
                        Text(
                          _currentStep == 0 
                              ? 'Define a new role with specific permissions'
                              : 'Select what this role can access and do',
                          style: TossTextStyles.caption.copyWith(
                            color: TossColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.close, color: TossColors.textSecondary),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),
            
            // Step indicator
            if (_currentStep == 0) ...[
              Container(
                padding: EdgeInsets.symmetric(horizontal: TossSpacing.space5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildStepIndicator(0, true),
                    Container(
                      width: 40,
                      height: 2,
                      color: TossColors.borderLight,
                    ),
                    _buildStepIndicator(1, false),
                  ],
                ),
              ),
              SizedBox(height: TossSpacing.space3),
            ],
            
            // Form content
            Flexible(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height * 0.5,
                ),
                child: _currentStep == 0
                    ? _buildBasicInfoStep()
                    : _buildPermissionsStep(),
              ),
            ),
            
            // Bottom action
            Container(
              padding: EdgeInsets.all(TossSpacing.space5),
              decoration: BoxDecoration(
                color: TossColors.white,
                border: Border(top: BorderSide(color: TossColors.borderLight)),
              ),
              child: SafeArea(
                top: false,
                child: TossPrimaryButton(
                  onPressed: _isCreating ? null : (_currentStep == 0 ? _goToNextStep : _createRole),
                  isLoading: _isCreating,
                  text: _currentStep == 0 ? 'Next' : 'Create Role',
                  fullWidth: true,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStepIndicator(int step, bool isActive) {
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        color: isActive ? TossColors.primary : TossColors.borderLight,
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          '${step + 1}',
          style: TossTextStyles.body.copyWith(
            color: isActive ? TossColors.textInverse : TossColors.textSecondary,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _buildBasicInfoStep() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(TossSpacing.space5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Role name input
          Text(
            'Role Name',
            style: TossTextStyles.labelLarge.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: TossSpacing.space2),
          TossTextField(
            controller: _roleNameController,
            hintText: 'Enter role name',
          ),
          
          SizedBox(height: TossSpacing.space5),
          
          // Description input
          Text(
            'Description',
            style: TossTextStyles.labelLarge.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: TossSpacing.space2),
          TossTextField(
            controller: _descriptionController,
            hintText: 'Describe what this role does...',
            maxLines: 3,
          ),
        ],
      ),
    );
  }

  Widget _buildPermissionsStep() {
    final allFeaturesAsync = ref.watch(allFeaturesProvider);
    
    return allFeaturesAsync.when(
      data: (categories) {
        return SingleChildScrollView(
          padding: EdgeInsets.all(TossSpacing.space5),
          child: Column(
            children: [
              // Quick actions
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Select Permissions',
                    style: TossTextStyles.h4.copyWith(
                      fontWeight: FontWeight.w700,
                      color: TossColors.textPrimary,
                    ),
                  ),
                  TossSecondaryButton(
                    onPressed: () {
                      setState(() {
                        _selectedPermissions.clear();
                      });
                    },
                    text: 'Clear all',
                  ),
                ],
              ),
              SizedBox(height: TossSpacing.space3),
              // Permission categories
              ...categories.map((category) {
                final categoryName = category['category_name'] as String;
                final features = (category['features'] as List? ?? [])
                    .cast<Map<String, dynamic>>();
                
                if (features.isEmpty) return SizedBox.shrink();
                
                return _buildPermissionCategory(categoryName, features);
              }).toList(),
            ],
          ),
        );
      },
      loading: () => const TossLoadingView(),
      error: (error, stack) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, color: TossColors.error, size: 48),
            SizedBox(height: TossSpacing.space3),
            Text(
              'Failed to load permissions',
              style: TossTextStyles.body.copyWith(color: TossColors.error),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPermissionCategory(String title, List<Map<String, dynamic>> features) {
    final isExpanded = _expandedCategories.contains(title);
    final featureIds = features.map((f) => f['feature_id'] as String).toList();
    final selectedCount = featureIds.where((id) => _selectedPermissions.contains(id)).length;
    final allSelected = selectedCount == features.length && features.isNotEmpty;
    final someSelected = selectedCount > 0 && selectedCount < features.length;
    
    return Container(
      margin: EdgeInsets.only(bottom: TossSpacing.space3),
      decoration: BoxDecoration(
        color: TossColors.white,
        borderRadius: BorderRadius.circular(TossBorderRadius.lg),
        boxShadow: TossShadows.card,
      ),
      child: Column(
        children: [
          // Collapsible header
          Material(
            color: Colors.transparent,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(TossBorderRadius.lg),
              bottom: Radius.circular(isExpanded ? 0 : TossBorderRadius.lg),
            ),
            child: InkWell(
              onTap: () {
                setState(() {
                  if (isExpanded) {
                    _expandedCategories.remove(title);
                  } else {
                    _expandedCategories.add(title);
                  }
                });
              },
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(TossBorderRadius.lg),
                bottom: Radius.circular(isExpanded ? 0 : TossBorderRadius.lg),
              ),
              child: Container(
                padding: EdgeInsets.all(TossSpacing.space4),
                child: Row(
                  children: [
                    // Select all checkbox
                    Material(
                      color: TossColors.transparent,
                      child: InkWell(
                        onTap: () {
                          _toggleCategoryPermissions(featureIds, !allSelected);
                        },
                        borderRadius: BorderRadius.circular(6),
                        child: Padding(
                          padding: EdgeInsets.all(4),
                          child: AnimatedContainer(
                            duration: TossAnimations.normal,
                            width: 20,
                            height: 20,
                            decoration: BoxDecoration(
                              color: allSelected
                                  ? TossColors.primary
                                  : someSelected
                                      ? TossColors.primary.withValues(alpha: 0.3)
                                      : TossColors.surface,
                              border: Border.all(
                                color: allSelected || someSelected
                                    ? TossColors.primary
                                    : TossColors.border!,
                                width: allSelected || someSelected ? 2 : 1,
                              ),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: allSelected
                                ? Icon(
                                    Icons.check,
                                    size: 14,
                                    color: TossColors.white,
                                  )
                                : someSelected
                                    ? Center(
                                        child: Container(
                                          width: 8,
                                          height: 2,
                                          color: TossColors.white,
                                        ),
                                      )
                                    : null,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: TossSpacing.space3),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            style: TossTextStyles.bodyLarge.copyWith(
                              fontWeight: FontWeight.w600,
                              color: TossColors.textPrimary,
                            ),
                          ),
                          if (selectedCount > 0) ...[
                            SizedBox(height: TossSpacing.space1),
                            Text(
                              '$selectedCount of ${features.length} selected',
                              style: TossTextStyles.caption.copyWith(
                                color: TossColors.textSecondary,
                                            ),
                            ),
                          ],
                        ],
                      ),
                    ),
                    AnimatedRotation(
                      turns: isExpanded ? 0.5 : 0,
                      duration: TossAnimations.normal,
                      child: Icon(
                        Icons.expand_more,
                        color: TossColors.textTertiary,
                        size: 22,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          
          // Expanded content
          if (isExpanded) ...[ 
            Container(
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(color: TossColors.borderLight, width: 0.5),
                ),
              ),
              child: Column(
                children: features.asMap().entries.map((entry) {
                  final index = entry.key;
                  final feature = entry.value;
                  final featureId = feature['feature_id'] as String;
                  final featureName = feature['feature_name'] as String;
                  final isSelected = _selectedPermissions.contains(featureId);
                  final isLast = index == features.length - 1;
                  
                  return Column(
                    children: [
                      Material(
                        color: TossColors.transparent,
                        child: InkWell(
                          onTap: () => _togglePermission(featureId),
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: TossSpacing.space4,
                              vertical: TossSpacing.space3,
                            ),
                            child: Row(
                              children: [
                                SizedBox(width: TossSpacing.space6),
                                AnimatedContainer(
                                  duration: TossAnimations.normal,
                                  width: 20,
                                  height: 20,
                                  decoration: BoxDecoration(
                                    color: isSelected
                                        ? TossColors.primary
                                        : TossColors.surface,
                                    border: Border.all(
                                      color: isSelected
                                          ? TossColors.primary
                                          : TossColors.border!,
                                      width: isSelected ? 2 : 1,
                                    ),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: isSelected
                                      ? Icon(
                                          Icons.check,
                                          size: 14,
                                          color: TossColors.white,
                                        )
                                      : null,
                                ),
                                SizedBox(width: TossSpacing.space3),
                                Expanded(
                                  child: Text(
                                    featureName,
                                    style: TossTextStyles.labelLarge.copyWith(
                                      color: TossColors.textPrimary,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      if (!isLast)
                        Container(
                          margin: EdgeInsets.only(left: TossSpacing.space10),
                          height: 0.5,
                          color: TossColors.borderLight,
                        ),
                    ],
                  );
                }).toList(),
              ),
            ),
          ],
        ],
      ),
    );
  }

  void _togglePermission(String featureId) {
    setState(() {
      if (_selectedPermissions.contains(featureId)) {
        _selectedPermissions.remove(featureId);
      } else {
        _selectedPermissions.add(featureId);
      }
    });
  }

  void _toggleCategoryPermissions(List<String> featureIds, bool select) {
    setState(() {
      if (select) {
        _selectedPermissions.addAll(featureIds);
      } else {
        _selectedPermissions.removeAll(featureIds);
      }
    });
  }

  void _goToNextStep() {
    final roleName = _roleNameController.text.trim();
    if (roleName.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please enter a role name'),
          backgroundColor: TossColors.error,
        ),
      );
      return;
    }

    setState(() {
      _currentStep = 1;
    });
  }

  Future<void> _createRole() async {
    final roleName = _roleNameController.text.trim();
    if (roleName.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please enter a role name'),
          backgroundColor: TossColors.error,
        ),
      );
      return;
    }

    setState(() => _isCreating = true);

    try {
      final appState = ref.read(appStateProvider);
      final companyId = appState.companyChoosen;
      
      if (companyId.isEmpty) {
        throw Exception('No company selected');
      }

      // Use the createRoleProvider to create the role with permissions
      final createRole = ref.read(createRoleProvider);
      final roleId = await createRole(
        companyId: companyId,
        roleName: roleName,
        description: _descriptionController.text.trim().isEmpty 
            ? null 
            : _descriptionController.text.trim(),
        roleType: 'custom',
      );

      // If permissions were selected, update them
      if (_selectedPermissions.isNotEmpty) {
        final updatePermissions = ref.read(updateRolePermissionsProvider);
        await updatePermissions(roleId, _selectedPermissions);
      }
      
      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Role "$roleName" created successfully'),
            backgroundColor: TossColors.primary,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to create role: $e'),
            backgroundColor: TossColors.error,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isCreating = false);
      }
    }
  }
}