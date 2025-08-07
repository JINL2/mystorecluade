import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/themes/toss_colors.dart';
import '../../../../core/themes/toss_text_styles.dart';
import '../../../../core/themes/toss_spacing.dart';
import '../../../providers/role_provider.dart';

class EditRoleModal extends ConsumerStatefulWidget {
  final Role role;
  
  const EditRoleModal({required this.role});
  
  @override
  ConsumerState<EditRoleModal> createState() => _EditRoleModalState();
}

class _EditRoleModalState extends ConsumerState<EditRoleModal> with SingleTickerProviderStateMixin {
  late Map<String, bool> permissionStates;
  late TabController _tabController;
  late TextEditingController _roleNameController;
  late TextEditingController _descriptionController;
  late TextEditingController _tagsController;
  bool isLoading = false;
  bool _isExpanded = false;
  bool _isEditingRoleName = false;
  bool _isEditingDescription = false;
  final ScrollController _permissionsScrollController = ScrollController();
  Map<String, bool> expandedCategories = {};
  Map<String, GlobalKey> categoryKeys = {};
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  double _dragHeight = 0.9;
  
  // Predefined tag options
  final List<String> tagOptions = [
    'Critical',
    'Management',
    'Operations',
    'Finance',
    'Support',
    'Temporary',
    'External',
  ];
  
