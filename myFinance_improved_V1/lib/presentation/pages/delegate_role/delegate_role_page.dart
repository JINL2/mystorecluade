import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'providers/delegate_role_providers.dart';
import 'widgets/role_management_sheet.dart';
import '../../providers/app_state_provider.dart';
import '../../widgets/common/toss_scaffold.dart';
import '../../widgets/common/toss_app_bar.dart';
import '../../widgets/common/toss_loading_view.dart';
import '../../widgets/common/toss_error_view.dart';
import '../../widgets/common/toss_empty_view.dart';
import '../../widgets/toss/toss_primary_button.dart';
import '../../widgets/toss/toss_text_field.dart';
import '../../widgets/SB_widget/SB_searchbar_filter.dart';
import '../../widgets/SB_widget/SB_headline_group.dart';
import '../../../core/themes/toss_colors.dart';
import '../../../core/themes/toss_text_styles.dart';
import '../../../core/themes/toss_spacing.dart';
import '../../../core/themes/toss_border_radius.dart';
import '../../../core/themes/toss_shadows.dart';
import '../../../core/utils/tag_validator.dart';

class DelegateRolePage extends ConsumerStatefulWidget {
  const DelegateRolePage({super.key});

  @override
  ConsumerState<DelegateRolePage> createState() => _DelegateRolePageState();
}

class _DelegateRolePageState extends ConsumerState<DelegateRolePage> with WidgetsBindingObserver {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  String? _selectedFilter;
  String _selectedSort = 'name_asc';
  
