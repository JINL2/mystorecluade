import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/themes/toss_colors.dart';
import '../../../core/themes/toss_text_styles.dart';
import '../../../core/themes/toss_spacing.dart';
import '../../../core/themes/toss_shadows.dart';
import '../../providers/role_provider.dart';
import '../../providers/app_state_provider.dart';
import 'widgets/create_role_modal.dart';
import 'widgets/edit_role_modal.dart';

class RolePermissionPage extends ConsumerStatefulWidget {
  const RolePermissionPage({super.key});

  @override
  ConsumerState<RolePermissionPage> createState() => _RolePermissionPageState();
}

class _RolePermissionPageState extends ConsumerState<RolePermissionPage> {
  @override
  Widget build(BuildContext context) {
    final selectedCompany = ref.watch(selectedCompanyProvider);
    
    if (selectedCompany == null) {
      return _buildNoCompanySelected();
    }

    final rolesAsync = ref.watch(companyRolesProvider);

    return Scaffold(
      backgroundColor: TossColors.gray50,
      body: Stack(
        children: [
          CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              // Custom App Bar with smooth scroll effect
              _buildSliverAppBar(context),
              
              // Company Header
              SliverToBoxAdapter(
                child: _buildCompanyHeader(selectedCompany),
              ),
              
              // Role List
              rolesAsync.when(
                data: (roles) => roles.isEmpty
                    ? SliverFillRemaining(
                        child: _buildEmptyState(),
                      )
                    : SliverPadding(
                        padding: EdgeInsets.fromLTRB(
                          TossSpacing.space4,
                          TossSpacing.space4,
                          TossSpacing.space4,
                          100, // Padding for floating button without white container
                        ),
                        sliver: SliverList(
                          delegate: SliverChildBuilderDelegate(
                            (context, index) {
                              return _buildRoleCard(roles[index]);
                            },
                            childCount: roles.length,
                          ),
                        ),
                      ),
                loading: () => const SliverFillRemaining(
                  child: Center(child: CircularProgressIndicator()),
                ),
                error: (error, stack) => SliverFillRemaining(
                  child: Center(
                    child: Padding(
                      padding: EdgeInsets.all(TossSpacing.space5),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.error_outline,
                            size: 48,
                            color: TossColors.error,
                          ),
                          SizedBox(height: TossSpacing.space4),
                          Text(
                            'Failed to load roles',
                            style: TossTextStyles.h3,
                          ),
                          SizedBox(height: TossSpacing.space2),
                          Text(
                            error.toString(),
                            style: TossTextStyles.caption.copyWith(
                              color: TossColors.gray600,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: TossSpacing.space4),
                          TextButton(
                            onPressed: () => ref.refresh(companyRolesProvider),
                            child: const Text('Retry'),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          
          // Floating Add Button
          Positioned(
            bottom: TossSpacing.space5,
            left: TossSpacing.space5,
            right: TossSpacing.space5,
            child: SafeArea(
              child: ElevatedButton(
                onPressed: () => _showCreateRoleModal(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: TossColors.primary,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(
                    vertical: TossSpacing.space4,
                    horizontal: TossSpacing.space5,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 4,
                  shadowColor: TossColors.primary.withOpacity(0.3),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.add, size: 20),
                    SizedBox(width: TossSpacing.space2),
                    Text(
                      'Add New Role',
                      style: TossTextStyles.labelLarge.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSliverAppBar(BuildContext context) {
    return SliverAppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      pinned: true,
      floating: false,
      forceElevated: false,
      toolbarHeight: 60,
      title: Text(
        'Role & Permission',
        style: TossTextStyles.h2.copyWith(
          color: TossColors.gray900,
          fontWeight: FontWeight.w700,
          fontSize: 20,
        ),
      ),
      centerTitle: false,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_new, color: TossColors.gray900, size: 22),
        onPressed: () => context.go('/'),
      ),
    );
  }

  Widget _buildCompanyHeader(Map<String, dynamic> company) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(
        left: TossSpacing.space4,
        right: TossSpacing.space4,
        top: TossSpacing.space3,
        bottom: TossSpacing.space4,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            company['company_name'] ?? 'Company',
            style: TossTextStyles.h2.copyWith(
              color: TossColors.gray900,
              fontWeight: FontWeight.w700,
              fontSize: 22,
            ),
          ),
          SizedBox(height: TossSpacing.space1),
          Text(
            'Manage roles and permissions for your team',
            style: TossTextStyles.bodySmall.copyWith(
              color: TossColors.gray600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRoleCard(Role role) {
    // Note: Employee role should be editable like other roles
    final isEditable = role.roleType != 'owner';
    
    return Container(
      margin: EdgeInsets.only(bottom: TossSpacing.space3),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: isEditable ? () => _showEditRoleModal(context, role) : null,
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: EdgeInsets.all(TossSpacing.space4),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: TossColors.gray100,
                width: 1,
              ),
            ),
            child: Row(
              children: [
                // Role Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Role name with user count and permission badges
                      Row(
                        children: [
                          Text(
                            role.roleName,
                            style: TossTextStyles.bodyLarge.copyWith(
                              color: TossColors.gray900,
                              fontWeight: FontWeight.w600,
                              fontSize: 18,
                            ),
                          ),
                          SizedBox(width: TossSpacing.space3),
                          // User Count Badge
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: TossSpacing.space2,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: TossColors.primary.withOpacity(0.08),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.people_outline,
                                  size: 14,
                                  color: TossColors.primary,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  role.userCount.toString(),
                                  style: TossTextStyles.labelSmall.copyWith(
                                    color: TossColors.primary,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: TossSpacing.space2),
                          // Permission Count Badge
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: TossSpacing.space2,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: TossColors.gray100,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.security_outlined,
                                  size: 14,
                                  color: TossColors.gray600,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  role.permissionCount.toString(),
                                  style: TossTextStyles.labelSmall.copyWith(
                                    color: TossColors.gray600,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: TossSpacing.space1),
                      // Description or role type
                      _buildRoleTags(role),
                      // Tags chips
                      if (role.tags != null && role.tags!.isNotEmpty) ...[
                        SizedBox(height: TossSpacing.space2),
                        _buildRoleTagChips(role),
                      ],
                    ],
                  ),
                ),
                
                // Edit Indicator
                if (isEditable)
                  Icon(
                    Icons.chevron_right,
                    size: 20,
                    color: TossColors.gray400,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRoleTags(Role role) {
    // Check for owner role only (Employee should be editable)
    if (role.roleType == 'owner') {
      return Container(
        padding: EdgeInsets.symmetric(
          horizontal: TossSpacing.space2,
          vertical: 2,
        ),
        decoration: BoxDecoration(
          color: TossColors.warning.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          'System role • Cannot be modified',
          style: TossTextStyles.caption.copyWith(
            color: TossColors.warning,
            fontWeight: FontWeight.w600,
          ),
        ),
      );
    }
    
    // Show description or default text (not tags here - moved to separate widget)
    if (role.description != null && role.description!.isNotEmpty) {
      return Text(
        role.description!,
        style: TossTextStyles.bodySmall.copyWith(
          color: TossColors.gray600,
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      );
    }
    
    // Default text based on role type
    if (role.roleType == 'admin') {
      return Text(
        'System role',
        style: TossTextStyles.bodySmall.copyWith(
          color: TossColors.gray600,
        ),
      );
    }
    
    return Text(
      'Custom role',
      style: TossTextStyles.bodySmall.copyWith(
        color: TossColors.gray600,
      ),
    );
  }

  Widget _buildRoleTagChips(Role role) {
    final List<String> tagsList = [];
    
    if (role.tags != null && role.tags!.isNotEmpty) {
      // Parse tags from the database format
      role.tags!.forEach((key, value) {
        if (value != null && value.toString().isNotEmpty) {
          final tagValue = value.toString().trim();
          
          // Check if the value is a string array like "[Management, Operations]"
          if (tagValue.startsWith('[') && tagValue.endsWith(']')) {
            // Parse the string array
            String cleanedTags = tagValue.substring(1, tagValue.length - 1);
            final tags = cleanedTags
                .split(',')
                .map((tag) => tag.trim())
                .where((tag) => tag.isNotEmpty)
                .toList();
            tagsList.addAll(tags);
          } else {
            tagsList.add(tagValue);
          }
        }
      });
    }
    
    if (tagsList.isEmpty) return const SizedBox.shrink();
    
    return SizedBox(
      height: 24, // Fixed height for chips
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: tagsList.length,
        separatorBuilder: (context, index) => SizedBox(width: TossSpacing.space2),
        itemBuilder: (context, index) {
          return Container(
            padding: EdgeInsets.symmetric(
              horizontal: TossSpacing.space2,
              vertical: 4,
            ),
            decoration: BoxDecoration(
              color: TossColors.gray100,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: TossColors.gray200,
                width: 0.5,
              ),
            ),
            child: Text(
              tagsList[index],
              style: TossTextStyles.caption.copyWith(
                color: TossColors.gray700,
                fontWeight: FontWeight.w500,
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildNoCompanySelected() {
    return Scaffold(
      backgroundColor: TossColors.background,
      appBar: AppBar(
        title: Text('Role & Permission', style: TossTextStyles.h2),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.business_outlined,
              size: 64,
              color: TossColors.gray300,
            ),
            SizedBox(height: TossSpacing.space4),
            Text(
              'No Company Selected',
              style: TossTextStyles.h3.copyWith(
                color: TossColors.gray900,
              ),
            ),
            SizedBox(height: TossSpacing.space2),
            Text(
              'Please select a company to manage roles and permissions',
              style: TossTextStyles.body.copyWith(
                color: TossColors.gray500,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  void _showCreateRoleModal(BuildContext context) {
    final selectedCompany = ref.read(selectedCompanyProvider);
    if (selectedCompany == null) return;
    
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => CreateRoleModal(companyId: selectedCompany['company_id']),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: TossColors.gray100,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.supervised_user_circle_outlined,
              size: 40,
              color: TossColors.gray400,
            ),
          ),
          SizedBox(height: TossSpacing.space5),
          Text(
            'No roles yet',
            style: TossTextStyles.h2.copyWith(
              color: TossColors.gray900,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: TossSpacing.space2),
          Text(
            'Create custom roles to manage\nyour team permissions',
            style: TossTextStyles.body.copyWith(
              color: TossColors.gray500,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: TossSpacing.space8),
          SizedBox(
            width: 200,
            child: ElevatedButton(
              onPressed: () => _showCreateRoleModal(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: TossColors.primary,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(
                  vertical: TossSpacing.space4,
                  horizontal: TossSpacing.space5,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.add, size: 20),
                  SizedBox(width: TossSpacing.space2),
                  const Text('Create First Role'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showEditRoleModal(BuildContext context, Role role) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => EditRoleModal(role: role),
    );
  }
}