import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/themes/toss_colors.dart';
import '../../../../core/themes/toss_text_styles.dart';
import '../../../../core/themes/toss_spacing.dart';
import '../../../../core/themes/toss_border_radius.dart';
import '../providers/delegate_role_providers.dart';

class RoleManagementSheet extends ConsumerStatefulWidget {
  final String roleId;
  final String roleName;
  final List<String> permissions;
  final int memberCount;
  final bool canEdit;
  final bool canDelegate;

  const RoleManagementSheet({
    super.key,
    required this.roleId,
    required this.roleName,
    required this.permissions,
    required this.memberCount,
    required this.canEdit,
    required this.canDelegate,
  });

  static Future<void> show(
    BuildContext context, {
    required String roleId,
    required String roleName,
    required List<String> permissions,
    required int memberCount,
    required bool canEdit,
    required bool canDelegate,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => RoleManagementSheet(
        roleId: roleId,
        roleName: roleName,
        permissions: permissions,
        memberCount: memberCount,
        canEdit: canEdit,
        canDelegate: canDelegate,
      ),
    );
  }

  @override
  ConsumerState<RoleManagementSheet> createState() => _RoleManagementSheetState();
}

class _RoleManagementSheetState extends ConsumerState<RoleManagementSheet>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late TextEditingController _roleNameController;
  late TextEditingController _descriptionController;
  bool _isLoading = false;
  Set<String> _selectedPermissions = {};

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _roleNameController = TextEditingController(text: widget.roleName);
    _descriptionController = TextEditingController(text: _getRoleDescription());
    _selectedPermissions = Set.from(widget.permissions);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _roleNameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.9,
      decoration: BoxDecoration(
        color: TossColors.background,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(TossBorderRadius.xl),
        ),
      ),
      child: Column(
        children: [
          // Handle bar
          Container(
            margin: EdgeInsets.only(top: TossSpacing.space3),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: TossColors.gray300,
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Header
          Padding(
            padding: EdgeInsets.all(TossSpacing.space5),
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: _getRoleColor().withOpacity(0.12),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    _getRoleIcon(),
                    color: _getRoleColor(),
                    size: 24,
                  ),
                ),
                SizedBox(width: TossSpacing.space3),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.roleName,
                        style: TossTextStyles.h2.copyWith(
                          fontWeight: FontWeight.w700,
                          color: TossColors.gray900,
                        ),
                      ),
                      Text(
                        'Role Management',
                        style: TossTextStyles.bodySmall.copyWith(
                          color: TossColors.gray600,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.close, color: TossColors.gray600),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),

          // Tab bar
          Container(
            margin: EdgeInsets.symmetric(horizontal: TossSpacing.space5),
            decoration: BoxDecoration(
              color: TossColors.gray50,
              borderRadius: BorderRadius.circular(TossBorderRadius.sm),
            ),
            child: TabBar(
              controller: _tabController,
              labelColor: Colors.white,
              unselectedLabelColor: TossColors.gray600,
              indicator: BoxDecoration(
                color: TossColors.primary,
                borderRadius: BorderRadius.circular(TossBorderRadius.sm),
              ),
              dividerColor: Colors.transparent,
              tabs: [
                Tab(text: 'Details'),
                Tab(text: 'Permissions'),
                Tab(text: 'Members'),
              ],
            ),
          ),

          // Tab content
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildDetailsTab(),
                _buildPermissionsTab(),
                _buildMembersTab(),
              ],
            ),
          ),

          // Bottom action
          if (widget.canEdit) ...[
            Container(
              padding: EdgeInsets.all(TossSpacing.space5),
              decoration: BoxDecoration(
                color: TossColors.background,
                border: Border(top: BorderSide(color: TossColors.gray200)),
              ),
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _saveChanges,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: TossColors.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(TossBorderRadius.sm),
                    ),
                  ),
                  child: _isLoading
                      ? SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : Text(
                          'Save Changes',
                          style: TossTextStyles.label.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildDetailsTab() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(TossSpacing.space5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Role name
          Text(
            'Role Name',
            style: TossTextStyles.label.copyWith(
              color: TossColors.gray700,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: TossSpacing.space2),
          TextField(
            controller: _roleNameController,
            enabled: widget.canEdit,
            style: TossTextStyles.body,
            decoration: InputDecoration(
              hintText: 'Enter role name',
              filled: true,
              fillColor: widget.canEdit ? TossColors.surface : TossColors.gray50,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(TossBorderRadius.sm),
                borderSide: BorderSide(color: TossColors.gray200),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(TossBorderRadius.sm),
                borderSide: BorderSide(color: TossColors.gray200),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(TossBorderRadius.sm),
                borderSide: BorderSide(color: TossColors.primary),
              ),
            ),
          ),

          SizedBox(height: TossSpacing.space5),

          // Role description
          Text(
            'Description',
            style: TossTextStyles.label.copyWith(
              color: TossColors.gray700,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: TossSpacing.space2),
          TextField(
            controller: _descriptionController,
            enabled: widget.canEdit,
            maxLines: 3,
            style: TossTextStyles.body,
            decoration: InputDecoration(
              hintText: 'Describe what this role does...',
              filled: true,
              fillColor: widget.canEdit ? TossColors.surface : TossColors.gray50,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(TossBorderRadius.sm),
                borderSide: BorderSide(color: TossColors.gray200),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(TossBorderRadius.sm),
                borderSide: BorderSide(color: TossColors.gray200),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(TossBorderRadius.sm),
                borderSide: BorderSide(color: TossColors.primary),
              ),
            ),
          ),

          SizedBox(height: TossSpacing.space5),

          // Role stats
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  'Members',
                  '${widget.memberCount}',
                  Icons.person,
                  TossColors.primary,
                ),
              ),
              SizedBox(width: TossSpacing.space3),
              Expanded(
                child: _buildStatCard(
                  'Permissions',
                  '${widget.permissions.length}',
                  Icons.shield_outlined,
                  TossColors.success,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPermissionsTab() {
    final rolePermissionsAsync = ref.watch(rolePermissionsProvider(widget.roleId));
    
    return rolePermissionsAsync.when(
      data: (permissionData) {
        final categories = permissionData['categories'] as List;
        final currentPermissions = permissionData['currentPermissions'] as Set<String>;
        
        return SingleChildScrollView(
          padding: EdgeInsets.all(TossSpacing.space5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Role Permissions',
                style: TossTextStyles.h3.copyWith(
                  fontWeight: FontWeight.w700,
                  color: TossColors.gray900,
                ),
              ),
              SizedBox(height: TossSpacing.space2),
              Text(
                'Configure what this role can access and do',
                style: TossTextStyles.bodySmall.copyWith(
                  color: TossColors.gray600,
                ),
              ),
              SizedBox(height: TossSpacing.space5),

              // Dynamic permission categories from Supabase
              ...categories.map((category) {
                final categoryName = category['category_name'] as String;
                final features = (category['features'] as List? ?? [])
                    .cast<Map<String, dynamic>>();
                
                if (features.isEmpty) return SizedBox.shrink();
                
                return Column(
                  children: [
                    _buildPermissionCategory(categoryName, features),
                    SizedBox(height: TossSpacing.space4),
                  ],
                );
              }).toList(),
            ],
          ),
        );
      },
      loading: () => Center(
        child: Padding(
          padding: EdgeInsets.all(TossSpacing.space10),
          child: CircularProgressIndicator(color: TossColors.primary),
        ),
      ),
      error: (error, stack) => Center(
        child: Padding(
          padding: EdgeInsets.all(TossSpacing.space5),
          child: Column(
            children: [
              Icon(Icons.error_outline, color: TossColors.error, size: 48),
              SizedBox(height: TossSpacing.space3),
              Text(
                'Failed to load permissions',
                style: TossTextStyles.body.copyWith(color: TossColors.error),
              ),
              SizedBox(height: TossSpacing.space2),
              ElevatedButton(
                onPressed: () => ref.invalidate(rolePermissionsProvider(widget.roleId)),
                child: Text('Retry'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMembersTab() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(TossSpacing.space5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Team Members',
                style: TossTextStyles.h3.copyWith(
                  fontWeight: FontWeight.w700,
                  color: TossColors.gray900,
                ),
              ),
              if (widget.canDelegate)
                ElevatedButton.icon(
                  onPressed: () {
                    // TODO: Show delegate user selection
                  },
                  icon: Icon(Icons.person_add, size: 18),
                  label: Text('Add Member'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: TossColors.primary,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(
                      horizontal: TossSpacing.space3,
                      vertical: TossSpacing.space2,
                    ),
                  ),
                ),
            ],
          ),
          SizedBox(height: TossSpacing.space4),

          // Members list (mock data)
          if (widget.memberCount > 0) ...[
            ListView.separated(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: 3, // Mock data
              separatorBuilder: (context, index) => SizedBox(height: TossSpacing.space3),
              itemBuilder: (context, index) {
                return _buildMemberItem(
                  name: 'Team Member ${index + 1}',
                  email: 'member${index + 1}@company.com',
                  joinedDate: 'Joined 2 weeks ago',
                );
              },
            ),
          ] else ...[
            Center(
              child: Column(
                children: [
                  SizedBox(height: TossSpacing.space10),
                  Icon(
                    Icons.people_outline,
                    size: 64,
                    color: TossColors.gray300,
                  ),
                  SizedBox(height: TossSpacing.space4),
                  Text(
                    'No team members yet',
                    style: TossTextStyles.h3.copyWith(
                      color: TossColors.gray600,
                    ),
                  ),
                  SizedBox(height: TossSpacing.space2),
                  Text(
                    'Delegate this role to team members to get started',
                    style: TossTextStyles.body.copyWith(
                      color: TossColors.gray500,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: EdgeInsets.all(TossSpacing.space4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(TossBorderRadius.sm),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 20, color: color),
              SizedBox(width: TossSpacing.space2),
              Text(
                title,
                style: TossTextStyles.label.copyWith(
                  color: TossColors.gray700,
                ),
              ),
            ],
          ),
          SizedBox(height: TossSpacing.space2),
          Text(
            value,
            style: TossTextStyles.h2.copyWith(
              color: color,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPermissionCategory(String title, List<Map<String, dynamic>> features) {
    return Container(
      padding: EdgeInsets.all(TossSpacing.space4),
      decoration: BoxDecoration(
        color: TossColors.surface,
        borderRadius: BorderRadius.circular(TossBorderRadius.sm),
        border: Border.all(color: TossColors.gray200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TossTextStyles.label.copyWith(
              fontWeight: FontWeight.w700,
              color: TossColors.gray900,
            ),
          ),
          SizedBox(height: TossSpacing.space3),
          ...features.map((feature) {
            final featureId = feature['feature_id'] as String;
            final featureName = feature['feature_name'] as String;
            final isSelected = _selectedPermissions.contains(featureId);
            
            return Padding(
              padding: EdgeInsets.symmetric(vertical: TossSpacing.space1),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: widget.canEdit ? () => _togglePermission(featureId) : null,
                    child: Container(
                      width: 18,
                      height: 18,
                      decoration: BoxDecoration(
                        color: isSelected ? TossColors.primary : Colors.transparent,
                        border: Border.all(
                          color: isSelected ? TossColors.primary : TossColors.gray300,
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(3),
                      ),
                      child: isSelected
                          ? Icon(
                              Icons.check,
                              size: 12,
                              color: Colors.white,
                            )
                          : null,
                    ),
                  ),
                  SizedBox(width: TossSpacing.space2),
                  Expanded(
                    child: Text(
                      featureName,
                      style: TossTextStyles.bodySmall.copyWith(
                        color: widget.canEdit 
                            ? TossColors.gray700 
                            : TossColors.gray500,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildMemberItem({
    required String name,
    required String email,
    required String joinedDate,
  }) {
    return Container(
      padding: EdgeInsets.all(TossSpacing.space4),
      decoration: BoxDecoration(
        color: TossColors.surface,
        borderRadius: BorderRadius.circular(TossBorderRadius.sm),
        border: Border.all(color: TossColors.gray200),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: TossColors.gray200,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Icon(Icons.person, color: TossColors.gray600),
          ),
          SizedBox(width: TossSpacing.space3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: TossTextStyles.body.copyWith(
                    fontWeight: FontWeight.w600,
                    color: TossColors.gray900,
                  ),
                ),
                Text(
                  email,
                  style: TossTextStyles.bodySmall.copyWith(
                    color: TossColors.gray600,
                  ),
                ),
                Text(
                  joinedDate,
                  style: TossTextStyles.caption.copyWith(
                    color: TossColors.gray500,
                  ),
                ),
              ],
            ),
          ),
          if (widget.canEdit)
            IconButton(
              icon: Icon(Icons.more_vert, color: TossColors.gray400),
              onPressed: () {
                // TODO: Show member options
              },
            ),
        ],
      ),
    );
  }

  Color _getRoleColor() {
    switch (widget.roleName.toLowerCase()) {
      case 'owner':
        return TossColors.error;
      case 'manager':
        return TossColors.warning;
      case 'employee':
        return TossColors.primary;
      case 'salesman':
        return TossColors.success;
      default:
        return TossColors.gray600;
    }
  }

  IconData _getRoleIcon() {
    switch (widget.roleName.toLowerCase()) {
      case 'owner':
        return Icons.star;
      case 'manager':
        return Icons.supervisor_account;
      case 'employee':
        return Icons.person;
      case 'salesman':
        return Icons.shopping_bag;
      default:
        return Icons.badge;
    }
  }

  String _getRoleDescription() {
    switch (widget.roleName.toLowerCase()) {
      case 'owner':
        return 'Full system access with company management capabilities. Can oversee all operations, manage finances, and make strategic decisions.';
      case 'manager':
        return 'Team oversight and operational control. Responsible for managing staff, schedules, and day-to-day operations.';
      case 'employee':
        return 'Standard access for daily operations. Can perform assigned tasks, view schedules, and access basic system functions.';
      case 'salesman':
        return 'Customer-facing sales operations. Handles client interactions, processes orders, and manages customer relationships.';
      case 'managerstore':
        return 'Store management and inventory control. Oversees store operations, manages stock, and ensures smooth daily activities.';
      default:
        return 'Custom role with specific permissions tailored to unique business requirements.';
    }
  }

  void _togglePermission(String featureId) {
    if (!widget.canEdit) return;
    
    setState(() {
      if (_selectedPermissions.contains(featureId)) {
        _selectedPermissions.remove(featureId);
      } else {
        _selectedPermissions.add(featureId);
      }
    });
  }

  Future<void> _saveChanges() async {
    setState(() => _isLoading = true);
    
    try {
      // Update role permissions using the provider
      final updatePermissions = ref.read(updateRolePermissionsProvider);
      await updatePermissions(widget.roleId, _selectedPermissions);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Role permissions updated successfully'),
            backgroundColor: TossColors.success,
            behavior: SnackBarBehavior.floating,
          ),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to update role: $e'),
            backgroundColor: TossColors.error,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }
}