  // Available tags from all roles
  Set<String> _availableTags = {};

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
              color: TossColors.textTertiary,
            ),
            title: 'No company selected',
            description: 'Please select a company to manage role delegations',
            action: TossPrimaryButton(
              text: 'Go to Home',
              onPressed: () => context.go('/'),
            ),
          ),
        ),
      );
    }

    return TossScaffold(
      key: _scaffoldKey,
      backgroundColor: TossColors.gray100,
      appBar: TossAppBar(
        title: 'Team Roles',
        primaryActionText: 'Add',
        onPrimaryAction: () => _showCreateRoleModal(context),
      ),
      body: RefreshIndicator(
        onRefresh: () => _handleRefresh(ref),
        color: TossColors.primary,
        child: allRolesAsync.when(
                  data: (roles) {
                    // Collect all available tags
                    _availableTags.clear();
                    for (final role in roles) {
                      final tags = role['tags'] as List<dynamic>? ?? [];
                      _availableTags.addAll(tags.map((tag) => tag.toString()));
                    }
                    
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
                                  color: TossColors.textTertiary,
                                ),
                              ),
                              SizedBox(height: TossSpacing.space6),
                              Text(
                                'No team roles yet',
                                style: TossTextStyles.h3.copyWith(
                                  color: TossColors.textPrimary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              SizedBox(height: TossSpacing.space2),
                              Text(
                                'Roles will appear here once they\'re created\nfor your company',
                                textAlign: TextAlign.center,
                                style: TossTextStyles.body.copyWith(
                                  color: TossColors.textSecondary,
                                  height: 1.5,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }
                    
                    // Filter roles based on search query and tag filter
                    var filteredRoles = roles.where((role) {
                      // Search filter
                      if (_searchQuery.isNotEmpty) {
                        final roleName = role['roleName'].toString().toLowerCase();
                        if (!roleName.contains(_searchQuery)) {
                          return false;
                        }
                      }
                      
                      // Tag filter
                      if (_selectedFilter != null) {
                        final tags = role['tags'] as List<dynamic>? ?? [];
                        final tagStrings = tags.map((tag) => tag.toString()).toList();
                        return tagStrings.contains(_selectedFilter);
                      }
                      
                      return true;
                    }).toList();
                    
                    // Sort roles based on selected sort option
                    filteredRoles.sort((a, b) {
                      switch (_selectedSort) {
                          case 'name_asc':
                            return a['roleName'].toString().compareTo(b['roleName'].toString());
                          case 'name_desc':
                            return b['roleName'].toString().compareTo(a['roleName'].toString());
                          case 'members_high':
                            return (b['memberCount'] ?? 0).compareTo(a['memberCount'] ?? 0);
                          case 'members_low':
                            return (a['memberCount'] ?? 0).compareTo(b['memberCount'] ?? 0);
                          case 'permissions_high':
                            return ((b['permissions'] as List).length).compareTo((a['permissions'] as List).length);
                          case 'permissions_low':
                            return ((a['permissions'] as List).length).compareTo((b['permissions'] as List).length);
                          default:
                            return 0;
                        }
                    });

                    return SingleChildScrollView(
                      padding: EdgeInsets.symmetric(horizontal: TossSpacing.space4),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: TossSpacing.space4),
                          
                          // Search Section
                          _buildSearchSection(),
                          
                          SizedBox(height: TossSpacing.space4),
                          
                          // Roles Section
                          _buildRolesSection(filteredRoles),
                          
                          SizedBox(height: TossSpacing.space4),
                        ],
                      ),
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

  Widget _buildSearchSection() {
    return SBSearchBarFilter(
      searchController: _searchController,
      searchHint: 'Search roles...',
      onSearchChanged: (value) {
        setState(() {
          _searchQuery = value.toLowerCase();
        });
      },
      onFilterTap: _showFilterOptions,
    );
  }

  Widget _buildRolesSection(List<dynamic> roles) {
    if (roles.isEmpty && _searchQuery.isNotEmpty) {
      return Container(
        padding: EdgeInsets.all(TossSpacing.space10),
        decoration: BoxDecoration(
          color: TossColors.surface,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(
          child: Column(
            children: [
              Icon(
                Icons.search_off,
                size: 48,
                color: TossColors.textTertiary,
              ),
              SizedBox(height: TossSpacing.space4),
              Text(
                'No roles found',
                style: TossTextStyles.h3.copyWith(
                  color: TossColors.textPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: TossSpacing.space2),
              Text(
                'Try a different search term',
                style: TossTextStyles.body.copyWith(
                  color: TossColors.textTertiary,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section Header - No background, separated from list
        SBHeadlineGroup(
          title: 'Team Roles',
        ),
        
        // Roles Container
        Container(
          padding: EdgeInsets.all(TossSpacing.space5),
          decoration: BoxDecoration(
            color: TossColors.surface,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Roles List
              ...roles.asMap().entries.map((entry) {
                final index = entry.key;
                final role = entry.value;
                
                return Column(
                  children: [
                    _buildRoleItem(role),
                    if (index < roles.length - 1) 
                      Container(
                        margin: EdgeInsets.symmetric(vertical: TossSpacing.space2),
                        height: 0.5,
                        color: TossColors.gray200,
                      ),
                  ],
                );
              }),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildRoleItem(Map<String, dynamic> role) {
    final memberCount = role['memberCount'] ?? 0;
    final permissionCount = (role['permissions'] as List).length;
    final roleName = role['roleName']?.toString() ?? '';
    final isOwnerRole = roleName.toLowerCase() == 'owner';
    final tags = role['tags'] as List<dynamic>? ?? [];
    
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: isOwnerRole ? null : () => _openRoleManagement(role),
        borderRadius: BorderRadius.circular(TossBorderRadius.lg),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: TossSpacing.space4),
          child: Row(
            children: [
              // Icon Container
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: memberCount > 0 
                      ? _getRoleColor(roleName).withValues(alpha: 0.1)
                      : TossColors.gray100,
                  borderRadius: BorderRadius.circular(28),
                ),
                child: Icon(
                  _getRoleIcon(roleName),
                  color: memberCount > 0 
                      ? _getRoleColor(roleName)
                      : TossColors.gray600,
                  size: 24,
                ),
              ),
              
              SizedBox(width: TossSpacing.space4),
              
              // Primary Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Role Name
                    Text(
                      roleName,
                      style: TossTextStyles.body.copyWith(
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                        color: Colors.black87,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    
                    SizedBox(height: TossSpacing.space1),
                    
                    // Tags or description
                    Row(
                      children: [
                        Expanded(
                          child: tags.isNotEmpty
                              ? Wrap(
                                  spacing: 4,
                                  runSpacing: 4,
                                  children: [
                                    ...tags.take(3).map((tag) => Container(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 6,
                                        vertical: 2,
                                      ),
                                      decoration: BoxDecoration(
                                        color: _getTagColor(tag.toString()).withValues(alpha: 0.1),
                                        borderRadius: BorderRadius.circular(4),
                                        border: Border.all(
                                          color: _getTagColor(tag.toString()).withValues(alpha: 0.3),
                                          width: 0.5,
                                        ),
                                      ),
                                      child: Text(
                                        tag.toString(),
                                        style: TextStyle(
                                          color: _getTagColor(tag.toString()),
                                          fontSize: 10,
                                          fontWeight: FontWeight.w600,
                                          height: 1.2,
                                        ),
                                      ),
                                    )).toList(),
                                    if (tags.length > 3)
                                      Container(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 6,
                                          vertical: 2,
                                        ),
                                        decoration: BoxDecoration(
                                          color: TossColors.gray100,
                                          borderRadius: BorderRadius.circular(4),
                                          border: Border.all(
                                            color: TossColors.gray300,
                                            width: 0.5,
                                          ),
                                        ),
                                        child: Text(
                                          '+${tags.length - 3}',
                                          style: TextStyle(
                                            color: TossColors.gray600,
                                            fontSize: 10,
                                            fontWeight: FontWeight.w600,
                                            height: 1.2,
                                          ),
                                        ),
                                      ),
                                  ],
                                )
                              : Text(
                                  _getRoleDescription(roleName),
                                  style: TossTextStyles.caption.copyWith(
                                    color: Colors.grey[600],
                                    fontSize: 13,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              
              // Stats Info
              Container(
                constraints: BoxConstraints(minWidth: 80),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Member Count
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Icon(
                          Icons.person_outline,
                          size: 16,
                          color: memberCount > 0 ? _getRoleColor(roleName) : Colors.grey[600],
                        ),
                        SizedBox(width: TossSpacing.space1),
                        Text(
                          '$memberCount',
                          style: TossTextStyles.body.copyWith(
                            color: memberCount > 0 ? _getRoleColor(roleName) : Colors.grey[600],
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                    
                    SizedBox(height: TossSpacing.space2),
                    
                    // Permission Count
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Icon(
                          Icons.shield_outlined,
                          size: 16,
                          color: Colors.grey[600],
                        ),
                        SizedBox(width: TossSpacing.space1),
                        Text(
                          '$permissionCount',
                          style: TossTextStyles.caption.copyWith(
                            color: Colors.grey[600],
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Tag colors mapping (same as in role management sheet)
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
  
  Color _getTagColor(String tag) {
    return _tagColors[tag] ?? TossColors.gray600;
  }



  Color _getRoleColor(String roleName) {
    switch (roleName.toLowerCase()) {
      case 'owner':
        return TossColors.primary;
      case 'admin':
        return TossColors.success;
      case 'manager':
      case 'store manager':
        return TossColors.warning;
      case 'employee':
        return TossColors.info;
      default:
        return TossColors.info; // Use info (blue) as default color for custom roles
    }
  }

  IconData _getRoleIcon(String roleName) {
    switch (roleName.toLowerCase()) {
      case 'owner':
        return Icons.star;
      case 'admin':
        return Icons.admin_panel_settings;
      case 'manager':
      case 'store manager':
        return Icons.manage_accounts;
      case 'employee':
        return Icons.person;
      default:
        return Icons.group;
    }
  }

  String _getRoleDescription(String roleName) {
    switch (roleName.toLowerCase()) {
      case 'owner':
        return 'Full system access & company management';
      case 'admin':
        return 'Custom role with specific permissions';
      case 'manager':
      case 'store manager':
        return 'Custom role with specific permissions';
      case 'employee':
        return 'Standard access for daily operations';
      default:
        return 'Custom role with specific permissions';
    }
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

  void _showFilterOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: TossColors.transparent,
      builder: (context) => Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.7,
        ),
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).padding.bottom,
        ),
        decoration: BoxDecoration(
          color: TossColors.surface,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(TossBorderRadius.xl),
            topRight: Radius.circular(TossBorderRadius.xl),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle
            Container(
              width: 48,
              height: 4,
              margin: EdgeInsets.only(top: TossSpacing.space3),
              decoration: BoxDecoration(
                color: TossColors.gray300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            
            // Title
            Container(
              padding: EdgeInsets.all(TossSpacing.space4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Filter by Tags',
                    style: TossTextStyles.h3.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  if (_selectedFilter != null)
                    TextButton(
                      onPressed: () {
                        setState(() {
                          _selectedFilter = null;
                        });
                        Navigator.pop(context);
                      },
                      child: Text(
                        'Clear',
                        style: TossTextStyles.body.copyWith(
                          color: TossColors.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                ],
              ),
            ),
            
            // Tags List
            if (_availableTags.isEmpty)
              Padding(
                padding: EdgeInsets.all(TossSpacing.space5),
                child: Text(
                  'No tags available',
                  style: TossTextStyles.body.copyWith(
                    color: TossColors.gray500,
                  ),
                ),
              )
            else
              Flexible(
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(horizontal: TossSpacing.space4),
                  child: Wrap(
                    spacing: TossSpacing.space2,
                    runSpacing: TossSpacing.space2,
                    children: _availableTags.map((tag) {
                      final isSelected = _selectedFilter == tag;
                      return Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              _selectedFilter = isSelected ? null : tag;
                            });
                            Navigator.pop(context);
                          },
                          borderRadius: BorderRadius.circular(TossBorderRadius.sm),
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: TossSpacing.space3,
                              vertical: TossSpacing.space2,
                            ),
                            decoration: BoxDecoration(
                              color: isSelected 
                                  ? _getTagColor(tag).withValues(alpha: 0.2)
                                  : TossColors.gray100,
                              borderRadius: BorderRadius.circular(TossBorderRadius.sm),
                              border: Border.all(
                                color: isSelected
                                    ? _getTagColor(tag)
                                    : TossColors.gray300,
                                width: isSelected ? 1.5 : 1,
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  tag,
                                  style: TossTextStyles.body.copyWith(
                                    color: isSelected
                                        ? _getTagColor(tag)
                                        : TossColors.gray700,
                                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                                  ),
                                ),
                                if (isSelected) ...[
                                  SizedBox(width: TossSpacing.space2),
                                  Icon(
                                    Icons.check,
                                    size: 16,
                                    color: _getTagColor(tag),
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
            
            SizedBox(height: TossSpacing.space4),
          ],
        ),
      ),
    );
  }

  void _showSortOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: TossColors.transparent,
      builder: (context) => Container(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).padding.bottom,
        ),
        decoration: BoxDecoration(
          color: TossColors.surface,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(TossBorderRadius.xl),
            topRight: Radius.circular(TossBorderRadius.xl),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle
            Container(
              width: 48,
              height: 4,
              margin: EdgeInsets.only(top: TossSpacing.space3),
              decoration: BoxDecoration(
                color: TossColors.gray300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            
            // Title
            Container(
              padding: EdgeInsets.all(TossSpacing.space4),
              child: Text(
                'Sort By',
                style: TossTextStyles.h3.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            
            // Sort Options
            _buildSortOption('Name (A-Z)', 'name_asc', Icons.sort_by_alpha),
            _buildSortOption('Name (Z-A)', 'name_desc', Icons.sort_by_alpha),
            _buildSortOption('Members (High to Low)', 'members_high', Icons.people),
            _buildSortOption('Members (Low to High)', 'members_low', Icons.people),
            _buildSortOption('Permissions (High to Low)', 'permissions_high', Icons.shield),
            _buildSortOption('Permissions (Low to High)', 'permissions_low', Icons.shield),
            
            SizedBox(height: TossSpacing.space4),
          ],
        ),
      ),
    );
  }

  Widget _buildSortOption(String label, String value, IconData icon) {
    final isSelected = _selectedSort == value;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          setState(() {
            _selectedSort = value;
          });
          Navigator.pop(context);
        },
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: TossSpacing.space4,
            vertical: TossSpacing.space3,
          ),
          child: Row(
            children: [
              Icon(
                icon,
                size: 20,
                color: TossColors.gray600,
              ),
              SizedBox(width: TossSpacing.space3),
              Text(
                label,
                style: TossTextStyles.body.copyWith(
                  color: TossColors.gray900,
                  fontWeight: FontWeight.w400,
                ),
              ),
              Spacer(),
              if (isSelected)
                Icon(
                  Icons.check_rounded,
                  color: TossColors.primary,
                  size: 20,
                ),
            ],
          ),
        ),
      ),
    );
  }


  void _openRoleManagement(Map<String, dynamic> role) {
    final roleName = role['roleName']?.toString().toLowerCase() ?? '';
    
    // For Owner role, disable editing like in role_permission page
    final bool canEditPermissions = roleName != 'owner';
    
    RoleManagementSheet.show(
      context,
      roleId: role['roleId'],
      roleName: role['roleName'],
      description: role['description'],
      tags: List<String>.from(role['tags'] ?? []),
      permissions: List<String>.from(role['permissions']),
      memberCount: role['memberCount'] ?? 0,
      canEdit: canEditPermissions, // Use local logic instead of database value
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

// Create Role Bottom Sheet (copied from role_permission_page.dart)
class _CreateRoleBottomSheet extends ConsumerStatefulWidget {
  @override
  ConsumerState<_CreateRoleBottomSheet> createState() => _CreateRoleBottomSheetState();
}

class _CreateRoleBottomSheetState extends ConsumerState<_CreateRoleBottomSheet> {
  final TextEditingController _roleNameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  bool _isCreating = false;
  int _currentStep = 0; // 0: Basic Info, 1: Permissions, 2: Tags
  final Set<String> _selectedPermissions = {};
  final Set<String> _expandedCategories = {};
  
  // Tags functionality
  final List<String> _selectedTags = [];
  
  // Predefined suggested tags following Toss design patterns
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
                          _getStepTitle(),
                          style: TossTextStyles.h3,
                        ),
                        SizedBox(height: TossSpacing.space1),
                        Text(
                          _getStepDescription(),
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
            ...[
              Container(
                padding: EdgeInsets.symmetric(horizontal: TossSpacing.space5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildStepIndicator(0, _currentStep == 0),
                    Container(
                      width: 30,
                      height: 2,
                      color: _currentStep >= 1 ? TossColors.primary.withOpacity(0.3) : TossColors.borderLight,
                    ),
                    _buildStepIndicator(1, _currentStep == 1),
                    Container(
                      width: 30,
                      height: 2,
                      color: _currentStep >= 2 ? TossColors.primary.withOpacity(0.3) : TossColors.borderLight,
                    ),
                    _buildStepIndicator(2, _currentStep == 2),
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
                child: _buildCurrentStep(),
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
                  onPressed: _isCreating ? null : _handleStepAction,
                  isLoading: _isCreating,
                  text: _getActionButtonText(),
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

  String _getStepTitle() {
    switch (_currentStep) {
      case 0:
        return 'Create New Role';
      case 1:
        return 'Configure Permissions';
      case 2:
        return 'Add Tags (Optional)';
      default:
        return '';
    }
  }

  String _getStepDescription() {
    switch (_currentStep) {
      case 0:
        return 'Define the role name and description';
      case 1:
        return 'Select what this role can access and do';
      case 2:
        return 'Add tags to help categorize and organize this role';
      default:
        return '';
    }
  }

  String _getActionButtonText() {
    switch (_currentStep) {
      case 0:
      case 1:
        return 'Next';
      case 2:
        return 'Create Role';
      default:
        return 'Next';
    }
  }

  void _handleStepAction() {
    switch (_currentStep) {
      case 0:
      case 1:
        _goToNextStep();
        break;
      case 2:
        _createRole();
        break;
    }
  }

  Widget _buildCurrentStep() {
    switch (_currentStep) {
      case 0:
        return _buildBasicInfoStep();
      case 1:
        return _buildPermissionsStep();
      case 2:
        return _buildTagsStep();
      default:
        return _buildBasicInfoStep();
    }
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
            style: TossTextStyles.h4.copyWith(
              fontWeight: FontWeight.w700,
              color: TossColors.gray900,
            ),
          ),
          SizedBox(height: TossSpacing.space3),
          TossTextField(
            controller: _roleNameController,
            hintText: 'Enter role name',
          ),
          
          SizedBox(height: TossSpacing.space6),
          
          // Description input
          Text(
            'Description',
            style: TossTextStyles.h4.copyWith(
              fontWeight: FontWeight.w700,
              color: TossColors.gray900,
            ),
          ),
          SizedBox(height: TossSpacing.space3),
          TossTextField(
            controller: _descriptionController,
            hintText: 'Describe what this role does',
            maxLines: 4,
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
          // Tags header
          Text(
            'Tags',
            style: TossTextStyles.h4.copyWith(
              fontWeight: FontWeight.w700,
              color: TossColors.gray900,
            ),
          ),
          SizedBox(height: TossSpacing.space2),
          Text(
            'Add up to 5 tags to help categorize this role',
            style: TossTextStyles.bodySmall.copyWith(
              color: TossColors.textSecondary,
            ),
          ),
          
          SizedBox(height: TossSpacing.space4),
          _buildTagsInput(),
        ],
      ),
    );
  }

  Widget _buildTagsInput() {
    // Get available suggestions (not yet selected)
    final availableSuggestions = _suggestedTags
        .where((tag) => !_selectedTags.contains(tag))
        .toList();
    
    // Tag limit is defined in TagValidator.MAX_TAGS
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Selected tags display
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
                        color: _selectedTags.length >= TagValidator.MAX_TAGS ? TossColors.primary : TossColors.textSecondary,
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
                color: _getTagColor(tag).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(TossBorderRadius.sm),
                border: Border.all(
                  color: _getTagColor(tag).withValues(alpha: 0.3),
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
                    onTap: () => _removeTag(tag),
                    borderRadius: BorderRadius.circular(TossBorderRadius.full),
                    child: Icon(
                      Icons.close,
                      size: TossSpacing.iconXS,
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
        
        // Suggested tags section (only show if limit not reached)
        if (_selectedTags.length < TagValidator.MAX_TAGS) ...[
          Text(
            'Suggested Tags',
            style: TossTextStyles.body.copyWith(
              color: TossColors.gray700,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: TossSpacing.space3),
          
          availableSuggestions.isEmpty
              ? Container(
                  padding: EdgeInsets.all(TossSpacing.space4),
                  decoration: BoxDecoration(
                    color: TossColors.gray50,
                    borderRadius: BorderRadius.circular(TossBorderRadius.md),
                    border: Border.all(
                      color: TossColors.gray200,
                      width: 1,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      'All suggested tags have been selected',
                      style: TossTextStyles.bodySmall.copyWith(
                        color: TossColors.textSecondary,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
                )
              : Wrap(
                  spacing: TossSpacing.space2,
                  runSpacing: TossSpacing.space2,
                  children: availableSuggestions
                      .map((tag) => Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () => _addTag(tag),
                    borderRadius: BorderRadius.circular(TossBorderRadius.sm),
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: TossSpacing.space3,
                        vertical: TossSpacing.space2,
                      ),
                      decoration: BoxDecoration(
                        color: TossColors.white,
                        borderRadius: BorderRadius.circular(TossBorderRadius.md),
                        border: Border.all(
                          color: TossColors.gray300,
                          width: 1.5,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.add,
                            size: TossSpacing.iconXS,
                            color: TossColors.primary,
                          ),
                          SizedBox(width: TossSpacing.space1),
                          Text(
                            tag,
                            style: TossTextStyles.caption.copyWith(
                              color: TossColors.gray700,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  )).toList(),
                ),
        ],
      ],
    );
  }

  Color _getTagColor(String tag) {
    return _tagColors[tag] ?? TossColors.gray600;
  }

  void _addTag(String tag) {
    // Validate tag before adding
    final validation = TagValidator.validateTag(tag);
    if (validation != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(validation),
          backgroundColor: TossColors.error,
        ),
      );
      return;
    }
    
    // Check if tag already exists (case-insensitive)
    final normalizedTag = tag.toLowerCase();
    final existingTag = _selectedTags.firstWhere(
      (existingTag) => existingTag.toLowerCase() == normalizedTag,
      orElse: () => '',
    );
    
    if (existingTag.isNotEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Tag "$tag" already added'),
          backgroundColor: TossColors.warning,
        ),
      );
      return;
    }
    
    // Check tag limit
    if (_selectedTags.length >= TagValidator.MAX_TAGS) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Maximum ${TagValidator.MAX_TAGS} tags allowed'),
          backgroundColor: TossColors.warning,
        ),
      );
      return;
    }
    
    setState(() {
      _selectedTags.add(tag);
    });
  }

  void _removeTag(String tag) {
    setState(() {
      _selectedTags.remove(tag);
    });
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
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () {
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
                      borderRadius: BorderRadius.circular(TossBorderRadius.sm),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: TossSpacing.space3,
                          vertical: TossSpacing.space2,
                        ),
                        child: Text(
                          _selectedPermissions.isEmpty ? 'Select All' : 'Clear All',
                          style: TossTextStyles.labelLarge.copyWith(
                            color: TossColors.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: TossSpacing.space4),
              
              // Permission categories
              ...categories.map((category) {
                final categoryName = category['category_name'] as String;
                final features = (category['features'] as List? ?? [])
                    .cast<Map<String, dynamic>>();
                
                if (features.isEmpty) return SizedBox.shrink();
                
                return _buildPermissionCategory(categoryName, features);
              }),
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
                            duration: const Duration(milliseconds: 200),
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
                      duration: const Duration(milliseconds: 200),
                      child: Icon(
                        Icons.expand_more,
                        color: TossColors.textTertiary,
                        size: TossSpacing.iconSM + 2,
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
                                  duration: const Duration(milliseconds: 200),
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
    if (_currentStep == 0) {
      // Validate role name before moving to permissions
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
    }

    // Move to next step (supports all 3 steps)
    setState(() {
      if (_currentStep < 2) {
        _currentStep++;
      }
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
        tags: _selectedTags.isNotEmpty ? _selectedTags : null,
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