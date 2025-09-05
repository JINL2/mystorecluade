import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/themes/toss_colors.dart';
import '../../../../core/themes/toss_text_styles.dart';
import '../../../../core/themes/toss_spacing.dart';
import '../../../../core/themes/toss_border_radius.dart';
import '../../../../core/themes/toss_animations.dart';
import '../providers/delegate_role_providers.dart';
import '../../../../core/utils/tag_validator.dart';
import '../../../widgets/toss/toss_enhanced_text_field.dart';
import '../../../widgets/toss/toss_modal.dart';
import '../../../widgets/toss/modal_keyboard_patterns.dart';
import '../../../widgets/common/toss_loading_view.dart';
import 'package:myfinance_improved/core/themes/index.dart';

class RoleManagementSheet extends ConsumerStatefulWidget {
  final String roleId;
  final String roleName;
  final String? description;
  final List<String> tags;
  final List<String> permissions;
  final int memberCount;
  final bool canEdit;
  final bool canDelegate;

  const RoleManagementSheet({
    super.key,
    required this.roleId,
    required this.roleName,
    this.description,
    required this.tags,
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
    required List<String> tags,
    required List<String> permissions,
    required int memberCount,
    required bool canEdit,
    required bool canDelegate,
  }) {
    return TossModal.show(
      context: context,
      title: roleName,
      subtitle: canEdit ? 'Edit role details and permissions' : 'View role details',
      height: MediaQuery.of(context).size.height * 0.8,
      enableKeyboardToolbar: true,
      enableTapDismiss: true,
      keyboardDoneText: 'Done',
      child: RoleManagementSheet(
        roleId: roleId,
        roleName: roleName,
        description: description,
        tags: tags,
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
  final FocusNode _roleNameFocus = FocusNode();
  final FocusNode _descriptionFocus = FocusNode();
  bool _isLoading = false;
  bool _isEditingText = false;
  Set<String> _selectedPermissions = {};
  Set<String> _expandedCategories = {};
  
  // Tags functionality
  List<String> _selectedTags = [];
  
  // Tag colors mapping using Toss color system
  static final Map<String, Color> _tagColors = {
    'Critical': TossColors.error,
    'Support': TossColors.info,
    'Management': TossColors.primary,
    'Operations': TossColors.success,
    'Temporary': TossColors.warning,
    'Finance': TossColors.primary,
    'Sales': TossColors.success,
    'Marketing': TossColors.info,
    'Technical': TossColors.textSecondary,
    'Customer Service': TossColors.info,
    'Admin': TossColors.primary,
    'Restricted': TossColors.error,
  };

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: 3,
      vsync: this,
      animationDuration: TossAnimations.medium, // 250ms smooth transitions
    );
    _roleNameController = TextEditingController(text: widget.roleName);
    _descriptionController = TextEditingController(text: widget.description ?? _getDefaultRoleDescription());
    _selectedPermissions = Set.from(widget.permissions);
    _selectedTags = List.from(widget.tags); // Initialize tags from widget
    // Start with all categories collapsed
    _expandedCategories = {};
    
    // Add focus listeners to track text editing state
    _roleNameFocus.addListener(_onTextEditingStateChanged);
    _descriptionFocus.addListener(_onTextEditingStateChanged);
  }

  @override
  void dispose() {
    _roleNameFocus.removeListener(_onTextEditingStateChanged);
    _descriptionFocus.removeListener(_onTextEditingStateChanged);
    _tabController.dispose();
    _roleNameController.dispose();
    _descriptionController.dispose();
    _roleNameFocus.dispose();
    _descriptionFocus.dispose();
    super.dispose();
  }

  void _onTextEditingStateChanged() {
    final isEditing = _roleNameFocus.hasFocus || _descriptionFocus.hasFocus;
    if (_isEditingText != isEditing) {
      setState(() {
        _isEditingText = isEditing;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    
    return Container(
      constraints: BoxConstraints(
        maxHeight: screenHeight * 0.8,
      ),
      decoration: BoxDecoration(
        color: TossColors.background,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(TossBorderRadius.xl),
        ),
      ),
      child: Column(
        children: [
          // Top spacing only (no duplicate header - TossModal handles header)
          SizedBox(height: TossSpacing.space4),

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

          // Tab content - Use Flexible instead of Expanded to prevent overflow
          Flexible(
            child: TabBarView(
              controller: _tabController,
              physics: const NeverScrollableScrollPhysics(), // Disable swipe to prevent conflicts
              children: [
                _buildDetailsTab(),
                _buildPermissionsTab(),
                _buildMembersTab(),
              ],
            ),
          ),

          // TOSS-style bottom action with proper safe area
          // Hide save button when user is actively editing text
          if (widget.canEdit && !_isEditingText)
            Container(
              decoration: BoxDecoration(
                color: TossColors.background,
                border: Border(top: BorderSide(color: TossColors.gray200)),
              ),
              child: SafeArea(
                top: false,
                child: Padding(
                  padding: EdgeInsets.fromLTRB(
                    TossSpacing.space5,
                    TossSpacing.space4,
                    TossSpacing.space5,
                    TossSpacing.space4,
                  ),
                  child: SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: Material(
                      color: _isLoading ? TossColors.gray400 : TossColors.primary,
                      borderRadius: BorderRadius.circular(TossBorderRadius.md),
                      child: InkWell(
                        onTap: _isLoading ? null : _saveChanges,
                        borderRadius: BorderRadius.circular(TossBorderRadius.md),
                        splashColor: TossColors.white.withOpacity(0.1),
                        highlightColor: TossColors.white.withOpacity(0.05),
                        child: Container(
                          alignment: Alignment.center,
                      child: _isLoading
                          ? SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2.0,
                                valueColor: AlwaysStoppedAnimation<Color>(TossColors.white),
                              ),
                            )
                          : Text(
                              'Save Changes',
                              style: TossTextStyles.bodyLarge.copyWith(
                                color: TossColors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildDetailsTab() {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Column(
        children: [
          // Header section with title and description
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
              Text(
                'Role Details',
                style: TossTextStyles.h3.copyWith(
                  fontWeight: FontWeight.w700,
                  color: TossColors.gray900,
                ),
              ),
              SizedBox(height: TossSpacing.space1),
              Text(
                'Manage role information and configuration',
                style: TossTextStyles.body.copyWith(
                  color: TossColors.gray600,
                ),
              ),
              SizedBox(height: TossSpacing.space4),
              // Compact stats
              Container(
                padding: EdgeInsets.all(TossSpacing.space3),
                decoration: BoxDecoration(
                  color: TossColors.gray50,
                  borderRadius: BorderRadius.circular(TossBorderRadius.sm),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          Icon(
                            Icons.person,
                            size: TossSpacing.iconSM,
                            color: TossColors.gray600,
                          ),
                          SizedBox(width: TossSpacing.space2),
                          Text(
                            '${widget.memberCount} Members',
                            style: TossTextStyles.caption.copyWith(
                              color: TossColors.gray700,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: 1,
                      height: 16,
                      color: TossColors.gray300,
                    ),
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.shield_outlined,
                            size: TossSpacing.iconSM,
                            color: TossColors.gray600,
                          ),
                          SizedBox(width: TossSpacing.space2),
                          Text(
                            '${widget.permissions.length} Permissions',
                            style: TossTextStyles.caption.copyWith(
                              color: TossColors.gray700,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        
        // Scrollable form content with keyboard handling
        Expanded(
          child: ScrollableFormWrapper(
            padding: EdgeInsets.fromLTRB(
              TossSpacing.space5,
              0,
              TossSpacing.space5,
              TossSpacing.space10,
            ),
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
                TossEnhancedTextField(
                  controller: _roleNameController,
                  focusNode: _roleNameFocus,
                  enabled: widget.canEdit,
                  hintText: 'Enter role name',
                  textInputAction: TextInputAction.next,
                  showKeyboardToolbar: true,
                  keyboardDoneText: 'Next',
                  onKeyboardDone: () => _descriptionFocus.requestFocus(),
                  enableTapDismiss: false,
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
                TossEnhancedTextField(
                  controller: _descriptionController,
                  focusNode: _descriptionFocus,
                  enabled: widget.canEdit,
                  hintText: 'Describe what this role does...',
                  maxLines: 3,
                  textInputAction: TextInputAction.done,
                  showKeyboardToolbar: true,
                  keyboardDoneText: 'Done',
                  onKeyboardDone: () => FocusScope.of(context).unfocus(),
                  enableTapDismiss: false,
                ),

                SizedBox(height: TossSpacing.space5),

                // Tags section with minimal edit button
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Tags',
                      style: TossTextStyles.label.copyWith(
                        color: TossColors.gray700,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    if (widget.canEdit)
                      InkWell(
                        onTap: _showTagSelectionSheet,
                        borderRadius: BorderRadius.circular(TossBorderRadius.sm),
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: TossSpacing.space2,
                            vertical: TossSpacing.space1,
                          ),
                          child: Text(
                            'Edit',
                            style: TossTextStyles.caption.copyWith(
                              color: TossColors.primary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
                SizedBox(height: TossSpacing.space2),
                _buildTagsDisplay(),
              ],
            ),
          ),
        ),
      ],
      ),
    );
  }

  Widget _buildTagsDisplay() {
    if (_selectedTags.isNotEmpty) {
      return Wrap(
        spacing: TossSpacing.space2,
        runSpacing: TossSpacing.space2,
        children: _selectedTags.map((tag) => Container(
          padding: EdgeInsets.symmetric(
            horizontal: TossSpacing.space3,
            vertical: TossSpacing.space2,
          ),
          decoration: BoxDecoration(
            color: _getTagColor(tag).withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(TossBorderRadius.sm),
            border: Border.all(
              color: Color.alphaBlend(
                _getTagColor(tag).withOpacity(0.3),
                TossColors.background,
              ),
              width: 1,
            ),
          ),
          child: Text(
            tag,
            style: TossTextStyles.caption.copyWith(
              color: _getTagColor(tag),
              fontWeight: FontWeight.w600,
            ),
          ),
        )).toList(),
      );
    } else {
      return Container(
        padding: EdgeInsets.all(TossSpacing.space4),
        decoration: BoxDecoration(
          color: TossColors.gray50,
          borderRadius: BorderRadius.circular(TossBorderRadius.sm),
          border: Border.all(color: TossColors.gray200),
        ),
        child: Row(
          children: [
            Icon(Icons.label_outline, color: TossColors.gray400, size: TossSpacing.iconSM),
            SizedBox(width: TossSpacing.space2),
            Text(
              'No tags assigned',
              style: TossTextStyles.body.copyWith(
                color: TossColors.gray500,
              ),
            ),
          ],
        ),
      );
    }
  }
  
  void _showTagSelectionSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: TossColors.transparent,
      useRootNavigator: true, // Use root navigator to show modal on top
      enableDrag: true,
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Container(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height - 
                       MediaQuery.of(context).viewInsets.bottom - 
                       MediaQuery.of(context).padding.top - 100,
            minHeight: 300,
          ),
          child: _TagSelectionBottomSheet(
            selectedTags: List.from(_selectedTags),
            onTagsSelected: (tags) {
              setState(() {
                _selectedTags = tags;
              });
            },
          ),
        ),
      ),
    );
  }

  Color _getTagColor(String tag) {
    return _tagColors[tag] ?? TossColors.gray600;
  }

  Widget _buildPermissionsTab() {
    final rolePermissionsAsync = ref.watch(rolePermissionsProvider(widget.roleId));
    
    return rolePermissionsAsync.when(
      data: (permissionData) {
        final categories = permissionData['categories'] as List;
        
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
                                  if (_selectedPermissions.isEmpty) {
                                    // Select all available permissions
                                    final allFeatureIds = <String>[];
                                    for (final category in categories) {
                                      final features = (category['features'] as List? ?? [])
                                          .cast<Map<String, dynamic>>();
                                      for (final feature in features) {
                                        allFeatureIds.add(feature['feature_id'] as String);
                                      }
                                    }
                                    _selectedPermissions.addAll(allFeatureIds);
                                  } else {
                                    // Clear all selected permissions
                                    _selectedPermissions.clear();
                                  }
                                });
                              },
                              child: Text(
                                _selectedPermissions.isEmpty ? 'Select all' : 'Clear all',
                                style: TossTextStyles.body.copyWith(
                                  color: TossColors.gray600,
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
          child: TossLoadingView(),
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
        // Header section with title, description and Add Member button
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
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Team Members',
                          style: TossTextStyles.h3.copyWith(
                            fontWeight: FontWeight.w700,
                            color: TossColors.gray900,
                          ),
                        ),
                        SizedBox(height: TossSpacing.space1),
                        Text(
                          'Users assigned to this role',
                          style: TossTextStyles.body.copyWith(
                            color: TossColors.gray600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (widget.canEdit)
                    IconButton(
                      icon: Icon(Icons.add, size: 24, color: TossColors.primary),
                      onPressed: () => _showAddMemberModal(),
                      tooltip: 'Add Member',
                    ),
                ],
              ),
            ],
          ),
        ),

        // Members content
        Expanded(
          child: FutureBuilder<List<Map<String, dynamic>>>(
            future: _getRoleMembers(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: TossLoadingView(),
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
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
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
                padding: EdgeInsets.symmetric(horizontal: TossSpacing.space5),
                itemCount: members.length,
                separatorBuilder: (context, index) => Container(
                  margin: EdgeInsets.symmetric(vertical: TossSpacing.space2),
                  height: 0.5,
                  color: TossColors.gray200,
                ),
                itemBuilder: (context, index) {
                  final member = members[index];
                  return _buildMemberItem(
                    userId: member['user_id'],
                    name: member['name'] ?? 'Unknown User',
                    email: member['email'] ?? '',
                    joinedDate: _formatJoinDate(member['created_at']),
                  );
                },
              );
            },
          ),
        ),

      ],
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
            color: TossColors.transparent,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(TossBorderRadius.md),
              bottom: Radius.circular(isExpanded ? 0 : TossBorderRadius.md),
            ),
            child: InkWell(
              splashFactory: InkRipple.splashFactory, // Better ripple effect
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
                    // Select all checkbox - improved touch target and pixel alignment
                    Material(
                      color: TossColors.transparent,
                      child: InkWell(
                        onTap: widget.canEdit
                            ? () {
                                _toggleCategoryPermissions(featureIds, !allSelected);
                              }
                            : null,
                        borderRadius: BorderRadius.circular(TossBorderRadius.sm),
                        child: Container(
                          width: 32, // Increased touch target from 28 to 32 (8x4px grid)
                          height: 32, // Match width for square touch target
                          alignment: Alignment.center,
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            width: 20,
                            height: 20,
                            decoration: BoxDecoration(
                              color: allSelected
                                  ? TossColors.primary
                                  : someSelected
                                      ? Color.alphaBlend(
                                          TossColors.primary.withOpacity(0.3),
                                          TossColors.background,
                                        )
                                      : TossColors.background,
                              border: Border.all(
                                color: allSelected || someSelected
                                    ? TossColors.primary
                                    : TossColors.gray300,
                                width: allSelected || someSelected ? 2.0 : 1.0, // Use whole pixels only
                              ),
                              borderRadius: BorderRadius.circular(TossBorderRadius.sm),
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
                                          decoration: BoxDecoration(
                                            color: TossColors.white,
                                            borderRadius: BorderRadius.circular(TossBorderRadius.xs),
                                          ),
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
                            style: TossTextStyles.bodyLarge.copyWith(
                              fontWeight: FontWeight.w700,
                              color: TossColors.gray900,
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
                    // Expand/collapse icon - pixel-perfect alignment
                    Container(
                      width: 24,
                      height: 24,
                      alignment: Alignment.center,
                      child: AnimatedRotation(
                        turns: isExpanded ? 0.5 : 0,
                        duration: const Duration(milliseconds: 200),
                        child: Icon(
                          Icons.expand_more,
                          color: TossColors.gray600,
                          size: 24,
                        ),
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
                    color: TossColors.transparent,
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
                            SizedBox(width: TossSpacing.space8), // Use 32px (8x4) for better alignment
                            // Individual checkbox - pixel-perfect rendering
                            Container(
                              width: 32, // Increased touch target
                              height: 32,
                              alignment: Alignment.center,
                              child: AnimatedContainer(
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
                                    width: isSelected ? 2.0 : 1.0, // Use whole pixels
                                  ),
                                  borderRadius: BorderRadius.circular(TossBorderRadius.sm),
                                ),
                                child: isSelected
                                    ? Icon(
                                        Icons.check,
                                        size: 14,
                                        color: TossColors.white,
                                      )
                                    : null,
                              ),
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
    if (createdAt == null) return 'Role assigned recently';
    
    try {
      final date = DateTime.parse(createdAt.toString());
      final now = DateTime.now();
      final difference = now.difference(date);
      
      if (difference.inDays == 0) {
        return 'Role assigned today';
      } else if (difference.inDays == 1) {
        return 'Role assigned yesterday';
      } else if (difference.inDays < 7) {
        return 'Role assigned ${difference.inDays} days ago';
      } else if (difference.inDays < 30) {
        final weeks = (difference.inDays / 7).floor();
        return 'Role assigned $weeks week${weeks == 1 ? '' : 's'} ago';
      } else if (difference.inDays < 365) {
        final months = (difference.inDays / 30).floor();
        return 'Role assigned $months month${months == 1 ? '' : 's'} ago';
      } else {
        final years = (difference.inDays / 365).floor();
        return 'Role assigned $years year${years == 1 ? '' : 's'} ago';
      }
    } catch (e) {
      return 'Role assigned recently';
    }
  }

  Widget _buildMemberItem({
    required String userId,
    required String name,
    required String email,
    required String joinedDate,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: TossSpacing.space3),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: TossColors.gray200,
              borderRadius: BorderRadius.circular(TossBorderRadius.xxl),
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
                  style: TossTextStyles.bodyLarge.copyWith(
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
      // Update role details (name, description, and tags) first
      final updateDetails = ref.read(updateRoleDetailsProvider);
      await updateDetails(
        roleId: widget.roleId,
        roleName: _roleNameController.text.trim(),
        description: _descriptionController.text.trim().isEmpty 
            ? null 
            : _descriptionController.text.trim(),
        tags: _selectedTags,
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


  void _showAddMemberModal() {
    // Refresh data before showing the modal to ensure latest role assignments
    ref.invalidate(companyUsersProvider);
    
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: TossColors.transparent,
      barrierColor: TossColors.black54, // Standard dark barrier
      useRootNavigator: true, // Use root navigator to show modal on top
      enableDrag: true,
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Container(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height - 
                       MediaQuery.of(context).viewInsets.bottom - 
                       MediaQuery.of(context).padding.top - 100,
            minHeight: 300,
          ),
          child: _AddMemberBottomSheet(
            roleId: widget.roleId,
            roleName: widget.roleName,
            onMemberAdded: () {
              // Reactive state management: invalidate providers for immediate updates
              ref.invalidate(companyUsersProvider); // Refresh user list with updated roles
              setState(() {}); // Refresh the members list in this component
            },
          ),
        ),
      ),
    );
  }


  Widget _buildUnderlineTab(String text, int index) {
    return Expanded(
      child: AnimatedBuilder(
        animation: _tabController,
        builder: (context, child) {
          final isSelected = _tabController.index == index;
          
          return GestureDetector(
            onTap: () {
              if (_tabController.index != index) {
                _tabController.animateTo(
                  index,
                  duration: TossAnimations.medium,
                  curve: TossAnimations.standard,
                );
              }
            },
            child: AnimatedContainer(
              duration: TossAnimations.normal,
              curve: TossAnimations.standard,
              padding: EdgeInsets.symmetric(vertical: TossSpacing.space3),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: isSelected 
                        ? TossColors.gray900
                        : TossColors.transparent,
                    width: 2,
                  ),
                ),
              ),
              child: Center(
                child: // TODO: Review AnimatedDefaultTextStyle for TossTextStyles usage
AnimatedDefaultTextStyle(
                  duration: TossAnimations.normal,
                  curve: TossAnimations.standard,
                  style: TossTextStyles.body.copyWith(
                    color: isSelected 
                        ? TossColors.gray900
                        : TossColors.gray500,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                  ),
                  child: Text(text),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

// Add Member Bottom Sheet
class _AddMemberBottomSheet extends ConsumerStatefulWidget {
  final String roleId;
  final String roleName;
  final VoidCallback onMemberAdded;

  const _AddMemberBottomSheet({
    required this.roleId,
    required this.roleName,
    required this.onMemberAdded,
  });

  @override
  ConsumerState<_AddMemberBottomSheet> createState() => _AddMemberBottomSheetState();
}

class _AddMemberBottomSheetState extends ConsumerState<_AddMemberBottomSheet> {
  String? _selectedUserId;
  bool _isAssigning = false;
  bool _isLoadingRoleAssignments = true;
  Map<String, String?> _userRoleAssignments = {}; // userId -> roleId mapping

  @override
  void initState() {
    super.initState();
    // Always load fresh role assignments when modal opens
    _loadUserRoleAssignments();
  }

  Future<void> _loadUserRoleAssignments() async {
    if (!mounted) return;
    
    setState(() => _isLoadingRoleAssignments = true);
    
    try {
      final supabase = Supabase.instance.client;
      
      // Get the company ID for this role with timeout
      final roleData = await supabase
          .from('roles')
          .select('company_id')
          .eq('role_id', widget.roleId)
          .single()
          .timeout(const Duration(seconds: 5));
      
      final companyId = roleData['company_id'];
      
      // Get all role assignments for users in this company with timeout
      final userRoles = await supabase
          .from('user_roles')
          .select('user_id, role_id, role:roles!role_id(company_id)')
          .eq('is_deleted', false)
          .timeout(const Duration(seconds: 10));
      
      final assignments = <String, String?>{};
      
      for (final userRole in userRoles) {
        final userId = userRole['user_id'] as String;
        final roleId = userRole['role_id'] as String;
        final role = userRole['role'] as Map<String, dynamic>?;
        
        // Only include roles from the current company
        if (role != null && role['company_id'] == companyId) {
          assignments[userId] = roleId;
        }
      }
      
      if (mounted) {
        setState(() {
          _userRoleAssignments = assignments;
          _isLoadingRoleAssignments = false;
        });
      }
    } catch (e) {
      // Graceful degradation: role name validation will still work
      if (mounted) {
        setState(() => _isLoadingRoleAssignments = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final companyUsersAsync = ref.watch(companyUsersProvider);
    
    // Refresh role assignments when companyUsersProvider updates
    companyUsersAsync.whenData((users) {
      if (mounted) {
        _loadUserRoleAssignments();
      }
    });
    
    return Container(
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
              color: TossColors.gray300, // Restore grey handle bar
              borderRadius: BorderRadius.circular(TossBorderRadius.xs),
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
                        'Add Member to ${widget.roleName}',
                        style: TossTextStyles.h2.copyWith(
                          fontWeight: FontWeight.w700,
                          color: TossColors.gray900,
                        ),
                      ),
                      Text(
                        'Select a user to assign to this role',
                        style: TossTextStyles.bodySmall.copyWith(
                          color: TossColors.gray600,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.close, color: TossColors.gray600),
                  onPressed: () {
                    FocusScope.of(context).unfocus();
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),

          // Users list
          Expanded(
            child: companyUsersAsync.when(
              data: (users) {
                if (users.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.people_outline,
                          size: 64,
                          color: TossColors.gray300,
                        ),
                        SizedBox(height: TossSpacing.space4),
                        Text(
                          'No users found',
                          style: TossTextStyles.h3.copyWith(
                            color: TossColors.gray600,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.separated(
                  padding: EdgeInsets.symmetric(horizontal: TossSpacing.space5),
                  itemCount: users.length,
                  separatorBuilder: (context, index) => Container(
                    margin: EdgeInsets.symmetric(vertical: TossSpacing.space1),
                    height: 0.5,
                    color: TossColors.gray200,
                  ),
                  itemBuilder: (context, index) {
                    final user = users[index];
                    final userId = user['id'] as String;
                    final userName = user['name'] as String;
                    final userEmail = user['email'] as String;
                    final currentRole = user['role'] as String;
                    final isSelected = _selectedUserId == userId;
                    
                    // Check if user is owner or already has the target role
                    final isOwner = currentRole.toLowerCase() == 'owner';
                    final hasTargetRole = _isUserAlreadyAssigned(userId, currentRole);
                    final isDisabled = isOwner || hasTargetRole;

                    return Material(
                      color: TossColors.transparent,
                      child: InkWell(
                        onTap: isDisabled ? null : () {
                          setState(() {
                            _selectedUserId = isSelected ? null : userId;
                          });
                        },
                        borderRadius: BorderRadius.circular(TossBorderRadius.sm),
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: TossSpacing.space3),
                          decoration: BoxDecoration(
                            color: isSelected 
                                ? Color.alphaBlend(
                                    TossColors.primary.withOpacity(0.1),
                                    TossColors.background,
                                  )
                                : TossColors.transparent,
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 44,
                                height: 44,
                                decoration: BoxDecoration(
                                  color: isOwner 
                                      ? Color.alphaBlend(
                                    TossColors.primary.withOpacity(0.1),
                                    TossColors.background,
                                  )
                                      : isDisabled
                                          ? TossColors.gray100
                                          : TossColors.gray200,
                                  borderRadius: BorderRadius.circular(TossBorderRadius.xxl),
                                ),
                                child: Icon(
                                  isOwner ? Icons.star : Icons.person, 
                                  color: isOwner 
                                      ? TossColors.primary
                                      : isDisabled
                                          ? TossColors.gray400
                                          : TossColors.gray600,
                                ),
                              ),
                              SizedBox(width: TossSpacing.space3),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            userName,
                                            style: TossTextStyles.body.copyWith(
                                              fontWeight: FontWeight.w600,
                                              color: isDisabled 
                                                  ? TossColors.gray500
                                                  : TossColors.gray900,
                                            ),
                                          ),
                                        ),
                                        _buildRoleBadge(currentRole, hasTargetRole),
                                      ],
                                    ),
                                    Text(
                                      userEmail,
                                      style: TossTextStyles.bodySmall.copyWith(
                                        color: isDisabled 
                                            ? TossColors.gray400
                                            : TossColors.gray600,
                                      ),
                                    ),
                                    Text(
                                      'Current: $currentRole',
                                      style: TossTextStyles.caption.copyWith(
                                        color: isDisabled 
                                            ? TossColors.gray400
                                            : TossColors.gray500,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              if (isSelected)
                                Icon(
                                  Icons.check_circle,
                                  color: TossColors.primary,
                                  size: 24,
                                ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
              loading: () => Center(
                child: TossLoadingView(),
              ),
              error: (error, stack) => Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.error_outline, color: TossColors.error, size: 48),
                    SizedBox(height: TossSpacing.space3),
                    Text(
                      'Failed to load users',
                      style: TossTextStyles.body.copyWith(color: TossColors.error),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Bottom action
          Container(
            decoration: BoxDecoration(
              color: TossColors.background,
              border: Border(top: BorderSide(color: TossColors.gray200)),
            ),
            child: SafeArea(
              top: false,
              child: Padding(
                padding: EdgeInsets.fromLTRB(
                  TossSpacing.space5,
                  TossSpacing.space4,
                  TossSpacing.space5,
                  TossSpacing.space4,
                ),
                child: SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: _selectedUserId == null || _isAssigning 
                        ? null 
                        : _assignUserToRole,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: TossColors.primary,
                      foregroundColor: TossColors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(TossBorderRadius.md),
                      ),
                      elevation: 0,
                    ),
                    child: _isAssigning
                        ? SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2.0,
                              valueColor: AlwaysStoppedAnimation<Color>(TossColors.white),
                            ),
                          )
                        : Text(
                            'Add Member',
                            style: TossTextStyles.bodyLarge.copyWith(
                              color: TossColors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  bool _isUserAlreadyAssigned(String userId, String currentRole) {
    // Normalize inputs for reliable comparison
    final normalizedCurrentRole = currentRole.toLowerCase().trim();
    final normalizedTargetRole = widget.roleName.toLowerCase().trim();
    
    // Handle comma-separated roles from STRING_AGG (e.g., "Employee, Manager")
    final hasRoleByName = normalizedCurrentRole == normalizedTargetRole ||
                         normalizedCurrentRole.contains(', $normalizedTargetRole') ||
                         normalizedCurrentRole.contains('$normalizedTargetRole,');
    
    // Layer 2: Role ID validation (database-level accuracy)
    final hasRoleById = !_isLoadingRoleAssignments && 
                       _userRoleAssignments.containsKey(userId) && 
                       _userRoleAssignments[userId] == widget.roleId;
    
    // During loading, rely on role name; after loading, use both validations
    if (_isLoadingRoleAssignments) {
      return hasRoleByName;
    }
    
    // Post-loading: either validation method confirming assignment is sufficient
    return hasRoleByName || hasRoleById;
  }

  Widget _buildRoleBadge(String currentRole, bool hasTargetRole) {
    // Only show badge for users who already have the target role
    if (hasTargetRole) {
      return Container(
        padding: EdgeInsets.symmetric(
          horizontal: TossSpacing.space2,
          vertical: TossSpacing.space1,
        ),
        decoration: BoxDecoration(
          color: TossColors.warning.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(TossBorderRadius.xs),
          border: Border.all(
            color: TossColors.warning.withValues(alpha: 0.3),
            width: 1,
          ),
        ),
        child: Text(
          'Already Assigned',
          style: TossTextStyles.caption.copyWith(
            color: TossColors.warning,
            fontWeight: FontWeight.w600,
          ),
        ),
      );
    }
    
    // No badge for owners or normal users - clean design
    return SizedBox.shrink();
  }

  Future<void> _assignUserToRole() async {
    if (_selectedUserId == null) return;

    setState(() => _isAssigning = true);

    try {
      final supabase = Supabase.instance.client;
      
      // Double-check validation before assignment
      final companyUsersAsync = ref.read(companyUsersProvider);
      final users = companyUsersAsync.value ?? [];
      final selectedUser = users.firstWhere(
        (user) => user['id'] == _selectedUserId,
        orElse: () => {},
      );
      
      if (selectedUser.isNotEmpty) {
        final currentRole = selectedUser['role'] as String;
        if (_isUserAlreadyAssigned(_selectedUserId!, currentRole)) {
          throw Exception('User is already assigned to this role');
        }
      }
      
      // Get the company_id for this role with timeout
      final roleData = await supabase
          .from('roles')
          .select('company_id')
          .eq('role_id', widget.roleId)
          .single()
          .timeout(const Duration(seconds: 10));
      
      final companyId = roleData['company_id'];
      
      // Check if user already has this exact role (database-level validation)
      final existingExactRole = await supabase
          .from('user_roles')
          .select('user_role_id')
          .eq('user_id', _selectedUserId!)
          .eq('role_id', widget.roleId)
          .eq('is_deleted', false)
          .timeout(const Duration(seconds: 10));

      if (existingExactRole.isNotEmpty) {
        throw Exception('User is already assigned to this role');
      }
      
      // Get all roles for this company to find any existing role
      final companyRoles = await supabase
          .from('roles')
          .select('role_id')
          .eq('company_id', companyId)
          .timeout(const Duration(seconds: 10));
      
      final roleIds = companyRoles.map((r) => r['role_id']).toList();
      
      // Check if user has any role in this company
      final existingUserRoles = await supabase
          .from('user_roles')
          .select('user_role_id, role_id')
          .eq('user_id', _selectedUserId!)
          .inFilter('role_id', roleIds)
          .eq('is_deleted', false)
          .timeout(const Duration(seconds: 10));
      
      if (existingUserRoles.isNotEmpty) {
        // User has an existing role in this company - update it
        // The trigger will handle deactivating the old role
        await supabase.from('user_roles').insert({
          'user_id': _selectedUserId!,
          'role_id': widget.roleId,
          'created_at': DateTime.now().toIso8601String(),
          'updated_at': DateTime.now().toIso8601String(),
          'is_deleted': false,
        }).timeout(const Duration(seconds: 15));
      } else {
        // User has no role in this company - simply insert
        await supabase.from('user_roles').insert({
          'user_id': _selectedUserId!,
          'role_id': widget.roleId,
          'created_at': DateTime.now().toIso8601String(),
          'updated_at': DateTime.now().toIso8601String(),
          'is_deleted': false,
        }).timeout(const Duration(seconds: 15));
      }

      if (mounted) {
        Navigator.pop(context);
        
        // Reactive state management: invalidate providers for cross-screen updates
        ref.invalidate(companyUsersProvider); // Refresh user roles in Add Member modal
        ref.invalidate(allCompanyRolesProvider); // Refresh role member counts
        
        // Update local role assignments to reflect the change immediately
        _userRoleAssignments[_selectedUserId!] = widget.roleId;
        
        widget.onMemberAdded();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Member added to ${widget.roleName} successfully'),
            backgroundColor: TossColors.success,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to add member: $e'),
            backgroundColor: TossColors.error,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isAssigning = false);
      }
    }
  }
}

// Tag Selection Bottom Sheet
class _TagSelectionBottomSheet extends StatefulWidget {
  final List<String> selectedTags;
  final Function(List<String>) onTagsSelected;

  const _TagSelectionBottomSheet({
    required this.selectedTags,
    required this.onTagsSelected,
  });

  @override
  State<_TagSelectionBottomSheet> createState() => _TagSelectionBottomSheetState();
}

class _TagSelectionBottomSheetState extends State<_TagSelectionBottomSheet> {
  late List<String> _selectedTags;
  
  // Predefined suggested tags (same as in RoleManagementSheet)
  static const List<String> _suggestedTags = [
    'Critical', 'Support', 'Management', 'Operations', 
    'Temporary', 'Finance', 'Sales', 'Marketing',
    'Technical', 'Customer Service', 'Admin', 'Restricted'
  ];
  
  // Tag colors mapping using Toss color system
  static final Map<String, Color> _tagColors = {
    'Critical': TossColors.error,
    'Support': TossColors.info,
    'Management': TossColors.primary,
    'Operations': TossColors.success,
    'Temporary': TossColors.warning,
    'Finance': TossColors.primary,
    'Sales': TossColors.success,
    'Marketing': TossColors.info,
    'Technical': TossColors.textSecondary,
    'Customer Service': TossColors.info,
    'Admin': TossColors.primary,
    'Restricted': TossColors.error,
  };

  @override
  void initState() {
    super.initState();
    _selectedTags = List.from(widget.selectedTags);
  }

  @override
  void dispose() {
    super.dispose();
  }

  Color _getTagColor(String tag) {
    return _tagColors[tag] ?? TossColors.gray600;
  }

  void _toggleTag(String tag) {
    setState(() {
      if (_selectedTags.contains(tag)) {
        _selectedTags.remove(tag);
      } else {
        if (_selectedTags.length < TagValidator.MAX_TAGS) {
          _selectedTags.add(tag);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Maximum ${TagValidator.MAX_TAGS} tags allowed'),
              backgroundColor: TossColors.warning,
            ),
          );
        }
      }
    });
  }


  @override
  Widget build(BuildContext context) {
    return Container(
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
              color: TossColors.gray300, // Restore grey handle bar
              borderRadius: BorderRadius.circular(TossBorderRadius.xs),
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
                        'Edit Tags',
                        style: TossTextStyles.h2.copyWith(
                          fontWeight: FontWeight.w700,
                          color: TossColors.gray900,
                        ),
                      ),
                      SizedBox(height: TossSpacing.space1),
                      Text(
                        'Add up to ${TagValidator.MAX_TAGS} tags to help categorize this role',
                        style: TossTextStyles.bodySmall.copyWith(
                          color: TossColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.close, color: TossColors.gray600),
                  onPressed: () {
                    FocusScope.of(context).unfocus();
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),

          // Content
          Expanded(
            child: SingleChildScrollView(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              padding: EdgeInsets.all(TossSpacing.space5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Selected tags display (similar to Create Role modal)
                  if (_selectedTags.isNotEmpty) ...[
                    Container(
                      padding: EdgeInsets.all(TossSpacing.space4),
                      decoration: BoxDecoration(
                        color: TossColors.gray50,
                        borderRadius: BorderRadius.circular(TossBorderRadius.md),
                        border: Border.all(
                          color: TossColors.gray200,
                          width: 1,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Selected Tags',
                                style: TossTextStyles.caption.copyWith(
                                  color: TossColors.textSecondary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Text(
                                '${_selectedTags.length}/${TagValidator.MAX_TAGS}',
                                style: TossTextStyles.caption.copyWith(
                                  color: _selectedTags.length >= TagValidator.MAX_TAGS 
                                      ? TossColors.primary 
                                      : TossColors.textSecondary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: TossSpacing.space3),
                          Wrap(
                            spacing: TossSpacing.space2,
                            runSpacing: TossSpacing.space2,
                            children: _selectedTags.map((tag) => Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: TossSpacing.space2,
                                vertical: TossSpacing.space1,
                              ),
                              decoration: BoxDecoration(
                                color: Color.alphaBlend(
                _getTagColor(tag).withOpacity(0.1),
                TossColors.background,
              ),
                                borderRadius: BorderRadius.circular(TossBorderRadius.sm),
                                border: Border.all(
                                  color: Color.alphaBlend(
                _getTagColor(tag).withOpacity(0.3),
                TossColors.background,
              ),
                                  width: 1,
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    tag,
                                    style: TossTextStyles.caption.copyWith(
                                      color: _getTagColor(tag),
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  SizedBox(width: TossSpacing.space1),
                                  InkWell(
                                    onTap: () => _toggleTag(tag),
                                    borderRadius: BorderRadius.circular(TossBorderRadius.full),
                                    child: Icon(
                                      Icons.close,
                                      size: 14,
                                      color: _getTagColor(tag),
                                    ),
                                  ),
                                ],
                              ),
                            )).toList(),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: TossSpacing.space4),
                  ],

                  // Suggested tags
                  if (_selectedTags.length < TagValidator.MAX_TAGS) ...[
                    Text(
                      'Suggested Tags',
                      style: TossTextStyles.caption.copyWith(
                        color: TossColors.textSecondary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: TossSpacing.space2),
                    Wrap(
                      spacing: TossSpacing.space2,
                      runSpacing: TossSpacing.space2,
                      children: _suggestedTags
                          .where((tag) => !_selectedTags.contains(tag))
                          .map((tag) => Material(
                        color: TossColors.transparent,
                        child: InkWell(
                          onTap: () => _toggleTag(tag),
                          borderRadius: BorderRadius.circular(TossBorderRadius.sm),
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: TossSpacing.space3,
                              vertical: TossSpacing.space2,
                            ),
                            decoration: BoxDecoration(
                              color: TossColors.gray100,
                              borderRadius: BorderRadius.circular(TossBorderRadius.sm),
                              border: Border.all(
                                color: TossColors.gray200,
                                width: 1,
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.add,
                                  size: 14,
                                  color: TossColors.textSecondary,
                                ),
                                SizedBox(width: TossSpacing.space1),
                                Text(
                                  tag,
                                  style: TossTextStyles.caption.copyWith(
                                    color: TossColors.textSecondary,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      )).toList(),
                    ),
                  ],
                  
                  SizedBox(height: TossSpacing.space10),
                ],
              ),
            ),
          ),

          // Bottom action
          Container(
            decoration: BoxDecoration(
              color: TossColors.background,
              border: Border(top: BorderSide(color: TossColors.gray200)),
            ),
            child: SafeArea(
              top: false,
              child: Padding(
                padding: EdgeInsets.fromLTRB(
                  TossSpacing.space5,
                  TossSpacing.space4,
                  TossSpacing.space5,
                  TossSpacing.space4,
                ),
                child: SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: Material(
                    color: TossColors.primary,
                    borderRadius: BorderRadius.circular(TossBorderRadius.md),
                    child: InkWell(
                      onTap: () {
                        widget.onTagsSelected(_selectedTags);
                        Navigator.pop(context);
                      },
                      borderRadius: BorderRadius.circular(TossBorderRadius.md),
                      splashColor: TossColors.white.withOpacity(0.1),
                      highlightColor: TossColors.white.withOpacity(0.05),
                      child: Container(
                        alignment: Alignment.center,
                        child: Text(
                          'Save Tags',
                          style: TossTextStyles.bodyLarge.copyWith(
                            color: TossColors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

