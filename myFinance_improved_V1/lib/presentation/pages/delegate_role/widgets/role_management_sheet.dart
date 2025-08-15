import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/themes/toss_colors.dart';
import '../../../../core/themes/toss_text_styles.dart';
import '../../../../core/themes/toss_spacing.dart';
import '../../../../core/themes/toss_border_radius.dart';
import '../providers/delegate_role_providers.dart';

class RoleManagementSheet extends ConsumerStatefulWidget {
  final String roleId;
  final String roleName;
  final String? description;
  final List<String> permissions;
  final int memberCount;
  final bool canEdit;
  final bool canDelegate;

  const RoleManagementSheet({
    super.key,
    required this.roleId,
    required this.roleName,
    this.description,
    required this.permissions,
    required this.memberCount,
    required this.canEdit,
    required this.canDelegate,
  });

  static Future<void> show(
    BuildContext context, {
    required String roleId,
    required String roleName,
    String? description,
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
        description: description,
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
  Set<String> _expandedCategories = {};

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _roleNameController = TextEditingController(text: widget.roleName);
    _descriptionController = TextEditingController(text: widget.description ?? _getDefaultRoleDescription());
    _selectedPermissions = Set.from(widget.permissions);
    // Start with all categories collapsed
    _expandedCategories = {};
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

          // Underline-style tabs
          Container(
            margin: EdgeInsets.symmetric(horizontal: TossSpacing.space5),
            child: Row(
              children: [
                _buildUnderlineTab('Details', 0),
                _buildUnderlineTab('Permissions', 1),
                _buildUnderlineTab('Members', 2),
              ],
            ),
          ),
          SizedBox(height: TossSpacing.space4),

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

          // TOSS-style bottom action with proper safe area
          if (widget.canEdit) ...[
            Container(
              padding: EdgeInsets.all(TossSpacing.space5),
              decoration: BoxDecoration(
                color: TossColors.background,
                border: Border(top: BorderSide(color: TossColors.gray200)),
              ),
              child: SafeArea(
                top: false,
                child: SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _saveChanges,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: TossColors.primary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(TossBorderRadius.md),
                      ),
                      elevation: 0,
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
        
        return Column(
          children: [
            // Header section with padding
            Container(
              padding: EdgeInsets.fromLTRB(
                TossSpacing.space5,
                TossSpacing.space5,
                TossSpacing.space5,
                TossSpacing.space3,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
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
                            SizedBox(height: TossSpacing.space1),
                            Text(
                              widget.roleName.toLowerCase() == 'owner' 
                                  ? 'Owner role always has full permissions'
                                  : widget.canEdit 
                                      ? 'Configure what this role can access and do'
                                      : 'View permissions for this role',
                              style: TossTextStyles.body.copyWith(
                                color: TossColors.gray600,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Quick actions
                      if (widget.canEdit)
                        Row(
                          children: [
                            TextButton(
                              onPressed: () {
                                setState(() {
                                  _selectedPermissions.clear();
                                });
                              },
                              child: Text(
                                'Clear all',
                                style: TossTextStyles.body.copyWith(
                                  color: TossColors.gray600,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ],
                        ),
                    ],
                  ),
                ],
              ),
            ),
            
            // Scrollable permission categories
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(
                  TossSpacing.space5,
                  0,
                  TossSpacing.space5,
                  TossSpacing.space10,
                ),
                child: Column(
                  children: categories.map((category) {
                    final categoryName = category['category_name'] as String;
                    final features = (category['features'] as List? ?? [])
                        .cast<Map<String, dynamic>>();
                    
                    if (features.isEmpty) return SizedBox.shrink();
                    
                    return _buildPermissionCategory(categoryName, features);
                  }).toList(),
                ),
              ),
            ),
          ],
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
    return Column(
      children: [
        // Header section
        Container(
          padding: EdgeInsets.all(TossSpacing.space5),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  'Team Members',
                  style: TossTextStyles.h3.copyWith(
                    fontWeight: FontWeight.w700,
                    color: TossColors.gray900,
                  ),
                ),
              ),
            ],
          ),
        ),

        // Scrollable content
        Expanded(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: TossSpacing.space5),
            child: Column(
              children: [
                // Real members from database
                FutureBuilder<List<Map<String, dynamic>>>(
                  future: _getRoleMembers(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                        child: CircularProgressIndicator(color: TossColors.primary),
                      );
                    }
                    
                    if (snapshot.hasError) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.error_outline, color: TossColors.error, size: 48),
                            SizedBox(height: TossSpacing.space3),
                            Text(
                              'Failed to load members',
                              style: TossTextStyles.body.copyWith(color: TossColors.error),
                            ),
                          ],
                        ),
                      );
                    }
                    
