import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:myfinance_improved/core/utils/tag_validator.dart';
import 'package:myfinance_improved/shared/themes/toss_animations.dart';
import 'package:myfinance_improved/shared/themes/toss_border_radius.dart';
import 'package:myfinance_improved/shared/themes/toss_colors.dart';
import 'package:myfinance_improved/shared/themes/toss_spacing.dart';
import 'package:myfinance_improved/shared/themes/toss_text_styles.dart';
import 'package:myfinance_improved/shared/widgets/common/toss_loading_view.dart';
import 'package:myfinance_improved/shared/widgets/common/toss_success_error_dialog.dart';
import 'package:myfinance_improved/shared/widgets/toss/modal_keyboard_patterns.dart';
import 'package:myfinance_improved/shared/widgets/toss/toss_enhanced_text_field.dart';
import 'package:myfinance_improved/shared/widgets/toss/toss_modal.dart';

import '../providers/repositories/repository_providers.dart';
import '../providers/state/state_providers.dart';
import '../providers/usecases/usecase_providers.dart';

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
      padding: EdgeInsets.zero, // Remove TossModal's default padding to prevent double scroll
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

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
          // Underline-style tabs
          Container(
            margin: const EdgeInsets.symmetric(horizontal: TossSpacing.space5),
            child: Row(
              children: [
                _buildUnderlineTab('Details', 0),
                _buildUnderlineTab('Permissions', 1),
                _buildUnderlineTab('Members', 2),
              ],
            ),
          ),

          // Tab content with fixed height
          SizedBox(
            height: screenHeight * 0.5, // Fixed height for TabBarView
            child: TabBarView(
              controller: _tabController,
              physics: const NeverScrollableScrollPhysics(),
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
              decoration: const BoxDecoration(
                color: TossColors.background,
                border: Border(top: BorderSide(color: TossColors.gray200)),
              ),
              child: SafeArea(
                top: false,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(
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
                          ? const SizedBox(
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
    );
  }

  Widget _buildDetailsTab() {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Column(
        children: [
          // Header section with title and description
          Container(
            padding: const EdgeInsets.fromLTRB(
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
              const SizedBox(height: TossSpacing.space1),
              Text(
                'Manage role information and configuration',
                style: TossTextStyles.body.copyWith(
                  color: TossColors.gray600,
                ),
              ),
              const SizedBox(height: TossSpacing.space4),
              // Compact stats
              Container(
                padding: const EdgeInsets.all(TossSpacing.space3),
                decoration: BoxDecoration(
                  color: TossColors.gray50,
                  borderRadius: BorderRadius.circular(TossBorderRadius.sm),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          const Icon(
                            Icons.person,
                            size: TossSpacing.iconSM,
                            color: TossColors.gray600,
                          ),
                          const SizedBox(width: TossSpacing.space2),
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
                          const Icon(
                            Icons.shield_outlined,
                            size: TossSpacing.iconSM,
                            color: TossColors.gray600,
                          ),
                          const SizedBox(width: TossSpacing.space2),
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
            padding: const EdgeInsets.fromLTRB(
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
                const SizedBox(height: TossSpacing.space2),
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

                const SizedBox(height: TossSpacing.space5),

                // Role description
                Text(
                  'Description',
                  style: TossTextStyles.label.copyWith(
                    color: TossColors.gray700,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: TossSpacing.space2),
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

                const SizedBox(height: TossSpacing.space5),

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
                          padding: const EdgeInsets.symmetric(
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
                const SizedBox(height: TossSpacing.space2),
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
          padding: const EdgeInsets.symmetric(
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
        ),).toList(),
      );
    } else {
      return Container(
        padding: const EdgeInsets.all(TossSpacing.space4),
        decoration: BoxDecoration(
          color: TossColors.gray50,
          borderRadius: BorderRadius.circular(TossBorderRadius.sm),
          border: Border.all(color: TossColors.gray200),
        ),
        child: Row(
          children: [
            const Icon(Icons.label_outline, color: TossColors.gray400, size: TossSpacing.iconSM),
            const SizedBox(width: TossSpacing.space2),
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

        return SingleChildScrollView(
          primary: true,
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(
            TossSpacing.space5,
            TossSpacing.space5,
            TossSpacing.space5,
            TossSpacing.space10,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header section
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
                        const SizedBox(height: TossSpacing.space1),
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
              const SizedBox(height: TossSpacing.space4),

              // Permission categories
              ...categories.map((category) {
                final categoryName = category['category_name'] as String;
                final features = (category['features'] as List? ?? [])
                    .cast<Map<String, dynamic>>();

                if (features.isEmpty) return const SizedBox.shrink();

                return _buildPermissionCategory(categoryName, features);
              }),
            ],
          ),
        );
      },
      loading: () => const Center(
        child: Padding(
          padding: EdgeInsets.all(TossSpacing.space10),
          child: TossLoadingView(),
        ),
      ),
      error: (error, stack) => Center(
        child: Padding(
          padding: const EdgeInsets.all(TossSpacing.space5),
          child: Column(
            children: [
              const Icon(Icons.error_outline, color: TossColors.error, size: 48),
              const SizedBox(height: TossSpacing.space3),
              Text(
                'Failed to load permissions',
                style: TossTextStyles.body.copyWith(color: TossColors.error),
              ),
              const SizedBox(height: TossSpacing.space2),
              ElevatedButton(
                onPressed: () => ref.invalidate(rolePermissionsProvider(widget.roleId)),
                child: const Text('Retry'),
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
          padding: const EdgeInsets.fromLTRB(
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
                        const SizedBox(height: TossSpacing.space1),
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
                      icon: const Icon(Icons.add, size: 24, color: TossColors.primary),
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
                return const Center(
                  child: TossLoadingView(),
                );
              }
              
              if (snapshot.hasError) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.error_outline, color: TossColors.error, size: 48),
                      const SizedBox(height: TossSpacing.space3),
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
                      const Icon(
                        Icons.people_outline,
                        size: 64,
                        color: TossColors.gray300,
                      ),
                      const SizedBox(height: TossSpacing.space4),
                      Text(
                        'No team members yet',
                        style: TossTextStyles.h3.copyWith(
                          color: TossColors.gray600,
                        ),
                      ),
                      const SizedBox(height: TossSpacing.space2),
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
                padding: const EdgeInsets.symmetric(horizontal: TossSpacing.space5),
                itemCount: members.length,
                separatorBuilder: (context, index) => Container(
                  margin: const EdgeInsets.symmetric(vertical: TossSpacing.space2),
                  height: 0.5,
                  color: TossColors.gray200,
                ),
                itemBuilder: (context, index) {
                  final member = members[index];
                  return _buildMemberItem(
                    userId: member['user_id'] as String,
                    name: (member['name'] as String?) ?? 'Unknown User',
                    email: (member['email'] as String?) ?? '',
                    joinedDate: _formatJoinDate(member['created_at'] as String?),
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
      margin: const EdgeInsets.only(bottom: TossSpacing.space3),
      decoration: BoxDecoration(
        color: TossColors.surface,
        borderRadius: BorderRadius.circular(TossBorderRadius.md),
        border: Border.all(
          color: TossColors.gray200,
          width: 1,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Collapsible header with select all
          Material(
            color: TossColors.transparent,
            borderRadius: BorderRadius.vertical(
              top: const Radius.circular(TossBorderRadius.md),
              bottom: Radius.circular(isExpanded ? 0 : TossBorderRadius.md),
            ),
            child: InkWell(
              splashFactory: InkRipple.splashFactory, // Better ripple effect
              excludeFromSemantics: true,
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
                top: const Radius.circular(TossBorderRadius.md),
                bottom: Radius.circular(isExpanded ? 0 : TossBorderRadius.md),
              ),
              child: Container(
                padding: const EdgeInsets.all(TossSpacing.space4),
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
                                ? const Icon(
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
                    const SizedBox(width: TossSpacing.space3),
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
                        child: const Icon(
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
              decoration: const BoxDecoration(
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
                      excludeFromSemantics: true,
                      onTap: widget.canEdit ? () => _togglePermission(featureId) : null,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: TossSpacing.space4,
                          vertical: TossSpacing.space3,
                        ),
                        decoration: const BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              color: TossColors.gray100,
                              width: 1,
                            ),
                          ),
                        ),
                        child: Row(
                          children: [
                            const SizedBox(width: TossSpacing.space8), // Use 32px (8x4) for better alignment
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
                                    ? const Icon(
                                        Icons.check,
                                        size: 14,
                                        color: TossColors.white,
                                      )
                                    : null,
                              ),
                            ),
                            const SizedBox(width: TossSpacing.space3),
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
    try {
      // ✅ Use GetRoleMembersUseCase instead of direct Supabase access
      final getRoleMembersUseCase = ref.read(getRoleMembersUseCaseProvider);
      final members = await getRoleMembersUseCase.execute(widget.roleId);
      return members;
    } catch (e) {
      // Handle errors gracefully
      debugPrint('Error fetching role members: $e');
      return [];
    }
  }

  String _formatJoinDate(dynamic createdAt) {
    if (createdAt == null) return 'Role assigned recently';

    try {
      // Parse the datetime string (should already be in local time from data source)
      // but DateTime.parse will preserve the timezone
      final date = DateTime.parse(createdAt.toString());
      // Ensure we're comparing in local time
      final dateLocal = date.isUtc ? date.toLocal() : date;
      final now = DateTime.now();
      final difference = now.difference(dateLocal);
      
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
      padding: const EdgeInsets.symmetric(vertical: TossSpacing.space3),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: TossColors.gray200,
              borderRadius: BorderRadius.circular(TossBorderRadius.xxl),
            ),
            child: const Icon(Icons.person, color: TossColors.gray600),
          ),
          const SizedBox(width: TossSpacing.space3),
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
        Navigator.pop(context);

        // Show success dialog
        await showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => TossDialog.success(
            title: 'Role Updated Successfully!',
            message: 'Role permissions have been updated',
            primaryButtonText: 'Done',
            onPrimaryPressed: () => context.pop(),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        // Show error dialog
        await showDialog(
          context: context,
          barrierDismissible: true,
          builder: (context) => TossDialog.error(
            title: 'Failed to Update Role',
            message: 'Could not update role permissions: $e',
            primaryButtonText: 'OK',
            onPrimaryPressed: () => context.pop(),
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
              padding: const EdgeInsets.symmetric(vertical: TossSpacing.space3),
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
      // ✅ Use GetUserRoleAssignmentsUseCase instead of direct Supabase access
      final getUserRoleAssignmentsUseCase = ref.read(getUserRoleAssignmentsUseCaseProvider);
      final roleRepository = ref.read(roleRepositoryProvider);

      // Get role to extract company ID
      final role = await roleRepository.getRoleById(widget.roleId);

      // Get all user role assignments for this company
      final assignments = await getUserRoleAssignmentsUseCase.execute(
        roleId: widget.roleId,
        companyId: role.companyId,
      );

      if (mounted) {
        setState(() {
          _userRoleAssignments = assignments;
          _isLoadingRoleAssignments = false;
        });
      }
    } catch (e) {
      // Graceful degradation: role name validation will still work
      debugPrint('Error loading user role assignments: $e');
      if (mounted) {
        setState(() => _isLoadingRoleAssignments = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // First get the role data to extract companyId
    final roleAsync = ref.watch(roleByIdProvider(widget.roleId));

    return Container(
      decoration: const BoxDecoration(
        color: TossColors.background,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(TossBorderRadius.xl),
        ),
      ),
      child: Column(
        children: [
          // Handle bar
          Container(
            margin: const EdgeInsets.only(top: TossSpacing.space3),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: TossColors.gray300, // Restore grey handle bar
              borderRadius: BorderRadius.circular(TossBorderRadius.xs),
            ),
          ),

          // Header
          Padding(
            padding: const EdgeInsets.all(TossSpacing.space5),
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
                  icon: const Icon(Icons.close, color: TossColors.gray600),
                  onPressed: () {
                    FocusScope.of(context).unfocus();
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),

          // Users list - fetch users after getting companyId from role
          Expanded(
            child: roleAsync.when(
              data: (role) {
                // Now fetch users for this company
                final companyUsersAsync = ref.watch(companyUsersProvider(role.companyId));

                return companyUsersAsync.when(
                  data: (users) {
                    if (users.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.people_outline,
                          size: 64,
                          color: TossColors.gray300,
                        ),
                        const SizedBox(height: TossSpacing.space4),
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
                  padding: const EdgeInsets.symmetric(horizontal: TossSpacing.space5),
                  itemCount: users.length,
                  separatorBuilder: (context, index) => Container(
                    margin: const EdgeInsets.symmetric(vertical: TossSpacing.space1),
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
                          padding: const EdgeInsets.symmetric(vertical: TossSpacing.space3),
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
                              const SizedBox(width: TossSpacing.space3),
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
                                const Icon(
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
              loading: () => const Center(
                child: TossLoadingView(),
              ),
              error: (error, stack) => Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error_outline, color: TossColors.error, size: 48),
                    const SizedBox(height: TossSpacing.space3),
                    Text(
                      'Failed to load users',
                      style: TossTextStyles.body.copyWith(color: TossColors.error),
                    ),
                  ],
                ),
              ),
            );
              },
              loading: () => const Center(
                child: TossLoadingView(),
              ),
              error: (error, stack) => Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error_outline, color: TossColors.error, size: 48),
                    const SizedBox(height: TossSpacing.space3),
                    Text(
                      'Failed to load role',
                      style: TossTextStyles.body.copyWith(color: TossColors.error),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Bottom action
          Container(
            decoration: const BoxDecoration(
              color: TossColors.background,
              border: Border(top: BorderSide(color: TossColors.gray200)),
            ),
            child: SafeArea(
              top: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(
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
                        ? const SizedBox(
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
        padding: const EdgeInsets.symmetric(
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
    return const SizedBox.shrink();
  }

  Future<void> _assignUserToRole() async {
    if (_selectedUserId == null) return;

    setState(() => _isAssigning = true);

    try {
      // Get roleRepository to fetch companyId
      final roleRepository = ref.read(roleRepositoryProvider);
      final role = await roleRepository.getRoleById(widget.roleId);
      final companyId = role.companyId;

      // ✅ Use AssignUserToRoleUseCase instead of direct database access
      final assignUserUseCase = ref.read(assignUserToRoleUseCaseProvider);
      await assignUserUseCase.execute(
        userId: _selectedUserId!,
        roleId: widget.roleId,
        companyId: companyId,
      );

      if (mounted) {
        Navigator.pop(context);

        // Reactive state management: invalidate providers for cross-screen updates
        ref.invalidate(companyUsersProvider); // Refresh user roles in Add Member modal
        ref.invalidate(allCompanyRolesProvider); // Refresh role member counts

        // Update local role assignments to reflect the change immediately
        _userRoleAssignments[_selectedUserId!] = widget.roleId;

        widget.onMemberAdded();

        // Show success dialog
        await showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => TossDialog.success(
            title: 'Member Added Successfully!',
            message: 'Member has been added to ${widget.roleName}',
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
            title: 'Failed to Add Member',
            message: 'Could not add member to role: $e',
            primaryButtonText: 'OK',
            onPrimaryPressed: () => context.pop(),
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
    'Technical', 'Customer Service', 'Admin', 'Restricted',
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
          // Show warning dialog
          showDialog(
            context: context,
            barrierDismissible: true,
            builder: (context) => TossDialog.error(
              title: 'Maximum Tags Reached',
              message: 'You can only add up to ${TagValidator.MAX_TAGS} tags',
              primaryButtonText: 'OK',
              onPrimaryPressed: () => context.pop(),
            ),
          );
          return;
        }
      }
    });
  }


  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: TossColors.background,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(TossBorderRadius.xl),
        ),
      ),
      child: Column(
        children: [
          // Handle bar
          Container(
            margin: const EdgeInsets.only(top: TossSpacing.space3),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: TossColors.gray300, // Restore grey handle bar
              borderRadius: BorderRadius.circular(TossBorderRadius.xs),
            ),
          ),

          // Header
          Padding(
            padding: const EdgeInsets.all(TossSpacing.space5),
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
                      const SizedBox(height: TossSpacing.space1),
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
                  icon: const Icon(Icons.close, color: TossColors.gray600),
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
              padding: const EdgeInsets.all(TossSpacing.space5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Selected tags display (similar to Create Role modal)
                  if (_selectedTags.isNotEmpty) ...[
                    Container(
                      padding: const EdgeInsets.all(TossSpacing.space4),
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
                          const SizedBox(height: TossSpacing.space3),
                          Wrap(
                            spacing: TossSpacing.space2,
                            runSpacing: TossSpacing.space2,
                            children: _selectedTags.map((tag) => Container(
                              padding: const EdgeInsets.symmetric(
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
                                  const SizedBox(width: TossSpacing.space1),
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
                            ),).toList(),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: TossSpacing.space4),
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
                    const SizedBox(height: TossSpacing.space2),
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
                            padding: const EdgeInsets.symmetric(
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
                                const Icon(
                                  Icons.add,
                                  size: 14,
                                  color: TossColors.textSecondary,
                                ),
                                const SizedBox(width: TossSpacing.space1),
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
                      ),).toList(),
                    ),
                  ],
                  
                  const SizedBox(height: TossSpacing.space10),
                ],
              ),
            ),
          ),

          // Bottom action
          Container(
            decoration: const BoxDecoration(
              color: TossColors.background,
              border: Border(top: BorderSide(color: TossColors.gray200)),
            ),
            child: SafeArea(
              top: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(
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

