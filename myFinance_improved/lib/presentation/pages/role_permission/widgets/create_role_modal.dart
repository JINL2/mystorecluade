import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/themes/toss_colors.dart';
import '../../../../core/themes/toss_text_styles.dart';
import '../../../../core/themes/toss_spacing.dart';
import '../../../providers/role_provider.dart';

class CreateRoleModal extends ConsumerStatefulWidget {
  final String companyId;
  const CreateRoleModal({required this.companyId, Key? key}) : super(key: key);

  @override
  ConsumerState<CreateRoleModal> createState() => _CreateRoleModalState();
}

class _CreateRoleModalState extends ConsumerState<CreateRoleModal> 
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _roleNameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final Map<String, bool> _selectedFeatureIds = {};
  final Map<String, bool> _expandedCategories = {};
  final Map<String, GlobalKey> _categoryKeys = {};
  final ScrollController _permissionsScrollController = ScrollController();
  List<String> _selectedTags = [];
  bool _isCreating = false;
  int _currentStep = 0;

  final List<String> _availableTags = [
    'Critical',
    'Management',
    'Operations',
    'Finance',
    'Support',
    'Temporary',
    'External',
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this, initialIndex: 0);
    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        setState(() {
          _currentStep = _tabController.index;
        });
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _roleNameController.dispose();
    _descriptionController.dispose();
    _permissionsScrollController.dispose();
    super.dispose();
  }

  Future<void> _createRole() async {
    setState(() => _isCreating = true);

    try {
      // Convert selected tags to the database format - store as string array in tag1
      final Map<String, dynamic>? tags = _selectedTags.isEmpty ? null : {
        'tag1': '[${_selectedTags.join(', ')}]'
      };

      final service = ref.read(roleServiceProvider);
      final success = await service.createRole(
        companyId: widget.companyId,
        roleName: _roleNameController.text.trim(),
        featureIds: _selectedFeatureIds.keys.where((id) => _selectedFeatureIds[id]!).toList(),
        description: _descriptionController.text.trim().isEmpty 
            ? null 
            : _descriptionController.text.trim(),
        tags: tags,
      );

      if (success && mounted) {
        ref.invalidate(companyRolesProvider);
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Role created successfully! 🎉'),
            backgroundColor: TossColors.success,
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

  bool get _canProceed {
    switch (_currentStep) {
      case 0:
        return _roleNameController.text.trim().isNotEmpty;
      case 1:
        return true; // Tags are optional
      case 2:
        return _selectedFeatureIds.values.any((selected) => selected);
      default:
        return false;
    }
  }

  String get _nextButtonText {
    switch (_currentStep) {
      case 0:
      case 1:
        return 'Continue';
      case 2:
        return 'Create Role';
      default:
        return 'Next';
    }
  }

  void _handleNext() {
    if (_currentStep < 2) {
      _tabController.animateTo(_currentStep + 1);
    } else {
      _createRole();
    }
  }

  void _handleBack() {
    if (_currentStep > 0) {
      _tabController.animateTo(_currentStep - 1);
    }
  }

  Widget _buildStepIndicator() {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: TossSpacing.space5,
        vertical: TossSpacing.space3,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(3, (index) {
          final isActive = index == _currentStep;
          final isCompleted = index < _currentStep;
          
          return Container(
            margin: EdgeInsets.symmetric(horizontal: TossSpacing.space1),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: isActive ? 24 : 8,
              height: 8,
              decoration: BoxDecoration(
                color: isActive 
                    ? TossColors.primary 
                    : isCompleted 
                        ? TossColors.primary.withOpacity(0.3)
                        : TossColors.gray200,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildRoleNameStep() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(TossSpacing.space5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Step Title
          Container(
            margin: EdgeInsets.only(bottom: TossSpacing.space8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'What\'s the role name?',
                  style: TossTextStyles.h2.copyWith(
                    color: TossColors.gray900,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: TossSpacing.space2),
                Text(
                  'Choose a clear, descriptive name for this role',
                  style: TossTextStyles.body.copyWith(
                    color: TossColors.gray500,
                  ),
                ),
              ],
            ),
          ),

          // Role Name Input
          Container(
            decoration: BoxDecoration(
              color: TossColors.gray50,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: _roleNameController.text.isNotEmpty 
                    ? TossColors.primary.withOpacity(0.3)
                    : Colors.transparent,
                width: 1.5,
              ),
            ),
            child: TextField(
              controller: _roleNameController,
              style: TossTextStyles.bodyLarge.copyWith(
                fontWeight: FontWeight.w500,
              ),
              autofocus: true,
              onChanged: (_) => setState(() {}),
              decoration: InputDecoration(
                hintText: 'e.g., Store Manager, Sales Associate',
                hintStyle: TossTextStyles.bodyLarge.copyWith(
                  color: TossColors.gray400,
                ),
                filled: true,
                fillColor: Colors.transparent,
                contentPadding: EdgeInsets.all(TossSpacing.space4),
                border: InputBorder.none,
              ),
            ),
          ),
          SizedBox(height: TossSpacing.space4),

          // Description (Optional)
          Text(
            'Description (optional)',
            style: TossTextStyles.label.copyWith(
              color: TossColors.gray600,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: TossSpacing.space2),
          Container(
            decoration: BoxDecoration(
              color: TossColors.gray50,
              borderRadius: BorderRadius.circular(16),
            ),
            child: TextField(
              controller: _descriptionController,
              style: TossTextStyles.body,
              maxLines: 3,
              decoration: InputDecoration(
                hintText: 'Briefly describe the responsibilities...',
                hintStyle: TossTextStyles.body.copyWith(
                  color: TossColors.gray400,
                ),
                filled: true,
                fillColor: Colors.transparent,
                contentPadding: EdgeInsets.all(TossSpacing.space4),
                border: InputBorder.none,
              ),
            ),
          ),

          // Examples
          SizedBox(height: TossSpacing.space6),
          Container(
            padding: EdgeInsets.all(TossSpacing.space4),
            decoration: BoxDecoration(
              color: TossColors.primary.withOpacity(0.05),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: TossColors.primary.withOpacity(0.1),
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.lightbulb_outline,
                  size: 20,
                  color: TossColors.primary,
                ),
                SizedBox(width: TossSpacing.space3),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Tip',
                        style: TossTextStyles.labelLarge.copyWith(
                          color: TossColors.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: TossSpacing.space1),
                      Text(
                        'Use specific names like "Regional Manager" instead of generic ones like "Manager"',
                        style: TossTextStyles.bodySmall.copyWith(
                          color: TossColors.gray700,
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
    );
  }

  Widget _buildTagsStep() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(TossSpacing.space5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Step Title
          Container(
            margin: EdgeInsets.only(bottom: TossSpacing.space8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Add tags (optional)',
                  style: TossTextStyles.h2.copyWith(
                    color: TossColors.gray900,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: TossSpacing.space2),
                Text(
                  'Tags help organize and identify roles quickly',
                  style: TossTextStyles.body.copyWith(
                    color: TossColors.gray500,
                  ),
                ),
              ],
            ),
          ),

          // Tag Grid
          Wrap(
            spacing: TossSpacing.space3,
            runSpacing: TossSpacing.space3,
            children: _availableTags.map((tag) {
              final isSelected = _selectedTags.contains(tag);
              return GestureDetector(
                onTap: () {
                  setState(() {
                    if (isSelected) {
                      _selectedTags.remove(tag);
                    } else {
                      _selectedTags.add(tag);
                    }
                  });
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: EdgeInsets.symmetric(
                    horizontal: TossSpacing.space3,
                    vertical: TossSpacing.space2,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected 
                        ? TossColors.primary 
                        : TossColors.gray50,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(
                      color: isSelected 
                          ? TossColors.primary 
                          : TossColors.gray200,
                      width: 1.5,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (isSelected)
                        const Icon(
                          Icons.check_circle,
                          size: 16,
                          color: Colors.white,
                        )
                      else
                        Icon(
                          Icons.add_circle_outline,
                          size: 16,
                          color: TossColors.gray400,
                        ),
                      const SizedBox(width: 6),
                      Text(
                        tag,
                        style: TossTextStyles.labelSmall.copyWith(
                          color: isSelected 
                              ? Colors.white 
                              : TossColors.gray700,
                          fontWeight: FontWeight.w500,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),

          // Selected count
          if (_selectedTags.isNotEmpty) ...[
            SizedBox(height: TossSpacing.space6),
            Container(
              padding: EdgeInsets.all(TossSpacing.space4),
              decoration: BoxDecoration(
                color: TossColors.gray50,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.tag,
                    size: 20,
                    color: TossColors.gray600,
                  ),
                  SizedBox(width: TossSpacing.space2),
                  Text(
                    '${_selectedTags.length} tag${_selectedTags.length > 1 ? 's' : ''} selected',
                    style: TossTextStyles.body.copyWith(
                      color: TossColors.gray700,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildPermissionsStep() {
    final categoriesAsync = ref.watch(categoriesProvider);
    final featuresAsync = ref.watch(featuresProvider);

    return Column(
      children: [
        // Step Header
        Container(
          padding: EdgeInsets.all(TossSpacing.space5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Set permissions',
                style: TossTextStyles.h2.copyWith(
                  color: TossColors.gray900,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: TossSpacing.space2),
              Text(
                'Choose what this role can access',
                style: TossTextStyles.body.copyWith(
                  color: TossColors.gray500,
                ),
              ),
              SizedBox(height: TossSpacing.space4),
              
              // Quick Actions
              featuresAsync.when(
                data: (features) {
                  final selectedCount = _selectedFeatureIds.values.where((v) => v).length;
                  final totalCount = features.length;
                  
                  return Container(
                    padding: EdgeInsets.all(TossSpacing.space3),
                    decoration: BoxDecoration(
                      color: TossColors.gray50,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.security,
                              size: 20,
                              color: TossColors.gray600,
                            ),
                            SizedBox(width: TossSpacing.space2),
                            Text(
                              '$selectedCount of $totalCount permissions',
                              style: TossTextStyles.body.copyWith(
                                color: TossColors.gray700,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        TextButton(
                          onPressed: () => _toggleAllPermissions(features),
                          child: Text(
                            selectedCount == totalCount ? 'Clear all' : 'Select all',
                            style: TossTextStyles.label.copyWith(
                              color: TossColors.primary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
                loading: () => const SizedBox.shrink(),
                error: (_, __) => const SizedBox.shrink(),
              ),
            ],
          ),
        ),
        const Divider(height: 1, color: TossColors.gray100),

        // Permission Categories
        Expanded(
          child: Container(
            decoration: const BoxDecoration(
              color: TossColors.gray50,
            ),
            child: SingleChildScrollView(
              controller: _permissionsScrollController,
              padding: EdgeInsets.only(
                left: TossSpacing.space5,
                right: TossSpacing.space5,
                top: TossSpacing.space3,
                bottom: TossSpacing.space20,
              ),
              physics: const BouncingScrollPhysics(),
              child: categoriesAsync.when(
              data: (categories) => featuresAsync.when(
                data: (features) => Column(
                  children: [
                    ...categories.map((category) {
                      final categoryFeatures = features.where(
                        (f) => f['category_id'] == category['category_id'],
                      ).toList();
                      
                      if (categoryFeatures.isEmpty) return const SizedBox.shrink();
                      
                      // Initialize category keys if not already done
                      if (!_categoryKeys.containsKey(category['category_id'])) {
                        _categoryKeys[category['category_id']] = GlobalKey();
                      }
                      
                      return _buildPermissionCategory(category, categoryFeatures);
                    }).toList(),
                  ],
                ),
                loading: () => Center(
                  child: Padding(
                    padding: EdgeInsets.all(TossSpacing.space10),
                    child: CircularProgressIndicator(
                      color: TossColors.primary,
                    ),
                  ),
                ),
                error: (error, _) => Center(
                  child: Text(
                    'Failed to load permissions',
                    style: TossTextStyles.body.copyWith(
                      color: TossColors.error,
                    ),
                  ),
                ),
              ),
              loading: () => const Center(
                child: CircularProgressIndicator(
                  color: TossColors.primary,
                ),
              ),
              error: (error, _) => Center(
                child: Text(
                  'Failed to load categories',
                  style: TossTextStyles.body.copyWith(
                    color: TossColors.error,
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

  Widget _buildPermissionCategory(Map<String, dynamic> category, List<Map<String, dynamic>> features) {
    final isExpanded = _expandedCategories[category['category_id']] ?? false;
    final selectedCount = features.where((f) => 
      _selectedFeatureIds[f['feature_id']] ?? false
    ).length;
    final allSelected = selectedCount == features.length && selectedCount > 0;
    
    return Container(
      key: _categoryKeys[category['category_id']],
      margin: EdgeInsets.only(bottom: TossSpacing.space4),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isExpanded 
                ? TossColors.primary.withOpacity(0.3) 
                : selectedCount > 0
                    ? TossColors.primary.withOpacity(0.15) 
                    : TossColors.gray100,
            width: isExpanded ? 2 : 1.5,
          ),
          boxShadow: isExpanded ? [
            BoxShadow(
              color: TossColors.primary.withOpacity(0.08),
              offset: const Offset(0, 2),
              blurRadius: 8,
            ),
          ] : selectedCount > 0 ? [
            BoxShadow(
              color: TossColors.primary.withOpacity(0.04),
              offset: const Offset(0, 1),
              blurRadius: 4,
            ),
          ] : [],
        ),
        child: Column(
          children: [
            InkWell(
              onTap: () {
                // Toggle expansion state immediately for responsiveness
                setState(() {
                  _expandedCategories[category['category_id']] = !isExpanded;
                });
                
                // Scroll animation runs in parallel (non-blocking)
                if (!isExpanded) {
                  // Use WidgetsBinding to ensure render is complete
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    final context = _categoryKeys[category['category_id']]?.currentContext;
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
              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                padding: EdgeInsets.all(TossSpacing.space4),
                decoration: BoxDecoration(
                  color: isExpanded
                      ? TossColors.primary.withOpacity(0.08)
                      : selectedCount > 0
                          ? TossColors.primary.withOpacity(0.04)
                          : TossColors.gray50,
                  borderRadius: BorderRadius.vertical(
                    top: const Radius.circular(14),
                    bottom: Radius.circular(isExpanded ? 0 : 14),
                  ),
                ),
                child: Row(
                children: [
                  // Category Circular Checkbox
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () => _toggleCategory(category['category_id'], features),
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        width: 24,
                        height: 24,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: allSelected 
                                ? TossColors.primary 
                                : TossColors.gray300,
                            width: 2,
                          ),
                          color: allSelected 
                              ? TossColors.primary 
                              : Colors.transparent,
                        ),
                        child: allSelected
                            ? const Icon(Icons.check, size: 14, color: Colors.white)
                            : selectedCount > 0
                                ? Icon(Icons.remove, size: 14, color: TossColors.gray400)
                                : null,
                      ),
                    ),
                  ),
                  SizedBox(width: TossSpacing.space3),
                  
                  // Category Name
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          category['name'] ?? '',
                          style: TossTextStyles.labelLarge.copyWith(
                            color: TossColors.gray900,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        if (selectedCount > 0 && !isExpanded)
                          Text(
                            '$selectedCount of ${features.length} selected',
                            style: TossTextStyles.caption.copyWith(
                              color: TossColors.primary,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                      ],
                    ),
                  ),
                  
                  // Expand Icon with animation
                  AnimatedRotation(
                    turns: isExpanded ? 0.5 : 0.0,
                    duration: const Duration(milliseconds: 150),
                    child: Icon(
                      Icons.keyboard_arrow_down,
                      size: 24,
                      color: isExpanded ? TossColors.primary : TossColors.gray400,
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          // Features with smooth animation
          AnimatedSize(
            duration: const Duration(milliseconds: 200),
            curve: Curves.fastOutSlowIn,
            child: isExpanded
                ? Column(
                    children: [
                      Container(
                        height: 1,
                        color: TossColors.gray100,
                      ),
                      ...features.map((feature) {
                        final isSelected = _selectedFeatureIds[feature['feature_id']] ?? false;
                        return Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                _selectedFeatureIds[feature['feature_id']] = !isSelected;
                              });
                            },
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 100),
                              padding: EdgeInsets.symmetric(
                                horizontal: TossSpacing.space4,
                                vertical: TossSpacing.space3,
                              ),
                              decoration: BoxDecoration(
                                color: isSelected 
                                    ? TossColors.primary.withOpacity(0.02) 
                                    : Colors.transparent,
                              ),
                              child: Row(
                                children: [
                                  SizedBox(width: TossSpacing.space10),
                                  // Circular checkbox on the left
                                  Container(
                                    width: 24,
                                    height: 24,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: isSelected 
                                            ? TossColors.primary 
                                            : TossColors.gray300,
                                        width: 2,
                                      ),
                                      color: isSelected 
                                          ? TossColors.primary 
                                          : Colors.transparent,
                                    ),
                                    child: isSelected
                                        ? const Icon(Icons.check, size: 14, color: Colors.white)
                                        : null,
                                  ),
                                  SizedBox(width: TossSpacing.space3),
                                  Expanded(
                                    child: Text(
                                      feature['feature_name'] ?? '',
                                      style: TossTextStyles.body.copyWith(
                                        color: isSelected 
                                            ? TossColors.gray900 
                                            : TossColors.gray600,
                                        fontWeight: isSelected 
                                            ? FontWeight.w600 
                                            : FontWeight.w400,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ],
                  )
                : const SizedBox.shrink(),
          ),
        ],
      ),
      ),
    );
  }

  void _toggleAllPermissions(List<Map<String, dynamic>> features) {
    setState(() {
      final allSelected = features.every((f) => 
        _selectedFeatureIds[f['feature_id']] ?? false
      );
      
      if (allSelected) {
        _selectedFeatureIds.clear();
      } else {
        for (final feature in features) {
          _selectedFeatureIds[feature['feature_id']] = true;
        }
      }
    });
  }

  void _toggleCategory(String categoryId, List<Map<String, dynamic>> categoryFeatures) {
    setState(() {
      final allSelected = categoryFeatures.every((f) => 
        _selectedFeatureIds[f['feature_id']] ?? false
      );
      
      for (final feature in categoryFeatures) {
        _selectedFeatureIds[feature['feature_id']] = !allSelected;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.9,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: Column(
        children: [
          // Handle Bar
          Container(
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
          
          // Modal Header
          Container(
            padding: EdgeInsets.symmetric(horizontal: TossSpacing.space5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Back button (only show after first step)
                if (_currentStep > 0)
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios_new, size: 20),
                    onPressed: _handleBack,
                    color: TossColors.gray700,
                  )
                else
                  const SizedBox(width: 48), // Placeholder for alignment
                
                // Title
                Text(
                  'Create New Role',
                  style: TossTextStyles.labelLarge.copyWith(
                    color: TossColors.gray700,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                
                // Close button
                IconButton(
                  icon: Icon(Icons.close, color: TossColors.gray700),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
          ),
          
          // Step Indicator
          _buildStepIndicator(),
          
          // Tab Content (without visible tabs)
          Expanded(
            child: TabBarView(
              controller: _tabController,
              physics: const NeverScrollableScrollPhysics(), // Disable swipe
              children: [
                _buildRoleNameStep(),
                _buildTagsStep(),
                _buildPermissionsStep(),
              ],
            ),
          ),

          // Bottom Action Button
          Container(
            padding: EdgeInsets.all(TossSpacing.space5),
            decoration: const BoxDecoration(
              color: Colors.white,
              border: Border(
                top: BorderSide(color: TossColors.gray100, width: 1),
              ),
            ),
            child: SafeArea(
              child: ElevatedButton(
                onPressed: _canProceed 
                    ? (_isCreating ? null : _handleNext)
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: TossColors.primary,
                  foregroundColor: Colors.white,
                  disabledBackgroundColor: TossColors.gray200,
                  disabledForegroundColor: TossColors.gray400,
                  minimumSize: const Size(double.infinity, 56),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 0,
                ),
                child: _isCreating
                    ? const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            _nextButtonText,
                            style: TossTextStyles.labelLarge.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(width: TossSpacing.space2),
                          Icon(
                            _currentStep < 2 
                                ? Icons.arrow_forward
                                : Icons.check,
                            size: 20,
                            color: Colors.white,
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
}