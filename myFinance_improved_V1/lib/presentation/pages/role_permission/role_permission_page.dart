import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import '../delegate_role/providers/delegate_role_providers.dart';
import '../delegate_role/widgets/role_card.dart';
import '../delegate_role/widgets/role_management_sheet.dart';
import '../../providers/app_state_provider.dart';
import '../../widgets/common/toss_scaffold.dart';
import '../../widgets/common/toss_app_bar.dart';
import '../../widgets/common/toss_loading_view.dart';
import '../../widgets/common/toss_error_view.dart';
import '../../widgets/common/toss_empty_view.dart';
import '../../../core/themes/toss_colors.dart';
import '../../../core/themes/toss_text_styles.dart';
import '../../../core/themes/toss_spacing.dart';
import '../../../core/themes/toss_border_radius.dart';
import '../../../core/themes/toss_shadows.dart';

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
          backgroundColor: const Color(0xFFE53935),
        ),
      );
      return;
    }
    
    if (roleName == 'employee') {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Cannot delete the Employee role. This is a default system role.'),
          backgroundColor: const Color(0xFFE53935),
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
                  color: Colors.orange[700],
                  fontSize: 13,
                ),
              ),
              SizedBox(height: TossSpacing.space2),
            ],
            Text(
              'This action cannot be undone.',
              style: TossTextStyles.caption.copyWith(
                color: const Color(0xFFE53935),
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(
              'Delete Role',
              style: TextStyle(color: const Color(0xFFE53935)),
            ),
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
              backgroundColor: Theme.of(context).colorScheme.primary,
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
              backgroundColor: const Color(0xFFE53935),
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
      return Scaffold(
        backgroundColor: const Color(0xFFF7F8FA),
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
                      icon: const Icon(Icons.arrow_back_ios, size: 20),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                    Expanded(
                      child: Text(
                        'Roles & Permissions',
                        style: TossTextStyles.h3.copyWith(fontWeight: FontWeight.w600),
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
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Icon(
                          Icons.business_outlined,
                          size: 40,
                          color: Colors.grey[400],
                        ),
                      ),
                      SizedBox(height: TossSpacing.space6),
                      Text(
                        'No company selected',
                        style: TossTextStyles.h3.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: TossSpacing.space2),
                      Text(
                        'Please select a company to\nmanage roles and permissions',
                        textAlign: TextAlign.center,
                        style: TossTextStyles.caption.copyWith(
                          color: Colors.grey[600],
                          fontSize: 13,
                        ),
                      ),
                      SizedBox(height: TossSpacing.space6),
                      ElevatedButton(
                        onPressed: () => context.go('/'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(context).colorScheme.primary,
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(
                            horizontal: TossSpacing.space5,
                            vertical: TossSpacing.space3,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(TossBorderRadius.md),
                          ),
                        ),
                        child: Text(
                          'Go to Home',
                          style: TossTextStyles.body.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                        ),
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

    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),
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
                    icon: const Icon(Icons.arrow_back_ios, size: 20),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  Expanded(
                    child: Text(
                      'Roles & Permissions',
                      style: TossTextStyles.h3.copyWith(fontWeight: FontWeight.w600),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  TextButton(
                    onPressed: () => _showCreateRoleModal(context),
                    child: Text(
                      'Add',
                      style: TossTextStyles.body.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Content
            Expanded(
              child: RefreshIndicator(
                onRefresh: () => _handleRefresh(ref),
                color: Theme.of(context).colorScheme.primary,
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
                                  color: Colors.grey[100],
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Icon(
                                  Icons.admin_panel_settings_outlined,
                                  size: 40,
                                  color: Colors.grey[400],
                                ),
                              ),
                              SizedBox(height: TossSpacing.space6),
                              Text(
                                'No roles created yet',
                                style: TossTextStyles.h3.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              SizedBox(height: TossSpacing.space2),
                              Text(
                                'Create roles and manage permissions\nfor your team members',
                                textAlign: TextAlign.center,
                                style: TossTextStyles.caption.copyWith(
                                  color: Colors.grey[600],
                                  fontSize: 13,
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
                        // Search bar - WHITE background, NO borders (from design guidelines)
                        Container(
                          color: Colors.white, // WHITE background - same as cards
                          padding: EdgeInsets.symmetric(
                            horizontal: TossSpacing.space4,
                            vertical: TossSpacing.space3,
                          ),
                          child: Container(
                            height: 44,
                            padding: EdgeInsets.symmetric(horizontal: TossSpacing.space3),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.search,
                                  color: Colors.grey[400], // Light gray icon
                                  size: 20,
                                ),
                                SizedBox(width: TossSpacing.space3),
                                Expanded(
                                  child: TextField(
                                    controller: _searchController,
                                    decoration: InputDecoration(
                                      hintText: 'Search roles...',
                                      hintStyle: TossTextStyles.body.copyWith(
                                        color: Colors.grey[400], // Light gray hint text
                                        fontSize: 16,
                                        fontWeight: FontWeight.w400,
                                      ),
                                      border: InputBorder.none, // NO BORDER
                                      isDense: true,
                                      contentPadding: EdgeInsets.zero,
                                    ),
                                    style: TossTextStyles.body.copyWith(
                                      fontSize: 16,
                                      color: Colors.black87,
                                    ),
                                  ),
                                ),
                                if (_searchQuery.isNotEmpty)
                                  GestureDetector(
                                    onTap: () {
                                      _searchController.clear();
                                    },
                                    child: Icon(
                                      Icons.clear,
                                      color: Colors.grey[400],
                                      size: 18,
                                    ),
                                  ),
                              ],
                            ),
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
                                          color: Colors.grey[400],
                                        ),
                                        SizedBox(height: TossSpacing.space4),
                                        Text(
                                          'No roles found',
                                          style: TossTextStyles.h3.copyWith(
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        SizedBox(height: TossSpacing.space2),
                                        Text(
                                          'Try a different search term',
                                          style: TossTextStyles.caption.copyWith(
                                            color: Colors.grey[600],
                                            fontSize: 13,
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
                                        bottom: TossSpacing.space10,
                                      ),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(TossBorderRadius.lg),
                                          boxShadow: TossShadows.cardShadow,
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
                                                                color: const Color(0xFFE53935),
                                                                shape: BoxShape.circle,
                                                              ),
                                                              child: Icon(
                                                                Icons.remove,
                                                                color: Colors.white,
                                                                size: 20,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ) : null, // No swipe action for protected roles
                                                    child: Material(
                                                      color: Colors.white,
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
                                                                      style: TossTextStyles.body.copyWith(
                                                                        fontWeight: FontWeight.w600,
                                                                        fontSize: 16,
                                                                        color: roleName == 'owner' ? Colors.grey[600] : Colors.black87,
                                                                      ),
                                                                    ),
                                                                    SizedBox(height: 2),
                                                                    Text(
                                                                      roleName == 'owner' 
                                                                          ? 'System administrator • Full permissions'
                                                                          : '$memberCount users • ${permissions.length} permissions',
                                                                      style: TossTextStyles.caption.copyWith(
                                                                        color: Colors.grey[500],
                                                                        fontSize: 13,
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                              // Chevron pointing left (hide for Owner and Employee)
                                                              if (roleName != 'owner' && roleName != 'employee')
                                                                Icon(
                                                                  Icons.chevron_left,
                                                                  color: Colors.grey[400],
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
                                                      color: const Color(0xFFE5E8EB),
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
                  loading: () => const Center(
                    child: CircularProgressIndicator(),
                  ),
                  error: (error, stack) => Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Failed to load roles',
                          style: TossTextStyles.body.copyWith(
                            color: Colors.grey[500],
                          ),
                        ),
                        SizedBox(height: TossSpacing.space3),
                        TextButton(
                          onPressed: () => ref.invalidate(allCompanyRolesProvider),
                          child: Text(
                            'Retry',
                            style: TossTextStyles.body.copyWith(
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
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
        maxHeight: MediaQuery.of(context).size.height * 0.85,
        minHeight: MediaQuery.of(context).size.height * 0.5,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
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
                color: Colors.grey[300],
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
                      icon: Icon(Icons.arrow_back, color: Colors.grey[600]),
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
                          style: TossTextStyles.h3.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: TossSpacing.space1),
                        Text(
                          _currentStep == 0 
                              ? 'Define a new role with specific permissions'
                              : 'Select what this role can access and do',
                          style: TossTextStyles.caption.copyWith(
                            color: Colors.grey[600],
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.close, color: Colors.grey[600]),
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
                      color: Colors.grey[200],
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
                color: Colors.white,
                border: Border(top: BorderSide(color: const Color(0xFFE5E8EB))),
              ),
              child: SafeArea(
                top: false,
                child: SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: _isCreating ? null : (_currentStep == 0 ? _goToNextStep : _createRole),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(TossBorderRadius.md),
                      ),
                      elevation: 0,
                    ),
                    child: _isCreating
                        ? SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : Text(
                            _currentStep == 0 ? 'Next' : 'Create Role',
                            style: TossTextStyles.body.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                            ),
                          ),
                  ),
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
        color: isActive ? Theme.of(context).colorScheme.primary : Colors.grey[200],
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          '${step + 1}',
          style: TossTextStyles.body.copyWith(
            color: isActive ? Colors.white : Colors.grey[600],
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
            style: TossTextStyles.body.copyWith(
              fontWeight: FontWeight.w700,
              fontSize: 15,
            ),
          ),
          SizedBox(height: TossSpacing.space2),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(TossBorderRadius.md),
              border: Border.all(
                color: Colors.grey[300]!,
                width: 1,
              ),
            ),
            child: TextField(
              controller: _roleNameController,
              style: TossTextStyles.body.copyWith(fontSize: 15),
              decoration: InputDecoration(
                hintText: 'Enter role name',
                hintStyle: TossTextStyles.body.copyWith(
                  color: Colors.grey[400],
                  fontSize: 15,
                ),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: TossSpacing.space3,
                  vertical: TossSpacing.space3,
                ),
              ),
            ),
          ),
          
          SizedBox(height: TossSpacing.space5),
          
          // Description input
          Text(
            'Description',
            style: TossTextStyles.body.copyWith(
              fontWeight: FontWeight.w700,
              fontSize: 15,
            ),
          ),
          SizedBox(height: TossSpacing.space2),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(TossBorderRadius.md),
              border: Border.all(
                color: Colors.grey[300]!,
                width: 1,
              ),
            ),
            child: TextField(
              controller: _descriptionController,
              maxLines: 3,
              style: TossTextStyles.body.copyWith(fontSize: 15),
              decoration: InputDecoration(
                hintText: 'Describe what this role does...',
                hintStyle: TossTextStyles.body.copyWith(
                  color: Colors.grey[400],
                  fontSize: 15,
                ),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: TossSpacing.space3,
                  vertical: TossSpacing.space3,
                ),
              ),
            ),
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
                    style: TossTextStyles.body.copyWith(
                      fontWeight: FontWeight.w700,
                      fontSize: 17,
                      color: Colors.black87,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        _selectedPermissions.clear();
                      });
                    },
                    child: Text(
                      'Clear all',
                      style: TossTextStyles.body.copyWith(
                        color: Colors.grey[600],
                        fontSize: 14,
                      ),
                    ),
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
      loading: () => const Center(
        child: CircularProgressIndicator(),
      ),
      error: (error, stack) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, color: const Color(0xFFE53935), size: 48),
            SizedBox(height: TossSpacing.space3),
            Text(
              'Failed to load permissions',
              style: TossTextStyles.body.copyWith(color: const Color(0xFFE53935)),
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
        color: Colors.white,
        borderRadius: BorderRadius.circular(TossBorderRadius.lg),
        boxShadow: TossShadows.cardShadow,
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
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () {
                          _toggleCategoryPermissions(featureIds, !allSelected);
                        },
                        borderRadius: BorderRadius.circular(6),
                        child: Padding(
                          padding: EdgeInsets.all(4),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            width: 20,
                            height: 20,
                            decoration: BoxDecoration(
                              color: allSelected
                                  ? Theme.of(context).colorScheme.primary
                                  : someSelected
                                      ? Theme.of(context).colorScheme.primary.withOpacity(0.3)
                                      : Colors.white,
                              border: Border.all(
                                color: allSelected || someSelected
                                    ? Theme.of(context).colorScheme.primary
                                    : Colors.grey[300]!,
                                width: allSelected || someSelected ? 2 : 1,
                              ),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: allSelected
                                ? Icon(
                                    Icons.check,
                                    size: 14,
                                    color: Colors.white,
                                  )
                                : someSelected
                                    ? Center(
                                        child: Container(
                                          width: 8,
                                          height: 2,
                                          color: Colors.white,
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
                            style: TossTextStyles.body.copyWith(
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                              color: Colors.black87,
                            ),
                          ),
                          if (selectedCount > 0) ...[
                            SizedBox(height: TossSpacing.space1),
                            Text(
                              '$selectedCount of ${features.length} selected',
                              style: TossTextStyles.caption.copyWith(
                                color: Colors.grey[600],
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                    AnimatedRotation(
                      turns: isExpanded ? 0.5 : 0,
                      duration: const Duration(milliseconds: 200),
                      child: Icon(
                        Icons.expand_more,
                        color: Colors.grey[400],
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
                  top: BorderSide(color: const Color(0xFFE5E8EB), width: 0.5),
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
                        color: Colors.transparent,
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
                                  duration: const Duration(milliseconds: 200),
                                  width: 20,
                                  height: 20,
                                  decoration: BoxDecoration(
                                    color: isSelected
                                        ? Theme.of(context).colorScheme.primary
                                        : Colors.white,
                                    border: Border.all(
                                      color: isSelected
                                          ? Theme.of(context).colorScheme.primary
                                          : Colors.grey[300]!,
                                      width: isSelected ? 2 : 1,
                                    ),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: isSelected
                                      ? Icon(
                                          Icons.check,
                                          size: 14,
                                          color: Colors.white,
                                        )
                                      : null,
                                ),
                                SizedBox(width: TossSpacing.space3),
                                Expanded(
                                  child: Text(
                                    featureName,
                                    style: TossTextStyles.body.copyWith(
                                      color: Colors.black87,
                                      fontWeight: FontWeight.w400,
                                      fontSize: 15,
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
                          color: const Color(0xFFE5E8EB),
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
          backgroundColor: const Color(0xFFE53935),
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
          backgroundColor: const Color(0xFFE53935),
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
            backgroundColor: Theme.of(context).colorScheme.primary,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to create role: $e'),
            backgroundColor: const Color(0xFFE53935),
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