                    final members = snapshot.data ?? [];
                    
                    if (members.isEmpty) {
                      return Center(
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
                              'No users are currently assigned to this role',
                              style: TossTextStyles.body.copyWith(
                                color: TossColors.gray500,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      );
                    }
                    
                    return ListView.separated(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: members.length,
                      separatorBuilder: (context, index) => SizedBox(height: TossSpacing.space3),
                      itemBuilder: (context, index) {
                        final member = members[index];
                        return _buildMemberItem(
                          name: member['name'] ?? 'Unknown User',
                          email: member['email'] ?? '',
                          joinedDate: _formatJoinDate(member['created_at']),
                        );
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        ),

      ],
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
    final isExpanded = _expandedCategories.contains(title);
    final featureIds = features.map((f) => f['feature_id'] as String).toList();
    final selectedCount = featureIds.where((id) => _selectedPermissions.contains(id)).length;
    final allSelected = selectedCount == features.length && features.isNotEmpty;
    final someSelected = selectedCount > 0 && selectedCount < features.length;
    
    return Container(
      margin: EdgeInsets.only(bottom: TossSpacing.space3),
      decoration: BoxDecoration(
        color: TossColors.surface,
        borderRadius: BorderRadius.circular(TossBorderRadius.md),
        border: Border.all(
          color: TossColors.gray200,
          width: 1,
        ),
      ),
      child: Column(
        children: [
          // Collapsible header with select all
          Material(
            color: Colors.transparent,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(TossBorderRadius.md),
              bottom: Radius.circular(isExpanded ? 0 : TossBorderRadius.md),
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
                top: Radius.circular(TossBorderRadius.md),
                bottom: Radius.circular(isExpanded ? 0 : TossBorderRadius.md),
              ),
              child: Container(
                padding: EdgeInsets.all(TossSpacing.space4),
                child: Row(
                  children: [
                    // Select all checkbox - wrapped in its own InkWell to prevent event bubbling
                    Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: widget.canEdit
                            ? () {
                                _toggleCategoryPermissions(featureIds, !allSelected);
                              }
                            : null,
                        borderRadius: BorderRadius.circular(6),
                        child: Padding(
                          padding: EdgeInsets.all(4), // Add padding for better touch target
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            width: 20,
                            height: 20,
                            decoration: BoxDecoration(
                              color: allSelected
                                  ? TossColors.primary
                                  : someSelected
                                      ? TossColors.primary.withOpacity(0.3)
                                      : TossColors.background,
                              border: Border.all(
                                color: allSelected || someSelected
                                    ? TossColors.primary
                                    : TossColors.gray300,
                                width: allSelected || someSelected ? 2 : 1.5,
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
                    // Category title - clickable area
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            style: TossTextStyles.body.copyWith(
                              fontWeight: FontWeight.w700,
                              color: TossColors.gray900,
                              fontSize: 16,
                            ),
                          ),
                          if (selectedCount > 0)
                            Text(
                              '$selectedCount of ${features.length} selected',
                              style: TossTextStyles.caption.copyWith(
                                color: TossColors.gray600,
                              ),
                            ),
                        ],
                      ),
                    ),
                    // Expand/collapse icon
                    AnimatedRotation(
                      turns: isExpanded ? 0.5 : 0,
                      duration: const Duration(milliseconds: 200),
                      child: Icon(
                        Icons.expand_more,
                        color: TossColors.gray600,
                        size: 24,
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
                  top: BorderSide(color: TossColors.gray200, width: 1),
                ),
              ),
              child: Column(
                children: features.map((feature) {
                  final featureId = feature['feature_id'] as String;
                  final featureName = feature['feature_name'] as String;
                  final isSelected = _selectedPermissions.contains(featureId);
                  
                  return Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: widget.canEdit ? () => _togglePermission(featureId) : null,
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: TossSpacing.space4,
                          vertical: TossSpacing.space3,
                        ),
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              color: TossColors.gray100,
                              width: 1,
                            ),
                          ),
                        ),
                        child: Row(
                          children: [
                            SizedBox(width: TossSpacing.space6), // Indent for hierarchy
                            // Individual checkbox
                            AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              width: 20,
                              height: 20,
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? TossColors.primary
                                    : TossColors.background,
                                border: Border.all(
                                  color: isSelected
                                      ? TossColors.primary
                                      : TossColors.gray300,
                                  width: isSelected ? 2 : 1.5,
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
                                  color: widget.canEdit 
                                      ? TossColors.gray900
                                      : TossColors.gray500,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Future<List<Map<String, dynamic>>> _getRoleMembers() async {
    final supabase = Supabase.instance.client;
    
    try {
      // Get user IDs from user_roles table
      final userRolesResponse = await supabase
          .from('user_roles')
          .select('user_id, created_at')
          .eq('role_id', widget.roleId)
          .eq('is_deleted', false);
      
      if (userRolesResponse.isEmpty) {
        return [];
      }
      
      // Extract user IDs
      final userIds = (userRolesResponse as List).map((item) => item['user_id']).toList();
      
      // Get user details from users table
      final usersResponse = await supabase
          .from('users')
          .select('user_id, first_name, last_name, email')
          .inFilter('user_id', userIds);
      
      final members = <Map<String, dynamic>>[];
      
      for (final user in usersResponse as List) {
        // Find the corresponding user_role entry to get created_at
        final userRole = (userRolesResponse as List).firstWhere(
          (role) => role['user_id'] == user['user_id'],
          orElse: () => {'created_at': null},
        );
        
        final firstName = user['first_name'] ?? '';
        final lastName = user['last_name'] ?? '';
        final fullName = '$firstName $lastName'.trim();
        
        members.add({
          'user_id': user['user_id'],
          'name': fullName.isEmpty ? 'Unknown User' : fullName,
          'email': user['email'] ?? 'No email',
          'created_at': userRole['created_at'],
        });
      }
      
      return members;
    } catch (e) {
      return [];
    }
  }

  String _formatJoinDate(dynamic createdAt) {
    if (createdAt == null) return 'Unknown date';
    
    try {
      final date = DateTime.parse(createdAt.toString());
      final now = DateTime.now();
      final difference = now.difference(date);
      
      if (difference.inDays == 0) {
        return 'Joined today';
      } else if (difference.inDays == 1) {
        return 'Joined yesterday';
      } else if (difference.inDays < 7) {
        return 'Joined ${difference.inDays} days ago';
      } else if (difference.inDays < 30) {
        final weeks = (difference.inDays / 7).floor();
        return 'Joined $weeks week${weeks == 1 ? '' : 's'} ago';
      } else if (difference.inDays < 365) {
        final months = (difference.inDays / 30).floor();
        return 'Joined $months month${months == 1 ? '' : 's'} ago';
      } else {
        final years = (difference.inDays / 365).floor();
        return 'Joined $years year${years == 1 ? '' : 's'} ago';
      }
    } catch (e) {
      return 'Unknown date';
    }
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


  String _getDefaultRoleDescription() {
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

  void _toggleCategoryPermissions(List<String> featureIds, bool select) {
    if (!widget.canEdit) return;
    
    setState(() {
      if (select) {
        _selectedPermissions.addAll(featureIds);
      } else {
        _selectedPermissions.removeAll(featureIds);
      }
    });
  }

  Future<void> _saveChanges() async {
    setState(() => _isLoading = true);
    
    try {
      // Update role details (name and description) first
      final updateDetails = ref.read(updateRoleDetailsProvider);
      await updateDetails(
        roleId: widget.roleId,
        roleName: _roleNameController.text.trim(),
        description: _descriptionController.text.trim().isEmpty 
            ? null 
            : _descriptionController.text.trim(),
      );

      // Update role permissions
      final updatePermissions = ref.read(updateRolePermissionsProvider);
      await updatePermissions(widget.roleId, _selectedPermissions);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Role updated successfully'),
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


  Widget _buildUnderlineTab(String text, int index) {
    final isSelected = _tabController.index == index;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _tabController.animateTo(index);
          });
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: EdgeInsets.symmetric(vertical: TossSpacing.space3),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: isSelected ? TossColors.gray900 : Colors.transparent,
                width: 2,
              ),
            ),
          ),
          child: Center(
            child: Text(
              text,
              style: TossTextStyles.body.copyWith(
                color: isSelected ? TossColors.gray900 : TossColors.gray500,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