  Set<String> selectedTags = {};
  
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this, initialIndex: 0); // Start with Info tab
    _roleNameController = TextEditingController(text: widget.role.roleName);
    _descriptionController = TextEditingController(text: widget.role.description ?? '');
    
    // Initialize tags from JSON
    selectedTags = {}; // Clear first
    
    if (widget.role.tags != null && widget.role.tags!.isNotEmpty) {
      // Handle JSONB format from Supabase
      if (widget.role.tags is Map) {
        final tagsMap = Map<String, dynamic>.from(widget.role.tags!);
        
        // Check each key in the map
        tagsMap.forEach((key, value) {
          if (value != null && value.toString().isNotEmpty) {
            final tagValue = value.toString().trim();
            
            // Check if the value is a string array like "[Management, Operations]"
            if (tagValue.startsWith('[') && tagValue.endsWith(']')) {
              // Parse the string array
              String cleanedTags = tagValue.substring(1, tagValue.length - 1);
              final tagsList = cleanedTags
                  .split(',')
                  .map((tag) => tag.trim())
                  .where((tag) => tag.isNotEmpty)
                  .toList();
              
              // Add each tag to selectedTags
              for (final tag in tagsList) {
                final matchingTag = tagOptions.firstWhere(
                  (option) => option.toLowerCase() == tag.toLowerCase(),
                  orElse: () => '',
                );
                if (matchingTag.isNotEmpty) {
                  selectedTags.add(matchingTag);
                }
              }
            }
            // Handle single tag value
            else {
              final matchingTag = tagOptions.firstWhere(
                (option) => option.toLowerCase() == tagValue.toLowerCase(),
                orElse: () => '',
              );
              if (matchingTag.isNotEmpty) {
                selectedTags.add(matchingTag);
              }
            }
          }
        });
      }
    }
    _tagsController = TextEditingController();
    
    // Initialize permission states based on current role permissions
    permissionStates = {};
    for (var permission in widget.role.permissions) {
      if (permission is Map && permission['feature_id'] != null) {
        permissionStates[permission['feature_id']] = true;
      }
    }
    
  }
  
  @override
  void dispose() {
    _tabController.dispose();
    _roleNameController.dispose();
    _descriptionController.dispose();
    _tagsController.dispose();
    _permissionsScrollController.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      height: MediaQuery.of(context).size.height * _dragHeight,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        children: [
          // Draggable Handle Bar
          GestureDetector(
            onVerticalDragUpdate: (details) {
              setState(() {
                _dragHeight -= details.delta.dy / MediaQuery.of(context).size.height;
                _dragHeight = _dragHeight.clamp(0.5, 1.0);
                _isExpanded = _dragHeight > 0.95;
              });
            },
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: TossColors.gray300,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
            ),
          ),
          
          // Modal Header
          Padding(
            padding: EdgeInsets.symmetric(horizontal: TossSpacing.space5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Edit Role',
                  style: TossTextStyles.h2.copyWith(
                    color: TossColors.gray900,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.close, color: TossColors.gray700),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
          ),
          
          // Tab Bar and Content
          Expanded(
            child: Column(
              children: [
                // Tab Bar
                Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    border: Border(
                      bottom: BorderSide(color: TossColors.gray200, width: 1),
                    ),
                  ),
                  child: TabBar(
                    controller: _tabController,
                    labelColor: TossColors.primary,
                    unselectedLabelColor: TossColors.gray500,
                    labelStyle: TossTextStyles.labelLarge.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                    unselectedLabelStyle: TossTextStyles.labelLarge,
                    indicatorColor: TossColors.primary,
                    indicatorWeight: 2,
                    tabs: const [
                      Tab(text: 'Info'),
                      Tab(text: 'Permissions'),
                      Tab(text: 'Members'),
                    ],
                  ),
                ),
                
                // Tab Content
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      // Info Tab
                      _buildInfoTab(),
                      // Permissions Tab
                      _buildPermissionsTab(),
                      // Members Tab
                      _buildMembersTab(),
                    ],
                  ),
                ),
              ],
            ),
          ),
          
          // Action Buttons
          Container(
            padding: EdgeInsets.all(TossSpacing.space5),
            decoration: const BoxDecoration(
              color: Colors.white,
              border: Border(
                top: BorderSide(color: TossColors.gray100, width: 1),
              ),
            ),
            child: SafeArea(
              child: Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: TossSpacing.space4),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: const BorderSide(color: TossColors.gray300, width: 1),
                        ),
                      ),
                      child: Text(
                        'Cancel',
                        style: TossTextStyles.labelLarge.copyWith(
                          color: TossColors.gray700,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: TossSpacing.space3),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: isLoading ? null : _savePermissions,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: TossColors.primary,
                        foregroundColor: Colors.white,
                        disabledBackgroundColor: TossColors.gray200,
                        padding: EdgeInsets.symmetric(vertical: TossSpacing.space4),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                      child: isLoading
                          ? const SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                          : const Text('Save Changes'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildInfoTab() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(TossSpacing.space5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Role Name with Edit Button
          _buildEditableField(
            label: 'Role Name',
            value: _roleNameController.text,
            isEditing: _isEditingRoleName,
            controller: _roleNameController,
            placeholder: 'Enter role name',
            onEditToggle: () {
              setState(() {
                _isEditingRoleName = !_isEditingRoleName;
              });
            },
          ),
          
          SizedBox(height: TossSpacing.space5),
          
          // Description with Edit Button
          _buildEditableField(
            label: 'Description',
            value: _descriptionController.text,
            isEditing: _isEditingDescription,
            controller: _descriptionController,
            placeholder: 'Add a description for this role',
            maxLines: 3,
            onEditToggle: () {
              setState(() {
                _isEditingDescription = !_isEditingDescription;
              });
            },
          ),
          
          SizedBox(height: TossSpacing.space5),
          
          // Tags Section
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Tags',
                style: TossTextStyles.labelLarge.copyWith(
                  color: TossColors.gray700,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: TossSpacing.space3),
              _buildTagSelector(),
            ],
          ),
        ],
      ),
    );
  }
  
  Widget _buildPermissionsTab() {
    final featuresAsync = ref.watch(featuresProvider);
    final categoriesAsync = ref.watch(categoriesProvider);
    final features = featuresAsync.value ?? [];
    final allSelected = features.isNotEmpty && 
        features.every((f) => permissionStates[f['feature_id']] ?? false);
    
    return Column(
      children: [
        // Select All / Deselect All Toggle with Sticky Header
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: TossSpacing.space5,
            vertical: TossSpacing.space3,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            border: const Border(
              bottom: BorderSide(color: TossColors.gray200, width: 1),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                offset: const Offset(0, 2),
                blurRadius: 4,
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'All Permissions',
                style: TossTextStyles.labelLarge.copyWith(
                  color: TossColors.gray900,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () => _selectAllPermissions(!allSelected),
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: TossSpacing.space3,
                      vertical: TossSpacing.space2,
                    ),
                    decoration: BoxDecoration(
                      color: allSelected ? TossColors.gray100 : TossColors.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      allSelected ? 'Deselect All' : 'Select All',
                      style: TossTextStyles.labelSmall.copyWith(
                        color: allSelected ? TossColors.gray700 : TossColors.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        
        // Features List
        Expanded(
          child: featuresAsync.when(
            data: (features) => categoriesAsync.when(
              data: (categories) => _buildCategorizedFeaturesList(features, categories),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (_, __) => const Center(child: Text('Failed to load categories')),
            ),
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, stack) => Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Failed to load features', style: TossTextStyles.body),
                  TextButton(
                    onPressed: () => ref.refresh(featuresProvider),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
  
  Widget _buildMembersTab() {
    final usersInRoleAsync = ref.watch(usersInRoleProvider(widget.role.roleId));
    
    return usersInRoleAsync.when(
      data: (users) => users.isEmpty
          ? Center(
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
                    'No members in this role',
                    style: TossTextStyles.h3.copyWith(
                      color: TossColors.gray600,
                    ),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: EdgeInsets.symmetric(vertical: TossSpacing.space3),
              itemCount: users.length,
              itemBuilder: (context, index) => _buildMemberItem(users[index]),
            ),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (_, __) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Failed to load members', style: TossTextStyles.body),
            TextButton(
              onPressed: () => ref.refresh(usersInRoleProvider(widget.role.roleId)),
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildCategorizedFeaturesList(List<Map<String, dynamic>> features, List<Map<String, dynamic>> categories) {
    // Group features by category
    final Map<String, List<Map<String, dynamic>>> featuresByCategory = {};
    for (var feature in features) {
      if (!featuresByCategory.containsKey(feature['category_id'])) {
        featuresByCategory[feature['category_id']] = [];
      }
      featuresByCategory[feature['category_id']]!.add(feature);
    }
    
    // Initialize category keys if not already done
    for (var category in categories) {
      if (!categoryKeys.containsKey(category['category_id'])) {
        categoryKeys[category['category_id']] = GlobalKey();
      }
    }
    
    return ListView.builder(
      controller: _permissionsScrollController,
      padding: EdgeInsets.only(bottom: TossSpacing.space5),
      itemCount: categories.length,
      itemBuilder: (context, index) {
        final category = categories[index];
        final categoryFeatures = featuresByCategory[category['category_id']] ?? [];
        
        if (categoryFeatures.isEmpty) return const SizedBox.shrink();
        
        return _buildCategorySection(category, categoryFeatures);
      },
    );
  }
  
  Widget _buildCategorySection(Map<String, dynamic> category, List<Map<String, dynamic>> features) {
    // Check if all features in this category are selected
    final allSelected = features.every((f) => permissionStates[f['feature_id']] ?? false);
    final someSelected = features.any((f) => permissionStates[f['feature_id']] ?? false);
    final isExpanded = expandedCategories[category['category_id']] ?? false;
    
    return Container(
      key: categoryKeys[category['category_id']],
      margin: EdgeInsets.only(bottom: TossSpacing.space2),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(color: TossColors.gray100, width: 1),
        ),
      ),
      child: Column(
        children: [
          // Category Header with Select All
          AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            padding: EdgeInsets.symmetric(
              horizontal: TossSpacing.space5,
              vertical: TossSpacing.space3,
            ),
            decoration: BoxDecoration(
              color: isExpanded ? TossColors.primary.withOpacity(0.05) : TossColors.gray50,
              border: Border(
                left: BorderSide(
                  color: isExpanded ? TossColors.primary : Colors.transparent,
                  width: 3,
                ),
              ),
            ),
            child: Row(
              children: [
                // Circular Checkbox
                InkWell(
                  onTap: () => _toggleCategoryPermissions(features, !allSelected),
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: allSelected ? TossColors.primary : TossColors.gray300,
                        width: 2,
                      ),
                      color: allSelected ? TossColors.primary : Colors.transparent,
                    ),
                    child: allSelected
                        ? const Icon(Icons.check, size: 14, color: Colors.white)
                        : someSelected
                            ? Icon(Icons.remove, size: 14, color: TossColors.gray400)
                            : null,
                  ),
                ),
                SizedBox(width: TossSpacing.space3),
                
                // Category Name
                Expanded(
                  child: InkWell(
                    onTap: () {
                      // Toggle expansion state immediately for responsiveness
                      setState(() {
                        expandedCategories[category['category_id']] = !isExpanded;
                      });
                      
                      // Scroll animation runs in parallel (non-blocking)
                      if (!isExpanded) {
                        // Use WidgetsBinding to ensure render is complete
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          final context = categoryKeys[category['category_id']]?.currentContext;
                          if (context != null && _permissionsScrollController.hasClients) {
                            final RenderBox renderBox = context.findRenderObject() as RenderBox;
                            
                            // Get the position relative to the scroll view
                            final ScrollableState? scrollableState = Scrollable.of(context);
                            if (scrollableState != null) {
                              final RenderBox scrollRenderBox = scrollableState.context.findRenderObject() as RenderBox;
                              final position = renderBox.localToGlobal(Offset.zero, ancestor: scrollRenderBox);
                              
                              // Calculate the offset to bring category to top with small padding
                              final currentScrollOffset = _permissionsScrollController.offset;
                              final targetOffset = currentScrollOffset + position.dy - 16; // 16px padding from top
                              
                              // Animate scroll with smooth duration
                              _permissionsScrollController.animateTo(
                                targetOffset.clamp(0.0, _permissionsScrollController.position.maxScrollExtent),
                                duration: const Duration(milliseconds: 250),
                                curve: Curves.easeOutCubic,
                              );
                            }
                          }
                        });
                      }
                    },
                    child: Row(
                      children: [
                        Text(
                          category['name'] ?? '',
                          style: TossTextStyles.labelLarge.copyWith(
                            color: TossColors.gray900,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(width: TossSpacing.space2),
                        // Dropdown icon with animation
                        AnimatedRotation(
                          turns: isExpanded ? 0.5 : 0.0,
                          duration: const Duration(milliseconds: 150),
                          child: Icon(
                            Icons.keyboard_arrow_down,
                            size: 20,
                            color: TossColors.gray500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                
                // Count
                Text(
                  '${features.where((f) => permissionStates[f['feature_id']] ?? false).length}/${features.length}',
                  style: TossTextStyles.caption.copyWith(
                    color: TossColors.gray500,
                  ),
                ),
              ],
            ),
          ),
          
          // Features in Category - Only show if expanded
          AnimatedSize(
            duration: const Duration(milliseconds: 200),
            curve: Curves.fastOutSlowIn,
            child: isExpanded
                ? Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border(
                        left: BorderSide(
                          color: TossColors.primary.withOpacity(0.2),
                          width: 3,
                        ),
                      ),
                    ),
                    child: Column(
                      children: features.map((feature) => _buildFeatureItem(feature)).toList(),
                    ),
                  )
                : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }
  
  Widget _buildFeatureItem(Map<String, dynamic> feature) {
    final isEnabled = permissionStates[feature['feature_id']] ?? false;
    
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          setState(() {
            permissionStates[feature['feature_id']] = !isEnabled;
          });
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 100),
          padding: EdgeInsets.symmetric(
            horizontal: TossSpacing.space5,
            vertical: TossSpacing.space3,
          ),
          decoration: BoxDecoration(
            color: isEnabled ? TossColors.primary.withOpacity(0.02) : Colors.transparent,
            border: const Border(
              bottom: BorderSide(
                color: TossColors.gray100,
                width: 0.5,
              ),
            ),
          ),
          child: Row(
            children: [
              SizedBox(width: TossSpacing.space10), // Increased indent for better hierarchy
              // Circular checkbox on the left
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isEnabled ? TossColors.primary : TossColors.gray300,
                    width: 2,
                  ),
                  color: isEnabled ? TossColors.primary : Colors.transparent,
                ),
                child: isEnabled
                    ? const Icon(Icons.check, size: 14, color: Colors.white)
                    : null,
              ),
              SizedBox(width: TossSpacing.space3),
              Expanded(
                child: Text(
                  feature['feature_name'] ?? '',
                  style: TossTextStyles.body.copyWith(
                    color: isEnabled ? TossColors.gray900 : TossColors.gray600,
                    fontWeight: isEnabled ? FontWeight.w600 : FontWeight.w400,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildMemberItem(Map<String, dynamic> user) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: TossSpacing.space5,
        vertical: TossSpacing.space3,
      ),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: TossColors.gray50, width: 1),
        ),
      ),
      child: Row(
        children: [
          // Avatar
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: TossColors.primary.withOpacity(0.1),
              shape: BoxShape.circle,
              border: Border.all(
                color: TossColors.primary.withOpacity(0.2),
                width: 1,
              ),
            ),
            child: Center(
              child: Text(
                user['initials'] ?? '?',
                style: TossTextStyles.labelLarge.copyWith(
                  color: TossColors.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          SizedBox(width: TossSpacing.space3),
          
          // User Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user['full_name'] ?? '',
                  style: TossTextStyles.body.copyWith(
                    color: TossColors.gray900,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        user['email'] ?? '',
                        style: TossTextStyles.caption.copyWith(
                          color: TossColors.gray500,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Text(
                      ' • ',
                      style: TossTextStyles.caption.copyWith(
                        color: TossColors.gray400,
                      ),
                    ),
                    Text(
                      _formatJoinDate(user['created_at'] != null ? DateTime.parse(user['created_at']) : null),
                      style: TossTextStyles.caption.copyWith(
                        color: TossColors.gray500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  String _formatJoinDate(DateTime? date) {
    if (date == null) return 'Unknown';
    
    final now = DateTime.now();
    final difference = now.difference(date);
    
    if (difference.inDays == 0) {
      return 'Today';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else if (difference.inDays < 30) {
      final weeks = (difference.inDays / 7).floor();
      return '$weeks ${weeks == 1 ? 'week' : 'weeks'} ago';
    } else if (difference.inDays < 365) {
      final months = (difference.inDays / 30).floor();
      return '$months ${months == 1 ? 'month' : 'months'} ago';
    } else {
      final years = (difference.inDays / 365).floor();
      return '$years ${years == 1 ? 'year' : 'years'} ago';
    }
  }
  
  void _selectAllPermissions(bool select) {
    final features = ref.read(featuresProvider).value ?? [];
    setState(() {
      for (var feature in features) {
        permissionStates[feature['feature_id']] = select;
      }
    });
  }
  
  void _toggleCategoryPermissions(List<Map<String, dynamic>> features, bool select) {
    setState(() {
      for (var feature in features) {
        permissionStates[feature['feature_id']] = select;
      }
    });
  }
  
  Future<void> _savePermissions() async {
    setState(() {
      isLoading = true;
    });
    
    try {
      // Get enabled feature IDs
      final enabledFeatureIds = permissionStates.entries
          .where((entry) => entry.value)
          .map((entry) => entry.key)
          .toList();
      
      // Convert selected tags to Map - store as string array in tag1
      Map<String, dynamic>? tagsMap;
      if (selectedTags.isNotEmpty) {
        // Format tags as "[Tag1, Tag2]" string to match database format
        final tagsList = selectedTags.toList();
        final formattedTags = '[${tagsList.join(', ')}]';
        tagsMap = {
          'tag1': formattedTags
        };
      }
      
      final service = ref.read(roleServiceProvider);
      final success = await service.updateRole(
        roleId: widget.role.roleId,
        roleName: _roleNameController.text.trim(),
        featureIds: enabledFeatureIds,
        description: _descriptionController.text.trim().isEmpty ? null : _descriptionController.text.trim(),
        tags: tagsMap,
      );
      
      if (success) {
        // Refresh the roles list
        ref.invalidate(companyRolesProvider);
        
        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Role updated successfully'),
            backgroundColor: TossColors.success,
          ),
        );
        
        Navigator.of(context).pop();
      } else {
        throw Exception('Failed to update role');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Failed to update role'),
          backgroundColor: TossColors.error,
        ),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }
  
  Widget _buildEditableField({
    required String label,
    required String value,
    required bool isEditing,
    required TextEditingController controller,
    required String placeholder,
    required VoidCallback onEditToggle,
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              label,
              style: TossTextStyles.labelLarge.copyWith(
                color: TossColors.gray700,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(width: TossSpacing.space2),
            InkWell(
              onTap: onEditToggle,
              borderRadius: BorderRadius.circular(4),
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: TossSpacing.space2,
                  vertical: TossSpacing.space1,
                ),
                child: Icon(
                  isEditing ? Icons.check : Icons.edit,
                  size: 16,
                  color: isEditing ? TossColors.primary : TossColors.gray500,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: TossSpacing.space2),
        if (isEditing)
          Container(
            decoration: BoxDecoration(
              color: TossColors.gray50,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: TossColors.primary, width: 2),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10), // Slightly smaller to fit inside the border
              child: TextField(
                controller: controller,
                maxLines: maxLines,
                autofocus: true,
                style: TossTextStyles.body.copyWith(
                  color: TossColors.gray900,
                ),
                decoration: InputDecoration(
                  hintText: placeholder,
                  hintStyle: TossTextStyles.body.copyWith(
                    color: TossColors.gray400,
                  ),
                  filled: true,
                  fillColor: Colors.transparent,
                  border: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  errorBorder: InputBorder.none,
                  disabledBorder: InputBorder.none,
                  contentPadding: EdgeInsets.all(TossSpacing.space4),
                ),
              ),
            ),
          )
        else
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(TossSpacing.space4),
            decoration: BoxDecoration(
              color: TossColors.gray50,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: TossColors.gray200),
            ),
            child: Text(
              value.isEmpty ? placeholder : value,
              style: TossTextStyles.body.copyWith(
                color: value.isEmpty ? TossColors.gray400 : TossColors.gray900,
              ),
              maxLines: maxLines,
              overflow: TextOverflow.ellipsis,
            ),
          ),
      ],
    );
  }

  Widget _buildTagSelector() {
    return Wrap(
      spacing: TossSpacing.space2,
      runSpacing: TossSpacing.space2,
      children: tagOptions.map((tag) {
        final isSelected = selectedTags.contains(tag);
        
        return InkWell(
          onTap: () {
            setState(() {
              if (isSelected) {
                selectedTags.remove(tag);
              } else {
                selectedTags.add(tag);
              }
            });
          },
          borderRadius: BorderRadius.circular(20),
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: TossSpacing.space3,
              vertical: 6, // Reduced padding
            ),
            decoration: BoxDecoration(
              color: isSelected 
                  ? TossColors.primary.withOpacity(0.08) 
                  : TossColors.gray50,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isSelected 
                    ? TossColors.primary 
                    : TossColors.gray200,
                width: 1, // Thinner border
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 14,
                  height: 14,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isSelected ? TossColors.primary : TossColors.gray400,
                      width: 1.5,
                    ),
                    color: isSelected ? TossColors.primary : Colors.transparent,
                  ),
                  child: isSelected
                      ? Center(
                          child: Container(
                            width: 5,
                            height: 5,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white,
                            ),
                          ),
                        )
                      : null,
                ),
                const SizedBox(width: 6),
                Text(
                  tag,
                  style: TossTextStyles.labelSmall.copyWith( // Changed to labelSmall
                    color: isSelected ? TossColors.primary : TossColors.gray700,
                    fontWeight: isSelected ? FontWeight.w500 : FontWeight.w400,
                    fontSize: 13, // Explicit font size
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}